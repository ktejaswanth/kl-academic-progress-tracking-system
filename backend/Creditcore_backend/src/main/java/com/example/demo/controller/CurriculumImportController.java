package com.example.demo.controller;

import com.example.demo.dto.curriculum.CurriculumAnalysisResult;
import com.example.demo.dto.curriculum.CurriculumUploadRequest;
import com.example.demo.dto.curriculum.CurriculumImportSummary;
import com.example.demo.service.CurriculumImportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/curriculum")
@CrossOrigin(origins = "http://localhost:5173")
public class CurriculumImportController {

    @Autowired
    private CurriculumImportService importService;

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> uploadCurriculum(
            @RequestParam("file") MultipartFile file,
            @RequestParam("curriculumName") String curriculumName,
            @RequestParam("department") String department,
            @RequestParam("regulation") String regulation,
            @RequestParam("academicYear") String academicYear) {
        try {
            CurriculumUploadRequest request = new CurriculumUploadRequest(
                    curriculumName, department, regulation, academicYear
            );
            CurriculumImportSummary summary = importService.uploadPdf(file, request);
            return ResponseEntity.status(HttpStatus.CREATED).body(summary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/{id}/analyze")
    public ResponseEntity<?> analyzeCurriculum(@PathVariable Long id) {
        try {
            CurriculumImportSummary summary = importService.analyzeCurriculum(id);
            return ResponseEntity.ok(summary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/{id}/summary")
    public ResponseEntity<?> getSummary(@PathVariable Long id) {
        try {
            CurriculumImportSummary summary = importService.getSummary(id);
            return ResponseEntity.ok(summary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/{id}/detail")
    public ResponseEntity<?> getDetail(@PathVariable Long id) {
        try {
            CurriculumAnalysisResult detail = importService.getAnalysisDetail(id);
            return ResponseEntity.ok(detail);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/{id}/edit")
    public ResponseEntity<?> editAnalysis(
            @PathVariable Long id,
            @RequestBody CurriculumAnalysisResult editedResult) {
        try {
            CurriculumImportSummary summary = importService.updateAnalysis(id, editedResult);
            return ResponseEntity.ok(summary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/{id}/approve")
    public ResponseEntity<?> approveCurriculum(@PathVariable Long id) {
        try {
            String currentUsername = SecurityContextHolder.getContext().getAuthentication().getName();
            CurriculumImportSummary summary = importService.approveCurriculum(id, currentUsername);
            return ResponseEntity.ok(summary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/{id}/reject")
    public ResponseEntity<?> rejectCurriculum(@PathVariable Long id) {
        try {
            CurriculumImportSummary summary = importService.rejectCurriculum(id);
            return ResponseEntity.ok(summary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping
    public ResponseEntity<?> listImports() {
        try {
            List<CurriculumImportSummary> list = importService.listImports();
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteImport(@PathVariable Long id) {
        try {
            importService.deleteImport(id);
            return ResponseEntity.ok(Map.of("message", "Import deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }
}
