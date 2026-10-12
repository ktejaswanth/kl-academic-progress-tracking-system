-- V25: Remove unnecessary, empty, and deprecated tables and unused columns

-- 1. Drop views dependent on legacy tables
DROP VIEW IF EXISTS completed_courses CASCADE;

-- 2. Drop foreign key constraints pointing to legacy program tables
ALTER TABLE IF EXISTS curriculum_versions DROP CONSTRAINT IF EXISTS fkf6c0m69b7sq8y14ikdmjqtms8 CASCADE;
ALTER TABLE IF EXISTS specializations DROP CONSTRAINT IF EXISTS fkrykp655bdh3ni91s9otyr8suj CASCADE;
ALTER TABLE IF EXISTS honors_programs DROP CONSTRAINT IF EXISTS fklpwg1kpbcwonwsh1i31m3itn7 CASCADE;
ALTER TABLE IF EXISTS degree_paths DROP CONSTRAINT IF EXISTS fkn3gb555ait9c0opy3ej9etapy CASCADE;
ALTER TABLE IF EXISTS degree_paths DROP CONSTRAINT IF EXISTS fkee4cbty02q8u0tvlavbwobw3c CASCADE;
ALTER TABLE IF EXISTS second_major_courses DROP CONSTRAINT IF EXISTS fknatlaird24kj8jvo6eh0kre23 CASCADE;

-- 3. Drop all 26 unnecessary, empty, and deprecated tables
-- Legacy import staging tables
DROP TABLE IF EXISTS curriculum_import_buckets CASCADE;
DROP TABLE IF EXISTS curriculum_import_courses CASCADE;
DROP TABLE IF EXISTS curriculum_import_errors CASCADE;
DROP TABLE IF EXISTS curriculum_import_specialization_courses CASCADE;
DROP TABLE IF EXISTS curriculum_import_specializations CASCADE;
DROP TABLE IF EXISTS curriculum_imports CASCADE;

-- Legacy course mapping tables superseded by y23 tables
DROP TABLE IF EXISTS curriculum_course_mapping CASCADE;
DROP TABLE IF EXISTS minor_courses CASCADE;
DROP TABLE IF EXISTS second_major_courses CASCADE;
DROP TABLE IF EXISTS specialization_courses CASCADE;
DROP TABLE IF EXISTS student_courses CASCADE;
DROP TABLE IF EXISTS curriculum_courses CASCADE;

-- Empty legacy program tables
DROP TABLE IF EXISTS honors_programs CASCADE;
DROP TABLE IF EXISTS second_major_programs CASCADE;
DROP TABLE IF EXISTS degree_programs CASCADE;

-- Empty auxiliary tables
DROP TABLE IF EXISTS path_sub_bucket_requirements CASCADE;
DROP TABLE IF EXISTS program_course_equivalences CASCADE;
DROP TABLE IF EXISTS unmatched_student_queue CASCADE;
DROP TABLE IF EXISTS mapping_audit_logs CASCADE;
DROP TABLE IF EXISTS upload_failed_records CASCADE;
DROP TABLE IF EXISTS student_issues CASCADE;
DROP TABLE IF EXISTS student_outcomes CASCADE;
DROP TABLE IF EXISTS eligibility_results CASCADE;
DROP TABLE IF EXISTS onboarding_tokens CASCADE;
DROP TABLE IF EXISTS student_course_attempts CASCADE;
DROP TABLE IF EXISTS student_profiles CASCADE;

-- 4. Drop completely NULL and unused columns from active tables
ALTER TABLE IF EXISTS curriculum_versions 
    DROP COLUMN IF EXISTS program_id,
    DROP COLUMN IF EXISTS effective_to,
    DROP COLUMN IF EXISTS source_file,
    DROP COLUMN IF EXISTS source_hash;

ALTER TABLE IF EXISTS degree_paths 
    DROP COLUMN IF EXISTS addon_name,
    DROP COLUMN IF EXISTS minor_id,
    DROP COLUMN IF EXISTS second_major_id,
    DROP COLUMN IF EXISTS specialization_id;

ALTER TABLE IF EXISTS specializations 
    DROP COLUMN IF EXISTS program_id;

ALTER TABLE IF EXISTS path_bucket_requirements 
    DROP COLUMN IF EXISTS required_count,
    DROP COLUMN IF EXISTS rules_json;

ALTER TABLE IF EXISTS student_degree_path 
    DROP COLUMN IF EXISTS assigned_by;

ALTER TABLE IF EXISTS students 
    DROP COLUMN IF EXISTS date_of_birth;
