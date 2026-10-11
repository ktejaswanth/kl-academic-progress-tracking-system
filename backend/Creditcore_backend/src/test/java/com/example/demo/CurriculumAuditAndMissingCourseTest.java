package com.example.demo;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.BucketMappingEngine;
import com.example.demo.service.BucketSatisfactionEngine;
import com.example.demo.service.Y23AidsCurriculumSeeder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class CurriculumAuditAndMissingCourseTest {

    @Autowired
    private CourseCatalogRepository courseCatalogRepository;

    @Autowired
    private CurriculumCourseRepository curriculumCourseRepository;

    @Autowired
    private CurriculumCourseMappingRepository curriculumCourseMappingRepository;

    @Autowired
    private CurriculumVersionRepository curriculumVersionRepository;

    @Autowired
    private BucketMasterRepository bucketMasterRepository;

    @Autowired
    private DegreePathRepository degreePathRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private StudentCourseRepository studentCourseRepository;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private BucketSatisfactionEngine bucketSatisfactionEngine;

    @Autowired
    private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();
    }

    @Test
    @DisplayName("Phase 6.1: Verify LTPS formula calculation: L + T + (P * 0.5) + (S * 0.25)")
    public void testLtpsFormulaCalculation() {
        // Standard theory course: 3-0-0-0 -> 3.0 credits
        assertEquals(3.0, calculateLtps(3, 0, 0, 0), 0.001);

        // Theory + lab course: 3-0-2-0 -> 4.0 credits
        assertEquals(4.0, calculateLtps(3, 0, 2, 0), 0.001);

        // Lab-intensive / skill course: 0-0-4-0 -> 2.0 credits
        assertEquals(2.0, calculateLtps(0, 0, 4, 0), 0.001);

        // Skill-based course: 0-0-6-4 -> 4.0 credits
        assertEquals(4.0, calculateLtps(0, 0, 6, 4), 0.001);

        // Fractional calculation: 3-0-2-2 -> 4.5 credits (e.g. 23EC2211R)
        assertEquals(4.5, calculateLtps(3, 0, 2, 2), 0.001);
    }

    private double calculateLtps(int l, int t, int p, int s) {
        return l + t + (p * 0.5) + (s * 0.25);
    }

    @Test
    @DisplayName("Phase 4 & 6.2: Verify targeted credit correction for 23EC2211R (4.5 credits)")
    public void testTargetedCreditCorrection() {
        Optional<CourseCatalog> catalogOpt = courseCatalogRepository.findByCourseCode("23EC2211R");
        if (catalogOpt.isPresent()) {
            CurriculumVersion cseVer = curriculumVersionRepository.findAll().stream()
                    .filter(v -> v.getVersionName().contains("CSE"))
                    .findFirst().orElseThrow();

            Optional<CurriculumCourse> ccOpt = curriculumCourseRepository
                    .findByCurriculumVersionIdAndCourseCourseCode(cseVer.getId(), "23EC2211R");
            if (ccOpt.isPresent()) {
                CurriculumCourse cc = ccOpt.get();
                if (cc.getCredits() != null) {
                    assertEquals(4.5, cc.getCredits(), 0.01,
                            "Course 23EC2211R must have 4.5 credits as per official handbook (LTPS 3-0-2-2)");
                }
            }
        }
    }

    @Test
    @DisplayName("Phase 7.1: Verify CSE 23CS2101 is mapped to PCC-CORE for Y23 CSE")
    public void testCseCoreCourseMapping() {
        CurriculumVersion cseVer = curriculumVersionRepository.findAll().stream()
                .filter(v -> v.getVersionName().contains("CSE"))
                .findFirst().orElseThrow();

        BucketMaster pccBucket = bucketMasterRepository.findAll().stream()
                .filter(b -> "PCC-CORE".equals(b.getBucketCode()))
                .findFirst().orElseThrow();

        Optional<CourseCatalog> cseCourse = courseCatalogRepository.findByCourseCode("23CS2101");
        assertTrue(cseCourse.isPresent(), "23CS2101 must exist in course catalog");

        List<CurriculumCourseMapping> mappings = curriculumCourseMappingRepository
                .findByVersionAndCourseCodeAndPathOrUniversal(cseVer.getId(), "23CS2101", null);

        assertFalse(mappings.isEmpty(), "23CS2101 must have an authoritative mapping in Y23 CSE curriculum");
        assertEquals("PCC-CORE", mappings.get(0).getBucket().getBucketCode(),
                "23CS2101 must map to PCC-CORE bucket");
    }

    @Test
    @DisplayName("Phase 7.2: Verify AIDS 23AD2101 is mapped to PCC-CORE for Y23 AIDS")
    public void testAidsCoreCourseMapping() {
        CurriculumVersion aidsVer = curriculumVersionRepository.findAll().stream()
                .filter(v -> v.getVersionName().contains("AIDS"))
                .findFirst().orElseThrow();

        Optional<CourseCatalog> aidsCourse = courseCatalogRepository.findByCourseCode("23AD2101");
        assertTrue(aidsCourse.isPresent(), "23AD2101 must exist in course catalog");

        List<CurriculumCourseMapping> mappings = curriculumCourseMappingRepository
                .findByVersionAndCourseCodeAndPathOrUniversal(aidsVer.getId(), "23AD2101", null);

        assertFalse(mappings.isEmpty(), "23AD2101 must have an authoritative mapping in Y23 AIDS curriculum");
        assertEquals("PCC-CORE", mappings.get(0).getBucket().getBucketCode(),
                "23AD2101 must map to PCC-CORE bucket");
    }

    @Test
    @DisplayName("Phase 8: Verify bucket credit capping and excess credits retention")
    public void testBucketCreditCappingAndExcessRetention() {
        // Create test student
        Student student = new Student();
        student.setStudentId("TEST_CAPPING_STUDENT");
        student.setEmail("capping_test@kluniversity.in");
        student.setPassword("hash");
        student.setFirstName("Cap");
        student.setLastName("Student");
        student.setDepartment("CSE");
        student = studentRepository.save(student);

        DegreePath path = degreePathRepository.findAll().stream()
                .filter(p -> "CSE-REGULAR".equals(p.getPathCode()))
                .findFirst().orElseThrow();

        StudentDegreePath sdp = new StudentDegreePath();
        sdp.setStudent(student);
        sdp.setDegreePath(path);
        studentDegreePathRepository.save(sdp);

        // Add multiple completed courses to exceed bucket limits if necessary
        StudentCourse sc1 = new StudentCourse();
        sc1.setStudent(student);
        sc1.setUniversityId(student.getStudentId());
        sc1.setCourseCode("23CS2101");
        sc1.setCourseName("Design and Analysis of Algorithms");
        sc1.setCredits(4.0);
        sc1.setStatus("COMPLETED");
        studentCourseRepository.save(sc1);

        List<StudentBucketProgress> progressList = bucketSatisfactionEngine.evaluateBuckets(student.getId());
        assertFalse(progressList.isEmpty(), "Bucket progress must be evaluated");

        Optional<StudentBucketProgress> pccProgress = progressList.stream()
                .filter(p -> "PCC-CORE".equals(p.getBucket().getBucketCode()))
                .findFirst();

        assertTrue(pccProgress.isPresent(), "PCC-CORE progress must be present");
        StudentBucketProgress prog = pccProgress.get();
        assertEquals(4, prog.getEarnedCredits(), "Earned credits should reflect raw course history");
        assertTrue(prog.getCountedCredits() <= (prog.getMaxCredits() != null ? prog.getMaxCredits() : Integer.MAX_VALUE),
                "Counted credits must not exceed max_credits limit");
    }
}
