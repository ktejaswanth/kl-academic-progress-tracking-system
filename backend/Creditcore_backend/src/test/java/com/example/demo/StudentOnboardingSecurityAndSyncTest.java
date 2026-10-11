package com.example.demo;

import com.example.demo.controller.StudentOnboardingController;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.StudentOnboardingService;
import com.example.demo.service.Y23AidsCurriculumSeeder;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
public class StudentOnboardingSecurityAndSyncTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private StudentOnboardingController onboardingController;

    @Autowired
    private StudentOnboardingService onboardingService;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private OnboardingTokenRepository onboardingTokenRepository;

    @Autowired
    private StudentSelectionRepository studentSelectionRepository;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private DegreeProgramRepository degreeProgramRepository;

    @Autowired
    private CurriculumVersionRepository curriculumVersionRepository;

    @Autowired
    private SpecializationRepository specializationRepository;

    @Autowired
    private HonorsProgramRepository honorsProgramRepository;

    @Autowired
    private DegreePathRepository degreePathRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    private Student studentA;
    private Student studentB;
    private DegreeProgram testProgram;
    private CurriculumVersion testVersion;
    private Specialization testSpec;
    private HonorsProgram testHonors;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();

        // Setup test students
        studentA = new Student();
        studentA.setStudentId("ONBOARD_STD_A");
        studentA.setFirstName("Alice");
        studentA.setLastName("Student");
        studentA.setEmail("alice.onboard@klu.edu");
        studentA.setDateOfBirth(LocalDate.of(2005, 5, 20));
        studentA.setPassword(passwordEncoder.encode("InitialTempPass"));
        studentA.setFirstLoginCompleted(false);
        studentA.setDepartment("CSE");
        studentA = studentRepository.save(studentA);

        studentB = new Student();
        studentB.setStudentId("ONBOARD_STD_B");
        studentB.setFirstName("Bob");
        studentB.setLastName("Student");
        studentB.setEmail("bob.onboard@klu.edu");
        studentB.setDateOfBirth(LocalDate.of(2005, 8, 15));
        studentB.setPassword(passwordEncoder.encode("InitialTempPassB"));
        studentB.setFirstLoginCompleted(false);
        studentB.setDepartment("CSE");
        studentB = studentRepository.save(studentB);

        // Setup test program and curriculum options
        testProgram = new DegreeProgram();
        testProgram.setCode("BTECH_CSE_ONBOARD");
        testProgram.setName("Bachelor of Technology in CSE");
        testProgram.setBranch("CSE");
        testProgram.setBatchStart(2023);
        testProgram.setBatchEnd(2027);
        testProgram.setRegulation("Y23");
        testProgram.setDurationYears(4);
        testProgram = degreeProgramRepository.save(testProgram);

        testVersion = new CurriculumVersion();
        testVersion.setVersionName("Y23-V1.0");
        testVersion.setProgram(testProgram);
        testVersion.setRegulation("Y23");
        testVersion = curriculumVersionRepository.save(testVersion);

        testSpec = new Specialization();
        testSpec.setName("Artificial Intelligence");
        testSpec.setCode("AI");
        testSpec.setProgram(testProgram);
        testSpec = specializationRepository.save(testSpec);

        testHonors = new HonorsProgram();
        testHonors.setName("Honors in Technology");
        testHonors.setCode("HTE");
        testHonors.setProgram(testProgram);
        testHonors = honorsProgramRepository.save(testHonors);
    }

    @Test
    @DisplayName("Unauthenticated password reset without token is rejected")
    public void testUnauthenticatedCompleteFirstLoginRejected() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        Map<String, Object> payload = new HashMap<>();
        payload.put("userId", studentA.getId());
        payload.put("password", "HackedPass123");
        payload.put("confirmPassword", "HackedPass123");

        ResponseEntity<?> response = onboardingController.completeFirstLogin(request, payload);
        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());

        Student freshA = studentRepository.findById(studentA.getId()).orElseThrow();
        assertFalse(freshA.getFirstLoginCompleted());
        assertFalse(passwordEncoder.matches("HackedPass123", freshA.getPassword()));
    }

    @Test
    @DisplayName("Invalid verification token is rejected")
    public void testInvalidTokenRejected() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Onboarding-Token", "fake-nonexistent-token-xyz");

        Map<String, Object> payload = new HashMap<>();
        payload.put("userId", studentA.getId());
        payload.put("password", "NewPass123");
        payload.put("confirmPassword", "NewPass123");

        ResponseEntity<?> response = onboardingController.completeFirstLogin(request, payload);
        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
    }

    @Test
    @DisplayName("Expired verification token is rejected")
    public void testExpiredTokenRejected() {
        // Generate valid token
        Map<String, Object> verifyRes = onboardingService.verifyFirstLogin(studentA.getStudentId(), "2005-05-20");
        assertNotNull(verifyRes);
        String rawToken = (String) verifyRes.get("token");

        // Expire token in database
        String tokenHash = onboardingService.hashToken(rawToken);
        OnboardingToken token = onboardingTokenRepository.findByTokenHash(tokenHash).orElseThrow();
        token.setExpiryDate(LocalDateTime.now().minusMinutes(5));
        onboardingTokenRepository.save(token);

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Onboarding-Token", rawToken);

        Map<String, Object> payload = new HashMap<>();
        payload.put("userId", studentA.getId());
        payload.put("password", "NewPass123");
        payload.put("confirmPassword", "NewPass123");

        ResponseEntity<?> response = onboardingController.completeFirstLogin(request, payload);
        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
    }

    @Test
    @DisplayName("Token cannot be reused to reset password multiple times")
    public void testReusedTokenRejected() {
        Map<String, Object> verifyRes = onboardingService.verifyFirstLogin(studentA.getStudentId(), "2005-05-20");
        String rawToken = (String) verifyRes.get("token");

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Onboarding-Token", rawToken);

        Map<String, Object> payload = new HashMap<>();
        payload.put("userId", studentA.getId());
        payload.put("password", "FirstNewPass123");
        payload.put("confirmPassword", "FirstNewPass123");

        ResponseEntity<?> firstRes = onboardingController.completeFirstLogin(request, payload);
        assertEquals(HttpStatus.OK, firstRes.getStatusCode());

        // Attempt second password reset with same token
        Map<String, Object> secondPayload = new HashMap<>();
        secondPayload.put("userId", studentA.getId());
        secondPayload.put("password", "SecondPass456");
        secondPayload.put("confirmPassword", "SecondPass456");

        ResponseEntity<?> secondRes = onboardingController.completeFirstLogin(request, secondPayload);
        assertEquals(HttpStatus.UNAUTHORIZED, secondRes.getStatusCode());
    }

    @Test
    @DisplayName("Valid first-login verification creates password and updates completion status")
    public void testValidFirstLoginFlowSucceeds() {
        // Step 1: Verify first login
        Map<String, String> creds = Map.of("username", studentA.getStudentId(), "dateOfBirth", "2005-05-20");
        ResponseEntity<?> verifyRes = onboardingController.verifyFirstLogin(creds);
        assertEquals(HttpStatus.OK, verifyRes.getStatusCode());

        @SuppressWarnings("unchecked")
        Map<String, Object> body = (Map<String, Object>) verifyRes.getBody();
        assertNotNull(body);
        String rawToken = (String) body.get("token");
        assertNotNull(rawToken);

        // Step 2: Complete first login
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Onboarding-Token", rawToken);

        Map<String, Object> payload = new HashMap<>();
        payload.put("userId", studentA.getId());
        payload.put("password", "SecureNewPassword123");
        payload.put("confirmPassword", "SecureNewPassword123");

        ResponseEntity<?> completeRes = onboardingController.completeFirstLogin(request, payload);
        assertEquals(HttpStatus.OK, completeRes.getStatusCode());

        Student fresh = studentRepository.findById(studentA.getId()).orElseThrow();
        assertTrue(fresh.getFirstLoginCompleted());
        assertTrue(passwordEncoder.matches("SecureNewPassword123", fresh.getPassword()));
        assertNull(fresh.getRawPassword()); // Never store plaintext password
    }

    @Test
    @DisplayName("Cross-student tampering is prevented: token for student A cannot alter student B")
    public void testCrossStudentTamperingPrevented() {
        Map<String, Object> verifyResA = onboardingService.verifyFirstLogin(studentA.getStudentId(), "2005-05-20");
        String tokenA = (String) verifyResA.get("token");

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Onboarding-Token", tokenA);

        // Student A's token attempting to modify Student B's profile
        Map<String, Object> profileData = new HashMap<>();
        profileData.put("studentId", studentB.getId());
        profileData.put("section", "HACKED_SEC");

        ResponseEntity<?> profileRes = onboardingController.updateProfile(request, profileData);
        assertEquals(HttpStatus.FORBIDDEN, profileRes.getStatusCode());

        // Student A's token attempting to view Student B's profile
        ResponseEntity<?> getRes = onboardingController.getOnboardingProfile(request, studentB.getId());
        assertEquals(HttpStatus.FORBIDDEN, getRes.getStatusCode());
    }

    @Test
    @DisplayName("Valid track selection synchronizes student specialization, sub-department, and degree path")
    public void testValidTrackSelectionSynchronizesStudentAndDegreePath() {
        Map<String, Object> verifyRes = onboardingService.verifyFirstLogin(studentA.getStudentId(), "2005-05-20");
        String token = (String) verifyRes.get("token");

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Onboarding-Token", token);

        StudentSelection selection = new StudentSelection();
        selection.setProgram(testProgram);
        selection.setCurriculumVersion(testVersion);
        selection.setSpecialization(testSpec);
        selection.setHonorsProgram(testHonors);
        selection.setExtensionType("HONORS_SPECIALIZATION");

        ResponseEntity<?> res = onboardingController.saveSelection(request, selection);
        assertEquals(HttpStatus.OK, res.getStatusCode());

        // Check Student entity synchronization
        Student fresh = studentRepository.findById(studentA.getId()).orElseThrow();
        assertEquals("HTE", fresh.getSubDepartment());
        assertEquals("SPECIALIZATION", fresh.getSpecializationType());
        assertEquals("Artificial Intelligence", fresh.getSpecializationName());

        // Check StudentDegreePath assigned
        assertTrue(studentDegreePathRepository.findByStudentId(studentA.getId()).isPresent());

        // Check StudentSelection persisted
        assertTrue(studentSelectionRepository.findByStudentId(studentA.getId()).isPresent());
    }

    @Test
    @DisplayName("Repeated selection submissions are idempotent and do not create duplicates")
    public void testRepeatedSubmissionsAreIdempotent() {
        Map<String, Object> verifyRes = onboardingService.verifyFirstLogin(studentA.getStudentId(), "2005-05-20");
        String token = (String) verifyRes.get("token");

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Onboarding-Token", token);

        StudentSelection sel1 = new StudentSelection();
        sel1.setProgram(testProgram);
        sel1.setCurriculumVersion(testVersion);
        sel1.setSpecialization(testSpec);

        onboardingController.saveSelection(request, sel1);

        long countSelections = studentSelectionRepository.count();
        long countPaths = studentDegreePathRepository.count();

        // Submit second time with new selection update
        StudentSelection sel2 = new StudentSelection();
        sel2.setProgram(testProgram);
        sel2.setCurriculumVersion(testVersion);
        sel2.setSpecialization(testSpec);
        sel2.setHonorsProgram(testHonors);

        // When token was marked used on first completion, retry using student's authenticated session
        onboardingService.saveSelection(token, sel2);

        // Verify count didn't increase
        assertEquals(countSelections, studentSelectionRepository.count());
        assertEquals(countPaths, studentDegreePathRepository.count());

        Student fresh = studentRepository.findById(studentA.getId()).orElseThrow();
        assertEquals("HTE", fresh.getSubDepartment());
    }

    @Test
    @DisplayName("Invalid track selection with non-existent program is rejected and rolls back")
    public void testInvalidTrackSelectionFailsValidation() {
        Map<String, Object> verifyRes = onboardingService.verifyFirstLogin(studentA.getStudentId(), "2005-05-20");
        String token = (String) verifyRes.get("token");

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader("X-Onboarding-Token", token);

        DegreeProgram fakeProgram = new DegreeProgram();
        fakeProgram.setId(999999L);

        StudentSelection selection = new StudentSelection();
        selection.setProgram(fakeProgram);

        ResponseEntity<?> res = onboardingController.saveSelection(request, selection);
        assertEquals(HttpStatus.BAD_REQUEST, res.getStatusCode());

        // Verify nothing was saved
        assertTrue(studentSelectionRepository.findByStudentId(studentA.getId()).isEmpty());
    }

    @Test
    @DisplayName("Student who already completed first login cannot repeat first-login verification")
    public void testAlreadyCompletedFirstLoginCannotReVerify() {
        studentA.setFirstLoginCompleted(true);
        studentRepository.save(studentA);

        Map<String, String> creds = Map.of("username", studentA.getStudentId(), "dateOfBirth", "2005-05-20");
        ResponseEntity<?> res = onboardingController.verifyFirstLogin(creds);

        assertEquals(HttpStatus.BAD_REQUEST, res.getStatusCode());
        @SuppressWarnings("unchecked")
        Map<String, Object> body = (Map<String, Object>) res.getBody();
        assertNotNull(body);
        assertTrue((Boolean) body.get("firstLoginCompleted"));
    }

    // ==================== DOB Verification Regression Tests ====================

    @Test
    @DisplayName("Verification with missing (null) DOB is rejected and issues no token")
    public void testVerifyFirstLoginWithMissingDobRejected() {
        Map<String, String> creds = new HashMap<>();
        creds.put("username", studentA.getStudentId());
        // dateOfBirth omitted entirely

        ResponseEntity<?> res = onboardingController.verifyFirstLogin(creds);
        assertEquals(HttpStatus.UNAUTHORIZED, res.getStatusCode());
        assertEquals(0, onboardingTokenRepository.count());
    }

    @Test
    @DisplayName("Verification with blank/empty DOB is rejected and issues no token")
    public void testVerifyFirstLoginWithBlankDobRejected() {
        Map<String, String> creds = Map.of("username", studentA.getStudentId(), "dateOfBirth", "   ");

        ResponseEntity<?> res = onboardingController.verifyFirstLogin(creds);
        assertEquals(HttpStatus.UNAUTHORIZED, res.getStatusCode());
        assertEquals(0, onboardingTokenRepository.count());
    }

    @Test
    @DisplayName("Verification with malformed DOB format is rejected and issues no token")
    public void testVerifyFirstLoginWithMalformedDobRejected() {
        Map<String, String> creds = Map.of("username", studentA.getStudentId(), "dateOfBirth", "not-a-valid-date");

        ResponseEntity<?> res = onboardingController.verifyFirstLogin(creds);
        assertEquals(HttpStatus.UNAUTHORIZED, res.getStatusCode());
        assertEquals(0, onboardingTokenRepository.count());
    }

    @Test
    @DisplayName("Verification with incorrect DOB is rejected and issues no token")
    public void testVerifyFirstLoginWithIncorrectDobRejected() {
        Map<String, String> creds = Map.of("username", studentA.getStudentId(), "dateOfBirth", "2000-01-01");

        ResponseEntity<?> res = onboardingController.verifyFirstLogin(creds);
        assertEquals(HttpStatus.UNAUTHORIZED, res.getStatusCode());
        assertEquals(0, onboardingTokenRepository.count());
    }

    @Test
    @DisplayName("Verification when student record has null DOB in database is rejected")
    public void testVerifyFirstLoginWhenStudentStoredDobIsNullRejected() {
        studentB.setDateOfBirth(null);
        studentRepository.save(studentB);

        Map<String, String> creds = Map.of("username", studentB.getStudentId(), "dateOfBirth", "2005-08-15");

        ResponseEntity<?> res = onboardingController.verifyFirstLogin(creds);
        assertEquals(HttpStatus.UNAUTHORIZED, res.getStatusCode());
        assertEquals(0, onboardingTokenRepository.count());
    }

    @Test
    @DisplayName("Verification with exact matching DOB succeeds and issues valid token")
    public void testVerifyFirstLoginWithCorrectDobSucceeds() {
        Map<String, String> creds = Map.of("username", studentA.getStudentId(), "dateOfBirth", "2005-05-20");

        ResponseEntity<?> res = onboardingController.verifyFirstLogin(creds);
        assertEquals(HttpStatus.OK, res.getStatusCode());
        @SuppressWarnings("unchecked")
        Map<String, Object> body = (Map<String, Object>) res.getBody();
        assertNotNull(body);
        assertNotNull(body.get("token"));
        assertEquals(studentA.getId(), body.get("userId"));
        assertEquals(1, onboardingTokenRepository.count());
    }

    // ==================== Concurrency Protection Tests ====================

    @Test
    @DisplayName("Atomic token update prevents concurrent token reuse")
    public void testConcurrentPasswordCreationPrevention() {
        Map<String, Object> verifyRes = onboardingService.verifyFirstLogin(studentA.getStudentId(), "2005-05-20");
        String rawToken = (String) verifyRes.get("token");
        String tokenHash = onboardingService.hashToken(rawToken);

        OnboardingToken token = onboardingTokenRepository.findByTokenHash(tokenHash).orElseThrow();
        assertFalse(token.getPasswordCreated());

        // First atomic claim succeeds (returns 1 updated row)
        int firstUpdate = onboardingTokenRepository.markPasswordCreatedAtomic(token.getId());
        assertEquals(1, firstUpdate);

        // Second concurrent claim fails (returns 0 updated rows because passwordCreated is already true)
        int secondUpdate = onboardingTokenRepository.markPasswordCreatedAtomic(token.getId());
        assertEquals(0, secondUpdate);

        // Service completeFirstLogin will reject because token was already consumed
        assertThrows(SecurityException.class, () ->
                onboardingService.completeFirstLogin(rawToken, studentA.getId(), "AnotherPassword123")
        );
    }

    // ==================== HTTP-Level MockMvc Security Tests ====================

    @Test
    @DisplayName("HTTP MockMvc: Verify first login endpoint succeeds with valid credentials")
    public void testHttpEndpointVerifyFirstLoginViaMockMvc() throws Exception {
        Map<String, String> creds = Map.of("username", studentA.getStudentId(), "dateOfBirth", "2005-05-20");

        mockMvc.perform(post("/api/onboarding/verify-first-login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(creds)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").exists())
                .andExpect(jsonPath("$.userId").value(studentA.getId()));
    }

    @Test
    @DisplayName("HTTP MockMvc: CORS preflight allows X-Onboarding-Token header")
    public void testHttpCorsPreflightAllowsOnboardingToken() throws Exception {
        mockMvc.perform(options("/api/onboarding/profile/" + studentA.getId())
                .header("Origin", "http://localhost:3086")
                .header("Access-Control-Request-Method", "GET")
                .header("Access-Control-Request-Headers", "X-Onboarding-Token,Content-Type"))
                .andExpect(status().isOk())
                .andExpect(header().exists("Access-Control-Allow-Origin"))
                .andExpect(header().string("Access-Control-Allow-Headers", org.hamcrest.Matchers.containsString("X-Onboarding-Token")));
    }

    @Test
    @DisplayName("HTTP MockMvc: Unauthenticated complete-first-login without token is rejected with 401")
    public void testHttpUnauthenticatedPasswordResetRejected() throws Exception {
        Map<String, Object> payload = Map.of(
                "userId", studentA.getId(),
                "password", "NewPass123",
                "confirmPassword", "NewPass123"
        );

        mockMvc.perform(post("/api/onboarding/complete-first-login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(payload)))
                .andExpect(status().isUnauthorized());
    }
}
