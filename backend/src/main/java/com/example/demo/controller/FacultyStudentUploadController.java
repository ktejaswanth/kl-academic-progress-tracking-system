package com.example.demo.controller;

import com.example.demo.repository.AdminRepository;
import com.example.demo.repository.FacultyRepository;
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
    private FacultyRepository facultyRepository;

    @Autowired
    private AdminRepository adminRepository;

    @PostMapping("/upload-students")
    public ResponseEntity<?> uploadStudents(@RequestParam("file") MultipartFile file) {
        try {
            if (file == null || file.isEmpty()) {
                return ResponseEntity.badRequest().body("Please select a valid Excel file to upload.");
            }
            
            String username = SecurityContextHolder.getContext().getAuthentication().getName();
            Long uploaderId = null;
            var fOpt = facultyRepository.findByUsername(username);
            if (fOpt.isPresent()) {
                uploaderId = fOpt.get().getId();
            } else {
                var aOpt = adminRepository.findByUsername(username);
                if (aOpt.isPresent()) {
                    uploaderId = aOpt.get().getId();
                }
            }

            List<BulkUploadService.CredentialInfo> credentials = bulkUploadService.processBulkUpload(file, uploaderId);
            return ResponseEntity.ok(credentials);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Upload Error: " + e.getMessage());
        }
    }

    @Autowired
    private com.example.demo.service.AuditService auditService;

    @GetMapping("/students/lookup/{username}")
    public ResponseEntity<?> lookupStudentCurriculum(@PathVariable String username) {
        try {
            return ResponseEntity.ok(auditService.getStudentCurriculumCourses(username));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error looking up student: " + e.getMessage());
        }
    }
}
