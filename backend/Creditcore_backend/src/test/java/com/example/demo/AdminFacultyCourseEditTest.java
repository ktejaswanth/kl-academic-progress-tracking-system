package com.example.demo;

import com.example.demo.controller.AddCourseController;
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

import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class AdminFacultyCourseEditTest {

    @Autowired
    private AddCourseController addCourseController;

    @Autowired
    private AddCourseService addCourseService;

    @Autowired
    private BucketMappingEngine bucketMappingEngine;

    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private AdminRepository adminRepository;

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
    private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    private Student testStudent;
    private DegreePath cseRegularPath;
    private Faculty testFaculty;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();

        // 1. Create student
        testStudent = new Student();
        testStudent.setStudentId("2300030055");
        testStudent.setFirstName("Priya");
        testStudent.setLastName("Rao");
        testStudent.setEmail("2300030055@kluniversity.in");
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

        // 2. Create faculty
        testFaculty = new Faculty();
        testFaculty.setEmpId("EMP001");
        testFaculty.setUsername("faculty_prof");
        testFaculty.setFirstName("S.");
        testFaculty.setLastName("Kumar");
        testFaculty.setEmail("profkumar@kluniversity.in");
        testFaculty.setPassword("pass");
        testFaculty.setDepartment("CSE");
        testFaculty = facultyRepository.save(testFaculty);

        // 3. Authenticate as FACULTY by default
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(
                        testFaculty.getUsername(),
                        "pass",
                        List.of(new SimpleGrantedAuthority("ROLE_FACULTY"))
                )
        );
    }

    @Test
    @DisplayName("1. Successful Course Update: updates records, normalizes, and recalculates progress")
    public void testSuccessfulCourseUpdate() {
        // Initial course with grade F
        AddCourseController.AddCourseRequest addReq = new AddCourseController.AddCourseRequest();
        addReq.setUniversityId(testStudent.getStudentId());
        addReq.setCourseCode("23CS2101");
        addReq.setCourseName("Data Structures");
        addReq.setGrade("F");
        addReq.setSemester("ODD");
        addReq.setAcademicYear("2023-2024");
        Map<String, Object> addResult = addCourseService.addSingleCourse(addReq, testFaculty.getId());
        CompletedCourse course = (CompletedCourse) addResult.get("course");
        Long courseId = course.getId();

        // Initially grade F => 0 earned credits
        Map<Long, BucketMappingEngine.BucketCreditsInfo> initialBuckets =
                bucketMappingEngine.mapStudentCoursesToBuckets(testStudent.getId(), cseRegularPath.getId());
        int initialEarned = initialBuckets.values().stream().mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits).sum();
        assertEquals(0, initialEarned, "Failing grade course must have 0 earned credits");

        // Faculty edits the course: updates grade to A
        AddCourseController.UpdateCourseRequest updateReq = new AddCourseController.UpdateCourseRequest();
        updateReq.setCourseCode("23CS2101");
        updateReq.setGrade("A");
        updateReq.setCredits(4);
        updateReq.setSemester("ODD");
        updateReq.setAcademicYear("2023-2024");

        ResponseEntity<?> response = addCourseController.updateCourse(courseId, updateReq);
        assertEquals(HttpStatus.OK, response.getStatusCode());

        // Verify CompletedCourse updated
        CompletedCourse updated = completedCourseRepository.findById(courseId).orElseThrow();
        assertEquals("A", updated.getGrade());
        assertEquals(testFaculty.getId(), updated.getVerifiedBy());

        // Verify normalized student_courses updated to COMPLETED
        List<StudentCourse> scList = studentCourseRepository.findByStudentId(testStudent.getId());
        StudentCourse sc = scList.stream().filter(c -> c.getCourseCode().equalsIgnoreCase("23CS2101")).findFirst().orElseThrow();
        assertEquals("COMPLETED", sc.getStatus());
        assertEquals("A", sc.getGrade());

        // Verify attempt is qualifying
        List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(testStudent.getId(), "23CS2101");
        assertFalse(attempts.isEmpty());
        assertTrue(attempts.get(0).getIsQualifying());

        // Verify recalculation: earned credits increased from 0 to 4
        Map<Long, BucketMappingEngine.BucketCreditsInfo> updatedBuckets =
                bucketMappingEngine.mapStudentCoursesToBuckets(testStudent.getId(), cseRegularPath.getId());
        int updatedEarned = updatedBuckets.values().stream().mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits).sum();
        assertEquals(4, updatedEarned, "After editing to passing grade A, course must count 4 earned credits");
    }

    @Test
    @DisplayName("2. Nonexistent Course Update: returns 404 NOT_FOUND")
    public void testUpdateNonexistentCourse() {
        AddCourseController.UpdateCourseRequest updateReq = new AddCourseController.UpdateCourseRequest();
        updateReq.setCourseCode("23CS2101");
        updateReq.setGrade("O");

        ResponseEntity<?> response = addCourseController.updateCourse(999999L, updateReq);
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertTrue(response.getBody().toString().contains("not found"));
    }

    @Test
    @DisplayName("3. Invalid Input: empty course code or negative credits returns 400 BAD_REQUEST")
    public void testUpdateInvalidInput() {
        // Create an existing course
        AddCourseController.AddCourseRequest addReq = new AddCourseController.AddCourseRequest();
        addReq.setUniversityId(testStudent.getStudentId());
        addReq.setCourseCode("23CS2101");
        addReq.setGrade("A");
        Map<String, Object> addResult = addCourseService.addSingleCourse(addReq, testFaculty.getId());
        CompletedCourse course = (CompletedCourse) addResult.get("course");

        // Attempt update with negative credits
        AddCourseController.UpdateCourseRequest negCreditsReq = new AddCourseController.UpdateCourseRequest();
        negCreditsReq.setCourseCode("23CS2101");
        negCreditsReq.setCredits(-5);

        ResponseEntity<?> negResp = addCourseController.updateCourse(course.getId(), negCreditsReq);
        assertEquals(HttpStatus.BAD_REQUEST, negResp.getStatusCode());
        assertTrue(negResp.getBody().toString().contains("Credits must be a non-negative integer"));

        // Attempt update with empty course code
        AddCourseController.UpdateCourseRequest emptyCodeReq = new AddCourseController.UpdateCourseRequest();
        emptyCodeReq.setCourseCode("   ");

        ResponseEntity<?> emptyResp = addCourseController.updateCourse(course.getId(), emptyCodeReq);
        assertEquals(HttpStatus.BAD_REQUEST, emptyResp.getStatusCode());
    }

    @Test
    @DisplayName("4. Unauthorized Access: Student cannot edit courses (returns 403 FORBIDDEN)")
    public void testUnauthorizedUserCannotEditCourse() {
        // Create a course as faculty
        AddCourseController.AddCourseRequest addReq = new AddCourseController.AddCourseRequest();
        addReq.setUniversityId(testStudent.getStudentId());
        addReq.setCourseCode("23CS2101");
        addReq.setGrade("A");
        Map<String, Object> addResult = addCourseService.addSingleCourse(addReq, testFaculty.getId());
        CompletedCourse course = (CompletedCourse) addResult.get("course");

        // Switch security context to STUDENT role
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(
                        testStudent.getStudentId(),
                        "pass",
                        List.of(new SimpleGrantedAuthority("ROLE_STUDENT"))
                )
        );

        AddCourseController.UpdateCourseRequest updateReq = new AddCourseController.UpdateCourseRequest();
        updateReq.setGrade("O");

        ResponseEntity<?> response = addCourseController.updateCourse(course.getId(), updateReq);
        assertEquals(HttpStatus.FORBIDDEN, response.getStatusCode());
        assertTrue(response.getBody().toString().contains("not authorized"));
    }

    @Test
    @DisplayName("5. Protected Fields: Changing student ownership is blocked")
    public void testProtectedFieldsCannotBeChanged() {
        // Create course for Student A
        AddCourseController.AddCourseRequest addReq = new AddCourseController.AddCourseRequest();
        addReq.setUniversityId(testStudent.getStudentId());
        addReq.setCourseCode("23CS2101");
        addReq.setGrade("B");
        Map<String, Object> addResult = addCourseService.addSingleCourse(addReq, testFaculty.getId());
        CompletedCourse course = (CompletedCourse) addResult.get("course");

        // Create Student B
        Student studentB = new Student();
        studentB.setStudentId("2300030099");
        studentB.setFirstName("Other");
        studentB.setLastName("Student");
        studentB.setEmail("2300030099@kluniversity.in");
        studentB.setPassword("pass");
        studentB.setDepartment("CSE");
        studentB = studentRepository.save(studentB);

        // Attempt to reassign course to Student B
        AddCourseController.UpdateCourseRequest reassignReq = new AddCourseController.UpdateCourseRequest();
        reassignReq.setStudentId(studentB.getId());
        reassignReq.setGrade("A");

        ResponseEntity<?> response = addCourseController.updateCourse(course.getId(), reassignReq);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertTrue(response.getBody().toString().contains("Changing student ownership of a course record is not permitted"));

        // Ensure record still belongs to original student
        CompletedCourse intact = completedCourseRepository.findById(course.getId()).orElseThrow();
        assertEquals(testStudent.getId(), intact.getStudent().getId());
    }

    @Test
    @DisplayName("6. Duplicate Course Prevention: Renaming course code to an existing course in same semester is rejected")
    public void testDuplicateCourseUpdatePrevented() {
        // Create Course 1
        AddCourseController.AddCourseRequest addReq1 = new AddCourseController.AddCourseRequest();
        addReq1.setUniversityId(testStudent.getStudentId());
        addReq1.setCourseCode("23CS2101");
        addReq1.setSemester("ODD");
        addReq1.setAcademicYear("2023-2024");
        addCourseService.addSingleCourse(addReq1, testFaculty.getId());

        // Create Course 2
        AddCourseController.AddCourseRequest addReq2 = new AddCourseController.AddCourseRequest();
        addReq2.setUniversityId(testStudent.getStudentId());
        addReq2.setCourseCode("23CS2102");
        addReq2.setSemester("ODD");
        addReq2.setAcademicYear("2023-2024");
        Map<String, Object> addResult2 = addCourseService.addSingleCourse(addReq2, testFaculty.getId());
        CompletedCourse course2 = (CompletedCourse) addResult2.get("course");

        // Attempt to rename Course 2 into 23CS2101 in the same semester
        AddCourseController.UpdateCourseRequest dupReq = new AddCourseController.UpdateCourseRequest();
        dupReq.setCourseCode("23CS2101");
        dupReq.setSemester("ODD");
        dupReq.setAcademicYear("2023-2024");

        ResponseEntity<?> response = addCourseController.updateCourse(course2.getId(), dupReq);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertTrue(response.getBody().toString().contains("already exists"));
    }

    @Test
    @DisplayName("7. Editing Grade to Failing Grade ('F') immediately removes earned credit")
    public void testEditingGradeToFailingReducesEarnedCredits() {
        // Create course with passing grade A (4 credits)
        AddCourseController.AddCourseRequest addReq = new AddCourseController.AddCourseRequest();
        addReq.setUniversityId(testStudent.getStudentId());
        addReq.setCourseCode("23CS2101");
        addReq.setGrade("A");
        addReq.setSemester("ODD");
        addReq.setAcademicYear("2023-2024");
        Map<String, Object> addResult = addCourseService.addSingleCourse(addReq, testFaculty.getId());
        CompletedCourse course = (CompletedCourse) addResult.get("course");

        Map<Long, BucketMappingEngine.BucketCreditsInfo> bucketsBefore =
                bucketMappingEngine.mapStudentCoursesToBuckets(testStudent.getId(), cseRegularPath.getId());
        int earnedBefore = bucketsBefore.values().stream().mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits).sum();
        assertEquals(4, earnedBefore);

        // Edit grade to F
        AddCourseController.UpdateCourseRequest failReq = new AddCourseController.UpdateCourseRequest();
        failReq.setGrade("F");

        ResponseEntity<?> response = addCourseController.updateCourse(course.getId(), failReq);
        assertEquals(HttpStatus.OK, response.getStatusCode());

        // Verify earned credits reduced to 0
        Map<Long, BucketMappingEngine.BucketCreditsInfo> bucketsAfter =
                bucketMappingEngine.mapStudentCoursesToBuckets(testStudent.getId(), cseRegularPath.getId());
        int earnedAfter = bucketsAfter.values().stream().mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits).sum();
        assertEquals(0, earnedAfter, "Failing grade edit must reduce earned credits to 0");
    }
}
