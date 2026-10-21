CREATE OR REPLACE FUNCTION trg_completed_courses_view_sync()
RETURNS TRIGGER AS $func$
DECLARE
    target_tbl text;
    batch_prefix text;
    rec record;
BEGIN
    IF TG_OP = 'DELETE' THEN
        rec := OLD;
    ELSE
        rec := NEW;
    END IF;

    -- Determine target batch table from academic_year or university_id
    IF rec.academic_year IS NOT NULL AND rec.academic_year ~* 'y[0-9]{2}' THEN
        batch_prefix := lower(substring(rec.academic_year from '(?i)y[0-9]{2}'));
    ELSIF rec.university_id IS NOT NULL AND length(rec.university_id) >= 2 AND substring(rec.university_id from 1 for 2) ~ '^[0-9]{2}$' THEN
        batch_prefix := 'y' || substring(rec.university_id from 1 for 2);
    ELSE
        batch_prefix := 'y23';
    END IF;
    target_tbl := batch_prefix || '_students_courses';

    IF TG_OP = 'INSERT' THEN
        EXECUTE format('
            INSERT INTO %I (
                student_id, university_id, student_name, course_code, course_name,
                credits, grade, semester, ltps, bucket_group, course_type,
                academic_year, study_year, section_no, register_date, course_ref,
                offer_to, offer_by, branch, category, status, verified_by
            ) VALUES (
                $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22
            ) ON CONFLICT (university_id, course_code, semester, academic_year)
            DO UPDATE SET
                student_id = COALESCE(EXCLUDED.student_id, %I.student_id),
                student_name = COALESCE(EXCLUDED.student_name, %I.student_name),
                course_name = COALESCE(EXCLUDED.course_name, %I.course_name),
                credits = COALESCE(EXCLUDED.credits, %I.credits),
                grade = COALESCE(EXCLUDED.grade, %I.grade),
                ltps = EXCLUDED.ltps,
                bucket_group = COALESCE(EXCLUDED.bucket_group, %I.bucket_group),
                course_type = COALESCE(EXCLUDED.course_type, %I.course_type),
                study_year = COALESCE(EXCLUDED.study_year, %I.study_year),
                section_no = COALESCE(EXCLUDED.section_no, %I.section_no),
                register_date = COALESCE(EXCLUDED.register_date, %I.register_date),
                course_ref = COALESCE(EXCLUDED.course_ref, %I.course_ref),
                offer_to = COALESCE(EXCLUDED.offer_to, %I.offer_to),
                offer_by = COALESCE(EXCLUDED.offer_by, %I.offer_by),
                branch = COALESCE(EXCLUDED.branch, %I.branch),
                category = COALESCE(EXCLUDED.category, %I.category),
                status = COALESCE(EXCLUDED.status, %I.status),
                verified_by = COALESCE(EXCLUDED.verified_by, %I.verified_by),
                updated_at = NOW()
            RETURNING id
        ', target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl)
        USING NEW.student_id, NEW.university_id, NEW.student_name, NEW.course_code, NEW.course_name,
              COALESCE(NEW.credits, 0), NEW.grade, NEW.semester, NEW.ltps, NEW.bucket_group, NEW.course_type,
              NEW.academic_year, NEW.study_year, NEW.section_no, NEW.register_date, NEW.course_ref,
              NEW.offer_to, NEW.offer_by, NEW.branch, NEW.category, COALESCE(NEW.status, 'Completed'), NEW.verified_by
        INTO NEW.id;
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        EXECUTE format('
            UPDATE %I SET
                student_id = $1, student_name = $2, course_name = $3, credits = $4, grade = $5,
                semester = $6, ltps = $7, bucket_group = $8, course_type = $9,
                academic_year = $10, study_year = $11, section_no = $12,
                register_date = $13, course_ref = $14, offer_to = $15,
                offer_by = $16, branch = $17, category = $18, status = $19,
                verified_by = $20, updated_at = NOW()
            WHERE id = $21
        ', target_tbl)
        USING NEW.student_id, NEW.student_name, NEW.course_name, NEW.credits, NEW.grade,
              NEW.semester, NEW.ltps, NEW.bucket_group, NEW.course_type,
              NEW.academic_year, NEW.study_year, NEW.section_no,
              NEW.register_date, NEW.course_ref, NEW.offer_to,
              NEW.offer_by, NEW.branch, NEW.category, NEW.status,
              NEW.verified_by, OLD.id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE format('DELETE FROM %I WHERE id = $1', target_tbl) USING OLD.id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$func$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_completed_courses_view_rw ON completed_courses;
CREATE TRIGGER trg_completed_courses_view_rw
INSTEAD OF INSERT OR UPDATE OR DELETE ON completed_courses
FOR EACH ROW EXECUTE FUNCTION trg_completed_courses_view_sync();
