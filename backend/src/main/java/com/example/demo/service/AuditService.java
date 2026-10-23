package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
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

    @Autowired
    private CurriculumCourseMappingRepository curriculumCourseMappingRepository;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private CurriculumVersionRepository curriculumVersionRepository;

    @Autowired
    private StudentCourseRepository studentCourseRepository;

    @Autowired
    private DegreePathEngine degreePathEngine;

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
                .or(() -> studentRepository.findByEmail(username))
                .or(() -> {
                    try {
                        Long id = Long.parseLong(username);
                        return studentRepository.findById(id);
                    } catch (NumberFormatException e) {
                        return Optional.empty();
                    }
                })
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

        // 1. Fetch completed course codes & enrolled courses for this student
        Set<String> completedCodes = new HashSet<>();
        List<StudentCourse> studentCourses = studentCourseRepository.findByStudentId(s.getId());
        if (studentCourses.isEmpty()) {
            studentCourses = studentCourseRepository.findByUniversityId(s.getStudentId());
        }
        for (StudentCourse sc : studentCourses) {
            if (sc.getCourseCode() != null && (sc.getStatus() == null || (!sc.getStatus().equalsIgnoreCase("DROPPED") && !sc.getStatus().equalsIgnoreCase("WITHDRAWN")))) {
                completedCodes.add(sc.getCourseCode().trim().toUpperCase());
            }
        }
        if (studentDbId != null) {
            List<CompletedCourse> completed = completedCourseRepository.findByStudentId(studentDbId);
            for (CompletedCourse cc : completed) {
                if (cc.getCourseCode() != null && (cc.getStatus() == null || !cc.getStatus().equalsIgnoreCase("On-Progress"))) {
                    completedCodes.add(cc.getCourseCode().trim().toUpperCase());
                }
            }
        }

        // 2. Resolve CurriculumVersion
        CurriculumVersion curriculumVersion = null;
        Optional<StudentDegreePath> sdpOpt = studentDegreePathRepository.findByStudentId(s.getId());
        if (sdpOpt.isPresent() && sdpOpt.get().getDegreePath() != null) {
            curriculumVersion = sdpOpt.get().getDegreePath().getCurriculumVersion();
        }
        if (curriculumVersion == null) {
            String targetCode = "Y23-" + dept;
            Optional<CurriculumVersion> cvOpt = curriculumVersionRepository.findByCurriculumCode(targetCode);
            if (cvOpt.isPresent()) {
                curriculumVersion = cvOpt.get();
            } else {
                targetCode = "Y24-" + dept;
                cvOpt = curriculumVersionRepository.findByCurriculumCode(targetCode);
                if (cvOpt.isPresent()) {
                    curriculumVersion = cvOpt.get();
                }
            }
        }

        // 3. Build student's individual curriculum courses from real-time academic records
        List<Map<String, Object>> curriculumCourses = new ArrayList<>();
        Set<String> seenCodes = new HashSet<>();

        // Add all courses enrolled/completed by student first
        for (StudentCourse sc : studentCourses) {
            if (sc.getCourseCode() == null || sc.getCourseCode().isBlank()) continue;
            String cCode = sc.getCourseCode().trim().toUpperCase();
            if (!seenCodes.add(cCode)) continue;

            String cUpper = cCode;
            String cat = "GENERAL";
            if (cUpper.startsWith("23CS") || cUpper.startsWith("23AD") || cUpper.startsWith("23EC") || 
                cUpper.startsWith("23EE") || cUpper.startsWith("23ME") || cUpper.startsWith("23SC") || 
                cUpper.startsWith("23MA") || cUpper.startsWith("23PH") || cUpper.startsWith("23CH") ||
                cUpper.startsWith("23MT")) {
                cat = "DEPARTMENT";
            } else if (cUpper.contains("SPEC") || cUpper.startsWith("23PE")) {
                cat = "SPECIALIZATION";
            } else if (cUpper.startsWith("H") || cUpper.contains("HONOR")) {
                cat = "HONORS";
            }

            double cr = sc.getCredits() != null ? sc.getCredits() : 0.0;
            String grade = (sc.getGrade() != null && !sc.getGrade().isBlank()) ? sc.getGrade().trim() : "Pass";
            String status = (sc.getStatus() != null && !sc.getStatus().isBlank()) ? sc.getStatus().trim() : "COMPLETED";
            String semester = sc.getSemester() != null ? sc.getSemester().trim() : "";
            String acadYr = sc.getAcademicYear() != null ? sc.getAcademicYear().trim() : "";

            Map<String, Object> cMap = new HashMap<>();
            cMap.put("courseCode", sc.getCourseCode().trim());
            cMap.put("courseName", sc.getCourseName() != null ? sc.getCourseName().trim() : sc.getCourseCode().trim());
            cMap.put("credits", cr);
            cMap.put("grade", grade);
            cMap.put("status", status);
            cMap.put("semester", semester);
            cMap.put("academicYear", acadYr);
            cMap.put("bucketName", cat.equals("DEPARTMENT") ? "Department Core" : (cat.equals("SPECIALIZATION") ? "Specialization" : (cat.equals("HONORS") ? "Honors" : "General & Electives")));
            cMap.put("bucketCode", cat.equals("DEPARTMENT") ? "PCC" : (cat.equals("SPECIALIZATION") ? "PEC" : (cat.equals("HONORS") ? "HON" : "GEN")));
            cMap.put("honorsType", cat.equals("HONORS") ? "HONORS" : "REGULAR");
            cMap.put("isMandatory", cat.equals("DEPARTMENT"));
            cMap.put("category", cat);
            cMap.put("degreeType", degreeType);
            cMap.put("specialization", specialization);
            cMap.put("isCompleted", true);
            curriculumCourses.add(cMap);
        }

        // Check completedCourseRepository for any additional completed courses
        if (studentDbId != null) {
            List<CompletedCourse> completed = completedCourseRepository.findByStudentId(studentDbId);
            for (CompletedCourse cc : completed) {
                if (cc.getCourseCode() == null || cc.getCourseCode().isBlank()) continue;
                String cCode = cc.getCourseCode().trim().toUpperCase();
                if (!seenCodes.add(cCode)) continue;

                String cUpper = cCode;
                String cat = "GENERAL";
                if (cUpper.startsWith("23CS") || cUpper.startsWith("23AD") || cUpper.startsWith("23EC") || 
                    cUpper.startsWith("23EE") || cUpper.startsWith("23ME") || cUpper.startsWith("23SC") || 
                    cUpper.startsWith("23MA") || cUpper.startsWith("23PH") || cUpper.startsWith("23CH") ||
                    cUpper.startsWith("23MT")) {
                    cat = "DEPARTMENT";
                } else if (cUpper.contains("SPEC") || cUpper.startsWith("23PE")) {
                    cat = "SPECIALIZATION";
                } else if (cUpper.startsWith("H") || cUpper.contains("HONOR")) {
                    cat = "HONORS";
                }

                double cr = cc.getCredits() != null ? cc.getCredits().doubleValue() : 0.0;
                String grade = (cc.getGrade() != null && !cc.getGrade().isBlank()) ? cc.getGrade().trim() : "Pass";
                String status = (cc.getStatus() != null && !cc.getStatus().isBlank()) ? cc.getStatus().trim() : "COMPLETED";
                String semester = cc.getSemester() != null ? cc.getSemester().trim() : "";
                String acadYr = cc.getAcademicYear() != null ? cc.getAcademicYear().trim() : "";

                Map<String, Object> cMap = new HashMap<>();
                cMap.put("courseCode", cc.getCourseCode().trim());
                cMap.put("courseName", cc.getCourseName() != null ? cc.getCourseName().trim() : cc.getCourseCode().trim());
                cMap.put("credits", cr);
                cMap.put("grade", grade);
                cMap.put("status", status);
                cMap.put("semester", semester);
                cMap.put("academicYear", acadYr);
                cMap.put("bucketName", cat.equals("DEPARTMENT") ? "Department Core" : (cat.equals("SPECIALIZATION") ? "Specialization" : (cat.equals("HONORS") ? "Honors" : "General & Electives")));
                cMap.put("bucketCode", cat.equals("DEPARTMENT") ? "PCC" : (cat.equals("SPECIALIZATION") ? "PEC" : (cat.equals("HONORS") ? "HON" : "GEN")));
                cMap.put("honorsType", cat.equals("HONORS") ? "HONORS" : "REGULAR");
                cMap.put("isMandatory", cat.equals("DEPARTMENT"));
                cMap.put("category", cat);
                cMap.put("degreeType", degreeType);
                cMap.put("specialization", specialization);
                cMap.put("isCompleted", true);
                curriculumCourses.add(cMap);
            }
        }

        // Only if student has NO records at all in system, fallback to curriculum catalog template
        if (curriculumCourses.isEmpty() && curriculumVersion != null) {
            List<CurriculumCourseMapping> mappings;
            try {
                mappings = curriculumCourseMappingRepository.findAllByCurriculumVersionIdWithDetails(curriculumVersion.getId());
            } catch (Exception e) {
                mappings = curriculumCourseMappingRepository.findByCurriculumVersionId(curriculumVersion.getId());
            }

            for (CurriculumCourseMapping ccm : mappings) {
                if (ccm.getCurriculumCourse() == null) continue;
                String cCode = null;
                String cName = null;
                Integer cr = 3;
                if (ccm.getCurriculumCourse().getCourse() != null) {
                    cCode = ccm.getCurriculumCourse().getCourse().getCourseCode();
                    cName = ccm.getCurriculumCourse().getCourse().getCourseName();
                    if (ccm.getCurriculumCourse().getCourse().getCredits() != null) {
                        cr = ccm.getCurriculumCourse().getCourse().getCredits();
                    }
                }
                if (cCode == null || cCode.isBlank()) continue;
                if (cName == null || cName.isBlank()) {
                    cName = ccm.getCurriculumCourse().getCourseName() != null ? ccm.getCurriculumCourse().getCourseName() : cCode;
                }
                if (cr == null || cr == 0) {
                    cr = ccm.getCurriculumCourse().getCredits() != null ? ccm.getCurriculumCourse().getCredits().intValue() : 3;
                }

                String bucketName = (ccm.getBucket() != null && ccm.getBucket().getBucketName() != null)
                        ? ccm.getBucket().getBucketName() : "Core";
                String bucketCode = (ccm.getBucket() != null && ccm.getBucket().getBucketCode() != null)
                        ? ccm.getBucket().getBucketCode() : "";

                String itemHonors = "REGULAR";
                if (bucketCode.startsWith("H") || bucketName.toLowerCase().contains("honor")) {
                    itemHonors = "HONORS";
                }

                Boolean isMand = Boolean.TRUE.equals(ccm.getIsMandatory()) || bucketCode.toUpperCase().contains("CORE");

                if (!seenCodes.add(cCode.trim().toUpperCase())) {
                    continue;
                }

                String cat = "GENERAL";
                if (itemHonors.equals("HONORS") || bucketCode.startsWith("H")) {
                    cat = "HONORS";
                } else if (bucketCode.contains("SPEC") || bucketName.toLowerCase().contains("specialization")) {
                    cat = "SPECIALIZATION";
                } else if (isMand || bucketCode.contains("CORE") || bucketCode.startsWith("PCC") || bucketCode.startsWith("ESC") || bucketCode.startsWith("BSC") || bucketName.toLowerCase().contains("core")) {
                    cat = "DEPARTMENT";
                }

                Map<String, Object> cMap = new HashMap<>();
                cMap.put("courseCode", cCode.trim());
                cMap.put("courseName", cName.trim());
                cMap.put("credits", cr);
                cMap.put("bucketName", bucketName);
                cMap.put("bucketCode", bucketCode);
                cMap.put("honorsType", itemHonors);
                cMap.put("isMandatory", isMand);
                cMap.put("category", cat);
                cMap.put("degreeType", degreeType);
                cMap.put("specialization", specialization);
                cMap.put("isCompleted", false);
                curriculumCourses.add(cMap);
            }
        }

        // Fallback to legacy requirementRepository if still empty
        if (curriculumCourses.isEmpty()) {
            List<Requirement> specReqs = requirementRepository.findByDegreeTypeAndSpecialization(degreeType, specialization);
            List<Requirement> honorsReqs = new ArrayList<>();
            if (!"REGULAR".equalsIgnoreCase(honorsType) && !"NONE".equalsIgnoreCase(honorsType)) {
                honorsReqs = requirementRepository.findByDegreeTypeAndSpecializationAndHonorsType(degreeType, specialization, honorsType);
            }
            for (Requirement r : specReqs) {
                if (r.getCourseCode() != null && seenCodes.add(r.getCourseCode().trim().toUpperCase())) {
                    String bName = r.getBucketName() != null ? r.getBucketName().toLowerCase() : "";
                    String cat = (Boolean.TRUE.equals(r.getIsMandatory()) || bName.contains("core")) ? "DEPARTMENT" : "GENERAL";

                    Map<String, Object> cMap = new HashMap<>();
                    cMap.put("courseCode", r.getCourseCode());
                    cMap.put("courseName", r.getCourseName());
                    cMap.put("credits", r.getCredits());
                    cMap.put("bucketName", r.getBucketName());
                    cMap.put("honorsType", r.getHonorsType());
                    cMap.put("isMandatory", r.getIsMandatory());
                    cMap.put("category", cat);
                    cMap.put("degreeType", r.getDegreeType());
                    cMap.put("specialization", r.getSpecialization());
                    cMap.put("isCompleted", false);
                    curriculumCourses.add(cMap);
                }
            }
            for (Requirement r : honorsReqs) {
                if (r.getCourseCode() != null && seenCodes.add(r.getCourseCode().trim().toUpperCase())) {
                    Map<String, Object> cMap = new HashMap<>();
                    cMap.put("courseCode", r.getCourseCode());
                    cMap.put("courseName", r.getCourseName());
                    cMap.put("credits", r.getCredits());
                    cMap.put("bucketName", r.getBucketName());
                    cMap.put("honorsType", r.getHonorsType());
                    cMap.put("isMandatory", r.getIsMandatory());
                    cMap.put("category", "HONORS");
                    cMap.put("degreeType", r.getDegreeType());
                    cMap.put("specialization", r.getSpecialization());
                    cMap.put("isCompleted", false);
                    curriculumCourses.add(cMap);
                }
            }
        }

        // Calculate authoritative credit totals
        double totalObtainedCredits = 0.0;
        int deptCount = 0;
        double deptCredits = 0.0;
        int genCount = 0;
        double genCredits = 0.0;
        int specCount = 0;
        double specCredits = 0.0;
        int honCount = 0;
        double honCredits = 0.0;

        for (Map<String, Object> c : curriculumCourses) {
            Number crNum = (Number) c.get("credits");
            double cr = crNum != null ? crNum.doubleValue() : 0.0;
            String cat = (String) c.get("category");
            boolean isComp = Boolean.TRUE.equals(c.get("isCompleted")) || completedCodes.contains(String.valueOf(c.get("courseCode")).trim().toUpperCase());
            if (isComp) {
                totalObtainedCredits += cr;
            }
            if ("DEPARTMENT".equals(cat)) {
                deptCount++;
                deptCredits += cr;
            } else if ("SPECIALIZATION".equals(cat)) {
                specCount++;
                specCredits += cr;
            } else if ("HONORS".equals(cat)) {
                honCount++;
                honCredits += cr;
            } else {
                genCount++;
                genCredits += cr;
            }
        }

        Map<String, Object> studentMap = new HashMap<>();
        studentMap.put("id", s.getId());
        studentMap.put("studentId", s.getStudentId());
        studentMap.put("firstName", s.getFirstName());
        studentMap.put("lastName", s.getLastName());
        studentMap.put("email", s.getEmail());
        studentMap.put("department", s.getDepartment());
        studentMap.put("academicYear", s.getAcademicYear());
        studentMap.put("specializationName", s.getSpecializationName());
        studentMap.put("specializationType", s.getSpecializationType());

        Map<String, Object> response = new HashMap<>();
        DegreePath dp = degreePathEngine != null ? degreePathEngine.findMatchingDegreePath(s) : null;
        int totalReq = degreePathEngine != null ? degreePathEngine.getRequiredCreditsForStudent(s) : ("AIDS".equalsIgnoreCase(dept) ? 166 : 163);
        String pathCode = dp != null ? dp.getPathCode() : (dept + "-" + honorsType);
        String academicYear = dp != null && dp.getAcademicYear() != null ? dp.getAcademicYear() : (degreePathEngine != null ? degreePathEngine.resolveAcademicYear(s) : "Y23");

        int totalCoursesCount = curriculumCourses.size();
        int obtainedCrInt = (int) Math.round(totalObtainedCredits);
        int remainingCrInt = Math.max(0, totalReq - obtainedCrInt);
        int completionPct = totalReq > 0 ? (int) Math.round(((double) obtainedCrInt / (double) totalReq) * 100.0) : 0;

        studentMap.put("pathCode", pathCode);
        studentMap.put("academicYear", academicYear);
        studentMap.put("totalRequiredCredits", totalReq);

        response.put("studentId", s.getStudentId());
        String fullName = ((s.getFirstName() != null ? s.getFirstName() : "") + " " + (s.getLastName() != null ? s.getLastName() : "")).trim();
        response.put("studentName", fullName.isEmpty() ? s.getStudentId() : fullName);
        response.put("student", studentMap);
        response.put("degreeType", degreeType);
        response.put("specialization", specialization);
        response.put("honorsType", honorsType);
        response.put("department", dept);
        response.put("specializationName", specName);
        response.put("specializationType", specType);
        response.put("completedCourseCodes", completedCodes);
        response.put("courses", curriculumCourses);

        response.put("totalCourses", totalCoursesCount);
        response.put("totalRequiredCredits", totalReq);
        response.put("totalObtainedCredits", obtainedCrInt);
        response.put("totalRemainingCredits", remainingCrInt);
        response.put("completionPercentage", completionPct);

        response.put("deptCoursesCount", deptCount);
        response.put("deptCredits", (int) Math.round(deptCredits));
        response.put("generalCoursesCount", genCount);
        response.put("generalCredits", (int) Math.round(genCredits));
        response.put("specializationCoursesCount", specCount);
        response.put("specializationCredits", (int) Math.round(specCredits));
        response.put("honorsCoursesCount", honCount);
        response.put("honorsCredits", (int) Math.round(honCredits));

        response.put("pathCode", pathCode);
        response.put("academicYear", academicYear);
        return response;
    }
}
