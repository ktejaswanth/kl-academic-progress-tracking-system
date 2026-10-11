package com.example.demo.controller;

import com.example.demo.model.StudentDegreeStatus;
import com.example.demo.service.BucketSatisfactionEngine;
import com.example.demo.service.DegreeEligibilityEngine;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/dyod/progress")
@CrossOrigin(origins = "http://localhost:5173")
public class BucketProgressController {

    @Autowired
    private BucketSatisfactionEngine bucketSatisfactionEngine;
    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    @Autowired
    private com.example.demo.repository.StudentRepository studentRepository;

    @GetMapping("/student/me")
    public ResponseEntity<?> getMyProgress() {
        String username = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName();
        com.example.demo.model.Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student not found: " + username));
        
        // Evaluate first to ensure it's up to date
        try {
            degreeEligibilityEngine.evaluateEligibility(student.getId());
        } catch (Exception e) {
            // Ignore error if path not assigned yet
        }
        
        Optional<StudentDegreeStatus> status = degreeEligibilityEngine.getStudentStatus(student.getId());
        if (status.isPresent()) {
            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("status", status.get());
            result.put("buckets", bucketSatisfactionEngine.getDetailedBucketProgress(student.getId()));
            String fullName = student.getName() != null && !student.getName().trim().isEmpty()
                    ? student.getName()
                    : ((student.getFirstName() != null ? student.getFirstName() : "") + " " + (student.getLastName() != null ? student.getLastName() : "")).trim();
            result.put("studentName", fullName.isEmpty() ? student.getStudentId() : fullName);
            result.put("department", student.getDepartment());
            result.put("subDepartment", student.getSubDepartment());
            result.put("specialization", student.getSpecializationName());
            return ResponseEntity.ok(result);
        }
        return ResponseEntity.notFound().build();
    }

    @Autowired
    private com.example.demo.service.UserSecurityService userSecurityService;

    @PostMapping("/student/{studentId}/evaluate")
    public ResponseEntity<?> evaluateStudent(@PathVariable Long studentId) {
        if (!userSecurityService.canAccessStudentData(studentId)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Access denied: Not authorized for student ID: " + studentId));
        }
        return ResponseEntity.ok(degreeEligibilityEngine.evaluateEligibility(studentId));
    }

    @GetMapping("/student/{studentId}/status")
    public ResponseEntity<?> getOverallStatus(@PathVariable Long studentId) {
        if (!userSecurityService.canAccessStudentData(studentId)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Access denied: Not authorized for student ID: " + studentId));
        }
        Optional<StudentDegreeStatus> status = degreeEligibilityEngine.getStudentStatus(studentId);
        if (status.isPresent()) {
            return ResponseEntity.ok(status.get());
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/student/{studentId}/buckets")
    public ResponseEntity<?> getDetailedBucketProgress(@PathVariable Long studentId) {
        if (!userSecurityService.canAccessStudentData(studentId)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Access denied: Not authorized for student ID: " + studentId));
        }
        return ResponseEntity.ok(bucketSatisfactionEngine.getDetailedBucketProgress(studentId));
    }

    @PostMapping("/batch-evaluate")
    public ResponseEntity<Map<String, Object>> batchEvaluateAll() {
        return ResponseEntity.ok(degreeEligibilityEngine.batchEvaluateAllStudents());
    }
}
