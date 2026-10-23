package com.example.demo.controller;

import com.example.demo.model.StudentIssue;
import com.example.demo.repository.StudentIssueRepository;
import com.example.demo.service.AuditService;
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

    @Autowired
    private AuditService auditService;

    // --- Admin Endpoints ---

    @PostMapping("/admins")
    public ResponseEntity<?> createAdmin(@RequestBody Map<String, Object> payload) {
        try {
            return ResponseEntity.status(201).body(userService.createAdmin(payload));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating admin: " + e.getMessage());
        }
    }

    @GetMapping("/admins")
    public ResponseEntity<?> getAllAdmins() {
        return ResponseEntity.ok(userService.getAllAdmins());
    }

    @DeleteMapping("/admins/{id}")
    public ResponseEntity<?> deleteAdmin(@PathVariable Long id) {
        try {
            userService.deleteAdmin(id);
            return ResponseEntity.ok("Admin deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting admin: " + e.getMessage());
        }
    }

    // --- Faculty Endpoints ---

    @PostMapping("/faculty")
    public ResponseEntity<?> createFaculty(@RequestBody Map<String, Object> payload) {
        try {
            return ResponseEntity.status(201).body(userService.createFaculty(payload));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating faculty: " + e.getMessage());
        }
    }

    @GetMapping("/faculty")
    public ResponseEntity<?> getFaculty() {
        return ResponseEntity.ok(userService.getAllFaculty());
    }

    @DeleteMapping("/faculty/{id}")
    public ResponseEntity<?> deleteFaculty(@PathVariable Long id) {
        try {
            userService.deleteFaculty(id);
            return ResponseEntity.ok("Faculty deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting faculty: " + e.getMessage());
        }
    }

    // --- Student Endpoints ---

    @PostMapping("/students")
    public ResponseEntity<?> createStudent(@RequestBody Map<String, Object> payload) {
        try {
            return ResponseEntity.status(201).body(userService.createStudent(payload));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating student: " + e.getMessage());
        }
    }

    @GetMapping("/students")
    public ResponseEntity<?> getStudents() {
        return ResponseEntity.ok(userService.getAllStudents());
    }

    @DeleteMapping("/students/{id}")
    public ResponseEntity<?> deleteStudent(@PathVariable Long id) {
        try {
            userService.deleteStudent(id);
            return ResponseEntity.ok("Student deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting student: " + e.getMessage());
        }
    }

    @PutMapping("/students/{id}")
    public ResponseEntity<?> updateStudentProfile(@PathVariable Long id, @RequestBody Map<String, Object> payload) {
        try {
            return ResponseEntity.ok(userService.updateStudentProfile(id, payload));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating student profile: " + e.getMessage());
        }
    }

    @GetMapping("/students/lookup/{username}")
    public ResponseEntity<?> lookupStudentCurriculum(@PathVariable String username) {
        try {
            return ResponseEntity.ok(auditService.getStudentCurriculumCourses(username));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error looking up student: " + e.getMessage());
        }
    }

    // --- Analytics & User Management ---

    @GetMapping("/analytics")
    public ResponseEntity<?> getAnalytics() {
        try {
            return ResponseEntity.ok(userService.getDashboardAnalytics());
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of(
                    "totalUsers", 0,
                    "totalStudents", 0,
                    "totalFaculty", 0,
                    "totalAdmins", 0,
                    "totalCourses", 0,
                    "totalCurriculums", 0,
                    "pendingAudits", 0,
                    "systemHealth", "Operational",
                    "recentActivities", java.util.List.of()
            ));
        }
    }

    @GetMapping("/users")
    public ResponseEntity<?> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.ok("User deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting user: " + e.getMessage());
        }
    }

    // --- Issues Management ---

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
