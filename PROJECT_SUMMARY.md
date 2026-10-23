# CreditCore — Project Summary

> **Project:** KL University Academic Progress Tracking System  
> **Purpose:** A role-based web platform that records a student's academic work, maps it to the applicable curriculum/degree path, shows graduation readiness, and supports exit-clearance administration.

## 1. What has been built

CreditCore centralizes academic-progress tracking for KL University. It supports the full flow from creating users and importing student/course data to evaluating degree requirements, generating reports, and processing exit clearance.

The current repository contains a working frontend and backend, database migration scripts, official Y23 CSE and AIDS curriculum PDFs, sample/seed logic, Docker configuration, and backend automated tests.

## 2. Technology stack

| Layer | Technology used |
|---|---|
| Frontend | React 19, Vite, React Router, Axios, XLSX |
| Backend | Java 21, Spring Boot 3.5.6, Spring Web, Spring Data JPA, Spring Security |
| Database | PostgreSQL (configured for Supabase; optional local PostgreSQL 16 Docker service) |
| Authentication | JWT-based authentication with role-based authorization |
| File/data processing | Apache POI for Excel, PDFBox for PDF text extraction |
| AI-assisted curriculum import | Google Gemini API integration with Gson/WebFlux |
| Mail | Spring Mail / SMTP |
| Documentation/API | Springdoc OpenAPI/Swagger dependency |
| Deployment | Docker Compose; frontend served through Nginx and backend on port `8086` |

## 3. User roles and responsibilities

The actual application enum defines three roles: `SUPER_ADMIN`, `FACULTY`, and `STUDENT`. Some security rules still mention legacy `ADMIN` access; the active role enum does **not** contain that value.

| Role | What the role can do |
|---|---|
| **SUPER_ADMIN** | Full system control: create/manage students, faculty, and admins; bulk import students; manage curriculum records; upload courses; view analytics; review student issues; administer exit clearances and reports. |
| **FACULTY** | View/lookup student academic data; register students one-by-one or in bulk; upload student courses; view academic/exit reports; review or bulk-approve exit-clearance items. |
| **STUDENT** | Sign in and finish first-login onboarding; maintain profile and academic choices; view courses, progress, degree path, requirements, readiness and reports; submit exit-clearance requirements and report issues. |

## 4. Main features implemented

### Authentication and onboarding

- Login, JWT session handling, protected React routes, logout, and password change.
- Forgot-password and password-reset flow with email support.
- First-login verification, password creation, profile setup, and academic selection/onboarding flow.
- Role-specific portals for Super Admin, Faculty, and Student.

### Student academic-progress portal

- Dashboard and academic-progress views.
- Current, completed, failed/re-attempt, and historical course tracking.
- Course catalogue and curriculum-course viewing.
- Degree requirements, bucket-wise progress, remaining requirements, and degree-path view.
- Graduation eligibility/readiness calculation.
- Recommended courses, semester performance, reports/downloads, profile, notifications UI, and issue reporting.
- Student exit-requirement submission/status and PDF/report download.

### Course and curriculum management

- Add, edit, delete, view, and bulk-upload student-course records.
- Excel templates and import support for courses, requirements, mappings, and students.
- Course audit trail/history endpoints.
- Curriculum administration for programs, curriculum versions, requirements, courses, specializations, and honors.
- Curriculum PDF upload, AI-assisted analysis, manual review/editing, approval/rejection, repository listing, and deletion.
- Master-data management for degree paths, buckets, bucket requirements, and course-to-bucket mappings.
- Y23 CSE and AIDS curriculum support; official curriculum PDFs are stored in the repository.

### Degree-path and eligibility engines

- Auto-resolution/assignment of a student's degree path.
- Bucket mapping and bucket-satisfaction evaluation.
- Degree eligibility, specialization progress, minor progress, and second-major progress engines.
- Batch progress evaluation and student-level progress/status endpoints.
- Exit-requirement report/PDF generation and final-clearance workflow.

### Faculty and administration

- Student lookup and student detail views.
- Single and bulk student registration.
- Faculty dashboard, student-course upload, and exit-clearance review/bulk approval.
- Super Admin dashboards, analytics, student/faculty/admin management, issue management, curriculum management, and exit-clearance management.
- Student, department, and graduation-readiness reports, including Excel exports.

## 5. Database design

The backend uses JPA entities/repositories and PostgreSQL. The repository includes later cleanup migrations (`V20`–`V26`), so there are two important facts:

1. Several older JPA entity classes remain in source for compatibility/development history.
2. Migration `V25` removes a group of old/empty tables. Therefore, the lists below distinguish the **active/current schema concepts** from tables **explicitly retired by migrations**.

### 5.1 Core active/current schema tables

| Area | Tables used | Purpose |
|---|---|---|
| Users and access | `students`, `faculty`, `admins`, `password_reset_tokens`, `audit_history` | Stores portal users, password-reset data, and user/activity auditing. |
| Student academic record | `student_degree_path`, `student_bucket_progress`, `student_degree_status`, `student_exit_clearances`, `student_exit_summary`, `student_selections` | Stores a student's assigned path, requirement progress/status, clearance workflow, final summary, and selections. |
| Course catalogue and progress | `course_catalog`, `completed_courses` | Course catalogue plus the compatibility view used to represent completed student-course data. `completed_courses` was recreated in V20 as an updatable view over legacy/current course records. |
| Curriculum and degree configuration | `curriculum_versions`, `degree_paths`, `degree_outcome_requirements`, `path_bucket_requirements`, `bucket_master`, `sub_bucket_master`, `department_master`, `degree_type_master`, `regulation_master`, `addon_type_master`, `exit_requirements_master` | Defines regulations, departments, degree paths, curriculum versions, required buckets/outcomes, and exit requirements. |
| Add-on programmes | `specializations`, `minor_programs` | Holds specialization/minor definitions that can contribute to a degree path. |
| Operational/audit data | `upload_history` | Records bulk-upload activity. |
| Y23 curriculum data | `y23_aids_courses`, `y23_cse_courses`, `y23_aids_category_grouping`, `y23_cse_category_grouping`, `y23_aids_course_grouping_mapping`, `y23_cse_course_grouping_mapping` | Stores the normalized Y23 AIDS/CSE course data, category grouping, course-group mappings, and bucket linkage. |

### 5.2 Important relationships

```text
Student
  └─ Student Degree Path ──> Degree Path ──> Path Bucket Requirements ──> Bucket Master
  └─ Academic course/progress data ──> Bucket Progress + Degree Status
  └─ Exit Clearance records ──> Exit Summary

Y23 CSE / AIDS Course
  └─ Category Grouping / Course Group Mapping
  └─ Bucket Master
```

### 5.3 Tables/entities retained in source but dropped by cleanup migrations

The following tables are represented by legacy/compatibility code but are explicitly dropped by V20 or V25 and should not be treated as the latest production schema unless re-created separately:

- `curriculum_imports`, `curriculum_import_buckets`, `curriculum_import_courses`, `curriculum_import_errors`, `curriculum_import_specializations`, `curriculum_import_specialization_courses`
- `curriculum_courses`, `curriculum_course_mapping`, `student_courses`
- `student_profiles`, `student_course_attempts`, `student_issues`, `student_outcomes`, `eligibility_results`, `onboarding_tokens`
- `minor_courses`, `second_major_courses`, `second_major_programs`, `specialization_courses`, `honors_programs`, `degree_programs`
- `path_sub_bucket_requirements`, `program_course_equivalences`, `program_requirements`, `requirements`, `curriculum_buckets`, `course_bucket_mapping`
- `mapping_audit_logs`, `unmatched_student_queue`, `upload_failed_records`
- legacy `users` table and the deprecated `_deprecated_*` tables.

> **Note for future development:** The curriculum-import, student-course, issue, onboarding, and some programme APIs still have matching Java entities. Before the next deployment, reconcile those entities/repositories with the final PostgreSQL schema or add a new migration that restores the tables required by the desired APIs.

## 6. Major backend modules

| Module | Main responsibility |
|---|---|
| `AuthController` / security configuration | Login, password flows, JWT validation, route authorization. |
| `StudentOnboardingController` | First login, profile setup, and student selections. |
| `StudentController` / `StudentProgressController` | Student profile, course records, roadmap, issue reporting, and dashboard data. |
| `StudentCourseManagementController` / `AddCourseController` | Student-course CRUD, catalogue, bulk upload, templates, and audit. |
| `CurriculumImportController` | Curriculum PDF upload, AI analysis, review, approve/reject, and repository management. |
| `CurriculumAdminController` / `MasterDataController` | Program/curriculum configuration and degree-path/bucket master data. |
| `DegreePathController`, `BucketProgressController`, `EligibilityController` | Degree-path assignment, bucket evaluation, and eligibility calculation. |
| `ExitRequirementController` | Student/faculty/admin exit-clearance workflow, reports, and PDFs. |
| `ReportController` | Student, department, and graduation-readiness reports with Excel exports. |
| `FacultyStudentUploadController` / `SuperAdminController` | Student upload/lookup and system-user management/analytics. |

## 7. Frontend portals

| Portal | Implemented screens |
|---|---|
| **Student** | Dashboard, progress, course history, degree requirements, degree path, specialization/minor, graduation readiness, recommendations, catalogue, semester performance, reports, profile, notifications UI, exit requirements, and issue reporting. |
| **Faculty** | Dashboard, student lookup/detail, exit reports, exit clearance, bulk/single student registration, and course upload. |
| **Super Admin** | Dashboard, student/faculty/admin CRUD, bulk Excel upload, course upload, curriculum upload/review/repository/setup, student issue management, student lookup, exit reports, and exit clearances. |

## 8. Security and data protections already present

- Spring Security with stateless JWT authentication.
- Role-based endpoint authorization and protected frontend routes.
- Identity-aware student endpoints such as `/me` variants; backend tests include IDOR authorization coverage.
- Password reset tokens and password change support.
- Audit-related tables/services for traceability.
- Database credentials, JWT secret, and Gemini key read from environment variables rather than hard-coded values.

## 9. Testing already present

Backend tests cover the main high-risk business and security areas:

- Academic/course data consistency and course-management audits.
- Student onboarding security/synchronization.
- IDOR/authorization protection.
- Faculty lookup and issue behavior.
- Curriculum mapping, isolation, audits, missing-course checks, bucket satisfaction, and Y23 credit/path validation for CSE and AIDS.

## 10. Database migration history included

| Migration | What it does |
|---|---|
| `V20__cleanup_unwanted_tables_and_columns.sql` | Removes legacy tables/views/columns and creates an updatable `completed_courses` compatibility view. |
| `V21__wipe_all_courses_and_mappings.sql` | Resets course, mapping, import, and course-progress data for a clean re-import. |
| `V22__create_y23_aids_and_cse_courses.sql` | Creates Y23 AIDS and CSE course tables. |
| `V23__create_y23_category_and_grouping.sql` | Adds category-grouping and course-group mapping tables. |
| `V24__map_bucket_master_with_y23_courses.sql` | Maps Y23 courses to buckets and adds convenience views. |
| `V25__cleanup_unnecessary_tables_and_columns.sql` | Drops obsolete/empty legacy tables and unused columns. |
| `V26__add_academic_year_to_degree_paths.sql` | Adds `academic_year` to degree paths, defaulting existing records to `Y23`. |

## 11. Deployment configuration

- Backend listens on **port 8086**.
- Frontend is served on **port 3086** through Nginx.
- Docker Compose supports the application services and an optional local PostgreSQL service on port `5433`.
- Required runtime environment values include `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`, `JWT_SECRET` (fallback is configured), and optionally `GEMINI_API_KEY` / `GEMINI_API_MODEL`.

## 12. Current status in one line

**CreditCore is a near end-to-end academic progress, curriculum, graduation-readiness, reporting, and exit-clearance platform, with Y23 CSE/AIDs curriculum support and separate interfaces for students, faculty, and Super Admins.**
