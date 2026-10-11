package com.example.demo.controller;

import com.example.demo.model.StudentProfile;
import com.example.demo.model.StudentSelection;
import com.example.demo.service.StudentOnboardingService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/onboarding")
public class StudentOnboardingController {

    @Autowired
    private StudentOnboardingService onboardingService;

    private String extractToken(HttpServletRequest request, Map<String, ?> payload) {
        String token = request.getHeader("X-Onboarding-Token");
        if (token != null && !token.trim().isEmpty()) {
            return token.trim();
        }

        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.trim().toLowerCase().startsWith("bearer ")) {
            return authHeader.substring(7).trim();
        }

        if (payload != null && payload.containsKey("token") && payload.get("token") != null) {
            return payload.get("token").toString().trim();
        }

        return null;
    }

    @PostMapping("/verify-first-login")
    public ResponseEntity<?> verifyFirstLogin(@RequestBody Map<String, String> payload) {
        String username = payload.get("username");
        String dob = payload.get("dateOfBirth");

        try {
            Map<String, Object> result = onboardingService.verifyFirstLogin(username, dob);
            if (result == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", "Invalid credentials. Please verify your Student ID and Date of Birth."));
            }
            return ResponseEntity.ok(result);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", e.getMessage(), "firstLoginCompleted", true));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", "Verification failed: " + e.getMessage()));
        }
    }

    @PostMapping("/complete-first-login")
    public ResponseEntity<?> completeFirstLogin(HttpServletRequest request, @RequestBody Map<String, Object> payload) {
        try {
            String token = extractToken(request, payload);
            Long userId = payload.get("userId") != null ? Long.valueOf(payload.get("userId").toString()) : null;
            String password = (String) payload.get("password");
            String confirmPassword = (String) payload.get("confirmPassword");

            if (password == null || !password.equals(confirmPassword) || password.length() < 6) {
                return ResponseEntity.badRequest().body("Passwords must match and be at least 6 characters.");
            }

            Map<String, Object> result = onboardingService.completeFirstLogin(token, userId, password);
            return ResponseEntity.ok(result);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Failed to complete first login: " + e.getMessage()));
        }
    }

    @PostMapping("/profile-setup")
    public ResponseEntity<?> updateProfile(HttpServletRequest request, @RequestBody Map<String, Object> profileData) {
        try {
            String token = extractToken(request, profileData);
            Long userId = profileData.get("studentId") != null ? Long.valueOf(profileData.get("studentId").toString()) : null;

            StudentProfile updated = onboardingService.updateProfile(token, userId, profileData);
            return ResponseEntity.ok(updated);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Failed to update profile: " + e.getMessage()));
        }
    }

    @GetMapping("/profile/{userId}")
    public ResponseEntity<?> getOnboardingProfile(HttpServletRequest request, @PathVariable Long userId) {
        try {
            String token = extractToken(request, null);
            return ResponseEntity.ok(onboardingService.getOnboardingProfile(token, userId));
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Error fetching profile: " + e.getMessage()));
        }
    }

    @PostMapping("/selection")
    public ResponseEntity<?> saveSelection(HttpServletRequest request, @RequestBody StudentSelection selection) {
        try {
            String token = extractToken(request, null);
            StudentSelection saved = onboardingService.saveSelection(token, selection);
            return ResponseEntity.ok(saved);
        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("error", e.getMessage()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Failed to save selection: " + e.getMessage()));
        }
    }
}
