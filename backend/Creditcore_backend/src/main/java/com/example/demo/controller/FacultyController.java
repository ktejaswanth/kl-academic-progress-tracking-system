package com.example.demo.controller;

import com.example.demo.model.StudentDegreeStatus;
import com.example.demo.model.User;
import com.example.demo.repository.StudentDegreeStatusRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dyod/faculty")
@CrossOrigin(origins = "http://localhost:5173")
public class FacultyController {

    @Autowired
    private StudentDegreeStatusRepository statusRepository;
    
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/dashboard")
    public ResponseEntity<?> getFacultyDashboard() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User faculty = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Faculty not found"));
                
        String dept = faculty.getDepartment();
        if (dept == null || dept.isEmpty()) dept = "CSE"; // Fallback
        
        long totalStudents = statusRepository.countByDepartment(dept);
        long eligibleStudents = statusRepository.countEligibleByDepartment(dept);
        
        List<StudentDegreeStatus> students = statusRepository.findByDepartment(dept);
        
        Map<String, Object> result = new HashMap<>();
        result.put("department", dept);
        result.put("totalStudents", totalStudents);
        result.put("eligibleStudents", eligibleStudents);
        result.put("pendingStudents", totalStudents - eligibleStudents);
        result.put("students", students);
        
        return ResponseEntity.ok(result);
    }
}
