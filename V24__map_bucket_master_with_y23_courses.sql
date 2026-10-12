-- V24: Map bucket_master.bucket_code with y23_aids_courses.sub_cat and y23_cse_courses.sub_cat

-- 1. Normalize sub_cat formatting to ensure exact match with bucket_code
UPDATE y23_aids_courses SET sub_cat = 'AUC-CAREER' WHERE sub_cat = 'AUC- CAREER';
UPDATE y23_aids_courses SET sub_cat = 'SMFC-CORE' WHERE sub_cat = 'SMFC- CORE';
UPDATE y23_aids_courses SET sub_cat = 'PRI-CORE' WHERE sub_cat IS NULL AND cat = 'PRI';
UPDATE y23_aids_courses SET sub_cat = 'OE-CORE' WHERE sub_cat IS NULL AND cat = 'OEC';

UPDATE y23_cse_courses SET sub_cat = 'AUC-CAREER' WHERE sub_cat = 'AUC- CAREER';
UPDATE y23_cse_courses SET sub_cat = 'SMFC-CORE' WHERE sub_cat = 'SMFC- CORE';

-- 2. Add bucket_id foreign key column and indexes to y23_aids_courses and y23_cse_courses
ALTER TABLE y23_aids_courses ADD COLUMN IF NOT EXISTS bucket_id BIGINT REFERENCES bucket_master(id);
ALTER TABLE y23_cse_courses ADD COLUMN IF NOT EXISTS bucket_id BIGINT REFERENCES bucket_master(id);

CREATE INDEX IF NOT EXISTS idx_y23_aids_courses_bucket_id ON y23_aids_courses(bucket_id);
CREATE INDEX IF NOT EXISTS idx_y23_cse_courses_bucket_id ON y23_cse_courses(bucket_id);
CREATE INDEX IF NOT EXISTS idx_y23_aids_courses_sub_cat ON y23_aids_courses(sub_cat);
CREATE INDEX IF NOT EXISTS idx_y23_cse_courses_sub_cat ON y23_cse_courses(sub_cat);

-- 3. Populate bucket_id by joining sub_cat with bucket_master.bucket_code
UPDATE y23_aids_courses c
SET bucket_id = b.id
FROM bucket_master b
WHERE c.sub_cat = b.bucket_code;

UPDATE y23_cse_courses c
SET bucket_id = b.id
FROM bucket_master b
WHERE c.sub_cat = b.bucket_code;

-- 4. Create convenience views joining courses with bucket master details
CREATE OR REPLACE VIEW y23_aids_courses_with_bucket AS
SELECT 
    c.*,
    b.bucket_name,
    b.description AS bucket_description
FROM y23_aids_courses c
LEFT JOIN bucket_master b ON c.sub_cat = b.bucket_code;

CREATE OR REPLACE VIEW y23_cse_courses_with_bucket AS
SELECT 
    c.*,
    b.bucket_name,
    b.description AS bucket_description
FROM y23_cse_courses c
LEFT JOIN bucket_master b ON c.sub_cat = b.bucket_code;
