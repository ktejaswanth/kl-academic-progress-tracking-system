package com.example.demo.controller;

import com.example.demo.model.CompletedCourse;
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
import java.util.Optional;

@RestController
@RequestMapping("/api/dyod/courses")
@CrossOrigin(origins = "http://localhost:5173")
public class AddCourseController {

    @Autowired
    private AddCourseService addCourseService;

    @Autowired
    private com.example.demo.repository.AdminRepository adminRepository;

    @Autowired
    private com.example.demo.repository.FacultyRepository facultyRepository;

    @Autowired
    private com.example.demo.repository.StudentRepository studentRepository;

    private Long getVerifierId(String username) {
        if (username == null || username.trim().isEmpty()) return 1L;
        Optional<com.example.demo.model.Faculty> fOpt = facultyRepository.findByUsername(username);
        if (fOpt.isPresent()) return fOpt.get().getId();
        Optional<com.example.demo.model.Admin> aOpt = adminRepository.findByUsername(username);
        if (aOpt.isPresent()) return aOpt.get().getId();
        return 1L;
    }

    @PostMapping("/add")
    public ResponseEntity<?> addSingleCourse(@RequestBody AddCourseRequest request) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Long verifierId = getVerifierId(username);

        try {
            Map<String, Object> response = addCourseService.addSingleCourse(request, verifierId);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/bulk-upload")
    public ResponseEntity<?> bulkUploadCourses(@RequestParam("file") MultipartFile file) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Long verifierId = getVerifierId(username);

        try {
            Map<String, Object> response = addCourseService.bulkUploadCourses(file, verifierId);
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

    @PutMapping("/{courseId}")
    public ResponseEntity<?> updateCourse(@PathVariable Long courseId, @RequestBody UpdateCourseRequest request) {
        org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        boolean isAuthorized = auth != null && auth.getAuthorities().stream().anyMatch(a ->
                a.getAuthority().equals("ROLE_SUPER_ADMIN") || a.getAuthority().equals("ROLE_FACULTY")
        );
        if (!isAuthorized) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "You are not authorized to edit course records."));
        }

        String username = auth.getName();
        Long verifierId = getVerifierId(username);

        try {
            Map<String, Object> response = addCourseService.updateCourse(courseId, request, verifierId);
            return ResponseEntity.ok(response);
        } catch (java.util.NoSuchElementException e) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.NOT_FOUND).body(Map.of("error", e.getMessage()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (SecurityException e) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN).body(Map.of("error", e.getMessage()));
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
        Optional<com.example.demo.model.Student> student = studentRepository.findByStudentId(username);
        if (student.isPresent()) {
            return ResponseEntity.ok(addCourseService.getStudentCourses(student.get().getId()));
        }
        return ResponseEntity.ok(addCourseService.getStudentCoursesByUniversityId(username));
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
        private Long studentId;
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

    public static class UpdateCourseRequest extends com.example.demo.dto.UpdateCourseRequest {}
}
