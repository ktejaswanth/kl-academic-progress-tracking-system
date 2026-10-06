package com.example.demo.controller;

import com.example.demo.model.StudentDegreeStatus;
import com.example.demo.model.User;
import com.example.demo.repository.StudentDegreeStatusRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dyod/faculty")
@CrossOrigin(origins = "http://localhost:5173")
public class FacultyController {

    @Autowired
    private StudentDegreeStatusRepository statusRepository;
    
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private com.example.demo.repository.FacultyRepository facultyRepository;

    @Autowired
    private com.example.demo.service.AuditService auditService;

    @GetMapping("/dashboard")
    public ResponseEntity<?> getFacultyDashboard() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        String dept = "CSE";
        java.util.Optional<com.example.demo.model.Faculty> fOpt = facultyRepository.findByUsername(username);
        if (fOpt.isPresent()) {
            if (fOpt.get().getDepartment() != null && !fOpt.get().getDepartment().isEmpty()) {
                dept = fOpt.get().getDepartment();
            }
        } else {
            User faculty = userRepository.findByUsername(username).orElse(null);
            if (faculty != null && faculty.getDepartment() != null && !faculty.getDepartment().isEmpty()) {
                dept = faculty.getDepartment();
            }
        }
        
        long totalStudents = statusRepository.countByDepartment(dept);
        long eligibleStudents = statusRepository.countEligibleByDepartment(dept);
        
        List<StudentDegreeStatus> students = statusRepository.findByDepartment(dept);
        
        Map<String, Object> result = new HashMap<>();
        result.put("department", dept);
        result.put("totalStudents", totalStudents);
        result.put("eligibleStudents", eligibleStudents);
        result.put("pendingStudents", totalStudents - eligibleStudents);
        result.put("students", students);
        
        return ResponseEntity.ok(result);
    }

    @GetMapping("/students/lookup/{username}")
    public ResponseEntity<?> lookupStudentCurriculum(@PathVariable String username) {
        try {
            return ResponseEntity.ok(auditService.getStudentCurriculumCourses(username));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error looking up student: " + e.getMessage());
        }
    }
}
