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

    private Map<String, String> errorResponse(String defaultMsg, Throwable t) {
        String msg = (t != null && t.getMessage() != null && !t.getMessage().trim().isEmpty())
                ? t.getMessage()
                : defaultMsg;
        return Map.of("error", msg);
    }

    @PostMapping("/add")
    public ResponseEntity<?> addSingleCourse(@RequestBody AddCourseRequest request) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Long verifierId = getVerifierId(username);

        try {
            Map<String, Object> response = addCourseService.addSingleCourse(request, verifierId);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(errorResponse("Unable to add course", e));
        }
    }

    @PostMapping("/bulk-upload")
    public ResponseEntity<?> bulkUploadCourses(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "batch", required = false) String batch
    ) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Long verifierId = getVerifierId(username);

        try {
            Map<String, Object> response = addCourseService.bulkUploadCourses(file, batch, verifierId);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(errorResponse("Upload failed", e));
        }
    }

    @GetMapping("/batches")
    public ResponseEntity<?> getAvailableBatches() {
        try {
            return ResponseEntity.ok(addCourseService.getAvailableBatches());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(errorResponse("Failed to fetch available batches", e));
        }
    }

    @DeleteMapping("/{courseId}")
    public ResponseEntity<?> deleteCourse(@PathVariable Long courseId) {
        try {
            addCourseService.deleteCourse(courseId);
            return ResponseEntity.ok(Map.of("message", "Completed course entry deleted successfully."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(errorResponse("Failed to delete course", e));
        }
    }

    @PutMapping("/{courseId}")
    public ResponseEntity<?> updateCourse(@PathVariable Long courseId, @RequestBody UpdateCourseRequest request) {
        org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        boolean isAuthorized = auth != null && auth.getAuthorities().stream().anyMatch(a ->
                a.getAuthority().equals("ROLE_SUPER_ADMIN") ||
                a.getAuthority().equals("ROLE_ADMIN") ||
                a.getAuthority().equals("ROLE_FACULTY")
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
            return ResponseEntity.status(org.springframework.http.HttpStatus.NOT_FOUND).body(errorResponse("Course not found", e));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(errorResponse("Invalid course update request", e));
        } catch (SecurityException e) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN).body(errorResponse("Access denied", e));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(errorResponse("Course update failed", e));
        }
    }

    @Autowired
    private com.example.demo.service.UserSecurityService userSecurityService;

    @GetMapping("/student/{studentId}")
    public ResponseEntity<?> getStudentCourses(@PathVariable Long studentId) {
        if (!userSecurityService.canAccessStudentData(studentId)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Access denied: Not authorized for student ID: " + studentId));
        }
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

    @GetMapping("/audit")
    public ResponseEntity<?> getAllAuditHistory() {
        org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        boolean isAuthorized = auth != null && auth.getAuthorities().stream().anyMatch(a ->
                a.getAuthority().equals("ROLE_SUPER_ADMIN") ||
                a.getAuthority().equals("ROLE_ADMIN") ||
                a.getAuthority().equals("ROLE_FACULTY")
        );
        if (!isAuthorized) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "You are not authorized to view audit history."));
        }
        return ResponseEntity.ok(addCourseService.getAllAuditHistory());
    }

    @GetMapping("/audit/{studentId}")
    public ResponseEntity<?> getAuditHistoryForStudent(@PathVariable Long studentId) {
        org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        boolean isAuthorized = auth != null && auth.getAuthorities().stream().anyMatch(a ->
                a.getAuthority().equals("ROLE_SUPER_ADMIN") ||
                a.getAuthority().equals("ROLE_ADMIN") ||
                a.getAuthority().equals("ROLE_FACULTY")
        );
        if (!isAuthorized) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "You are not authorized to view audit history."));
        }
        return ResponseEntity.ok(addCourseService.getAuditHistoryForStudent(studentId));
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
