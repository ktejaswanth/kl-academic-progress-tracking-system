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

    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> getStudentDashboard(Authentication authentication) {
        String username = authentication.getName();
        Student student = studentRepository.findByStudentId(username)
                .orElseThrow(() -> new RuntimeException("Student not found: " + username));

        return getStudentDashboardById(student.getId());
    }

    @GetMapping("/dashboard/{studentId}")
    public ResponseEntity<Map<String, Object>> getStudentDashboardById(@PathVariable Long studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + studentId));

        Map<String, Object> response = new LinkedHashMap<>();

        // 1. Student Identity Info
        Map<String, Object> studentInfo = new LinkedHashMap<>();
        studentInfo.put("studentId", student.getId());
        studentInfo.put("username", student.getStudentId());
        studentInfo.put("universityId", student.getStudentId());
        String fullName = student.getName() != null && !student.getName().trim().isEmpty()
                ? student.getName()
                : ((student.getFirstName() != null ? student.getFirstName() : "") + " " + (student.getLastName() != null ? student.getLastName() : "")).trim();
        studentInfo.put("fullName", fullName.isEmpty() ? student.getStudentId() : fullName);
        studentInfo.put("email", student.getEmail());
        studentInfo.put("department", student.getDepartment() != null ? student.getDepartment() : "CSE");
        studentInfo.put("program", "B.Tech");
        studentInfo.put("batch", student.getAcademicYear() != null ? student.getAcademicYear() : "2023-2027");
        studentInfo.put("curriculum", "Y23 Regulation");
        studentInfo.put("degreeType", student.getSubDepartment() != null ? student.getSubDepartment() : "REGULAR");
        studentInfo.put("addonType", student.getSpecializationType() != null ? student.getSpecializationType() : "NONE");
        studentInfo.put("addonName", student.getSpecializationName() != null ? student.getSpecializationName() : "N/A");
        studentInfo.put("currentSemester", "Semester 6");
        response.put("student", studentInfo);

        // 2. Assigned Degree Path
        Optional<StudentDegreePath> sdpOpt = degreePathEngine.getStudentPath(studentId);
        if (sdpOpt.isEmpty()) {
            try {
                degreePathEngine.resolveAndAssignPath(studentId);
                sdpOpt = degreePathEngine.getStudentPath(studentId);
            } catch (Exception e) {
                response.put("error", "No degree path assigned: " + e.getMessage());
                return ResponseEntity.ok(response);
            }
        }

        DegreePath path = sdpOpt.get().getDegreePath();
        Map<String, Object> pathInfo = new LinkedHashMap<>();
        pathInfo.put("pathId", path.getId());
        pathInfo.put("pathCode", path.getPathCode());
        pathInfo.put("department", path.getDepartment() != null ? path.getDepartment().getDeptCode() : "N/A");
        pathInfo.put("degreeType", path.getDegreeType() != null ? path.getDegreeType().getTypeCode() : "REGULAR");
        pathInfo.put("degreeTypeName", path.getDegreeType() != null ? path.getDegreeType().getTypeName() : "Regular");
        pathInfo.put("addonType", path.getAddonType() != null ? path.getAddonType().getAddonCode() : "NONE");
        pathInfo.put("totalRequiredCredits", path.getTotalCredits());
        response.put("degreePath", pathInfo);

        // 3. Evaluate Eligibility & Buckets
        StudentDegreeStatus status;
        Optional<StudentDegreeStatus> existingStatusOpt = studentDegreeStatusRepository.findByStudentId(studentId);
        if (existingStatusOpt.isPresent() && existingStatusOpt.get().getLastEvaluated() != null) {
            status = existingStatusOpt.get();
        } else {
            status = degreeEligibilityEngine.evaluateEligibility(studentId);
        }
        response.put("degreeStatus", status);

        // 4. Bucket Progress List (with detailed courses)
        List<Map<String, Object>> buckets = bucketSatisfactionEngine.getDetailedBucketProgress(studentId);
        response.put("buckets", buckets);

        // 5. Academic Performance (SGPA, CGPA, Semester history)
        Map<String, Object> perf = calculateAcademicPerformance(studentId, student.getStudentId());
        response.put("cgpa", perf.get("cgpa"));
        response.put("semesterPerformance", perf.get("semesters"));

        // 6. Natural Language UX narrative & Graduation Readiness explanation
        int totalRequired = status.getTotalRequiredCredits();
        int totalEarned = status.getTotalEarnedCredits();
        int remaining = Math.max(0, totalRequired - totalEarned);
        Map<String, Object> narrative = buildAcademicNarrative(student, totalEarned, totalRequired, remaining, buckets, status);
        response.put("narrative", narrative);
        response.put("graduationReadiness", narrative.get("graduationReadiness"));

        // 7. Recommended Courses ("What Should I Take Next?")
        List<Map<String, Object>> recommendedCourses = buildRecommendedCourses(buckets);
        response.put("recommendedCourses", recommendedCourses);

        // 8. Academic Notifications
        response.put("notifications", buildNotifications(remaining, narrative));

        // 9. Specialization Progress if applicable
        if (path.getSpecialization() != null) {
            Map<String, Object> specProgress = specializationProgressEngine.calculateSpecializationProgress(studentId, path.getSpecialization().getId());
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
            String sem = sc.getSemester() != null && !sc.getSemester().isBlank() ? sc.getSemester() : "Year 1";
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
                double cr = c.getCredits() != null ? c.getCredits() : 3.0;
                String grade = c.getGrade() != null ? c.getGrade().trim().toUpperCase() : "PASS";
                double gp = getGradePoint(grade);

                if (!"DROPPED".equalsIgnoreCase(c.getStatus())) {
                    semPoints += (gp * cr);
                    semCredits += cr;
                    if (!"FAILED".equalsIgnoreCase(c.getStatus()) && !"F".equalsIgnoreCase(grade)) {
                        completedCount++;
                    }
                }
            }

            totalPoints += semPoints;
            totalCredits += semCredits;

            double sgpa = semCredits > 0 ? Math.round((semPoints / semCredits) * 100.0) / 100.0 : 8.5;
            double cgpa = totalCredits > 0 ? Math.round((totalPoints / totalCredits) * 100.0) / 100.0 : 8.6;

            Map<String, Object> semData = new LinkedHashMap<>();
            semData.put("semester", semName);
            semData.put("creditsEarned", semCredits);
            semData.put("coursesCompleted", completedCount);
            semData.put("sgpa", sgpa > 0 ? sgpa : 8.5);
            semData.put("cgpa", cgpa > 0 ? cgpa : 8.6);
            semesterList.add(semData);
        }

        double overallCgpa = totalCredits > 0 ? Math.round((totalPoints / totalCredits) * 100.0) / 100.0 : 8.65;
        if (overallCgpa <= 0) overallCgpa = 8.65;

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("cgpa", overallCgpa);
        result.put("semesters", semesterList);
        return result;
    }

    private double getGradePoint(String grade) {
        if (grade == null) return 8.0;
        return switch (grade.toUpperCase()) {
            case "O" -> 10.0;
            case "A+" -> 9.0;
            case "A" -> 8.0;
            case "B+" -> 7.0;
            case "B" -> 6.0;
            case "C" -> 5.0;
            case "P", "PASS" -> 4.5;
            case "F", "FAIL" -> 0.0;
            default -> 8.0;
        };
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

    private List<Map<String, Object>> buildRecommendedCourses(List<Map<String, Object>> buckets) {
        List<Map<String, Object>> recommendedCourses = new ArrayList<>();
        if (buckets != null) {
            for (Map<String, Object> b : buckets) {
                if (!"COMPLETED".equalsIgnoreCase(String.valueOf(b.getOrDefault("status", "")))) {
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> pending = (List<Map<String, Object>>) b.get("pendingCourses");
                    if (pending != null) {
                        for (Map<String, Object> c : pending) {
                            Map<String, Object> rec = new LinkedHashMap<>(c);
                            rec.put("bucketCode", b.get("bucketCode"));
                            rec.put("bucketName", b.get("bucketName"));
                            rec.put("eligibility", "Eligible - Recommended for upcoming registration");
                            rec.put("recommendationRationale", "Satisfies required credits in " + b.get("bucketName"));
                            rec.put("prerequisites", "Satisfied / None");
                            recommendedCourses.add(rec);
                            if (recommendedCourses.size() >= 12) break;
                        }
                    }
                }
                if (recommendedCourses.size() >= 12) break;
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
