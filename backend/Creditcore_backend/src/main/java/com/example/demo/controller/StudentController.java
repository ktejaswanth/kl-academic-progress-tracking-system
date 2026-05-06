package com.example.demo.controller;

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
}
