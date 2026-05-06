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
