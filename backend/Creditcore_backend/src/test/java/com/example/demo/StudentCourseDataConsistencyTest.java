package com.example.demo;

import com.example.demo.controller.StudentController;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.AddCourseService;
import com.example.demo.service.BucketMappingEngine;
import com.example.demo.service.DegreeEligibilityEngine;
import com.example.demo.service.Y23AidsCurriculumSeeder;
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
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class StudentCourseDataConsistencyTest {

    @Autowired
    private AddCourseService addCourseService;

    @Autowired
    private BucketMappingEngine bucketMappingEngine;

    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private StudentCourseRepository studentCourseRepository;

    @Autowired
    private StudentCourseAttemptRepository studentCourseAttemptRepository;

    @Autowired
    private DegreePathRepository degreePathRepository;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private StudentDegreeStatusRepository studentDegreeStatusRepository;

    @Autowired
    private CourseCatalogRepository courseCatalogRepository;

    @Autowired
    private StudentController studentController;

    @Autowired
    private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    private Student testStudent;
    private DegreePath cseRegularPath;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();

        testStudent = new Student();
        testStudent.setStudentId("2300030001");
        testStudent.setFirstName("Rahul");
        testStudent.setLastName("Sharma");
        testStudent.setEmail("2300030001@kluniversity.in");
        testStudent.setPassword("pass");
        testStudent.setDepartment("CSE");
        testStudent.setAcademicYear("Y23");
        testStudent = studentRepository.save(testStudent);

        cseRegularPath = degreePathRepository.findByPathCode("Y23_CSE_REGULAR")
                .orElseGet(() -> degreePathRepository.findAll().get(0));

        StudentDegreePath sdp = new StudentDegreePath();
        sdp.setStudent(testStudent);
        sdp.setDegreePath(cseRegularPath);
        studentDegreePathRepository.save(sdp);

        // Authenticate as testStudent
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(
                        testStudent.getStudentId(),
                        "pass",
                        List.of(new SimpleGrantedAuthority("ROLE_STUDENT"))
                )
        );
    }

    @Test
    @DisplayName("1. Student adds a valid course - synchronizes normalized records as UNVERIFIED")
    public void testStudentAddsValidCourse() {
        Map<String, Object> payload = new HashMap<>();
        payload.put("courseName", "Design and Analysis of Algorithms");
        payload.put("courseCode", "23CS2103");
        payload.put("category", "Core");
        payload.put("credits", 4);
        payload.put("status", "Completed");
        payload.put("semester", "ODD");
        payload.put("academicYear", "2023-2024");

        ResponseEntity<?> response = studentController.addStudentCourse(payload);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertTrue(response.getBody() instanceof CompletedCourse);

        CompletedCourse saved = (CompletedCourse) response.getBody();
        assertNotNull(saved.getId());
        assertEquals("23CS2103", saved.getCourseCode());
        assertNull(saved.getVerifiedBy(), "Self-reported student course must have verifiedBy as null");

        // Verify normalized student_courses record
        List<StudentCourse> scList = studentCourseRepository.findByStudentId(testStudent.getId());
        Optional<StudentCourse> scOpt = scList.stream()
                .filter(sc -> sc.getCourseCode().equalsIgnoreCase("23CS2103"))
                .findFirst();
        assertTrue(scOpt.isPresent(), "Normalized student_courses record should be created");
        StudentCourse sc = scOpt.get();
        assertEquals("UNVERIFIED", sc.getStatus(), "Status in normalized table must be UNVERIFIED for student custom courses");
        assertEquals(4.0, sc.getCredits());

        // Verify normalized student_course_attempts record
        List<StudentCourseAttempt> attempts = studentCourseAttemptRepository
                .findByStudentIdAndCourseCode(testStudent.getId(), "23CS2103");
        assertFalse(attempts.isEmpty(), "Student course attempt should be created");
        StudentCourseAttempt sca = attempts.get(0);
        assertEquals("UNVERIFIED", sca.getStatus());
        assertFalse(sca.getIsQualifying(), "Self-reported student course attempt must NOT be qualifying");
    }

    @Test
    @DisplayName("2. Duplicate course submission is rejected")
    public void testDuplicateCourseSubmissionIsRejected() {
        Map<String, Object> payload = new HashMap<>();
        payload.put("courseName", "Design and Analysis of Algorithms");
        payload.put("courseCode", "23CS2103");
        payload.put("category", "Core");
        payload.put("credits", 4);
        payload.put("status", "Completed");

        // First submission succeeds
        ResponseEntity<?> firstResponse = studentController.addStudentCourse(payload);
        assertEquals(HttpStatus.OK, firstResponse.getStatusCode());

        // Second submission of the same course must be rejected with 400 Bad Request
        ResponseEntity<?> duplicateResponse = studentController.addStudentCourse(payload);
        assertEquals(HttpStatus.BAD_REQUEST, duplicateResponse.getStatusCode());
        assertTrue(duplicateResponse.getBody().toString().contains("already exists"),
                "Error response should indicate course already exists: " + duplicateResponse.getBody());
    }

    @Test
    @DisplayName("3. Deleting a course updates correct records and recalculates progress")
    public void testDeletingCourseUpdatesCorrectRecords() {
        Map<String, Object> payload = new HashMap<>();
        payload.put("courseName", "Web Development");
        payload.put("courseCode", "23CS2104");
        payload.put("category", "Core");
        payload.put("credits", 3);
        payload.put("status", "Completed");

        ResponseEntity<?> addResp = studentController.addStudentCourse(payload);
        assertEquals(HttpStatus.OK, addResp.getStatusCode());
        CompletedCourse saved = (CompletedCourse) addResp.getBody();
        Long courseId = saved.getId();

        // Delete course
        ResponseEntity<?> delResp = studentController.deleteStudentCourse(courseId);
        assertEquals(HttpStatus.OK, delResp.getStatusCode());

        // Verify completed_courses deleted
        assertFalse(completedCourseRepository.findById(courseId).isPresent(),
                "CompletedCourse entry must be deleted");

        // Verify normalized student_courses cleaned up
        List<StudentCourse> remainingSc = studentCourseRepository.findByStudentId(testStudent.getId());
        boolean hasCourse = remainingSc.stream().anyMatch(sc -> sc.getCourseCode().equalsIgnoreCase("23CS2104"));
        assertFalse(hasCourse, "Normalized StudentCourse entry must be removed upon deletion");

        // Verify attempt cleaned up
        List<StudentCourseAttempt> attempts = studentCourseAttemptRepository
                .findByStudentIdAndCourseCode(testStudent.getId(), "23CS2104");
        assertTrue(attempts.isEmpty(), "StudentCourseAttempt entries must be cleaned up");
    }

    @Test
    @DisplayName("4. Planned or unverified courses do not count as earned credits")
    public void testPlannedOrUnverifiedCoursesDoNotCountAsEarnedCredits() {
        // Add course as unverified student custom course
        Map<String, Object> payload = new HashMap<>();
        payload.put("courseName", "Database Systems");
        payload.put("courseCode", "23CS2101");
        payload.put("category", "Core");
        payload.put("credits", 4);
        payload.put("status", "Completed");

        ResponseEntity<?> addResp = studentController.addStudentCourse(payload);
        assertEquals(HttpStatus.OK, addResp.getStatusCode());

        // Map courses to buckets
        Map<Long, BucketMappingEngine.BucketCreditsInfo> bucketMap =
                bucketMappingEngine.mapStudentCoursesToBuckets(testStudent.getId(), cseRegularPath.getId());

        int totalEarnedCredits = bucketMap.values().stream()
                .mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits)
                .sum();

        assertEquals(0, totalEarnedCredits,
                "Unverified student courses must NOT count toward earned credits in bucket evaluation");
    }

    @Test
    @DisplayName("5. Verified course counts toward earned credits without duplicate counting")
    public void testVerifiedCourseCountsOnceWithoutDuplicates() {
        // Officially verified course: verifiedBy != null, status = COMPLETED, passing grade
        CompletedCourse verifiedCourse = new CompletedCourse();
        verifiedCourse.setStudent(testStudent);
        verifiedCourse.setUniversityId(testStudent.getStudentId());
        verifiedCourse.setStudentName(testStudent.getFirstName() + " " + testStudent.getLastName());
        verifiedCourse.setCourseName("Data Structures");
        verifiedCourse.setCourseCode("23CS2101");
        verifiedCourse.setCredits(4);
        verifiedCourse.setStatus("Completed");
        verifiedCourse.setGrade("A");
        verifiedCourse.setVerifiedBy(999L); // Officially verified by faculty/admin
        verifiedCourse.setSemester("ODD");
        verifiedCourse.setAcademicYear("2023-2024");
        completedCourseRepository.save(verifiedCourse);

        // Also dual-written to student_courses
        CourseCatalog catalog = addCourseService.resolveOrCreateCourseCatalog("23CS2101", "Data Structures", "4", "Core");

        StudentCourse sc = new StudentCourse();
        sc.setStudent(testStudent);
        sc.setUniversityId(testStudent.getStudentId());
        sc.setCourse(catalog);
        sc.setCourseCode("23CS2101");
        sc.setCourseName("Data Structures");
        sc.setCredits(4.0);
        sc.setGrade("A");
        sc.setStatus("COMPLETED");
        sc.setSemester("ODD");
        sc.setAcademicYear("2023-2024");
        studentCourseRepository.save(sc);

        // Evaluate bucket mapping
        Map<Long, BucketMappingEngine.BucketCreditsInfo> bucketMap =
                bucketMappingEngine.mapStudentCoursesToBuckets(testStudent.getId(), cseRegularPath.getId());

        int totalEarnedCredits = bucketMap.values().stream()
                .mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits)
                .sum();

        // 23CS2101 has 4 credits. It must be counted EXACTLY ONCE (4 credits, not 8 credits).
        assertEquals(4, totalEarnedCredits,
                "Verified course present in both completed_courses and student_courses must not double-count credits");
    }

    @Test
    @DisplayName("6. Unauthorized users cannot modify another student's records")
    public void testUnauthorizedUserCannotDeleteOtherStudentCourse() {
        // Student A adds course
        Map<String, Object> payload = new HashMap<>();
        payload.put("courseName", "Course A");
        payload.put("courseCode", "23CS2105");
        payload.put("category", "Core");
        payload.put("credits", 3);
        payload.put("status", "Completed");

        ResponseEntity<?> addResp = studentController.addStudentCourse(payload);
        assertEquals(HttpStatus.OK, addResp.getStatusCode());
        CompletedCourse courseA = (CompletedCourse) addResp.getBody();

        // Create Student B and switch security context to Student B
        Student studentB = new Student();
        studentB.setStudentId("2300030002");
        studentB.setFirstName("Other");
        studentB.setLastName("Student");
        studentB.setEmail("2300030002@kluniversity.in");
        studentB.setPassword("pass");
        studentB.setDepartment("CSE");
        studentB = studentRepository.save(studentB);

        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(
                        studentB.getStudentId(),
                        "pass",
                        List.of(new SimpleGrantedAuthority("ROLE_STUDENT"))
                )
        );

        // Student B attempts to delete Student A's course
        ResponseEntity<?> delResp = studentController.deleteStudentCourse(courseA.getId());
        assertEquals(HttpStatus.FORBIDDEN, delResp.getStatusCode(),
                "Unauthorized student attempting to delete another student's course must receive 403 Forbidden");
    }

    @Test
    @DisplayName("7. Student cannot delete officially verified course")
    public void testStudentCannotDeleteVerifiedCourse() {
        CompletedCourse verifiedCourse = new CompletedCourse();
        verifiedCourse.setStudent(testStudent);
        verifiedCourse.setUniversityId(testStudent.getStudentId());
        verifiedCourse.setCourseName("Official Verified Course");
        verifiedCourse.setCourseCode("23CS2106");
        verifiedCourse.setCredits(3);
        verifiedCourse.setStatus("Completed");
        verifiedCourse.setGrade("O");
        verifiedCourse.setVerifiedBy(100L); // Officially verified
        verifiedCourse = completedCourseRepository.save(verifiedCourse);

        ResponseEntity<?> delResp = studentController.deleteStudentCourse(verifiedCourse.getId());
        assertEquals(HttpStatus.FORBIDDEN, delResp.getStatusCode(),
                "Student must not be able to delete an officially verified academic course");
    }

    @Test
    @DisplayName("8. Failed grades (e.g. 'F') do not count as passing or earned credits")
    public void testFailedGradesDoNotCountTowardEarnedCredits() {
        assertFalse(BucketMappingEngine.isPassingGrade("F"));
        assertFalse(BucketMappingEngine.isPassingGrade("FAIL"));
        assertFalse(BucketMappingEngine.isPassingGrade("AB"));
        assertFalse(BucketMappingEngine.isPassingGrade("DT"));
        assertFalse(BucketMappingEngine.isPassingGrade("IP"));
        assertTrue(BucketMappingEngine.isPassingGrade("A"));
        assertTrue(BucketMappingEngine.isPassingGrade("O"));
        assertTrue(BucketMappingEngine.isPassingGrade("B+"));
        assertTrue(BucketMappingEngine.isPassingGrade("Pass"));
    }
}
