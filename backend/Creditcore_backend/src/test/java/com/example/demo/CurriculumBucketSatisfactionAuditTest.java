package com.example.demo;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.BucketSatisfactionEngine;
import com.example.demo.service.DegreeEligibilityEngine;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class CurriculumBucketSatisfactionAuditTest {

    @Autowired private BucketSatisfactionEngine bucketSatisfactionEngine;
    @Autowired private DegreeEligibilityEngine degreeEligibilityEngine;
    @Autowired private StudentRepository studentRepository;
    @Autowired private DegreePathRepository degreePathRepository;
    @Autowired private StudentDegreePathRepository studentDegreePathRepository;
    @Autowired private BucketMasterRepository bucketMasterRepository;
    @Autowired private PathBucketRequirementRepository pathBucketRequirementRepository;
    @Autowired private StudentCourseRepository studentCourseRepository;
    @Autowired private CourseCatalogRepository courseCatalogRepository;
    @Autowired private CurriculumCourseRepository curriculumCourseRepository;
    @Autowired private CurriculumCourseMappingRepository curriculumCourseMappingRepository;
    @Autowired private CurriculumVersionRepository curriculumVersionRepository;
    @Autowired private DepartmentMasterRepository departmentMasterRepository;
    @Autowired private DegreeTypeMasterRepository degreeTypeMasterRepository;
    @Autowired private StudentBucketProgressRepository studentBucketProgressRepository;
    @Autowired private com.example.demo.service.Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    private Student testStudent;
    private DegreePath testPath;
    private CurriculumVersion testVersion;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();

        // Find or create test student
        testStudent = studentRepository.findByStudentId("TEST_AUDIT_STUDENT").orElseGet(() -> {
            Student s = new Student();
            s.setStudentId("TEST_AUDIT_STUDENT");
            s.setFirstName("Audit");
            s.setLastName("Student");
            s.setEmail("audit.student@example.com");
            s.setPassword("secret");
            s.setDepartment("CSE");
            return studentRepository.save(s);
        });

        // Use CSE-HTE-MINOR degree path
        testPath = degreePathRepository.findAll().stream()
                .filter(p -> "CSE-HTE-MINOR".equals(p.getPathCode()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("CSE-HTE-MINOR path must exist"));

        testVersion = testPath.getCurriculumVersion();

        // Assign degree path to student
        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(testStudent.getId())
                .orElse(new StudentDegreePath());
        sdp.setStudent(testStudent);
        sdp.setDegreePath(testPath);
        sdp.setIsConfirmed(true);
        studentDegreePathRepository.save(sdp);
    }

    @Test
    @DisplayName("Audit 1: Max Credit Capping - Excess credits must not inflate bucket counted credits")
    public void testMaxCreditCapping() {
        // Find a bucket with max_credits limit, e.g., HEC-CORE (min 8, max 16) or create specific requirement
        BucketMaster testBucket = bucketMasterRepository.findByBucketCode("HEC-CORE")
                .orElseGet(() -> {
                    BucketMaster b = new BucketMaster();
                    b.setBucketCode("HEC-CORE");
                    b.setBucketName("Humanities Elective Core");
                    return bucketMasterRepository.save(b);
                });

        PathBucketRequirement req = pathBucketRequirementRepository
                .findByDegreePathIdAndBucketId(testPath.getId(), testBucket.getId())
                .orElseGet(() -> {
                    PathBucketRequirement pbr = new PathBucketRequirement();
                    pbr.setDegreePath(testPath);
                    pbr.setBucket(testBucket);
                    pbr.setRequiredCredits(8);
                    pbr.setMinCredits(8);
                    pbr.setMaxCredits(16);
                    pbr.setMinCourses(2);
                    pbr.setMaxCourses(4);
                    return pathBucketRequirementRepository.save(pbr);
                });

        req.setMinCredits(8);
        req.setMaxCredits(16);
        req.setRequiredCredits(8);
        pathBucketRequirementRepository.save(req);

        // Add 5 completed courses of 4 credits each = 20 credits (exceeds max_credits of 16)
        for (int i = 1; i <= 5; i++) {
            String code = "HEC_TEST_0" + i;
            addCompletedCourse(testStudent, code, "HEC Course " + i, 4.0, testBucket);
        }

        List<StudentBucketProgress> progressList = bucketSatisfactionEngine.evaluateBuckets(testStudent.getId());

        StudentBucketProgress hecProgress = progressList.stream()
                .filter(p -> testBucket.getId().equals(p.getBucket().getId()))
                .findFirst()
                .orElseThrow();

        // Raw earned credits = 20
        assertEquals(20, hecProgress.getEarnedCredits(), "Raw earned credits should be 20");

        // Counted credits MUST be capped at 16 (or course cap max_courses * credits)
        assertTrue(hecProgress.getCountedCredits() <= 16, "Counted credits must not exceed max_credits (16), but was " + hecProgress.getCountedCredits());
        assertEquals(16, hecProgress.getCountedCredits(), "Counted credits should be capped at 16");

        // Excess credits should be 4
        assertEquals(4, hecProgress.getExcessCredits(), "Excess credits should be 20 - 16 = 4");

        // Status should be COMPLETED since counted (16) >= required (8)
        assertEquals("COMPLETED", hecProgress.getStatus());
    }

    @Test
    @DisplayName("Audit 2: Course Count Limits - 5th course excluded when max_courses is 4")
    public void testMaxCourseLimitExclusion() {
        BucketMaster testBucket = bucketMasterRepository.findByBucketCode("SDP-1")
                .orElseGet(() -> {
                    BucketMaster b = new BucketMaster();
                    b.setBucketCode("SDP-1");
                    b.setBucketName("Skill Development Project 1");
                    return bucketMasterRepository.save(b);
                });

        PathBucketRequirement req = pathBucketRequirementRepository
                .findByDegreePathIdAndBucketId(testPath.getId(), testBucket.getId())
                .orElseGet(() -> {
                    PathBucketRequirement pbr = new PathBucketRequirement();
                    pbr.setDegreePath(testPath);
                    pbr.setBucket(testBucket);
                    pbr.setRequiredCredits(2);
                    pbr.setMinCredits(2);
                    pbr.setMaxCredits(4);
                    pbr.setMinCourses(1);
                    pbr.setMaxCourses(1);
                    return pathBucketRequirementRepository.save(pbr);
                });

        req.setMaxCourses(1);
        req.setMaxCredits(4);
        pathBucketRequirementRepository.save(req);

        // Add 2 completed courses (exceeding max_courses = 1)
        addCompletedCourse(testStudent, "SDP1_A", "SDP Course A", 2.0, testBucket);
        addCompletedCourse(testStudent, "SDP1_B", "SDP Course B", 2.0, testBucket);

        List<StudentBucketProgress> progressList = bucketSatisfactionEngine.evaluateBuckets(testStudent.getId());

        StudentBucketProgress sdpProgress = progressList.stream()
                .filter(p -> testBucket.getId().equals(p.getBucket().getId()))
                .findFirst()
                .orElseThrow();

        // Total courses completed = 2
        assertEquals(2, sdpProgress.getCourseCount());
        // Counted courses capped at max_courses = 1
        assertEquals(1, sdpProgress.getCountedCourses(), "Counted courses must not exceed max_courses (1)");

        // Detailed progress should list 1 excluded course
        List<Map<String, Object>> details = bucketSatisfactionEngine.getDetailedBucketProgress(testStudent.getId());
        Map<String, Object> sdpDetail = details.stream()
                .filter(d -> testBucket.getId().equals(d.get("bucketId")))
                .findFirst()
                .orElseThrow();

        assertEquals(1, sdpDetail.get("excludedCoursesCount"));
    }

    @Test
    @DisplayName("Audit 3: Min Course Count Enforcement - Bucket with 0 credits and min 1 course is NOT complete with 0 courses")
    public void testMinCourseCountEnforcement() {
        BucketMaster vacBucket = bucketMasterRepository.findByBucketCode("VAC-SPORTS")
                .orElseGet(() -> {
                    BucketMaster b = new BucketMaster();
                    b.setBucketCode("VAC-SPORTS");
                    b.setBucketName("Sports and Games");
                    return bucketMasterRepository.save(b);
                });

        PathBucketRequirement req = pathBucketRequirementRepository
                .findByDegreePathIdAndBucketId(testPath.getId(), vacBucket.getId())
                .orElseGet(() -> {
                    PathBucketRequirement pbr = new PathBucketRequirement();
                    pbr.setDegreePath(testPath);
                    pbr.setBucket(vacBucket);
                    pbr.setRequiredCredits(0);
                    pbr.setMinCredits(0);
                    pbr.setMaxCredits(0);
                    pbr.setMinCourses(1);
                    pbr.setMaxCourses(1);
                    return pathBucketRequirementRepository.save(pbr);
                });

        req.setMinCredits(0);
        req.setMinCourses(1);
        pathBucketRequirementRepository.save(req);

        // 0 courses completed -> MUST be PENDING, not COMPLETED despite 0 >= 0 credits
        List<StudentBucketProgress> progressList = bucketSatisfactionEngine.evaluateBuckets(testStudent.getId());

        StudentBucketProgress vacProgress = progressList.stream()
                .filter(p -> vacBucket.getId().equals(p.getBucket().getId()))
                .findFirst()
                .orElseThrow();

        assertEquals("PENDING", vacProgress.getStatus(), "Bucket requiring 1 course must be PENDING when 0 courses completed");

        // Now complete 1 course of 0 credits
        addCompletedCourse(testStudent, "VAC_SPORT_01", "Athletics", 0.0, vacBucket);

        progressList = bucketSatisfactionEngine.evaluateBuckets(testStudent.getId());
        vacProgress = progressList.stream()
                .filter(p -> vacBucket.getId().equals(p.getBucket().getId()))
                .findFirst()
                .orElseThrow();

        assertEquals("COMPLETED", vacProgress.getStatus(), "Bucket should be COMPLETED after completing 1 course");
    }

    @Test
    @DisplayName("Audit 4: Degree Eligibility - Capped credits prevent degree eligibility when other buckets are incomplete")
    public void testDegreeEligibilityIntegrity() {
        StudentDegreeStatus status = degreeEligibilityEngine.evaluateEligibility(testStudent.getId());
        assertFalse(status.getIsDegreeEligible(), "Student without completing all buckets must not be eligible");

        // Verify total required credits equals degree path credits (203 for CSE-HTE-MINOR)
        assertEquals(testPath.getTotalCredits(), status.getTotalRequiredCredits());
    }

    // ==================== Helper ====================

    private void addCompletedCourse(Student student, String code, String name, double credits, BucketMaster bucket) {
        CourseCatalog catalog = courseCatalogRepository.findByCourseCode(code).orElseGet(() -> {
            CourseCatalog cc = new CourseCatalog();
            cc.setCourseCode(code);
            cc.setCourseName(name);
            cc.setCredits((int) credits);
            return courseCatalogRepository.save(cc);
        });

        CurriculumCourse currCourse = curriculumCourseRepository
                .findByCurriculumVersionIdAndCourseCourseCode(testVersion.getId(), code)
                .orElseGet(() -> {
                    CurriculumCourse c = new CurriculumCourse();
                    c.setCurriculumVersion(testVersion);
                    c.setCourse(catalog);
                    c.setCourseName(name);
                    c.setCredits(credits);
                    return curriculumCourseRepository.save(c);
                });

        CurriculumCourseMapping mapping = new CurriculumCourseMapping();
        mapping.setCurriculumVersion(testVersion);
        mapping.setCurriculumCourse(currCourse);
        mapping.setBucket(bucket);
        mapping.setDegreePath(testPath);
        mapping.setIsMandatory(false);
        curriculumCourseMappingRepository.save(mapping);

        StudentCourse sc = new StudentCourse();
        sc.setStudent(student);
        sc.setUniversityId(student.getStudentId());
        sc.setCurriculumVersion(testVersion);
        sc.setCourse(catalog);
        sc.setCurriculumCourse(currCourse);
        sc.setCourseCode(code);
        sc.setCourseName(name);
        sc.setCredits(credits);
        sc.setGrade("O");
        sc.setStatus("COMPLETED");
        studentCourseRepository.save(sc);
    }
}
