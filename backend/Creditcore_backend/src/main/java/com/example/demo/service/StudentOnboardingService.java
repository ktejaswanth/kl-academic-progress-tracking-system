package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.*;

@Service
@Transactional
public class StudentOnboardingService {

    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private StudentSelectionRepository studentSelectionRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private OnboardingTokenRepository onboardingTokenRepository;

    @Autowired
    private DegreeProgramRepository degreeProgramRepository;

    @Autowired
    private CurriculumVersionRepository curriculumVersionRepository;

    @Autowired
    private SpecializationRepository specializationRepository;

    @Autowired
    private HonorsProgramRepository honorsProgramRepository;

    @Autowired
    private DegreePathEngine degreePathEngine;

    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    public String hashToken(String rawToken) {
        if (rawToken == null) return null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(rawToken.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedHash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    public Map<String, Object> verifyFirstLogin(String username, String dobString) {
        Optional<Student> studentOpt = studentRepository.findByStudentId(username);
        if (studentOpt.isEmpty()) {
            return null;
        }

        Student student = studentOpt.get();

        if (Boolean.TRUE.equals(student.getFirstLoginCompleted())) {
            throw new IllegalStateException("First-time login has already been completed for this account.");
        }

        if (dobString == null || dobString.trim().isEmpty() || student.getDateOfBirth() == null) {
            return null;
        }

        try {
            java.time.LocalDate dob = java.time.LocalDate.parse(dobString.trim());
            if (!student.getDateOfBirth().equals(dob)) {
                return null;
            }
        } catch (Exception e) {
            return null;
        }

        // Generate cryptographically random verification token
        String rawToken = UUID.randomUUID().toString() + "-" + UUID.randomUUID().toString();
        String tokenHash = hashToken(rawToken);

        // Invalidate any prior unused tokens for this student
        onboardingTokenRepository.deleteByStudentId(student.getId());

        OnboardingToken token = new OnboardingToken();
        token.setTokenHash(tokenHash);
        token.setStudentId(student.getId());
        token.setUsername(student.getStudentId());
        token.setExpiryDate(LocalDateTime.now().plusMinutes(15));
        token.setPasswordCreated(false);
        token.setIsUsed(false);
        onboardingTokenRepository.save(token);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("userId", student.getId());
        result.put("username", student.getStudentId());
        result.put("firstLoginCompleted", false);
        result.put("token", rawToken);
        return result;
    }

    public OnboardingToken validateAndGetToken(String rawToken, boolean allowAlreadyUsed) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            throw new SecurityException("Missing onboarding verification token.");
        }

        String cleaned = rawToken.trim();
        if (cleaned.startsWith("Bearer ") || cleaned.startsWith("bearer ")) {
            cleaned = cleaned.substring(7).trim();
        }

        String hash = hashToken(cleaned);
        OnboardingToken token = onboardingTokenRepository.findByTokenHash(hash)
                .orElseThrow(() -> new SecurityException("Invalid onboarding verification token."));

        if (token.isExpired()) {
            throw new SecurityException("Verification token has expired. Please verify your identity again.");
        }

        if (!allowAlreadyUsed && Boolean.TRUE.equals(token.getIsUsed())) {
            throw new SecurityException("Verification token has already been used.");
        }

        return token;
    }

    public OnboardingToken validateAndGetToken(String rawToken) {
        return validateAndGetToken(rawToken, false);
    }

    public Student resolveVerifiedStudent(String rawToken, Long clientUserId, boolean allowAlreadyUsed) {
        if (rawToken != null && !rawToken.trim().isEmpty()) {
            OnboardingToken token = validateAndGetToken(rawToken, allowAlreadyUsed);
            if (clientUserId != null && !clientUserId.equals(token.getStudentId())) {
                throw new SecurityException("Mismatched student identity for verification token.");
            }
            return studentRepository.findById(token.getStudentId())
                    .orElseThrow(() -> new RuntimeException("Student not found: " + token.getStudentId()));
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getName())) {
            String username = auth.getName();
            boolean isStaff = auth.getAuthorities().stream().anyMatch(a ->
                    a.getAuthority().equals("ROLE_ADMIN") ||
                    a.getAuthority().equals("ROLE_SUPER_ADMIN") ||
                    a.getAuthority().equals("ROLE_FACULTY"));

            if (isStaff && clientUserId != null) {
                return studentRepository.findById(clientUserId)
                        .orElseThrow(() -> new RuntimeException("Student not found with ID: " + clientUserId));
            }

            Student student = studentRepository.findByStudentId(username)
                    .orElseThrow(() -> new RuntimeException("Authenticated student record not found: " + username));

            if (clientUserId != null && !clientUserId.equals(student.getId())) {
                throw new SecurityException("Cannot access or modify another student's onboarding record.");
            }
            return student;
        }

        throw new SecurityException("Unauthorized: Valid onboarding verification token or authentication required.");
    }

    public Student resolveVerifiedStudent(String rawToken, Long clientUserId) {
        return resolveVerifiedStudent(rawToken, clientUserId, false);
    }

    public Map<String, Object> completeFirstLogin(String rawToken, Long clientUserId, String password) {
        if (rawToken == null || rawToken.trim().isEmpty()) {
            throw new SecurityException("Missing onboarding verification token.");
        }

        String cleaned = rawToken.trim();
        if (cleaned.startsWith("Bearer ") || cleaned.startsWith("bearer ")) {
            cleaned = cleaned.substring(7).trim();
        }

        String hash = hashToken(cleaned);
        OnboardingToken token = onboardingTokenRepository.findByTokenHashWithLock(hash)
                .orElseThrow(() -> new SecurityException("Invalid onboarding verification token."));

        if (token.isExpired()) {
            throw new SecurityException("Verification token has expired. Please verify your identity again.");
        }

        if (Boolean.TRUE.equals(token.getPasswordCreated())) {
            throw new SecurityException("Password has already been created using this verification token.");
        }

        if (clientUserId != null && !clientUserId.equals(token.getStudentId())) {
            throw new SecurityException("Mismatched student identity for verification token.");
        }

        // Atomically mark token as password created to eliminate race conditions
        int updated = onboardingTokenRepository.markPasswordCreatedAtomic(token.getId());
        if (updated == 0) {
            throw new SecurityException("Password has already been created using this verification token.");
        }

        Student s = studentRepository.findById(token.getStudentId())
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + token.getStudentId()));

        String encoded = passwordEncoder.encode(password);
        s.setPassword(encoded);
        s.setRawPassword(null); // Never store raw password
        s.setFirstLoginCompleted(true);
        studentRepository.save(s);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("userId", s.getId());
        result.put("username", s.getStudentId());
        result.put("firstLoginCompleted", true);
        result.put("token", rawToken);
        return result;
    }

    public StudentProfile updateProfile(String rawToken, Long clientUserId, Map<String, Object> profileData) {
        Student student = resolveVerifiedStudent(rawToken, clientUserId);

        StudentProfile profile = studentProfileRepository.findByUserId(student.getId())
                .orElseGet(() -> {
                    StudentProfile newProfile = new StudentProfile();
                    newProfile.setUser(student);
                    return newProfile;
                });

        if (profile.getDegreeType() == null) {
            profile.setDegreeType("B.Tech");
        }
        if (profile.getSpecialization() == null) {
            profile.setSpecialization(student.getSpecializationName() != null ? student.getSpecializationName() : student.getDepartment());
        }
        if (profile.getHonorsType() == null) {
            profile.setHonorsType(student.getSubDepartment() != null ? student.getSubDepartment() : "REGULAR");
        }
        if (profile.getBranch() == null) {
            profile.setBranch(student.getDepartment());
        }
        if (profile.getBatch() == null) {
            profile.setBatch(student.getCreatedAt() != null ? student.getCreatedAt().toLocalDate().getYear() : java.time.LocalDate.now().getYear());
        }

        if (profileData.get("currentYear") != null) {
            try {
                profile.setCurrentYear(Integer.valueOf(profileData.get("currentYear").toString()));
            } catch (Exception ignored) {}
        }
        profile.setSection((String) profileData.getOrDefault("section", profile.getSection()));
        profile.setHonorsOption((String) profileData.getOrDefault("honorsOption", profile.getHonorsOption()));
        profile.setExtensionType((String) profileData.getOrDefault("extensionType", profile.getExtensionType()));

        return studentProfileRepository.save(profile);
    }

    public Map<String, Object> getOnboardingProfile(String rawToken, Long clientUserId) {
        Student student = resolveVerifiedStudent(rawToken, clientUserId);

        StudentProfile profile = studentProfileRepository.findByUserId(student.getId())
                .orElseGet(() -> {
                    StudentProfile newProfile = new StudentProfile();
                    newProfile.setUser(student);
                    newProfile.setDegreeType("B.Tech");
                    newProfile.setSpecialization(student.getSpecializationName() != null ? student.getSpecializationName() : student.getDepartment());
                    newProfile.setHonorsType(student.getSubDepartment() != null ? student.getSubDepartment() : "REGULAR");
                    newProfile.setCurrentYear(1);
                    newProfile.setAdmissionYear(java.time.LocalDate.now().getYear());
                    return studentProfileRepository.save(newProfile);
                });

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("userId", student.getId());
        result.put("username", student.getStudentId());
        result.put("email", student.getEmail());
        result.put("firstName", student.getFirstName());
        result.put("lastName", student.getLastName());
        result.put("department", student.getDepartment());
        result.put("subDepartment", student.getSubDepartment());
        result.put("specializationType", student.getSpecializationType());
        result.put("specializationName", student.getSpecializationName());

        result.put("degreeType", profile.getDegreeType());
        result.put("specialization", profile.getSpecialization());
        result.put("honorsType", profile.getHonorsType());
        result.put("branch", profile.getBranch() != null ? profile.getBranch() : student.getDepartment());
        result.put("batch", profile.getBatch() != null ? profile.getBatch() : (student.getCreatedAt() != null ? student.getCreatedAt().toLocalDate().getYear() : java.time.LocalDate.now().getYear()));
        result.put("currentYear", profile.getCurrentYear());
        result.put("section", profile.getSection());
        result.put("honorsOption", profile.getHonorsOption());
        result.put("extensionType", profile.getExtensionType());

        return result;
    }

    public StudentSelection saveSelection(String rawToken, StudentSelection selection) {
        Long clientStudentId = (selection.getStudent() != null) ? selection.getStudent().getId() : null;
        Student verifiedStudent = resolveVerifiedStudent(rawToken, clientStudentId, true);

        // 1. Validate Track Selection against curriculum configuration
        if (selection.getProgram() == null || selection.getProgram().getId() == null) {
            throw new IllegalArgumentException("Degree program is required.");
        }
        DegreeProgram program = degreeProgramRepository.findById(selection.getProgram().getId())
                .orElseThrow(() -> new IllegalArgumentException("Degree program not found with ID: " + selection.getProgram().getId()));
        selection.setProgram(program);

        if (selection.getCurriculumVersion() != null && selection.getCurriculumVersion().getId() != null) {
            CurriculumVersion version = curriculumVersionRepository.findById(selection.getCurriculumVersion().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Curriculum version not found with ID: " + selection.getCurriculumVersion().getId()));
            if (version.getProgram() != null && !version.getProgram().getId().equals(program.getId())) {
                throw new IllegalArgumentException("Curriculum version does not belong to selected degree program.");
            }
            selection.setCurriculumVersion(version);
        }

        Specialization specialization = null;
        if (selection.getSpecialization() != null && selection.getSpecialization().getId() != null) {
            specialization = specializationRepository.findById(selection.getSpecialization().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Specialization not found with ID: " + selection.getSpecialization().getId()));
            if (specialization.getProgram() != null && !specialization.getProgram().getId().equals(program.getId())) {
                throw new IllegalArgumentException("Specialization does not belong to selected degree program.");
            }
            selection.setSpecialization(specialization);
        }

        HonorsProgram honorsProgram = null;
        if (selection.getHonorsProgram() != null && selection.getHonorsProgram().getId() != null) {
            honorsProgram = honorsProgramRepository.findById(selection.getHonorsProgram().getId())
                    .orElseThrow(() -> new IllegalArgumentException("Honors program not found with ID: " + selection.getHonorsProgram().getId()));
            if (honorsProgram.getProgram() != null && !honorsProgram.getProgram().getId().equals(program.getId())) {
                throw new IllegalArgumentException("Honors program does not belong to selected degree program.");
            }
            selection.setHonorsProgram(honorsProgram);
        }

        // 2. Persist selection (idempotent: avoid duplicate records)
        StudentSelection savedSelection;
        Optional<StudentSelection> existing = studentSelectionRepository.findByStudentId(verifiedStudent.getId());
        if (existing.isPresent()) {
            StudentSelection current = existing.get();
            current.setProgram(program);
            current.setCurriculumVersion(selection.getCurriculumVersion());
            current.setHonorsProgram(honorsProgram);
            current.setSpecialization(specialization);
            current.setMinorProgramIds(selection.getMinorProgramIds());
            current.setDoubleMajorIds(selection.getDoubleMajorIds());
            current.setExtensionType(selection.getExtensionType());
            savedSelection = studentSelectionRepository.save(current);
        } else {
            selection.setStudent(verifiedStudent);
            savedSelection = studentSelectionRepository.save(selection);
        }

        // 3. Synchronize Student entity attributes
        if (verifiedStudent.getDepartment() == null || verifiedStudent.getDepartment().trim().isEmpty()) {
            verifiedStudent.setDepartment(program.getBranch() != null ? program.getBranch() : "CSE");
        }

        if (honorsProgram != null) {
            String hCode = honorsProgram.getCode() != null && !honorsProgram.getCode().trim().isEmpty()
                    ? honorsProgram.getCode().trim()
                    : honorsProgram.getName();
            verifiedStudent.setSubDepartment(hCode);
        } else {
            verifiedStudent.setSubDepartment("REGULAR");
        }

        if (specialization != null) {
            verifiedStudent.setSpecializationType("SPECIALIZATION");
            verifiedStudent.setSpecializationName(specialization.getName());
        } else if (selection.getMinorProgramIds() != null && selection.getMinorProgramIds().length > 0) {
            verifiedStudent.setSpecializationType("MINOR");
            verifiedStudent.setSpecializationName(null);
        } else if (selection.getDoubleMajorIds() != null && selection.getDoubleMajorIds().length > 0) {
            verifiedStudent.setSpecializationType("DOUBLE_MAJOR");
            verifiedStudent.setSpecializationName(null);
        } else {
            verifiedStudent.setSpecializationType("NONE");
            verifiedStudent.setSpecializationName(null);
        }
        studentRepository.save(verifiedStudent);

        // 4. Synchronize StudentProfile
        StudentProfile profile = studentProfileRepository.findByUserId(verifiedStudent.getId())
                .orElseGet(() -> {
                    StudentProfile p = new StudentProfile();
                    p.setUser(verifiedStudent);
                    p.setDegreeType("B.Tech");
                    p.setCurrentYear(2);
                    p.setAdmissionYear(java.time.LocalDate.now().getYear());
                    return p;
                });
        if (profile.getDegreeType() == null) {
            profile.setDegreeType("B.Tech");
        }
        if (profile.getCurrentYear() == null) {
            profile.setCurrentYear(2);
        }
        if (profile.getAdmissionYear() == null) {
            profile.setAdmissionYear(java.time.LocalDate.now().getYear());
        }
        profile.setSpecialization(verifiedStudent.getSpecializationName() != null ? verifiedStudent.getSpecializationName() : (verifiedStudent.getDepartment() != null ? verifiedStudent.getDepartment() : "CSE"));
        profile.setHonorsType(verifiedStudent.getSubDepartment() != null ? verifiedStudent.getSubDepartment() : "REGULAR");
        profile.setExtensionType(selection.getExtensionType());
        studentProfileRepository.save(profile);

        // 5. Initialize or synchronize DegreePath association
        try {
            degreePathEngine.resolveAndAssignPath(verifiedStudent.getId());
        } catch (Exception e) {
            // If direct auto-resolution fails due to custom codes, fallback to REGULAR path
            System.err.println("Warning: Degree path auto-resolve failed for student " + verifiedStudent.getId() + ": " + e.getMessage());
        }

        // 6. Trigger initial eligibility and progress evaluation gracefully
        try {
            degreeEligibilityEngine.evaluateEligibility(verifiedStudent.getId());
        } catch (Exception e) {
            // Missing/incomplete bucket progress rules in catalog handled gracefully without failing selection
            System.err.println("Info: Eligibility evaluation deferred for student " + verifiedStudent.getId() + ": " + e.getMessage());
        }

        // 7. Mark onboarding token as used upon successful selection completion
        if (rawToken != null && !rawToken.trim().isEmpty()) {
            try {
                OnboardingToken token = validateAndGetToken(rawToken);
                token.setIsUsed(true);
                onboardingTokenRepository.save(token);
            } catch (Exception ignored) {}
        }

        return savedSelection;
    }
}
