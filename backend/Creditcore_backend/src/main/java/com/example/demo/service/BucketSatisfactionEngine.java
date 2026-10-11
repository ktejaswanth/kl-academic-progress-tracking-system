package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Bucket Satisfaction Engine
 *
 * For each bucket in a student's degree path, evaluates:
 *   1. Required minimum and maximum credits
 *   2. Course count limits (min_courses and max_courses)
 *   3. Mandatory courses per bucket
 *   4. Grouping constraints (PROJECT, MINOR, SPECIALIZATION, DOUBLE MAJOR)
 *   5. Credit capping: Counted credits cannot exceed max_credits
 *   6. Course capping: Extra courses beyond max_courses are excluded
 *
 * A bucket is COMPLETED only when ALL conditions are satisfied:
 *   - countedCredits >= requiredCredits (minCredits)
 *   - countedCourses >= minCourses
 *   - all mandatory courses completed
 *   - grouping constraints satisfied
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
    private StudentRepository studentRepository;
    @Autowired
    private CurriculumCourseMappingRepository curriculumCourseMappingRepository;
    @Autowired
    private MinorCourseRepository minorCourseRepository;
    @Autowired
    private SpecializationCourseRepository specializationCourseRepository;
    @Autowired
    private SecondMajorCourseRepository secondMajorCourseRepository;

    /**
     * Evaluate all bucket satisfaction for a student.
     * Recalculates progress for every bucket in their degree path.
     */
    public List<StudentBucketProgress> evaluateBuckets(Long studentId) {
        // 1. Get the student's degree path
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId)
                .orElseThrow(() -> new RuntimeException("Student has no assigned degree path. Please assign one first."));

        Long degreePathId = sdp.getDegreePath().getId();
        DegreePath degreePath = sdp.getDegreePath();

        // 2. Get all bucket requirements for this path
        List<PathBucketRequirement> requirements = pathBucketRequirementRepository.findByDegreePathId(degreePathId);

        if (requirements.isEmpty()) {
            throw new RuntimeException("No bucket requirements defined for degree path: " + degreePath.getPathCode());
        }

        // 3. Map completed courses to buckets
        Map<Long, BucketMappingEngine.BucketCreditsInfo> earnedMap = 
                bucketMappingEngine.mapStudentCoursesToBuckets(studentId, degreePathId);

        // 4. For each required bucket, calculate progress
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        List<StudentBucketProgress> progressList = new ArrayList<>();

        for (PathBucketRequirement req : requirements) {
            Long bucketId = req.getBucket().getId();

            int minCredits = (req.getMinCredits() != null) ? req.getMinCredits() : 0;
            Integer maxCredits = req.getMaxCredits();
            int requiredCredits = (minCredits > 0) ? minCredits : (req.getRequiredCredits() != null ? req.getRequiredCredits() : 0);
            int minCourses = (req.getMinCourses() != null) ? req.getMinCourses() : 0;
            Integer maxCourses = req.getMaxCourses();
            String groupingCode = req.getGroupingCode();

            // Completed courses for this bucket
            BucketMappingEngine.BucketCreditsInfo earned = earnedMap.get(bucketId);
            List<Map<String, Object>> completedCourses = (earned != null && earned.getCourses() != null)
                    ? new ArrayList<>(earned.getCourses())
                    : new ArrayList<>();

            // 4.1 Filter by grouping code if grouping requirement is specified
            completedCourses = filterCoursesByGrouping(completedCourses, groupingCode, degreePath, student);

            // 4.2 Mandatory course check
            List<String> missingMandatoryCourses = checkMissingMandatoryCourses(bucketId, degreePath, completedCourses);
            boolean mandatorySatisfied = missingMandatoryCourses.isEmpty();

            // 4.3 Course Count Limits (max_courses)
            int totalCompletedCourses = completedCourses.size();
            int rawEarnedCredits = completedCourses.stream()
                    .mapToInt(c -> ((Number) c.getOrDefault("credits", 0)).intValue())
                    .sum();

            List<Map<String, Object>> countedCourses;
            List<Map<String, Object>> excludedCourses;
            if (maxCourses != null && maxCourses > 0 && totalCompletedCourses > maxCourses) {
                countedCourses = new ArrayList<>(completedCourses.subList(0, maxCourses));
                excludedCourses = new ArrayList<>(completedCourses.subList(maxCourses, totalCompletedCourses));
            } else {
                countedCourses = completedCourses;
                excludedCourses = Collections.emptyList();
            }

            int countedCoursesCount = countedCourses.size();
            int eligibleCredits = countedCourses.stream()
                    .mapToInt(c -> ((Number) c.getOrDefault("credits", 0)).intValue())
                    .sum();

            // 4.4 Credit Limits (max_credits capping)
            int countedCredits = (maxCredits != null && maxCredits > 0)
                    ? Math.min(eligibleCredits, maxCredits)
                    : eligibleCredits;

            int excessCredits = Math.max(0, rawEarnedCredits - countedCredits);
            int remainingCredits = Math.max(0, requiredCredits - countedCredits);

            // 4.5 Completion Status Evaluation
            boolean creditsSatisfied = (countedCredits >= requiredCredits);
            boolean coursesSatisfied = (minCourses <= 0 || countedCoursesCount >= minCourses);
            boolean isCompleted = creditsSatisfied && coursesSatisfied && mandatorySatisfied;

            String status;
            if (isCompleted) {
                status = "COMPLETED";
            } else if (countedCredits > 0 || totalCompletedCourses > 0) {
                status = "IN_PROGRESS";
            } else {
                status = "PENDING";
            }

            // 4.6 Upsert student_bucket_progress
            StudentBucketProgress progress = studentBucketProgressRepository
                    .findByStudentIdAndBucketIdAndDegreePathId(studentId, bucketId, degreePathId)
                    .orElse(new StudentBucketProgress());

            progress.setStudent(student);
            progress.setBucket(req.getBucket());
            progress.setDegreePath(degreePath);
            progress.setRequiredCredits(requiredCredits);
            progress.setEarnedCredits(rawEarnedCredits);
            progress.setCountedCredits(countedCredits);
            progress.setExcessCredits(excessCredits);
            progress.setRemainingCredits(remainingCredits);
            progress.setMinCredits(minCredits);
            progress.setMaxCredits(maxCredits);
            progress.setCourseCount(totalCompletedCourses);
            progress.setCountedCourses(countedCoursesCount);
            progress.setMinCourses(minCourses);
            progress.setMaxCourses(maxCourses);
            progress.setMandatorySatisfied(mandatorySatisfied);
            progress.setStatus(status);
            progress.setLastCalculated(LocalDateTime.now());

            studentBucketProgressRepository.save(progress);
            progressList.add(progress);
        }

        return progressList;
    }

    /**
     * Get current stored bucket progress for a student.
     */
    public List<StudentBucketProgress> getStudentBucketProgress(Long studentId) {
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId).orElse(null);
        if (sdp == null) return Collections.emptyList();
        return studentBucketProgressRepository.findByStudentIdAndDegreePathId(studentId, sdp.getDegreePath().getId());
    }

    /**
     * Get detailed progress report per bucket including course lists, credit capping, and limits.
     */
    public List<Map<String, Object>> getDetailedBucketProgress(Long studentId) {
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId)
                .orElseThrow(() -> new RuntimeException("Student has no assigned degree path"));

        Long degreePathId = sdp.getDegreePath().getId();
        DegreePath degreePath = sdp.getDegreePath();

        // Get stored progress
        List<StudentBucketProgress> progressList = studentBucketProgressRepository
                .findByStudentIdAndDegreePathId(studentId, degreePathId);

        // Get earned course details
        Map<Long, BucketMappingEngine.BucketCreditsInfo> earnedMap =
                bucketMappingEngine.mapStudentCoursesToBuckets(studentId, degreePathId);

        // Requirements lookup map
        Map<Long, PathBucketRequirement> reqMap = new HashMap<>();
        pathBucketRequirementRepository.findByDegreePathId(degreePathId)
                .forEach(r -> reqMap.put(r.getBucket().getId(), r));

        List<Map<String, Object>> result = new ArrayList<>();

        for (StudentBucketProgress progress : progressList) {
            Long bucketId = progress.getBucket().getId();
            PathBucketRequirement req = reqMap.get(bucketId);

            Map<String, Object> bucketDetail = new LinkedHashMap<>();
            bucketDetail.put("bucketId", bucketId);
            bucketDetail.put("bucketCode", progress.getBucket().getBucketCode());
            bucketDetail.put("bucketName", progress.getBucket().getBucketName());
            bucketDetail.put("bucketCategory", progress.getBucket().getBucketCategory());
            
            // Credit metrics
            bucketDetail.put("requiredCredits", progress.getRequiredCredits());
            bucketDetail.put("minCredits", progress.getMinCredits() != null ? progress.getMinCredits() : progress.getRequiredCredits());
            bucketDetail.put("maxCredits", progress.getMaxCredits());
            bucketDetail.put("earnedCredits", progress.getEarnedCredits()); // Raw earned
            bucketDetail.put("countedCredits", progress.getCountedCredits() != null ? progress.getCountedCredits() : progress.getEarnedCredits()); // Capped
            bucketDetail.put("excessCredits", progress.getExcessCredits() != null ? progress.getExcessCredits() : 0);
            bucketDetail.put("remainingCredits", progress.getRemainingCredits() != null ? progress.getRemainingCredits() : Math.max(0, progress.getRequiredCredits() - progress.getEarnedCredits()));

            // Course count metrics
            bucketDetail.put("courseCount", progress.getCourseCount()); // Raw completed courses count
            bucketDetail.put("countedCourses", progress.getCountedCourses() != null ? progress.getCountedCourses() : progress.getCourseCount());
            bucketDetail.put("minCourses", progress.getMinCourses() != null ? progress.getMinCourses() : 0);
            bucketDetail.put("maxCourses", progress.getMaxCourses());
            int remainingCourses = Math.max(0, (progress.getMinCourses() != null ? progress.getMinCourses() : 0) - (progress.getCountedCourses() != null ? progress.getCountedCourses() : progress.getCourseCount()));
            bucketDetail.put("remainingCourses", remainingCourses);

            // Grouping and mandatory status
            bucketDetail.put("groupingCode", req != null ? req.getGroupingCode() : null);
            bucketDetail.put("mandatorySatisfied", progress.getMandatorySatisfied() != null ? progress.getMandatorySatisfied() : true);
            bucketDetail.put("status", progress.getStatus());
            bucketDetail.put("lastCalculated", progress.getLastCalculated());

            // Completion percentage for this bucket (counted credits vs required)
            int effectiveCounted = progress.getCountedCredits() != null ? progress.getCountedCredits() : progress.getEarnedCredits();
            double percentage = progress.getRequiredCredits() > 0
                    ? Math.min(100.0, (double) effectiveCounted / progress.getRequiredCredits() * 100.0)
                    : 100.0;
            bucketDetail.put("completionPercentage", Math.round(percentage * 100.0) / 100.0);

            // Split into counted courses vs excluded courses (courses over max_courses)
            BucketMappingEngine.BucketCreditsInfo earned = earnedMap.get(bucketId);
            List<Map<String, Object>> allCourses = (earned != null && earned.getCourses() != null)
                    ? new ArrayList<>(earned.getCourses())
                    : Collections.emptyList();

            Integer maxCourses = progress.getMaxCourses();
            List<Map<String, Object>> completedCourses;
            List<Map<String, Object>> excludedCourses;
            if (maxCourses != null && maxCourses > 0 && allCourses.size() > maxCourses) {
                completedCourses = allCourses.subList(0, maxCourses);
                excludedCourses = allCourses.subList(maxCourses, allCourses.size());
            } else {
                completedCourses = allCourses;
                excludedCourses = Collections.emptyList();
            }

            bucketDetail.put("completedCourses", completedCourses);
            bucketDetail.put("excludedCourses", excludedCourses);
            bucketDetail.put("excludedCoursesCount", excludedCourses.size());

            // Missing mandatory courses
            List<String> missingMandatory = checkMissingMandatoryCourses(bucketId, degreePath, allCourses);
            bucketDetail.put("missingMandatoryCourses", missingMandatory);

            // Add pending/available courses for this bucket
            if (!"COMPLETED".equals(progress.getStatus())) {
                List<Map<String, Object>> availableCourses = bucketMappingEngine
                        .getCoursesForBucket(bucketId, degreePathId);
                Set<String> completedCodes = allCourses.stream()
                        .map(c -> (String) c.get("courseCode"))
                        .collect(Collectors.toSet());
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

    // ==================== Private Helper Methods ====================

    private List<Map<String, Object>> filterCoursesByGrouping(List<Map<String, Object>> courses,
                                                             String groupingCode,
                                                             DegreePath degreePath,
                                                             Student student) {
        if (groupingCode == null || groupingCode.trim().isEmpty() || courses.isEmpty()) {
            return courses;
        }

        String code = groupingCode.trim().toUpperCase();
        Set<String> allowedCodes = new HashSet<>();

        if ("MINOR".equals(code)) {
            if (degreePath.getMinor() != null) {
                minorCourseRepository.findByMinorId(degreePath.getMinor().getId())
                        .forEach(mc -> {
                            if (mc.getCourse() != null && mc.getCourse().getCourseCode() != null) {
                                allowedCodes.add(mc.getCourse().getCourseCode());
                            }
                        });
            }
            if (allowedCodes.isEmpty()) return courses; // If no program courses mapped yet, keep courses
            return courses.stream().filter(c -> allowedCodes.contains(c.get("courseCode"))).collect(Collectors.toList());
        }

        if ("SPECIALIZATION".equals(code)) {
            if (degreePath.getSpecialization() != null) {
                specializationCourseRepository.findBySpecializationId(degreePath.getSpecialization().getId())
                        .forEach(sc -> {
                            if (sc.getCourse() != null && sc.getCourse().getCourseCode() != null) {
                                allowedCodes.add(sc.getCourse().getCourseCode());
                            }
                        });
            }
            if (allowedCodes.isEmpty()) return courses;
            return courses.stream().filter(c -> allowedCodes.contains(c.get("courseCode"))).collect(Collectors.toList());
        }

        if ("DOUBLE".equals(code) || "DOUBLE MAJOR".equals(code)) {
            if (degreePath.getSecondMajor() != null) {
                secondMajorCourseRepository.findBySecondMajorId(degreePath.getSecondMajor().getId())
                        .forEach(smc -> {
                            if (smc.getCourse() != null && smc.getCourse().getCourseCode() != null) {
                                allowedCodes.add(smc.getCourse().getCourseCode());
                            }
                        });
            }
            if (allowedCodes.isEmpty()) return courses;
            return courses.stream().filter(c -> allowedCodes.contains(c.get("courseCode"))).collect(Collectors.toList());
        }

        return courses;
    }

    private List<String> checkMissingMandatoryCourses(Long bucketId,
                                                      DegreePath degreePath,
                                                      List<Map<String, Object>> completedCourses) {
        if (degreePath.getCurriculumVersion() == null) {
            return Collections.emptyList();
        }

        List<CurriculumCourseMapping> mappings = curriculumCourseMappingRepository
                .findByVersionAndBucketAndPath(degreePath.getCurriculumVersion().getId(), bucketId, degreePath.getId());

        Set<String> completedCodes = completedCourses.stream()
                .map(c -> (String) c.get("courseCode"))
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        List<String> missing = new ArrayList<>();
        for (CurriculumCourseMapping ccm : mappings) {
            if (Boolean.TRUE.equals(ccm.getIsMandatory()) && ccm.getCurriculumCourse() != null && ccm.getCurriculumCourse().getCourse() != null) {
                String code = ccm.getCurriculumCourse().getCourse().getCourseCode();
                if (!completedCodes.contains(code)) {
                    missing.add(code);
                }
            }
        }

        return missing;
    }
}
