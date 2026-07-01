-- ============================================================
-- V2: DYOD (Design Your Own Degree) Schema Migration
-- KL University Academic Progress Tracking System
-- Regulation: Y23 (initial), extensible for Y26+
-- ============================================================

-- 1. BUCKET MASTER — the 30+ DYOD curriculum buckets
CREATE TABLE IF NOT EXISTS bucket_master (
    id              BIGSERIAL PRIMARY KEY,
    bucket_code     VARCHAR(30) UNIQUE NOT NULL,
    bucket_name     VARCHAR(200) NOT NULL,
    bucket_category VARCHAR(50),
    description     TEXT,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 2. DEPARTMENT MASTER
CREATE TABLE IF NOT EXISTS department_master (
    id              BIGSERIAL PRIMARY KEY,
    dept_code       VARCHAR(20) UNIQUE NOT NULL,
    dept_name       VARCHAR(200) NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 3. REGULATION MASTER
CREATE TABLE IF NOT EXISTS regulation_master (
    id              BIGSERIAL PRIMARY KEY,
    reg_code        VARCHAR(20) UNIQUE NOT NULL,
    reg_name        VARCHAR(100) NOT NULL,
    effective_year  INT,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 4. DEGREE TYPE MASTER
CREATE TABLE IF NOT EXISTS degree_type_master (
    id              BIGSERIAL PRIMARY KEY,
    type_code       VARCHAR(20) UNIQUE NOT NULL,
    type_name       VARCHAR(100) NOT NULL,
    description     TEXT,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 5. ADDON TYPE MASTER
CREATE TABLE IF NOT EXISTS addon_type_master (
    id              BIGSERIAL PRIMARY KEY,
    addon_code      VARCHAR(30) UNIQUE NOT NULL,
    addon_name      VARCHAR(100) NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 6. DEGREE PATHS — the combinations (dept × type × addon)
CREATE TABLE IF NOT EXISTS degree_paths (
    id              BIGSERIAL PRIMARY KEY,
    path_code       VARCHAR(100) UNIQUE NOT NULL,
    department_id   BIGINT REFERENCES department_master(id),
    degree_type_id  BIGINT REFERENCES degree_type_master(id),
    addon_type_id   BIGINT REFERENCES addon_type_master(id),
    regulation_id   BIGINT REFERENCES regulation_master(id),
    addon_name      VARCHAR(200),
    total_credits   INT NOT NULL DEFAULT 0,
    is_active       BOOLEAN DEFAULT true,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 7. PATH BUCKET REQUIREMENTS — credit requirements per bucket per path
CREATE TABLE IF NOT EXISTS path_bucket_requirements (
    id              BIGSERIAL PRIMARY KEY,
    degree_path_id  BIGINT REFERENCES degree_paths(id) ON DELETE CASCADE,
    bucket_id       BIGINT REFERENCES bucket_master(id),
    required_credits INT NOT NULL,
    min_courses     INT,
    is_mandatory    BOOLEAN DEFAULT true,
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(degree_path_id, bucket_id)
);

-- 8. COURSE BUCKET MAPPING — which courses belong to which buckets
CREATE TABLE IF NOT EXISTS course_bucket_mapping (
    id              BIGSERIAL PRIMARY KEY,
    course_id       BIGINT REFERENCES course_catalog(id) ON DELETE CASCADE,
    bucket_id       BIGINT REFERENCES bucket_master(id) ON DELETE CASCADE,
    degree_path_id  BIGINT REFERENCES degree_paths(id),
    is_mandatory    BOOLEAN DEFAULT false,
    semester_offered VARCHAR(20),
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 9. STUDENT DEGREE PATH ASSIGNMENT
CREATE TABLE IF NOT EXISTS student_degree_path (
    id              BIGSERIAL PRIMARY KEY,
    student_id      BIGINT REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    degree_path_id  BIGINT REFERENCES degree_paths(id),
    assigned_at     TIMESTAMP DEFAULT NOW(),
    assigned_by     BIGINT REFERENCES users(id),
    is_confirmed    BOOLEAN DEFAULT false
);

-- 10. STUDENT BUCKET PROGRESS — computed progress per bucket
CREATE TABLE IF NOT EXISTS student_bucket_progress (
    id              BIGSERIAL PRIMARY KEY,
    student_id      BIGINT REFERENCES users(id) ON DELETE CASCADE,
    bucket_id       BIGINT REFERENCES bucket_master(id),
    degree_path_id  BIGINT REFERENCES degree_paths(id),
    required_credits INT NOT NULL,
    earned_credits  INT NOT NULL DEFAULT 0,
    course_count    INT NOT NULL DEFAULT 0,
    status          VARCHAR(20) DEFAULT 'PENDING',
    last_calculated TIMESTAMP DEFAULT NOW(),
    UNIQUE(student_id, bucket_id, degree_path_id)
);

-- 11. STUDENT DEGREE STATUS — overall eligibility
CREATE TABLE IF NOT EXISTS student_degree_status (
    id                      BIGSERIAL PRIMARY KEY,
    student_id              BIGINT REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    degree_path_id          BIGINT REFERENCES degree_paths(id),
    total_required_credits  INT,
    total_earned_credits    INT DEFAULT 0,
    completion_percentage   DECIMAL(5,2) DEFAULT 0.00,
    buckets_completed       INT DEFAULT 0,
    buckets_total           INT DEFAULT 0,
    is_degree_eligible      BOOLEAN DEFAULT false,
    status                  VARCHAR(30) DEFAULT 'IN_PROGRESS',
    last_evaluated          TIMESTAMP DEFAULT NOW(),
    details                 JSONB
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_degree_path_dept ON degree_paths(department_id);
CREATE INDEX IF NOT EXISTS idx_degree_path_type ON degree_paths(degree_type_id);
CREATE INDEX IF NOT EXISTS idx_degree_path_addon ON degree_paths(addon_type_id);
CREATE INDEX IF NOT EXISTS idx_degree_path_reg ON degree_paths(regulation_id);
CREATE INDEX IF NOT EXISTS idx_path_req_path ON path_bucket_requirements(degree_path_id);
CREATE INDEX IF NOT EXISTS idx_path_req_bucket ON path_bucket_requirements(bucket_id);
CREATE INDEX IF NOT EXISTS idx_cbm_course ON course_bucket_mapping(course_id);
CREATE INDEX IF NOT EXISTS idx_cbm_bucket ON course_bucket_mapping(bucket_id);
CREATE INDEX IF NOT EXISTS idx_cbm_path ON course_bucket_mapping(degree_path_id);
CREATE UNIQUE INDEX IF NOT EXISTS course_bucket_mapping_unique_idx ON course_bucket_mapping (course_id, bucket_id, COALESCE(degree_path_id, 0));
CREATE INDEX IF NOT EXISTS idx_sbp_student ON student_bucket_progress(student_id);
CREATE INDEX IF NOT EXISTS idx_sbp_path ON student_bucket_progress(degree_path_id);
CREATE INDEX IF NOT EXISTS idx_sds_student ON student_degree_status(student_id);
CREATE INDEX IF NOT EXISTS idx_sdp_student ON student_degree_path(student_id);

-- ============================================================
-- SEED DATA
-- ============================================================

-- Bucket Master (30+ DYOD buckets from KL Y23 curriculum)
INSERT INTO bucket_master (bucket_code, bucket_name, bucket_category) VALUES
    ('HAS-CORE', 'Humanities and Social Sciences - Core', 'Humanities'),
    ('HAS-FLE', 'Humanities and Social Sciences - Flexi Core', 'Humanities'),
    ('HAS-MGE', 'Humanities and Social Sciences - Management Elective', 'Humanities'),
    ('BSC-CORE', 'Basic Sciences - Core', 'Basic Sciences'),
    ('BSC-ME-1', 'Basic Sciences - Mathematics Elective 1', 'Basic Sciences'),
    ('BSC-ME-2', 'Basic Sciences - Mathematics Elective 2', 'Basic Sciences'),
    ('BSC-ME-3', 'Basic Sciences - Mathematics Elective 3', 'Basic Sciences'),
    ('BSC-SE-1', 'Basic Sciences - Science Elective 1', 'Basic Sciences'),
    ('BSC-SE-2', 'Basic Sciences - Science Elective 2', 'Basic Sciences'),
    ('BSC-SE-3', 'Basic Sciences - Science Elective 3', 'Basic Sciences'),
    ('ESC-CORE', 'Engineering Sciences - Core', 'Engineering Sciences'),
    ('PCC-CORE', 'Professional Core Courses', 'Professional Core'),
    ('FCC', 'Flexi Core Courses', 'Professional Core'),
    ('HFC-CORE', 'Honors Flexi Core', 'Honors'),
    ('HEC-CORE', 'Honors Elective Core', 'Honors'),
    ('SDP-1', 'Skill Development Program 1', 'Skill Development'),
    ('SDP-2', 'Skill Development Program 2', 'Skill Development'),
    ('SDP-3', 'Skill Development Program 3', 'Skill Development'),
    ('SDP-4', 'Skill Development Program 4', 'Skill Development'),
    ('PE-1', 'Program Elective 1', 'Program Electives'),
    ('PE-2', 'Program Elective 2', 'Program Electives'),
    ('PE-3', 'Program Elective 3', 'Program Electives'),
    ('PE-4', 'Program Elective 4', 'Program Electives'),
    ('PE-5', 'Program Elective 5', 'Program Electives'),
    ('PRI-CORE', 'Project / Research / Internship - Core', 'Project & Research'),
    ('OE-1', 'Open Elective 1', 'Open Electives'),
    ('OE-2', 'Open Elective 2', 'Open Electives'),
    ('OE-3', 'Open Elective 3', 'Open Electives'),
    ('MIN-CORE', 'Minor Core', 'Minor'),
    ('MIN-SDP', 'Minor Skill Development', 'Minor'),
    ('VAC', 'Value Added Courses', 'Value Added'),
    ('AUC', 'Audit Courses', 'Audit'),
    ('SIL', 'Self Initiated Learning', 'Self Learning')
ON CONFLICT (bucket_code) DO NOTHING;

-- Department Master
INSERT INTO department_master (dept_code, dept_name) VALUES
    ('CSE', 'Computer Science and Engineering'),
    ('AIDS', 'Artificial Intelligence and Data Science'),
    ('CSIT', 'Computer Science and Information Technology'),
    ('EEE', 'Electrical and Electronics Engineering'),
    ('MECH', 'Mechanical Engineering'),
    ('CIVIL', 'Civil Engineering'),
    ('ECE', 'Electronics and Communication Engineering')
ON CONFLICT (dept_code) DO NOTHING;

-- Regulation Master
INSERT INTO regulation_master (reg_code, reg_name, effective_year) VALUES
    ('Y23', 'Year 2023 Regulation', 2023),
    ('Y26', 'Year 2026 Regulation', 2026)
ON CONFLICT (reg_code) DO NOTHING;

-- Degree Type Master
INSERT INTO degree_type_master (type_code, type_name, description) VALUES
    ('REGULAR', 'Regular', 'Standard B.Tech degree without flexibility options'),
    ('HONORS', 'Honors', 'B.Tech with Honors - additional honors courses required'),
    ('HTE', 'Honors with Two Extras', 'B.Tech with honors and two additional specializations/minors'),
    ('HTI', 'Honors with Thesis and Internship', 'B.Tech with honors, thesis, and industry internship'),
    ('HTR', 'Honors with Thesis and Research', 'B.Tech with honors, thesis, and research project')
ON CONFLICT (type_code) DO NOTHING;

-- Addon Type Master
INSERT INTO addon_type_master (addon_code, addon_name) VALUES
    ('NONE', 'No Add-on'),
    ('SPECIALIZATION', 'Specialization'),
    ('MINOR', 'Minor'),
    ('DOUBLE_MAJOR', 'Double Major')
ON CONFLICT (addon_code) DO NOTHING;

-- ============================================================
-- END OF DYOD SCHEMA MIGRATION
-- ============================================================
