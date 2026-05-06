package com.example.demo.controller;

import com.example.demo.model.UploadHistory;
import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.BulkUploadService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/faculty")
public class FacultyController {

    @Autowired
    private BulkUploadService bulkUploadService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/upload-students")
    public ResponseEntity<?> uploadStudents(@RequestParam("file") MultipartFile file) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User uploadedBy = userRepository.findByUsername(username).orElseThrow();

        try {
            List<BulkUploadService.CredentialInfo> credentials = bulkUploadService.processBulkUpload(file, uploadedBy);
            return ResponseEntity.ok(credentials);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Upload failed: " + e.getMessage());
        }
    }

    @GetMapping("/download-credentials/{uploadId}")
    public ResponseEntity<byte[]> downloadCredentials(@PathVariable Long uploadId) {
        try {
            byte[] excelContent = bulkUploadService.generateCredentialsExcel(uploadId);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=credentials_" + uploadId + ".xlsx")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(excelContent);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/analytics")
    public ResponseEntity<?> getAnalytics() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findByUsername(username).orElseThrow();
        return ResponseEntity.ok(bulkUploadService.getFacultyAnalytics(user));
    }
}
