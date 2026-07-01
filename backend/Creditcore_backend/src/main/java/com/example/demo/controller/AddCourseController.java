package com.example.demo.controller;

import com.example.demo.model.CompletedCourse;
import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.AddCourseService;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dyod/courses")
@CrossOrigin(origins = "http://localhost:5173")
public class AddCourseController {

    @Autowired
    private AddCourseService addCourseService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/add")
    public ResponseEntity<?> addSingleCourse(@RequestBody AddCourseRequest request) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User verifier = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Logged in user not found"));

        try {
            Map<String, Object> response = addCourseService.addSingleCourse(request, verifier.getId());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/bulk-upload")
    public ResponseEntity<?> bulkUploadCourses(@RequestParam("file") MultipartFile file) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User verifier = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Logged in user not found"));

        try {
            Map<String, Object> response = addCourseService.bulkUploadCourses(file, verifier.getId());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @DeleteMapping("/{courseId}")
    public ResponseEntity<?> deleteCourse(@PathVariable Long courseId) {
        try {
            addCourseService.deleteCourse(courseId);
            return ResponseEntity.ok(Map.of("message", "Completed course entry deleted successfully."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<CompletedCourse>> getStudentCourses(@PathVariable Long studentId) {
        return ResponseEntity.ok(addCourseService.getStudentCourses(studentId));
    }

    @GetMapping("/student/me")
    public ResponseEntity<List<CompletedCourse>> getMyCourses() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User student = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Student user not found"));

        return ResponseEntity.ok(addCourseService.getStudentCourses(student.getId()));
    }

    @GetMapping("/template")
    public ResponseEntity<byte[]> downloadTemplate() {
        try {
            byte[] data = addCourseService.generateTemplate();
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=completed_courses_template.xlsx")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(data);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @Data
    public static class AddCourseRequest {
        private String universityId;
        private String studentName;
        private String courseCode;
        private String ltps;
        private String courseName;
        private String bucketGroup;
        private String courseType;
        private String academicYear;
        private String semester;
        private String studyYear;
        private String sectionNo;
        private String registerDate;
        private String courseRef;
        private String offerTo;
        private String offerBy;
        private String branch;
        // Grade can still be passed if needed or updated later.
        private String grade;
    }
}
