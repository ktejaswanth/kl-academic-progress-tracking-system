package com.example.demo.service;

import com.example.demo.model.StudentProfile;
import com.example.demo.model.StudentSelection;
import com.example.demo.model.User;
import com.example.demo.repository.StudentProfileRepository;
import com.example.demo.repository.StudentSelectionRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class StudentOnboardingService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private StudentSelectionRepository studentSelectionRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private com.example.demo.repository.StudentRepository studentRepository;

    public Optional<User> verifyFirstLogin(String username, String dobString) {
        Optional<User> user = userRepository.findByUsername(username);
        if (user.isEmpty()) {
            return Optional.empty();
        }
        try {
            java.time.LocalDate dob = java.time.LocalDate.parse(dobString);
            if (user.get().getDateOfBirth() == null || !user.get().getDateOfBirth().equals(dob)) {
                return Optional.empty();
            }
            return user;
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    public Map<String, Object> completeFirstLogin(Long userId, String password) {
        String encoded = passwordEncoder.encode(password);
        
        Optional<com.example.demo.model.Student> studentOpt = studentRepository.findById(userId);
        if (studentOpt.isPresent()) {
            com.example.demo.model.Student s = studentOpt.get();
            s.setPassword(encoded);
            s.setRawPassword(password);
            s.setFirstLoginCompleted(true);
            studentRepository.save(s);
            return Map.of("userId", s.getId(), "username", s.getStudentId(), "firstLoginCompleted", true);
        }

        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));
        user.setPasswordHash(encoded);
        user.setRawPassword(password);
        user.setForcePasswordChange(false);
        user.setFirstLoginCompleted(true);
        userRepository.save(user);

        studentRepository.findByStudentId(user.getUsername()).ifPresent(s -> {
            s.setPassword(encoded);
            s.setRawPassword(password);
            s.setFirstLoginCompleted(true);
            studentRepository.save(s);
        });

        return Map.of("userId", user.getId(), "username", user.getUsername(), "firstLoginCompleted", true);
    }

    public StudentProfile updateProfile(Long userId, Map<String, Object> profileData) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        StudentProfile profile = studentProfileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    StudentProfile newProfile = new StudentProfile();
                    newProfile.setUser(user);
                    return newProfile;
                });

        // Secure: Student is NOT allowed to change department, honors, degree, branch, or batch details.
        // We lock these to existing database profile values or user entity defaults.
        if (profile.getDegreeType() == null) {
            profile.setDegreeType("B.Tech");
        }
        if (profile.getSpecialization() == null) {
            profile.setSpecialization(user.getDepartment() != null ? user.getDepartment() : "CSE");
        }
        if (profile.getHonorsType() == null) {
            profile.setHonorsType(user.getSubDepartment() != null ? user.getSubDepartment() : "REGULAR");
        }
        if (profile.getBranch() == null) {
            profile.setBranch(user.getDepartment());
        }
        if (profile.getBatch() == null) {
            profile.setBatch(user.getCreatedAt() != null ? user.getCreatedAt().toLocalDate().getYear() : java.time.LocalDate.now().getYear());
        }

        profile.setCurrentYear(profileData.get("currentYear") != null ? Integer.valueOf(profileData.get("currentYear").toString()) : profile.getCurrentYear());
        profile.setSection((String) profileData.getOrDefault("section", profile.getSection()));
        profile.setHonorsOption((String) profileData.getOrDefault("honorsOption", profile.getHonorsOption()));
        profile.setExtensionType((String) profileData.getOrDefault("extensionType", profile.getExtensionType()));

        return studentProfileRepository.save(profile);
    }

    public Map<String, Object> getOnboardingProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        StudentProfile profile = studentProfileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    StudentProfile newProfile = new StudentProfile();
                    newProfile.setUser(user);
                    newProfile.setDegreeType("B.Tech");
                    newProfile.setSpecialization(user.getDepartment() != null ? user.getDepartment() : "CSE");
                    newProfile.setHonorsType(user.getSubDepartment() != null ? user.getSubDepartment() : "REGULAR");
                    newProfile.setCurrentYear(1);
                    newProfile.setAdmissionYear(java.time.LocalDate.now().getYear());
                    return studentProfileRepository.save(newProfile);
                });

        Map<String, Object> result = new java.util.HashMap<>();
        result.put("userId", user.getId());
        result.put("username", user.getUsername());
        result.put("email", user.getEmail());
        result.put("firstName", user.getFirstName());
        result.put("lastName", user.getLastName());
        result.put("department", user.getDepartment());
        result.put("subDepartment", user.getSubDepartment());
        result.put("specializationType", user.getSpecializationType());
        result.put("specializationName", user.getSpecializationName());
        
        result.put("degreeType", profile.getDegreeType());
        result.put("specialization", profile.getSpecialization());
        result.put("honorsType", profile.getHonorsType());
        result.put("branch", profile.getBranch() != null ? profile.getBranch() : user.getDepartment());
        result.put("batch", profile.getBatch() != null ? profile.getBatch() : (user.getCreatedAt() != null ? user.getCreatedAt().toLocalDate().getYear() : java.time.LocalDate.now().getYear()));
        result.put("currentYear", profile.getCurrentYear());
        result.put("section", profile.getSection());
        result.put("honorsOption", profile.getHonorsOption());
        result.put("extensionType", profile.getExtensionType());
        
        return result;
    }

    public StudentSelection saveSelection(StudentSelection selection) {
        Optional<StudentSelection> existing = studentSelectionRepository.findByStudentId(selection.getStudent().getId());
        if (existing.isPresent()) {
            StudentSelection current = existing.get();
            current.setProgram(selection.getProgram());
            current.setCurriculumVersion(selection.getCurriculumVersion());
            current.setHonorsProgram(selection.getHonorsProgram());
            current.setSpecialization(selection.getSpecialization());
            current.setMinorProgramIds(selection.getMinorProgramIds());
            current.setDoubleMajorIds(selection.getDoubleMajorIds());
            current.setExtensionType(selection.getExtensionType());
            return studentSelectionRepository.save(current);
        }
        return studentSelectionRepository.save(selection);
    }
}
