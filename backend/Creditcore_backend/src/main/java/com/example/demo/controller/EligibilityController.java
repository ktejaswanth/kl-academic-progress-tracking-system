package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
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
    private UserRepository userRepository;

    @GetMapping
    public ResponseEntity<?> getEligibility() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return ResponseEntity.ok(eligibilityService.calculateEligibility(user.getId()));
    }

    @GetMapping("/{studentId}")
    public ResponseEntity<?> getEligibility(@PathVariable Long studentId) {
        return ResponseEntity.ok(eligibilityService.calculateEligibility(studentId));
    }
}
