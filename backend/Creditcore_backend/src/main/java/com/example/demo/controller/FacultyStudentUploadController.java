package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.BulkUploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/faculty")
public class FacultyStudentUploadController {

    @Autowired
    private BulkUploadService bulkUploadService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/upload-students")
    public ResponseEntity<?> uploadStudents(@RequestParam("file") MultipartFile file) {
        try {
            if (file == null || file.isEmpty()) {
                return ResponseEntity.badRequest().body("Please select a valid Excel file to upload.");
            }
            
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            User currentUser = userRepository.findByUsername(username).orElse(null);

            List<BulkUploadService.CredentialInfo> credentials = bulkUploadService.processBulkUpload(file, currentUser);
            return ResponseEntity.ok(credentials);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Upload Error: " + e.getMessage());
        }
    }
}
