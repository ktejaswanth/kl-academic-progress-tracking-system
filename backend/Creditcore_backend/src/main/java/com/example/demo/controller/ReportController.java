package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
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
    private UserRepository userRepository;

    @GetMapping("/student/{id}")
    public ResponseEntity<?> getStudentReport(@PathVariable Long id) {
        try {
            Map<String, Object> data = reportService.getStudentReport(id);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/student/me")
    public ResponseEntity<?> getMyReport() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User student = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Student user not found"));

        try {
            Map<String, Object> data = reportService.getStudentReport(student.getId());
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/student/{id}/excel")
    public ResponseEntity<byte[]> downloadStudentReportExcel(@PathVariable Long id) {
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
        User student = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Student user not found"));

        try {
            byte[] fileBytes = reportService.exportStudentReportExcel(student.getId());
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=student_progress_report_me.xlsx")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
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
