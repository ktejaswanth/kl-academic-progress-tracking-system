package com.example.demo.controller;

import com.example.demo.dto.StudentCourseDTO;
import com.example.demo.model.Student;
import com.example.demo.service.ExitRequirementPdfService;
import com.example.demo.service.StudentCourseManagementService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/student-course-management")
@CrossOrigin(origins = "*")
@Slf4j
public class StudentCourseManagementController {

    @Autowired
    private StudentCourseManagementService courseManagementService;

    @Autowired
    private ExitRequirementPdfService exitRequirementPdfService;

    private String getCurrentUsername() {
        return SecurityContextHolder.getContext().getAuthentication() != null
                ? SecurityContextHolder.getContext().getAuthentication().getName()
                : "system";
    }

    /**
     * READ: Get all courses for a student.
     */
    @GetMapping("/students/{studentId}/courses")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> getStudentCourses(@PathVariable String studentId) {
        try {
            List<StudentCourseDTO> courses = courseManagementService.getStudentCourses(studentId);
            return ResponseEntity.ok(courses);
        } catch (Exception e) {
            log.error("Failed fetching courses for student {}: ", studentId, e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * CREATE: Add a new student course record.
     */
    @PostMapping("/students/{studentId}/courses")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> addStudentCourse(
            @PathVariable String studentId,
            @RequestBody StudentCourseDTO request) {
        String username = getCurrentUsername();
        try {
            StudentCourseDTO created = courseManagementService.addCourse(studentId, request, username);
            // Also return updated Exit Requirement Report summary
            Map<String, Object> exitReport = exitRequirementPdfService.getStudentExitRequirementReportData(studentId);
            return ResponseEntity.ok(Map.of(
                    "course", created,
                    "exitSummary", exitReport.get("summary"),
                    "categories", exitReport.get("categories"),
                    "message", "Course " + created.getCourseCode() + " added successfully."
            ));
        } catch (IllegalStateException e) {
            return ResponseEntity.status(409).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            log.error("Failed adding course for student {}: ", studentId, e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * UPDATE: Edit an existing student course record.
     */
    @PutMapping("/students/{studentId}/courses/{courseCode}")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> updateStudentCourse(
            @PathVariable String studentId,
            @PathVariable String courseCode,
            @RequestBody StudentCourseDTO request) {
        String username = getCurrentUsername();
        try {
            StudentCourseDTO updated = courseManagementService.updateCourse(studentId, courseCode, request, username);
            Map<String, Object> exitReport = exitRequirementPdfService.getStudentExitRequirementReportData(studentId);
            return ResponseEntity.ok(Map.of(
                    "course", updated,
                    "exitSummary", exitReport.get("summary"),
                    "categories", exitReport.get("categories"),
                    "message", "Course " + courseCode + " updated successfully."
            ));
        } catch (Exception e) {
            log.error("Failed updating course {} for student {}: ", courseCode, studentId, e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * DELETE: Soft delete / remove course record for student.
     */
    @DeleteMapping("/students/{studentId}/courses/{courseCode}")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> deleteStudentCourse(
            @PathVariable String studentId,
            @PathVariable String courseCode) {
        String username = getCurrentUsername();
        try {
            courseManagementService.deleteCourse(studentId, courseCode, username);
            Map<String, Object> exitReport = exitRequirementPdfService.getStudentExitRequirementReportData(studentId);
            return ResponseEntity.ok(Map.of(
                    "message", "Course " + courseCode + " removed successfully.",
                    "exitSummary", exitReport.get("summary"),
                    "categories", exitReport.get("categories")
            ));
        } catch (Exception e) {
            log.error("Failed deleting course {} for student {}: ", courseCode, studentId, e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * SEARCH CATALOG: Authoritative Course Master lookup.
     */
    @GetMapping("/catalog")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'FACULTY', 'STUDENT')")
    public ResponseEntity<?> searchCatalog(
            @RequestParam(required = false, defaultValue = "") String query,
            @RequestParam(required = false) String category,
            @RequestParam(required = false, defaultValue = "50") int limit) {
        try {
            return ResponseEntity.ok(courseManagementService.searchCourseCatalog(query, category, limit));
        } catch (Exception e) {
            log.error("Failed searching course catalog: ", e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * Recalculated Credit Summary & Categories preview.
     */
    @GetMapping("/students/{studentId}/summary")
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> getStudentCreditSummary(@PathVariable String studentId) {
        try {
            Map<String, Object> exitReport = exitRequirementPdfService.getStudentExitRequirementReportData(studentId);
            @SuppressWarnings("unchecked")
            Map<String, Object> summary = (Map<String, Object>) exitReport.get("summary");
            @SuppressWarnings("unchecked")
            Map<String, Object> student = (Map<String, Object>) exitReport.get("student");
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> categories = (List<Map<String, Object>>) exitReport.get("categories");
            
            Map<String, Integer> categoryCredits = new java.util.LinkedHashMap<>();
            if (categories != null) {
                for (Map<String, Object> cat : categories) {
                    String code = (String) cat.get("categoryCode");
                    Integer obtained = (Integer) cat.get("obtainedCredits");
                    if (code != null) categoryCredits.put(code, obtained != null ? obtained : 0);
                }
            }

            Map<String, Object> response = new java.util.LinkedHashMap<>(exitReport);
            if (summary != null) response.putAll(summary);
            if (student != null) response.putAll(student);
            response.put("categoryCredits", categoryCredits);
            if (summary != null && summary.get("totalRequiredCredits") != null) {
                response.put("totalRequiredCredits", summary.get("totalRequiredCredits"));
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
