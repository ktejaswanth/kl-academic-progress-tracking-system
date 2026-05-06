package com.example.demo.service;

import com.example.demo.model.CompletedCourse;
import com.example.demo.model.Requirement;
import com.example.demo.model.StudentProfile;
import com.example.demo.model.User;
import com.example.demo.repository.CompletedCourseRepository;
import com.example.demo.repository.RequirementRepository;
import com.example.demo.repository.StudentProfileRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class AuditService {

    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private RequirementRepository requirementRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    public Map<String, Object> getStudentProgressByUsername(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return getStudentProgress(user.getId());
    }

    public Map<String, Object> getStudentProgress(Long userId) {
        StudentProfile profile = studentProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Student profile not found"));

        List<Requirement> requirements = requirementRepository.findByDegreeTypeAndSpecialization(
                profile.getDegreeType(), profile.getSpecialization());

        List<CompletedCourse> completed = completedCourseRepository.findByStudentId(userId);

        // 1. Calculate Statistics
        int totalRequired = requirements.stream().mapToInt(Requirement::getCredits).sum();
        int totalCompleted = completed.stream().mapToInt(CompletedCourse::getCredits).sum();
        double percentage = totalRequired > 0 ? (double) totalCompleted / totalRequired * 100 : 0;

        // 2. Map Categorized Progress
        Map<String, Map<String, Object>> categorySummaries = new HashMap<>();
        
        // Group requirements by bucket
        Map<String, List<Requirement>> groupedReqs = requirements.stream()
                .collect(Collectors.groupingBy(Requirement::getBucketName));

        for (String bucket : groupedReqs.keySet()) {
            List<Requirement> bucketReqs = groupedReqs.get(bucket);
            int reqCredits = bucketReqs.stream().mapToInt(Requirement::getCredits).sum();
            
            // This is a simplified logic: matching completed courses to buckets
            // In a real system, we'd match by course_code or rules
            int compCredits = completed.stream()
                    .filter(c -> bucketReqs.stream().anyMatch(r -> r.getCourseCode().equals(c.getCourseCode())))
                    .mapToInt(CompletedCourse::getCredits)
                    .sum();

            Map<String, Object> summary = new HashMap<>();
            summary.put("required", reqCredits);
            summary.put("completed", compCredits);
            summary.put("percentage", reqCredits > 0 ? (double) compCredits / reqCredits * 100 : 0);
            categorySummaries.put(bucket, summary);
        }

        // 3. Prepare Final Response
        Map<String, Object> response = new HashMap<>();
        response.put("studentName", profile.getUser().getFirstName() + " " + profile.getUser().getLastName());
        response.put("degree", profile.getDegreeType());
        response.put("specialization", profile.getSpecialization());
        response.put("totalCreditsRequired", totalRequired);
        response.put("totalCreditsCompleted", totalCompleted);
        response.put("completionPercentage", Math.round(percentage * 100.0) / 100.0);
        response.put("categorySummaries", categorySummaries);
        response.put("completedCourses", completed);
        
        // Identify missing mandatory courses
        List<Requirement> missingMandatory = requirements.stream()
                .filter(Requirement::getIsMandatory)
                .filter(r -> completed.stream().noneMatch(c -> c.getCourseCode().equals(r.getCourseCode())))
                .collect(Collectors.toList());
        
        response.put("missingMandatory", missingMandatory);

        return response;
    }
}
