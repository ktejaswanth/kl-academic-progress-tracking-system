package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.model.UserRole;
import com.example.demo.model.StudentIssue;
import com.example.demo.repository.StudentIssueRepository;
import com.example.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class SuperAdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private StudentIssueRepository studentIssueRepository;

    @PostMapping("/faculty")
    public ResponseEntity<?> createFaculty(@RequestBody User faculty) {
        try {
            return ResponseEntity.status(201).body(userService.createFaculty(faculty));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating faculty: " + e.getMessage());
        }
    }

    @PostMapping("/students")
    public ResponseEntity<?> createStudent(@RequestBody User student) {
        try {
            return ResponseEntity.status(201).body(userService.createStudent(student));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating student: " + e.getMessage());
        }
    }

    @GetMapping("/analytics")
    public ResponseEntity<?> getAnalytics() {
        return ResponseEntity.ok(userService.getDashboardAnalytics());
    }

    @GetMapping("/users")
    public ResponseEntity<?> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/faculty")
    public ResponseEntity<?> getFaculty() {
        return ResponseEntity.ok(userService.getUsersByRole(UserRole.FACULTY));
    }

    @GetMapping("/students")
    public ResponseEntity<?> getStudents() {
        return ResponseEntity.ok(userService.getUsersByRole(UserRole.STUDENT));
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.ok("User deleted successfully");
    }

    @PutMapping("/students/{id}")
    public ResponseEntity<?> updateStudentProfile(@PathVariable Long id, @RequestBody Map<String, Object> payload) {
        try {
            User updated = userService.updateStudentProfile(id, payload);
            return ResponseEntity.ok(updated);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating student profile: " + e.getMessage());
        }
    }

    @GetMapping("/issues")
    public ResponseEntity<?> getAllIssues() {
        try {
            return ResponseEntity.ok(studentIssueRepository.findAllByOrderByCreatedAtDesc());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching issues: " + e.getMessage());
        }
    }

    @PutMapping("/issues/{id}/status")
    public ResponseEntity<?> updateIssueStatus(@PathVariable Long id, @RequestBody Map<String, String> payload) {
        try {
            StudentIssue issue = studentIssueRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Issue not found"));
            
            String newStatus = payload.get("status");
            if (newStatus == null || newStatus.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Status is required.");
            }
            
            issue.setStatus(newStatus);
            if ("RESOLVED".equalsIgnoreCase(newStatus)) {
                issue.setResolvedAt(java.time.LocalDateTime.now());
            } else {
                issue.setResolvedAt(null);
            }
            
            return ResponseEntity.ok(studentIssueRepository.save(issue));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating issue: " + e.getMessage());
        }
    }
}
