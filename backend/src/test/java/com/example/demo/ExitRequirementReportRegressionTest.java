package com.example.demo;

import com.example.demo.controller.ExitRequirementController;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.ExitRequirementPdfService;
import com.example.demo.service.Y23AidsCurriculumSeeder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class ExitRequirementReportRegressionTest {

    @Autowired private ExitRequirementPdfService exitRequirementPdfService;
    @Autowired private ExitRequirementController exitRequirementController;
    @Autowired private StudentRepository studentRepository;
    @Autowired private DegreePathRepository degreePathRepository;
    @Autowired private StudentDegreePathRepository studentDegreePathRepository;
    @Autowired private StudentBucketProgressRepository studentBucketProgressRepository;
    @Autowired private StudentCourseRepository studentCourseRepository;
    @Autowired private CourseCatalogRepository courseCatalogRepository;
    @Autowired private CurriculumCourseRepository curriculumCourseRepository;
    @Autowired private CurriculumCourseMappingRepository curriculumCourseMappingRepository;
    @Autowired private BucketMasterRepository bucketMasterRepository;
    @Autowired private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;
    @Autowired private com.example.demo.service.ExitRequirementService exitRequirementService;
    @Autowired private com.example.demo.service.ReportService reportService;
    @Autowired private com.example.demo.service.DegreePathEngine degreePathEngine;
    @Autowired private StudentDegreeStatusRepository studentDegreeStatusRepository;

    private Student testStudent;
    private DegreePath testPath;
    private CurriculumVersion testVersion;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();

        testPath = degreePathRepository.findAll().stream()
                .filter(p -> "CSE-HTE-MINOR".equals(p.getPathCode()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("CSE-HTE-MINOR path must exist"));

        testVersion = testPath.getCurriculumVersion();

        // Create a unique test student
        testStudent = studentRepository.findByStudentId("TEST_EXIT_STUDENT_01").orElseGet(() -> {
            Student s = new Student();
            s.setStudentId("TEST_EXIT_STUDENT_01");
            s.setFirstName("Exit");
            s.setLastName("Student");
            s.setEmail("exit.student01@example.com");
            s.setPassword("secret");
            s.setDepartment("CSE");
            s.setAcademicYear("2023-2027");
            return studentRepository.save(s);
        });

        // Assign degree path
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(testStudent.getId())
                .orElse(new StudentDegreePath());
        sdp.setStudent(testStudent);
        sdp.setDegreePath(testPath);
        sdp.setIsConfirmed(true);
        studentDegreePathRepository.save(sdp);

        // Ensure clean state: delete any pre-existing progress for this test student
        List<StudentBucketProgress> existing = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(testStudent.getId(), testPath.getId());
        if (!existing.isEmpty()) {
            studentBucketProgressRepository.deleteAll(existing);
        }

        List<StudentCourse> existingCourses = studentCourseRepository.findByStudentId(testStudent.getId());
        if (!existingCourses.isEmpty()) {
            studentCourseRepository.deleteAll(existingCourses);
        }
    }

    @Test
    @DisplayName("Regression Test 1: Student without pre-calculated bucket progress generates progress on-the-fly without SQLState 25006/25P02")
    public void testStudentWithoutPreCalculatedBucketProgress() {
        // Confirm no bucket progress exists before the call
        List<StudentBucketProgress> initialProgress = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(testStudent.getId(), testPath.getId());
        assertTrue(initialProgress.isEmpty(), "Student must initially have NO bucket progress records");

        // Add a completed course for this student
        addCourse(testStudent, "23CS2101", "Data Structures", 4.0, "PCC");

        // Invoke exit requirement report generation
        Map<String, Object> reportData = exitRequirementPdfService.getStudentExitRequirementReportData(testStudent.getStudentId());

        assertNotNull(reportData, "Report data must not be null");
        assertTrue(reportData.containsKey("student"), "Report data must contain student info");
        assertTrue(reportData.containsKey("summary"), "Report data must contain summary info");
        assertTrue(reportData.containsKey("categories"), "Report data must contain categories");

        @SuppressWarnings("unchecked")
        Map<String, Object> summary = (Map<String, Object>) reportData.get("summary");
        int totalRequired = (int) summary.get("totalRequiredCredits");
        int totalObtained = (int) summary.get("totalObtainedCredits");
        int totalRemaining = (int) summary.get("totalRemainingCredits");
        assertTrue(totalRequired > 0, "Total required credits must be greater than 0");
        assertEquals(4, totalObtained, "Total obtained credits must be exactly 4 from the completed course");
        assertEquals(Math.max(0, totalRequired - 4), totalRemaining, "Total remaining credits must reflect obtained credits deducted");
        assertEquals(false, summary.get("isEligible"), "Student with 4 credits must not be eligible");

        // Verify categories and course details
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> categories = (List<Map<String, Object>>) reportData.get("categories");
        assertNotNull(categories, "Categories list must not be null");
        assertFalse(categories.isEmpty(), "Categories list must not be empty");

        Map<String, Object> pccCategory = categories.stream()
                .filter(c -> "PCC".equals(c.get("categoryCode")))
                .findFirst()
                .orElseThrow(() -> new AssertionError("PCC category must be present in report"));

        assertEquals(4, pccCategory.get("obtainedCredits"), "PCC category obtained credits must be 4");

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> pccCourses = (List<Map<String, Object>>) pccCategory.get("courses");
        assertNotNull(pccCourses, "PCC courses list must not be null");
        assertEquals(1, pccCourses.size(), "PCC courses count must be exactly 1");
        assertEquals("23CS2101", pccCourses.get(0).get("courseCode"));
        assertEquals("Data Structures", pccCourses.get(0).get("courseName"));
        assertEquals(4, pccCourses.get(0).get("credits"));

        // Verify that bucket progress was generated and saved to the database on-the-fly
        List<StudentBucketProgress> savedProgress = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(testStudent.getId(), testPath.getId());
        assertFalse(savedProgress.isEmpty(), "Bucket progress rows must now be saved in student_bucket_progress");

        // Verify downstream studentCourseRepository.findByStudentId executed successfully without transaction abort
        List<StudentCourse> studentCourses = studentCourseRepository.findByStudentId(testStudent.getId());
        assertFalse(studentCourses.isEmpty(), "Student courses must be accessible and query must not be aborted");
        assertEquals(1, studentCourses.size(), "Student courses count must be 1");
    }

    @Test
    @DisplayName("Regression Test 2: Student with previously calculated bucket-progress rows succeeds cleanly")
    public void testStudentWithPreCalculatedBucketProgress() {
        // Pre-evaluate progress first
        addCourse(testStudent, "23CS2101", "Data Structures", 4.0, "PCC");
        exitRequirementPdfService.getStudentExitRequirementReportData(testStudent.getStudentId());

        List<StudentBucketProgress> preExisting = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(testStudent.getId(), testPath.getId());
        assertFalse(preExisting.isEmpty(), "Pre-existing progress must exist");
        int preCount = preExisting.size();

        // Subsequent call should reuse pre-existing progress without error
        Map<String, Object> reportData = exitRequirementPdfService.getStudentExitRequirementReportData(testStudent.getStudentId());
        assertNotNull(reportData);

        @SuppressWarnings("unchecked")
        Map<String, Object> summary = (Map<String, Object>) reportData.get("summary");
        assertEquals(4, summary.get("totalObtainedCredits"), "Obtained credits must be 4");

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> categories = (List<Map<String, Object>>) reportData.get("categories");
        Map<String, Object> pccCategory = categories.stream()
                .filter(c -> "PCC".equals(c.get("categoryCode")))
                .findFirst()
                .orElseThrow(() -> new AssertionError("PCC category must be present"));
        assertEquals(4, pccCategory.get("obtainedCredits"));
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> pccCourses = (List<Map<String, Object>>) pccCategory.get("courses");
        assertEquals(1, pccCourses.size());

        List<StudentBucketProgress> postCall = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(testStudent.getId(), testPath.getId());
        assertEquals(preCount, postCall.size(), "Bucket progress row count should remain consistent");
    }

    @Test
    @DisplayName("Regression Test 3: Student with no course records handles progress safely with 0 earned credits")
    public void testStudentWithNoCourseRecords() {
        // Create student with degree path but 0 courses
        Student cleanStudent = studentRepository.findByStudentId("TEST_EMPTY_STUDENT").orElseGet(() -> {
            Student s = new Student();
            s.setStudentId("TEST_EMPTY_STUDENT");
            s.setFirstName("Empty");
            s.setLastName("Student");
            s.setEmail("empty.student@example.com");
            s.setPassword("secret");
            s.setDepartment("CSE");
            return studentRepository.save(s);
        });

        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(cleanStudent.getId())
                .orElse(new StudentDegreePath());
        sdp.setStudent(cleanStudent);
        sdp.setDegreePath(testPath);
        sdp.setIsConfirmed(true);
        studentDegreePathRepository.save(sdp);

        // Clear any pre-existing progress for clean student
        List<StudentBucketProgress> emptyProgress = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(cleanStudent.getId(), testPath.getId());
        if (!emptyProgress.isEmpty()) {
            studentBucketProgressRepository.deleteAll(emptyProgress);
        }

        Map<String, Object> reportData = exitRequirementPdfService.getStudentExitRequirementReportData(cleanStudent.getStudentId());
        assertNotNull(reportData);

        @SuppressWarnings("unchecked")
        Map<String, Object> summary = (Map<String, Object>) reportData.get("summary");
        assertEquals(0, summary.get("totalObtainedCredits"), "Obtained credits must be 0 for student with no courses");
        assertEquals(false, summary.get("isEligible"), "Student with no courses must not be eligible for graduation");

        // Verify all categories have 0 obtained credits and empty courses
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> categories = (List<Map<String, Object>>) reportData.get("categories");
        int totalCategoryCredits = categories.stream()
                .mapToInt(c -> (int) c.get("obtainedCredits"))
                .sum();
        assertEquals(0, totalCategoryCredits, "Total credits across all categories must be 0");
        long totalCourses = categories.stream()
                .mapToLong(c -> ((List<?>) c.get("courses")).size())
                .sum();
        assertEquals(0, totalCourses, "Total courses across all categories must be 0");

        // Verify missing bucket progress was generated and saved for the empty student
        List<StudentBucketProgress> generated = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(cleanStudent.getId(), testPath.getId());
        assertFalse(generated.isEmpty(), "Bucket progress rows should be generated even for students with 0 courses");
    }

    @Test
    @DisplayName("Regression Test 4: PDF generation flow succeeds and produces valid PDF header")
    public void testPdfGenerationFlow() throws Exception {
        addCourse(testStudent, "23CS2101", "Data Structures", 4.0, "PCC");

        byte[] pdfBytes = exitRequirementPdfService.generateStudentExitRequirementPdf(testStudent.getStudentId());
        assertNotNull(pdfBytes, "Generated PDF bytes must not be null");
        assertTrue(pdfBytes.length > 500, "PDF must not be empty");

        // Verify PDF Magic Bytes (%PDF-)
        String header = new String(pdfBytes, 0, Math.min(5, pdfBytes.length));
        assertEquals("%PDF-", header, "Generated document must start with '%PDF-'");

        // Verify bucket progress rows were generated during PDF generation
        List<StudentBucketProgress> savedProgress = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(testStudent.getId(), testPath.getId());
        assertFalse(savedProgress.isEmpty(), "Bucket progress must be persisted during PDF generation");
    }

    @Test
    @DisplayName("Regression Test 5: Controller endpoints return HTTP 200 for report data and PDF download")
    public void testControllerEndpoints() {
        org.springframework.security.core.context.SecurityContextHolder.getContext().setAuthentication(
                new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(
                        "superadmin", "pass",
                        List.of(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_SUPER_ADMIN"))
                )
        );

        addCourse(testStudent, "23CS2101", "Data Structures", 4.0, "PCC");

        // Admin report endpoint
        ResponseEntity<?> reportResponse = exitRequirementController.getAdminExitReport(testStudent.getStudentId());
        assertEquals(HttpStatus.OK, reportResponse.getStatusCode(), "Controller must return HTTP 200 for admin exit report");
        assertNotNull(reportResponse.getBody());

        // Faculty report endpoint
        ResponseEntity<?> facultyReport = exitRequirementController.getFacultyExitReport(testStudent.getStudentId());
        assertEquals(HttpStatus.OK, facultyReport.getStatusCode(), "Controller must return HTTP 200 for faculty exit report");
        assertNotNull(facultyReport.getBody());

        // Admin PDF download
        ResponseEntity<byte[]> pdfResponse = exitRequirementController.downloadAdminExitPdf(testStudent.getStudentId());
        assertEquals(HttpStatus.OK, pdfResponse.getStatusCode(), "Controller must return HTTP 200 for admin PDF download");
        assertNotNull(pdfResponse.getBody());
        assertTrue(pdfResponse.getBody().length > 500);
        assertEquals("%PDF-", new String(pdfResponse.getBody(), 0, 5));

        // Faculty PDF download
        ResponseEntity<byte[]> facultyPdf = exitRequirementController.downloadFacultyExitPdf(testStudent.getStudentId());
        assertEquals(HttpStatus.OK, facultyPdf.getStatusCode(), "Controller must return HTTP 200 for faculty PDF download");
        assertNotNull(facultyPdf.getBody());
        assertEquals("%PDF-", new String(facultyPdf.getBody(), 0, 5));

        // Student report & PDF download using authenticated student context
        org.springframework.security.core.context.SecurityContextHolder.getContext().setAuthentication(
                new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(
                        testStudent.getStudentId(), "pass",
                        List.of(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_STUDENT"))
                )
        );

        ResponseEntity<?> studentReport = exitRequirementController.getStudentExitReport();
        assertEquals(HttpStatus.OK, studentReport.getStatusCode(), "Controller must return HTTP 200 for student exit report");
        assertNotNull(studentReport.getBody());

        ResponseEntity<byte[]> studentPdf = exitRequirementController.downloadStudentExitPdf();
        assertEquals(HttpStatus.OK, studentPdf.getStatusCode(), "Controller must return HTTP 200 for student PDF download");
        assertNotNull(studentPdf.getBody());
        assertEquals("%PDF-", new String(studentPdf.getBody(), 0, 5));

        org.springframework.security.core.context.SecurityContextHolder.clearContext();
    }

    @Test
    @DisplayName("Regression Test 6: Verify ExitRequirementPdfService transaction configuration is read-write")
    public void testTransactionConfiguration() {
        Transactional tx = ExitRequirementPdfService.class.getAnnotation(Transactional.class);
        assertNotNull(tx, "ExitRequirementPdfService must be annotated with @Transactional");
        assertFalse(tx.readOnly(), "ExitRequirementPdfService @Transactional must NOT be readOnly = true");

        Transactional reportTx = com.example.demo.service.ReportService.class.getAnnotation(Transactional.class);
        assertNotNull(reportTx, "ReportService must be annotated with @Transactional");
        assertFalse(reportTx.readOnly(), "ReportService @Transactional must NOT be readOnly = true");
    }

    @Test
    @DisplayName("Regression Test 7: Student who has never logged in (firstLoginCompleted=false, no degree path) can view report without transaction abort")
    public void testNeverLoggedInStudentReportGeneration() {
        // Create student who has never logged in and has NO assigned degree path
        String studentRoll = "TEST_NEVER_LOGGED_IN_01";
        Student freshStudent = studentRepository.findByStudentId(studentRoll).orElseGet(() -> {
            Student s = new Student();
            s.setStudentId(studentRoll);
            s.setFirstName("NeverLoggedIn");
            s.setLastName("Student");
            s.setEmail("never.logged.in@example.com");
            s.setPassword("secret");
            s.setDepartment("CSE");
            s.setAcademicYear("2023-2027");
            s.setFirstLoginCompleted(false);
            return studentRepository.save(s);
        });

        // Ensure NO degree path and NO bucket progress exist initially
        studentDegreePathRepository.findByStudentId(freshStudent.getId())
                .ifPresent(sdp -> studentDegreePathRepository.delete(sdp));
        List<StudentBucketProgress> initialProgress = studentBucketProgressRepository.findAll().stream()
                .filter(p -> p.getStudent() != null && freshStudent.getId().equals(p.getStudent().getId()))
                .toList();
        if (!initialProgress.isEmpty()) {
            studentBucketProgressRepository.deleteAll(initialProgress);
        }

        assertTrue(studentDegreePathRepository.findByStudentId(freshStudent.getId()).isEmpty(),
                "Student must initially have NO degree path assigned");
        assertEquals(false, freshStudent.getFirstLoginCompleted(),
                "firstLoginCompleted must initially be false");

        // Add a course for this student
        addCourse(freshStudent, "23CS2101", "Data Structures", 4.0, "PCC");

        // Generate report for this student who has never logged in
        Map<String, Object> reportData = exitRequirementPdfService.getStudentExitRequirementReportData(freshStudent.getStudentId());

        assertNotNull(reportData, "Report data must be returned");
        assertTrue(reportData.containsKey("student"));
        assertTrue(reportData.containsKey("summary"));
        assertTrue(reportData.containsKey("categories"));

        @SuppressWarnings("unchecked")
        Map<String, Object> summary = (Map<String, Object>) reportData.get("summary");
        int totalObtained = (int) summary.get("totalObtainedCredits");
        assertEquals(4, totalObtained, "Obtained credits must be 4");

        // Verify that degree path was safely auto-assigned
        Optional<StudentDegreePath> assignedPath = studentDegreePathRepository.findByStudentId(freshStudent.getId());
        assertTrue(assignedPath.isPresent(), "Degree path must be safely auto-assigned during report generation");
        assertNotNull(assignedPath.get().getDegreePath(), "Assigned degree path must not be null");

        // Verify bucket progress rows were safely persisted
        List<StudentBucketProgress> savedProgress = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(freshStudent.getId(), assignedPath.get().getDegreePath().getId());
        assertFalse(savedProgress.isEmpty(), "Bucket progress rows must be initialized and persisted");

        // Verify firstLoginCompleted was NOT modified (remains false)
        Student reloaded = studentRepository.findById(freshStudent.getId()).orElseThrow();
        assertEquals(false, reloaded.getFirstLoginCompleted(),
                "firstLoginCompleted must remain false even after admin viewed report");

        // Verify downstream studentCourseRepository.findByStudentId executes without transaction abort
        List<StudentCourse> courses = studentCourseRepository.findByStudentId(freshStudent.getId());
        assertFalse(courses.isEmpty(), "Downstream query must succeed on clean transaction");
    }

    @Test
    @DisplayName("Regression Test 8: Repeated report requests for never-logged-in student are idempotent without duplicate rows")
    public void testNeverLoggedInStudentIdempotency() {
        String studentRoll = "TEST_NEVER_LOGGED_IN_02";
        Student student = studentRepository.findByStudentId(studentRoll).orElseGet(() -> {
            Student s = new Student();
            s.setStudentId(studentRoll);
            s.setFirstName("Idempotent");
            s.setLastName("Student");
            s.setEmail("idempotent.student@example.com");
            s.setPassword("secret");
            s.setDepartment("CSE");
            s.setAcademicYear("2023-2027");
            s.setFirstLoginCompleted(false);
            return studentRepository.save(s);
        });

        studentDegreePathRepository.findByStudentId(student.getId())
                .ifPresent(sdp -> studentDegreePathRepository.delete(sdp));

        addCourse(student, "23CS2101", "Data Structures", 4.0, "PCC");

        // First call
        Map<String, Object> report1 = exitRequirementPdfService.getStudentExitRequirementReportData(student.getStudentId());
        assertNotNull(report1);

        Optional<StudentDegreePath> path1 = studentDegreePathRepository.findByStudentId(student.getId());
        assertTrue(path1.isPresent());
        List<StudentBucketProgress> progress1 = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(student.getId(), path1.get().getDegreePath().getId());
        assertFalse(progress1.isEmpty());
        int progressCount1 = progress1.size();

        // Second call (repeated)
        Map<String, Object> report2 = exitRequirementPdfService.getStudentExitRequirementReportData(student.getStudentId());
        assertNotNull(report2);

        // Verify exactly one degree path and consistent progress count (no duplicate rows)
        Optional<StudentDegreePath> path2 = studentDegreePathRepository.findByStudentId(student.getId());
        assertTrue(path2.isPresent());
        assertEquals(path1.get().getId(), path2.get().getId(), "Degree path ID must remain identical");

        List<StudentBucketProgress> progress2 = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(student.getId(), path2.get().getDegreePath().getId());
        assertEquals(progressCount1, progress2.size(), "Bucket progress row count must remain consistent (no duplicates)");

        Student reloaded = studentRepository.findById(student.getId()).orElseThrow();
        assertEquals(false, reloaded.getFirstLoginCompleted(), "firstLoginCompleted must remain false");
    }

    @Test
    @DisplayName("Regression Test 9: Admin exit clearance and controller endpoints work for never-logged-in student")
    public void testAdminExitClearanceEndpointsForNeverLoggedInStudent() {
        String studentRoll = "TEST_NEVER_LOGGED_IN_03";
        Student student = studentRepository.findByStudentId(studentRoll).orElseGet(() -> {
            Student s = new Student();
            s.setStudentId(studentRoll);
            s.setFirstName("Clearance");
            s.setLastName("Student");
            s.setEmail("clearance.student@example.com");
            s.setPassword("secret");
            s.setDepartment("CSE");
            s.setAcademicYear("2023-2027");
            s.setFirstLoginCompleted(false);
            return studentRepository.save(s);
        });

        studentDegreePathRepository.findByStudentId(student.getId())
                .ifPresent(sdp -> studentDegreePathRepository.delete(sdp));

        addCourse(student, "23CS2101", "Data Structures", 4.0, "PCC");

        org.springframework.security.core.context.SecurityContextHolder.getContext().setAuthentication(
                new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(
                        "superadmin", "pass",
                        List.of(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_SUPER_ADMIN"))
                )
        );

        // Admin report endpoint
        ResponseEntity<?> reportResp = exitRequirementController.getAdminExitReport(student.getStudentId());
        assertEquals(HttpStatus.OK, reportResp.getStatusCode());
        assertNotNull(reportResp.getBody());

        // Admin PDF endpoint
        ResponseEntity<byte[]> pdfResp = exitRequirementController.downloadAdminExitPdf(student.getStudentId());
        assertEquals(HttpStatus.OK, pdfResp.getStatusCode());
        assertNotNull(pdfResp.getBody());
        assertEquals("%PDF-", new String(pdfResp.getBody(), 0, 5));

        // Admin clearance detail endpoint
        ResponseEntity<?> detailResp = exitRequirementController.getStudentExitDetailForAdmin(student.getId());
        assertEquals(HttpStatus.OK, detailResp.getStatusCode());
        assertNotNull(detailResp.getBody());

        // Student firstLoginCompleted must still be false
        Student reloaded = studentRepository.findById(student.getId()).orElseThrow();
        assertEquals(false, reloaded.getFirstLoginCompleted(), "firstLoginCompleted must remain false");

        org.springframework.security.core.context.SecurityContextHolder.clearContext();
    }

    @Test
    @DisplayName("Regression Test 10: ReportService read-write transaction executes without transaction abort for never-logged-in student")
    public void testReportServiceForNeverLoggedInStudent() {
        String studentRoll = "TEST_NEVER_LOGGED_IN_04";
        Student student = studentRepository.findByStudentId(studentRoll).orElseGet(() -> {
            Student s = new Student();
            s.setStudentId(studentRoll);
            s.setFirstName("ReportService");
            s.setLastName("Student");
            s.setEmail("reportservice.student@example.com");
            s.setPassword("secret");
            s.setDepartment("CSE");
            s.setAcademicYear("2023-2027");
            s.setFirstLoginCompleted(false);
            return studentRepository.save(s);
        });

        studentDegreePathRepository.findByStudentId(student.getId())
                .ifPresent(sdp -> studentDegreePathRepository.delete(sdp));

        addCourse(student, "23CS2101", "Data Structures", 4.0, "PCC");

        Map<String, Object> report = reportService.getStudentReport(student.getId());
        assertNotNull(report, "Student report must not be null");
        assertTrue(report.containsKey("status"));
        assertTrue(report.containsKey("buckets"));

        Student reloaded = studentRepository.findById(student.getId()).orElseThrow();
        assertEquals(false, reloaded.getFirstLoginCompleted(), "firstLoginCompleted must remain false");
    }

    @Test
    @DisplayName("Regression Test 11: Ambiguous or unknown department student is not silently assigned an arbitrary degree path")
    public void testAmbiguousDepartmentNotSilentlyAssigned() {
        String studentRoll = "TEST_AMBIGUOUS_DEPT_01";
        Student student = studentRepository.findByStudentId(studentRoll).orElseGet(() -> {
            Student s = new Student();
            s.setStudentId(studentRoll);
            s.setFirstName("Ambiguous");
            s.setLastName("Student");
            s.setEmail("ambiguous@example.com");
            s.setPassword("secret");
            s.setDepartment("UNKNOWN_DEP_XYZ");
            s.setAcademicYear("2023-2027");
            s.setFirstLoginCompleted(false);
            return studentRepository.save(s);
        });

        studentDegreePathRepository.findByStudentId(student.getId())
                .ifPresent(sdp -> studentDegreePathRepository.delete(sdp));

        // Attempting to resolve and assign must throw an actionable exception and route to review queue
        RuntimeException ex = assertThrows(RuntimeException.class, () -> {
            degreePathEngine.resolveAndAssignPath(student.getId());
        });
        assertTrue(ex.getMessage().contains("ambiguous department") || ex.getMessage().contains("review queue"));

        // Must NOT silently assign any degree path
        Optional<StudentDegreePath> sdp = studentDegreePathRepository.findByStudentId(student.getId());
        assertTrue(sdp.isEmpty(), "Ambiguous student must NOT have any degree path assigned");
    }

    private void addCourse(Student student, String code, String name, double credits, String bucketCode) {
        CourseCatalog catalog = courseCatalogRepository.findByCourseCode(code).orElseGet(() -> {
            CourseCatalog c = new CourseCatalog();
            c.setCourseCode(code);
            c.setCourseName(name);
            c.setCredits((int) credits);
            return courseCatalogRepository.save(c);
        });

        BucketMaster bucket = bucketMasterRepository.findByBucketCode(bucketCode).orElseGet(() -> {
            BucketMaster b = new BucketMaster();
            b.setBucketCode(bucketCode);
            b.setBucketName(bucketCode + " Bucket");
            return bucketMasterRepository.save(b);
        });

        CurriculumCourse currCourse = curriculumCourseRepository
                .findByCurriculumVersionIdAndCourseCourseCode(testVersion.getId(), code)
                .orElseGet(() -> {
                    CurriculumCourse c = new CurriculumCourse();
                    c.setCurriculumVersion(testVersion);
                    c.setCourse(catalog);
                    c.setCourseName(name);
                    c.setCredits(credits);
                    return curriculumCourseRepository.save(c);
                });

        CurriculumCourseMapping mapping = new CurriculumCourseMapping();
        mapping.setCurriculumVersion(testVersion);
        mapping.setCurriculumCourse(currCourse);
        mapping.setBucket(bucket);
        mapping.setDegreePath(testPath);
        mapping.setIsMandatory(false);
        curriculumCourseMappingRepository.save(mapping);

        StudentCourse sc = new StudentCourse();
        sc.setStudent(student);
        sc.setUniversityId(student.getStudentId());
        sc.setCurriculumVersion(testVersion);
        sc.setCourse(catalog);
        sc.setCurriculumCourse(currCourse);
        sc.setCourseCode(code);
        sc.setCourseName(name);
        sc.setCredits(credits);
        sc.setGrade("O");
        sc.setStatus("COMPLETED");
        studentCourseRepository.save(sc);
    }
}
