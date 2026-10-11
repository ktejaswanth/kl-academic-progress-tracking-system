-- ============================================================
-- V13: Schema Redesign — Clean Architecture
-- KL University Academic Progress Tracking System
--
-- This migration:
--   1. Creates sub_bucket_master (sub-bucket support)
--   2. Creates 6 dedicated curriculum course tables (Y23/Y24 × CSE/AIDS/CSIT)
--   3. Creates path_sub_bucket_requirements
--   4. Enhances student_degree_path (absorbs student_selections)
--   5. Migrates completed_courses → student_courses
--   6. Cleans up and retires obsolete tables
--
-- PREREQUISITES: Run against a backed-up database.
-- ============================================================

BEGIN;

-- ============================================================
-- PHASE 1: NEW TABLES
-- ============================================================

-- 1.1 SUB-BUCKET MASTER
CREATE TABLE IF NOT EXISTS sub_bucket_master (
    id              BIGSERIAL PRIMARY KEY,
    sub_bucket_code VARCHAR(30) UNIQUE NOT NULL,
    sub_bucket_name VARCHAR(200) NOT NULL,
    bucket_id       BIGINT NOT NULL REFERENCES bucket_master(id) ON DELETE CASCADE,
    description     TEXT,
    display_order   INT DEFAULT 0,
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sub_bucket_parent ON sub_bucket_master(bucket_id);

-- 1.2 PATH SUB-BUCKET REQUIREMENTS
CREATE TABLE IF NOT EXISTS path_sub_bucket_requirements (
    id                  BIGSERIAL PRIMARY KEY,
    degree_path_id      BIGINT NOT NULL REFERENCES degree_paths(id) ON DELETE CASCADE,
    bucket_id           BIGINT NOT NULL REFERENCES bucket_master(id),
    sub_bucket_id       BIGINT NOT NULL REFERENCES sub_bucket_master(id),
    target_credits      NUMERIC(5,2) NOT NULL DEFAULT 0,
    min_credits         NUMERIC(5,2),
    max_credits         NUMERIC(5,2),
    min_courses         INT,
    max_courses         INT,
    is_mandatory        BOOLEAN DEFAULT true,
    rules_json          JSONB,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(degree_path_id, sub_bucket_id)
);

CREATE INDEX IF NOT EXISTS idx_psbr_path ON path_sub_bucket_requirements(degree_path_id);
CREATE INDEX IF NOT EXISTS idx_psbr_bucket ON path_sub_bucket_requirements(bucket_id);
CREATE INDEX IF NOT EXISTS idx_psbr_sub_bucket ON path_sub_bucket_requirements(sub_bucket_id);

-- 1.3 ENSURE Y24 REGULATION EXISTS
INSERT INTO regulation_master (reg_code, reg_name, effective_year)
VALUES ('Y24', 'Year 2024 Regulation', 2024)
ON CONFLICT (reg_code) DO NOTHING;

-- 1.4 ENSURE CSIT DEPARTMENT EXISTS
INSERT INTO department_master (dept_code, dept_name)
VALUES ('CSIT', 'Computer Science and Information Technology')
ON CONFLICT (dept_code) DO NOTHING;

-- 1.5 CREATE CURRICULUM VERSIONS FOR ALL 6 COMBINATIONS
INSERT INTO curriculum_versions (curriculum_code, version_name, program_name, department_id, regulation_id, status, academic_year)
SELECT 'Y23-CSE', 'Y23 B.Tech. CSE Curriculum', 'B.Tech Computer Science and Engineering',
       d.id, r.id, 'ACTIVE', '2023-2024'
FROM department_master d, regulation_master r
WHERE d.dept_code = 'CSE' AND r.reg_code = 'Y23'
  AND NOT EXISTS (SELECT 1 FROM curriculum_versions WHERE curriculum_code = 'Y23-CSE');

INSERT INTO curriculum_versions (curriculum_code, version_name, program_name, department_id, regulation_id, status, academic_year)
SELECT 'Y23-AIDS', 'Y23 B.Tech. AIDS Curriculum', 'B.Tech Artificial Intelligence and Data Science',
       d.id, r.id, 'ACTIVE', '2023-2024'
FROM department_master d, regulation_master r
WHERE d.dept_code = 'AIDS' AND r.reg_code = 'Y23'
  AND NOT EXISTS (SELECT 1 FROM curriculum_versions WHERE curriculum_code = 'Y23-AIDS');

INSERT INTO curriculum_versions (curriculum_code, version_name, program_name, department_id, regulation_id, status, academic_year)
SELECT 'Y23-CSIT', 'Y23 B.Tech. CSIT Curriculum', 'B.Tech Computer Science and Information Technology',
       d.id, r.id, 'ACTIVE', '2023-2024'
FROM department_master d, regulation_master r
WHERE d.dept_code = 'CSIT' AND r.reg_code = 'Y23'
  AND NOT EXISTS (SELECT 1 FROM curriculum_versions WHERE curriculum_code = 'Y23-CSIT');

INSERT INTO curriculum_versions (curriculum_code, version_name, program_name, department_id, regulation_id, status, academic_year)
SELECT 'Y24-CSE', 'Y24 B.Tech. CSE Curriculum', 'B.Tech Computer Science and Engineering',
       d.id, r.id, 'ACTIVE', '2024-2025'
FROM department_master d, regulation_master r
WHERE d.dept_code = 'CSE' AND r.reg_code = 'Y24'
  AND NOT EXISTS (SELECT 1 FROM curriculum_versions WHERE curriculum_code = 'Y24-CSE');

INSERT INTO curriculum_versions (curriculum_code, version_name, program_name, department_id, regulation_id, status, academic_year)
SELECT 'Y24-AIDS', 'Y24 B.Tech. AIDS Curriculum', 'B.Tech Artificial Intelligence and Data Science',
       d.id, r.id, 'ACTIVE', '2024-2025'
FROM department_master d, regulation_master r
WHERE d.dept_code = 'AIDS' AND r.reg_code = 'Y24'
  AND NOT EXISTS (SELECT 1 FROM curriculum_versions WHERE curriculum_code = 'Y24-AIDS');

INSERT INTO curriculum_versions (curriculum_code, version_name, program_name, department_id, regulation_id, status, academic_year)
SELECT 'Y24-CSIT', 'Y24 B.Tech. CSIT Curriculum', 'B.Tech Computer Science and Information Technology',
       d.id, r.id, 'ACTIVE', '2024-2025'
FROM department_master d, regulation_master r
WHERE d.dept_code = 'CSIT' AND r.reg_code = 'Y24'
  AND NOT EXISTS (SELECT 1 FROM curriculum_versions WHERE curriculum_code = 'Y24-CSIT');


-- ============================================================
-- PHASE 2: SIX DEDICATED CURRICULUM COURSE TABLES
-- ============================================================
-- All 6 share identical structure with GENERATED credits column.
-- Formula: Credits = L + T + (0.5 * P) + (0.25 * S)

-- ---- Y23 CSE ----
CREATE TABLE IF NOT EXISTS y23_cse_courses (
    id                  BIGSERIAL PRIMARY KEY,
    course_code         VARCHAR(20) NOT NULL,
    course_name         VARCHAR(255) NOT NULL,
    lecture_hours       INT NOT NULL DEFAULT 0 CHECK (lecture_hours >= 0),
    tutorial_hours      INT NOT NULL DEFAULT 0 CHECK (tutorial_hours >= 0),
    practical_hours     INT NOT NULL DEFAULT 0 CHECK (practical_hours >= 0),
    skill_hours         INT NOT NULL DEFAULT 0 CHECK (skill_hours >= 0),
    calculated_credits  NUMERIC(5,2) GENERATED ALWAYS AS (
        lecture_hours + tutorial_hours + (0.5 * practical_hours) + (0.25 * skill_hours)
    ) STORED,
    semester            VARCHAR(10),
    study_year          INT CHECK (study_year BETWEEN 1 AND 4),
    bucket_code         VARCHAR(30),
    sub_bucket_code     VARCHAR(30),
    prerequisite        VARCHAR(255),
    is_mandatory        BOOLEAN DEFAULT false,
    course_type         VARCHAR(50),
    source              VARCHAR(50) DEFAULT 'MANUAL',
    is_active           BOOLEAN DEFAULT true,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(course_code)
);

-- ---- Y23 AIDS ----
CREATE TABLE IF NOT EXISTS y23_aids_courses (
    id                  BIGSERIAL PRIMARY KEY,
    course_code         VARCHAR(20) NOT NULL,
    course_name         VARCHAR(255) NOT NULL,
    lecture_hours       INT NOT NULL DEFAULT 0 CHECK (lecture_hours >= 0),
    tutorial_hours      INT NOT NULL DEFAULT 0 CHECK (tutorial_hours >= 0),
    practical_hours     INT NOT NULL DEFAULT 0 CHECK (practical_hours >= 0),
    skill_hours         INT NOT NULL DEFAULT 0 CHECK (skill_hours >= 0),
    calculated_credits  NUMERIC(5,2) GENERATED ALWAYS AS (
        lecture_hours + tutorial_hours + (0.5 * practical_hours) + (0.25 * skill_hours)
    ) STORED,
    semester            VARCHAR(10),
    study_year          INT CHECK (study_year BETWEEN 1 AND 4),
    bucket_code         VARCHAR(30),
    sub_bucket_code     VARCHAR(30),
    prerequisite        VARCHAR(255),
    is_mandatory        BOOLEAN DEFAULT false,
    course_type         VARCHAR(50),
    source              VARCHAR(50) DEFAULT 'MANUAL',
    is_active           BOOLEAN DEFAULT true,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(course_code)
);

-- ---- Y23 CSIT ----
CREATE TABLE IF NOT EXISTS y23_csit_courses (
    id                  BIGSERIAL PRIMARY KEY,
    course_code         VARCHAR(20) NOT NULL,
    course_name         VARCHAR(255) NOT NULL,
    lecture_hours       INT NOT NULL DEFAULT 0 CHECK (lecture_hours >= 0),
    tutorial_hours      INT NOT NULL DEFAULT 0 CHECK (tutorial_hours >= 0),
    practical_hours     INT NOT NULL DEFAULT 0 CHECK (practical_hours >= 0),
    skill_hours         INT NOT NULL DEFAULT 0 CHECK (skill_hours >= 0),
    calculated_credits  NUMERIC(5,2) GENERATED ALWAYS AS (
        lecture_hours + tutorial_hours + (0.5 * practical_hours) + (0.25 * skill_hours)
    ) STORED,
    semester            VARCHAR(10),
    study_year          INT CHECK (study_year BETWEEN 1 AND 4),
    bucket_code         VARCHAR(30),
    sub_bucket_code     VARCHAR(30),
    prerequisite        VARCHAR(255),
    is_mandatory        BOOLEAN DEFAULT false,
    course_type         VARCHAR(50),
    source              VARCHAR(50) DEFAULT 'MANUAL',
    is_active           BOOLEAN DEFAULT true,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(course_code)
);

-- ---- Y24 CSE ----
CREATE TABLE IF NOT EXISTS y24_cse_courses (
    id                  BIGSERIAL PRIMARY KEY,
    course_code         VARCHAR(20) NOT NULL,
    course_name         VARCHAR(255) NOT NULL,
    lecture_hours       INT NOT NULL DEFAULT 0 CHECK (lecture_hours >= 0),
    tutorial_hours      INT NOT NULL DEFAULT 0 CHECK (tutorial_hours >= 0),
    practical_hours     INT NOT NULL DEFAULT 0 CHECK (practical_hours >= 0),
    skill_hours         INT NOT NULL DEFAULT 0 CHECK (skill_hours >= 0),
    calculated_credits  NUMERIC(5,2) GENERATED ALWAYS AS (
        lecture_hours + tutorial_hours + (0.5 * practical_hours) + (0.25 * skill_hours)
    ) STORED,
    semester            VARCHAR(10),
    study_year          INT CHECK (study_year BETWEEN 1 AND 4),
    bucket_code         VARCHAR(30),
    sub_bucket_code     VARCHAR(30),
    prerequisite        VARCHAR(255),
    is_mandatory        BOOLEAN DEFAULT false,
    course_type         VARCHAR(50),
    source              VARCHAR(50) DEFAULT 'MANUAL',
    is_active           BOOLEAN DEFAULT true,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(course_code)
);

-- ---- Y24 AIDS ----
CREATE TABLE IF NOT EXISTS y24_aids_courses (
    id                  BIGSERIAL PRIMARY KEY,
    course_code         VARCHAR(20) NOT NULL,
    course_name         VARCHAR(255) NOT NULL,
    lecture_hours       INT NOT NULL DEFAULT 0 CHECK (lecture_hours >= 0),
    tutorial_hours      INT NOT NULL DEFAULT 0 CHECK (tutorial_hours >= 0),
    practical_hours     INT NOT NULL DEFAULT 0 CHECK (practical_hours >= 0),
    skill_hours         INT NOT NULL DEFAULT 0 CHECK (skill_hours >= 0),
    calculated_credits  NUMERIC(5,2) GENERATED ALWAYS AS (
        lecture_hours + tutorial_hours + (0.5 * practical_hours) + (0.25 * skill_hours)
    ) STORED,
    semester            VARCHAR(10),
    study_year          INT CHECK (study_year BETWEEN 1 AND 4),
    bucket_code         VARCHAR(30),
    sub_bucket_code     VARCHAR(30),
    prerequisite        VARCHAR(255),
    is_mandatory        BOOLEAN DEFAULT false,
    course_type         VARCHAR(50),
    source              VARCHAR(50) DEFAULT 'MANUAL',
    is_active           BOOLEAN DEFAULT true,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(course_code)
);

-- ---- Y24 CSIT ----
CREATE TABLE IF NOT EXISTS y24_csit_courses (
    id                  BIGSERIAL PRIMARY KEY,
    course_code         VARCHAR(20) NOT NULL,
    course_name         VARCHAR(255) NOT NULL,
    lecture_hours       INT NOT NULL DEFAULT 0 CHECK (lecture_hours >= 0),
    tutorial_hours      INT NOT NULL DEFAULT 0 CHECK (tutorial_hours >= 0),
    practical_hours     INT NOT NULL DEFAULT 0 CHECK (practical_hours >= 0),
    skill_hours         INT NOT NULL DEFAULT 0 CHECK (skill_hours >= 0),
    calculated_credits  NUMERIC(5,2) GENERATED ALWAYS AS (
        lecture_hours + tutorial_hours + (0.5 * practical_hours) + (0.25 * skill_hours)
    ) STORED,
    semester            VARCHAR(10),
    study_year          INT CHECK (study_year BETWEEN 1 AND 4),
    bucket_code         VARCHAR(30),
    sub_bucket_code     VARCHAR(30),
    prerequisite        VARCHAR(255),
    is_mandatory        BOOLEAN DEFAULT false,
    course_type         VARCHAR(50),
    source              VARCHAR(50) DEFAULT 'MANUAL',
    is_active           BOOLEAN DEFAULT true,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(course_code)
);


-- ============================================================
-- PHASE 3: ENHANCE EXISTING TABLES
-- ============================================================

-- 3.1 Add sub_bucket_id to curriculum_course_mapping
ALTER TABLE curriculum_course_mapping
    ADD COLUMN IF NOT EXISTS sub_bucket_id BIGINT REFERENCES sub_bucket_master(id);
CREATE INDEX IF NOT EXISTS idx_ccm_sub_bucket ON curriculum_course_mapping(sub_bucket_id);

-- 3.2 Enhance path_bucket_requirements with NUMERIC credits
ALTER TABLE path_bucket_requirements
    ALTER COLUMN required_credits TYPE NUMERIC(5,2) USING required_credits::NUMERIC(5,2);
ALTER TABLE path_bucket_requirements
    ALTER COLUMN min_credits TYPE NUMERIC(5,2) USING min_credits::NUMERIC(5,2);
ALTER TABLE path_bucket_requirements
    ALTER COLUMN max_credits TYPE NUMERIC(5,2) USING max_credits::NUMERIC(5,2);

-- 3.3 Add sub-bucket tracking to student_bucket_progress
ALTER TABLE student_bucket_progress
    ADD COLUMN IF NOT EXISTS sub_bucket_id BIGINT REFERENCES sub_bucket_master(id);
ALTER TABLE student_bucket_progress
    ALTER COLUMN earned_credits TYPE NUMERIC(5,2) USING earned_credits::NUMERIC(5,2);
ALTER TABLE student_bucket_progress
    ALTER COLUMN required_credits TYPE NUMERIC(5,2) USING required_credits::NUMERIC(5,2);

-- 3.4 Enhance curriculum_courses
ALTER TABLE curriculum_courses
    ALTER COLUMN credits TYPE NUMERIC(5,2) USING credits::NUMERIC(5,2);
ALTER TABLE curriculum_courses
    ADD COLUMN IF NOT EXISTS sub_bucket_code VARCHAR(30);
ALTER TABLE curriculum_courses
    ADD COLUMN IF NOT EXISTS bucket_code VARCHAR(30);

-- 3.5 Enhance student_degree_path to absorb student_selections
ALTER TABLE student_degree_path
    ADD COLUMN IF NOT EXISTS specialization_id BIGINT REFERENCES specializations(id);
ALTER TABLE student_degree_path
    ADD COLUMN IF NOT EXISTS minor_id BIGINT REFERENCES minor_programs(id);
ALTER TABLE student_degree_path
    ADD COLUMN IF NOT EXISTS second_major_id BIGINT REFERENCES second_major_programs(id);
ALTER TABLE student_degree_path
    ADD COLUMN IF NOT EXISTS addon_type VARCHAR(30);
ALTER TABLE student_degree_path
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- 3.6 Enhance student_courses with NUMERIC credits
ALTER TABLE student_courses
    ALTER COLUMN credits TYPE NUMERIC(5,2) USING credits::NUMERIC(5,2);

-- 3.7 Enhance student_degree_status
ALTER TABLE student_degree_status
    ALTER COLUMN total_required_credits TYPE NUMERIC(7,2) USING total_required_credits::NUMERIC(7,2);
ALTER TABLE student_degree_status
    ALTER COLUMN total_earned_credits TYPE NUMERIC(7,2) USING total_earned_credits::NUMERIC(7,2);


-- ============================================================
-- PHASE 4: DATA MIGRATION
-- ============================================================

-- 4.0 Drop legacy foreign keys pointing student_id to users table
ALTER TABLE IF EXISTS student_courses DROP CONSTRAINT IF EXISTS fk4celjueb4wixygpkjagooyeok;
ALTER TABLE IF EXISTS student_course_attempts DROP CONSTRAINT IF EXISTS fke9ubc2kyvv8ie8klun4mvryfd;
ALTER TABLE IF EXISTS student_selections DROP CONSTRAINT IF EXISTS fkqm7nsiaexp5y13t4bmd6fgsho;
ALTER TABLE IF EXISTS eligibility_results DROP CONSTRAINT IF EXISTS fkswbqxxe14nn150r2vkeny83ho;
ALTER TABLE IF EXISTS student_issues DROP CONSTRAINT IF EXISTS fkb7aw4ubsja03rc8xlly2uguwf;
ALTER TABLE IF EXISTS audit_history DROP CONSTRAINT IF EXISTS fkpu4py9ykhyupdnykianvabdyc;

-- Ensure student_courses foreign key points to students table
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'student_courses') THEN
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.table_constraints
            WHERE constraint_name = 'fk_student_courses_student'
              AND table_name = 'student_courses'
        ) THEN
            ALTER TABLE student_courses
                ADD CONSTRAINT fk_student_courses_student
                FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
        END IF;
    END IF;
END $$;

-- 4.1 Migrate completed_courses → student_courses (if completed_courses exists)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'completed_courses') THEN
        INSERT INTO student_courses (
            student_id, course_code, course_name, credits, grade, semester,
            academic_year, status, university_id, created_at
        )
        SELECT
            cc.student_id, cc.course_code, cc.course_name,
            COALESCE(cc.credits, 0)::NUMERIC(5,2), cc.grade, cc.semester,
            cc.academic_year, COALESCE(cc.status, 'COMPLETED'),
            cc.university_id, COALESCE(cc.created_at, NOW())
        FROM completed_courses cc
        WHERE NOT EXISTS (
            SELECT 1 FROM student_courses sc
            WHERE sc.student_id = cc.student_id
              AND sc.course_code = cc.course_code
              AND COALESCE(sc.semester, '') = COALESCE(cc.semester, '')
        );
    END IF;
END $$;

-- 4.2 Migrate student_selections → student_degree_path (if student_selections exists)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'student_selections') THEN
        UPDATE student_degree_path sdp
        SET specialization_id = ss.specialization_id,
            addon_type = ss.extension_type,
            updated_at = NOW()
        FROM student_selections ss
        WHERE sdp.student_id = ss.student_id
          AND ss.specialization_id IS NOT NULL
          AND sdp.specialization_id IS NULL;
    END IF;
END $$;


-- ============================================================
-- PHASE 5: SEED SUB-BUCKET MASTER DATA
-- ============================================================

INSERT INTO sub_bucket_master (sub_bucket_code, sub_bucket_name, bucket_id, description, display_order) VALUES
    ('PCC-THEORY', 'PCC Theory Courses',    (SELECT id FROM bucket_master WHERE bucket_code = 'PCC-CORE'), 'Core theory courses', 1),
    ('PCC-LAB',    'PCC Lab Courses',        (SELECT id FROM bucket_master WHERE bucket_code = 'PCC-CORE'), 'Core lab courses', 2),
    ('PCC-ELEC',   'PCC Elective Courses',   (SELECT id FROM bucket_master WHERE bucket_code = 'PCC-CORE'), 'Elective courses within professional core', 3),
    ('BSC-MATH',   'Mathematics Core',       (SELECT id FROM bucket_master WHERE bucket_code = 'BSC-CORE'), 'Core mathematics', 1),
    ('BSC-PHY',    'Physics/Chemistry Core', (SELECT id FROM bucket_master WHERE bucket_code = 'BSC-CORE'), 'Core science', 2),
    ('ESC-THEORY', 'Engineering Theory',     (SELECT id FROM bucket_master WHERE bucket_code = 'ESC-CORE'), 'Engineering theory', 1),
    ('ESC-LAB',    'Engineering Lab',        (SELECT id FROM bucket_master WHERE bucket_code = 'ESC-CORE'), 'Engineering lab', 2),
    ('HAS-THEORY', 'HAS Theory',            (SELECT id FROM bucket_master WHERE bucket_code = 'HAS-CORE'), 'Humanities theory', 1),
    ('HAS-COMM',   'Communication Skills',   (SELECT id FROM bucket_master WHERE bucket_code = 'HAS-CORE'), 'Communication courses', 2),
    ('PRI-PROJECT','Major Project',          (SELECT id FROM bucket_master WHERE bucket_code = 'PRI-CORE'), 'Capstone project', 1),
    ('PRI-INTERN', 'Internship',            (SELECT id FROM bucket_master WHERE bucket_code = 'PRI-CORE'), 'Industry internship', 2),
    ('PRI-RESEARCH','Research Component',    (SELECT id FROM bucket_master WHERE bucket_code = 'PRI-CORE'), 'Research thesis', 3)
ON CONFLICT (sub_bucket_code) DO NOTHING;


-- ============================================================
-- PHASE 6: RETIRE OBSOLETE TABLES (safe rename)
-- ============================================================

ALTER TABLE IF EXISTS completed_courses RENAME TO _deprecated_completed_courses;
ALTER TABLE IF EXISTS requirements RENAME TO _deprecated_requirements;
ALTER TABLE IF EXISTS program_requirements RENAME TO _deprecated_program_requirements;
ALTER TABLE IF EXISTS student_selections RENAME TO _deprecated_student_selections;
ALTER TABLE IF EXISTS student_cgpa_summary RENAME TO _deprecated_student_cgpa_summary;
ALTER TABLE IF EXISTS course_bucket_mapping RENAME TO _deprecated_course_bucket_mapping;
ALTER TABLE IF EXISTS curriculum_buckets RENAME TO _deprecated_curriculum_buckets;
ALTER TABLE IF EXISTS y23_aids_studentdata RENAME TO _deprecated_y23_aids_studentdata;


-- ============================================================
-- PHASE 7: INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_y23_cse_bucket ON y23_cse_courses(bucket_code);
CREATE INDEX IF NOT EXISTS idx_y23_aids_bucket ON y23_aids_courses(bucket_code);
CREATE INDEX IF NOT EXISTS idx_y23_csit_bucket ON y23_csit_courses(bucket_code);
CREATE INDEX IF NOT EXISTS idx_y24_cse_bucket ON y24_cse_courses(bucket_code);
CREATE INDEX IF NOT EXISTS idx_y24_aids_bucket ON y24_aids_courses(bucket_code);
CREATE INDEX IF NOT EXISTS idx_y24_csit_bucket ON y24_csit_courses(bucket_code);

CREATE INDEX IF NOT EXISTS idx_y23_cse_semester ON y23_cse_courses(semester);
CREATE INDEX IF NOT EXISTS idx_y23_aids_semester ON y23_aids_courses(semester);
CREATE INDEX IF NOT EXISTS idx_y23_csit_semester ON y23_csit_courses(semester);
CREATE INDEX IF NOT EXISTS idx_y24_cse_semester ON y24_cse_courses(semester);
CREATE INDEX IF NOT EXISTS idx_y24_aids_semester ON y24_aids_courses(semester);
CREATE INDEX IF NOT EXISTS idx_y24_csit_semester ON y24_csit_courses(semester);

CREATE INDEX IF NOT EXISTS idx_sbp_sub_bucket ON student_bucket_progress(sub_bucket_id);
CREATE INDEX IF NOT EXISTS idx_sc_status ON student_courses(status);
CREATE INDEX IF NOT EXISTS idx_sc_student_status ON student_courses(student_id, status);

COMMIT;
