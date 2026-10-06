-- ====================================================================
-- SCHEMA DEFINITION: ADMIN, FACULTY, AND STUDENTS TABLES
-- ====================================================================

-- 1. ADMINS TABLE
CREATE TABLE IF NOT EXISTS admins (
    id BIGSERIAL PRIMARY KEY,
    emp_id VARCHAR(50),
    username VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    raw_password VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    designation VARCHAR(100),
    contact_no VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- View for singular reference
CREATE OR REPLACE VIEW admin AS SELECT * FROM admins;


-- 2. FACULTY TABLE
CREATE TABLE IF NOT EXISTS faculty (
    id BIGSERIAL PRIMARY KEY,
    emp_id VARCHAR(50),
    username VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    raw_password VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    designation VARCHAR(100),
    department VARCHAR(100),
    cabin_no VARCHAR(50),
    contact_no VARCHAR(50),
    first_login_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 3. STUDENTS TABLE
CREATE TABLE IF NOT EXISTS students (
    id BIGSERIAL PRIMARY KEY,
    student_id VARCHAR(100) UNIQUE NOT NULL,
    academic_year VARCHAR(50),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    department VARCHAR(100),
    sub_department VARCHAR(100),
    specialization_type VARCHAR(100) DEFAULT 'NONE',
    specialization_name VARCHAR(100),
    first_login_completed BOOLEAN DEFAULT FALSE,
    raw_password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- View for singular reference
CREATE OR REPLACE VIEW student AS SELECT * FROM students;


-- 4. USERS COMPLEMENTARY COLUMNS (For unified auth & Spring Security integration)
ALTER TABLE users ADD COLUMN IF NOT EXISTS emp_id VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS academic_year VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS designation VARCHAR(100);
ALTER TABLE users ADD COLUMN IF NOT EXISTS cabin_no VARCHAR(50);
ALTER TABLE users ADD COLUMN IF NOT EXISTS contact_no VARCHAR(50);
