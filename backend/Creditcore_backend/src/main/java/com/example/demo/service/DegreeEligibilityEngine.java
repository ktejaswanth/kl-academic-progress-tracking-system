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
 * Aggregates results from BucketSatisfactionEngine and validates:
 *   1. All degree path bucket requirements satisfied (credits, courses, mandatory, grouping)
 *   2. Total counted credits (capped per bucket) meets or exceeds degree path total requirement
 *   3. Non-credit outcome requirements (minimum CGPA, publications, patents, consultancy, backlog rules)
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
    private StudentRepository studentRepository;
    @Autowired
    private DegreeOutcomeRequirementRepository degreeOutcomeRequirementRepository;
    @Autowired
    private StudentOutcomeRepository studentOutcomeRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * Evaluate overall degree eligibility for a student.
     */
    public StudentDegreeStatus evaluateEligibility(Long studentId) {
        // 1. Get the assigned path
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId)
                .orElseThrow(() -> new RuntimeException("Student has no assigned degree path."));

        DegreePath degreePath = sdp.getDegreePath();

        // 2. Trigger bucket evaluation
        List<StudentBucketProgress> progressList = bucketSatisfactionEngine.evaluateBuckets(studentId);

        if (progressList.isEmpty()) {
            throw new RuntimeException("No bucket progress found for student");
        }

        // 3. Aggregate totals using degree path total credits as source of truth
        int totalRequired = (degreePath.getTotalCredits() != null && degreePath.getTotalCredits() > 0)
                ? degreePath.getTotalCredits()
                : progressList.stream().mapToInt(StudentBucketProgress::getRequiredCredits).sum();

        int totalCounted = 0;
        int totalEarnedRaw = 0;
        int bucketsTotal = progressList.size();
        int bucketsCompleted = 0;

        List<Map<String, Object>> failedBuckets = new ArrayList<>();

        for (StudentBucketProgress progress : progressList) {
            int counted = (progress.getCountedCredits() != null) ? progress.getCountedCredits() : progress.getEarnedCredits();
            totalCounted += counted;
            totalEarnedRaw += progress.getEarnedCredits();

            if ("COMPLETED".equals(progress.getStatus())) {
                bucketsCompleted++;
            } else {
                Map<String, Object> failInfo = new LinkedHashMap<>();
                failInfo.put("bucketCode", progress.getBucket().getBucketCode());
                failInfo.put("required", progress.getRequiredCredits());
                failInfo.put("earned", progress.getEarnedCredits());
                failInfo.put("counted", counted);
                failInfo.put("shortfall", progress.getRemainingCredits() != null 
                        ? progress.getRemainingCredits() 
                        : Math.max(0, progress.getRequiredCredits() - counted));
                failInfo.put("minCourses", progress.getMinCourses());
                failInfo.put("courseCount", progress.getCourseCount());
                failInfo.put("countedCourses", progress.getCountedCourses());
                failInfo.put("mandatorySatisfied", progress.getMandatorySatisfied());
                failedBuckets.add(failInfo);
            }
        }

        // 4. Evaluate Outcome Requirements (CGPA, publications, patents, consultancy, backlogs)
        boolean outcomesSatisfied = true;
        Map<String, Object> outcomeCheckResult = new LinkedHashMap<>();
        Optional<DegreeOutcomeRequirement> dorOpt = degreeOutcomeRequirementRepository.findByDegreePathId(degreePath.getId());
        if (dorOpt.isPresent()) {
            DegreeOutcomeRequirement req = dorOpt.get();
            Optional<StudentOutcome> soOpt = studentOutcomeRepository.findByStudentId(studentId);
            if (soOpt.isPresent()) {
                StudentOutcome so = soOpt.get();
                boolean cgpaOk = (req.getMinCgpa() == null || req.getMinCgpa() <= 0 || (so.getCgpa() != null && so.getCgpa() >= req.getMinCgpa()));
                boolean scopusOk = (req.getMinScopusPublications() == null || req.getMinScopusPublications() <= 0 || (so.getScopusPublications() != null && so.getScopusPublications() >= req.getMinScopusPublications()));
                boolean patentsOk = (req.getMinDesignPatents() == null || req.getMinDesignPatents() <= 0 || (so.getDesignPatents() != null && so.getDesignPatents() >= req.getMinDesignPatents()));
                boolean consultOk = (req.getMinConsultancyProjects() == null || req.getMinConsultancyProjects() <= 0 || (so.getConsultancyProjects() != null && so.getConsultancyProjects() >= req.getMinConsultancyProjects()));
                boolean backlogOk = (!Boolean.TRUE.equals(req.getNoBacklogHistory()) || !Boolean.TRUE.equals(so.getHasBacklogHistory()));
                boolean bettermentOk = (!Boolean.TRUE.equals(req.getNoBettermentHistory()) || !Boolean.TRUE.equals(so.getHasBettermentHistory()));

                outcomesSatisfied = cgpaOk && scopusOk && patentsOk && consultOk && backlogOk && bettermentOk;
                outcomeCheckResult.put("cgpaSatisfied", cgpaOk);
                outcomeCheckResult.put("scopusSatisfied", scopusOk);
                outcomeCheckResult.put("patentsSatisfied", patentsOk);
                outcomeCheckResult.put("consultancySatisfied", consultOk);
                outcomeCheckResult.put("backlogSatisfied", backlogOk);
                outcomeCheckResult.put("bettermentSatisfied", bettermentOk);
                outcomeCheckResult.put("allOutcomesSatisfied", outcomesSatisfied);
                outcomeCheckResult.put("studentCgpa", so.getCgpa());
                outcomeCheckResult.put("minCgpaRequired", req.getMinCgpa());
            } else {
                // If student outcome is not entered yet, don't fail immediately but flag as pending verification
                outcomeCheckResult.put("status", "OUTCOMES_PENDING_VERIFICATION");
                outcomeCheckResult.put("minCgpaRequired", req.getMinCgpa());
                outcomeCheckResult.put("minScopusRequired", req.getMinScopusPublications());
                outcomeCheckResult.put("minPatentsRequired", req.getMinDesignPatents());
            }
        }

        // 5. Determine overall status
        boolean allBucketsCompleted = (bucketsCompleted == bucketsTotal);
        boolean creditsSatisfied = (totalCounted >= totalRequired);
        boolean isEligible = allBucketsCompleted && creditsSatisfied && outcomesSatisfied;
        String status = isEligible ? "ELIGIBLE" : "IN_PROGRESS";

        // Calculate percentage (effective counted capped at required total)
        int effectiveCounted = Math.min(totalCounted, totalRequired);
        BigDecimal percentage = totalRequired > 0
                ? new BigDecimal(effectiveCounted).divide(new BigDecimal(totalRequired), 4, RoundingMode.HALF_UP).multiply(new BigDecimal(100))
                : BigDecimal.valueOf(100.00);

        // 6. Create details JSON
        Map<String, Object> detailsMap = new LinkedHashMap<>();
        detailsMap.put("failedBuckets", failedBuckets);
        detailsMap.put("totalEarnedRaw", totalEarnedRaw);
        detailsMap.put("totalCountedCredits", totalCounted);
        detailsMap.put("totalRequiredCredits", totalRequired);
        detailsMap.put("excessCreditsTotal", Math.max(0, totalEarnedRaw - totalCounted));
        detailsMap.put("allBucketsCompleted", allBucketsCompleted);
        detailsMap.put("creditsSatisfied", creditsSatisfied);
        detailsMap.put("outcomes", outcomeCheckResult);

        String detailsJson;
        try {
            detailsJson = objectMapper.writeValueAsString(detailsMap);
        } catch (JsonProcessingException e) {
            detailsJson = "{}";
        }

        // 7. Save or update status
        Student student = studentRepository.findById(studentId).orElseThrow();
        StudentDegreeStatus degreeStatus = studentDegreeStatusRepository.findByStudentId(studentId)
                .orElse(new StudentDegreeStatus());

        degreeStatus.setStudent(student);
        degreeStatus.setDegreePath(degreePath);
        degreeStatus.setTotalRequiredCredits(totalRequired);
        degreeStatus.setTotalEarnedCredits(totalCounted); // Official counted credits
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
