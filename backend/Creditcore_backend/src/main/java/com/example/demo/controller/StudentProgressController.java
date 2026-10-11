package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.StudentRepository;
import com.example.demo.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/student/progress")
@CrossOrigin(origins = "*")
public class StudentProgressController {

    @Autowired private DegreeEligibilityEngine degreeEligibilityEngine;
    @Autowired private BucketSatisfactionEngine bucketSatisfactionEngine;
    @Autowired private DegreePathEngine degreePathEngine;
    @Autowired private SpecializationProgressEngine specializationProgressEngine;
    @Autowired private MinorProgressEngine minorProgressEngine;
    @Autowired private SecondMajorProgressEngine secondMajorProgressEngine;
    @Autowired private StudentRepository studentRepository;
    @Autowired private UserSecurityService userSecurityService;

    @GetMapping("/dashboard")
    public ResponseEntity<?> getStudentDashboard(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getName())) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "Full authentication required."));
        }
        String username = authentication.getName();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student not found: " + username));

        return getStudentDashboardById(student.getId());
    }

    @GetMapping("/dashboard/{studentId}")
    public ResponseEntity<?> getStudentDashboardById(@PathVariable Long studentId) {
        if (!userSecurityService.canAccessStudentData(studentId)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN)
                    .body(Map.of("error", "Access denied: You are not authorized to view another student's progress dashboard."));
        }

        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + studentId));

        Map<String, Object> response = new LinkedHashMap<>();

        // 1. Student Identity Info
        Map<String, Object> studentInfo = new LinkedHashMap<>();
        studentInfo.put("studentId", student.getId());
        studentInfo.put("username", student.getStudentId());
        studentInfo.put("universityId", student.getStudentId());
        String fullName = student.getName() != null && !student.getName().trim().isEmpty()
                ? student.getName()
                : ((student.getFirstName() != null ? student.getFirstName() : "") + " " + (student.getLastName() != null ? student.getLastName() : "")).trim();
        studentInfo.put("fullName", fullName.isEmpty() ? student.getStudentId() : fullName);
        studentInfo.put("email", student.getEmail());
        studentInfo.put("department", student.getDepartment());
        studentInfo.put("degreeType", student.getSubDepartment() != null ? student.getSubDepartment() : "REGULAR");
        studentInfo.put("addonType", student.getSpecializationType() != null ? student.getSpecializationType() : "NONE");
        studentInfo.put("addonName", student.getSpecializationName());
        response.put("student", studentInfo);

        // 2. Assigned Degree Path
        Optional<StudentDegreePath> sdpOpt = degreePathEngine.getStudentPath(studentId);
        if (sdpOpt.isEmpty()) {
            // Auto resolve if missing
            try {
                DegreePath path = degreePathEngine.resolveAndAssignPath(studentId);
                sdpOpt = degreePathEngine.getStudentPath(studentId);
            } catch (Exception e) {
                response.put("error", "No degree path assigned: " + e.getMessage());
                return ResponseEntity.ok(response);
            }
        }

        DegreePath path = sdpOpt.get().getDegreePath();
        Map<String, Object> pathInfo = new LinkedHashMap<>();
        pathInfo.put("pathId", path.getId());
        pathInfo.put("pathCode", path.getPathCode());
        pathInfo.put("department", path.getDepartment() != null ? path.getDepartment().getDeptCode() : "N/A");
        pathInfo.put("degreeType", path.getDegreeType() != null ? path.getDegreeType().getTypeCode() : "REGULAR");
        pathInfo.put("degreeTypeName", path.getDegreeType() != null ? path.getDegreeType().getTypeName() : "Regular");
        pathInfo.put("addonType", path.getAddonType() != null ? path.getAddonType().getAddonCode() : "NONE");
        pathInfo.put("totalRequiredCredits", path.getTotalCredits());
        response.put("degreePath", pathInfo);

        // 3. Evaluate Eligibility & Buckets
        StudentDegreeStatus status = degreeEligibilityEngine.evaluateEligibility(studentId);
        response.put("degreeStatus", status);

        // 4. Bucket Progress List (with detailed courses)
        List<Map<String, Object>> buckets = bucketSatisfactionEngine.getDetailedBucketProgress(studentId);
        response.put("buckets", buckets);

        // 5. Specialization Progress if applicable
        if (path.getSpecialization() != null) {
            Map<String, Object> specProgress = specializationProgressEngine.calculateSpecializationProgress(studentId, path.getSpecialization().getId());
            response.put("specializationProgress", specProgress);
        }

        // 6. Minor Progress if applicable
        if (path.getMinor() != null) {
            Map<String, Object> minorProgress = minorProgressEngine.calculateMinorProgress(studentId, path.getMinor().getId());
            response.put("minorProgress", minorProgress);
        }

        // 7. Second Major Progress if applicable
        if (path.getSecondMajor() != null) {
            Map<String, Object> smProgress = secondMajorProgressEngine.calculateSecondMajorProgress(studentId, path.getSecondMajor().getId());
            response.put("secondMajorProgress", smProgress);
        }

        return ResponseEntity.ok(response);
    }
}
