-- ============================================================
-- V7: Student Course Normalization & Multiple Attempt Support
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. NORMALIZED STUDENT_COURSES TABLE
CREATE TABLE IF NOT EXISTS student_courses (
    id                      BIGSERIAL PRIMARY KEY,
    student_id              BIGINT REFERENCES users(id) ON DELETE CASCADE,
    university_id           VARCHAR(50) NOT NULL,
    curriculum_version_id   BIGINT REFERENCES curriculum_versions(id),
    course_id               BIGINT REFERENCES course_catalog(id),
    curriculum_course_id    BIGINT REFERENCES curriculum_courses(id),
    course_code             VARCHAR(30) NOT NULL,
    course_name             VARCHAR(255),
    credits                 DOUBLE PRECISION DEFAULT 0,
    grade                   VARCHAR(5),
    status                  VARCHAR(30) DEFAULT 'COMPLETED', -- REGISTERED, IN_PROGRESS, COMPLETED, FAILED, DT, WITHDRAWN, TRANSFERRED
    semester                VARCHAR(20),
    academic_year           VARCHAR(20),
    completed_date          DATE,
    upload_id               BIGINT REFERENCES upload_history(id),
    source_row              INT,
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_student_courses_student ON student_courses(student_id);
CREATE INDEX IF NOT EXISTS idx_student_courses_univ_id ON student_courses(university_id);
CREATE INDEX IF NOT EXISTS idx_student_courses_code ON student_courses(course_code);

-- 2. STUDENT COURSE ATTEMPTS TABLE (For deterministic attempt selection)
CREATE TABLE IF NOT EXISTS student_course_attempts (
    id                      BIGSERIAL PRIMARY KEY,
    student_id              BIGINT REFERENCES users(id) ON DELETE CASCADE,
    university_id           VARCHAR(50) NOT NULL,
    course_code             VARCHAR(30) NOT NULL,
    attempt_number          INT DEFAULT 1,
    grade                   VARCHAR(5),
    grade_points            DOUBLE PRECISION DEFAULT 0,
    status                  VARCHAR(30) NOT NULL, -- REGISTERED, IN_PROGRESS, COMPLETED, FAILED, DT, WITHDRAWN
    semester                VARCHAR(20),
    academic_year           VARCHAR(20),
    is_qualifying           BOOLEAN DEFAULT false,
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_attempts_student_code ON student_course_attempts(student_id, course_code);

-- ============================================================
-- END OF V7 MIGRATION
-- ============================================================
