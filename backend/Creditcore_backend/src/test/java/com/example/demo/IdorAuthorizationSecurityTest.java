package com.example.demo;

import com.example.demo.config.JwtUtil;
import com.example.demo.model.Admin;
import com.example.demo.model.Faculty;
import com.example.demo.model.Student;
import com.example.demo.repository.AdminRepository;
import com.example.demo.repository.FacultyRepository;
import com.example.demo.repository.StudentRepository;
import com.example.demo.service.CustomUserDetailsService;
import com.example.demo.service.Y23AidsCurriculumSeeder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
public class IdorAuthorizationSecurityTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    @Autowired
    private com.example.demo.service.DegreePathEngine degreePathEngine;

    @Autowired
    private com.example.demo.service.DegreeEligibilityEngine degreeEligibilityEngine;

    private Student studentA;
    private Student studentB;
    private Faculty faculty;
    private Admin admin;

    private String tokenStudentA;
    private String tokenStudentB;
    private String tokenFaculty;
    private String tokenAdmin;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();

        // 1. Create Student A
        studentA = new Student();
        studentA.setStudentId("IDOR_STD_ALICE");
        studentA.setFirstName("Alice");
        studentA.setLastName("Wonderland");
        studentA.setEmail("alice.idor@klu.edu");
        studentA.setDateOfBirth(LocalDate.of(2005, 1, 10));
        studentA.setPassword(passwordEncoder.encode("Password123!"));
        studentA.setFirstLoginCompleted(true);
        studentA.setDepartment("CSE");
        studentA.setSubDepartment("REGULAR");
        studentA = studentRepository.save(studentA);

        // 2. Create Student B
        studentB = new Student();
        studentB.setStudentId("IDOR_STD_BOB");
        studentB.setFirstName("Bob");
        studentB.setLastName("Builder");
        studentB.setEmail("bob.idor@klu.edu");
        studentB.setDateOfBirth(LocalDate.of(2005, 2, 20));
        studentB.setPassword(passwordEncoder.encode("Password123!"));
        studentB.setFirstLoginCompleted(true);
        studentB.setDepartment("CSE");
        studentB.setSubDepartment("REGULAR");
        studentB = studentRepository.save(studentB);

        // 3. Create Faculty
        faculty = new Faculty();
        faculty.setUsername("IDOR_FACULTY_PROF");
        faculty.setFirstName("Professor");
        faculty.setLastName("Oak");
        faculty.setEmail("oak.idor@klu.edu");
        faculty.setPassword(passwordEncoder.encode("Password123!"));
        faculty.setDepartment("CSE");
        faculty.setFirstLoginCompleted(true);
        faculty = facultyRepository.save(faculty);

        // 4. Create Admin
        admin = new Admin();
        admin.setUsername("IDOR_SUPER_ADMIN");
        admin.setFirstName("Admin");
        admin.setLastName("User");
        admin.setEmail("admin.idor@klu.edu");
        admin.setPassword(passwordEncoder.encode("Password123!"));
        admin = adminRepository.save(admin);

        // 5. Initialize degree paths and eligibility status for test students
        degreePathEngine.resolveAndAssignPath(studentA.getId());
        degreeEligibilityEngine.evaluateEligibility(studentA.getId());
        degreePathEngine.resolveAndAssignPath(studentB.getId());
        degreeEligibilityEngine.evaluateEligibility(studentB.getId());

        // 6. Generate signed JWT tokens
        UserDetails userDetailsA = userDetailsService.loadUserByUsername(studentA.getStudentId());
        tokenStudentA = jwtUtil.generateToken(userDetailsA, "STUDENT");

        UserDetails userDetailsB = userDetailsService.loadUserByUsername(studentB.getStudentId());
        tokenStudentB = jwtUtil.generateToken(userDetailsB, "STUDENT");

        UserDetails userDetailsFac = userDetailsService.loadUserByUsername(faculty.getUsername());
        tokenFaculty = jwtUtil.generateToken(userDetailsFac, "FACULTY");

        UserDetails userDetailsAdm = userDetailsService.loadUserByUsername(admin.getUsername());
        tokenAdmin = jwtUtil.generateToken(userDetailsAdm, "SUPER_ADMIN");
    }

    // ==================== Requirement 1: Unauthenticated Requests ====================

    @Test
    @DisplayName("Unauthenticated request to student progress dashboard is rejected with 401")
    public void testUnauthenticatedDashboardRejected() throws Exception {
        mockMvc.perform(get("/api/student/progress/dashboard/" + studentA.getId()))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("Unauthenticated request to student eligibility is rejected with 401")
    public void testUnauthenticatedEligibilityRejected() throws Exception {
        mockMvc.perform(get("/api/student/eligibility/" + studentA.getId()))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("Unauthenticated request to student report is rejected with 401")
    public void testUnauthenticatedReportRejected() throws Exception {
        mockMvc.perform(get("/api/reports/student/" + studentA.getId()))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("Unauthenticated request to student Excel report is rejected with 401")
    public void testUnauthenticatedExcelReportRejected() throws Exception {
        mockMvc.perform(get("/api/reports/student/" + studentA.getId() + "/excel"))
                .andExpect(status().isUnauthorized());
    }

    // ==================== Requirement 2: Student accessing own data ====================

    @Test
    @DisplayName("Student can access their own progress dashboard via /dashboard and /dashboard/{id}")
    public void testStudentCanAccessOwnDashboard() throws Exception {
        // Own dashboard via /dashboard
        mockMvc.perform(get("/api/student/progress/dashboard")
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.student.username").value(studentA.getStudentId()));

        // Own dashboard via /dashboard/{ownId}
        mockMvc.perform(get("/api/student/progress/dashboard/" + studentA.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.student.username").value(studentA.getStudentId()));
    }

    // ==================== Requirement 3: Student cannot access another student's dashboard ====================

    @Test
    @DisplayName("Student A cannot access Student B's progress dashboard (IDOR rejected with 403)")
    public void testStudentCannotAccessAnotherStudentDashboard() throws Exception {
        mockMvc.perform(get("/api/student/progress/dashboard/" + studentB.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.student").doesNotExist())
                .andExpect(content().string(not(containsString(studentB.getEmail()))));
    }

    // ==================== Requirement 4: Student accessing own eligibility ====================

    @Test
    @DisplayName("Student can access their own eligibility via /eligibility and /eligibility/{id}")
    public void testStudentCanAccessOwnEligibility() throws Exception {
        // Own eligibility via /eligibility
        mockMvc.perform(get("/api/student/eligibility")
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isOk());

        // Own eligibility via /eligibility/{ownId}
        mockMvc.perform(get("/api/student/eligibility/" + studentA.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isOk());
    }

    // ==================== Requirement 5: Student cannot access another student's eligibility ====================

    @Test
    @DisplayName("Student A cannot access Student B's eligibility information (IDOR rejected with 403)")
    public void testStudentCannotAccessAnotherStudentEligibility() throws Exception {
        mockMvc.perform(get("/api/student/eligibility/" + studentB.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.eligible").doesNotExist())
                .andExpect(jsonPath("$.status").doesNotExist());
    }

    // ==================== Requirement 6: Student cannot access/download another student's report ====================

    @Test
    @DisplayName("Student A cannot download Student B's Excel report (IDOR rejected with 403)")
    public void testStudentCannotDownloadAnotherStudentReportExcel() throws Exception {
        mockMvc.perform(get("/api/reports/student/" + studentB.getId() + "/excel")
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("Student A cannot access Student B's JSON report (IDOR rejected with 403)")
    public void testStudentCannotAccessAnotherStudentReportJson() throws Exception {
        mockMvc.perform(get("/api/reports/student/" + studentB.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isForbidden())
                .andExpect(content().string(not(containsString(studentB.getEmail()))));
    }

    @Test
    @DisplayName("Student A can access their own report and own Excel report")
    public void testStudentCanAccessOwnReport() throws Exception {
        mockMvc.perform(get("/api/reports/student/me")
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/reports/student/" + studentA.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/reports/student/" + studentA.getId() + "/excel")
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isOk());
    }

    // ==================== Requirement 7: Admin and Faculty access permissions ====================

    @Test
    @DisplayName("Faculty can access any student's dashboard, eligibility, and report")
    public void testFacultyCanAccessStudentData() throws Exception {
        // Faculty accessing Student A's dashboard
        mockMvc.perform(get("/api/student/progress/dashboard/" + studentA.getId())
                .header("Authorization", "Bearer " + tokenFaculty))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.student.username").value(studentA.getStudentId()));

        // Faculty accessing Student B's eligibility
        mockMvc.perform(get("/api/student/eligibility/" + studentB.getId())
                .header("Authorization", "Bearer " + tokenFaculty))
                .andExpect(status().isOk());

        // Faculty accessing Student A's report
        mockMvc.perform(get("/api/reports/student/" + studentA.getId())
                .header("Authorization", "Bearer " + tokenFaculty))
                .andExpect(status().isOk());

        // Faculty downloading Student A's Excel report
        mockMvc.perform(get("/api/reports/student/" + studentA.getId() + "/excel")
                .header("Authorization", "Bearer " + tokenFaculty))
                .andExpect(status().isOk());
    }

    @Test
    @DisplayName("Admin can access any student's dashboard, eligibility, and report")
    public void testAdminCanAccessStudentData() throws Exception {
        // Admin accessing Student A's dashboard
        mockMvc.perform(get("/api/student/progress/dashboard/" + studentA.getId())
                .header("Authorization", "Bearer " + tokenAdmin))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.student.username").value(studentA.getStudentId()));

        // Admin accessing Student B's eligibility
        mockMvc.perform(get("/api/student/eligibility/" + studentB.getId())
                .header("Authorization", "Bearer " + tokenAdmin))
                .andExpect(status().isOk());

        // Admin accessing Student B's report
        mockMvc.perform(get("/api/reports/student/" + studentB.getId())
                .header("Authorization", "Bearer " + tokenAdmin))
                .andExpect(status().isOk());

        // Admin downloading Student B's Excel report
        mockMvc.perform(get("/api/reports/student/" + studentB.getId() + "/excel")
                .header("Authorization", "Bearer " + tokenAdmin))
                .andExpect(status().isOk());
    }

    // ==================== Requirement 8: Parameter Tampering Cannot Bypass Authorization ====================

    @Test
    @DisplayName("Tampering with query parameters or URL path cannot bypass authorization")
    public void testParameterTamperingCannotBypassAuthorization() throws Exception {
        // Student A requesting Student B's dashboard while injecting studentId=studentA.id as query param
        mockMvc.perform(get("/api/student/progress/dashboard/" + studentB.getId() + "?studentId=" + studentA.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isForbidden());

        // Student A requesting Student B's report while injecting id=studentA.id as query param
        mockMvc.perform(get("/api/reports/student/" + studentB.getId() + "?id=" + studentA.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isForbidden());

        // Student A requesting Student B's Excel report with injected params
        mockMvc.perform(get("/api/reports/student/" + studentB.getId() + "/excel?id=" + studentA.getId())
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isForbidden());

        // Student A requesting a non-existent student ID returns 403 Forbidden without leaking existence
        mockMvc.perform(get("/api/student/progress/dashboard/999999")
                .header("Authorization", "Bearer " + tokenStudentA))
                .andExpect(status().isForbidden());
    }
}
