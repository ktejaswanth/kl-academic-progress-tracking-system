package com.example.demo.controller;

import com.example.demo.model.StudentProfile;
import com.example.demo.model.StudentSelection;
import com.example.demo.model.User;
import com.example.demo.service.StudentOnboardingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/onboarding")
public class StudentOnboardingController {

    @Autowired
    private StudentOnboardingService onboardingService;

    @PostMapping("/verify-first-login")
    public ResponseEntity<Map<String, Object>> verifyFirstLogin(@RequestBody Map<String, String> payload) {
        String username = payload.get("username");
        String dob = payload.get("dateOfBirth");

        return onboardingService.verifyFirstLogin(username, dob)
                .map(user -> ResponseEntity.ok(Map.<String, Object>of(
                        "userId", user.getId(),
                        "username", user.getUsername(),
                        "firstLoginCompleted", user.getFirstLoginCompleted()
                )))
                .orElse(ResponseEntity.status(401).body(Map.<String, Object>of("error", "Invalid credentials")));
    }

    @PostMapping("/complete-first-login")
    public ResponseEntity<?> completeFirstLogin(@RequestBody Map<String, String> payload) {
        Long userId = Long.valueOf(payload.get("userId"));
        String password = payload.get("password");
        String confirmPassword = payload.get("confirmPassword");

        if (password == null || !password.equals(confirmPassword) || password.length() < 6) {
            return ResponseEntity.badRequest().body("Passwords must match and be at least 6 characters.");
        }

        User user = onboardingService.completeFirstLogin(userId, password);
        return ResponseEntity.ok(Map.of(
                "userId", user.getId(),
                "username", user.getUsername(),
                "firstLoginCompleted", user.getFirstLoginCompleted()
        ));
    }

    @PostMapping("/profile-setup")
    public ResponseEntity<StudentProfile> updateProfile(@RequestBody Map<String, Object> profileData) {
        Long userId = Long.valueOf(profileData.get("studentId").toString());
        return ResponseEntity.ok(onboardingService.updateProfile(userId, profileData));
    }

    @PostMapping("/selection")
    public ResponseEntity<StudentSelection> saveSelection(@RequestBody StudentSelection selection) {
        return ResponseEntity.ok(onboardingService.saveSelection(selection));
    }
}
