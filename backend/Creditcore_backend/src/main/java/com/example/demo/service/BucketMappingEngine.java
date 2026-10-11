package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Bucket Mapping Engine (Curriculum-Aware & Version-Isolated)
 *
 * Maps a student's completed courses to DYOD buckets strictly within the student's assigned curriculum version.
 *
 * Algorithm:
 *   1. Resolve student's assigned DegreePath and CurriculumVersion.
 *   2. Fetch student's completed courses from StudentCourseRepository (or CompletedCourseRepository fallback).
 *   3. For each completed course, lookup mappings in curriculum_course_mapping for (curriculumVersionId, courseCode, degreePathId).
 *   4. If no curriculum-version mapping exists, the course does NOT satisfy any bucket for this degree path.
 *   5. Group and aggregate earned credits per bucket.
 */
@Service
@Transactional(readOnly = true)
public class BucketMappingEngine {

    @Autowired
    private StudentCourseRepository studentCourseRepository;
    @Autowired
    private CompletedCourseRepository completedCourseRepository;
    @Autowired
    private CurriculumCourseMappingRepository curriculumCourseMappingRepository;
    @Autowired
    private DegreePathRepository degreePathRepository;
    @Autowired
    private CourseCatalogRepository courseCatalogRepository;
    @Autowired
    private BucketMasterRepository bucketMasterRepository;
    @Autowired
    private ProgramCourseEquivalenceRepository programCourseEquivalenceRepository;

    /**
     * Map all completed courses for a student to their respective buckets under their assigned degree path.
     * Returns a map of bucketId -> BucketCreditsInfo.
     */
    public Map<Long, BucketCreditsInfo> mapStudentCoursesToBuckets(Long studentId, Long degreePathId) {
        DegreePath degreePath = degreePathRepository.findById(degreePathId).orElse(null);
        Long curriculumVersionId = (degreePath != null && degreePath.getCurriculumVersion() != null)
                ? degreePath.getCurriculumVersion().getId()
                : null;

        // Fetch completed courses from StudentCourse table
        List<StudentCourse> studentCourses = studentCourseRepository.findByStudentIdAndStatus(studentId, "COMPLETED");
        
        // Also fetch legacy CompletedCourse if studentCourses is empty
        Map<String, CourseCompletionInfo> courseCompletions = new LinkedHashMap<>();
        for (StudentCourse sc : studentCourses) {
            courseCompletions.put(sc.getCourseCode(), new CourseCompletionInfo(
                    sc.getCourseCode(),
                    sc.getCourseName(),
                    sc.getCredits() != null ? sc.getCredits().intValue() : 0,
                    sc.getGrade()
            ));
        }

        if (courseCompletions.isEmpty()) {
            List<CompletedCourse> rawCompleted = completedCourseRepository.findByStudentId(studentId);
            for (CompletedCourse cc : rawCompleted) {
                if (cc.getStatus() == null || !cc.getStatus().equalsIgnoreCase("On-Progress")) {
                    courseCompletions.put(cc.getCourseCode(), new CourseCompletionInfo(
                            cc.getCourseCode(),
                            cc.getCourseName(),
                            cc.getCredits(),
                            cc.getGrade()
                    ));
                }
            }
        }

        Map<Long, BucketCreditsInfo> bucketCredits = new HashMap<>();

        for (CourseCompletionInfo completed : courseCompletions.values()) {
            List<CurriculumCourseMapping> mappings;
            if (curriculumVersionId != null) {
                mappings = curriculumCourseMappingRepository
                        .findByVersionAndCourseCodeAndPathOrUniversal(curriculumVersionId, completed.getCourseCode(), degreePathId);
            } else {
                mappings = curriculumCourseMappingRepository
                        .findByCourseCodeAndPathOrUniversal(completed.getCourseCode(), degreePathId);
            }

            // If not found in native curriculum, check for explicitly approved cross-program course equivalence
            if (mappings.isEmpty() && curriculumVersionId != null) {
                List<ProgramCourseEquivalence> approvedEquivalences = programCourseEquivalenceRepository
                        .findApprovedEquivalencesForTarget(curriculumVersionId, completed.getCourseCode());
                for (ProgramCourseEquivalence pce : approvedEquivalences) {
                    List<CurriculumCourseMapping> equivMappings = curriculumCourseMappingRepository
                            .findByVersionAndCourseCodeAndPathOrUniversal(curriculumVersionId, pce.getTargetCourseCode(), degreePathId);
                    if (!equivMappings.isEmpty()) {
                        mappings = equivMappings;
                        break;
                    }
                }
            }

            if (mappings.isEmpty()) {
                // Cross-curriculum isolation: course not mapped to this curriculum version -> skipped
                continue;
            }

            // Prefer degree path-specific mapping over universal version mapping
            CurriculumCourseMapping bestMapping = mappings.stream()
                    .filter(m -> m.getDegreePath() != null && m.getDegreePath().getId().equals(degreePathId))
                    .findFirst()
                    .orElse(mappings.get(0));

            Long bucketId = bestMapping.getBucket().getId();
            int credits = completed.getCredits() > 0 ? completed.getCredits() : 
                    (bestMapping.getCurriculumCourse() != null && bestMapping.getCurriculumCourse().getCredits() != null 
                            ? bestMapping.getCurriculumCourse().getCredits().intValue() : 0);

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
        DegreePath degreePath = degreePathRepository.findById(degreePathId).orElse(null);
        Long curriculumVersionId = (degreePath != null && degreePath.getCurriculumVersion() != null)
                ? degreePath.getCurriculumVersion().getId()
                : null;

        List<CurriculumCourseMapping> mappings;
        if (curriculumVersionId != null) {
            mappings = curriculumCourseMappingRepository
                    .findByVersionAndBucketAndPath(curriculumVersionId, bucketId, degreePathId);
        } else {
            mappings = Collections.emptyList();
        }

        return mappings.stream().map(m -> {
            Map<String, Object> courseInfo = new LinkedHashMap<>();
            courseInfo.put("courseId", m.getCurriculumCourse().getCourse().getId());
            courseInfo.put("courseCode", m.getCurriculumCourse().getCourse().getCourseCode());
            courseInfo.put("courseName", m.getCurriculumCourse().getCourseName() != null 
                    ? m.getCurriculumCourse().getCourseName() 
                    : m.getCurriculumCourse().getCourse().getCourseName());
            courseInfo.put("credits", m.getCurriculumCourse().getCredits());
            courseInfo.put("isMandatory", m.getIsMandatory());
            courseInfo.put("semesterOffered", m.getSemesterOffered());
            return courseInfo;
        }).collect(Collectors.toList());
    }

    /**
     * Resolve which bucket a specific course code maps to for a given degree path.
     */
    public Optional<BucketMaster> resolveBucket(String courseCode, Long degreePathId) {
        DegreePath degreePath = degreePathRepository.findById(degreePathId).orElse(null);
        Long curriculumVersionId = (degreePath != null && degreePath.getCurriculumVersion() != null)
                ? degreePath.getCurriculumVersion().getId()
                : null;

        List<CurriculumCourseMapping> mappings;
        if (curriculumVersionId != null) {
            mappings = curriculumCourseMappingRepository
                    .findByVersionAndCourseCodeAndPathOrUniversal(curriculumVersionId, courseCode, degreePathId);
        } else {
            mappings = curriculumCourseMappingRepository
                    .findByCourseCodeAndPathOrUniversal(courseCode, degreePathId);
        }

        if (mappings.isEmpty()) {
            return Optional.empty();
        }

        CurriculumCourseMapping best = mappings.stream()
                .filter(m -> m.getDegreePath() != null && m.getDegreePath().getId().equals(degreePathId))
                .findFirst()
                .orElse(mappings.get(0));

        return Optional.of(best.getBucket());
    }

    // ==================== Inner classes ====================

    private static class CourseCompletionInfo {
        private final String courseCode;
        private final String courseName;
        private final int credits;
        private final String grade;

        public CourseCompletionInfo(String courseCode, String courseName, int credits, String grade) {
            this.courseCode = courseCode;
            this.courseName = courseName;
            this.credits = credits;
            this.grade = grade;
        }

        public String getCourseCode() { return courseCode; }
        public String getCourseName() { return courseName; }
        public int getCredits() { return credits; }
        public String getGrade() { return grade; }
    }

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
