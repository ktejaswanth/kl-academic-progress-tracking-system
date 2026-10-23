-- Add academic_year column to degree_paths table and set default to Y23
ALTER TABLE IF EXISTS degree_paths 
    ADD COLUMN IF NOT EXISTS academic_year VARCHAR(50) DEFAULT 'Y23';

UPDATE degree_paths 
SET academic_year = 'Y23' 
WHERE academic_year IS NULL OR academic_year = '';
