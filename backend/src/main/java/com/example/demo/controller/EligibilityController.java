package com.example.demo.controller;

import com.example.demo.model.Student;
import com.example.demo.repository.StudentRepository;
import com.example.demo.service.EligibilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/student/eligibility")
public class EligibilityController {

    @Autowired
    private EligibilityService eligibilityService;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private com.example.demo.service.UserSecurityService userSecurityService;

    @GetMapping
    public ResponseEntity<?> getEligibility() {
        org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(java.util.Map.of("error", "Full authentication required."));
        }
        String username = auth.getName();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student not found: " + username));
        return ResponseEntity.ok(eligibilityService.calculateEligibility(student.getId()));
    }

    @GetMapping("/{studentId}")
    public ResponseEntity<?> getEligibility(@PathVariable Long studentId) {
        if (!userSecurityService.canAccessStudentData(studentId)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(java.util.Map.of("error", "Access denied: You are not authorized to view another student's eligibility data."));
        }
        return ResponseEntity.ok(eligibilityService.calculateEligibility(studentId));
    }
}
