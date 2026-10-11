package com.example.demo.controller;

import com.example.demo.model.ExitRequirementMaster;
import com.example.demo.model.Student;
import com.example.demo.repository.ExitRequirementMasterRepository;
import com.example.demo.repository.StudentRepository;
import com.example.demo.service.ExitRequirementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/exit")
@CrossOrigin(origins = "*")
public class ExitRequirementController {

    @Autowired
    private ExitRequirementService exitRequirementService;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private ExitRequirementMasterRepository requirementMasterRepository;

    @Autowired
    private com.example.demo.service.ExitRequirementPdfService exitRequirementPdfService;

    @Autowired
    private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    @GetMapping("/debug/db-tables")
    public ResponseEntity<?> debugDbTables() {
        List<String> tables = jdbcTemplate.queryForList(
            "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name",
            String.class
        );
        return ResponseEntity.ok(tables);
    }

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ExitRequirementController.class);

    @GetMapping("/student/download-pdf")
    @PreAuthorize("hasAnyRole('STUDENT', 'SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<byte[]> downloadStudentExitPdf() {
        String username = getCurrentUsername();
        try {
            Student student = exitRequirementPdfService.findStudentByIdentifier(username);
            byte[] pdfBytes = exitRequirementPdfService.generateStudentExitRequirementPdf(username);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"Exit_Requirement_" + student.getStudentId() + ".pdf\"")
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(pdfBytes);
        } catch (Exception e) {
            log.error("Failed generating student exit PDF for {}: ", username, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/faculty/download-pdf/{identifier}")
    @PreAuthorize("hasAnyRole('FACULTY', 'SUPER_ADMIN')")
    public ResponseEntity<byte[]> downloadFacultyExitPdf(@PathVariable String identifier) {
        try {
            Student student = exitRequirementPdfService.findStudentByIdentifier(identifier);
            byte[] pdfBytes = exitRequirementPdfService.generateStudentExitRequirementPdf(identifier);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"Exit_Requirement_" + student.getStudentId() + ".pdf\"")
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(pdfBytes);
        } catch (Exception e) {
            log.error("Failed generating faculty exit PDF for student {}: ", identifier, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/admin/download-pdf/{identifier}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<byte[]> downloadAdminExitPdf(@PathVariable String identifier) {
        try {
            Student student = exitRequirementPdfService.findStudentByIdentifier(identifier);
            byte[] pdfBytes = exitRequirementPdfService.generateStudentExitRequirementPdf(identifier);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"Exit_Requirement_" + student.getStudentId() + ".pdf\"")
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(pdfBytes);
        } catch (Exception e) {
            log.error("Failed generating admin exit PDF for student {}: ", identifier, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/admin/report/{identifier}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> getAdminExitReport(@PathVariable String identifier) {
        try {
            Map<String, Object> data = exitRequirementPdfService.getStudentExitRequirementReportData(identifier);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            log.error("Failed to fetch admin exit report for {}: ", identifier, e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/faculty/report/{identifier}")
    @PreAuthorize("hasAnyRole('FACULTY', 'SUPER_ADMIN')")
    public ResponseEntity<?> getFacultyExitReport(@PathVariable String identifier) {
        try {
            Map<String, Object> data = exitRequirementPdfService.getStudentExitRequirementReportData(identifier);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            log.error("Failed to fetch faculty exit report for {}: ", identifier, e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/student/report")
    @PreAuthorize("hasAnyRole('STUDENT', 'SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> getStudentExitReport() {
        String username = getCurrentUsername();
        try {
            Map<String, Object> data = exitRequirementPdfService.getStudentExitRequirementReportData(username);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            log.error("Failed to fetch student exit report for {}: ", username, e);
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/search-students")
    @PreAuthorize("hasAnyRole('FACULTY', 'SUPER_ADMIN')")
    public ResponseEntity<?> searchStudents(@RequestParam(value = "query", required = false) String query) {
        if (query == null || query.trim().isEmpty()) {
            return ResponseEntity.ok(List.of());
        }
        String q = "%" + query.trim().toLowerCase() + "%";
        String sql = "SELECT id, student_id AS \"rollNumber\", first_name AS \"firstName\", last_name AS \"lastName\", department " +
                     "FROM students " +
                     "WHERE LOWER(student_id) LIKE ? OR LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? " +
                     "ORDER BY student_id ASC LIMIT 15";
        List<Map<String, Object>> results = jdbcTemplate.queryForList(sql, q, q, q);
        return ResponseEntity.ok(results);
    }

    private String getCurrentUsername() {
        return SecurityContextHolder.getContext().getAuthentication() != null
                ? SecurityContextHolder.getContext().getAuthentication().getName()
                : "";
    }

    // =========================================================================
    // 1. STUDENT ENDPOINTS
    // =========================================================================

    @GetMapping("/student/my-status")
    @PreAuthorize("hasAnyRole('STUDENT', 'SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> getMyExitStatus() {
        String username = getCurrentUsername();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student record not found for: " + username));
        return ResponseEntity.ok(exitRequirementService.getStudentExitStatus(student.getId()));
    }

    @PostMapping("/student/submit/{clearanceId}")
    @PreAuthorize("hasAnyRole('STUDENT', 'SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> submitRequirement(
            @PathVariable Long clearanceId,
            @RequestBody Map<String, String> payload) {
        String username = getCurrentUsername();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student record not found for: " + username));

        String notes = payload.getOrDefault("notes", "");
        String attachmentUrl = payload.getOrDefault("attachmentUrl", "");

        return ResponseEntity.ok(exitRequirementService.submitStudentRequirement(student.getId(), clearanceId, notes, attachmentUrl));
    }

    @PostMapping("/student/submit-survey")
    @PreAuthorize("hasAnyRole('STUDENT', 'SUPER_ADMIN', 'FACULTY')")
    public ResponseEntity<?> submitSurvey(@RequestBody Map<String, Object> surveyData) {
        String username = getCurrentUsername();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student record not found for: " + username));

        return ResponseEntity.ok(exitRequirementService.submitExitSurvey(student.getId(), surveyData));
    }

    // =========================================================================
    // 2. FACULTY ENDPOINTS
    // =========================================================================

    @GetMapping("/faculty/dashboard")
    @PreAuthorize("hasAnyRole('FACULTY', 'SUPER_ADMIN')")
    public ResponseEntity<?> getFacultyDashboard() {
        String username = getCurrentUsername();
        return ResponseEntity.ok(exitRequirementService.getFacultyDashboardData(username));
    }

    @GetMapping("/faculty/students")
    @PreAuthorize("hasAnyRole('FACULTY', 'SUPER_ADMIN')")
    public ResponseEntity<?> getFacultyStudents(
            @RequestParam(required = false) String search,
            @RequestParam(required = false, defaultValue = "ALL") String status) {
        String username = getCurrentUsername();
        return ResponseEntity.ok(exitRequirementService.getFacultyStudentsRoster(username, search, status));
    }

    @GetMapping("/faculty/student/{studentId}")
    @PreAuthorize("hasAnyRole('FACULTY', 'SUPER_ADMIN')")
    public ResponseEntity<?> getStudentExitDetailForFaculty(@PathVariable Long studentId) {
        return ResponseEntity.ok(exitRequirementService.getStudentExitStatus(studentId));
    }

    @PostMapping("/faculty/review")
    @PreAuthorize("hasAnyRole('FACULTY', 'SUPER_ADMIN')")
    public ResponseEntity<?> facultyReviewRequirement(@RequestBody Map<String, String> payload) {
        Long clearanceId = Long.valueOf(payload.get("clearanceId"));
        String status = payload.getOrDefault("status", "APPROVED");
        String remarks = payload.getOrDefault("remarks", "");
        String username = getCurrentUsername();

        return ResponseEntity.ok(exitRequirementService.reviewClearance(clearanceId, status, remarks, username, "FACULTY"));
    }

    @PostMapping("/faculty/bulk-approve")
    @PreAuthorize("hasAnyRole('FACULTY', 'SUPER_ADMIN')")
    public ResponseEntity<?> facultyBulkApprove(@RequestBody Map<String, Object> payload) {
        @SuppressWarnings("unchecked")
        List<Object> idsObj = (List<Object>) payload.get("clearanceIds");
        List<Long> clearanceIds = idsObj.stream().map(o -> Long.valueOf(o.toString())).toList();
        String remarks = (String) payload.getOrDefault("remarks", "Bulk approved by faculty advisor.");
        String username = getCurrentUsername();

        int approvedCount = exitRequirementService.bulkReviewClearances(clearanceIds, "APPROVED", remarks, username, "FACULTY");
        return ResponseEntity.ok(Map.of("message", "Successfully approved " + approvedCount + " clearance records.", "count", approvedCount));
    }

    // =========================================================================
    // 3. SUPER ADMIN ENDPOINTS
    // =========================================================================

    @GetMapping("/admin/dashboard")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> getAdminDashboard() {
        return ResponseEntity.ok(exitRequirementService.getAdminDashboardData());
    }

    @GetMapping("/admin/all-students")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> getAdminAllStudents(
            @RequestParam(required = false, defaultValue = "ALL") String department,
            @RequestParam(required = false, defaultValue = "ALL") String status,
            @RequestParam(required = false) String search) {
        return ResponseEntity.ok(exitRequirementService.getAllStudentsAdminRoster(department, status, search));
    }

    @GetMapping("/admin/student/{studentId}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> getStudentExitDetailForAdmin(@PathVariable Long studentId) {
        return ResponseEntity.ok(exitRequirementService.getStudentExitStatus(studentId));
    }

    @PostMapping("/admin/review")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> adminReviewRequirement(@RequestBody Map<String, String> payload) {
        Long clearanceId = Long.valueOf(payload.get("clearanceId"));
        String status = payload.getOrDefault("status", "APPROVED");
        String remarks = payload.getOrDefault("remarks", "");
        String username = getCurrentUsername();

        return ResponseEntity.ok(exitRequirementService.reviewClearance(clearanceId, status, remarks, username, "SUPER_ADMIN"));
    }

    @PostMapping("/admin/final-clearance/{studentId}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> grantFinalClearance(
            @PathVariable Long studentId,
            @RequestBody(required = false) Map<String, String> payload) {
        String remarks = (payload != null) ? payload.getOrDefault("remarks", "Approved for graduation by Super Administrator.") : "Approved for graduation.";
        String username = getCurrentUsername();
        return ResponseEntity.ok(exitRequirementService.grantFinalClearance(studentId, username, remarks));
    }

    @PostMapping("/admin/auto-evaluate-all")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> autoEvaluateAll() {
        return ResponseEntity.ok(exitRequirementService.autoEvaluateAllStudents());
    }

    @GetMapping("/admin/export-excel")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<byte[]> exportExitExcel() {
        try {
            byte[] excelBytes = exitRequirementService.exportExitReportExcel();
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=university_exit_clearance_report.xlsx")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(excelBytes);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // Master Requirements Configuration
    @GetMapping("/admin/requirements")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> getMasterRequirements() {
        return ResponseEntity.ok(requirementMasterRepository.findAllByOrderByDisplayOrderAsc());
    }

    @PostMapping("/admin/requirements")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> saveMasterRequirement(@RequestBody ExitRequirementMaster req) {
        return ResponseEntity.ok(requirementMasterRepository.save(req));
    }

    @DeleteMapping("/admin/requirements/{id}")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<?> deleteMasterRequirement(@PathVariable Long id) {
        requirementMasterRepository.deleteById(id);
        return ResponseEntity.ok(Map.of("message", "Exit requirement deleted successfully"));
    }
}
