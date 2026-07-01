package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Bucket Mapping Engine
 *
 * Maps a student's completed courses to DYOD buckets and calculates earned credits per bucket.
 *
 * Algorithm:
 *   For each CompletedCourse:
 *     1. Find course in course_catalog by course_code
 *     2. Find course_bucket_mapping entries (path-specific or universal)
 *     3. Group credits by bucket_id
 *     4. Return Map<BucketId, BucketCreditsInfo>
 */
@Service
@Transactional(readOnly = true)
public class BucketMappingEngine {

    @Autowired
    private CompletedCourseRepository completedCourseRepository;
    @Autowired
    private CourseBucketMappingRepository courseBucketMappingRepository;
    @Autowired
    private CourseCatalogRepository courseCatalogRepository;
    @Autowired
    private BucketMasterRepository bucketMasterRepository;

    /**
     * Map all completed courses for a student to their respective buckets.
     * Returns a map of bucketId -> {earnedCredits, courseCount, courseList}.
     */
    public Map<Long, BucketCreditsInfo> mapStudentCoursesToBuckets(Long studentId, Long degreePathId) {
        List<CompletedCourse> completedCourses = completedCourseRepository.findByStudentId(studentId);
        Map<Long, BucketCreditsInfo> bucketCredits = new HashMap<>();

        for (CompletedCourse completed : completedCourses) {
            // Find the course in the catalog
            Optional<CourseCatalog> catalogOpt = courseCatalogRepository.findByCourseCode(completed.getCourseCode());

            if (catalogOpt.isEmpty()) {
                // Course not in catalog — skip (or log warning)
                continue;
            }

            CourseCatalog catalog = catalogOpt.get();

            // Find bucket mapping for this course (path-specific or universal)
            List<CourseBucketMapping> mappings = courseBucketMappingRepository
                    .findByCourseCodeAndPathOrUniversal(completed.getCourseCode(), degreePathId);

            if (mappings.isEmpty()) {
                // No bucket mapping — this course doesn't contribute to any bucket
                continue;
            }

            // A course can map to multiple buckets (rare but possible)
            // We take the first path-specific mapping, or fall back to universal
            CourseBucketMapping bestMapping = mappings.stream()
                    .filter(m -> m.getDegreePath() != null && m.getDegreePath().getId().equals(degreePathId))
                    .findFirst()
                    .orElse(mappings.get(0));

            Long bucketId = bestMapping.getBucket().getId();
            int credits = catalog.getCredits();

            bucketCredits.computeIfAbsent(bucketId, k -> new BucketCreditsInfo(
                    bucketId,
                    bestMapping.getBucket().getBucketCode(),
                    bestMapping.getBucket().getBucketName()
            ));

            BucketCreditsInfo info = bucketCredits.get(bucketId);
            info.addCredits(credits);
            info.addCourse(completed.getCourseCode(), completed.getCourseName(), credits, completed.getGrade());
        }

        return bucketCredits;
    }

    /**
     * Get all courses mapped to a specific bucket for a degree path.
     */
    public List<Map<String, Object>> getCoursesForBucket(Long bucketId, Long degreePathId) {
        List<CourseBucketMapping> mappings = courseBucketMappingRepository
                .findByBucketIdAndPathOrUniversal(bucketId, degreePathId);

        return mappings.stream().map(m -> {
            Map<String, Object> courseInfo = new LinkedHashMap<>();
            courseInfo.put("courseId", m.getCourse().getId());
            courseInfo.put("courseCode", m.getCourse().getCourseCode());
            courseInfo.put("courseName", m.getCourse().getCourseName());
            courseInfo.put("credits", m.getCourse().getCredits());
            courseInfo.put("isMandatory", m.getIsMandatory());
            courseInfo.put("semesterOffered", m.getSemesterOffered());
            return courseInfo;
        }).collect(Collectors.toList());
    }

    /**
     * Resolve which bucket a specific course code maps to for a given degree path.
     */
    public Optional<BucketMaster> resolveBucket(String courseCode, Long degreePathId) {
        List<CourseBucketMapping> mappings = courseBucketMappingRepository
                .findByCourseCodeAndPathOrUniversal(courseCode, degreePathId);

        if (mappings.isEmpty()) {
            return Optional.empty();
        }

        // Prefer path-specific mapping
        CourseBucketMapping best = mappings.stream()
                .filter(m -> m.getDegreePath() != null && m.getDegreePath().getId().equals(degreePathId))
                .findFirst()
                .orElse(mappings.get(0));

        return Optional.of(best.getBucket());
    }

    // ==================== Inner class for bucket credits ====================

    public static class BucketCreditsInfo {
        private Long bucketId;
        private String bucketCode;
        private String bucketName;
        private int earnedCredits;
        private int courseCount;
        private List<Map<String, Object>> courses;

        public BucketCreditsInfo(Long bucketId, String bucketCode, String bucketName) {
            this.bucketId = bucketId;
            this.bucketCode = bucketCode;
            this.bucketName = bucketName;
            this.earnedCredits = 0;
            this.courseCount = 0;
            this.courses = new ArrayList<>();
        }

        public void addCredits(int credits) {
            this.earnedCredits += credits;
            this.courseCount++;
        }

        public void addCourse(String code, String name, int credits, String grade) {
            Map<String, Object> course = new LinkedHashMap<>();
            course.put("courseCode", code);
            course.put("courseName", name);
            course.put("credits", credits);
            course.put("grade", grade);
            this.courses.add(course);
        }

        public Long getBucketId() { return bucketId; }
        public String getBucketCode() { return bucketCode; }
        public String getBucketName() { return bucketName; }
        public int getEarnedCredits() { return earnedCredits; }
        public int getCourseCount() { return courseCount; }
        public List<Map<String, Object>> getCourses() { return courses; }

        public Map<String, Object> toMap() {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("bucketId", bucketId);
            map.put("bucketCode", bucketCode);
            map.put("bucketName", bucketName);
            map.put("earnedCredits", earnedCredits);
            map.put("courseCount", courseCount);
            map.put("courses", courses);
            return map;
        }
    }
}
