package com.example.demo;

import com.example.demo.model.DegreePath;
import com.example.demo.repository.DegreePathRepository;
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
public class Y23CreditTotalsValidationTest {

    @Autowired
    private DegreePathRepository degreePathRepository;

    @Autowired
    private com.example.demo.service.Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;

    @org.junit.jupiter.api.BeforeEach
    public void setup() {
        y23AidsCurriculumSeeder.seedY23AidsCurriculum();
    }

    private static final Map<String, Integer> EXPECTED_CSE_TOTALS = Map.ofEntries(
            Map.entry("CSE-HTE-MINOR", 203),
            Map.entry("CSE-HTE-DOUBLE_MAJOR", 208),
            Map.entry("CSE-HTE-SPECIALIZATION", 193),
            Map.entry("CSE-HTE", 183),
            Map.entry("CSE-HTI-MINOR", 201),
            Map.entry("CSE-HTI-DOUBLE_MAJOR", 208),
            Map.entry("CSE-HTI-SPECIALIZATION", 193),
            Map.entry("CSE-HTI", 183),
            Map.entry("CSE-HTR-MINOR", 201),
            Map.entry("CSE-HTR-DOUBLE_MAJOR", 208),
            Map.entry("CSE-HTR-SPECIALIZATION", 193),
            Map.entry("CSE-HTR", 183),
            Map.entry("CSE-HONORS-MINOR", 201),
            Map.entry("CSE-HONORS-DOUBLE_MAJOR", 208),
            Map.entry("CSE-HONORS-SPECIALIZATION", 193),
            Map.entry("CSE-HONORS", 183),
            Map.entry("CSE-REGULAR-MINOR", 183),
            Map.entry("CSE-REGULAR-DOUBLE_MAJOR", 188),
            Map.entry("CSE-REGULAR-SPECIALIZATION", 168),
            Map.entry("CSE-REGULAR", 163)
    );

    private static final Map<String, Integer> EXPECTED_AIDS_TOTALS = Map.ofEntries(
            Map.entry("AIDS-HTE-MINOR", 206),
            Map.entry("AIDS-HTE-DOUBLE_MAJOR", 211),
            Map.entry("AIDS-HTE-SPECIALIZATION", 196),
            Map.entry("AIDS-HTE", 186),
            Map.entry("AIDS-HTI-MINOR", 206),
            Map.entry("AIDS-HTI-DOUBLE_MAJOR", 211),
            Map.entry("AIDS-HTI-SPECIALIZATION", 196),
            Map.entry("AIDS-HTI", 186),
            Map.entry("AIDS-HTR-MINOR", 206),
            Map.entry("AIDS-HTR-DOUBLE_MAJOR", 211),
            Map.entry("AIDS-HTR-SPECIALIZATION", 196),
            Map.entry("AIDS-HTR", 186),
            Map.entry("AIDS-HONORS-MINOR", 206),
            Map.entry("AIDS-HONORS-DOUBLE_MAJOR", 211),
            Map.entry("AIDS-HONORS-SPECIALIZATION", 196),
            Map.entry("AIDS-HONORS", 186),
            Map.entry("AIDS-REGULAR-MINOR", 186),
            Map.entry("AIDS-REGULAR-DOUBLE_MAJOR", 191),
            Map.entry("AIDS-REGULAR-SPECIALIZATION", 171),
            Map.entry("AIDS-REGULAR", 166)
    );

    @Test
    @DisplayName("Phase 17.1: Validate All 20 CSE Degree Path Totals Against Official PDF")
    public void testAll20CseDegreePathTotals() {
        for (Map.Entry<String, Integer> entry : EXPECTED_CSE_TOTALS.entrySet()) {
            String pathCode = entry.getKey();
            int expectedCredits = entry.getValue();

            Optional<DegreePath> pathOpt = degreePathRepository.findAll().stream()
                    .filter(p -> pathCode.equals(p.getPathCode()) && p.getDepartment() != null && "CSE".equals(p.getDepartment().getDeptCode()))
                    .findFirst();

            assertTrue(pathOpt.isPresent(), "CSE Degree Path must exist: " + pathCode);
            DegreePath path = pathOpt.get();
            assertEquals(expectedCredits, path.getTotalCredits(),
                    "Credit total mismatch for " + pathCode + ": expected " + expectedCredits + " but got " + path.getTotalCredits());
            assertNotNull(path.getCurriculumVersion(), "Degree path must be linked to curriculum_version");
            assertEquals("Y23-CSE", path.getCurriculumVersion().getCurriculumCode(), "Must link to Y23-CSE curriculum version");
        }
    }

    @Test
    @DisplayName("Phase 17.2: Validate All 20 AIDS Degree Path Totals Against Official PDF")
    public void testAll20AidsDegreePathTotals() {
        for (Map.Entry<String, Integer> entry : EXPECTED_AIDS_TOTALS.entrySet()) {
            String pathCode = entry.getKey();
            int expectedCredits = entry.getValue();

            Optional<DegreePath> pathOpt = degreePathRepository.findAll().stream()
                    .filter(p -> pathCode.equals(p.getPathCode()) && p.getDepartment() != null && "AIDS".equals(p.getDepartment().getDeptCode()))
                    .findFirst();

            assertTrue(pathOpt.isPresent(), "AIDS Degree Path must exist: " + pathCode);
            DegreePath path = pathOpt.get();
            assertEquals(expectedCredits, path.getTotalCredits(),
                    "Credit total mismatch for " + pathCode + ": expected " + expectedCredits + " but got " + path.getTotalCredits());
            assertNotNull(path.getCurriculumVersion(), "Degree path must be linked to curriculum_version");
            assertEquals("Y23-AIDS", path.getCurriculumVersion().getCurriculumCode(), "Must link to Y23-AIDS curriculum version");
        }
    }

    @Test
    @DisplayName("Phase 17.3: Specific Cardinal Totals (CSE: 163, 168, 183, 188; AIDS: 166, 171, 186, 191)")
    public void testCardinalRegularTotals() {
        // CSE
        assertEquals(163, getCredits("CSE-REGULAR", "CSE"));
        assertEquals(168, getCredits("CSE-REGULAR-SPECIALIZATION", "CSE"));
        assertEquals(183, getCredits("CSE-REGULAR-MINOR", "CSE"));
        assertEquals(188, getCredits("CSE-REGULAR-DOUBLE_MAJOR", "CSE"));

        // AIDS
        assertEquals(166, getCredits("AIDS-REGULAR", "AIDS"));
        assertEquals(171, getCredits("AIDS-REGULAR-SPECIALIZATION", "AIDS"));
        assertEquals(186, getCredits("AIDS-REGULAR-MINOR", "AIDS"));
        assertEquals(191, getCredits("AIDS-REGULAR-DOUBLE_MAJOR", "AIDS"));
    }

    private int getCredits(String pathCode, String deptCode) {
        return degreePathRepository.findAll().stream()
                .filter(p -> pathCode.equals(p.getPathCode()) && p.getDepartment() != null && deptCode.equals(p.getDepartment().getDeptCode()))
                .findFirst()
                .map(DegreePath::getTotalCredits)
                .orElseThrow(() -> new AssertionError("Path not found: " + pathCode));
    }
}
