-- V17: Curriculum Audit Reconciliation, Targeted Credit Corrections, and Missing Mappings
-- Authoritative source: CSE_Pages_72_to_End.txt and AIDS_Pages_72_to_End.txt

BEGIN;

-- 1. Targeted Credit Correction for 23EC2211R (Official LTPS 3-0-2-2 = 4.5 credits)
UPDATE course_catalog 
SET credits = 5 
WHERE course_code = '23EC2211R';

UPDATE curriculum_courses 
SET credits = 4.5 
WHERE course_id IN (SELECT id FROM course_catalog WHERE course_code = '23EC2211R');

-- 2. Update category & subcategory for core AIDS courses (v=1)
UPDATE curriculum_courses 
SET category = 'PCC', subcategory = 'PCC-CORE', is_mandatory = true
WHERE curriculum_version_id = 1 
  AND course_id IN (
    SELECT id FROM course_catalog 
    WHERE course_code IN ('23AD2101', '23AD2102', '23AD2103', '23AD2104', '23AD2205', '23AD2206', '23AD2207', '23AD2208', '23AD3109', '23AD3110', '23AD3111')
  );

UPDATE curriculum_courses 
SET category = 'BSC', subcategory = 'BSC-CORE', is_mandatory = true
WHERE curriculum_version_id = 1 
  AND course_id IN (
    SELECT id FROM course_catalog 
    WHERE course_code IN ('23MT1101', '23MT1102')
  );

UPDATE curriculum_courses 
SET category = 'ESC', subcategory = 'ESC-CORE', is_mandatory = true
WHERE curriculum_version_id = 1 
  AND course_id IN (
    SELECT id FROM course_catalog 
    WHERE course_code = '23CS1101'
  );

-- 3. Insert Missing Mappings for CSE (v=2): 23CS2101 -> PCC-CORE
INSERT INTO curriculum_course_mapping (curriculum_version_id, curriculum_course_id, bucket_id, mapping_source, mapping_confidence, is_mandatory, created_at)
SELECT 2, cc.id, b.id, 'OFFICIAL_PDF', 1.0, true, now()
FROM curriculum_courses cc
JOIN course_catalog cat ON cc.course_id = cat.id
CROSS JOIN bucket_master b
WHERE cc.curriculum_version_id = 2 
  AND cat.course_code = '23CS2101'
  AND b.bucket_code = 'PCC-CORE'
  AND NOT EXISTS (
    SELECT 1 FROM curriculum_course_mapping ccm 
    WHERE ccm.curriculum_version_id = 2 AND ccm.curriculum_course_id = cc.id AND ccm.bucket_id = b.id
  );

-- 4. Insert Missing Mappings for AIDS (v=1): 23AD2101-23AD3111 -> PCC-CORE
INSERT INTO curriculum_course_mapping (curriculum_version_id, curriculum_course_id, bucket_id, mapping_source, mapping_confidence, is_mandatory, created_at)
SELECT 1, cc.id, b.id, 'OFFICIAL_PDF', 1.0, true, now()
FROM curriculum_courses cc
JOIN course_catalog cat ON cc.course_id = cat.id
CROSS JOIN bucket_master b
WHERE cc.curriculum_version_id = 1 
  AND cat.course_code IN ('23AD2101', '23AD2102', '23AD2103', '23AD2104', '23AD2205', '23AD2206', '23AD2207', '23AD2208', '23AD3109', '23AD3110', '23AD3111')
  AND b.bucket_code = 'PCC-CORE'
  AND NOT EXISTS (
    SELECT 1 FROM curriculum_course_mapping ccm 
    WHERE ccm.curriculum_version_id = 1 AND ccm.curriculum_course_id = cc.id AND ccm.bucket_id = b.id
  );

-- 5. Insert Missing Mappings for AIDS (v=1): 23MT1101, 23MT1102 -> BSC-CORE
INSERT INTO curriculum_course_mapping (curriculum_version_id, curriculum_course_id, bucket_id, mapping_source, mapping_confidence, is_mandatory, created_at)
SELECT 1, cc.id, b.id, 'OFFICIAL_PDF', 1.0, true, now()
FROM curriculum_courses cc
JOIN course_catalog cat ON cc.course_id = cat.id
CROSS JOIN bucket_master b
WHERE cc.curriculum_version_id = 1 
  AND cat.course_code IN ('23MT1101', '23MT1102')
  AND b.bucket_code = 'BSC-CORE'
  AND NOT EXISTS (
    SELECT 1 FROM curriculum_course_mapping ccm 
    WHERE ccm.curriculum_version_id = 1 AND ccm.curriculum_course_id = cc.id AND ccm.bucket_id = b.id
  );

-- 6. Insert Missing Mappings for AIDS (v=1): 23CS1101 -> ESC-CORE
INSERT INTO curriculum_course_mapping (curriculum_version_id, curriculum_course_id, bucket_id, mapping_source, mapping_confidence, is_mandatory, created_at)
SELECT 1, cc.id, b.id, 'OFFICIAL_PDF', 1.0, true, now()
FROM curriculum_courses cc
JOIN course_catalog cat ON cc.course_id = cat.id
CROSS JOIN bucket_master b
WHERE cc.curriculum_version_id = 1 
  AND cat.course_code = '23CS1101'
  AND b.bucket_code = 'ESC-CORE'
  AND NOT EXISTS (
    SELECT 1 FROM curriculum_course_mapping ccm 
    WHERE ccm.curriculum_version_id = 1 AND ccm.curriculum_course_id = cc.id AND ccm.bucket_id = b.id
  );

COMMIT;
