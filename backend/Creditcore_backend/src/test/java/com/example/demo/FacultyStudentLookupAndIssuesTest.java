package com.example.demo;

import com.example.demo.controller.FacultyController;
import com.example.demo.controller.FacultyStudentUploadController;
import com.example.demo.controller.SuperAdminController;
import com.example.demo.model.Faculty;
import com.example.demo.model.Student;
import com.example.demo.model.StudentIssue;
import com.example.demo.repository.FacultyRepository;
import com.example.demo.repository.StudentIssueRepository;
import com.example.demo.repository.StudentRepository;
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
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class FacultyStudentLookupAndIssuesTest {

    @Autowired
    private FacultyController facultyController;

    @Autowired
    private FacultyStudentUploadController facultyStudentUploadController;

    @Autowired
    private SuperAdminController superAdminController;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private StudentIssueRepository studentIssueRepository;

    @Autowired
    private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    private Student testStudent;
    private Faculty testFaculty;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();

        // 1. Resolve or create test student
        testStudent = studentRepository.findByStudentId("2300030777").orElseGet(() -> {
            Student s = new Student();
            s.setStudentId("2300030777");
            s.setFirstName("Rohan");
            s.setLastName("Verma");
            s.setEmail("2300030777@kluniversity.in");
            s.setPassword("pass");
            s.setDepartment("CSE");
            s.setAcademicYear("Y23");
            return studentRepository.save(s);
        });

        // 2. Resolve or create test faculty
        testFaculty = facultyRepository.findByEmpId("FAC777").orElseGet(() -> {
            Faculty f = new Faculty();
            f.setEmpId("FAC777");
            f.setUsername("faculty_rohan");
            f.setFirstName("Dr. Ramesh");
            f.setLastName("Kumar");
            f.setEmail("ramesh@kluniversity.in");
            f.setPassword("pass");
            f.setDepartment("CSE");
            f.setIsActive(true);
            return facultyRepository.save(f);
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

    @Test
    @DisplayName("Faculty student lookup returns full student profile and curriculum by studentId")
    public void testFacultyLookupReturnsStudentDetailsAndCurriculum() {
        authenticateAsFaculty();

        // Test via FacultyController (/api/dyod/faculty/students/lookup/{username})
        ResponseEntity<?> response = facultyController.lookupStudentCurriculum(testStudent.getStudentId());
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody() instanceof Map);

        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) response.getBody();
        assertEquals("2300030777", data.get("studentId"));
        assertEquals("Rohan Verma", data.get("studentName"));
        assertNotNull(data.get("student"));

        @SuppressWarnings("unchecked")
        Map<String, Object> studentMap = (Map<String, Object>) data.get("student");
        assertEquals("2300030777", studentMap.get("studentId"));
        assertEquals("Rohan", studentMap.get("firstName"));
        assertEquals("Verma", studentMap.get("lastName"));
        assertEquals("2300030777@kluniversity.in", studentMap.get("email"));
        assertEquals("CSE", studentMap.get("department"));
        assertEquals("Y23", studentMap.get("academicYear"));

        // Verify curriculum courses are included
        assertNotNull(data.get("courses"));
        assertTrue(data.get("courses") instanceof List);

        // Test via FacultyStudentUploadController (/api/faculty/students/lookup/{username})
        ResponseEntity<?> uploadCtrlResponse = facultyStudentUploadController.lookupStudentCurriculum(testStudent.getStudentId());
        assertEquals(HttpStatus.OK, uploadCtrlResponse.getStatusCode());
    }

    @Test
    @DisplayName("Faculty student lookup supports lookup by student email as well")
    public void testFacultyLookupByEmail() {
        authenticateAsFaculty();

        ResponseEntity<?> response = facultyController.lookupStudentCurriculum(testStudent.getEmail());
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());

        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) response.getBody();
        assertEquals("2300030777", data.get("studentId"));
    }

    @Test
    @DisplayName("Faculty student lookup returns 400 Bad Request for non-existent student")
    public void testFacultyLookupNonExistentStudent() {
        authenticateAsFaculty();

        ResponseEntity<?> response = facultyController.lookupStudentCurriculum("nonexistent_id_999999");
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
        assertTrue(response.getBody().toString().contains("Error looking up student"));
    }

    @Test
    @DisplayName("Admin issues endpoint returns issues with populated student details including studentId")
    public void testAdminIssuesReturnsCorrectStudentInformation() {
        // Create an issue for testStudent
        StudentIssue issue = new StudentIssue();
        issue.setStudent(testStudent);
        issue.setTitle("Course Registration Mismatch");
        issue.setDescription("Need approval for elective course");
        issue.setStatus("PENDING");
        studentIssueRepository.save(issue);

        ResponseEntity<?> response = superAdminController.getAllIssues();
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        assertTrue(response.getBody() instanceof List);

        @SuppressWarnings("unchecked")
        List<StudentIssue> issues = (List<StudentIssue>) response.getBody();
        assertFalse(issues.isEmpty());

        StudentIssue fetched = issues.stream()
                .filter(i -> i.getId().equals(issue.getId()))
                .findFirst()
                .orElse(null);
        assertNotNull(fetched);
        assertNotNull(fetched.getStudent(), "Student entity must be populated");
        assertEquals("2300030777", fetched.getStudent().getStudentId(), "Student must contain correct studentId identifier");
        assertEquals("Rohan", fetched.getStudent().getFirstName());
        assertEquals("Verma", fetched.getStudent().getLastName());
        assertEquals("2300030777@kluniversity.in", fetched.getStudent().getEmail());
    }
}
