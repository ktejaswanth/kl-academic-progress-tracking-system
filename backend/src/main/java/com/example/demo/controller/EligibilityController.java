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

    @GetMapping
    public ResponseEntity<?> getEligibility() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student not found: " + username));
        return ResponseEntity.ok(eligibilityService.calculateEligibility(student.getId()));
    }

    @GetMapping("/{studentId}")
    public ResponseEntity<?> getEligibility(@PathVariable Long studentId) {
        return ResponseEntity.ok(eligibilityService.calculateEligibility(studentId));
    }
}
