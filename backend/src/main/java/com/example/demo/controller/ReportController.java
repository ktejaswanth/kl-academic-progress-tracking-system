package com.example.demo.controller;

import com.example.demo.model.Student;
import com.example.demo.repository.StudentRepository;
import com.example.demo.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/reports")
@CrossOrigin(origins = "http://localhost:5173")
public class ReportController {

    @Autowired
    private ReportService reportService;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private com.example.demo.service.UserSecurityService userSecurityService;

    @GetMapping("/student/{id}")
    public ResponseEntity<?> getStudentReport(@PathVariable Long id) {
        if (!userSecurityService.canAccessStudentData(id)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Access denied: You are not authorized to view another student's report."));
        }
        try {
            Map<String, Object> data = reportService.getStudentReport(id);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/student/me")
    public ResponseEntity<?> getMyReport() {
        org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Full authentication required."));
        }
        String username = auth.getName();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student user not found: " + username));

        try {
            Map<String, Object> data = reportService.getStudentReport(student.getId());
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/student/{id}/excel")
    public ResponseEntity<?> downloadStudentReportExcel(@PathVariable Long id) {
        if (!userSecurityService.canAccessStudentData(id)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Access denied: You are not authorized to download another student's report."));
        }
        try {
            byte[] fileBytes = reportService.exportStudentReportExcel(id);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=student_progress_report_" + id + ".xlsx")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(fileBytes);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/student/me/excel")
    public ResponseEntity<byte[]> downloadMyReportExcel() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student user not found: " + username));

        try {
            byte[] fileBytes = reportService.exportStudentReportExcel(student.getId());
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=student_progress_report_" + student.getStudentId() + ".xlsx")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(fileBytes);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/student/me/eligibility-pdf")
    public ResponseEntity<byte[]> downloadMyEligibilityPdf() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student user not found: " + username));

        try {
            byte[] fileBytes = reportService.exportEligibilityAuditPdf(student.getId());
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=Graduation_Eligibility_Audit_" + student.getStudentId() + ".pdf")
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(fileBytes);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/student/{id}/eligibility-pdf")
    public ResponseEntity<byte[]> downloadStudentEligibilityPdf(@PathVariable Long id) {
        if (!userSecurityService.canAccessStudentData(id)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN).build();
        }
        try {
            Student student = studentRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Student not found: " + id));
            byte[] fileBytes = reportService.exportEligibilityAuditPdf(id);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=Graduation_Eligibility_Audit_" + student.getStudentId() + ".pdf")
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(fileBytes);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/department/{dept}")
    public ResponseEntity<?> getDepartmentReport(@PathVariable String dept) {
        try {
            Map<String, Object> data = reportService.getDepartmentReport(dept);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/department/{dept}/excel")
    public ResponseEntity<byte[]> downloadDepartmentReportExcel(@PathVariable String dept) {
        try {
            byte[] fileBytes = reportService.exportDepartmentReportExcel(dept);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=department_report_" + dept + ".xlsx")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(fileBytes);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/graduation-readiness")
    public ResponseEntity<?> getGraduationReadinessReport() {
        try {
            Map<String, Object> data = reportService.getGraduationReadinessReport();
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/graduation-readiness/excel")
    public ResponseEntity<byte[]> downloadGraduationReadinessExcel() {
        try {
            byte[] fileBytes = reportService.exportGraduationReadinessExcel();
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=graduation_readiness_report.xlsx")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(fileBytes);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
