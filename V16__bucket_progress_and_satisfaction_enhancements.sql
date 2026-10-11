-- V14: Bucket Progress and Satisfaction Enhancements
-- Adds explicit credit limits (min/max), counted credits, excess credits, remaining credits,
-- course count limits (min/max), and mandatory course satisfaction tracking to student_bucket_progress.

ALTER TABLE student_bucket_progress
    ADD COLUMN IF NOT EXISTS counted_credits NUMERIC(5,2) DEFAULT 0,
    ADD COLUMN IF NOT EXISTS min_credits NUMERIC(5,2) DEFAULT 0,
    ADD COLUMN IF NOT EXISTS max_credits NUMERIC(5,2),
    ADD COLUMN IF NOT EXISTS min_courses INT DEFAULT 0,
    ADD COLUMN IF NOT EXISTS max_courses INT,
    ADD COLUMN IF NOT EXISTS counted_courses INT DEFAULT 0,
    ADD COLUMN IF NOT EXISTS excess_credits NUMERIC(5,2) DEFAULT 0,
    ADD COLUMN IF NOT EXISTS remaining_credits NUMERIC(5,2) DEFAULT 0,
    ADD COLUMN IF NOT EXISTS mandatory_satisfied BOOLEAN DEFAULT true;

-- Ensure indexes for fast student progress retrieval
CREATE INDEX IF NOT EXISTS idx_sbp_student_degree ON student_bucket_progress(student_id, degree_path_id);
CREATE INDEX IF NOT EXISTS idx_sbp_status ON student_bucket_progress(status);
