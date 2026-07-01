package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

/**
 * Bucket Satisfaction Engine
 *
 * For each bucket in a student's degree path, compares required vs earned credits
 * and determines satisfaction status.
 *
 * Algorithm:
 *   For each PathBucketRequirement:
 *     1. Get required_credits from path_bucket_requirements
 *     2. Get earned_credits from BucketMappingEngine
 *     3. status = earned >= required ? COMPLETED : (earned > 0 ? IN_PROGRESS : PENDING)
 *     4. Save/update student_bucket_progress
 */
@Service
@Transactional
public class BucketSatisfactionEngine {

    @Autowired
    private PathBucketRequirementRepository pathBucketRequirementRepository;
    @Autowired
    private StudentBucketProgressRepository studentBucketProgressRepository;
    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;
    @Autowired
    private BucketMappingEngine bucketMappingEngine;
    @Autowired
    private UserRepository userRepository;

    /**
     * Evaluate all bucket satisfaction for a student.
     * Recalculates progress for every bucket in their degree path.
     */
    public List<StudentBucketProgress> evaluateBuckets(Long studentId) {
        // 1. Get the student's degree path
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId)
                .orElseThrow(() -> new RuntimeException("Student has no assigned degree path. Please assign one first."));

        Long degreePathId = sdp.getDegreePath().getId();

        // 2. Get all bucket requirements for this path
        List<PathBucketRequirement> requirements = pathBucketRequirementRepository.findByDegreePathId(degreePathId);

        if (requirements.isEmpty()) {
            throw new RuntimeException("No bucket requirements defined for degree path: " + sdp.getDegreePath().getPathCode());
        }

        // 3. Map completed courses to buckets
        Map<Long, BucketMappingEngine.BucketCreditsInfo> earnedMap = 
                bucketMappingEngine.mapStudentCoursesToBuckets(studentId, degreePathId);

        // 4. For each required bucket, calculate progress
        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        DegreePath degreePath = sdp.getDegreePath();

        List<StudentBucketProgress> progressList = new ArrayList<>();

        for (PathBucketRequirement req : requirements) {
            Long bucketId = req.getBucket().getId();
            int requiredCredits = req.getRequiredCredits();

            // Get earned credits for this bucket
            BucketMappingEngine.BucketCreditsInfo earned = earnedMap.get(bucketId);
            int earnedCredits = (earned != null) ? earned.getEarnedCredits() : 0;
            int courseCount = (earned != null) ? earned.getCourseCount() : 0;

            // Determine status
            String status;
            if (earnedCredits >= requiredCredits) {
                status = "COMPLETED";
            } else if (earnedCredits > 0) {
                status = "IN_PROGRESS";
            } else {
                status = "PENDING";
            }

            // Upsert student_bucket_progress
            StudentBucketProgress progress = studentBucketProgressRepository
                    .findByStudentIdAndBucketIdAndDegreePathId(studentId, bucketId, degreePathId)
                    .orElse(new StudentBucketProgress());

            progress.setStudent(student);
            progress.setBucket(req.getBucket());
            progress.setDegreePath(degreePath);
            progress.setRequiredCredits(requiredCredits);
            progress.setEarnedCredits(earnedCredits);
            progress.setCourseCount(courseCount);
            progress.setStatus(status);
            progress.setLastCalculated(LocalDateTime.now());

            studentBucketProgressRepository.save(progress);
            progressList.add(progress);
        }

        return progressList;
    }

    /**
     * Get the current bucket progress for a student (without recalculating).
     */
    public List<StudentBucketProgress> getStudentBucketProgress(Long studentId) {
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId).orElse(null);
        if (sdp == null) return Collections.emptyList();
        return studentBucketProgressRepository.findByStudentIdAndDegreePathId(studentId, sdp.getDegreePath().getId());
    }

    /**
     * Get detailed progress report per bucket including course lists.
     */
    public List<Map<String, Object>> getDetailedBucketProgress(Long studentId) {
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId)
                .orElseThrow(() -> new RuntimeException("Student has no assigned degree path"));

        Long degreePathId = sdp.getDegreePath().getId();

        // Get stored progress
        List<StudentBucketProgress> progressList = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(studentId, degreePathId);

        // Get earned course details
        Map<Long, BucketMappingEngine.BucketCreditsInfo> earnedMap =
                bucketMappingEngine.mapStudentCoursesToBuckets(studentId, degreePathId);

        List<Map<String, Object>> result = new ArrayList<>();

        for (StudentBucketProgress progress : progressList) {
            Map<String, Object> bucketDetail = new LinkedHashMap<>();
            bucketDetail.put("bucketId", progress.getBucket().getId());
            bucketDetail.put("bucketCode", progress.getBucket().getBucketCode());
            bucketDetail.put("bucketName", progress.getBucket().getBucketName());
            bucketDetail.put("bucketCategory", progress.getBucket().getBucketCategory());
            bucketDetail.put("requiredCredits", progress.getRequiredCredits());
            bucketDetail.put("earnedCredits", progress.getEarnedCredits());
            bucketDetail.put("courseCount", progress.getCourseCount());
            bucketDetail.put("status", progress.getStatus());
            bucketDetail.put("lastCalculated", progress.getLastCalculated());

            // Completion percentage for this bucket
            double percentage = progress.getRequiredCredits() > 0
                    ? Math.min(100.0, (double) progress.getEarnedCredits() / progress.getRequiredCredits() * 100.0)
                    : 100.0;
            bucketDetail.put("completionPercentage", Math.round(percentage * 100.0) / 100.0);

            // Add completed courses for this bucket
            BucketMappingEngine.BucketCreditsInfo earned = earnedMap.get(progress.getBucket().getId());
            bucketDetail.put("completedCourses", earned != null ? earned.getCourses() : Collections.emptyList());

            // Add pending/available courses for this bucket
            if (!"COMPLETED".equals(progress.getStatus())) {
                List<Map<String, Object>> availableCourses = bucketMappingEngine
                        .getCoursesForBucket(progress.getBucket().getId(), degreePathId);
                // Filter out already completed ones
                Set<String> completedCodes = new HashSet<>();
                if (earned != null) {
                    earned.getCourses().forEach(c -> completedCodes.add((String) c.get("courseCode")));
                }
                List<Map<String, Object>> pending = new ArrayList<>();
                for (Map<String, Object> c : availableCourses) {
                    if (!completedCodes.contains(c.get("courseCode"))) {
                        pending.add(c);
                    }
                }
                bucketDetail.put("pendingCourses", pending);
            } else {
                bucketDetail.put("pendingCourses", Collections.emptyList());
            }

            result.add(bucketDetail);
        }

        return result;
    }
}
