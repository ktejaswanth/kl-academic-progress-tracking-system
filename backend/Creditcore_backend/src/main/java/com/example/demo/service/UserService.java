package com.example.demo.service;

import com.example.demo.model.User;
import com.example.demo.model.UserRole;
import com.example.demo.repository.UserRepository;
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
    private PasswordEncoder passwordEncoder;

    public User createFaculty(User faculty) {
        faculty.setRole(UserRole.FACULTY);
        if (faculty.getPassword() != null) {
            faculty.setPasswordHash(passwordEncoder.encode(faculty.getPassword()));
        }
        faculty.setForcePasswordChange(true);
        return userRepository.save(faculty);
    }

    public User createStudent(User student) {
        student.setRole(UserRole.STUDENT);
        if (student.getPassword() != null) {
            student.setPasswordHash(passwordEncoder.encode(student.getPassword()));
        }
        student.setForcePasswordChange(true);
        return userRepository.save(student);
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
