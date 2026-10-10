-- ============================================================
-- V13: Student Exit Requirement Management Schema
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. Create Exit Requirements Master Table
CREATE TABLE IF NOT EXISTS exit_requirements_master (
    id                  BIGSERIAL PRIMARY KEY,
    requirement_code    VARCHAR(50) UNIQUE NOT NULL,
    title               VARCHAR(150) NOT NULL,
    category            VARCHAR(50) NOT NULL, -- ACADEMIC, DEPARTMENT, ADMINISTRATIVE, CAREER_ALUMNI
    description         TEXT,
    responsible_role    VARCHAR(30) NOT NULL DEFAULT 'SUPER_ADMIN', -- SYSTEM_AUTO, FACULTY, SUPER_ADMIN
    is_mandatory        BOOLEAN DEFAULT true,
    display_order       INT DEFAULT 0,
    created_at          TIMESTAMP DEFAULT NOW()
);

-- 2. Create Student Exit Clearances Table
CREATE TABLE IF NOT EXISTS student_exit_clearances (
    id                  BIGSERIAL PRIMARY KEY,
    student_id          BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    requirement_id      BIGINT NOT NULL REFERENCES exit_requirements_master(id) ON DELETE CASCADE,
    status              VARCHAR(30) NOT NULL DEFAULT 'PENDING', -- PENDING, SUBMITTED, IN_REVIEW, APPROVED, REJECTED, WAIVED
    submission_notes    TEXT,
    attachment_url      VARCHAR(255),
    verified_by         VARCHAR(100),
    verifier_role       VARCHAR(30),
    verified_at         TIMESTAMP,
    remarks             TEXT,
    updated_at          TIMESTAMP DEFAULT NOW(),
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(student_id, requirement_id)
);

-- 3. Create Student Exit Summary Table (Overall Graduation Clearance)
CREATE TABLE IF NOT EXISTS student_exit_summary (
    id                  BIGSERIAL PRIMARY KEY,
    student_id          BIGINT UNIQUE NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    overall_status      VARCHAR(40) NOT NULL DEFAULT 'IN_PROGRESS', -- NOT_STARTED, IN_PROGRESS, PENDING_FINAL_APPROVAL, CLEARED_FOR_GRADUATION
    total_requirements  INT DEFAULT 0,
    approved_count      INT DEFAULT 0,
    clearance_percentage NUMERIC(5, 2) DEFAULT 0.00,
    certificate_token   VARCHAR(100),
    final_approved_by   VARCHAR(100),
    final_approved_at   TIMESTAMP,
    final_remarks       TEXT,
    updated_at          TIMESTAMP DEFAULT NOW(),
    created_at          TIMESTAMP DEFAULT NOW()
);

-- 4. Seed Master Exit Requirements
INSERT INTO exit_requirements_master (requirement_code, title, category, description, responsible_role, is_mandatory, display_order)
VALUES
    ('ACAD_CREDITS', 'Total Degree Credits & Bucket Requirements', 'ACADEMIC', 'Completion of all mandatory DYOD credit buckets, core courses, and electives.', 'SYSTEM_AUTO', true, 1),
    ('ACAD_CGPA', 'Cumulative GPA Compliance (CGPA >= 5.50)', 'ACADEMIC', 'Verification of passing grades with no active backlogs or disciplinary holds.', 'SYSTEM_AUTO', true, 2),
    ('ACAD_CAPSTONE', 'Capstone Project / Internship Defense Clearance', 'DEPARTMENT', 'Satisfactory viva, presentation, and project report submission to the faculty evaluation committee.', 'FACULTY', true, 3),
    ('DEPT_LAB_CLEAR', 'Department Laboratory Equipment & Kit Return', 'DEPARTMENT', 'Return of all lab hardware kits, component lending clearance, and lab in-charge signoff.', 'FACULTY', true, 4),
    ('DEPT_ADVISOR_SIGN', 'Faculty Counselor & Mentor Exit Recommendation', 'DEPARTMENT', 'Formal exit counseling session and endorsement from assigned faculty counselor.', 'FACULTY', true, 5),
    ('ADMIN_LIBRARY', 'Central Library Clearance & Book Return', 'ADMINISTRATIVE', 'Return of all borrowed books, materials, and clearance of any overdue library penalties.', 'SUPER_ADMIN', true, 6),
    ('ADMIN_FINANCE', 'Finance & Accounts No-Dues Clearance', 'ADMINISTRATIVE', 'Full reconciliation of tuition fees, lab fees, examination dues, and hostel accounts.', 'SUPER_ADMIN', true, 7),
    ('ADMIN_HOSTEL', 'Hostel & Residential Facilities Clearance', 'ADMINISTRATIVE', 'Room inspection, key handover, and clearance from chief hostel warden (if applicable).', 'SUPER_ADMIN', false, 8),
    ('EXIT_SURVEY', 'Mandatory University Academic Exit Survey', 'CAREER_ALUMNI', 'Completion of Program Outcomes (PO) assessment survey and feedback on university services.', 'SYSTEM_AUTO', true, 9),
    ('ALUMNI_REG', 'Alumni Association Registration & Career Declaration', 'CAREER_ALUMNI', 'Enrollment in the KL Alumni Network and submission of placement offer / higher study admit details.', 'SUPER_ADMIN', true, 10)
ON CONFLICT (requirement_code) DO NOTHING;

-- 5. Indexes for fast lookup
CREATE INDEX IF NOT EXISTS idx_sec_student ON student_exit_clearances(student_id);
CREATE INDEX IF NOT EXISTS idx_sec_req ON student_exit_clearances(requirement_id);
CREATE INDEX IF NOT EXISTS idx_sec_status ON student_exit_clearances(status);
CREATE INDEX IF NOT EXISTS idx_ses_student ON student_exit_summary(student_id);
