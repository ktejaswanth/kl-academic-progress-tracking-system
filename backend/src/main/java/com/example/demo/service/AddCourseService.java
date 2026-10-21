package com.example.demo.service;

import com.example.demo.controller.AddCourseController.AddCourseRequest;
import com.example.demo.dto.AuditHistoryResponse;
import com.example.demo.dto.UpdateCourseRequest;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
@Transactional
public class AddCourseService {

    static {
        IOUtils.setByteArrayMaxOverride(Integer.MAX_VALUE);
        ZipSecureFile.setMinInflateRatio(0.0);
    }

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private CourseCatalogRepository courseCatalogRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private StudentCourseRepository studentCourseRepository;

    @Autowired
    private StudentCourseAttemptRepository studentCourseAttemptRepository;

    @Autowired
    private CurriculumCourseRepository curriculumCourseRepository;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private BucketMappingEngine bucketMappingEngine;

    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    @Autowired
    private AuditHistoryRepository auditHistoryRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    private final com.fasterxml.jackson.databind.ObjectMapper objectMapper = new com.fasterxml.jackson.databind.ObjectMapper().findAndRegisterModules();

    /**
     * Resolves student entity from universityId in students table directly.
     * Checks students table and auto-registers in students table if not found.
     * Does NOT use or populate the users table.
     */
    public Student resolveOrCreateStudent(String universityId, String studentName, String branch, String academicYear) {
        if (universityId == null || universityId.trim().isEmpty()) {
            throw new IllegalArgumentException("University ID cannot be null or empty.");
        }
        String cleanUnivId = universityId.trim();

        // 1. Try finding in students table
        Optional<Student> studentOpt = studentRepository.findByStudentId(cleanUnivId);
        if (studentOpt.isPresent()) {
            return studentOpt.get();
        }

        // 2. Auto-create student in students table
        String firstName = cleanUnivId;
        String lastName = "";
        if (studentName != null && !studentName.trim().isEmpty()) {
            String trimmedName = studentName.trim();
            int spaceIdx = trimmedName.indexOf(' ');
            if (spaceIdx > 0) {
                firstName = trimmedName.substring(0, spaceIdx).trim();
                lastName = trimmedName.substring(spaceIdx + 1).trim();
            } else {
                firstName = trimmedName;
            }
        }
        String dept = (branch != null && !branch.trim().isEmpty()) ? branch.trim().toUpperCase() : null;
        if (dept != null) {
            if (dept.contains("AI") || dept.contains("AIDS") || dept.contains("DATA SCIENCE")) dept = "AIDS";
            else if (dept.contains("CSE") || dept.contains("COMPUTER SCIENCE")) dept = "CSE";
        } else {
            dept = "UNASSIGNED";
        }
        String acadYr = (academicYear != null && !academicYear.trim().isEmpty()) ? academicYear.trim() : "Y23";
        String email = cleanUnivId.toLowerCase() + "@kluniversity.in";
        String rawPassword = cleanUnivId;
        String encodedPassword = passwordEncoder.encode(rawPassword);

        Student newStudent = new Student();
        newStudent.setStudentId(cleanUnivId);
        newStudent.setFirstName(firstName);
        newStudent.setLastName(lastName);
        newStudent.setEmail(email);
        newStudent.setPassword(encodedPassword);
        newStudent.setRawPassword(rawPassword);
        newStudent.setDepartment(dept);
        newStudent.setSubDepartment("REGULAR");
        newStudent.setSpecializationType("NONE");
        newStudent.setSpecializationName("N/A");
        newStudent.setAcademicYear(acadYr);
        newStudent.setIsActive(true);
        newStudent.setFirstLoginCompleted(false);
        return studentRepository.save(newStudent);
    }

    /**
     * Resolves course from CourseCatalog. If missing, auto-creates entry so upload never fails.
     */
    public CourseCatalog resolveOrCreateCourseCatalog(String courseCode, String courseName, String ltps, String branch) {
        if (courseCode == null || courseCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Course code cannot be null or empty.");
        }
        String cleanCode = courseCode.trim();

        Optional<CourseCatalog> catalogOpt = courseCatalogRepository.findByCourseCode(cleanCode);
        if (catalogOpt.isPresent()) {
            CourseCatalog cat = catalogOpt.get();
            if (cat.getCredits() == null) {
                int credits = parseCreditsFromLtps(ltps);
                cat.setCredits(credits);
                return courseCatalogRepository.save(cat);
            }
            return cat;
        }

        // Auto-create course catalog entry
        int credits = parseCreditsFromLtps(ltps);
        String finalName = (courseName != null && !courseName.trim().isEmpty()) ? courseName.trim() : cleanCode;
        CourseCatalog newCatalog = new CourseCatalog();
        newCatalog.setCourseCode(cleanCode);
        newCatalog.setCourseName(finalName);
        newCatalog.setCredits(credits);
        newCatalog.setCategory((branch != null && !branch.trim().isEmpty()) ? branch.trim() : "GENERAL");
        return courseCatalogRepository.save(newCatalog);
    }

    /**
     * Parse credits from LTPS string like "3-0-2-0", "3-0-0", "4", etc.
     */
    public static int parseCreditsFromLtps(String ltps) {
        if (ltps == null || ltps.trim().isEmpty()) {
            return 3;
        }
        String clean = ltps.trim();
        try {
            return Integer.parseInt(clean);
        } catch (NumberFormatException ignored) {}

        String[] parts = clean.split("[-:, /]+");
        List<Double> nums = new ArrayList<>();
        for (String p : parts) {
            try {
                nums.add(Double.parseDouble(p.trim()));
            } catch (NumberFormatException ignored) {}
        }
        if (nums.isEmpty()) {
            return 3;
        }
        if (nums.size() == 1) {
            return Math.max(1, nums.get(0).intValue());
        }
        if (nums.size() >= 4) {
            double l = nums.get(0);
            double t = nums.get(1);
            double p = nums.get(2);
            double s = nums.get(3);
            double credits = l + t + (p * 0.5) + (s * 0.5);
            return Math.max(1, (int) Math.round(credits));
        }
        if (nums.size() == 3) {
            double l = nums.get(0);
            double t = nums.get(1);
            double p = nums.get(2);
            double credits = l + t + (p * 0.5);
            return Math.max(1, (int) Math.round(credits));
        }
        return Math.max(1, nums.get(0).intValue());
    }

    /**
     * Add a single completed course entry for a student.
     */
    public Map<String, Object> addSingleCourse(AddCourseRequest request, Long verifiedById) {
        if (request.getUniversityId() == null || request.getUniversityId().trim().isEmpty()) {
            if (request.getStudentId() != null) {
                Optional<Student> sOpt = studentRepository.findById(request.getStudentId());
                if (sOpt.isPresent()) {
                    request.setUniversityId(sOpt.get().getStudentId());
                    if (request.getStudentName() == null || request.getStudentName().trim().isEmpty()) {
                        request.setStudentName(sOpt.get().getFirstName() + " " + (sOpt.get().getLastName() != null ? sOpt.get().getLastName() : ""));
                    }
                } else {
                    throw new RuntimeException("Student not found for ID: " + request.getStudentId());
                }
            } else {
                throw new RuntimeException("Student university ID is required.");
            }
        }

        Student student = resolveOrCreateStudent(request.getUniversityId(), request.getStudentName(), request.getBranch(), request.getAcademicYear());


        CourseCatalog catalog = resolveOrCreateCourseCatalog(request.getCourseCode(), request.getCourseName(), request.getLtps(), request.getBranch());

        Optional<CompletedCourse> existing = completedCourseRepository
                .findFirstByUniversityIdAndCourseCodeAndSemesterAndAcademicYear(
                        student.getStudentId(), catalog.getCourseCode(), request.getSemester(), request.getAcademicYear()
                );
        if (!existing.isPresent()) {
            existing = completedCourseRepository.findFirstByUniversityIdAndCourseCode(student.getStudentId(), catalog.getCourseCode());
        }

        CompletedCourse completed = existing.orElseGet(CompletedCourse::new);
        completed.setStudent(student);
        completed.setUniversityId(student.getStudentId());
        completed.setStudentName(request.getStudentName() != null && !request.getStudentName().isEmpty() ? request.getStudentName() : (student.getFirstName() + " " + student.getLastName()).trim());
        completed.setCourseCode(catalog.getCourseCode());
        completed.setCourseName(request.getCourseName() != null && !request.getCourseName().isEmpty() ? request.getCourseName() : catalog.getCourseName());
        completed.setCredits(catalog.getCredits());
        completed.setGrade(request.getGrade() != null ? request.getGrade().toUpperCase() : null);
        completed.setSemester(request.getSemester() != null ? request.getSemester() : "ODD");

        LocalDate registerDate = null;
        if (request.getRegisterDate() != null && !request.getRegisterDate().isEmpty()) {
            try {
                registerDate = parseDateSafely(null, request.getRegisterDate());
            } catch (Exception ignored) {}
        }
        completed.setRegisterDate(registerDate != null ? registerDate : LocalDate.now());

        completed.setLtps(request.getLtps());
        completed.setBucketGroup(request.getBucketGroup());
        completed.setCourseType(request.getCourseType());
        completed.setAcademicYear(request.getAcademicYear());

        if (request.getStudyYear() != null && !request.getStudyYear().isEmpty()) {
            try {
                completed.setStudyYear(Integer.parseInt(request.getStudyYear()));
            } catch (Exception ignored) {}
        }

        completed.setSectionNo(request.getSectionNo());
        completed.setCourseRef(request.getCourseRef());
        completed.setOfferTo(request.getOfferTo());
        completed.setOfferBy(request.getOfferBy());
        completed.setBranch(request.getBranch());
        completed.setVerifiedBy(verifiedById);
        completed.setStatus("Completed");

        CompletedCourse saved = completedCourseRepository.save(completed);

        // Dual-write into normalized student_courses and student_course_attempts table
        syncStudentCourse(student, catalog, saved.getCourseName(), saved.getCredits() != null ? saved.getCredits().doubleValue() : 0.0,
                saved.getGrade(), saved.getSemester(), saved.getRegisterDate(), saved.getAcademicYear());

        // Try evaluating eligibility if a degree path is assigned
        Optional<StudentDegreePath> sdpOpt = studentDegreePathRepository.findByStudentId(student.getId());
        String bucketCode = "N/A";
        String bucketName = "N/A";
        if (sdpOpt.isPresent()) {
            try {
                degreeEligibilityEngine.evaluateEligibility(student.getId());
                Optional<BucketMaster> bucketOpt = bucketMappingEngine.resolveBucket(request.getCourseCode(), sdpOpt.get().getDegreePath().getId());
                if (bucketOpt.isPresent()) {
                    bucketCode = bucketOpt.get().getBucketCode();
                    bucketName = bucketOpt.get().getBucketName();
                }
            } catch (Exception ignored) {}
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("course", saved);
        result.put("mappedBucketCode", bucketCode);
        result.put("mappedBucketName", bucketName);

        // Record audit entry for course creation
        ActorInfo actor = resolveCurrentActor(verifiedById);
        Map<String, Object> newValues = new LinkedHashMap<>();
        newValues.put("courseCode", saved.getCourseCode());
        newValues.put("courseName", saved.getCourseName());
        newValues.put("credits", saved.getCredits());
        newValues.put("grade", saved.getGrade());
        newValues.put("semester", saved.getSemester());
        newValues.put("academicYear", saved.getAcademicYear());

        recordCourseAudit(
                student,
                "CREATE",
                actor,
                saved.getId(),
                saved.getCourseCode(),
                "Added course " + saved.getCourseCode() + " (" + (saved.getCourseName() != null ? saved.getCourseName() : "") + ") with " + saved.getCredits() + " credits",
                null,
                newValues
        );

        return result;
    }

    /**
     * Retrieves all available batch tables and their row counts.
     */
    public List<Map<String, Object>> getAvailableBatches() {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            List<String> tables = jdbcTemplate.queryForList(
                    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE '%_students_courses' ORDER BY table_name",
                    String.class
            );
            for (String tbl : tables) {
                String batchCode = tbl.replace("_students_courses", "").toUpperCase();
                Long count = 0L;
                try {
                    count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM " + tbl, Long.class);
                } catch (Exception ignored) {}

                Map<String, Object> map = new LinkedHashMap<>();
                map.put("batch", batchCode);
                map.put("tableName", tbl);
                map.put("count", count != null ? count : 0L);
                list.add(map);
            }
        } catch (Exception e) {
            System.err.println("Error fetching batches: " + e.getMessage());
        }
        return list;
    }

    /**
     * Ensures that the batch table exists (e.g. y23_students_courses, y24_students_courses, y26_students_courses).
     * If not existing, creates it dynamically with all required columns, indexes, and constraints.
     * Also refreshes completed_courses and student_courses views to UNION ALL all active batch tables.
     */
    public synchronized String ensureBatchTableExists(String batch) {
        String cleanBatch = (batch != null && !batch.trim().isEmpty()) ? batch.trim().toLowerCase() : "y23";
        if (!cleanBatch.startsWith("y")) {
            cleanBatch = "y" + cleanBatch;
        }
        cleanBatch = cleanBatch.replaceAll("[^a-z0-9]", "");
        if (!cleanBatch.matches("^y[0-9]{2,4}$")) {
            cleanBatch = "y23";
        }

        String tableName = cleanBatch + "_students_courses";

        try {
            String ddl = "CREATE TABLE IF NOT EXISTS " + tableName + " (" +
                    "id BIGSERIAL PRIMARY KEY, " +
                    "student_id BIGINT, " +
                    "university_id VARCHAR(50) NOT NULL, " +
                    "student_name VARCHAR(255), " +
                    "course_code VARCHAR(50) NOT NULL, " +
                    "course_name VARCHAR(255), " +
                    "ltps VARCHAR(50), " +
                    "credits INTEGER DEFAULT 0, " +
                    "grade VARCHAR(10), " +
                    "bucket_group VARCHAR(100), " +
                    "course_type VARCHAR(100), " +
                    "academic_year VARCHAR(50), " +
                    "semester VARCHAR(20), " +
                    "study_year INTEGER, " +
                    "section_no VARCHAR(50), " +
                    "register_date DATE, " +
                    "course_ref VARCHAR(100), " +
                    "offer_to VARCHAR(100), " +
                    "offer_by VARCHAR(100), " +
                    "branch VARCHAR(100), " +
                    "category VARCHAR(100), " +
                    "status VARCHAR(50) DEFAULT 'Completed', " +
                    "verified_by BIGINT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ");";
            jdbcTemplate.execute(ddl);

            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS idx_" + tableName + "_univ_course ON " + tableName + " (university_id, course_code);");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS idx_" + tableName + "_univ ON " + tableName + " (university_id);");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS idx_" + tableName + "_student_id ON " + tableName + " (student_id);");
            jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS idx_" + tableName + "_course ON " + tableName + " (course_code);");
            jdbcTemplate.execute("CREATE UNIQUE INDEX IF NOT EXISTS uq_" + tableName + "_record ON " + tableName + " (university_id, course_code, semester, academic_year);");

            // Enforce foreign key linking to students table
            try {
                jdbcTemplate.execute("ALTER TABLE " + tableName + " ADD CONSTRAINT fk_" + tableName + "_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;");
            } catch (Exception ignored) {
                // Constraint already exists
            }

            // Refresh completed_courses view
            refreshCompletedCoursesView();
        } catch (Exception e) {
            System.err.println("Notice ensuring batch table " + tableName + ": " + e.getMessage());
            throw new IllegalStateException("Failed to initialize batch table " + tableName + ": " + e.getMessage(), e);
        }

        return tableName;
    }

    /**
     * Refreshes the completed_courses and student_courses views to UNION ALL all batch tables.
     */
    public synchronized void refreshCompletedCoursesView() {
        try {
            List<String> tables = jdbcTemplate.queryForList(
                    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name LIKE '%_students_courses' ORDER BY table_name",
                    String.class
            );
            if (tables.isEmpty()) {
                tables = Collections.singletonList("y23_students_courses");
            }

            StringBuilder sb = new StringBuilder("CREATE OR REPLACE VIEW completed_courses AS ");
            for (int i = 0; i < tables.size(); i++) {
                if (i > 0) sb.append(" UNION ALL ");
                sb.append("SELECT id, student_id, university_id, student_name, course_code, course_name, credits, grade, semester, ltps, bucket_group, course_type, academic_year, study_year, section_no, register_date, course_ref, offer_to, offer_by, branch, category, status, verified_by, created_at FROM ").append(tables.get(i));
            }
            jdbcTemplate.execute(sb.toString());

            // Also refresh student_courses view
            jdbcTemplate.execute("CREATE OR REPLACE VIEW student_courses AS " +
                    "SELECT id, student_id, university_id, NULL::BIGINT AS curriculum_version_id, NULL::BIGINT AS course_id, NULL::BIGINT AS curriculum_course_id, course_code, course_name, credits::DOUBLE PRECISION AS credits, grade, status, semester, academic_year, register_date AS completed_date, created_at FROM completed_courses;");

            // Re-apply trigger function and trigger
            String triggerSql = "CREATE OR REPLACE FUNCTION trg_completed_courses_view_sync() " +
                    "RETURNS TRIGGER AS $$ " +
                    "DECLARE target_tbl text; batch_prefix text; rec record; " +
                    "BEGIN " +
                    "  IF TG_OP = 'DELETE' THEN rec := OLD; ELSE rec := NEW; END IF; " +
                    "  IF rec.academic_year IS NOT NULL AND rec.academic_year ~* 'y[0-9]{2}' THEN " +
                    "    batch_prefix := lower(substring(rec.academic_year from '(?i)y[0-9]{2}')); " +
                    "  ELSIF rec.university_id IS NOT NULL AND length(rec.university_id) >= 2 AND substring(rec.university_id from 1 for 2) ~ '^[0-9]{2}$' THEN " +
                    "    batch_prefix := 'y' || substring(rec.university_id from 1 for 2); " +
                    "  ELSE batch_prefix := 'y23'; END IF; " +
                    "  target_tbl := batch_prefix || '_students_courses'; " +
                    "  IF TG_OP = 'INSERT' THEN " +
                    "    EXECUTE format('INSERT INTO %I (student_id, university_id, student_name, course_code, course_name, credits, grade, semester, ltps, bucket_group, course_type, academic_year, study_year, section_no, register_date, course_ref, offer_to, offer_by, branch, category, status, verified_by) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22) ON CONFLICT (university_id, course_code, semester, academic_year) DO UPDATE SET student_id=COALESCE(EXCLUDED.student_id, %I.student_id), student_name=COALESCE(EXCLUDED.student_name, %I.student_name), course_name=COALESCE(EXCLUDED.course_name, %I.course_name), credits=COALESCE(EXCLUDED.credits, %I.credits), grade=COALESCE(EXCLUDED.grade, %I.grade), ltps=EXCLUDED.ltps, bucket_group=COALESCE(EXCLUDED.bucket_group, %I.bucket_group), course_type=COALESCE(EXCLUDED.course_type, %I.course_type), study_year=COALESCE(EXCLUDED.study_year, %I.study_year), section_no=COALESCE(EXCLUDED.section_no, %I.section_no), register_date=COALESCE(EXCLUDED.register_date, %I.register_date), course_ref=COALESCE(EXCLUDED.course_ref, %I.course_ref), offer_to=COALESCE(EXCLUDED.offer_to, %I.offer_to), offer_by=COALESCE(EXCLUDED.offer_by, %I.offer_by), branch=COALESCE(EXCLUDED.branch, %I.branch), category=COALESCE(EXCLUDED.category, %I.category), status=COALESCE(EXCLUDED.status, %I.status), verified_by=COALESCE(EXCLUDED.verified_by, %I.verified_by), updated_at=NOW() RETURNING id', target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl, target_tbl) " +
                    "    USING NEW.student_id, NEW.university_id, NEW.student_name, NEW.course_code, NEW.course_name, COALESCE(NEW.credits,0), NEW.grade, NEW.semester, NEW.ltps, NEW.bucket_group, NEW.course_type, NEW.academic_year, NEW.study_year, NEW.section_no, NEW.register_date, NEW.course_ref, NEW.offer_to, NEW.offer_by, NEW.branch, NEW.category, COALESCE(NEW.status,'Completed'), NEW.verified_by INTO NEW.id; " +
                    "    RETURN NEW; " +
                    "  ELSIF TG_OP = 'UPDATE' THEN " +
                    "    EXECUTE format('UPDATE %I SET student_id=$1, student_name=$2, course_name=$3, credits=$4, grade=$5, semester=$6, ltps=$7, bucket_group=$8, course_type=$9, academic_year=$10, study_year=$11, section_no=$12, register_date=$13, course_ref=$14, offer_to=$15, offer_by=$16, branch=$17, category=$18, status=$19, verified_by=$20, updated_at=NOW() WHERE id=$21', target_tbl) " +
                    "    USING NEW.student_id, NEW.student_name, NEW.course_name, NEW.credits, NEW.grade, NEW.semester, NEW.ltps, NEW.bucket_group, NEW.course_type, NEW.academic_year, NEW.study_year, NEW.section_no, NEW.register_date, NEW.course_ref, NEW.offer_to, NEW.offer_by, NEW.branch, NEW.category, NEW.status, NEW.verified_by, OLD.id; " +
                    "    RETURN NEW; " +
                    "  ELSIF TG_OP = 'DELETE' THEN " +
                    "    EXECUTE format('DELETE FROM %I WHERE id = $1', target_tbl) USING OLD.id; " +
                    "    RETURN OLD; " +
                    "  END IF; " +
                    "  RETURN NULL; " +
                    "END; $$ LANGUAGE plpgsql; " +
                    "DROP TRIGGER IF EXISTS trg_completed_courses_view_rw ON completed_courses; " +
                    "CREATE TRIGGER trg_completed_courses_view_rw INSTEAD OF INSERT OR UPDATE OR DELETE ON completed_courses FOR EACH ROW EXECUTE FUNCTION trg_completed_courses_view_sync();";
            jdbcTemplate.execute(triggerSql);
        } catch (Exception e) {
            System.err.println("Notice refreshing completed_courses view: " + e.getMessage());
        }
    }

    public Map<String, Object> bulkUploadCourses(MultipartFile file, Long verifiedById) throws Exception {
        return bulkUploadCourses(file, null, verifiedById);
    }

    /**
     * High Performance Streaming Bulk Upload Engine.
     * Supports files with up to 1,000,000 rows (CSV, XLSX SAX, XLS).
     * Automatically creates dynamic batch table if not exists (e.g. y23_students_courses, y24_students_courses)
     * and executes chunked multi-row UPSERTs with constant minimal memory usage.
     */
    public Map<String, Object> bulkUploadCourses(MultipartFile file, String batch, Long verifiedById) throws Exception {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File cannot be empty.");
        }

        long startTime = System.currentTimeMillis();
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) originalFilename = "upload.xlsx";

        // Determine target batch
        String targetBatch = (batch != null && !batch.trim().isEmpty()) ? batch.trim().toUpperCase() : null;
        String tableName = (targetBatch != null) ? ensureBatchTableExists(targetBatch) : null;

        int[] counters = new int[4]; // [0] = total, [1] = added/updated, [2] = skipped, [3] = failed
        List<String> errors = new ArrayList<>();
        Set<String> distinctStudentIds = new HashSet<>();
        List<com.example.demo.utils.CourseFileStreamingParser.ParsedRow> chunk = new ArrayList<>(1000);
        String[] detectedBatch = new String[]{targetBatch};
        String[] targetTableHolder = new String[]{tableName};

        try (InputStream is = file.getInputStream()) {
            com.example.demo.utils.CourseFileStreamingParser.streamRows(is, originalFilename, row -> {
                counters[0]++; // total

                if (row.status != null && row.status.startsWith("FAILED")) {
                    counters[3]++; // failed
                    if (errors.size() < 100) {
                        errors.add("Row missing required universityId or courseCode (student: " + (row.studentName != null ? row.studentName : "unknown") + ")");
                    }
                    return;
                }

                // If batch wasn't specified, detect from first valid row
                if (targetTableHolder[0] == null) {
                    String b = "Y23";
                    if (row.academicYear != null && row.academicYear.toUpperCase().matches(".*Y[0-9]{2}.*")) {
                        java.util.regex.Matcher m = java.util.regex.Pattern.compile("(?i)Y[0-9]{2}").matcher(row.academicYear);
                        if (m.find()) b = m.group().toUpperCase();
                    } else if (row.universityId != null && row.universityId.length() >= 2 && Character.isDigit(row.universityId.charAt(0)) && Character.isDigit(row.universityId.charAt(1))) {
                        b = "Y" + row.universityId.substring(0, 2);
                    }
                    detectedBatch[0] = b;
                    targetTableHolder[0] = ensureBatchTableExists(b);
                }

                distinctStudentIds.add(row.universityId);
                chunk.add(row);

                if (chunk.size() >= 1000) {
                    processCourseChunk(chunk, targetTableHolder[0], verifiedById, counters, errors);
                    chunk.clear();
                }
            });

            // Flush remaining chunk
            if (!chunk.isEmpty()) {
                if (targetTableHolder[0] == null) {
                    targetTableHolder[0] = ensureBatchTableExists("Y23");
                    detectedBatch[0] = "Y23";
                }
                processCourseChunk(chunk, targetTableHolder[0], verifiedById, counters, errors);
                chunk.clear();
            }
        }

        String finalTable = (targetTableHolder[0] != null) ? targetTableHolder[0] : "y23_students_courses";
        String finalBatch = (detectedBatch[0] != null) ? detectedBatch[0] : "Y23";

        // Auto-register any missing students in students table
        try {
            String encodedDefaultPassword = passwordEncoder.encode("Password@123");
            String syncStudentsSql = "INSERT INTO students (student_id, first_name, last_name, email, password, department, academic_year, is_active) " +
                    "SELECT DISTINCT " +
                    "  b.university_id, " +
                    "  COALESCE(NULLIF(SPLIT_PART(b.student_name, ' ', 1), ''), b.university_id), " +
                    "  COALESCE(NULLIF(SUBSTRING(b.student_name FROM POSITION(' ' IN b.student_name) + 1), ''), ''), " +
                    "  LOWER(b.university_id) || '@kluniversity.in', " +
                    "  ?, " +
                    "  COALESCE(NULLIF(b.branch, ''), 'UNASSIGNED'), " +
                    "  ?, " +
                    "  TRUE " +
                    "FROM " + finalTable + " b " +
                    "WHERE b.university_id NOT IN (SELECT student_id FROM students) " +
                    "ON CONFLICT (student_id) DO NOTHING;";
            jdbcTemplate.update(syncStudentsSql, encodedDefaultPassword, finalBatch);

            // Re-link student_id in batch table
            jdbcTemplate.execute("UPDATE " + finalTable + " b SET student_id = s.id FROM students s WHERE b.university_id = s.student_id AND b.student_id IS NULL;");
        } catch (Exception e) {
            System.err.println("Notice auto-syncing students table: " + e.getMessage());
        }

        // Trigger background eligibility evaluation
        if (!distinctStudentIds.isEmpty()) {
            Set<String> idsCopy = new HashSet<>(distinctStudentIds);
            CompletableFuture.runAsync(() -> {
                for (String uid : idsCopy) {
                    try {
                        studentRepository.findByStudentId(uid).ifPresent(s -> {
                            try {
                                degreeEligibilityEngine.evaluateEligibility(s.getId());
                            } catch (Exception ignored) {}
                        });
                    } catch (Exception ignored) {}
                }
            });
        }

        long elapsedMs = Math.max(1, System.currentTimeMillis() - startTime);
        double speed = (counters[0] * 1000.0) / elapsedMs;

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("total", counters[0]);
        result.put("batch", finalBatch);
        result.put("tableName", finalTable);
        result.put("added", counters[1]);
        result.put("updated", 0);
        result.put("skipped", counters[2]);
        result.put("failed", counters[3]);
        result.put("errors", errors);
        result.put("executionTimeMs", elapsedMs);
        result.put("speedRowsPerSec", Math.round(speed));
        result.put("message", "Successfully processed " + counters[0] + " course records into " + finalTable + " (" + Math.round(speed) + " rows/sec in " + (elapsedMs / 1000.0) + "s).");
        return result;
    }

    private void processCourseChunk(
            List<com.example.demo.utils.CourseFileStreamingParser.ParsedRow> chunk,
            String tableName,
            Long verifiedById,
            int[] counters,
            List<String> errors
    ) {
        if (chunk == null || chunk.isEmpty()) return;

        StringBuilder sql = new StringBuilder();
        sql.append("INSERT INTO ").append(tableName).append(" (")
                .append("university_id, student_name, course_code, course_name, credits, grade, ")
                .append("semester, ltps, bucket_group, course_type, academic_year, study_year, ")
                .append("section_no, register_date, course_ref, offer_to, offer_by, branch, category, status, verified_by")
                .append(") VALUES ");

        for (int i = 0; i < chunk.size(); i++) {
            if (i > 0) sql.append(", ");
            sql.append("(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        }

        sql.append(" ON CONFLICT (university_id, course_code, semester, academic_year) DO UPDATE SET ")
                .append("student_name = EXCLUDED.student_name, ")
                .append("course_name = EXCLUDED.course_name, ")
                .append("credits = EXCLUDED.credits, ")
                .append("grade = COALESCE(EXCLUDED.grade, ").append(tableName).append(".grade), ")
                .append("ltps = EXCLUDED.ltps, ")
                .append("bucket_group = EXCLUDED.bucket_group, ")
                .append("course_type = EXCLUDED.course_type, ")
                .append("study_year = EXCLUDED.study_year, ")
                .append("section_no = EXCLUDED.section_no, ")
                .append("register_date = EXCLUDED.register_date, ")
                .append("course_ref = EXCLUDED.course_ref, ")
                .append("offer_to = EXCLUDED.offer_to, ")
                .append("offer_by = EXCLUDED.offer_by, ")
                .append("branch = EXCLUDED.branch, ")
                .append("category = EXCLUDED.category, ")
                .append("status = EXCLUDED.status, ")
                .append("verified_by = EXCLUDED.verified_by, ")
                .append("updated_at = NOW();");

        try {
            jdbcTemplate.update(sql.toString(), ps -> {
                int p = 1;
                for (com.example.demo.utils.CourseFileStreamingParser.ParsedRow r : chunk) {
                    ps.setString(p++, r.universityId);
                    ps.setString(p++, r.studentName);
                    ps.setString(p++, r.courseCode);
                    ps.setString(p++, r.courseName);
                    if (r.credits != null) {
                        ps.setInt(p++, r.credits);
                    } else {
                        ps.setInt(p++, 0);
                    }
                    ps.setString(p++, r.grade);
                    ps.setString(p++, r.semester != null ? r.semester : "ODD");
                    ps.setString(p++, r.ltps);
                    ps.setString(p++, r.bucketGroup);
                    ps.setString(p++, r.courseType);
                    ps.setString(p++, r.academicYear);
                    if (r.studyYear != null) {
                        ps.setInt(p++, r.studyYear);
                    } else {
                        ps.setNull(p++, java.sql.Types.INTEGER);
                    }
                    ps.setString(p++, r.sectionNo);
                    if (r.registerDate != null) {
                        ps.setDate(p++, java.sql.Date.valueOf(r.registerDate));
                    } else {
                        ps.setNull(p++, java.sql.Types.DATE);
                    }
                    ps.setString(p++, r.courseRef);
                    ps.setString(p++, r.offerTo);
                    ps.setString(p++, r.offerBy);
                    ps.setString(p++, r.branch);
                    ps.setString(p++, r.category);
                    ps.setString(p++, r.status != null ? r.status : "Completed");
                    if (verifiedById != null) {
                        ps.setLong(p++, verifiedById);
                    } else {
                        ps.setNull(p++, java.sql.Types.BIGINT);
                    }
                }
            });
            counters[1] += chunk.size();
        } catch (Exception e) {
            counters[3] += chunk.size();
            if (errors.size() < 100) {
                errors.add("Chunk error: " + e.getMessage());
            }
            e.printStackTrace();
        }
    }

    private String mergeLtps(String oldLtps, String newLtps) {
        if (oldLtps == null || oldLtps.trim().isEmpty()) return newLtps;
        if (newLtps == null || newLtps.trim().isEmpty()) return oldLtps;
        if (oldLtps.equalsIgnoreCase(newLtps)) return oldLtps;
        return oldLtps + ", " + newLtps;
    }

    /**
     * Delete a completed course entry.
     */
    public void deleteCourse(Long courseId) {
        CompletedCourse completed = completedCourseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Completed course entry not found"));
        Long studentId = (completed.getStudent() != null) ? completed.getStudent().getId() : null;
        String courseCode = completed.getCourseCode();

        Student student = completed.getStudent();
        Map<String, Object> deletedValues = new LinkedHashMap<>();
        deletedValues.put("courseCode", completed.getCourseCode());
        deletedValues.put("courseName", completed.getCourseName());
        deletedValues.put("credits", completed.getCredits());
        deletedValues.put("grade", completed.getGrade());
        deletedValues.put("semester", completed.getSemester());
        deletedValues.put("academicYear", completed.getAcademicYear());

        completedCourseRepository.delete(completed);

        if (studentId != null && courseCode != null) {
            List<StudentCourse> scList = studentCourseRepository.findByStudentId(studentId);
            for (StudentCourse sc : scList) {
                if (courseCode.equalsIgnoreCase(sc.getCourseCode())) {
                    studentCourseRepository.delete(sc);
                }
            }
            List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(studentId, courseCode);
            if (attempts != null && !attempts.isEmpty()) {
                studentCourseAttemptRepository.deleteAll(attempts);
            }

            if (studentDegreePathRepository.findByStudentId(studentId).isPresent()) {
                try {
                    degreeEligibilityEngine.evaluateEligibility(studentId);
                } catch (Exception ignored) {}
            }
        }

        // Record audit entry for course deletion
        ActorInfo actor = resolveCurrentActor(null);
        recordCourseAudit(
                student,
                "DELETE",
                actor,
                courseId,
                courseCode,
                "Deleted course " + courseCode + " (" + (completed.getCourseName() != null ? completed.getCourseName() : "") + ")",
                deletedValues,
                null
        );
    }

    /**
     * Update an existing completed course record by Admin/Faculty.
     * Prevents changes to protected fields (id, student ownership).
     * Enforces duplicate validation.
     * Synchronizes normalized student_courses and student_course_attempts.
     * Recalculates student degree eligibility and bucket progress.
     */
    public Map<String, Object> updateCourse(Long courseId, UpdateCourseRequest request, Long verifierId) {
        if (courseId == null) {
            throw new IllegalArgumentException("Course ID must not be null.");
        }
        if (request == null) {
            throw new IllegalArgumentException("Update request body cannot be null.");
        }

        CompletedCourse completed = completedCourseRepository.findById(courseId)
                .orElseThrow(() -> new NoSuchElementException("Completed course record with ID " + courseId + " not found."));

        Student student = completed.getStudent();
        if (student == null && completed.getUniversityId() != null) {
            student = studentRepository.findByStudentId(completed.getUniversityId()).orElse(null);
        }
        if (student == null) {
            throw new IllegalStateException("Associated student record not found for course " + courseId);
        }

        // Capture snapshot of old values for audit logging
        Map<String, Object> oldValues = new LinkedHashMap<>();
        oldValues.put("courseCode", completed.getCourseCode());
        oldValues.put("courseName", completed.getCourseName());
        oldValues.put("credits", completed.getCredits());
        oldValues.put("grade", completed.getGrade());
        oldValues.put("semester", completed.getSemester());
        oldValues.put("academicYear", completed.getAcademicYear());
        oldValues.put("sectionNo", completed.getSectionNo());
        oldValues.put("status", completed.getStatus());

        // Prevent changing student ownership (protected field)
        if (request.getStudentId() != null && !request.getStudentId().equals(student.getId())) {
            throw new IllegalArgumentException("Changing student ownership of a course record is not permitted.");
        }
        if (request.getUniversityId() != null && !request.getUniversityId().trim().equalsIgnoreCase(completed.getUniversityId())) {
            throw new IllegalArgumentException("Changing student ownership of a course record is not permitted.");
        }

        if (request.getCourseCode() != null && request.getCourseCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Course code cannot be empty.");
        }

        String oldCourseCode = completed.getCourseCode();
        String newCourseCode = (request.getCourseCode() != null && !request.getCourseCode().trim().isEmpty())
                ? request.getCourseCode().trim().toUpperCase()
                : (oldCourseCode != null ? oldCourseCode.trim().toUpperCase() : "");

        if (newCourseCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Course code cannot be empty.");
        }

        String targetSemester = (request.getSemester() != null && !request.getSemester().trim().isEmpty())
                ? request.getSemester().trim()
                : completed.getSemester();
        String targetAcademicYear = (request.getAcademicYear() != null && !request.getAcademicYear().trim().isEmpty())
                ? request.getAcademicYear().trim()
                : completed.getAcademicYear();

        // Duplicate validation: check if another record for this student already has this courseCode
        List<CompletedCourse> existingStudentCourses = completedCourseRepository.findByStudentId(student.getId());
        for (CompletedCourse other : existingStudentCourses) {
            if (!other.getId().equals(courseId)) {
                if (other.getCourseCode() != null && other.getCourseCode().trim().equalsIgnoreCase(newCourseCode)) {
                    if (targetSemester != null && targetAcademicYear != null
                            && other.getSemester() != null && other.getAcademicYear() != null) {
                        if (other.getSemester().equalsIgnoreCase(targetSemester) && other.getAcademicYear().equalsIgnoreCase(targetAcademicYear)) {
                            throw new IllegalArgumentException("Another course record with code " + newCourseCode + " already exists for semester " + targetSemester + " (" + targetAcademicYear + ").");
                        }
                    } else {
                        throw new IllegalArgumentException("Another course record with code " + newCourseCode + " already exists for this student.");
                    }
                }
            }
        }

        // Validate credits if specified
        if (request.getCredits() != null) {
            if (request.getCredits() < 0 || request.getCredits() > 30) {
                throw new IllegalArgumentException("Credits must be a non-negative integer between 0 and 30.");
            }
            completed.setCredits(request.getCredits());
        }

        completed.setCourseCode(newCourseCode);

        if (request.getCourseName() != null && !request.getCourseName().trim().isEmpty()) {
            completed.setCourseName(request.getCourseName().trim());
        } else if (!newCourseCode.equalsIgnoreCase(oldCourseCode)) {
            // If course code changed and no name given, fetch name from catalog
            Optional<CourseCatalog> catOpt = courseCatalogRepository.findByCourseCode(newCourseCode);
            catOpt.ifPresent(cat -> completed.setCourseName(cat.getCourseName()));
        }

        if (request.getGrade() != null) {
            completed.setGrade(request.getGrade().trim().toUpperCase());
        }

        if (request.getSemester() != null) {
            completed.setSemester(request.getSemester().trim());
        }

        if (request.getAcademicYear() != null) {
            completed.setAcademicYear(request.getAcademicYear().trim());
        }

        if (request.getLtps() != null) {
            completed.setLtps(request.getLtps().trim());
        }

        if (request.getSectionNo() != null) {
            completed.setSectionNo(request.getSectionNo().trim());
        }

        if (request.getStatus() != null) {
            completed.setStatus(request.getStatus().trim());
        }

        if (request.getCategory() != null) {
            completed.setCategory(request.getCategory().trim());
        }

        if (request.getCourseType() != null) {
            completed.setCourseType(request.getCourseType().trim());
        }

        if (request.getBucketGroup() != null) {
            completed.setBucketGroup(request.getBucketGroup().trim());
        }

        if (request.getRegisterDate() != null && !request.getRegisterDate().trim().isEmpty()) {
            try {
                completed.setRegisterDate(parseDateSafely(null, request.getRegisterDate()));
            } catch (Exception ignored) {}
        }

        if (request.getCompletedDate() != null && !request.getCompletedDate().trim().isEmpty()) {
            try {
                completed.setCompletedDate(parseDateSafely(null, request.getCompletedDate()));
            } catch (Exception ignored) {}
        }

        if (verifierId != null) {
            completed.setVerifiedBy(verifierId);
        }

        CompletedCourse saved = completedCourseRepository.save(completed);

        // Clean up old normalized records if course code changed and no other record uses it
        if (oldCourseCode != null && !newCourseCode.equalsIgnoreCase(oldCourseCode)) {
            List<CompletedCourse> remainingOld = completedCourseRepository.findByStudentId(student.getId()).stream()
                    .filter(c -> !c.getId().equals(saved.getId()) && c.getCourseCode() != null && c.getCourseCode().equalsIgnoreCase(oldCourseCode))
                    .toList();
            if (remainingOld.isEmpty()) {
                List<StudentCourse> scList = studentCourseRepository.findByStudentId(student.getId());
                for (StudentCourse sc : scList) {
                    if (sc.getCourseCode() != null && sc.getCourseCode().equalsIgnoreCase(oldCourseCode)) {
                        studentCourseRepository.delete(sc);
                    }
                }
                List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(student.getId(), oldCourseCode);
                if (attempts != null && !attempts.isEmpty()) {
                    studentCourseAttemptRepository.deleteAll(attempts);
                }
            }
        }

        // Dual-write into normalized student_courses and student_course_attempts
        CourseCatalog catalog = resolveOrCreateCourseCatalog(
                newCourseCode,
                saved.getCourseName(),
                saved.getLtps(),
                saved.getBranch() != null ? saved.getBranch() : saved.getCategory()
        );

        syncStudentCourse(
                student,
                catalog,
                saved.getCourseName(),
                saved.getCredits() != null ? saved.getCredits().doubleValue() : 0.0,
                saved.getGrade(),
                saved.getSemester(),
                saved.getCompletedDate() != null ? saved.getCompletedDate() : saved.getRegisterDate(),
                saved.getAcademicYear()
        );

        // Recalculate degree eligibility and bucket progress
        String bucketCode = "N/A";
        String bucketName = "N/A";
        Optional<StudentDegreePath> sdpOpt = studentDegreePathRepository.findByStudentId(student.getId());
        if (sdpOpt.isPresent()) {
            try {
                degreeEligibilityEngine.evaluateEligibility(student.getId());
                Optional<BucketMaster> bucketOpt = bucketMappingEngine.resolveBucket(newCourseCode, sdpOpt.get().getDegreePath().getId());
                if (bucketOpt.isPresent()) {
                    bucketCode = bucketOpt.get().getBucketCode();
                    bucketName = bucketOpt.get().getBucketName();
                }
            } catch (Exception ignored) {}
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("message", "Course record updated successfully.");
        response.put("course", saved);
        response.put("mappedBucketCode", bucketCode);
        response.put("mappedBucketName", bucketName);

        // Record audit entry for course update
        Map<String, Object> newValues = new LinkedHashMap<>();
        newValues.put("courseCode", saved.getCourseCode());
        newValues.put("courseName", saved.getCourseName());
        newValues.put("credits", saved.getCredits());
        newValues.put("grade", saved.getGrade());
        newValues.put("semester", saved.getSemester());
        newValues.put("academicYear", saved.getAcademicYear());
        newValues.put("sectionNo", saved.getSectionNo());
        newValues.put("status", saved.getStatus());

        List<String> changeSummaries = new ArrayList<>();
        for (String k : oldValues.keySet()) {
            Object oldV = oldValues.get(k);
            Object newV = newValues.get(k);
            if (!Objects.equals(oldV, newV)) {
                changeSummaries.add(k + ": '" + oldV + "' -> '" + newV + "'");
            }
        }
        String desc = changeSummaries.isEmpty()
                ? "Updated course " + saved.getCourseCode()
                : "Updated course " + saved.getCourseCode() + " (" + String.join(", ", changeSummaries) + ")";

        ActorInfo actor = resolveCurrentActor(verifierId);
        recordCourseAudit(
                student,
                "UPDATE",
                actor,
                saved.getId(),
                saved.getCourseCode(),
                desc,
                oldValues,
                newValues
        );

        return response;
    }

    /**
     * Add student self-reported custom course.
     * Enforces duplicate validation across completed_courses and student_courses.
     * Dual-writes into normalized student_courses and student_course_attempts marked UNVERIFIED (isQualifying = false).
     * Distinguishes student self-reported courses from officially verified courses (verifiedBy remains null).
     * Triggers degree progress recalculation.
     */
    public CompletedCourse addStudentCustomCourse(Student student, String courseName, String courseCode,
                                                 String category, Integer credits, String status,
                                                 String semester, String academicYear) {
        if (student == null) {
            throw new IllegalArgumentException("Student is required.");
        }
        if (courseName == null || courseName.trim().isEmpty() ||
            courseCode == null || courseCode.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            credits == null || status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("All fields (courseName, courseCode, category, credits, status) are required.");
        }

        String cleanCode = courseCode.trim().toUpperCase();
        String sem = (semester != null && !semester.trim().isEmpty()) ? semester.trim() : "ODD";
        String acadYr = (academicYear != null && !academicYear.trim().isEmpty()) ? academicYear.trim() : student.getAcademicYear();

        // 1. Duplicate check across completed courses
        List<CompletedCourse> studentCompleted = completedCourseRepository.findByStudentId(student.getId());
        if (studentCompleted.isEmpty()) {
            studentCompleted = completedCourseRepository.findByUniversityId(student.getStudentId());
        }
        for (CompletedCourse cc : studentCompleted) {
            if (cc.getCourseCode() != null && cc.getCourseCode().trim().equalsIgnoreCase(cleanCode)) {
                if (semester != null && academicYear != null && cc.getSemester() != null && cc.getAcademicYear() != null) {
                    if (cc.getSemester().equalsIgnoreCase(sem) && cc.getAcademicYear().equalsIgnoreCase(acadYr)) {
                        throw new IllegalArgumentException("Course " + cleanCode + " already exists for semester " + sem + " (" + acadYr + ").");
                    }
                } else {
                    throw new IllegalArgumentException("Course " + cleanCode + " already exists in your academic records.");
                }
            }
        }

        // Also check student_courses
        List<StudentCourse> scList = studentCourseRepository.findByStudentId(student.getId());
        for (StudentCourse sc : scList) {
            if (sc.getCourseCode() != null && sc.getCourseCode().trim().equalsIgnoreCase(cleanCode)) {
                if (semester != null && academicYear != null && sc.getSemester() != null && sc.getAcademicYear() != null) {
                    if (sc.getSemester().equalsIgnoreCase(sem) && sc.getAcademicYear().equalsIgnoreCase(acadYr)) {
                        throw new IllegalArgumentException("Course " + cleanCode + " already exists for semester " + sem + " (" + acadYr + ").");
                    }
                } else {
                    throw new IllegalArgumentException("Course " + cleanCode + " already exists in your academic records.");
                }
            }
        }

        // 2. Save self-reported completed course
        CompletedCourse course = new CompletedCourse();
        course.setStudent(student);
        course.setUniversityId(student.getStudentId());
        course.setStudentName(student.getFirstName() + (student.getLastName() != null ? " " + student.getLastName() : ""));
        course.setCourseName(courseName.trim());
        course.setCourseCode(cleanCode);
        course.setCategory(category.trim());
        course.setCredits(credits);
        course.setStatus(status);
        if ("Completed".equalsIgnoreCase(status)) {
            course.setGrade("Pass");
        } else {
            course.setGrade("IP");
        }
        course.setSemester(sem);
        course.setAcademicYear(acadYr);
        course.setRegisterDate(LocalDate.now());
        course.setVerifiedBy(null); // Explicitly unverified

        CompletedCourse saved = completedCourseRepository.save(course);

        // 3. Dual-write into normalized student_courses and student_course_attempts
        CourseCatalog catalog = resolveOrCreateCourseCatalog(cleanCode, courseName.trim(), String.valueOf(credits), category);

        String normStatus = "Completed".equalsIgnoreCase(status) ? "UNVERIFIED" : "IN_PROGRESS";
        StudentCourse sc = new StudentCourse();
        sc.setStudent(student);
        sc.setUniversityId(student.getStudentId());
        sc.setCourse(catalog);
        sc.setCourseCode(cleanCode);
        sc.setCourseName(courseName.trim());
        sc.setCredits(credits.doubleValue());
        sc.setGrade(saved.getGrade());
        sc.setStatus(normStatus);
        sc.setSemester(sem);
        sc.setAcademicYear(acadYr);
        sc.setCompletedDate(LocalDate.now());
        studentCourseRepository.save(sc);

        StudentCourseAttempt sca = new StudentCourseAttempt();
        sca.setStudent(student);
        sca.setUniversityId(student.getStudentId());
        sca.setCourseCode(cleanCode);
        sca.setAttemptNumber(1);
        sca.setGrade(saved.getGrade());
        sca.setStatus(normStatus);
        sca.setSemester(sem);
        sca.setAcademicYear(acadYr);
        sca.setIsQualifying(false); // Unverified course is never qualifying
        studentCourseAttemptRepository.save(sca);

        // 4. Trigger progress recalculation
        if (studentDegreePathRepository.findByStudentId(student.getId()).isPresent()) {
            try {
                degreeEligibilityEngine.evaluateEligibility(student.getId());
            } catch (Exception ignored) {}
        }

        // Record audit entry for student custom course creation
        ActorInfo actor = new ActorInfo(student.getId(), student.getStudentId(), "STUDENT");
        Map<String, Object> newValues = new LinkedHashMap<>();
        newValues.put("courseCode", saved.getCourseCode());
        newValues.put("courseName", saved.getCourseName());
        newValues.put("credits", saved.getCredits());
        newValues.put("grade", saved.getGrade());
        newValues.put("semester", saved.getSemester());
        newValues.put("academicYear", saved.getAcademicYear());

        recordCourseAudit(
                student,
                "CREATE",
                actor,
                saved.getId(),
                saved.getCourseCode(),
                "Student self-reported course " + saved.getCourseCode() + " (" + saved.getCourseName() + ")",
                null,
                newValues
        );

        return saved;
    }

    /**
     * Delete student self-reported course.
     * Validates student ownership and prevents students from deleting officially verified academic records.
     * Cleans up corresponding normalized records and triggers progress recalculation.
     */
    public void deleteStudentCustomCourse(Student student, Long courseId) {
        if (student == null) {
            throw new IllegalArgumentException("Student is required.");
        }
        CompletedCourse course = completedCourseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));

        boolean authorized = false;
        if (course.getStudent() != null && course.getStudent().getId().equals(student.getId())) {
            authorized = true;
        } else if (course.getUniversityId() != null && course.getUniversityId().equalsIgnoreCase(student.getStudentId())) {
            authorized = true;
        }

        if (!authorized) {
            throw new SecurityException("You are not authorized to delete this course.");
        }

        // Students cannot delete officially verified course records
        if (course.getVerifiedBy() != null) {
            throw new IllegalStateException("Cannot delete an officially verified academic course record.");
        }

        String courseCode = course.getCourseCode();
        completedCourseRepository.delete(course);

        // Clean up normalized student_courses and attempts if no other record exists for this course
        if (courseCode != null) {
            List<CompletedCourse> remaining = completedCourseRepository.findByStudentId(student.getId());
            boolean hasRemaining = remaining.stream().anyMatch(c -> c.getCourseCode() != null && c.getCourseCode().trim().equalsIgnoreCase(courseCode.trim()));
            if (!hasRemaining) {
                List<StudentCourse> scList = studentCourseRepository.findByStudentId(student.getId());
                for (StudentCourse sc : scList) {
                    if (sc.getCourseCode() != null && sc.getCourseCode().trim().equalsIgnoreCase(courseCode.trim())) {
                        studentCourseRepository.delete(sc);
                    }
                }
                List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(student.getId(), courseCode.trim());
                if (attempts != null && !attempts.isEmpty()) {
                    studentCourseAttemptRepository.deleteAll(attempts);
                }
            }
        }

        // Recalculate progress
        if (studentDegreePathRepository.findByStudentId(student.getId()).isPresent()) {
            try {
                degreeEligibilityEngine.evaluateEligibility(student.getId());
            } catch (Exception ignored) {}
        }

        // Record audit entry for student custom course deletion
        ActorInfo actor = new ActorInfo(student.getId(), student.getStudentId(), "STUDENT");
        Map<String, Object> deletedValues = new LinkedHashMap<>();
        deletedValues.put("courseCode", course.getCourseCode());
        deletedValues.put("courseName", course.getCourseName());
        deletedValues.put("credits", course.getCredits());
        deletedValues.put("grade", course.getGrade());

        recordCourseAudit(
                student,
                "DELETE",
                actor,
                courseId,
                courseCode,
                "Student deleted self-reported course " + courseCode,
                deletedValues,
                null
        );
    }

    private void syncStudentCourse(Student student, CourseCatalog catalog, String courseName, Double credits,
                                   String grade, String semester, LocalDate completedDate, String academicYear) {
        if (student == null || catalog == null) return;

        boolean isPassing = BucketMappingEngine.isPassingGrade(grade);
        String finalStatus = isPassing ? "COMPLETED" : "FAILED";
        boolean qualifying = isPassing;

        List<StudentCourse> existingList = studentCourseRepository.findByStudentId(student.getId());
        Optional<StudentCourse> scOpt = existingList.stream()
                .filter(sc -> sc.getCourseCode().equalsIgnoreCase(catalog.getCourseCode()))
                .findFirst();

        if (!scOpt.isPresent()) {
            StudentCourse sc = new StudentCourse();
            sc.setStudent(student);
            sc.setUniversityId(student.getStudentId());
            sc.setCourse(catalog);
            sc.setCourseCode(catalog.getCourseCode());
            sc.setCourseName(courseName != null ? courseName : catalog.getCourseName());
            sc.setCredits(credits != null ? credits : (catalog.getCredits() != null ? catalog.getCredits().doubleValue() : 0.0));
            sc.setGrade(grade);
            sc.setStatus(finalStatus);
            sc.setSemester(semester != null ? semester : "ODD");
            sc.setAcademicYear(academicYear);
            sc.setCompletedDate(completedDate != null ? completedDate : LocalDate.now());
            studentCourseRepository.save(sc);

            StudentCourseAttempt sca = new StudentCourseAttempt();
            sca.setStudent(student);
            sca.setUniversityId(student.getStudentId());
            sca.setCourseCode(catalog.getCourseCode());
            sca.setAttemptNumber(1);
            sca.setGrade(grade);
            sca.setStatus(finalStatus);
            sca.setSemester(semester != null ? semester : "ODD");
            sca.setAcademicYear(academicYear);
            sca.setIsQualifying(qualifying);
            studentCourseAttemptRepository.save(sca);
        } else {
            StudentCourse sc = scOpt.get();
            if (credits != null) {
                sc.setCredits(credits);
            }
            if (courseName != null && !courseName.trim().isEmpty()) {
                sc.setCourseName(courseName.trim());
            }
            if (grade != null) {
                sc.setGrade(grade);
                sc.setStatus(finalStatus);
            }
            if (semester != null) sc.setSemester(semester);
            if (academicYear != null) sc.setAcademicYear(academicYear);
            if (completedDate != null) sc.setCompletedDate(completedDate);
            studentCourseRepository.save(sc);

            List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(student.getId(), catalog.getCourseCode());
            if (attempts != null && !attempts.isEmpty()) {
                StudentCourseAttempt sca = attempts.get(attempts.size() - 1);
                sca.setGrade(grade);
                sca.setStatus(finalStatus);
                sca.setIsQualifying(qualifying);
                if (semester != null) sca.setSemester(semester);
                if (academicYear != null) sca.setAcademicYear(academicYear);
                studentCourseAttemptRepository.save(sca);
            }
        }
    }

    /**
     * Get completed courses for a student by ID or university ID.
     */
    public List<CompletedCourse> getStudentCourses(Long studentId) {
        List<CompletedCourse> list = completedCourseRepository.findByStudentIdOrderByRegisterDateDesc(studentId);
        if (list.isEmpty()) {
            Optional<Student> sOpt = studentRepository.findById(studentId);
            if (sOpt.isPresent()) {
                return completedCourseRepository.findByUniversityIdOrderByRegisterDateDesc(sOpt.get().getStudentId());
            }
        }
        return list;
    }

    public List<CompletedCourse> getStudentCoursesByUniversityId(String universityId) {
        return completedCourseRepository.findByUniversityIdOrderByRegisterDateDesc(universityId);
    }

    /**
     * Generate Excel template for bulk completed course uploads (16 columns).
     */
    public byte[] generateTemplate() throws Exception {
        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Template");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("UNIVERSITY ID");
            header.createCell(1).setCellValue("STUDENT NAME");
            header.createCell(2).setCellValue("COURSE CODE");
            header.createCell(3).setCellValue("LTPS");
            header.createCell(4).setCellValue("COURSE NAME");
            header.createCell(5).setCellValue("BUCKET GROUP");
            header.createCell(6).setCellValue("COURSE TYPE");
            header.createCell(7).setCellValue("ACADEMIC YEAR");
            header.createCell(8).setCellValue("SEMESTER");
            header.createCell(9).setCellValue("STUDY YEAR");
            header.createCell(10).setCellValue("SECTION");
            header.createCell(11).setCellValue("REGISTER DATE");
            header.createCell(12).setCellValue("COURSE REF");
            header.createCell(13).setCellValue("OFFERED TO");
            header.createCell(14).setCellValue("OFFERED BY");
            header.createCell(15).setCellValue("BRANCH");

            for (int i = 0; i < 16; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            return out.toByteArray();
        }
    }

    private String getCellString(Cell cell) {
        if (cell == null) return null;
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue().trim();
            case NUMERIC -> {
                if (DateUtil.isCellDateFormatted(cell)) {
                    yield cell.getLocalDateTimeCellValue().toLocalDate().toString();
                }
                yield String.valueOf((long) cell.getNumericCellValue());
            }
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            case FORMULA -> {
                try {
                    yield cell.getStringCellValue().trim();
                } catch (Exception e) {
                    yield String.valueOf((long) cell.getNumericCellValue());
                }
            }
            default -> null;
        };
    }

    private LocalDate parseDateSafely(Cell cell, String val) {
        if (cell != null && cell.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cell)) {
            return cell.getLocalDateTimeCellValue().toLocalDate();
        }
        if (val == null || val.trim().isEmpty()) {
            return LocalDate.now();
        }
        List<String> formats = Arrays.asList("yyyy-MM-dd", "dd-MM-yyyy", "MM/dd/yyyy", "dd/MM/yyyy", "yyyy/MM/dd", "dd-MM-yy", "d-MMM-yyyy", "dd-MMM-yyyy");
        for (String format : formats) {
            try {
                return LocalDate.parse(val.trim(), DateTimeFormatter.ofPattern(format, Locale.ENGLISH));
            } catch (Exception ignored) {}
        }
        return LocalDate.now();
    }

    public record ActorInfo(Long id, String username, String role) {}

    public ActorInfo resolveCurrentActor(Long fallbackId) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
                String principalName = auth.getName();
                String role = auth.getAuthorities().stream()
                        .findFirst()
                        .map(GrantedAuthority::getAuthority)
                        .orElse("UNKNOWN");

                if (role.startsWith("ROLE_")) {
                    role = role.substring(5);
                }

                // Check Admin
                Optional<Admin> adminOpt = adminRepository.findByUsername(principalName);
                if (adminOpt.isPresent()) {
                    return new ActorInfo(adminOpt.get().getId(), adminOpt.get().getUsername(), "ADMIN");
                }

                // Check Faculty
                Optional<Faculty> facOpt = facultyRepository.findByEmail(principalName);
                if (!facOpt.isPresent()) {
                    facOpt = facultyRepository.findByUsername(principalName);
                }
                if (facOpt.isPresent()) {
                    String facName = facOpt.get().getUsername() != null ? facOpt.get().getUsername() : (facOpt.get().getFirstName() + " " + (facOpt.get().getLastName() != null ? facOpt.get().getLastName() : ""));
                    return new ActorInfo(facOpt.get().getId(), facName.trim(), "FACULTY");
                }

                // Check Student
                Optional<Student> stuOpt = studentRepository.findByStudentId(principalName);
                if (!stuOpt.isPresent()) {
                    stuOpt = studentRepository.findByEmail(principalName);
                }
                if (stuOpt.isPresent()) {
                    return new ActorInfo(stuOpt.get().getId(), stuOpt.get().getStudentId(), "STUDENT");
                }

                return new ActorInfo(fallbackId, principalName, role);
            }
        } catch (Exception ignored) {}

        if (fallbackId != null) {
            Optional<Admin> admin = adminRepository.findById(fallbackId);
            if (admin.isPresent()) {
                return new ActorInfo(admin.get().getId(), admin.get().getUsername(), "ADMIN");
            }
            Optional<Faculty> faculty = facultyRepository.findById(fallbackId);
            if (faculty.isPresent()) {
                String facName = faculty.get().getUsername() != null ? faculty.get().getUsername() : (faculty.get().getFirstName() + " " + (faculty.get().getLastName() != null ? faculty.get().getLastName() : ""));
                return new ActorInfo(faculty.get().getId(), facName.trim(), "FACULTY");
            }
            return new ActorInfo(fallbackId, "USER_" + fallbackId, "ADMIN");
        }

        return new ActorInfo(null, "SYSTEM", "SYSTEM");
    }

    public void recordCourseAudit(Student student, String actionType, ActorInfo actor, Long courseId,
                                  String courseCode, String description,
                                  Map<String, Object> oldValues, Map<String, Object> newValues) {
        try {
            AuditHistory audit = new AuditHistory();
            audit.setStudent(student);
            audit.setActionType(actionType != null ? actionType.toUpperCase() : "UNKNOWN");
            audit.setPerformedBy(actor != null ? actor.id() : null);

            Map<String, Object> payloadMap = new LinkedHashMap<>();
            payloadMap.put("courseId", courseId);
            payloadMap.put("courseCode", courseCode);
            payloadMap.put("actorUsername", actor != null ? actor.username() : "SYSTEM");
            payloadMap.put("actorRole", actor != null ? actor.role() : "SYSTEM");
            payloadMap.put("description", description);
            if (oldValues != null && !oldValues.isEmpty()) {
                payloadMap.put("oldValues", oldValues);
            }

            Map<String, Object> resultMap = new LinkedHashMap<>();
            resultMap.put("status", "SUCCESS");
            if (newValues != null && !newValues.isEmpty()) {
                resultMap.put("newValues", newValues);
            }

            audit.setPayload(objectMapper.writeValueAsString(payloadMap));
            audit.setResult(objectMapper.writeValueAsString(resultMap));
            audit.setCreatedAt(LocalDateTime.now());

            auditHistoryRepository.save(audit);
        } catch (Exception e) {
            // Re-throw so transaction rolls back if audit fails in transactional context
            throw new RuntimeException("Failed to record audit history: " + e.getMessage(), e);
        }
    }

    public List<AuditHistoryResponse> getAuditHistoryForStudent(Long studentId) {
        List<AuditHistory> audits = auditHistoryRepository.findByStudentIdOrderByCreatedAtDesc(studentId);
        return audits.stream().map(this::toAuditResponse).toList();
    }

    public List<AuditHistoryResponse> getAllAuditHistory() {
        List<AuditHistory> audits = auditHistoryRepository.findAllByOrderByCreatedAtDesc();
        return audits.stream().map(this::toAuditResponse).toList();
    }

    private AuditHistoryResponse toAuditResponse(AuditHistory audit) {
        String actorUsername = null;
        String actorRole = null;
        Long courseId = null;
        String courseCode = null;
        String description = null;
        Map<String, Object> oldValues = null;
        Map<String, Object> newValues = null;

        if (audit.getPayload() != null && !audit.getPayload().trim().isEmpty()) {
            try {
                Map<String, Object> p = objectMapper.readValue(audit.getPayload(), new com.fasterxml.jackson.core.type.TypeReference<Map<String, Object>>() {});
                if (p.containsKey("actorUsername")) actorUsername = String.valueOf(p.get("actorUsername"));
                if (p.containsKey("actorRole")) actorRole = String.valueOf(p.get("actorRole"));
                if (p.containsKey("courseId") && p.get("courseId") != null) courseId = Long.valueOf(p.get("courseId").toString());
                if (p.containsKey("courseCode")) courseCode = String.valueOf(p.get("courseCode"));
                if (p.containsKey("description")) description = String.valueOf(p.get("description"));
                if (p.containsKey("oldValues") && p.get("oldValues") instanceof Map) {
                    //noinspection unchecked
                    oldValues = (Map<String, Object>) p.get("oldValues");
                }
            } catch (Exception ignored) {}
        }

        if (audit.getResult() != null && !audit.getResult().trim().isEmpty()) {
            try {
                Map<String, Object> r = objectMapper.readValue(audit.getResult(), new com.fasterxml.jackson.core.type.TypeReference<Map<String, Object>>() {});
                if (r.containsKey("newValues") && r.get("newValues") instanceof Map) {
                    //noinspection unchecked
                    newValues = (Map<String, Object>) r.get("newValues");
                }
            } catch (Exception ignored) {}
        }

        Student student = audit.getStudent();
        return AuditHistoryResponse.builder()
                .id(audit.getId())
                .studentId(student != null ? student.getId() : null)
                .universityId(student != null ? student.getStudentId() : null)
                .studentName(student != null ? (student.getFirstName() + " " + (student.getLastName() != null ? student.getLastName() : "")).trim() : null)
                .actionType(audit.getActionType())
                .performedBy(audit.getPerformedBy())
                .actorUsername(actorUsername)
                .actorRole(actorRole)
                .courseId(courseId)
                .courseCode(courseCode)
                .description(description)
                .oldValues(oldValues)
                .newValues(newValues)
                .payload(audit.getPayload())
                .result(audit.getResult())
                .createdAt(audit.getCreatedAt())
                .build();
    }
}
