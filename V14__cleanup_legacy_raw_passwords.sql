-- =====================================================================================
-- V14: Cleanup Legacy Plaintext Raw Passwords
-- KL University Academic Progress Tracking System
--
-- PURPOSE:
-- Nullifies legacy plaintext credentials stored in the `raw_password` columns across
-- `students`, `faculty`, and `admins` tables to ensure credential security at rest.
--
-- IMPORTANT SAFETY NOTICE:
-- 1. Apply this script ONLY after confirming compatibility and taking a full database backup.
-- 2. All accounts will continue authenticating normally via their BCrypt password hashes
--    stored in the `password` column.
-- 3. This script is idempotent: columns are updated only if they exist in the schema.
-- =====================================================================================

DO $$
BEGIN
    -- 1. Cleanup legacy plaintext passwords in students table
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'students' AND column_name = 'raw_password'
    ) THEN
        UPDATE students SET raw_password = NULL WHERE raw_password IS NOT NULL;
        RAISE NOTICE 'Cleared legacy raw_password values from students table.';
    END IF;

    -- 2. Cleanup legacy plaintext passwords in faculty table
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'faculty' AND column_name = 'raw_password'
    ) THEN
        UPDATE faculty SET raw_password = NULL WHERE raw_password IS NOT NULL;
        RAISE NOTICE 'Cleared legacy raw_password values from faculty table.';
    END IF;

    -- 3. Cleanup legacy plaintext passwords in admins table
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'admins' AND column_name = 'raw_password'
    ) THEN
        UPDATE admins SET raw_password = NULL WHERE raw_password IS NOT NULL;
        RAISE NOTICE 'Cleared legacy raw_password values from admins table.';
    END IF;
END $$;
