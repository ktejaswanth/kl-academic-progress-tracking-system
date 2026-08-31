-- ============================================================
-- V10: Master Architecture Overhaul (Phases 3, 4, 5, 6, 11)
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. FIX DEGREE TYPE TERMINOLOGY & DESCRIPTIONS
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

UPDATE degree_type_master 
SET type_name = 'Honors', 
    description = 'B.Tech. degree with Honors'
WHERE type_code = 'HONORS';

UPDATE degree_type_master 
SET type_name = 'Regular', 
    description = 'Standard B.Tech degree without flexibility options'
WHERE type_code = 'REGULAR';

-- 2. ENSURE ALL DYOD BUCKETS ARE IN BUCKET_MASTER
INSERT INTO bucket_master (bucket_code, bucket_name, bucket_category) VALUES
    ('HAS-CORE', 'Humanities and Social Sciences - Core', 'Humanities'),
    ('HAS-FLE', 'Humanities and Social Sciences - Flexi Core', 'Humanities'),
    ('HAS-MGE', 'Humanities and Social Sciences - Management Elective', 'Humanities'),
    ('BSC-CORE', 'Basic Sciences - Core', 'Basic Sciences'),
    ('BSC-ME-1', 'Basic Sciences - Mathematics Elective 1', 'Basic Sciences'),
    ('BSC-ME-2', 'Basic Sciences - Mathematics Elective 2', 'Basic Sciences'),
    ('BSC-ME-3', 'Basic Sciences - Mathematics Elective 3', 'Basic Sciences'),
    ('BSC-ME-4', 'Basic Sciences - Mathematics Elective 4', 'Basic Sciences'),
    ('BSC-ME-5', 'Basic Sciences - Mathematics Elective 5', 'Basic Sciences'),
    ('BSC-SE-1', 'Basic Sciences - Science Elective 1', 'Basic Sciences'),
    ('BSC-SE-2', 'Basic Sciences - Science Elective 2', 'Basic Sciences'),
    ('BSC-SE-3', 'Basic Sciences - Science Elective 3', 'Basic Sciences'),
    ('ESC-CORE', 'Engineering Sciences - Core', 'Engineering Sciences'),
    ('PCC-CORE', 'Professional Core Courses', 'Professional Core'),
    ('FC-1', 'Flexi Core Course 1', 'Professional Core'),
    ('FC-2', 'Flexi Core Course 2', 'Professional Core'),
    ('FCC', 'Flexi Core Courses', 'Professional Core'),
    ('HFC-CORE', 'Honors Flexi Core', 'Honors'),
    ('HEC-CORE', 'Honors Elective Core', 'Honors'),
    ('HRC-CORE', 'Honors Research Core', 'Honors'),
    ('HIC-CORE', 'Honors Innovation Core', 'Honors'),
    ('SDP-1', 'Skill Development Program 1', 'Skill Development'),
    ('SDP-2', 'Skill Development Program 2', 'Skill Development'),
    ('SDP-3', 'Skill Development Program 3', 'Skill Development'),
    ('SDP-4', 'Skill Development Program 4', 'Skill Development'),
    ('SDC-CORE', 'Skill Development Core', 'Skill Development'),
    ('PE-1', 'Program Elective 1', 'Program Electives'),
    ('PE-2', 'Program Elective 2', 'Program Electives'),
    ('PE-3', 'Program Elective 3', 'Program Electives'),
    ('PE-4', 'Program Elective 4', 'Program Electives'),
    ('PE-5', 'Program Elective 5', 'Program Electives'),
    ('PE-CORE', 'Program Elective Core', 'Program Electives'),
    ('PRI-CORE', 'Project / Research / Internship - Core', 'Project & Research'),
    ('OE-1', 'Open Elective 1', 'Open Electives'),
    ('OE-2', 'Open Elective 2', 'Open Electives'),
    ('OE-3', 'Open Elective 3', 'Open Electives'),
    ('OE-CORE', 'Open Elective Core', 'Open Electives'),
    ('MIN-CORE', 'Minor Core', 'Minor'),
    ('MIN-SDP', 'Minor Skill Development', 'Minor'),
    ('VAC-SPORTS', 'Value Added Course - Sports', 'Value Added'),
    ('VAC-CERT', 'Value Added Course - Certification', 'Value Added'),
    ('VAC-CORE', 'Value Added Core', 'Value Added'),
    ('VAC', 'Value Added Courses', 'Value Added'),
    ('AUC-CORE', 'Audit Course - Core', 'Audit'),
    ('AUC-CAREER', 'Audit Course - Career', 'Audit'),
    ('AUC', 'Audit Courses', 'Audit'),
    ('SIL-CORE', 'Self Initiated Learning Core', 'Self Learning'),
    ('SIL', 'Self Initiated Learning', 'Self Learning'),
    ('SMFC-CORE', 'Second Major Flexi Core', 'Double Major'),
    ('SMFC-SDP', 'Second Major Skill Development Program', 'Double Major')
ON CONFLICT (bucket_code) DO NOTHING;

-- 3. ENSURE CURRICULUM_VERSIONS FOR Y23-CSE AND Y23-AIDS
INSERT INTO curriculum_versions (curriculum_code, version_name, program_name, department_id, regulation_id, status, academic_year)
SELECT 'Y23-CSE', 'Y23 B.Tech. CSE Curriculum', 'B.Tech Computer Science and Engineering', 
       d.id, r.id, 'ACTIVE', '2023-2024'
FROM department_master d, regulation_master r
WHERE d.dept_code = 'CSE' AND r.reg_code = 'Y23'
  AND NOT EXISTS (SELECT 1 FROM curriculum_versions WHERE curriculum_code = 'Y23-CSE');

INSERT INTO curriculum_versions (curriculum_code, version_name, program_name, department_id, regulation_id, status, academic_year)
SELECT 'Y23-AIDS', 'Y23 B.Tech. AIDS Curriculum', 'B.Tech Artificial Intelligence and Data Science', 
       d.id, r.id, 'ACTIVE', '2023-2024'
FROM department_master d, regulation_master r
WHERE d.dept_code = 'AIDS' AND r.reg_code = 'Y23'
  AND NOT EXISTS (SELECT 1 FROM curriculum_versions WHERE curriculum_code = 'Y23-AIDS');

-- 4. BACKFILL DEGREE_PATHS CURRICULUM_VERSION_ID
UPDATE degree_paths dp
SET curriculum_version_id = cv.id
FROM curriculum_versions cv, department_master d
WHERE dp.department_id = d.id 
  AND d.dept_code = 'CSE' 
  AND cv.curriculum_code = 'Y23-CSE'
  AND (dp.curriculum_version_id IS NULL OR dp.curriculum_version_id != cv.id);

UPDATE degree_paths dp
SET curriculum_version_id = cv.id
FROM curriculum_versions cv, department_master d
WHERE dp.department_id = d.id 
  AND d.dept_code = 'AIDS' 
  AND cv.curriculum_code = 'Y23-AIDS'
  AND (dp.curriculum_version_id IS NULL OR dp.curriculum_version_id != cv.id);

-- 5. UPDATE DEGREE_PATHS UNIQUE CONSTRAINT (DROP GLOBAL UNIQUE ON PATH_CODE, ADD UNIQUE(curriculum_version_id, path_code))
ALTER TABLE degree_paths DROP CONSTRAINT IF EXISTS degree_paths_path_code_key;
ALTER TABLE degree_paths DROP CONSTRAINT IF EXISTS uk_degree_paths_version_pathcode;
ALTER TABLE degree_paths ADD CONSTRAINT uk_degree_paths_version_pathcode UNIQUE (curriculum_version_id, path_code);

-- 6. ENHANCE CURRICULUM_COURSE_MAPPING
CREATE TABLE IF NOT EXISTS curriculum_course_mapping (
    id                      BIGSERIAL PRIMARY KEY,
    curriculum_version_id   BIGINT NOT NULL REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    curriculum_course_id    BIGINT NOT NULL REFERENCES curriculum_courses(id) ON DELETE CASCADE,
    bucket_id               BIGINT NOT NULL REFERENCES bucket_master(id),
    degree_path_id          BIGINT REFERENCES degree_paths(id) ON DELETE CASCADE,
    is_mandatory            BOOLEAN DEFAULT false,
    selection_group         VARCHAR(50),
    selection_order         INT DEFAULT 0,
    semester_offered        VARCHAR(20),
    mapping_source          VARCHAR(50) DEFAULT 'MANUAL',
    mapping_confidence      DOUBLE PRECISION DEFAULT 1.0,
    source_page             INT,
    source_section          VARCHAR(100),
    created_at              TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ccm_version ON curriculum_course_mapping(curriculum_version_id);
CREATE INDEX IF NOT EXISTS idx_ccm_course ON curriculum_course_mapping(curriculum_course_id);
CREATE INDEX IF NOT EXISTS idx_ccm_bucket ON curriculum_course_mapping(bucket_id);
CREATE INDEX IF NOT EXISTS idx_ccm_path ON curriculum_course_mapping(degree_path_id);

-- 7. ENHANCE CURRICULUM_IMPORTS
ALTER TABLE curriculum_imports ADD COLUMN IF NOT EXISTS source_hash VARCHAR(64);
ALTER TABLE curriculum_imports ADD COLUMN IF NOT EXISTS curriculum_version_id BIGINT REFERENCES curriculum_versions(id);

-- 8. INDEXES FOR PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_curr_courses_ver ON curriculum_courses(curriculum_version_id);
CREATE INDEX IF NOT EXISTS idx_curr_courses_code ON curriculum_courses(course_id);
CREATE INDEX IF NOT EXISTS idx_pbr_path_bucket ON path_bucket_requirements(degree_path_id, bucket_id);
