package com.example.demo.service;

import com.example.demo.model.Student;
import com.example.demo.model.StudentProfile;
import com.example.demo.model.StudentSelection;
import com.example.demo.repository.StudentProfileRepository;
import com.example.demo.repository.StudentRepository;
import com.example.demo.repository.StudentSelectionRepository;
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
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private StudentSelectionRepository studentSelectionRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private StudentRepository studentRepository;

    public Optional<Student> verifyFirstLogin(String username, String dobString) {
        Optional<Student> studentOpt = studentRepository.findByStudentId(username);
        if (studentOpt.isEmpty()) {
            return Optional.empty();
        }
        if (dobString == null || dobString.trim().isEmpty()) {
            return studentOpt;
        }
        try {
            java.time.LocalDate dob = java.time.LocalDate.parse(dobString);
            if (studentOpt.get().getDateOfBirth() == null || !studentOpt.get().getDateOfBirth().equals(dob)) {
                return Optional.empty();
            }
            return studentOpt;
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    public Map<String, Object> completeFirstLogin(Long userId, String password) {
        String encoded = passwordEncoder.encode(password);
        
        Student s = studentRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + userId));
        s.setPassword(encoded);
        s.setRawPassword(password);
        s.setFirstLoginCompleted(true);
        studentRepository.save(s);
        return Map.of("userId", s.getId(), "username", s.getStudentId(), "firstLoginCompleted", true);
    }

    public StudentProfile updateProfile(Long userId, Map<String, Object> profileData) {
        Student student = studentRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + userId));

        StudentProfile profile = studentProfileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    StudentProfile newProfile = new StudentProfile();
                    newProfile.setUser(student);
                    return newProfile;
                });

        // Secure: Student is NOT allowed to change department, honors, degree, branch, or batch details.
        if (profile.getDegreeType() == null) {
            profile.setDegreeType("B.Tech");
        }
        if (profile.getSpecialization() == null) {
            profile.setSpecialization(student.getDepartment());
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

        profile.setCurrentYear(profileData.get("currentYear") != null ? Integer.valueOf(profileData.get("currentYear").toString()) : profile.getCurrentYear());
        profile.setSection((String) profileData.getOrDefault("section", profile.getSection()));
        profile.setHonorsOption((String) profileData.getOrDefault("honorsOption", profile.getHonorsOption()));
        profile.setExtensionType((String) profileData.getOrDefault("extensionType", profile.getExtensionType()));

        return studentProfileRepository.save(profile);
    }

    public Map<String, Object> getOnboardingProfile(Long userId) {
        Student student = studentRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + userId));
        StudentProfile profile = studentProfileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    StudentProfile newProfile = new StudentProfile();
                    newProfile.setUser(student);
                    newProfile.setDegreeType("B.Tech");
                    newProfile.setSpecialization(student.getDepartment());
                    newProfile.setHonorsType(student.getSubDepartment() != null ? student.getSubDepartment() : "REGULAR");
                    newProfile.setCurrentYear(1);
                    newProfile.setAdmissionYear(java.time.LocalDate.now().getYear());
                    return studentProfileRepository.save(newProfile);
                });

        Map<String, Object> result = new java.util.HashMap<>();
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
