package com.example.demo;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
public class Y23AidsDegreePathTest {

    @Autowired private Y23AidsCurriculumSeeder seeder;
    @Autowired private Y23AidsDataMigration migration;
    @Autowired private UserRepository userRepository;
    @Autowired private DegreePathRepository degreePathRepo;
    @Autowired private DegreeEligibilityEngine eligibilityEngine;
    @Autowired private BucketSatisfactionEngine bucketEngine;
    @Autowired private SpecializationProgressEngine specEngine;

    @BeforeEach
    public void setUp() {
        seeder.seedY23AidsCurriculum();
        migration.migrateY23AidsStudentData();
    }

    @Test
    @DisplayName("Test 1: Verify Y23 AIDS Seeding & Terminology Corrections")
    public void testAidsSeedingAndTerminology() {
        List<DegreePath> aidsPaths = degreePathRepo.findAll().stream()
                .filter(p -> p.getPathCode() != null && p.getPathCode().startsWith("AIDS-"))
                .toList();

        assertFalse(aidsPaths.isEmpty(), "AIDS Degree Paths should be created");

        // Verify correct terminology for HTE, HTI, HTR
        Optional<DegreePath> htePath = degreePathRepo.findByPathCode("AIDS-HTE");
        assertTrue(htePath.isPresent(), "AIDS-HTE path should exist");
        assertEquals("Honors through Experiential Learning", htePath.get().getDegreeType().getTypeName());

        Optional<DegreePath> htiPath = degreePathRepo.findByPathCode("AIDS-HTI");
        assertTrue(htiPath.isPresent(), "AIDS-HTI path should exist");
        assertEquals("Honors through Innovation", htiPath.get().getDegreeType().getTypeName());

        Optional<DegreePath> htrPath = degreePathRepo.findByPathCode("AIDS-HTR");
        assertTrue(htrPath.isPresent(), "AIDS-HTR path should exist");
        assertEquals("Honors through Research", htrPath.get().getDegreeType().getTypeName());
    }

    @Test
    @DisplayName("Test 2: Verify Student Progress Calculation for Y23 AIDS")
    public void testStudentProgressCalculation() {
        User student = userRepository.findByUsername("2100030001").orElse(null);
        assertNotNull(student, "Test student 2100030001 should exist");

        StudentDegreeStatus status = eligibilityEngine.evaluateEligibility(student.getId());
        assertNotNull(status);
        assertNotNull(status.getCompletionPercentage());
        assertFalse(status.getIsDegreeEligible(), "Student with partial credits should not be degree eligible yet");

        List<StudentBucketProgress> progressList = bucketEngine.getStudentBucketProgress(student.getId());
        assertFalse(progressList.isEmpty(), "Bucket progress should be generated");
    }

    @Test
    @DisplayName("Test 3: Verify Specialization Progress Calculation")
    public void testSpecializationProgress() {
        User student = userRepository.findByUsername("2100030001").orElse(null);
        assertNotNull(student);

        DegreePath specPath = degreePathRepo.findByPathCode("AIDS-REGULAR-SPECIALIZATION").orElse(null);
        assertNotNull(specPath);

        if (specPath.getSpecialization() != null) {
            Map<String, Object> specResult = specEngine.calculateSpecializationProgress(student.getId(), specPath.getSpecialization().getId());
            assertNotNull(specResult);
            assertTrue(specResult.containsKey("status"));
        }
    }
}
