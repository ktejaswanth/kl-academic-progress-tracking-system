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
    private com.example.demo.repository.UserRepository userRepository;

    @GetMapping("/student/me")
    public ResponseEntity<?> getMyProgress() {
        String username = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName();
        com.example.demo.model.User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Evaluate first to ensure it's up to date
        try {
            degreeEligibilityEngine.evaluateEligibility(user.getId());
        } catch (Exception e) {
            // Ignore error if path not assigned yet
        }
        
        Optional<StudentDegreeStatus> status = degreeEligibilityEngine.getStudentStatus(user.getId());
        if (status.isPresent()) {
            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("status", status.get());
            result.put("buckets", bucketSatisfactionEngine.getDetailedBucketProgress(user.getId()));
            result.put("studentName", user.getFirstName() + " " + user.getLastName());
            result.put("department", user.getDepartment());
            result.put("subDepartment", user.getSubDepartment());
            result.put("specialization", user.getSpecializationName());
            return ResponseEntity.ok(result);
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping("/student/{studentId}/evaluate")
    public ResponseEntity<StudentDegreeStatus> evaluateStudent(@PathVariable Long studentId) {
        return ResponseEntity.ok(degreeEligibilityEngine.evaluateEligibility(studentId));
    }

    @GetMapping("/student/{studentId}/status")
    public ResponseEntity<?> getOverallStatus(@PathVariable Long studentId) {
        Optional<StudentDegreeStatus> status = degreeEligibilityEngine.getStudentStatus(studentId);
        if (status.isPresent()) {
            return ResponseEntity.ok(status.get());
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/student/{studentId}/buckets")
    public ResponseEntity<List<Map<String, Object>>> getDetailedBucketProgress(@PathVariable Long studentId) {
        return ResponseEntity.ok(bucketSatisfactionEngine.getDetailedBucketProgress(studentId));
    }

    @PostMapping("/batch-evaluate")
    public ResponseEntity<Map<String, Object>> batchEvaluateAll() {
        return ResponseEntity.ok(degreeEligibilityEngine.batchEvaluateAllStudents());
    }
}
