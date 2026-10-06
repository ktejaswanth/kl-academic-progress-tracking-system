package com.example.demo.service;

import com.example.demo.model.CompletedCourse;
import com.example.demo.model.Requirement;
import com.example.demo.model.Student;
import com.example.demo.model.StudentProfile;
import com.example.demo.repository.CompletedCourseRepository;
import com.example.demo.repository.RequirementRepository;
import com.example.demo.repository.StudentProfileRepository;
import com.example.demo.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class AuditService {

    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private RequirementRepository requirementRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    public Map<String, Object> getStudentProgressByUsername(String username) {
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student not found: " + username));
        return getStudentProgressForStudent(student);
    }

    public Map<String, Object> getStudentProgressForStudent(Student student) {
        String degreeType = "B.Tech";
        String specialization = student.getDepartment() != null ? student.getDepartment() : "CSE";

        List<Requirement> requirements = requirementRepository.findByDegreeTypeAndSpecialization(
                degreeType, specialization);

        List<CompletedCourse> completed = completedCourseRepository.findByStudentId(student.getId());

        int totalRequired = requirements.stream().mapToInt(Requirement::getCredits).sum();
        int totalCompleted = completed.stream()
                .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                .mapToInt(CompletedCourse::getCredits)
                .sum();
        double percentage = totalRequired > 0 ? (double) totalCompleted / totalRequired * 100 : 0;

        Map<String, Map<String, Object>> categorySummaries = new HashMap<>();
        Map<String, List<Requirement>> groupedReqs = requirements.stream()
                .collect(Collectors.groupingBy(Requirement::getBucketName));

        for (String bucket : groupedReqs.keySet()) {
            List<Requirement> bucketReqs = groupedReqs.get(bucket);
            int reqCredits = bucketReqs.stream().mapToInt(Requirement::getCredits).sum();
            int compCredits = completed.stream()
                    .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                    .filter(c -> bucketReqs.stream().anyMatch(r -> r.getCourseCode().equals(c.getCourseCode())))
                    .mapToInt(CompletedCourse::getCredits)
                    .sum();
            double catPct = reqCredits > 0 ? (double) compCredits / reqCredits * 100 : 0;

            Map<String, Object> catData = new HashMap<>();
            catData.put("required", reqCredits);
            catData.put("completed", compCredits);
            catData.put("percentage", Math.round(catPct * 10.0) / 10.0);
            categorySummaries.put(bucket, catData);
        }

        Map<String, Object> response = new HashMap<>();
        String fullName = student.getName() != null && !student.getName().trim().isEmpty()
                ? student.getName()
                : ((student.getFirstName() != null ? student.getFirstName() : "") + " " + (student.getLastName() != null ? student.getLastName() : "")).trim();
        response.put("studentName", fullName.isEmpty() ? student.getStudentId() : fullName);
        response.put("degree", degreeType);
        response.put("specialization", specialization);
        response.put("totalCreditsRequired", totalRequired);
        response.put("totalCreditsCompleted", totalCompleted);
        response.put("overallPercentage", Math.round(percentage * 10.0) / 10.0);
        response.put("completionPercentage", Math.round(percentage * 100.0) / 100.0);
        response.put("categories", categorySummaries);
        response.put("categorySummaries", categorySummaries);
        response.put("completedCourses", completed);

        // Identify missing mandatory courses
        Set<String> completedCodesForMandatory = completed.stream()
                .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                .map(CompletedCourse::getCourseCode)
                .collect(Collectors.toSet());
        List<Requirement> missingMandatory = requirements.stream()
                .filter(Requirement::getIsMandatory)
                .filter(r -> !completedCodesForMandatory.contains(r.getCourseCode()))
                .collect(Collectors.toList());

        response.put("missingMandatory", missingMandatory);
        return response;
    }

    public Map<String, Object> getStudentProgress(Long studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + studentId));
        return getStudentProgressForStudent(student);
    }

    public Map<String, Object> getStudentCurriculumCourses(String username) {
        String degreeType = "B.Tech";
        String specialization = "CSE";
        String honorsType = "REGULAR";

        Long studentDbId = null;
        String dept = "CSE";
        String specName = "N/A";
        String specType = "NONE";

        Student s = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student not found: " + username));
        studentDbId = s.getId();
        if (s.getDepartment() != null && !s.getDepartment().isEmpty()) {
            specialization = s.getDepartment();
            dept = s.getDepartment();
        }
        if (s.getSubDepartment() != null && !s.getSubDepartment().isEmpty()) honorsType = s.getSubDepartment();
        if (s.getSpecializationName() != null) specName = s.getSpecializationName();
        if (s.getSpecializationType() != null) specType = s.getSpecializationType();

        // Final fallback if fields are empty
        if ("N/A".equalsIgnoreCase(specialization) || specialization.trim().isEmpty()) {
            specialization = "CSE";
        }
        if ("N/A".equalsIgnoreCase(honorsType) || honorsType.trim().isEmpty()) {
            honorsType = "REGULAR";
        }

        // Fetch core specialization requirements
        List<Requirement> specReqs = requirementRepository.findByDegreeTypeAndSpecialization(degreeType, specialization);
        
        // Fetch additional honors requirements if honors is selected
        List<Requirement> honorsReqs = new ArrayList<>();
        if (!"REGULAR".equalsIgnoreCase(honorsType) && !"NONE".equalsIgnoreCase(honorsType)) {
            honorsReqs = requirementRepository.findByDegreeTypeAndSpecializationAndHonorsType(degreeType, specialization, honorsType);
        }

        // De-duplicate requirements by course code
        Set<String> seenCodes = new HashSet<>();
        List<Requirement> curriculumCourses = new ArrayList<>();
        
        for (Requirement r : specReqs) {
            if (r.getCourseCode() != null && seenCodes.add(r.getCourseCode())) {
                curriculumCourses.add(r);
            }
        }
        for (Requirement r : honorsReqs) {
            if (r.getCourseCode() != null && seenCodes.add(r.getCourseCode())) {
                curriculumCourses.add(r);
            }
        }

        // Fetch completed course codes for this student
        List<CompletedCourse> completed = (studentDbId != null)
                ? completedCourseRepository.findByStudentId(studentDbId)
                : Collections.emptyList();
        Set<String> completedCodes = completed.stream()
                .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                .map(CompletedCourse::getCourseCode)
                .collect(Collectors.toSet());

        Map<String, Object> response = new HashMap<>();
        response.put("degreeType", degreeType);
        response.put("specialization", specialization);
        response.put("honorsType", honorsType);
        response.put("department", dept);
        response.put("specializationName", specName);
        response.put("specializationType", specType);
        response.put("completedCourseCodes", completedCodes);
        response.put("courses", curriculumCourses);
        return response;
    }
}
