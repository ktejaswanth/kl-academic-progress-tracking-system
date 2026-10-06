package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.model.CompletedCourse;
import com.example.demo.model.StudentIssue;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.CompletedCourseRepository;
import com.example.demo.repository.StudentIssueRepository;
import com.example.demo.service.AuditService;
import com.example.demo.service.EligibilityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/student")
public class StudentController {

    @Autowired
    private AuditService auditService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private com.example.demo.repository.StudentRepository studentRepository;

    @Autowired
    private EligibilityService eligibilityService;

    @GetMapping("/progress")
    public ResponseEntity<?> getMyProgress() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
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
            
            Optional<com.example.demo.model.Student> studentOpt = studentRepository.findByStudentId(username);
            if (studentOpt.isPresent()) {
                com.example.demo.model.Student student = studentOpt.get();
                java.util.Map<String, Object> profile = new java.util.HashMap<>();
                profile.put("username", student.getStudentId());
                profile.put("email", student.getEmail());
                profile.put("firstName", student.getFirstName());
                profile.put("lastName", student.getLastName());
                profile.put("department", student.getDepartment());
                profile.put("subDepartment", student.getSubDepartment());
                profile.put("specializationType", student.getSpecializationType());
                profile.put("specializationName", student.getSpecializationName());
                profile.put("academicYear", student.getAcademicYear());
                return ResponseEntity.ok(profile);
            }

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
            profile.put("academicYear", user.getAcademicYear());
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

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @PostMapping("/courses")
    public ResponseEntity<?> addStudentCourse(@RequestBody java.util.Map<String, Object> payload) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            User student = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("Student not found"));

            String courseName = (String) payload.get("courseName");
            String courseCode = (String) payload.get("courseCode");
            String category = (String) payload.get("category");
            Object creditsObj = payload.get("credits");
            String status = (String) payload.get("status");

            if (courseName == null || courseName.trim().isEmpty() ||
                courseCode == null || courseCode.trim().isEmpty() ||
                category == null || category.trim().isEmpty() ||
                creditsObj == null || status == null || status.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("All fields (courseName, courseCode, category, credits, status) are required.");
            }

            Integer credits = Integer.parseInt(creditsObj.toString());

            CompletedCourse course = new CompletedCourse();
            course.setStudent(student);
            course.setCourseName(courseName);
            course.setCourseCode(courseCode);
            course.setCategory(category);
            course.setCredits(credits);
            course.setStatus(status);
            
            if ("Completed".equalsIgnoreCase(status)) {
                course.setGrade("Pass");
            } else {
                course.setGrade("IP");
            }

            return ResponseEntity.ok(completedCourseRepository.save(course));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error adding course: " + e.getMessage());
        }
    }

    @GetMapping("/courses")
    public ResponseEntity<?> getMyCourses() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            User student = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("Student not found"));

            return ResponseEntity.ok(completedCourseRepository.findByStudentId(student.getId()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching courses: " + e.getMessage());
        }
    }

    @DeleteMapping("/courses/{id}")
    public ResponseEntity<?> deleteStudentCourse(@PathVariable Long id) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String username = auth.getName();
            User student = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("Student not found"));

            CompletedCourse course = completedCourseRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Course not found"));

            if (!course.getStudent().getId().equals(student.getId())) {
                return ResponseEntity.status(403).body("You are not authorized to delete this course.");
            }

            completedCourseRepository.delete(course);
            return ResponseEntity.ok("Course deleted successfully.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error deleting course: " + e.getMessage());
        }
    }

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
