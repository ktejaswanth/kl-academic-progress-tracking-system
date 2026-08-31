-- ============================================================
-- V11: Seed Full Per-Bucket Path Requirements (CSE + AIDS)
-- KL University Academic Progress Tracking System
-- ============================================================

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTE' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 28, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'FC-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 28, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 28, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 28, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTI' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'FC-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 9, 9, 12, 3, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 9, 9, 12, 3, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 9, 9, 12, 3, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 9, 9, 12, 3, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HTR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'FC-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 36, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-HONORS' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 28, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'FC-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 28, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 0, 0, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 28, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 28, 28, 28, 7, 7, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'CSE-REGULAR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTE' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'HIC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTI' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 9, 9, 12, 3, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 9, 9, 12, 3, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 9, 9, 12, 3, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 9, 9, 12, 3, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'HRC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 20, 20, 20, 4, 4, 'PROJECT', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HTR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 7, 7, 7, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 43, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 16, 2, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'HFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 0, 16, 0, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'HEC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-HONORS' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 31, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'MIN-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'MINOR', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-MINOR' AND bm.bucket_code = 'MIN-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 31, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 21, 21, 21, 5, 5, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, 'DOUBLE', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-DOUBLE_MAJOR' AND bm.bucket_code = 'SMFC-SDP'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 31, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SDP-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, 'SPECIALIZATION', true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PE-5'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR-SPECIALIZATION' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 10, 10, 10, 5, 5, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'HAS-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'HAS-FLE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'HAS-MGE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 8, 8, 8, 2, 2, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'BSC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'BSC-ME-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'BSC-ME-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'BSC-ME-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'BSC-SE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'BSC-SE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'BSC-SE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 30, 30, 30, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'ESC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 31, 31, 31, 8, 8, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'PCC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'FC-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'SDP-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'SDP-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 2, 2, 2, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'SDP-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'PE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'PE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 5, 5, 5, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'PE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'PE-4'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 16, 16, 16, 4, 4, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'PRI-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'OE-1'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'OE-2'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 4, 4, 4, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'OE-3'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'VAC-SPORTS'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'VAC-CERT'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 5, 6, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'AUC-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 0, 0, 0, 1, 1, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'AUC-CAREER'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;

INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, 3, 3, 3, 3, 3, NULL, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = 'AIDS-REGULAR' AND bm.bucket_code = 'SIL-CORE'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;
