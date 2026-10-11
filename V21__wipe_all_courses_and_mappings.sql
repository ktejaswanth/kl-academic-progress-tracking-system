-- =====================================================================================
-- V21: Wipe All Courses, Mappings, Student Courses, and Course Progress in Supabase
-- KL University Academic Progress Tracking System
--
-- PURPOSE:
-- Cleanses all courses, course catalogs, curriculum mappings, student course records,
-- and course progress calculation tables, resetting identities for clean re-import.
-- Preserves master configurations: students, faculty, admins, degree paths, buckets.
-- =====================================================================================

BEGIN;

TRUNCATE TABLE 
    student_course_attempts,
    student_bucket_progress,
    student_degree_status,
    curriculum_course_mapping,
    student_courses,
    curriculum_courses,
    specialization_courses,
    minor_courses,
    second_major_courses,
    program_course_equivalences,
    curriculum_import_specialization_courses,
    curriculum_import_courses,
    curriculum_import_buckets,
    curriculum_import_errors,
    curriculum_import_specializations,
    curriculum_imports,
    unmatched_student_queue,
    mapping_audit_logs,
    course_catalog
RESTART IDENTITY CASCADE;

COMMIT;
