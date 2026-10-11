-- ============================================================
-- V16: Department Isolation, Course Equivalences & Review Queue
-- KL University Academic Progress Tracking System
--
-- This migration:
--   1. Creates program_course_equivalences for cross-curriculum course credits
--   2. Creates unmatched_student_queue for students with missing/invalid departments
--   3. Creates mapping_audit_logs for audit trails of admin corrections
--   4. Normalizes 'AI&DS' -> 'AIDS' in students table
--   5. Deduplicates student_courses records and adds uniqueness index
--   6. Enqueues student 2300080228 (department 'H') for manual administrative review
-- ============================================================

BEGIN;

-- 1. Program Course Equivalences Table
CREATE TABLE IF NOT EXISTS program_course_equivalences (
    id                          BIGSERIAL PRIMARY KEY,
    source_curriculum_version_id BIGINT NOT NULL REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    target_curriculum_version_id BIGINT NOT NULL REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    source_course_code          VARCHAR(30) NOT NULL,
    target_course_code          VARCHAR(30) NOT NULL,
    status                      VARCHAR(20) NOT NULL DEFAULT 'APPROVED', -- PENDING, APPROVED, REJECTED
    approved_by                 VARCHAR(100),
    approved_at                 TIMESTAMP DEFAULT NOW(),
    notes                       TEXT,
    created_at                  TIMESTAMP DEFAULT NOW(),
    CONSTRAINT uk_program_course_equiv UNIQUE (source_curriculum_version_id, target_curriculum_version_id, source_course_code, target_course_code)
);

CREATE INDEX IF NOT EXISTS idx_pce_source ON program_course_equivalences(source_curriculum_version_id, source_course_code);
CREATE INDEX IF NOT EXISTS idx_pce_target ON program_course_equivalences(target_curriculum_version_id, target_course_code);

-- 2. Unmatched Student Review Queue Table
CREATE TABLE IF NOT EXISTS unmatched_student_queue (
    id                  BIGSERIAL PRIMARY KEY,
    student_id          BIGINT REFERENCES students(id) ON DELETE CASCADE,
    student_id_num      VARCHAR(50) NOT NULL,
    student_name        VARCHAR(150),
    raw_department      VARCHAR(100),
    raw_regulation      VARCHAR(50),
    issue_type          VARCHAR(50) NOT NULL, -- UNKNOWN_DEPARTMENT, MISSING_REGULATION, AMBIGUOUS_MAPPING, UNRESOLVED_PATH
    error_message       TEXT NOT NULL,
    status              VARCHAR(20) NOT NULL DEFAULT 'PENDING_REVIEW', -- PENDING_REVIEW, RESOLVED, DISMISSED
    resolution_notes    TEXT,
    resolved_by         VARCHAR(100),
    resolved_at         TIMESTAMP,
    created_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_usq_status ON unmatched_student_queue(status);
CREATE INDEX IF NOT EXISTS idx_usq_student_id ON unmatched_student_queue(student_id_num);

-- 3. Mapping Audit Logs Table
CREATE TABLE IF NOT EXISTS mapping_audit_logs (
    id              BIGSERIAL PRIMARY KEY,
    student_id      BIGINT REFERENCES students(id) ON DELETE CASCADE,
    student_id_num  VARCHAR(50),
    action          VARCHAR(50) NOT NULL, -- MANUAL_CURRICULUM_ASSIGNMENT, DEPARTMENT_CORRECTION, EQUIVALENCE_APPROVED
    changed_by      VARCHAR(100) NOT NULL,
    previous_value  TEXT,
    new_value       TEXT,
    reason          TEXT,
    created_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_mal_student ON mapping_audit_logs(student_id);

-- 4. Normalize 'AI&DS' -> 'AIDS' in students table
UPDATE students 
SET department = 'AIDS' 
WHERE department = 'AI&DS';

-- 5. Deduplicate student_courses exact duplicates
DELETE FROM student_courses a 
USING student_courses b 
WHERE a.id < b.id 
  AND a.student_id = b.student_id 
  AND a.course_code = b.course_code 
  AND COALESCE(a.semester, '') = COALESCE(b.semester, '') 
  AND COALESCE(a.academic_year, '') = COALESCE(b.academic_year, '');

-- Create unique index to prevent future duplicate course attempts
CREATE UNIQUE INDEX IF NOT EXISTS uk_student_course_attempt 
ON student_courses (student_id, course_code, COALESCE(semester, ''), COALESCE(academic_year, ''));

-- 6. Enqueue student with ambiguous department 'H' to review queue
INSERT INTO unmatched_student_queue (
    student_id, student_id_num, student_name, raw_department, raw_regulation, 
    issue_type, error_message, status
)
SELECT 
    id, 
    student_id, 
    TRIM(COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')), 
    department, 
    academic_year, 
    'UNKNOWN_DEPARTMENT', 
    'Ambiguous department code ''H''. Student has completed 34 courses (including 23AD2204A, 23AD2205R). Requires administrative verification.', 
    'PENDING_REVIEW'
FROM students 
WHERE department = 'H'
  AND NOT EXISTS (
      SELECT 1 FROM unmatched_student_queue WHERE student_id_num = '2300080228'
  );

COMMIT;
