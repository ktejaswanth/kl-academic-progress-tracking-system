package com.example.demo;

import com.example.demo.model.DegreePath;
import com.example.demo.model.PathBucketRequirement;
import com.example.demo.repository.DegreePathRepository;
import com.example.demo.repository.PathBucketRequirementRepository;
import com.example.demo.service.Y23AidsCurriculumSeeder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
public class Y23PathBucketRequirementsTest {

    @Autowired
    private DegreePathRepository degreePathRepository;

    @Autowired
    private PathBucketRequirementRepository pathBucketRequirementRepository;

    @Autowired
    private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    @BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();
    }

    @Test
    @DisplayName("Verify that all 40 degree paths have per-bucket requirements seeded")
    public void testAllPathsHaveRequirements() {
        List<DegreePath> allPaths = degreePathRepository.findAll();
        assertFalse(allPaths.isEmpty(), "Degree paths should not be empty");

        for (DegreePath path : allPaths) {
            List<PathBucketRequirement> reqs = pathBucketRequirementRepository.findByDegreePathId(path.getId());
            assertFalse(reqs.isEmpty(), "Degree path " + path.getPathCode() + " must have bucket requirements");
            assertTrue(reqs.size() >= 20, "Degree path " + path.getPathCode() + " should have at least 20 per-bucket requirements but got " + reqs.size());

            // Verify each requirement has a valid bucket and non-null required credits
            for (PathBucketRequirement pbr : reqs) {
                assertNotNull(pbr.getBucket(), "Bucket should not be null for path requirement in " + path.getPathCode());
                assertNotNull(pbr.getRequiredCredits(), "Required credits should not be null for " + pbr.getBucket().getBucketCode());
                assertTrue(pbr.getRequiredCredits() >= 0, "Required credits must be non-negative");
            }
        }
    }

    @Test
    @DisplayName("Verify CSE-REGULAR bucket requirements breakdown")
    public void testCseRegularBucketBreakdown() {
        DegreePath path = degreePathRepository.findAll().stream()
                .filter(p -> "CSE-REGULAR".equals(p.getPathCode()) && p.getDepartment() != null && "CSE".equals(p.getDepartment().getDeptCode()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("CSE-REGULAR path not found"));

        List<PathBucketRequirement> reqs = pathBucketRequirementRepository.findByDegreePathId(path.getId());
        assertFalse(reqs.isEmpty());

        int totalMinCredits = reqs.stream().mapToInt(PathBucketRequirement::getMinCredits).sum();
        assertEquals(163, totalMinCredits, "CSE-REGULAR min_credits sum must equal 163");
    }

    @Test
    @DisplayName("Verify AIDS-REGULAR bucket requirements breakdown")
    public void testAidsRegularBucketBreakdown() {
        DegreePath path = degreePathRepository.findAll().stream()
                .filter(p -> "AIDS-REGULAR".equals(p.getPathCode()) && p.getDepartment() != null && "AIDS".equals(p.getDepartment().getDeptCode()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("AIDS-REGULAR path not found"));

        List<PathBucketRequirement> reqs = pathBucketRequirementRepository.findByDegreePathId(path.getId());
        assertFalse(reqs.isEmpty());

        int totalMinCredits = reqs.stream().mapToInt(PathBucketRequirement::getMinCredits).sum();
        assertEquals(166, totalMinCredits, "AIDS-REGULAR min_credits sum must equal 166");
    }
}
