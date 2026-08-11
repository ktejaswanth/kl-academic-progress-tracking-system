-- ============================================================
-- V5: Curriculum Version Hardening & Curriculum Courses / Buckets
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. ENHANCE CURRICULUM_VERSIONS TABLE
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS department_id BIGINT REFERENCES department_master(id);
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS regulation_id BIGINT REFERENCES regulation_master(id);
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS curriculum_code VARCHAR(50);
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS program_name VARCHAR(200);
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'ACTIVE';
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS source_file VARCHAR(255);
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS source_hash VARCHAR(64);
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS published_at TIMESTAMP;
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS effective_to DATE;
ALTER TABLE curriculum_versions ADD COLUMN IF NOT EXISTS academic_year VARCHAR(20);

CREATE INDEX IF NOT EXISTS idx_curriculum_version_dept_reg ON curriculum_versions(department_id, regulation_id);

-- 2. TIE DEGREE_PATHS TO CURRICULUM_VERSION
ALTER TABLE degree_paths ADD COLUMN IF NOT EXISTS curriculum_version_id BIGINT REFERENCES curriculum_versions(id);
CREATE INDEX IF NOT EXISTS idx_degree_paths_curr_ver ON degree_paths(curriculum_version_id);

-- 3. ENHANCE CURRICULUM_COURSES TABLE (curriculum-version-specific course info)
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS course_name VARCHAR(255);
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS credits DOUBLE PRECISION;
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS ltps VARCHAR(20);
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS lecture_hours INT DEFAULT 0;
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS tutorial_hours INT DEFAULT 0;
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS practical_hours INT DEFAULT 0;
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS skill_hours INT DEFAULT 0;
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS course_type VARCHAR(50);
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS category VARCHAR(50);
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS subcategory VARCHAR(50);
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS semester VARCHAR(20);
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS study_year INT;
ALTER TABLE curriculum_courses ADD COLUMN IF NOT EXISTS prerequisite VARCHAR(255);

-- 4. CURRICULUM BUCKETS (version-aware bucket definitions)
CREATE TABLE IF NOT EXISTS curriculum_buckets (
    id                      BIGSERIAL PRIMARY KEY,
    curriculum_version_id   BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    bucket_id               BIGINT REFERENCES bucket_master(id),
    display_name            VARCHAR(200) NOT NULL,
    category                VARCHAR(100),
    subcategory             VARCHAR(100),
    description             TEXT,
    display_order           INT DEFAULT 0,
    is_active               BOOLEAN DEFAULT true,
    created_at              TIMESTAMP DEFAULT NOW(),
    UNIQUE(curriculum_version_id, bucket_id)
);

-- 5. CURRICULUM COURSE MAPPING (version-aware course -> bucket -> path mapping)
CREATE TABLE IF NOT EXISTS curriculum_course_mapping (
    id                      BIGSERIAL PRIMARY KEY,
    curriculum_version_id   BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    curriculum_course_id    BIGINT REFERENCES curriculum_courses(id) ON DELETE CASCADE,
    bucket_id               BIGINT REFERENCES bucket_master(id),
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
CREATE INDEX IF NOT EXISTS idx_ccm_bucket ON curriculum_course_mapping(bucket_id);
CREATE INDEX IF NOT EXISTS idx_ccm_path ON curriculum_course_mapping(degree_path_id);

-- ============================================================
-- END OF V5 MIGRATION
-- ============================================================
