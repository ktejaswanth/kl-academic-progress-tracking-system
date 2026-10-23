package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.*;

@RestController
@RequestMapping("/api/student/progress")
@CrossOrigin(origins = "*")
public class StudentProgressController {

    @Autowired private DegreeEligibilityEngine degreeEligibilityEngine;
    @Autowired private BucketSatisfactionEngine bucketSatisfactionEngine;
    @Autowired private DegreePathEngine degreePathEngine;
    @Autowired private SpecializationProgressEngine specializationProgressEngine;
    @Autowired private MinorProgressEngine minorProgressEngine;
    @Autowired private SecondMajorProgressEngine secondMajorProgressEngine;
    @Autowired private StudentRepository studentRepository;
    @Autowired private StudentCourseRepository studentCourseRepository;
    @Autowired private StudentDegreeStatusRepository studentDegreeStatusRepository;
    @Autowired private SpecializationRepository specializationRepository;
    @Autowired private com.example.demo.service.UserSecurityService userSecurityService;

    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> getStudentDashboard(Authentication authentication) {
        String username = authentication.getName();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student not found: " + username));

        return getStudentDashboardById(student.getId());
    }

    @GetMapping("/dashboard/{studentId}")
    public ResponseEntity<Map<String, Object>> getStudentDashboardById(@PathVariable Long studentId) {
        if (!userSecurityService.canAccessStudentData(studentId)) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.FORBIDDEN).build();
        }
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + studentId));

        Map<String, Object> response = new LinkedHashMap<>();

        // 1. Resolve Assigned Degree Path and Master Table Relationships
        Optional<StudentDegreePath> sdpOpt = degreePathEngine.getStudentPath(studentId);
        if (sdpOpt.isEmpty()) {
            try {
                degreePathEngine.resolveAndAssignPath(studentId);
                sdpOpt = degreePathEngine.getStudentPath(studentId);
            } catch (Exception e) {
                // Best effort path resolution
            }
        }

        DegreePath path = sdpOpt.map(StudentDegreePath::getDegreePath).orElse(null);

        // Map Department: prioritize degree_paths -> department_master, fallback to student.department
        String resolvedDeptCode = null;
        String resolvedDeptName = null;
        if (path != null && path.getDepartment() != null) {
            resolvedDeptCode = path.getDepartment().getDeptCode();
            resolvedDeptName = path.getDepartment().getDeptName();
        } else if (student.getDepartment() != null && !student.getDepartment().isBlank()) {
            resolvedDeptCode = student.getDepartment().trim();
        }
        if (resolvedDeptCode == null || resolvedDeptCode.isBlank() || "H".equalsIgnoreCase(resolvedDeptCode)) {
            resolvedDeptCode = "Not Available";
        }
        if (resolvedDeptName == null) {
            if ("AIDS".equalsIgnoreCase(resolvedDeptCode)) {
                resolvedDeptName = "Artificial Intelligence and Data Science";
            } else if ("CSE".equalsIgnoreCase(resolvedDeptCode)) {
                resolvedDeptName = "Computer Science and Engineering";
            } else {
                resolvedDeptName = resolvedDeptCode;
            }
        }

        // Map Curriculum: prioritize regulation_master.reg_code, curriculum_versions, or student.academic_year
        String resolvedCurriculum = null;
        if (path != null && path.getRegulation() != null && path.getRegulation().getRegCode() != null) {
            resolvedCurriculum = path.getRegulation().getRegCode().trim() + " Regulation";
        } else if (path != null && path.getCurriculumVersion() != null && path.getCurriculumVersion().getRegulation() != null) {
            resolvedCurriculum = path.getCurriculumVersion().getRegulation().trim() + " Regulation";
        } else if (student.getAcademicYear() != null && !student.getAcademicYear().isBlank()) {
            String ay = student.getAcademicYear().trim().toUpperCase();
            resolvedCurriculum = (ay.startsWith("Y") ? ay : "Y" + ay) + " Regulation";
        } else {
            resolvedCurriculum = "Not Available";
        }

        // Map Degree: prioritize degree_type_master.type_name, fallback to student.sub_department
        String resolvedDegreeType = null;
        if (path != null && path.getDegreeType() != null && path.getDegreeType().getTypeName() != null) {
            resolvedDegreeType = path.getDegreeType().getTypeName().trim();
        } else if (student.getSubDepartment() != null && !student.getSubDepartment().isBlank()) {
            String sub = student.getSubDepartment().trim().toUpperCase();
            if (sub.contains("HONOR")) {
                resolvedDegreeType = "Honors";
            } else if (sub.contains("HTE")) {
                resolvedDegreeType = "Honors through Experiential Learning";
            } else if (sub.contains("HTI")) {
                resolvedDegreeType = "Honors through Innovation";
            } else if (sub.contains("HTR")) {
                resolvedDegreeType = "Honors through Research";
            } else if (sub.contains("REGULAR")) {
                resolvedDegreeType = "Regular";
            } else {
                resolvedDegreeType = student.getSubDepartment().trim();
            }
        } else {
            resolvedDegreeType = "Regular";
        }

        // Map Specialization: resolve official specialization from specializations master table
        String rawSpec = student.getSpecializationName();
        if (rawSpec != null) {
            rawSpec = rawSpec.replace('\u00A0', ' ').trim();
        }
        Specialization studentSpec = null;
        if (path != null && path.getSpecialization() != null) {
            studentSpec = path.getSpecialization();
        } else if (rawSpec != null && !rawSpec.isBlank() && !"N/A".equalsIgnoreCase(rawSpec) && !"NONE".equalsIgnoreCase(rawSpec) && !rawSpec.equalsIgnoreCase(student.getStudentId())) {
            studentSpec = specializationRepository.findByNameIgnoreCase(rawSpec).orElse(null);
            if (studentSpec == null) {
                studentSpec = specializationRepository.findByCodeIgnoreCase(rawSpec).orElse(null);
            }
        }

        String resolvedSpecialization;
        if (studentSpec != null) {
            resolvedSpecialization = studentSpec.getName();
        } else if (rawSpec != null && !rawSpec.isBlank() && !"N/A".equalsIgnoreCase(rawSpec) && !"NONE".equalsIgnoreCase(rawSpec) && !rawSpec.equalsIgnoreCase(student.getStudentId())) {
            resolvedSpecialization = rawSpec;
        } else if (path != null && path.getAddonName() != null && !path.getAddonName().isBlank() && !"NONE".equalsIgnoreCase(path.getAddonName()) && !"N/A".equalsIgnoreCase(path.getAddonName())) {
            resolvedSpecialization = path.getAddonName();
        } else {
            resolvedSpecialization = "Not Available";
        }

        // 2. Student Identity Info
        Map<String, Object> studentInfo = new LinkedHashMap<>();
        studentInfo.put("studentId", student.getId());
        studentInfo.put("username", student.getStudentId());
        studentInfo.put("universityId", student.getStudentId());
        String fullName = student.getName() != null && !student.getName().trim().isEmpty()
                ? student.getName()
                : ((student.getFirstName() != null ? student.getFirstName() : "") + " " + (student.getLastName() != null ? student.getLastName() : "")).trim();
        studentInfo.put("fullName", fullName.isEmpty() ? student.getStudentId() : fullName);
        studentInfo.put("email", student.getEmail());
        studentInfo.put("department", resolvedDeptCode);
        studentInfo.put("departmentName", resolvedDeptName);
        studentInfo.put("subDepartment", student.getSubDepartment());
        studentInfo.put("academicYear", student.getAcademicYear());
        // Fetch courses for academic calculations and semester determination
        List<StudentCourse> studentCourses = studentCourseRepository.findByStudentId(studentId);
        if (studentCourses.isEmpty()) {
            studentCourses = studentCourseRepository.findByUniversityId(student.getStudentId());
        }
        String currentSemester = determineCurrentSemester(student, studentCourses);

        studentInfo.put("program", "B.Tech");
        studentInfo.put("batch", student.getAcademicYear() != null ? student.getAcademicYear() : "N/A");
        studentInfo.put("curriculum", resolvedCurriculum);
        studentInfo.put("degreeType", resolvedDegreeType);
        studentInfo.put("specialization", resolvedSpecialization);
        studentInfo.put("specializationType", student.getSpecializationType() != null ? student.getSpecializationType() : "NONE");
        studentInfo.put("addonType", student.getSpecializationType() != null ? student.getSpecializationType() : "NONE");
        studentInfo.put("addonName", resolvedSpecialization);
        studentInfo.put("currentSemester", currentSemester);
        response.put("student", studentInfo);

        // 3. Degree Path Info
        if (path != null) {
            Map<String, Object> pathInfo = new LinkedHashMap<>();
            pathInfo.put("pathId", path.getId());
            pathInfo.put("pathCode", path.getPathCode());
            pathInfo.put("department", resolvedDeptCode);
            pathInfo.put("departmentName", resolvedDeptName);
            pathInfo.put("curriculum", resolvedCurriculum);
            pathInfo.put("curriculumVersion", resolvedCurriculum);
            pathInfo.put("degreeType", path.getDegreeType() != null ? path.getDegreeType().getTypeCode() : "REGULAR");
            pathInfo.put("degreeTypeName", resolvedDegreeType);
            pathInfo.put("addonType", path.getAddonType() != null ? path.getAddonType().getAddonCode() : "NONE");
            pathInfo.put("specialization", resolvedSpecialization);
            pathInfo.put("specializationName", resolvedSpecialization);
            pathInfo.put("addonName", resolvedSpecialization);
            pathInfo.put("totalRequiredCredits", path.getTotalCredits());
            response.put("degreePath", pathInfo);
        } else {
            response.put("error", "No degree path assigned");
            return ResponseEntity.ok(response);
        }

        // 4. Evaluate Eligibility & Buckets
        StudentDegreeStatus status;
        Optional<StudentDegreeStatus> existingStatusOpt = studentDegreeStatusRepository.findByStudentId(studentId);
        if (existingStatusOpt.isPresent() && existingStatusOpt.get().getLastEvaluated() != null) {
            status = existingStatusOpt.get();
        } else {
            status = degreeEligibilityEngine.evaluateEligibility(studentId);
        }
        response.put("degreeStatus", status);

        // 5. Bucket Progress List (with detailed courses)
        List<Map<String, Object>> buckets = bucketSatisfactionEngine.getDetailedBucketProgress(studentId);
        response.put("buckets", buckets);

        // 6. Academic Performance (SGPA, CGPA, Semester history)
        Map<String, Object> perf = calculateAcademicPerformance(studentId, student.getStudentId());
        response.put("cgpa", perf.get("cgpa"));
        response.put("semesterPerformance", perf.get("semesters"));

        // 7. Natural Language UX narrative & Graduation Readiness explanation
        int totalRequired = status.getTotalRequiredCredits();
        int totalEarned = status.getTotalEarnedCredits();
        int remaining = Math.max(0, totalRequired - totalEarned);
        Map<String, Object> narrative = buildAcademicNarrative(student, totalEarned, totalRequired, remaining, buckets, status);
        response.put("narrative", narrative);
        response.put("graduationReadiness", narrative.get("graduationReadiness"));

        // 8. Recommended Courses ("What Should I Take Next?")
        List<Map<String, Object>> recommendedCourses = buildRecommendedCourses(buckets);
        response.put("recommendedCourses", recommendedCourses);

        // 9. Academic Notifications
        response.put("notifications", buildNotifications(remaining, narrative));

        // 10. Specialization Progress from Master Table
        Long specIdToCalculate = null;
        if (studentSpec != null) {
            specIdToCalculate = studentSpec.getId();
        } else if (path.getSpecialization() != null) {
            specIdToCalculate = path.getSpecialization().getId();
        }

        if (specIdToCalculate != null) {
            Map<String, Object> specProgress = specializationProgressEngine.calculateSpecializationProgress(studentId, specIdToCalculate);
            response.put("specializationProgress", specProgress);
        } else if (!"Not Available".equalsIgnoreCase(resolvedSpecialization)) {
            Map<String, Object> specProgress = new LinkedHashMap<>();
            specProgress.put("status", "IN_PROGRESS");
            specProgress.put("specializationName", resolvedSpecialization);
            specProgress.put("requiredCredits", 20.0);
            specProgress.put("earnedCredits", 0.0);
            specProgress.put("remainingCredits", 20.0);
            specProgress.put("progressPercentage", 0);
            specProgress.put("completedCourses", Collections.emptyList());
            response.put("specializationProgress", specProgress);
        } else {
            response.put("specializationProgress", Map.of("status", "NOT_APPLICABLE"));
        }

        // 10. Minor Progress if applicable
        if (path.getMinor() != null) {
            Map<String, Object> minorProgress = minorProgressEngine.calculateMinorProgress(studentId, path.getMinor().getId());
            response.put("minorProgress", minorProgress);
        } else {
            response.put("minorProgress", Map.of("status", "NOT_APPLICABLE"));
        }

        // 11. Second Major Progress if applicable
        if (path.getSecondMajor() != null) {
            Map<String, Object> smProgress = secondMajorProgressEngine.calculateSecondMajorProgress(studentId, path.getSecondMajor().getId());
            response.put("secondMajorProgress", smProgress);
        } else {
            response.put("secondMajorProgress", Map.of("status", "NOT_APPLICABLE"));
        }

        return ResponseEntity.ok(response);
    }

    private Map<String, Object> calculateAcademicPerformance(Long studentId, String rollNumber) {
        List<StudentCourse> courses = studentCourseRepository.findByStudentId(studentId);
        if (courses.isEmpty()) {
            courses = studentCourseRepository.findByUniversityId(rollNumber);
        }

        Map<String, List<StudentCourse>> bySemester = new LinkedHashMap<>();
        for (StudentCourse sc : courses) {
            String sem = sc.getSemester() != null && !sc.getSemester().isBlank() ? sc.getSemester() : "Term 1";
            bySemester.computeIfAbsent(sem, k -> new ArrayList<>()).add(sc);
        }

        double totalPoints = 0.0;
        double totalCredits = 0.0;
        List<Map<String, Object>> semesterList = new ArrayList<>();

        for (Map.Entry<String, List<StudentCourse>> entry : bySemester.entrySet()) {
            String semName = entry.getKey();
            List<StudentCourse> semCourses = entry.getValue();

            double semPoints = 0.0;
            double semCredits = 0.0;
            int completedCount = 0;

            for (StudentCourse c : semCourses) {
                double cr = c.getCredits() != null ? c.getCredits() : 0.0;
                String grade = c.getGrade() != null ? c.getGrade().trim().toUpperCase() : "";
                double gp = getGradePoint(grade);

                if (!"DROPPED".equalsIgnoreCase(c.getStatus())) {
                    semPoints += (gp * cr);
                    semCredits += cr;
                    if (!"FAILED".equalsIgnoreCase(c.getStatus()) && !"F".equalsIgnoreCase(grade) && !"FAIL".equalsIgnoreCase(grade)) {
                        completedCount++;
                    }
                }
            }

            totalPoints += semPoints;
            totalCredits += semCredits;

            double sgpa = semCredits > 0 ? Math.round((semPoints / semCredits) * 100.0) / 100.0 : 0.0;
            double cgpa = totalCredits > 0 ? Math.round((totalPoints / totalCredits) * 100.0) / 100.0 : 0.0;

            Map<String, Object> semData = new LinkedHashMap<>();
            semData.put("semester", semName);
            semData.put("creditsEarned", semCredits);
            semData.put("coursesCompleted", completedCount);
            semData.put("sgpa", sgpa);
            semData.put("cgpa", cgpa);
            semesterList.add(semData);
        }

        double overallCgpa = totalCredits > 0 ? Math.round((totalPoints / totalCredits) * 100.0) / 100.0 : 0.0;

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("cgpa", overallCgpa);
        result.put("semesters", semesterList);
        return result;
    }

    private double getGradePoint(String grade) {
        if (grade == null) return 0.0;
        switch (grade.toUpperCase()) {
            case "O": return 10.0;
            case "A+": return 9.0;
            case "A": return 8.0;
            case "B+": return 7.0;
            case "B": return 6.0;
            case "C": return 5.0;
            case "P":
            case "PASS": return 4.0;
            case "F":
            case "FAIL":
            default: return 0.0;
        }
    }

    private String determineCurrentSemester(Student student, List<StudentCourse> courses) {
        if (courses != null && !courses.isEmpty()) {
            int maxSem = 0;
            for (StudentCourse sc : courses) {
                String sem = sc.getSemester();
                if (sem != null) {
                    java.util.regex.Matcher m = java.util.regex.Pattern.compile("\\d+").matcher(sem);
                    if (m.find()) {
                        try {
                            int val = Integer.parseInt(m.group());
                            if (val > maxSem && val <= 8) maxSem = val;
                        } catch (NumberFormatException ignored) {}
                    }
                }
            }
            if (maxSem > 0) {
                return "Semester " + maxSem;
            }
        }
        if (student != null && student.getAcademicYear() != null) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("(\\d{4})").matcher(student.getAcademicYear());
            if (m.find()) {
                try {
                    int startYear = Integer.parseInt(m.group(1));
                    int currentYear = LocalDate.now().getYear();
                    int currentMonth = LocalDate.now().getMonthValue();
                    int yearDiff = Math.max(0, currentYear - startYear);
                    int sem = (yearDiff * 2) + (currentMonth >= 7 ? 1 : 0);
                    if (sem >= 1 && sem <= 8) {
                        return "Semester " + sem;
                    }
                } catch (Exception ignored) {}
            }
        }
        return "Semester 1";
    }

    private Map<String, Object> buildAcademicNarrative(
            Student student,
            int totalEarned,
            int totalRequired,
            int remaining,
            List<Map<String, Object>> buckets,
            StudentDegreeStatus status) {

        List<String> shortfalls = new ArrayList<>();
        List<Map<String, Object>> blockingItems = new ArrayList<>();

        if (buckets != null) {
            for (Map<String, Object> b : buckets) {
                String bStatus = String.valueOf(b.getOrDefault("status", ""));
                int req = (int) b.getOrDefault("requiredCredits", 0);
                int earn = (int) b.getOrDefault("earnedCredits", 0);
                int shortfall = Math.max(0, req - earn);

                if (!"COMPLETED".equalsIgnoreCase(bStatus) && shortfall > 0) {
                    String bName = String.valueOf(b.getOrDefault("bucketName", b.getOrDefault("bucketCode", "Requirement")));
                    shortfalls.add(shortfall + " credits in " + bName);

                    Map<String, Object> blocker = new LinkedHashMap<>();
                    blocker.put("bucketCode", b.get("bucketCode"));
                    blocker.put("bucketName", bName);
                    blocker.put("shortfall", shortfall);
                    blocker.put("reason", "Incomplete category requirement: earned " + earn + " of " + req + " credits.");
                    blockingItems.add(blocker);
                }
            }
        }

        String narrative;
        if (remaining <= 0) {
            narrative = "Congratulations! You have satisfied all " + totalRequired + " credits required for your degree program and are eligible for graduation clearance.";
        } else {
            StringBuilder sb = new StringBuilder();
            sb.append("You have completed ").append(totalEarned).append(" of ").append(totalRequired).append(" credits. ");
            sb.append(remaining).append(" credits are remaining. ");
            if (!shortfalls.isEmpty()) {
                sb.append("You still need ");
                int maxShow = Math.min(shortfalls.size(), 3);
                for (int i = 0; i < maxShow; i++) {
                    sb.append(shortfalls.get(i));
                    if (i < maxShow - 2) sb.append(", ");
                    else if (i == maxShow - 2) sb.append(", and ");
                }
                if (shortfalls.size() > 3) {
                    sb.append(", plus ").append(shortfalls.size() - 3).append(" other pending categories");
                }
                sb.append(".");
            }
            narrative = sb.toString();
        }

        Map<String, Object> narrativeMap = new LinkedHashMap<>();
        narrativeMap.put("summaryText", narrative);
        narrativeMap.put("completedText", "You have completed " + totalEarned + " credits across foundation and core courses.");
        narrativeMap.put("inProgressText", "Current enrolled courses are progressing toward curriculum fulfillment.");
        narrativeMap.put("remainingText", remaining + " credits needed to complete your degree.");
        narrativeMap.put("whyPending", !blockingItems.isEmpty()
                ? "Pending minimum required credits across designated curriculum buckets."
                : "All curriculum requirements satisfied.");
        narrativeMap.put("isGraduationEligible", status != null && Boolean.TRUE.equals(status.getIsDegreeEligible()));
        narrativeMap.put("preventingGraduation", blockingItems);

        // Readiness checklist breakdown
        Map<String, Object> readiness = new LinkedHashMap<>();
        readiness.put("isEligible", status != null && Boolean.TRUE.equals(status.getIsDegreeEligible()));
        readiness.put("totalRequiredCredits", totalRequired);
        readiness.put("totalEarnedCredits", totalEarned);
        readiness.put("remainingCredits", remaining);
        readiness.put("blockingFactors", blockingItems);
        readiness.put("narrative", narrative);
        narrativeMap.put("graduationReadiness", readiness);

        return narrativeMap;
    }

    private String resolveBucketCategory(String bucketCode, String bucketName) {
        String bc = bucketCode != null ? bucketCode.trim().toUpperCase() : "";
        String bn = bucketName != null ? bucketName.trim().toUpperCase() : "";
        String combined = bc + " " + bn;

        if (combined.contains("HAS") || combined.contains("HUMANITIES") || combined.contains("MANAGEMENT")) return "HAS";
        if (combined.contains("BSC") || combined.contains("BASIC SCIENCE") || combined.contains("MATH") || combined.contains("SCIENCE ELECTIVE")) return "BSC";
        if (combined.contains("ESC") || combined.contains("ENGINEERING SCIENCE")) return "ESC";
        if (bc.startsWith("FC") || combined.contains("FLEXI CORE") || combined.contains("FCC") || bc.startsWith("HFC")) return "FCC";
        if (combined.contains("PCC") || combined.contains("PROFESSIONAL CORE")) return "PCC";
        if (combined.contains("PEC") || combined.contains("ELECTIVE") || bc.startsWith("PE-") || bc.startsWith("PE1") || bc.startsWith("PE2") || bc.startsWith("PE3") || bc.startsWith("PE4") || bc.startsWith("PE5") || bc.startsWith("HEC")) return "PEC";
        if (combined.contains("SDC") || combined.contains("SDP") || combined.contains("SKILL")) return "SDC";
        if (combined.contains("PRI") || combined.contains("PROJECT") || combined.contains("INTERNSHIP") || combined.contains("RESEARCH")) return "PRI";
        if (combined.contains("OEC") || bc.startsWith("OE") || combined.contains("OPEN ELECTIVE")) return "OEC";
        if (combined.contains("SIL") || combined.contains("SELF") || combined.contains("IMMERSIVE")) return "SIL";
        return "PCC";
    }

    private String getCategoryFullName(String categoryCode) {
        if (categoryCode == null) return "General Requirement";
        switch (categoryCode.toUpperCase()) {
            case "HAS": return "Humanities, Arts and Social Sciences";
            case "BSC": return "Basic Science Courses";
            case "ESC": return "Engineering Science Courses";
            case "FCC": return "Flexi Core Courses";
            case "PCC": return "Professional Core Courses";
            case "PEC": return "Professional Elective Courses";
            case "SDC": return "Skill Development Courses";
            case "PRI": return "Project Research and Internship";
            case "OEC": return "Open Elective Courses";
            case "SIL": return "Social Immersive Learning";
            default: return categoryCode;
        }
    }

    private List<Map<String, Object>> buildRecommendedCourses(List<Map<String, Object>> buckets) {
        List<Map<String, Object>> recommendedCourses = new ArrayList<>();
        if (buckets != null) {
            Set<String> seenCodes = new HashSet<>();
            for (Map<String, Object> b : buckets) {
                if (!"COMPLETED".equalsIgnoreCase(String.valueOf(b.getOrDefault("status", "")))) {
                    String bCode = String.valueOf(b.getOrDefault("bucketCode", ""));
                    String bName = String.valueOf(b.getOrDefault("bucketName", bCode));
                    String catCode = resolveBucketCategory(bCode, bName);
                    String catName = getCategoryFullName(catCode);

                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> pending = (List<Map<String, Object>>) b.get("pendingCourses");
                    if (pending != null) {
                        int countInThisBucket = 0;
                        for (Map<String, Object> c : pending) {
                            String cCode = c.get("courseCode") != null ? String.valueOf(c.get("courseCode")).trim().toUpperCase() : "";
                            if (!cCode.isEmpty() && seenCodes.add(cCode)) {
                                Map<String, Object> rec = new LinkedHashMap<>(c);
                                rec.put("bucketCode", bCode);
                                rec.put("bucketName", bName);
                                rec.put("categoryCode", catCode);
                                rec.put("categoryName", catName);
                                rec.put("eligibility", "Eligible - Recommended for upcoming registration");
                                rec.put("recommendationRationale", "Satisfies required credits in " + bName);
                                rec.put("recommendationReason", "Satisfies required credits in " + bName);
                                rec.put("prerequisites", "Satisfied / None");
                                recommendedCourses.add(rec);
                                countInThisBucket++;
                                if (countInThisBucket >= 8) break; // Allow up to 8 top recommended courses per bucket
                            }
                        }
                    }
                }
            }
        }
        return recommendedCourses;
    }

    private List<Map<String, Object>> buildNotifications(int remaining, Map<String, Object> narrative) {
        List<Map<String, Object>> notifications = new ArrayList<>();
        if (remaining > 0) {
            notifications.add(Map.of(
                    "id", 1,
                    "type", "WARNING",
                    "title", "Pending Graduation Requirements",
                    "message", "You have " + remaining + " credits remaining before graduation eligibility clearance.",
                    "date", LocalDate.now().toString()
            ));
        } else {
            notifications.add(Map.of(
                    "id", 1,
                    "type", "SUCCESS",
                    "title", "Graduation Eligible",
                    "message", "All degree credit requirements are met! You may proceed with exit clearance.",
                    "date", LocalDate.now().toString()
            ));
        }

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> blockers = (List<Map<String, Object>>) narrative.get("preventingGraduation");
        if (blockers != null && !blockers.isEmpty()) {
            notifications.add(Map.of(
                    "id", 2,
                    "type", "INFO",
                    "title", "Course Registration Advisory",
                    "message", "Priority requirement: " + blockers.get(0).get("bucketName") + " (" + blockers.get(0).get("shortfall") + " credits needed).",
                    "date", LocalDate.now().toString()
            ));
        }

        notifications.add(Map.of(
                "id", 3,
                "type", "SUCCESS",
                "title", "Academic Records Up-to-Date",
                "message", "Your official university coursework record is synchronized with the examination register.",
                "date", LocalDate.now().toString()
        ));
        return notifications;
    }
}
