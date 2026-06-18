-- 1. DROP EXISTING TABLES (IF ANY)
DROP TABLE IF EXISTS upload_failed_records;
DROP TABLE IF EXISTS upload_history;
DROP TABLE IF EXISTS completed_courses;
DROP TABLE IF EXISTS requirements;
DROP TABLE IF EXISTS student_profiles;
DROP TABLE IF EXISTS users;
DROP TYPE IF EXISTS user_role;

-- 2. CREATE ROLES ENUM
CREATE TYPE user_role AS ENUM ('SUPER_ADMIN', 'FACULTY', 'STUDENT');

-- 3. CREATE USERS TABLE
CREATE TABLE users (
    id              BIGSERIAL PRIMARY KEY,
    username        VARCHAR(50) UNIQUE NOT NULL,    -- Student ID or faculty username
    email           VARCHAR(100) UNIQUE NOT NULL,
    password_hash   VARCHAR(255) NOT NULL,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    role            user_role NOT NULL DEFAULT 'STUDENT',
    department      VARCHAR(50),                    -- HTE, HTR, HTI, HONOR, REGULAR
    sub_department  VARCHAR(50),
    specialization_type VARCHAR(30) DEFAULT 'NONE',  -- NONE, MINOR, DOUBLE_MAJOR, SPECIALIZATION
    specialization_name VARCHAR(100),
    raw_password    VARCHAR(100),                   -- Plaintext password for admin viewing
    date_of_birth   DATE,
    first_login_completed BOOLEAN DEFAULT false,
    is_active       BOOLEAN DEFAULT true,
    force_password_change BOOLEAN DEFAULT true,     -- First login flag
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- 4. CREATE STUDENT PROFILES TABLE
CREATE TABLE student_profiles (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    degree_type     VARCHAR(20) NOT NULL,           -- B.Tech, M.Tech, etc.
    specialization  VARCHAR(50),                    -- HTE, HTR, HTI, HONOR, REGULAR
    honors_type     VARCHAR(20),                    -- Additional flag if needed
    branch          VARCHAR(50),
    batch           INT,
    section         VARCHAR(20),
    honors_option   VARCHAR(100),
    extension_type  VARCHAR(100),
    current_year    INT DEFAULT 1,
    admission_year  INT,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 5. CREATE REQUIREMENTS TABLE (DYNAMIC RULES)
CREATE TABLE requirements (
    id              BIGSERIAL PRIMARY KEY,
    degree_type     VARCHAR(20) NOT NULL,
    specialization  VARCHAR(50),                    -- HTE, HTR, HTI, HONOR, REGULAR
    honors_type     VARCHAR(20),
    bucket_name     VARCHAR(50) NOT NULL,           -- Mandatory, Elective, VAC, etc.
    course_code     VARCHAR(20),
    course_name     VARCHAR(100) NOT NULL,
    credits         INT NOT NULL,
    is_mandatory    BOOLEAN DEFAULT false,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 6. CREATE COMPLETED COURSES TABLE
CREATE TABLE completed_courses (
    id              BIGSERIAL PRIMARY KEY,
    student_id      BIGINT REFERENCES users(id) ON DELETE CASCADE,
    course_code     VARCHAR(20) NOT NULL,
    course_name     VARCHAR(100) NOT NULL,
    credits         INT NOT NULL,
    grade           VARCHAR(5),
    semester        VARCHAR(20),
    completed_date  DATE,
    verified_by     BIGINT REFERENCES users(id),    -- Faculty who verified
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 7. CREATE UPLOAD HISTORY TABLE
CREATE TABLE upload_history (
    id              BIGSERIAL PRIMARY KEY,
    uploaded_by     BIGINT REFERENCES users(id),
    file_name       VARCHAR(255),
    total_records   INT DEFAULT 0,
    success_count   INT DEFAULT 0,
    failed_count    INT DEFAULT 0,
    status          VARCHAR(20) DEFAULT 'PROCESSING',
    created_at      TIMESTAMP DEFAULT NOW()
);

-- 8. CREATE FAILED UPLOAD RECORDS TABLE
CREATE TABLE upload_failed_records (
    id              BIGSERIAL PRIMARY KEY,
    upload_id       BIGINT REFERENCES upload_history(id) ON DELETE CASCADE,
    row_number      INT,
    student_id_num  VARCHAR(50),
    email           VARCHAR(100),
    error_reason    VARCHAR(255)
);

-- 9. SEED INITIAL SUPER ADMIN (Username: admin, Password: password123 - hashed manually for now)
-- Note: Replace the hash with a proper BCrypt hash later.
-- This hash corresponds to 'password123'
INSERT INTO users (username, email, password_hash, first_name, last_name, role, department, force_password_change)
VALUES ('admin', 'admin@university.edu', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.TVuHOnC', 'Super', 'Admin', 'SUPER_ADMIN', 'ALL', false);

-- 10. CURRICULUM & PROGRAM TABLES
-- Degree programs (e.g., B.Tech CSE 2022 regulation)
CREATE TABLE degree_programs (
    id              BIGSERIAL PRIMARY KEY,
    code            VARCHAR(50) UNIQUE NOT NULL,   -- e.g., BTECH-CSE
    name            VARCHAR(200) NOT NULL,
    branch          VARCHAR(50) NOT NULL,          -- e.g., CSE, ECE
    batch_start     INT NOT NULL,                   -- admission year/batch
    batch_end       INT,                            -- optional
    regulation      VARCHAR(50),                    -- e.g., R2022
    duration_years  INT DEFAULT 4,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Specializations tied to degree programs
CREATE TABLE specializations (
    id              BIGSERIAL PRIMARY KEY,
    program_id      BIGINT REFERENCES degree_programs(id) ON DELETE CASCADE,
    code            VARCHAR(50) NOT NULL,
    name            VARCHAR(200) NOT NULL,
    description     TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(program_id, code)
);

-- Minor programs
CREATE TABLE minor_programs (
    id              BIGSERIAL PRIMARY KEY,
    program_id      BIGINT REFERENCES degree_programs(id) ON DELETE CASCADE,
    code            VARCHAR(50) NOT NULL,
    name            VARCHAR(200) NOT NULL,
    credits_required INT NOT NULL DEFAULT 18,
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(program_id, code)
);

-- Honors program definitions
CREATE TABLE honors_programs (
    id              BIGSERIAL PRIMARY KEY,
    program_id      BIGINT REFERENCES degree_programs(id) ON DELETE CASCADE,
    code            VARCHAR(50) NOT NULL,
    name            VARCHAR(200) NOT NULL,
    credits_required INT NOT NULL DEFAULT 12,
    research_required BOOLEAN DEFAULT false,
    created_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(program_id, code)
);

-- Course catalog
CREATE TABLE course_catalog (
    id              BIGSERIAL PRIMARY KEY,
    course_code     VARCHAR(50) UNIQUE NOT NULL,
    course_name     VARCHAR(255) NOT NULL,
    credits         INT NOT NULL,
    category        VARCHAR(100),   -- Core, Flexi Core, Program Elective, Lab, Audit
    offered_semester VARCHAR(20),    -- e.g., S1,S2,S3 or 1,2,3
    metadata        JSONB,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Program curriculum versions
CREATE TABLE curriculum_versions (
    id              BIGSERIAL PRIMARY KEY,
    program_id      BIGINT REFERENCES degree_programs(id) ON DELETE CASCADE,
    version_name    VARCHAR(100) NOT NULL,
    regulation      VARCHAR(100),
    effective_from  DATE,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Program requirements: ties courses/buckets to a curriculum version
CREATE TABLE program_requirements (
    id                  BIGSERIAL PRIMARY KEY,
    curriculum_version_id BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    bucket_name         VARCHAR(100) NOT NULL,   -- e.g., CORE, FLEXI_CORE, ELECTIVE, HONORS_CORE
    required_credits    INT NOT NULL,
    mandatory_course_codes TEXT[],               -- array of course_codes that are mandatory
    allowed_electives    TEXT[],                 -- array of course_codes permitted as electives (optional)
    created_at          TIMESTAMP DEFAULT NOW()
);

-- Mapping curriculum -> courses (explicit mapping for mandatory/optional courses)
CREATE TABLE curriculum_courses (
    id                  BIGSERIAL PRIMARY KEY,
    curriculum_version_id BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    course_id           BIGINT REFERENCES course_catalog(id) ON DELETE CASCADE,
    is_mandatory        BOOLEAN DEFAULT false,
    bucket_name         VARCHAR(100),
    min_year            INT,    -- earliest year/semester expected
    max_year            INT,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(curriculum_version_id, course_id)
);

-- Student selections for honors/specialization/minors/double-major
CREATE TABLE student_selections (
    id                  BIGSERIAL PRIMARY KEY,
    student_id          BIGINT REFERENCES users(id) ON DELETE CASCADE,
    program_id          BIGINT REFERENCES degree_programs(id),
    curriculum_version_id BIGINT REFERENCES curriculum_versions(id),
    honors_program_id   BIGINT REFERENCES honors_programs(id),
    specialization_id   BIGINT REFERENCES specializations(id),
    minor_program_ids   BIGINT[],    -- array of minor_program ids
    double_major_ids    BIGINT[],    -- array of program ids if double major
    extension_type      VARCHAR(100), -- None, Minor, Double Major, Specialization, Two Specializations, One Minor + One Specialization
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(student_id)
);

-- Eligibility result snapshots (computed after changes)
CREATE TABLE eligibility_results (
    id                  BIGSERIAL PRIMARY KEY,
    student_id          BIGINT REFERENCES users(id) ON DELETE CASCADE,
    snapshot_time       TIMESTAMP DEFAULT NOW(),
    degree_eligible     BOOLEAN DEFAULT false,
    honors_eligible     BOOLEAN DEFAULT false,
    minor_eligible      BOOLEAN DEFAULT false,
    double_major_eligible BOOLEAN DEFAULT false,
    specialization_eligible BOOLEAN DEFAULT false,
    details             JSONB,      -- structured report of missing credits/courses
    created_at          TIMESTAMP DEFAULT NOW()
);

-- Audit history/logs for eligibility runs and planner actions
CREATE TABLE audit_history (
    id                  BIGSERIAL PRIMARY KEY,
    student_id          BIGINT REFERENCES users(id) ON DELETE CASCADE,
    action_type         VARCHAR(100),   -- ELIGIBILITY_RUN, WHAT_IF_SIMULATION, ROADMAP_GENERATION
    performed_by        BIGINT REFERENCES users(id), -- who triggered (faculty or student)
    payload             JSONB,
    result              JSONB,
    created_at          TIMESTAMP DEFAULT NOW()
);

-- Indexes for faster lookups
CREATE INDEX idx_course_code ON course_catalog(course_code);
CREATE INDEX idx_program_code ON degree_programs(code);
CREATE INDEX idx_curriculum_version ON curriculum_versions(program_id);

-- 11. SAMPLE DATA (empty templates for common programs)
-- Example: add BTech CSE program placeholder and curricula (admin will manage real data via API)
INSERT INTO degree_programs (code, name, branch, batch_start, regulation, duration_years)
VALUES ('BTECH-CSE', 'B.Tech Computer Science and Engineering', 'CSE', 2022, 'R2022', 4)
ON CONFLICT (code) DO NOTHING;

-- End of schema additions for curriculum & eligibility
