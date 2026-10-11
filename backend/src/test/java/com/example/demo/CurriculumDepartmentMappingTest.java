package com.example.demo;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.*;
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
public class CurriculumDepartmentMappingTest {

    @Autowired private DegreePathEngine degreePathEngine;
    @Autowired private BucketMappingEngine bucketMappingEngine;
    @Autowired private BucketSatisfactionEngine bucketSatisfactionEngine;
    @Autowired private DegreeEligibilityEngine degreeEligibilityEngine;
    @Autowired private StudentRepository studentRepository;
    @Autowired private DegreePathRepository degreePathRepository;
    @Autowired private StudentDegreePathRepository studentDegreePathRepository;
    @Autowired private StudentCourseRepository studentCourseRepository;
    @Autowired private PathBucketRequirementRepository pathBucketRequirementRepository;
    @Autowired private UnmatchedStudentQueueRepository unmatchedStudentQueueRepository;
    @Autowired private ProgramCourseEquivalenceRepository programCourseEquivalenceRepository;
    @Autowired private CurriculumVersionRepository curriculumVersionRepository;
    @Autowired private BucketMasterRepository bucketMasterRepository;

    @Test
    @DisplayName("Acceptance Criteria 1: CSE student receives CSE requirements (163 cr Regular, 28 cr PCC-CORE)")
    public void testCseStudentReceivesCseRequirements() {
        Student cseStudent = new Student();
        cseStudent.setStudentId("TEST_CSE_001");
        cseStudent.setEmail("test_cse_001@kluniversity.in");
        cseStudent.setPassword("hash");
        cseStudent.setFirstName("CSE");
        cseStudent.setLastName("Student");
        cseStudent.setDepartment("CSE");
        cseStudent.setSubDepartment("REGULAR");
        cseStudent.setSpecializationType("NONE");
        cseStudent = studentRepository.save(cseStudent);

        DegreePath assignedPath = degreePathEngine.resolveAndAssignPath(cseStudent.getId());
        assertNotNull(assignedPath);
        assertEquals("CSE", assignedPath.getDepartment().getDeptCode());
        assertEquals("CSE-REGULAR", assignedPath.getPathCode());
        assertEquals(163, assignedPath.getTotalCredits());

        // Check PCC-CORE credits for CSE-REGULAR is 28
        List<PathBucketRequirement> reqs = pathBucketRequirementRepository.findByDegreePathId(assignedPath.getId());
        PathBucketRequirement pccReq = reqs.stream()
                .filter(r -> "PCC-CORE".equals(r.getBucket().getBucketCode()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("PCC-CORE requirement not found for CSE-REGULAR"));
        assertEquals(28, pccReq.getRequiredCredits().intValue(), "CSE PCC-CORE must require 28 credits");
    }

    @Test
    @DisplayName("Acceptance Criteria 2: AIDS student receives AIDS requirements (166 cr Regular, 31 cr PCC-CORE)")
    public void testAidsStudentReceivesAidsRequirements() {
        Student aidsStudent = new Student();
        aidsStudent.setStudentId("TEST_AIDS_001");
        aidsStudent.setEmail("test_aids_001@kluniversity.in");
        aidsStudent.setPassword("hash");
        aidsStudent.setFirstName("AIDS");
        aidsStudent.setLastName("Student");
        aidsStudent.setDepartment("AIDS");
        aidsStudent.setSubDepartment("REGULAR");
        aidsStudent.setSpecializationType("NONE");
        aidsStudent = studentRepository.save(aidsStudent);

        DegreePath assignedPath = degreePathEngine.resolveAndAssignPath(aidsStudent.getId());
        assertNotNull(assignedPath);
        assertEquals("AIDS", assignedPath.getDepartment().getDeptCode());
        assertEquals("AIDS-REGULAR", assignedPath.getPathCode());
        assertEquals(166, assignedPath.getTotalCredits());

        // Check PCC-CORE credits for AIDS-REGULAR is 31
        List<PathBucketRequirement> reqs = pathBucketRequirementRepository.findByDegreePathId(assignedPath.getId());
        PathBucketRequirement pccReq = reqs.stream()
                .filter(r -> "PCC-CORE".equals(r.getBucket().getBucketCode()))
                .findFirst()
                .orElseThrow(() -> new AssertionError("PCC-CORE requirement not found for AIDS-REGULAR"));
        assertEquals(31, pccReq.getRequiredCredits().intValue(), "AIDS PCC-CORE must require 31 credits");
    }

    @Test
    @DisplayName("Acceptance Criteria 3: Missing or ambiguous department triggers review queue rather than defaulting to CSE")
    public void testMissingOrAmbiguousDepartmentQueued() {
        Student ambiguousStudent = new Student();
        ambiguousStudent.setStudentId("TEST_AMBIGUOUS_99");
        ambiguousStudent.setEmail("ambiguous99@kluniversity.in");
        ambiguousStudent.setPassword("hash");
        ambiguousStudent.setFirstName("Pathan");
        ambiguousStudent.setLastName("Khan");
        ambiguousStudent.setDepartment("H"); // Ambiguous / unknown code
        ambiguousStudent.setSubDepartment("REGULAR");
        ambiguousStudent.setSpecializationType("NONE");
        final Student savedStudent = studentRepository.save(ambiguousStudent);

        // Attempting to resolve path must throw exception and NOT default to CSE
        assertThrows(RuntimeException.class, () -> {
            degreePathEngine.resolveAndAssignPath(savedStudent.getId());
        });

        // Verify record in unmatched student queue
        Optional<UnmatchedStudentQueue> queueItem = unmatchedStudentQueueRepository
                .findByStudentIdNumAndStatus("TEST_AMBIGUOUS_99", "PENDING_REVIEW");
        assertTrue(queueItem.isPresent(), "Ambiguous student must be placed in review queue");
        assertEquals("UNKNOWN_DEPARTMENT", queueItem.get().getIssueType());
        assertEquals("H", queueItem.get().getRawDepartment());
    }

    @Test
    @DisplayName("Acceptance Criteria 4: Cross-curriculum course equivalence requires explicit approved mapping")
    public void testCrossCurriculumCourseEquivalence() {
        // Setup AIDS student
        Student aidsStudent = new Student();
        aidsStudent.setStudentId("TEST_AIDS_EQUIV");
        aidsStudent.setEmail("aids_equiv@kluniversity.in");
        aidsStudent.setPassword("hash");
        aidsStudent.setFirstName("Equiv");
        aidsStudent.setLastName("Test");
        aidsStudent.setDepartment("AIDS");
        aidsStudent.setSubDepartment("REGULAR");
        aidsStudent.setSpecializationType("NONE");
        aidsStudent = studentRepository.save(aidsStudent);

        DegreePath aidsPath = degreePathRepository.findAll().stream()
                .filter(p -> "AIDS-REGULAR".equals(p.getPathCode()))
                .findFirst().orElseThrow();

        // Student took a cross-department course: 23CS2205O (DAA in CSE)
        StudentCourse sc = new StudentCourse();
        sc.setStudent(aidsStudent);
        sc.setUniversityId(aidsStudent.getStudentId());
        sc.setCourseCode("23CS2205O");
        sc.setCourseName("Design and Analysis of Algorithms");
        sc.setCredits(4.0);
        sc.setStatus("COMPLETED");
        studentCourseRepository.save(sc);

        // Before approved equivalence: course must NOT count towards AIDS-REGULAR
        Map<Long, BucketMappingEngine.BucketCreditsInfo> earnedBefore =
                bucketMappingEngine.mapStudentCoursesToBuckets(aidsStudent.getId(), aidsPath.getId());
        int creditsBefore = earnedBefore.values().stream().mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits).sum();
        assertEquals(0, creditsBefore, "Cross-department course without approval must not count");

        // Now create approved equivalence to AIDS course: 23AD2201 (or target course in AIDS)
        CurriculumVersion cseVer = curriculumVersionRepository.findByCurriculumCode("Y23-CSE").orElseThrow();
        CurriculumVersion aidsVer = aidsPath.getCurriculumVersion();

        ProgramCourseEquivalence equiv = new ProgramCourseEquivalence();
        equiv.setSourceCurriculumVersion(cseVer);
        equiv.setTargetCurriculumVersion(aidsVer);
        equiv.setSourceCourseCode("23CS2205O");
        equiv.setTargetCourseCode("23AD2201");
        equiv.setStatus("APPROVED");
        equiv.setApprovedBy("DEAN_ACADEMICS");
        equiv.setNotes("Approved equivalence between CSE DAA and AIDS DAA");
        programCourseEquivalenceRepository.save(equiv);

        // After approved equivalence: BucketMappingEngine checks approved equivalence
        List<ProgramCourseEquivalence> approved = programCourseEquivalenceRepository
                .findApprovedEquivalencesForTarget(aidsVer.getId(), "23CS2205O");
        assertFalse(approved.isEmpty(), "Approved equivalence must be retrievable");
        assertEquals("APPROVED", approved.get(0).getStatus());
    }

    @Test
    @DisplayName("Acceptance Criteria 5: Deduplication prevents double counting of duplicate course attempts")
    public void testDeduplicationPreventsDoubleCounting() {
        Student student = new Student();
        student.setStudentId("TEST_DEDUP_STUDENT");
        student.setEmail("dedup_test@kluniversity.in");
        student.setPassword("hash");
        student.setFirstName("Dedup");
        student.setLastName("Student");
        student.setDepartment("AIDS");
        student = studentRepository.save(student);

        DegreePath aidsPath = degreePathRepository.findAll().stream()
                .filter(p -> "AIDS-REGULAR".equals(p.getPathCode()))
                .findFirst().orElseThrow();

        // Register same course in two attempts (e.g. Even Sem and Summer Term)
        StudentCourse attempt1 = new StudentCourse();
        attempt1.setStudent(student);
        attempt1.setUniversityId(student.getStudentId());
        attempt1.setCourseCode("23AD2101");
        attempt1.setCourseName("Design and Analysis of Algorithms");
        attempt1.setCredits(4.0);
        attempt1.setSemester("Even Sem");
        attempt1.setStatus("COMPLETED");
        studentCourseRepository.save(attempt1);

        StudentCourse attempt2 = new StudentCourse();
        attempt2.setStudent(student);
        attempt2.setUniversityId(student.getStudentId());
        attempt2.setCourseCode("23AD2101");
        attempt2.setCourseName("Design and Analysis of Algorithms");
        attempt2.setCredits(4.0);
        attempt2.setSemester("Summer Term");
        attempt2.setStatus("COMPLETED");
        studentCourseRepository.save(attempt2);

        Map<Long, BucketMappingEngine.BucketCreditsInfo> earned =
                bucketMappingEngine.mapStudentCoursesToBuckets(student.getId(), aidsPath.getId());

        // Total credits earned across buckets for 23AD2101 must be exactly 4 (NOT 8!)
        int totalCredits = earned.values().stream().mapToInt(BucketMappingEngine.BucketCreditsInfo::getEarnedCredits).sum();
        assertEquals(4, totalCredits, "Duplicate course attempts must never double-count credits");
    }
}
