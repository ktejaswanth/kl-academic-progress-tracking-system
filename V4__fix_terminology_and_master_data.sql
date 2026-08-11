-- ============================================================
-- V4: Fix Terminology & Master Data Hardening
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. FIX DEGREE TYPE TERMINOLOGY
UPDATE degree_type_master 
SET type_name = 'Honors through Experiential Learning', 
    description = 'B.Tech. degree with Honors through Experiential Learning (HTE)'
WHERE type_code = 'HTE';

UPDATE degree_type_master 
SET type_name = 'Honors through Innovation', 
    description = 'B.Tech. degree with Honors through Innovation (HTI)'
WHERE type_code = 'HTI';

UPDATE degree_type_master 
SET type_name = 'Honors through Research', 
    description = 'B.Tech. degree with Honors through Research (HTR)'
WHERE type_code = 'HTR';

-- 2. ENSURE ALL REGULATIONS IN REGULATION MASTER
INSERT INTO regulation_master (reg_code, reg_name, effective_year) VALUES
    ('Y23', 'Year 2023 Regulation', 2023),
    ('Y24', 'Year 2024 Regulation', 2024),
    ('Y25', 'Year 2025 Regulation', 2025),
    ('Y26', 'Year 2026 Regulation', 2026)
ON CONFLICT (reg_code) DO NOTHING;

-- 3. ADD UNIVERSITY_ID TO STUDENT PROFILES
ALTER TABLE student_profiles ADD COLUMN IF NOT EXISTS university_id VARCHAR(50);
CREATE UNIQUE INDEX IF NOT EXISTS idx_student_profiles_university_id ON student_profiles(university_id) WHERE university_id IS NOT NULL;

-- Backfill university_id from users.username if null
UPDATE student_profiles sp
SET university_id = u.username
FROM users u
WHERE sp.user_id = u.id AND sp.university_id IS NULL;

-- 4. ADD SOURCE_HASH TO CURRICULUM_IMPORTS FOR DUPLICATE PROTECTION
ALTER TABLE curriculum_imports ADD COLUMN IF NOT EXISTS source_hash VARCHAR(64);
CREATE INDEX IF NOT EXISTS idx_curriculum_imports_source_hash ON curriculum_imports(source_hash);

-- ============================================================
-- END OF V4 MIGRATION
-- ============================================================
