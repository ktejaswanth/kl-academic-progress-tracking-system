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

    public User completeFirstLogin(Long userId, String password) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setForcePasswordChange(false);
        user.setFirstLoginCompleted(true);
        userRepository.save(user);
        return user;
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

        profile.setDegreeType((String) profileData.getOrDefault("degreeType", profile.getDegreeType()));
        profile.setSpecialization((String) profileData.getOrDefault("specialization", profile.getSpecialization()));
        profile.setHonorsType((String) profileData.getOrDefault("honorsType", profile.getHonorsType()));
        profile.setBranch((String) profileData.getOrDefault("branch", profile.getBranch()));
        profile.setBatch(profileData.get("batch") != null ? Integer.valueOf(profileData.get("batch").toString()) : profile.getBatch());
        profile.setCurrentYear(profileData.get("currentYear") != null ? Integer.valueOf(profileData.get("currentYear").toString()) : profile.getCurrentYear());
        profile.setSection((String) profileData.getOrDefault("section", profile.getSection()));
        profile.setHonorsOption((String) profileData.getOrDefault("honorsOption", profile.getHonorsOption()));
        profile.setExtensionType((String) profileData.getOrDefault("extensionType", profile.getExtensionType()));

        return studentProfileRepository.save(profile);
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
