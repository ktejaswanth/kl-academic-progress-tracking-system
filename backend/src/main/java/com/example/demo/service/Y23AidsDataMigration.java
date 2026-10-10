package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class Y23AidsDataMigration {

    private static final Logger log = LoggerFactory.getLogger(Y23AidsDataMigration.class);

    @Autowired private CompletedCourseRepository completedCourseRepo;
    @Autowired private StudentCourseRepository studentCourseRepo;
    @Autowired private StudentCourseAttemptRepository studentAttemptRepo;
    @Autowired private StudentProfileRepository studentProfileRepo;
    @Autowired private CourseCatalogRepository courseCatalogRepo;
    @Autowired private DegreePathEngine degreePathEngine;

    public Map<String, Object> migrateY23AidsStudentData() {
        log.info("Starting student course data normalization migration...");

        List<CompletedCourse> rawList = completedCourseRepo.findAll();
        int totalRecords = rawList.size();
        int matchedStudents = 0;
        int matchedCourses = 0;
        int migratedCourses = 0;
        int duplicateRecords = 0;

        Set<Long> processedStudents = new HashSet<>();

        // 1. Preload Course Catalog into map for O(1) lookups
        Map<String, CourseCatalog> catalogMap = new HashMap<>();
        for (CourseCatalog cat : courseCatalogRepo.findAll()) {
            if (cat.getCourseCode() != null) {
                catalogMap.put(cat.getCourseCode().toUpperCase().trim(), cat);
            }
        }

        // 2. Preload existing student courses to avoid N+1 queries
        Set<String> existingPairs = new HashSet<>();
        for (StudentCourse sc : studentCourseRepo.findAll()) {
            if (sc.getStudent() != null && sc.getCourseCode() != null) {
                existingPairs.add(sc.getStudent().getId() + "#" + sc.getCourseCode().toUpperCase().trim());
            }
        }

        List<StudentCourse> scToSave = new ArrayList<>();
        List<StudentCourseAttempt> scaToSave = new ArrayList<>();

        for (CompletedCourse cc : rawList) {
            Student student = cc.getStudent();
            if (student == null) continue;

            String codeUpper = cc.getCourseCode() != null ? cc.getCourseCode().toUpperCase().trim() : "";
            if (codeUpper.isEmpty()) continue;

            String pairKey = student.getId() + "#" + codeUpper;
            if (existingPairs.contains(pairKey)) {
                duplicateRecords++;
                continue;
            }
            existingPairs.add(pairKey);

            String univId = cc.getUniversityId() != null ? cc.getUniversityId() : student.getStudentId();
            processedStudents.add(student.getId());

            CourseCatalog catalog = catalogMap.get(codeUpper);
            if (catalog != null) {
                matchedCourses++;
            }

            StudentCourse sc = new StudentCourse();
            sc.setStudent(student);
            sc.setUniversityId(univId);
            sc.setCourseCode(cc.getCourseCode());
            sc.setCourseName(cc.getCourseName());
            sc.setCredits(cc.getCredits() != null ? cc.getCredits().doubleValue() : 0.0);
            sc.setGrade(cc.getGrade());
            sc.setStatus(cc.getStatus() != null ? cc.getStatus() : "COMPLETED");
            sc.setSemester(cc.getSemester());
            sc.setCompletedDate(cc.getCompletedDate());
            if (catalog != null) {
                sc.setCourse(catalog);
            }
            scToSave.add(sc);

            StudentCourseAttempt sca = new StudentCourseAttempt();
            sca.setStudent(student);
            sca.setUniversityId(univId);
            sca.setCourseCode(cc.getCourseCode());
            sca.setAttemptNumber(1);
            sca.setGrade(cc.getGrade());
            sca.setStatus("COMPLETED");
            sca.setSemester(cc.getSemester());
            sca.setIsQualifying(true);
            scaToSave.add(sca);

            migratedCourses++;
        }

        if (!scToSave.isEmpty()) {
            studentCourseRepo.saveAll(scToSave);
        }
        if (!scaToSave.isEmpty()) {
            studentAttemptRepo.saveAll(scaToSave);
        }

        // Auto assign degree path to any student missing one
        for (Long studentId : processedStudents) {
            try {
                degreePathEngine.resolveAndAssignPath(studentId);
                matchedStudents++;
            } catch (Exception e) {
                log.warn("Could not auto-assign path for student ID {}: {}", studentId, e.getMessage());
            }
        }

        Map<String, Object> report = new LinkedHashMap<>();
        report.put("totalRecords", totalRecords);
        report.put("processedStudents", processedStudents.size());
        report.put("matchedStudentsWithDegreePath", matchedStudents);
        report.put("matchedCatalogCourses", matchedCourses);
        report.put("migratedStudentCourses", migratedCourses);
        report.put("duplicateSkipped", duplicateRecords);
        report.put("success", true);

        log.info("Student course data normalization complete: {}", report);
        return report;
    }
}
