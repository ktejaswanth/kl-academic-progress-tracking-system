package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.AuditService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/student")
public class StudentController {

    @Autowired
    private AuditService auditService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/progress")
    public ResponseEntity<?> getMyProgress() {
        try {
            // In a real scenario, extract ID from JWT
            // For now, I'll assume the username is available in the context
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            
            // Note: In my current setup, I might need to find the user ID from the username
            // I'll update the AuditService to handle username or I'll fetch the ID here.
            return ResponseEntity.ok(auditService.getStudentProgressByUsername(username));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching progress: " + e.getMessage());
        }
    }

    @GetMapping("/profile")
    public ResponseEntity<?> getMyProfile() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            
            java.util.Map<String, Object> profile = new java.util.HashMap<>();
            profile.put("username", user.getUsername());
            profile.put("email", user.getEmail());
            profile.put("firstName", user.getFirstName());
            profile.put("lastName", user.getLastName());
            profile.put("department", user.getDepartment());
            profile.put("subDepartment", user.getSubDepartment());
            profile.put("specializationType", user.getSpecializationType());
            profile.put("specializationName", user.getSpecializationName());
            return ResponseEntity.ok(profile);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching profile: " + e.getMessage());
        }
    }
}
