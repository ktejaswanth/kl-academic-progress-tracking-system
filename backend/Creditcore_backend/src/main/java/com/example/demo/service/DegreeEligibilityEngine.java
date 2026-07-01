package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.*;

/**
 * Degree Eligibility Engine
 *
 * Top-level engine that evaluates overall degree eligibility for a student.
 * Aggregates results from BucketSatisfactionEngine.
 *
 * Algorithm:
 *   1. Run BucketSatisfactionEngine to update all buckets
 *   2. Sum required credits across all buckets
 *   3. Sum earned credits across all buckets
 *   4. Count completed buckets vs total buckets
 *   5. if (completedBuckets == totalBuckets && totalEarned >= totalRequired) -> ELIGIBLE
 */
@Service
@Transactional
public class DegreeEligibilityEngine {

    @Autowired
    private StudentDegreeStatusRepository studentDegreeStatusRepository;
    @Autowired
    private BucketSatisfactionEngine bucketSatisfactionEngine;
    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;
    @Autowired
    private UserRepository userRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * Evaluate overall degree eligibility for a student.
     */
    public StudentDegreeStatus evaluateEligibility(Long studentId) {
        // 1. Get the assigned path
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId)
                .orElseThrow(() -> new RuntimeException("Student has no assigned degree path."));

        // 2. Trigger bucket evaluation
        List<StudentBucketProgress> progressList = bucketSatisfactionEngine.evaluateBuckets(studentId);

        if (progressList.isEmpty()) {
            throw new RuntimeException("No bucket progress found for student");
        }

        // 3. Aggregate totals
        int totalRequired = 0;
        int totalEarned = 0;
        int bucketsTotal = progressList.size();
        int bucketsCompleted = 0;

        List<Map<String, Object>> failedBuckets = new ArrayList<>();

        for (StudentBucketProgress progress : progressList) {
            totalRequired += progress.getRequiredCredits();
            
            // Only count earned credits up to the required amount for the percentage calculation
            // to prevent one over-fulfilled bucket from hiding an under-fulfilled one
            int effectiveEarned = Math.min(progress.getEarnedCredits(), progress.getRequiredCredits());
            totalEarned += effectiveEarned;

            if ("COMPLETED".equals(progress.getStatus())) {
                bucketsCompleted++;
            } else {
                Map<String, Object> failInfo = new HashMap<>();
                failInfo.put("bucketCode", progress.getBucket().getBucketCode());
                failInfo.put("required", progress.getRequiredCredits());
                failInfo.put("earned", progress.getEarnedCredits());
                failInfo.put("shortfall", progress.getRequiredCredits() - progress.getEarnedCredits());
                failedBuckets.add(failInfo);
            }
        }

        // 4. Determine overall status
        boolean isEligible = (bucketsCompleted == bucketsTotal) && (totalEarned >= totalRequired);
        String status = isEligible ? "ELIGIBLE" : "IN_PROGRESS";

        // Calculate percentage
        BigDecimal percentage = totalRequired > 0
                ? new BigDecimal(totalEarned).divide(new BigDecimal(totalRequired), 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100))
                : BigDecimal.valueOf(100.00);

        // 5. Create details JSON
        Map<String, Object> detailsMap = new HashMap<>();
        detailsMap.put("failedBuckets", failedBuckets);
        detailsMap.put("totalEarnedRaw", progressList.stream().mapToInt(StudentBucketProgress::getEarnedCredits).sum());
        
        String detailsJson;
        try {
            detailsJson = objectMapper.writeValueAsString(detailsMap);
        } catch (JsonProcessingException e) {
            detailsJson = "{}";
        }

        // 6. Save or update status
        User student = userRepository.findById(studentId).orElseThrow();
        StudentDegreeStatus degreeStatus = studentDegreeStatusRepository.findByStudentId(studentId)
                .orElse(new StudentDegreeStatus());

        degreeStatus.setStudent(student);
        degreeStatus.setDegreePath(sdp.getDegreePath());
        degreeStatus.setTotalRequiredCredits(totalRequired);
        degreeStatus.setTotalEarnedCredits(progressList.stream().mapToInt(StudentBucketProgress::getEarnedCredits).sum()); // Store raw total
        degreeStatus.setCompletionPercentage(percentage);
        degreeStatus.setBucketsCompleted(bucketsCompleted);
        degreeStatus.setBucketsTotal(bucketsTotal);
        degreeStatus.setIsDegreeEligible(isEligible);
        degreeStatus.setStatus(status);
        degreeStatus.setLastEvaluated(LocalDateTime.now());
        degreeStatus.setDetails(detailsJson);

        return studentDegreeStatusRepository.save(degreeStatus);
    }

    /**
     * Retrieve the current overall status for a student without recalculating.
     */
    public Optional<StudentDegreeStatus> getStudentStatus(Long studentId) {
        return studentDegreeStatusRepository.findByStudentId(studentId);
    }

    /**
     * Batch evaluate all students.
     */
    public Map<String, Object> batchEvaluateAllStudents() {
        List<StudentDegreePath> allPaths = studentDegreePathRepository.findAll();
        int evaluated = 0;
        int eligible = 0;
        int failed = 0;

        for (StudentDegreePath sdp : allPaths) {
            try {
                StudentDegreeStatus status = evaluateEligibility(sdp.getStudent().getId());
                evaluated++;
                if (status.getIsDegreeEligible()) {
                    eligible++;
                }
            } catch (Exception e) {
                failed++;
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("totalStudents", allPaths.size());
        result.put("evaluated", evaluated);
        result.put("eligible", eligible);
        result.put("failed", failed);
        return result;
    }
}
