package com.example.demo;

import com.example.demo.controller.AddCourseController;
import com.example.demo.controller.AddCourseController.UpdateCourseRequest;
import com.example.demo.dto.AuditHistoryResponse;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.AddCourseService;
import com.example.demo.service.Y23AidsCurriculumSeeder;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class CourseManagementAuditTest {

    @Autowired
    private AddCourseController addCourseController;

    @Autowired
    private AddCourseService addCourseService;

    @Autowired
    private AuditHistoryRepository auditHistoryRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private DegreePathRepository degreePathRepository;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    @Autowired
    private PlatformTransactionManager transactionManager;

    private Student testStudent;
    private Faculty testFaculty;
    private Admin testAdmin;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();

        auditHistoryRepository.deleteAll();

        // 1. Resolve or create student
        testStudent = studentRepository.findByStudentId("2300030999").orElseGet(() -> {
            Student s = new Student();
            s.setStudentId("2300030999");
            s.setFirstName("Audit");
            s.setLastName("Student");
            s.setEmail("2300030999@kluniversity.in");
            s.setPassword("pass");
            s.setDepartment("CSE");
            s.setAcademicYear("Y23");
            return studentRepository.save(s);
        });

        completedCourseRepository.deleteAll(completedCourseRepository.findByStudentId(testStudent.getId()));

        DegreePath path = degreePathRepository.findByPathCode("Y23_CSE_REGULAR")
                .orElseGet(() -> degreePathRepository.findAll().get(0));

        if (studentDegreePathRepository.findByStudentId(testStudent.getId()).isEmpty()) {
            StudentDegreePath sdp = new StudentDegreePath();
            sdp.setStudent(testStudent);
            sdp.setDegreePath(path);
            studentDegreePathRepository.save(sdp);
        }

        // 2. Resolve or create faculty
        testFaculty = facultyRepository.findByEmpId("FAC999").orElseGet(() -> {
            Faculty f = new Faculty();
            f.setEmpId("FAC999");
            f.setUsername("auditor");
            f.setFirstName("Dr.");
            f.setLastName("Auditor");
            f.setEmail("auditor@kluniversity.in");
            f.setPassword("pass");
            f.setDepartment("CSE");
            f.setIsActive(true);
            return facultyRepository.save(f);
        });

        // 3. Resolve or create admin
        testAdmin = adminRepository.findByUsername("superaudit").orElseGet(() -> {
            Admin a = new Admin();
            a.setEmpId("ADM999");
            a.setUsername("superaudit");
            a.setFirstName("Super");
            a.setLastName("Admin");
            a.setEmail("superaudit@kluniversity.in");
            a.setPassword("pass");
            a.setIsActive(true);
            return adminRepository.save(a);
        });
    }

    @AfterEach
    public void tearDown() {
        SecurityContextHolder.clearContext();
    }

    private void authenticateAsFaculty() {
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                testFaculty.getEmail(),
                null,
                List.of(new SimpleGrantedAuthority("ROLE_FACULTY"))
        );
        SecurityContextHolder.getContext().setAuthentication(auth);
    }

    private void authenticateAsAdmin() {
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                testAdmin.getUsername(),
                null,
                List.of(new SimpleGrantedAuthority("ROLE_ADMIN"))
        );
        SecurityContextHolder.getContext().setAuthentication(auth);
    }

    private void authenticateAsStudent() {
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                testStudent.getStudentId(),
                null,
                List.of(new SimpleGrantedAuthority("ROLE_STUDENT"))
        );
        SecurityContextHolder.getContext().setAuthentication(auth);
    }

    @Test
    @DisplayName("Successful course creation creates exactly one CREATE audit entry with actor info")
    public void testSuccessfulCourseCreationCreatesAudit() {
        authenticateAsFaculty();

        AddCourseController.AddCourseRequest req = new AddCourseController.AddCourseRequest();
        req.setUniversityId(testStudent.getStudentId());
        req.setCourseCode("23CS2101");
        req.setCourseName("Mathematical Foundations");
        req.setLtps("4-0-0-4");
        req.setGrade("A");
        req.setSemester("ODD");
        req.setAcademicYear("2023-2024");

        ResponseEntity<?> response = addCourseController.addSingleCourse(req);
        assertEquals(HttpStatus.OK, response.getStatusCode());

        List<AuditHistory> audits = auditHistoryRepository.findByStudentIdOrderByCreatedAtDesc(testStudent.getId());
        assertEquals(1, audits.size(), "Should have exactly one audit entry");

        AuditHistory audit = audits.get(0);
        assertEquals("CREATE", audit.getActionType());
        assertEquals(testFaculty.getId(), audit.getPerformedBy());
        assertNotNull(audit.getPayload());
        assertTrue(audit.getPayload().contains("23CS2101"));
        assertTrue(audit.getPayload().contains("auditor") || audit.getPayload().contains("Dr. Auditor"));
        assertTrue(audit.getPayload().contains("FACULTY"));
        assertNotNull(audit.getResult());
        assertTrue(audit.getResult().contains("SUCCESS"));
    }

    @Test
    @DisplayName("Successful course editing creates exactly one UPDATE audit entry with old and new values")
    public void testSuccessfulCourseEditCreatesAuditWithDiff() {
        authenticateAsAdmin();

        // 1. Create initial course
        AddCourseController.AddCourseRequest createReq = new AddCourseController.AddCourseRequest();
        createReq.setUniversityId(testStudent.getStudentId());
        createReq.setCourseCode("23CS2102");
        createReq.setCourseName("Data Structures");
        createReq.setLtps("4-0-0-4");
        createReq.setGrade("B");
        createReq.setSemester("ODD");
        createReq.setAcademicYear("2023-2024");
        addCourseController.addSingleCourse(createReq);

        List<CompletedCourse> courses = completedCourseRepository.findByStudentId(testStudent.getId());
        assertFalse(courses.isEmpty());
        CompletedCourse course = courses.get(0);

        int initialAuditCount = auditHistoryRepository.findByStudentIdOrderByCreatedAtDesc(testStudent.getId()).size();

        // 2. Edit course
        UpdateCourseRequest updateReq = new UpdateCourseRequest();
        updateReq.setGrade("A+");
        updateReq.setSemester("EVEN");

        ResponseEntity<?> updateResponse = addCourseController.updateCourse(course.getId(), updateReq);
        assertEquals(HttpStatus.OK, updateResponse.getStatusCode());

        List<AuditHistory> audits = auditHistoryRepository.findByStudentIdOrderByCreatedAtDesc(testStudent.getId());
        assertEquals(initialAuditCount + 1, audits.size(), "Editing course should add exactly one audit entry");

        AuditHistory latestAudit = audits.get(0);
        assertEquals("UPDATE", latestAudit.getActionType());
        assertEquals(testAdmin.getId(), latestAudit.getPerformedBy());
        assertTrue(latestAudit.getPayload().contains(testAdmin.getUsername()));
        assertTrue(latestAudit.getPayload().contains("oldValues"));
        assertTrue(latestAudit.getPayload().contains("\"grade\":\"B\""));
        assertTrue(latestAudit.getResult().contains("newValues"));
        assertTrue(latestAudit.getResult().contains("\"grade\":\"A+\""));
    }

    @Test
    @DisplayName("Successful course deletion creates exactly one DELETE audit entry")
    public void testSuccessfulCourseDeletionCreatesAudit() {
        authenticateAsFaculty();

        // 1. Create initial course
        AddCourseController.AddCourseRequest createReq = new AddCourseController.AddCourseRequest();
        createReq.setUniversityId(testStudent.getStudentId());
        createReq.setCourseCode("23CS2103");
        createReq.setCourseName("Algorithms");
        createReq.setLtps("4-0-0-4");
        createReq.setGrade("A");
        createReq.setSemester("ODD");
        createReq.setAcademicYear("2023-2024");
        addCourseController.addSingleCourse(createReq);

        List<CompletedCourse> courses = completedCourseRepository.findByStudentId(testStudent.getId());
        CompletedCourse course = courses.get(0);

        int countBeforeDelete = auditHistoryRepository.findByStudentIdOrderByCreatedAtDesc(testStudent.getId()).size();

        // 2. Delete course
        ResponseEntity<?> delResponse = addCourseController.deleteCourse(course.getId());
        assertEquals(HttpStatus.OK, delResponse.getStatusCode());

        List<AuditHistory> audits = auditHistoryRepository.findByStudentIdOrderByCreatedAtDesc(testStudent.getId());
        assertEquals(countBeforeDelete + 1, audits.size());

        AuditHistory deleteAudit = audits.get(0);
        assertEquals("DELETE", deleteAudit.getActionType());
        assertTrue(deleteAudit.getPayload().contains("23CS2103"));
        assertTrue(deleteAudit.getPayload().contains("Deleted course"));
    }

    @Test
    @DisplayName("Failed or unauthorized operations do not create success audit entries")
    public void testFailedOrUnauthorizedOperationsDoNotCreateAudit() {
        // Authenticate as student and try to edit course
        authenticateAsStudent();

        UpdateCourseRequest editReq = new UpdateCourseRequest();
        editReq.setGrade("O");

        int initialAuditCount = auditHistoryRepository.findAll().size();

        ResponseEntity<?> response = addCourseController.updateCourse(99999L, editReq);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());

        assertEquals(initialAuditCount, auditHistoryRepository.findAll().size(), "Unauthorized attempt must not create audit log");

        // Try updating non-existent course as Admin
        authenticateAsAdmin();
        ResponseEntity<?> notFoundResponse = addCourseController.updateCourse(99999L, editReq);
        assertEquals(HttpStatus.NOT_FOUND, notFoundResponse.getStatusCode());

        assertEquals(initialAuditCount, auditHistoryRepository.findAll().size(), "Failed attempt for non-existent course must not create audit log");
    }

    @Test
    @DisplayName("Students cannot access administrative audit history endpoint (403 Forbidden)")
    public void testStudentsCannotAccessAuditHistoryEndpoint() {
        authenticateAsStudent();

        ResponseEntity<?> studentResponse = addCourseController.getAuditHistoryForStudent(testStudent.getId());
        assertEquals(HttpStatus.FORBIDDEN, studentResponse.getStatusCode());

        ResponseEntity<?> allAuditResponse = addCourseController.getAllAuditHistory();
        assertEquals(HttpStatus.FORBIDDEN, allAuditResponse.getStatusCode());

        // But faculty can access
        authenticateAsFaculty();
        ResponseEntity<?> facultyResponse = addCourseController.getAuditHistoryForStudent(testStudent.getId());
        assertEquals(HttpStatus.OK, facultyResponse.getStatusCode());
    }

    @Test
    @DisplayName("Transaction rollback does not leave a misleading audit entry")
    public void testTransactionRollbackRollsBackAudit() {
        authenticateAsFaculty();

        int initialAudits = auditHistoryRepository.findAll().size();

        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
        TransactionStatus status = transactionManager.getTransaction(def);

        try {
            AddCourseController.AddCourseRequest req = new AddCourseController.AddCourseRequest();
            req.setUniversityId(testStudent.getStudentId());
            req.setCourseCode("23CS9999");
            req.setCourseName("Failing Transaction Test");
            req.setLtps("4-0-0-4");
            req.setGrade("A");
            req.setSemester("ODD");
            req.setAcademicYear("2023-2024");

            addCourseService.addSingleCourse(req, testFaculty.getId());

            // Simulate runtime exception causing transaction rollback
            throw new RuntimeException("Simulated failure after operation");
        } catch (Exception e) {
            transactionManager.rollback(status);
        }

        assertEquals(initialAudits, auditHistoryRepository.findAll().size(),
                "Transaction rollback must roll back any audit entry created during the transaction");
    }
}
