-- ============================================================
-- V11: Completed Courses Mapping & Long File Batch Support
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. ADD UNIVERSITY_ID AND STUDENT_NAME TO COMPLETED_COURSES
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS university_id VARCHAR(100);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS student_name VARCHAR(255);
ALTER TABLE completed_courses ALTER COLUMN credits DROP NOT NULL;
ALTER TABLE completed_courses ALTER COLUMN credits SET DEFAULT 0;

-- 2. CREATE INDEXES FOR RAPID SEARCH AND BULK PROCESSING
CREATE INDEX IF NOT EXISTS idx_completed_courses_univ_id ON completed_courses(university_id);
CREATE INDEX IF NOT EXISTS idx_completed_courses_code ON completed_courses(course_code);
CREATE INDEX IF NOT EXISTS idx_completed_courses_sem_acad ON completed_courses(university_id, course_code, semester, academic_year);

-- 3. LINK COMPLETED_COURSES DIRECTLY TO STUDENTS TABLE (NOT USERS TABLE)
ALTER TABLE completed_courses DROP CONSTRAINT IF EXISTS fkcj51sydw9r03u4iasv6m5h4pp;
ALTER TABLE completed_courses DROP CONSTRAINT IF EXISTS completed_courses_student_id_fkey;

UPDATE completed_courses cc
SET student_id = s.id
FROM students s
WHERE cc.university_id = s.student_id;

ALTER TABLE completed_courses
ADD CONSTRAINT fk_completed_courses_student
FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
