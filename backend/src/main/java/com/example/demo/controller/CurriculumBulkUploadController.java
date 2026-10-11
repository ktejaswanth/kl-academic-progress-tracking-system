package com.example.demo.controller;

import com.example.demo.service.CurriculumBulkUploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/api/dyod/upload")
@CrossOrigin(origins = "http://localhost:5173")
public class CurriculumBulkUploadController {

    @Autowired
    private CurriculumBulkUploadService bulkUploadService;

    @PostMapping("/courses")
    public ResponseEntity<?> uploadCourses(@RequestParam("file") MultipartFile file) {
        try {
            return ResponseEntity.ok(bulkUploadService.uploadCourseCatalog(file));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/requirements")
    public ResponseEntity<?> uploadRequirements(@RequestParam("file") MultipartFile file) {
        try {
            return ResponseEntity.ok(bulkUploadService.uploadPathRequirements(file));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/mappings")
    public ResponseEntity<?> uploadMappings(@RequestParam("file") MultipartFile file) {
        try {
            return ResponseEntity.ok(bulkUploadService.uploadCourseBucketMappings(file));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/template/{type}")
    public ResponseEntity<byte[]> getTemplate(@PathVariable String type) {
        try {
            byte[] file = bulkUploadService.generateTemplate(type);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
            headers.setContentDispositionFormData("attachment", type + "_template.xlsx");
            return ResponseEntity.ok().headers(headers).body(file);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
