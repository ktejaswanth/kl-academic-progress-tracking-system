package com.example.demo;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.BucketMappingEngine;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class CrossCurriculumIsolationTest {

    @Autowired
    private BucketMappingEngine bucketMappingEngine;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private DegreePathRepository degreePathRepository;

    @Autowired
    private StudentCourseRepository studentCourseRepository;

    @Autowired
    private CurriculumCourseMappingRepository curriculumCourseMappingRepository;

    @Autowired
    private com.example.demo.service.Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    @org.junit.jupiter.api.BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();
    }

    @Test
    @DisplayName("Phase 18.1: Y23 CSE course MUST NOT satisfy Y23 AIDS requirement")
    public void testCseCourseCannotSatisfyAidsPath() {
        // 1. Create a dummy test student
        Student aidsStudent = new Student();
        aidsStudent.setStudentId("TEST_AIDS_STUDENT_99");
        aidsStudent.setEmail("aids99@test.com");
        aidsStudent.setPassword("hash");
        aidsStudent.setFirstName("AIDS");
        aidsStudent.setLastName("Student");
        aidsStudent.setDepartment("AIDS");
        aidsStudent = studentRepository.save(aidsStudent);

        // 2. Add a CSE-specific course to this student's completed courses
        // Note: 23CS2101 is a CSE course, not an AIDS course
        StudentCourse sc = new StudentCourse();
        sc.setStudent(aidsStudent);
        sc.setUniversityId(aidsStudent.getStudentId());
        sc.setCourseCode("23CS2101");
        sc.setCourseName("Design and Analysis of Algorithms");
        sc.setCredits(4.0);
        sc.setStatus("COMPLETED");
        studentCourseRepository.save(sc);

        // 3. Find an AIDS degree path
        DegreePath aidsPath = degreePathRepository.findAll().stream()
                .filter(p -> "AIDS-REGULAR".equals(p.getPathCode()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("AIDS-REGULAR path not found"));

        // 4. Map courses to buckets using BucketMappingEngine
        Map<Long, BucketMappingEngine.BucketCreditsInfo> earned =
                bucketMappingEngine.mapStudentCoursesToBuckets(aidsStudent.getId(), aidsPath.getId());

        // 5. Assert that 23CS2101 DID NOT map to any bucket for AIDS-REGULAR
        int totalCreditsEarned = earned.values().stream().mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits).sum();
        assertEquals(0, totalCreditsEarned,
                "Cross-curriculum violation: CSE course 23CS2101 should NOT contribute credits to AIDS-REGULAR path");
    }

    @Test
    @DisplayName("Phase 18.2: Y23 AIDS course MUST NOT satisfy Y23 CSE requirement")
    public void testAidsCourseCannotSatisfyCsePath() {
        // 1. Create a dummy test student
        Student cseStudent = new Student();
        cseStudent.setStudentId("TEST_CSE_STUDENT_99");
        cseStudent.setEmail("cse99@test.com");
        cseStudent.setPassword("hash");
        cseStudent.setFirstName("CSE");
        cseStudent.setLastName("Student");
        cseStudent.setDepartment("CSE");
        cseStudent = studentRepository.save(cseStudent);

        // 2. Add an AIDS-specific course to this student's completed courses
        // Note: 23AD2101 is an AIDS course
        StudentCourse sc = new StudentCourse();
        sc.setStudent(cseStudent);
        sc.setUniversityId(cseStudent.getStudentId());
        sc.setCourseCode("23AD2101");
        sc.setCourseName("Introduction to Data Science & AI");
        sc.setCredits(4.0);
        sc.setStatus("COMPLETED");
        studentCourseRepository.save(sc);

        // 3. Find a CSE degree path
        DegreePath csePath = degreePathRepository.findAll().stream()
                .filter(p -> "CSE-REGULAR".equals(p.getPathCode()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("CSE-REGULAR path not found"));

        // 4. Map courses to buckets using BucketMappingEngine
        Map<Long, BucketMappingEngine.BucketCreditsInfo> earned =
                bucketMappingEngine.mapStudentCoursesToBuckets(cseStudent.getId(), csePath.getId());

        // 5. Assert that 23AD2101 DID NOT map to any bucket for CSE-REGULAR
        int totalCreditsEarned = earned.values().stream().mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits).sum();
        assertEquals(0, totalCreditsEarned,
                "Cross-curriculum violation: AIDS course 23AD2101 should NOT contribute credits to CSE-REGULAR path");
    }
}
