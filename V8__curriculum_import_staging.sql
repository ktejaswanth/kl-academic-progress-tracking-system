-- ============================================================
-- V8: Curriculum AI Import Staging Tables
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. STAGING TABLE FOR IMPORTED COURSES
CREATE TABLE IF NOT EXISTS curriculum_import_courses (
    id                      BIGSERIAL PRIMARY KEY,
    import_id               BIGINT REFERENCES curriculum_imports(id) ON DELETE CASCADE,
    course_code             VARCHAR(30),
    course_name             VARCHAR(255),
    credits                 DOUBLE PRECISION,
    category                VARCHAR(50),
    subcategory             VARCHAR(50),
    lecture_hours           INT DEFAULT 0,
    tutorial_hours          INT DEFAULT 0,
    practical_hours         INT DEFAULT 0,
    skill_hours             INT DEFAULT 0,
    contact_hours           INT DEFAULT 0,
    mode                    VARCHAR(20),
    acronym                 VARCHAR(20),
    is_mandatory            BOOLEAN DEFAULT false,
    prerequisite            VARCHAR(255),
    source_page             INT,
    source_section          VARCHAR(100),
    raw_value               TEXT,
    parsed_value            TEXT,
    confidence              DOUBLE PRECISION DEFAULT 1.0,
    validation_status       VARCHAR(20) DEFAULT 'VALID',
    error_message           TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);

-- 2. STAGING TABLE FOR IMPORTED BUCKETS
CREATE TABLE IF NOT EXISTS curriculum_import_buckets (
    id                      BIGSERIAL PRIMARY KEY,
    import_id               BIGINT REFERENCES curriculum_imports(id) ON DELETE CASCADE,
    bucket_code             VARCHAR(50),
    bucket_name             VARCHAR(200),
    bucket_category         VARCHAR(100),
    description             TEXT,
    min_credits             INT DEFAULT 0,
    max_credits             INT DEFAULT 0,
    min_courses             INT DEFAULT 0,
    max_courses             INT DEFAULT 0,
    degree_type             VARCHAR(30) DEFAULT 'REGULAR',
    source_page             INT,
    source_section          VARCHAR(100),
    raw_value               TEXT,
    parsed_value            TEXT,
    confidence              DOUBLE PRECISION DEFAULT 1.0,
    validation_status       VARCHAR(20) DEFAULT 'VALID',
    error_message           TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);

-- 3. STAGING TABLE FOR IMPORTED SPECIALIZATIONS
CREATE TABLE IF NOT EXISTS curriculum_import_specializations (
    id                      BIGSERIAL PRIMARY KEY,
    import_id               BIGINT REFERENCES curriculum_imports(id) ON DELETE CASCADE,
    code                    VARCHAR(50),
    name                    VARCHAR(200),
    description             TEXT,
    source_page             INT,
    source_section          VARCHAR(100),
    raw_value               TEXT,
    parsed_value            TEXT,
    confidence              DOUBLE PRECISION DEFAULT 1.0,
    validation_status       VARCHAR(20) DEFAULT 'VALID',
    error_message           TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);

-- 4. STAGING TABLE FOR SPECIALIZATION COURSES
CREATE TABLE IF NOT EXISTS curriculum_import_specialization_courses (
    id                      BIGSERIAL PRIMARY KEY,
    import_id               BIGINT REFERENCES curriculum_imports(id) ON DELETE CASCADE,
    specialization_code     VARCHAR(50),
    course_code             VARCHAR(30),
    role                    VARCHAR(30), -- PE-1..5, SDC, SDP
    sequence_no             INT DEFAULT 1,
    source_page             INT,
    source_section          VARCHAR(100),
    confidence              DOUBLE PRECISION DEFAULT 1.0,
    validation_status       VARCHAR(20) DEFAULT 'VALID',
    error_message           TEXT,
    created_at              TIMESTAMP DEFAULT NOW()
);

-- 5. STAGING TABLE FOR IMPORT ERRORS / LOGS
CREATE TABLE IF NOT EXISTS curriculum_import_errors (
    id                      BIGSERIAL PRIMARY KEY,
    import_id               BIGINT REFERENCES curriculum_imports(id) ON DELETE CASCADE,
    entity_type             VARCHAR(50),
    field_name              VARCHAR(50),
    raw_value               TEXT,
    error_severity          VARCHAR(20) DEFAULT 'ERROR', -- WARNING, ERROR, CRITICAL
    error_message           TEXT NOT NULL,
    source_page             INT,
    source_section          VARCHAR(100),
    created_at              TIMESTAMP DEFAULT NOW()
);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_cic_import ON curriculum_import_courses(import_id);
CREATE INDEX IF NOT EXISTS idx_cib_import ON curriculum_import_buckets(import_id);
CREATE INDEX IF NOT EXISTS idx_cis_import ON curriculum_import_specializations(import_id);
CREATE INDEX IF NOT EXISTS idx_cie_import ON curriculum_import_errors(import_id);

-- ============================================================
-- END OF V8 MIGRATION
-- ============================================================
