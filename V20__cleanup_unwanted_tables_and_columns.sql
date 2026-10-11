-- =====================================================================================
-- V20: Cleanup Unwanted Tables and Dead Columns in Supabase
-- KL University Academic Progress Tracking System
--
-- PURPOSE:
-- 1. Drops 8 legacy _deprecated_* tables that duplicate student_courses & curriculum data.
-- 2. Drops 8 obsolete scraping and temporary staging tables (y23_*_courses, y24_*_courses, guide allocations).
-- 3. Drops unused faculty_course_assignments table.
-- 4. Repoints all legacy foreign keys referencing the obsolete `users` table, and drops `users`.
-- 5. Drops 8 obsolete backward-compatibility views.
-- 6. Replaces completed_courses view with a unified, updatable view over student_courses
--    via INSTEAD OF triggers so legacy services seamlessly read & write to canonical student_courses.
-- 7. Drops unmapped 100% NULL columns (curriculum_courses.bucket_code, sub_bucket_code,
--    curriculum_course_mapping.sub_bucket_id, and unmapped student_degree_path addon/minor/major columns).
-- =====================================================================================

BEGIN;

-- -------------------------------------------------------------------------------------
-- 1. DROP OBSOLETE BACKWARD-COMPATIBILITY VIEWS
-- -------------------------------------------------------------------------------------
DROP VIEW IF EXISTS completed_courses CASCADE;
DROP VIEW IF EXISTS course_bucket_mapping CASCADE;
DROP VIEW IF EXISTS curriculum_buckets CASCADE;
DROP VIEW IF EXISTS program_requirements CASCADE;
DROP VIEW IF EXISTS requirements CASCADE;
DROP VIEW IF EXISTS student_cgpa_summary CASCADE;
DROP VIEW IF EXISTS student_selections CASCADE;
DROP VIEW IF EXISTS admin CASCADE;
DROP VIEW IF EXISTS student CASCADE;

-- -------------------------------------------------------------------------------------
-- 2. REMOVE LEGACY FOREIGN KEYS POINTING TO OBSOLETE 'users' TABLE
-- -------------------------------------------------------------------------------------
ALTER TABLE IF EXISTS audit_history DROP CONSTRAINT IF EXISTS fkdnwvkjybpuhnfydmidmjj4ni7;
ALTER TABLE IF EXISTS audit_history DROP CONSTRAINT IF EXISTS fkpu4py9ykhyupdnykianvabdyc;
ALTER TABLE IF EXISTS password_reset_tokens DROP CONSTRAINT IF EXISTS fkk3ndxg5xp6v7wd4gjyusp15gq;
ALTER TABLE IF EXISTS student_degree_path DROP CONSTRAINT IF EXISTS fkbhth53pkwi1hmkyr12mwwim7j;
ALTER TABLE IF EXISTS student_degree_path DROP CONSTRAINT IF EXISTS fkgxhgdtnw406ep16nla4h1jtnp;
ALTER TABLE IF EXISTS student_profiles DROP CONSTRAINT IF EXISTS fk32koy3tgqtaujxhfsn0b9pel2;
ALTER TABLE IF EXISTS upload_history DROP CONSTRAINT IF EXISTS fkgbr2is3gd9pcmcpg9w9nmq6bs;

-- -------------------------------------------------------------------------------------
-- 3. DROP OBSOLETE 'users' TABLE
-- -------------------------------------------------------------------------------------
DROP TABLE IF EXISTS users CASCADE;

-- -------------------------------------------------------------------------------------
-- 4. DROP ALL 8 DEPRECATED TABLES
-- -------------------------------------------------------------------------------------
DROP TABLE IF EXISTS _deprecated_completed_courses CASCADE;
DROP TABLE IF EXISTS _deprecated_course_bucket_mapping CASCADE;
DROP TABLE IF EXISTS _deprecated_curriculum_buckets CASCADE;
DROP TABLE IF EXISTS _deprecated_program_requirements CASCADE;
DROP TABLE IF EXISTS _deprecated_requirements CASCADE;
DROP TABLE IF EXISTS _deprecated_student_cgpa_summary CASCADE;
DROP TABLE IF EXISTS _deprecated_student_selections CASCADE;
DROP TABLE IF EXISTS _deprecated_y23_aids_studentdata CASCADE;

-- -------------------------------------------------------------------------------------
-- 5. DROP TEMPORARY SCRAPING, GUIDE ALLOCATION & UNUSED AD-HOC TABLES
-- -------------------------------------------------------------------------------------
DROP TABLE IF EXISTS y23_aids_courses CASCADE;
DROP TABLE IF EXISTS y23_cse_courses CASCADE;
DROP TABLE IF EXISTS y23_csit_courses CASCADE;
DROP TABLE IF EXISTS y24_aids_courses CASCADE;
DROP TABLE IF EXISTS y24_cse_courses CASCADE;
DROP TABLE IF EXISTS y24_csit_courses CASCADE;
DROP TABLE IF EXISTS y23_aids_crt_guide_allocation CASCADE;
DROP TABLE IF EXISTS y23_aids_noncrt_guide_allocation CASCADE;
DROP TABLE IF EXISTS faculty_course_assignments CASCADE;

-- -------------------------------------------------------------------------------------
-- 6. DROP UNMAPPED DEAD COLUMNS FROM ACTIVE PRODUCTION TABLES
-- -------------------------------------------------------------------------------------
-- 6.1 curriculum_courses: drop unmapped dead columns bucket_code and sub_bucket_code
ALTER TABLE IF EXISTS curriculum_courses DROP COLUMN IF EXISTS bucket_code;
ALTER TABLE IF EXISTS curriculum_courses DROP COLUMN IF EXISTS sub_bucket_code;

-- 6.2 curriculum_course_mapping: drop unmapped dead foreign key and column sub_bucket_id
ALTER TABLE IF EXISTS curriculum_course_mapping DROP CONSTRAINT IF EXISTS curriculum_course_mapping_sub_bucket_id_fkey;
ALTER TABLE IF EXISTS curriculum_course_mapping DROP COLUMN IF EXISTS sub_bucket_id;

-- 6.3 student_degree_path: drop unmapped dead foreign keys and columns
ALTER TABLE IF EXISTS student_degree_path DROP CONSTRAINT IF EXISTS student_degree_path_second_major_id_fkey;
ALTER TABLE IF EXISTS student_degree_path DROP CONSTRAINT IF EXISTS student_degree_path_minor_id_fkey;
ALTER TABLE IF EXISTS student_degree_path DROP CONSTRAINT IF EXISTS student_degree_path_specialization_id_fkey;
ALTER TABLE IF EXISTS student_degree_path DROP COLUMN IF EXISTS specialization_id;
ALTER TABLE IF EXISTS student_degree_path DROP COLUMN IF EXISTS minor_id;
ALTER TABLE IF EXISTS student_degree_path DROP COLUMN IF EXISTS second_major_id;
ALTER TABLE IF EXISTS student_degree_path DROP COLUMN IF EXISTS addon_type;
ALTER TABLE IF EXISTS student_degree_path DROP COLUMN IF EXISTS updated_at;

-- -------------------------------------------------------------------------------------
-- 7. RECREATE UNIFIED READ/WRITE COMPATIBILITY VIEW OVER student_courses
-- -------------------------------------------------------------------------------------
CREATE VIEW completed_courses AS
SELECT 
    sc.id,
    sc.student_id,
    sc.course_code,
    sc.course_name,
    sc.credits::INTEGER AS credits,
    sc.grade,
    sc.semester,
    sc.completed_date,
    NULL::BIGINT AS verified_by,
    sc.created_at::TIMESTAMP WITHOUT TIME ZONE AS created_at,
    NULL::VARCHAR(50) AS ltps,
    NULL::VARCHAR(50) AS bucket_group,
    NULL::VARCHAR(50) AS course_type,
    sc.academic_year,
    NULL::INTEGER AS study_year,
    NULL::VARCHAR(50) AS section_no,
    NULL::VARCHAR(50) AS offer_to,
    NULL::VARCHAR(50) AS offer_by,
    NULL::VARCHAR(50) AS branch,
    NULL::DATE AS register_date,
    NULL::VARCHAR(50) AS course_ref,
    NULL::VARCHAR(50) AS category,
    sc.status,
    sc.university_id,
    NULL::VARCHAR(150) AS student_name
FROM student_courses sc;

CREATE OR REPLACE FUNCTION trg_completed_courses_sync()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO student_courses (
            student_id, course_code, course_name, credits, grade, semester,
            academic_year, completed_date, status, university_id, created_at
        ) VALUES (
            NEW.student_id, NEW.course_code, NEW.course_name, COALESCE(NEW.credits, 0),
            NEW.grade, NEW.semester, NEW.academic_year, NEW.completed_date,
            COALESCE(NEW.status, 'COMPLETED'), NEW.university_id, COALESCE(NEW.created_at, NOW())
        ) RETURNING id INTO NEW.id;
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE student_courses
        SET course_code = NEW.course_code,
            course_name = NEW.course_name,
            credits = COALESCE(NEW.credits, credits),
            grade = NEW.grade,
            semester = NEW.semester,
            academic_year = NEW.academic_year,
            completed_date = NEW.completed_date,
            status = COALESCE(NEW.status, status),
            university_id = NEW.university_id
        WHERE id = OLD.id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM student_courses WHERE id = OLD.id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_completed_courses_rw
INSTEAD OF INSERT OR UPDATE OR DELETE ON completed_courses
FOR EACH ROW EXECUTE FUNCTION trg_completed_courses_sync();

COMMIT;
