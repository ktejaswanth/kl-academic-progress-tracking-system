package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.model.StudentIssue;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.StudentIssueRepository;
import com.example.demo.service.AuditService;
import com.example.demo.service.EligibilityService;
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

    @Autowired
    private EligibilityService eligibilityService;

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

    @GetMapping("/roadmap")
    public ResponseEntity<?> getStudentRoadmap() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            return ResponseEntity.ok(eligibilityService.generateRoadmap(user.getId()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error generating roadmap: " + e.getMessage());
        }
    }

    @GetMapping("/curriculum-courses")
    public ResponseEntity<?> getMyCurriculumCourses() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            return ResponseEntity.ok(auditService.getStudentCurriculumCourses(username));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching curriculum: " + e.getMessage());
        }
    }

    @Autowired
    private StudentIssueRepository studentIssueRepository;

    @PostMapping("/issues")
    public ResponseEntity<?> submitIssue(@RequestBody java.util.Map<String, String> payload) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            User student = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("Student not found"));

            String title = payload.get("title");
            String description = payload.get("description");

            if (title == null || title.trim().isEmpty() || description == null || description.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Title and description are required.");
            }

            StudentIssue issue = new StudentIssue();
            issue.setStudent(student);
            issue.setTitle(title);
            issue.setDescription(description);
            issue.setStatus("PENDING");

            return ResponseEntity.ok(studentIssueRepository.save(issue));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error submitting issue: " + e.getMessage());
        }
    }

    @GetMapping("/issues")
    public ResponseEntity<?> getMyIssues() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            User student = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("Student not found"));

            return ResponseEntity.ok(studentIssueRepository.findByStudentId(student.getId()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching issues: " + e.getMessage());
        }
    }
}
