-- ============================================================
-- V6: Specialization, Minor & Double Major Structures
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. ENHANCE SPECIALIZATIONS
ALTER TABLE specializations ADD COLUMN IF NOT EXISTS curriculum_version_id BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE;
ALTER TABLE specializations ADD COLUMN IF NOT EXISTS department_id BIGINT REFERENCES department_master(id);
ALTER TABLE specializations ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- SPECIALIZATION COURSES TABLE
CREATE TABLE IF NOT EXISTS specialization_courses (
    id                      BIGSERIAL PRIMARY KEY,
    specialization_id       BIGINT REFERENCES specializations(id) ON DELETE CASCADE,
    curriculum_version_id   BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    course_id               BIGINT REFERENCES course_catalog(id) ON DELETE CASCADE,
    role                    VARCHAR(30) NOT NULL, -- PE-1, PE-2, PE-3, PE-4, PE-5, SDC, SDP
    sequence_no             INT DEFAULT 1,
    required                BOOLEAN DEFAULT true,
    created_at              TIMESTAMP DEFAULT NOW(),
    UNIQUE(specialization_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_spec_courses_spec ON specialization_courses(specialization_id);

-- 2. ENHANCE MINOR PROGRAMS
ALTER TABLE minor_programs ADD COLUMN IF NOT EXISTS curriculum_version_id BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE;
ALTER TABLE minor_programs ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE minor_programs ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- MINOR COURSES TABLE
CREATE TABLE IF NOT EXISTS minor_courses (
    id                      BIGSERIAL PRIMARY KEY,
    minor_id                BIGINT REFERENCES minor_programs(id) ON DELETE CASCADE,
    curriculum_version_id   BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    course_id               BIGINT REFERENCES course_catalog(id) ON DELETE CASCADE,
    bucket_id               BIGINT REFERENCES bucket_master(id),
    required                BOOLEAN DEFAULT true,
    sequence_no             INT DEFAULT 1,
    created_at              TIMESTAMP DEFAULT NOW(),
    UNIQUE(minor_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_minor_courses_minor ON minor_courses(minor_id);

-- 3. SECOND MAJOR PROGRAMS TABLE
CREATE TABLE IF NOT EXISTS second_major_programs (
    id                      BIGSERIAL PRIMARY KEY,
    curriculum_version_id   BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    department_id           BIGINT REFERENCES department_master(id),
    code                    VARCHAR(50) NOT NULL,
    name                    VARCHAR(200) NOT NULL,
    description             TEXT,
    required_credits        INT NOT NULL DEFAULT 40,
    is_active               BOOLEAN DEFAULT true,
    created_at              TIMESTAMP DEFAULT NOW(),
    UNIQUE(curriculum_version_id, code)
);

-- SECOND MAJOR COURSES TABLE
CREATE TABLE IF NOT EXISTS second_major_courses (
    id                      BIGSERIAL PRIMARY KEY,
    second_major_id         BIGINT REFERENCES second_major_programs(id) ON DELETE CASCADE,
    curriculum_version_id   BIGINT REFERENCES curriculum_versions(id) ON DELETE CASCADE,
    course_id               BIGINT REFERENCES course_catalog(id) ON DELETE CASCADE,
    bucket_id               BIGINT REFERENCES bucket_master(id),
    required                BOOLEAN DEFAULT true,
    sequence_no             INT DEFAULT 1,
    created_at              TIMESTAMP DEFAULT NOW(),
    UNIQUE(second_major_id, course_id)
);

CREATE INDEX IF NOT EXISTS idx_sm_courses_sm ON second_major_courses(second_major_id);

-- 4. UPDATE DEGREE PATHS WITH SPECIALIZATION / MINOR / SECOND MAJOR FOREIGN KEYS
ALTER TABLE degree_paths ADD COLUMN IF NOT EXISTS specialization_id BIGINT REFERENCES specializations(id);
ALTER TABLE degree_paths ADD COLUMN IF NOT EXISTS minor_id BIGINT REFERENCES minor_programs(id);
ALTER TABLE degree_paths ADD COLUMN IF NOT EXISTS second_major_id BIGINT REFERENCES second_major_programs(id);

-- ============================================================
-- END OF V6 MIGRATION
-- ============================================================
