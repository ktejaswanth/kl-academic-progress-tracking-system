-- V3: Add Course module revamp — 15-column format
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS ltps VARCHAR(20);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS bucket_group VARCHAR(50);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS course_type VARCHAR(50);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS academic_year VARCHAR(20);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS study_year INT;
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS section_no VARCHAR(10);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS offer_to VARCHAR(100);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS offer_by VARCHAR(100);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS branch VARCHAR(50);
ALTER TABLE completed_courses ADD COLUMN IF NOT EXISTS register_date DATE;

-- Migrate existing completed_date data to register_date
UPDATE completed_courses SET register_date = completed_date WHERE register_date IS NULL;
