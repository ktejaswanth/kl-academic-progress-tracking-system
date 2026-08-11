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
    @Autowired private CurriculumVersionRepository curriculumVersionRepo;
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

        for (CompletedCourse cc : rawList) {
            User student = cc.getStudent();
            if (student == null) continue;

            processedStudents.add(student.getId());

            String univId = student.getUsername(); // Student ID / Roll number
            Optional<CourseCatalog> catalogOpt = courseCatalogRepo.findByCourseCode(cc.getCourseCode());

            if (catalogOpt.isPresent()) {
                matchedCourses++;
            }

            // Check if already in student_courses
            boolean exists = studentCourseRepo.findByStudentId(student.getId()).stream()
                    .anyMatch(sc -> sc.getCourseCode().equalsIgnoreCase(cc.getCourseCode()));

            if (exists) {
                duplicateRecords++;
                continue;
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
            if (catalogOpt.isPresent()) {
                sc.setCourse(catalogOpt.get());
            }

            studentCourseRepo.save(sc);
            migratedCourses++;

            // Create qualifying attempt
            StudentCourseAttempt sca = new StudentCourseAttempt();
            sca.setStudent(student);
            sca.setUniversityId(univId);
            sca.setCourseCode(cc.getCourseCode());
            sca.setAttemptNumber(1);
            sca.setGrade(cc.getGrade());
            sca.setStatus("COMPLETED");
            sca.setSemester(cc.getSemester());
            sca.setIsQualifying(true);
            studentAttemptRepo.save(sca);
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
