package com.example.demo.service;

import com.example.demo.model.User;
import com.example.demo.model.UserRole;
import com.example.demo.model.StudentProfile;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.StudentProfileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User createFaculty(User faculty) {
        faculty.setRole(UserRole.FACULTY);
        if (faculty.getPassword() != null) {
            faculty.setPasswordHash(passwordEncoder.encode(faculty.getPassword()));
            faculty.setRawPassword(faculty.getPassword());
        }
        faculty.setForcePasswordChange(true);
        return userRepository.save(faculty);
    }

    public User createStudent(User student) {
        student.setRole(UserRole.STUDENT);
        if (student.getPassword() != null) {
            student.setPasswordHash(passwordEncoder.encode(student.getPassword()));
            student.setRawPassword(student.getPassword());
        }
        student.setForcePasswordChange(true);
        User savedStudent = userRepository.save(student);

        // Auto-create StudentProfile to prevent portal load crashes
        StudentProfile profile = new StudentProfile();
        profile.setUser(savedStudent);
        profile.setDegreeType("B.Tech");
        profile.setSpecialization(savedStudent.getDepartment() != null ? savedStudent.getDepartment() : "CSE");
        profile.setHonorsType(savedStudent.getSubDepartment() != null ? savedStudent.getSubDepartment() : "REGULAR");
        profile.setCurrentYear(1);
        profile.setAdmissionYear(java.time.LocalDate.now().getYear());
        studentProfileRepository.save(profile);

        return savedStudent;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public List<User> getUsersByRole(UserRole role) {
        return userRepository.findByRole(role);
    }

    public Map<String, Long> getDashboardAnalytics() {
        Map<String, Long> analytics = new HashMap<>();
        analytics.put("totalUsers", userRepository.count());
        analytics.put("totalFaculty", (long) userRepository.findByRole(UserRole.FACULTY).size());
        analytics.put("totalStudents", (long) userRepository.findByRole(UserRole.STUDENT).size());
        return analytics;
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }
}
