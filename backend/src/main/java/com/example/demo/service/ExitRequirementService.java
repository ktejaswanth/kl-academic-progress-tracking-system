package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Transactional
public class ExitRequirementService {

    private static final Logger log = LoggerFactory.getLogger(ExitRequirementService.class);

    @Autowired private ExitRequirementMasterRepository requirementMasterRepo;
    @Autowired private StudentExitClearanceRepository exitClearanceRepo;
    @Autowired private StudentExitSummaryRepository exitSummaryRepo;
    @Autowired private StudentRepository studentRepo;
    @Autowired private FacultyRepository facultyRepo;
    @Autowired private StudentDegreeStatusRepository degreeStatusRepo;
    @Autowired private StudentCourseRepository studentCourseRepo;
    @Autowired private DegreeEligibilityEngine degreeEligibilityEngine;
    @Autowired private StudentDegreePathRepository studentDegreePathRepo;
    @Autowired private DegreePathEngine degreePathEngine;

    /**
     * Get or initialize all exit clearances and summary for a student.
     * Evaluates SYSTEM_AUTO rules in real time.
     */
    public Map<String, Object> getStudentExitStatus(Long studentId) {
        Student student = studentRepo.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + studentId));

        List<ExitRequirementMaster> masterReqs = requirementMasterRepo.findAllByOrderByDisplayOrderAsc();
        if (masterReqs.isEmpty()) {
            return Map.of("error", "No exit requirements defined in system.");
        }

        // 1. Ensure clearance rows exist
        List<StudentExitClearance> clearances = exitClearanceRepo.findByStudentIdOrderByRequirement_DisplayOrderAsc(studentId);
        Map<Long, StudentExitClearance> existingMap = new HashMap<>();
        for (StudentExitClearance c : clearances) {
            existingMap.put(c.getRequirement().getId(), c);
        }

        boolean newlyCreated = false;
        for (ExitRequirementMaster req : masterReqs) {
            if (!existingMap.containsKey(req.getId())) {
                StudentExitClearance sec = new StudentExitClearance();
                sec.setStudent(student);
                sec.setRequirement(req);
                sec.setStatus("PENDING");
                exitClearanceRepo.save(sec);
                existingMap.put(req.getId(), sec);
                newlyCreated = true;
            }
        }

        if (newlyCreated) {
            clearances = exitClearanceRepo.findByStudentIdOrderByRequirement_DisplayOrderAsc(studentId);
        }

        // Ensure student has assigned degree path
        if (studentDegreePathRepo.findByStudentId(studentId).isEmpty() && degreePathEngine != null) {
            try {
                degreePathEngine.resolveAndAssignPath(studentId);
            } catch (Exception ignored) {
                // Resolution error handled in downstream evaluations
            }
        }

        // 2. Auto-evaluate SYSTEM_AUTO rules
        autoEvaluateSystemRules(student, clearances);

        // 3. Update overall summary
        StudentExitSummary summary = calculateAndSaveSummary(student, clearances);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("studentId", student.getId());
        response.put("universityId", student.getStudentId());
        response.put("studentName", student.getName());
        response.put("department", student.getDepartment());
        response.put("specialization", student.getSpecializationName());
        response.put("summary", summary);
        response.put("clearances", clearances);
        return response;
    }

    /**
     * Auto evaluate system rules like credit completion and CGPA compliance.
     */
    private void autoEvaluateSystemRules(Student student, List<StudentExitClearance> clearances) {
        for (StudentExitClearance c : clearances) {
            ExitRequirementMaster req = c.getRequirement();
            if ("SYSTEM_AUTO".equalsIgnoreCase(req.getResponsibleRole())) {
                if ("ACAD_CREDITS".equalsIgnoreCase(req.getRequirementCode())) {
                    // Check degree status or evaluate
                    try {
                        StudentDegreeStatus status = degreeStatusRepo.findByStudentId(student.getId()).orElse(null);
                        if (status == null) {
                            status = degreeEligibilityEngine.evaluateEligibility(student.getId());
                        }
                        if (status != null && Boolean.TRUE.equals(status.getIsDegreeEligible())) {
                            c.setStatus("APPROVED");
                            c.setVerifierRole("SYSTEM");
                            c.setVerifiedBy("Academic Audit Engine");
                            c.setVerifiedAt(LocalDateTime.now());
                            c.setRemarks("Verified: Completed " + status.getTotalEarnedCredits() + "/" + status.getTotalRequiredCredits() + " required credits across all buckets.");
                            exitClearanceRepo.save(c);
                        } else if (status != null) {
                            if (!"APPROVED".equals(c.getStatus())) {
                                c.setRemarks("In Progress: " + status.getTotalEarnedCredits() + "/" + status.getTotalRequiredCredits() + " credits earned (" + status.getCompletionPercentage() + "%).");
                                exitClearanceRepo.save(c);
                            }
                        }
                    } catch (Exception e) {
                        log.debug("Auto evaluate credits note for {}: {}", student.getStudentId(), e.getMessage());
                    }
                } else if ("ACAD_CGPA".equalsIgnoreCase(req.getRequirementCode())) {
                    // Check course passing criteria
                    List<StudentCourse> courses = studentCourseRepo.findByStudentId(student.getId());
                    if (courses.isEmpty()) {
                        courses = studentCourseRepo.findByUniversityId(student.getStudentId());
                    }
                    if (!courses.isEmpty()) {
                        long failCount = courses.stream().filter(cr -> "F".equalsIgnoreCase(cr.getGrade()) || "Fail".equalsIgnoreCase(cr.getGrade())).count();
                        if (failCount == 0 && !"APPROVED".equals(c.getStatus())) {
                            c.setStatus("APPROVED");
                            c.setVerifierRole("SYSTEM");
                            c.setVerifiedBy("Examination Cell Engine");
                            c.setVerifiedAt(LocalDateTime.now());
                            c.setRemarks("Verified: All " + courses.size() + " completed courses passed with no active backlogs.");
                            exitClearanceRepo.save(c);
                        }
                    }
                }
            }
        }
    }

    /**
     * Calculates and updates the StudentExitSummary.
     */
    public StudentExitSummary calculateAndSaveSummary(Student student, List<StudentExitClearance> clearances) {
        StudentExitSummary summary = exitSummaryRepo.findByStudentId(student.getId())
                .orElse(new StudentExitSummary());

        summary.setStudent(student);
        int total = clearances.size();
        int approved = 0;
        int mandatoryCount = 0;
        int mandatoryApproved = 0;

        for (StudentExitClearance c : clearances) {
            boolean isApproved = "APPROVED".equalsIgnoreCase(c.getStatus()) || "WAIVED".equalsIgnoreCase(c.getStatus());
            if (isApproved) {
                approved++;
            }
            if (Boolean.TRUE.equals(c.getRequirement().getIsMandatory())) {
                mandatoryCount++;
                if (isApproved) {
                    mandatoryApproved++;
                }
            }
        }

        summary.setTotalRequirements(total);
        summary.setApprovedCount(approved);

        BigDecimal pct = (total > 0)
                ? BigDecimal.valueOf(approved).divide(BigDecimal.valueOf(total), 4, RoundingMode.HALF_UP).multiply(BigDecimal.valueOf(100)).setScale(2, RoundingMode.HALF_UP)
                : BigDecimal.valueOf(100.00);
        summary.setClearancePercentage(pct);

        if (!"CLEARED_FOR_GRADUATION".equals(summary.getOverallStatus())) {
            if (mandatoryCount > 0 && mandatoryApproved == mandatoryCount) {
                summary.setOverallStatus("PENDING_FINAL_APPROVAL");
            } else if (approved > 0 || clearances.stream().anyMatch(c -> "SUBMITTED".equals(c.getStatus()))) {
                summary.setOverallStatus("IN_PROGRESS");
            } else {
                summary.setOverallStatus("NOT_STARTED");
            }
        }

        return exitSummaryRepo.save(summary);
    }

    /**
     * Student submits proof/notes for an exit clearance requirement.
     */
    public StudentExitClearance submitStudentRequirement(Long studentId, Long clearanceId, String notes, String attachmentUrl) {
        StudentExitClearance sec = exitClearanceRepo.findById(clearanceId)
                .orElseThrow(() -> new RuntimeException("Clearance record not found: " + clearanceId));

        if (!sec.getStudent().getId().equals(studentId)) {
            throw new RuntimeException("Unauthorized: This clearance requirement does not belong to you.");
        }

        sec.setSubmissionNotes(notes);
        if (attachmentUrl != null && !attachmentUrl.isBlank()) {
            sec.setAttachmentUrl(attachmentUrl);
        }
        sec.setStatus("SUBMITTED");
        sec.setUpdatedAt(LocalDateTime.now());
        StudentExitClearance saved = exitClearanceRepo.save(sec);

        // Recalculate summary
        List<StudentExitClearance> clearances = exitClearanceRepo.findByStudentIdOrderByRequirement_DisplayOrderAsc(studentId);
        calculateAndSaveSummary(sec.getStudent(), clearances);
        return saved;
    }

    /**
     * Student submits the mandatory university exit survey.
     */
    public StudentExitClearance submitExitSurvey(Long studentId, Map<String, Object> surveyData) {
        Student student = studentRepo.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        ExitRequirementMaster req = requirementMasterRepo.findByRequirementCode("EXIT_SURVEY")
                .orElseThrow(() -> new RuntimeException("Exit Survey requirement not found in system."));

        StudentExitClearance sec = exitClearanceRepo.findByStudentIdAndRequirementId(studentId, req.getId())
                .orElseGet(() -> {
                    StudentExitClearance c = new StudentExitClearance();
                    c.setStudent(student);
                    c.setRequirement(req);
                    return c;
                });

        String satisfaction = String.valueOf(surveyData.getOrDefault("overallSatisfaction", "5/5"));
        String feedback = String.valueOf(surveyData.getOrDefault("feedback", "Completed"));
        String careerPlan = String.valueOf(surveyData.getOrDefault("careerPlan", "Industry Employment"));

        sec.setSubmissionNotes("Satisfaction: " + satisfaction + " | Career Path: " + careerPlan + " | Comments: " + feedback);
        sec.setStatus("APPROVED");
        sec.setVerifierRole("SYSTEM");
        sec.setVerifiedBy("University Survey System");
        sec.setVerifiedAt(LocalDateTime.now());
        sec.setRemarks("Academic exit survey successfully recorded.");
        StudentExitClearance saved = exitClearanceRepo.save(sec);

        List<StudentExitClearance> clearances = exitClearanceRepo.findByStudentIdOrderByRequirement_DisplayOrderAsc(studentId);
        calculateAndSaveSummary(student, clearances);
        return saved;
    }

    /**
     * Faculty or Super Admin reviews, approves, or rejects a clearance requirement.
     */
    public StudentExitClearance reviewClearance(Long clearanceId, String status, String remarks, String verifierUsername, String verifierRole) {
        StudentExitClearance sec = exitClearanceRepo.findById(clearanceId)
                .orElseThrow(() -> new RuntimeException("Clearance record not found: " + clearanceId));

        sec.setStatus(status.toUpperCase().trim());
        sec.setRemarks(remarks);
        sec.setVerifiedBy(verifierUsername);
        sec.setVerifierRole(verifierRole);
        sec.setVerifiedAt(LocalDateTime.now());
        StudentExitClearance saved = exitClearanceRepo.save(sec);

        // Recalculate summary
        List<StudentExitClearance> clearances = exitClearanceRepo.findByStudentIdOrderByRequirement_DisplayOrderAsc(sec.getStudent().getId());
        calculateAndSaveSummary(sec.getStudent(), clearances);
        return saved;
    }

    /**
     * Bulk review of a requirement for multiple students (e.g. Faculty approving Lab Return).
     */
    public int bulkReviewClearances(List<Long> clearanceIds, String status, String remarks, String verifierUsername, String verifierRole) {
        int count = 0;
        Set<Long> affectedStudentIds = new HashSet<>();
        for (Long id : clearanceIds) {
            exitClearanceRepo.findById(id).ifPresent(sec -> {
                sec.setStatus(status.toUpperCase().trim());
                sec.setRemarks(remarks);
                sec.setVerifiedBy(verifierUsername);
                sec.setVerifierRole(verifierRole);
                sec.setVerifiedAt(LocalDateTime.now());
                exitClearanceRepo.save(sec);
                affectedStudentIds.add(sec.getStudent().getId());
            });
            count++;
        }

        for (Long sid : affectedStudentIds) {
            studentRepo.findById(sid).ifPresent(s -> {
                List<StudentExitClearance> clearances = exitClearanceRepo.findByStudentIdOrderByRequirement_DisplayOrderAsc(s.getId());
                calculateAndSaveSummary(s, clearances);
            });
        }
        return count;
    }

    /**
     * Super Admin grants final graduation and degree conferral clearance.
     */
    public StudentExitSummary grantFinalClearance(Long studentId, String adminUsername, String finalRemarks) {
        Student student = studentRepo.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        List<StudentExitClearance> clearances = exitClearanceRepo.findByStudentIdOrderByRequirement_DisplayOrderAsc(studentId);
        StudentExitSummary summary = calculateAndSaveSummary(student, clearances);

        String certToken = "KLU-GRAD-" + student.getStudentId() + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        summary.setCertificateToken(certToken);
        summary.setOverallStatus("CLEARED_FOR_GRADUATION");
        summary.setFinalApprovedBy(adminUsername);
        summary.setFinalApprovedAt(LocalDateTime.now());
        summary.setFinalRemarks(finalRemarks != null && !finalRemarks.isBlank() ? finalRemarks : "Conferred full institutional clearance for graduation and degree award.");

        return exitSummaryRepo.save(summary);
    }

    /**
     * Faculty dashboard metrics for their department.
     */
    public Map<String, Object> getFacultyDashboardData(String username) {
        String dept = "CSE";
        var fOpt = facultyRepo.findByUsername(username);
        if (fOpt.isPresent() && fOpt.get().getDepartment() != null && !fOpt.get().getDepartment().isBlank()) {
            dept = fOpt.get().getDepartment();
        }

        List<Student> students = studentRepo.findByDepartment(dept);
        long totalStudents = students.size();

        long fullyCleared = exitSummaryRepo.countByDepartmentAndOverallStatus(dept, "CLEARED_FOR_GRADUATION");
        long pendingFinal = exitSummaryRepo.countByDepartmentAndOverallStatus(dept, "PENDING_FINAL_APPROVAL");
        long inProgress = exitSummaryRepo.countByDepartmentAndOverallStatus(dept, "IN_PROGRESS");

        List<StudentExitClearance> facultyQueue = exitClearanceRepo.findByRoleAndDepartment("FACULTY", dept);
        long pendingReviewCount = facultyQueue.stream().filter(c -> "SUBMITTED".equals(c.getStatus()) || "PENDING".equals(c.getStatus())).count();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("department", dept);
        result.put("totalStudents", totalStudents);
        result.put("fullyCleared", fullyCleared);
        result.put("pendingFinalApproval", pendingFinal);
        result.put("inProgress", inProgress);
        result.put("pendingFacultyActions", pendingReviewCount);
        return result;
    }

    /**
     * List of students in faculty department with their exit clearance summary.
     */
    public List<Map<String, Object>> getFacultyStudentsRoster(String username, String search, String statusFilter) {
        String dept = "CSE";
        var fOpt = facultyRepo.findByUsername(username);
        if (fOpt.isPresent() && fOpt.get().getDepartment() != null && !fOpt.get().getDepartment().isBlank()) {
            dept = fOpt.get().getDepartment();
        }

        List<Student> students = studentRepo.findByDepartment(dept);
        List<StudentExitSummary> allSummaries = exitSummaryRepo.findAll();
        Map<Long, StudentExitSummary> summaryMap = allSummaries.stream()
                .filter(sum -> sum.getStudent() != null)
                .collect(Collectors.toMap(sum -> sum.getStudent().getId(), Function.identity(), (a, b) -> a));

        List<Map<String, Object>> roster = new ArrayList<>();

        for (Student s : students) {
            if (search != null && !search.isBlank()) {
                String term = search.toLowerCase().trim();
                boolean matchId = s.getStudentId() != null && s.getStudentId().toLowerCase().contains(term);
                boolean matchName = s.getName() != null && s.getName().toLowerCase().contains(term);
                if (!matchId && !matchName) continue;
            }

            StudentExitSummary summary = summaryMap.get(s.getId());
            String status = summary != null ? summary.getOverallStatus() : "NOT_STARTED";

            if (statusFilter != null && !statusFilter.isBlank() && !"ALL".equalsIgnoreCase(statusFilter)) {
                if (!statusFilter.equalsIgnoreCase(status)) continue;
            }

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("studentId", s.getId());
            item.put("universityId", s.getStudentId());
            item.put("name", s.getName());
            item.put("email", s.getEmail());
            item.put("department", s.getDepartment());
            item.put("specialization", s.getSpecializationName());
            item.put("overallStatus", status);
            item.put("clearancePercentage", summary != null ? summary.getClearancePercentage() : BigDecimal.ZERO);
            item.put("approvedCount", summary != null ? summary.getApprovedCount() : 0);
            item.put("totalRequirements", summary != null ? summary.getTotalRequirements() : 10);
            item.put("certificateToken", summary != null ? summary.getCertificateToken() : null);
            roster.add(item);
        }

        return roster;
    }

    /**
     * Super Admin dashboard metrics for all university departments.
     */
    public Map<String, Object> getAdminDashboardData() {
        long totalStudents = studentRepo.count();
        long cleared = exitSummaryRepo.countByOverallStatus("CLEARED_FOR_GRADUATION");
        long pendingFinal = exitSummaryRepo.countByOverallStatus("PENDING_FINAL_APPROVAL");
        long inProgress = exitSummaryRepo.countByOverallStatus("IN_PROGRESS");
        long notStarted = totalStudents - (cleared + pendingFinal + inProgress);

        // Department breakdown
        List<String> depts = List.of("CSE", "AIDS");
        List<Map<String, Object>> deptStats = new ArrayList<>();
        for (String d : depts) {
            long total = studentRepo.countByDepartment(d);
            long cl = exitSummaryRepo.countByDepartmentAndOverallStatus(d, "CLEARED_FOR_GRADUATION");
            long pf = exitSummaryRepo.countByDepartmentAndOverallStatus(d, "PENDING_FINAL_APPROVAL");
            deptStats.add(Map.of(
                    "department", d,
                    "totalStudents", total,
                    "cleared", cl,
                    "pendingFinal", pf,
                    "completionRate", total > 0 ? Math.round((double) cl / total * 100.0) : 0
            ));
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("totalStudents", totalStudents);
        result.put("clearedForGraduation", cleared);
        result.put("pendingFinalApproval", pendingFinal);
        result.put("inProgress", inProgress);
        result.put("notStarted", Math.max(0, notStarted));
        result.put("overallClearanceRate", totalStudents > 0 ? Math.round((double) cleared / totalStudents * 100.0) : 0);
        result.put("departmentBreakdown", deptStats);
        return result;
    }

    /**
     * Super Admin list of all students with full exit clearance filter.
     */
    public List<Map<String, Object>> getAllStudentsAdminRoster(String dept, String statusFilter, String search) {
        List<Student> students = (dept != null && !dept.isBlank() && !"ALL".equalsIgnoreCase(dept))
                ? studentRepo.findByDepartment(dept)
                : studentRepo.findAll();

        List<StudentExitSummary> allSummaries = exitSummaryRepo.findAll();
        Map<Long, StudentExitSummary> summaryMap = allSummaries.stream()
                .filter(sum -> sum.getStudent() != null)
                .collect(Collectors.toMap(sum -> sum.getStudent().getId(), Function.identity(), (a, b) -> a));

        List<Map<String, Object>> list = new ArrayList<>();
        for (Student s : students) {
            if (search != null && !search.isBlank()) {
                String term = search.toLowerCase().trim();
                boolean matchId = s.getStudentId() != null && s.getStudentId().toLowerCase().contains(term);
                boolean matchName = s.getName() != null && s.getName().toLowerCase().contains(term);
                if (!matchId && !matchName) continue;
            }

            StudentExitSummary summary = summaryMap.get(s.getId());
            String st = summary != null ? summary.getOverallStatus() : "NOT_STARTED";

            if (statusFilter != null && !statusFilter.isBlank() && !"ALL".equalsIgnoreCase(statusFilter)) {
                if (!statusFilter.equalsIgnoreCase(st)) continue;
            }

            Map<String, Object> map = new LinkedHashMap<>();
            map.put("studentId", s.getId());
            map.put("universityId", s.getStudentId());
            map.put("name", s.getName());
            map.put("email", s.getEmail());
            map.put("department", s.getDepartment());
            map.put("specialization", s.getSpecializationName());
            map.put("overallStatus", st);
            map.put("clearancePercentage", summary != null ? summary.getClearancePercentage() : BigDecimal.ZERO);
            map.put("approvedCount", summary != null ? summary.getApprovedCount() : 0);
            map.put("totalRequirements", summary != null ? summary.getTotalRequirements() : 10);
            map.put("certificateToken", summary != null ? summary.getCertificateToken() : null);
            map.put("finalApprovedBy", summary != null ? summary.getFinalApprovedBy() : null);
            map.put("finalApprovedAt", summary != null ? summary.getFinalApprovedAt() : null);
            list.add(map);
        }
        return list;
    }

    /**
     * Super Admin auto-evaluates all graduating students in the database.
     */
    public Map<String, Object> autoEvaluateAllStudents() {
        List<Student> students = studentRepo.findAll();
        int evaluated = 0;
        int newlyCleared = 0;

        for (Student s : students) {
            try {
                Map<String, Object> res = getStudentExitStatus(s.getId());
                StudentExitSummary sum = (StudentExitSummary) res.get("summary");
                if (sum != null && "PENDING_FINAL_APPROVAL".equals(sum.getOverallStatus())) {
                    newlyCleared++;
                }
                evaluated++;
            } catch (Exception e) {
                log.warn("Failed auto-evaluation for student {}: {}", s.getStudentId(), e.getMessage());
            }
        }

        return Map.of(
                "totalStudentsEvaluated", evaluated,
                "readyForFinalApproval", newlyCleared
        );
    }

    /**
     * Exports full university exit clearance report to Excel.
     */
    public byte[] exportExitReportExcel() throws Exception {
        List<Student> students = studentRepo.findAll();
        List<ExitRequirementMaster> reqs = requirementMasterRepo.findAllByOrderByDisplayOrderAsc();

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Exit Clearance Report");

            // Title
            Row titleRow = sheet.createRow(0);
            titleRow.createCell(0).setCellValue("KL UNIVERSITY — STUDENT GRADUATION EXIT CLEARANCE REPORT");

            // Header Style
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            // Columns
            Row header = sheet.createRow(2);
            header.createCell(0).setCellValue("Roll No");
            header.createCell(1).setCellValue("Student Name");
            header.createCell(2).setCellValue("Department");
            header.createCell(3).setCellValue("Overall Status");
            header.createCell(4).setCellValue("Clearance %");
            header.createCell(5).setCellValue("Approved / Total");
            header.createCell(6).setCellValue("Certificate Token");

            int colIdx = 7;
            for (ExitRequirementMaster r : reqs) {
                header.createCell(colIdx++).setCellValue(r.getTitle());
            }

            for (int i = 0; i < colIdx; i++) {
                header.getCell(i).setCellStyle(headerStyle);
            }

            List<StudentExitSummary> allSummaries = exitSummaryRepo.findAll();
            Map<Long, StudentExitSummary> summaryMap = allSummaries.stream()
                    .filter(sum -> sum.getStudent() != null)
                    .collect(Collectors.toMap(sum -> sum.getStudent().getId(), Function.identity(), (a, b) -> a));

            List<StudentExitClearance> allClearances = exitClearanceRepo.findAll();
            Map<Long, Map<Long, String>> clearanceMap = new HashMap<>();
            for (StudentExitClearance c : allClearances) {
                if (c.getStudent() != null && c.getRequirement() != null) {
                    clearanceMap.computeIfAbsent(c.getStudent().getId(), k -> new HashMap<>())
                            .put(c.getRequirement().getId(), c.getStatus());
                }
            }

            int rowIdx = 3;
            for (Student s : students) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(s.getStudentId());
                row.createCell(1).setCellValue(s.getName());
                row.createCell(2).setCellValue(s.getDepartment() != null ? s.getDepartment() : "N/A");

                StudentExitSummary sum = summaryMap.get(s.getId());
                row.createCell(3).setCellValue(sum != null ? sum.getOverallStatus() : "NOT_STARTED");
                row.createCell(4).setCellValue(sum != null ? sum.getClearancePercentage() + "%" : "0%");
                row.createCell(5).setCellValue(sum != null ? sum.getApprovedCount() + " / " + sum.getTotalRequirements() : "0 / " + reqs.size());
                row.createCell(6).setCellValue(sum != null && sum.getCertificateToken() != null ? sum.getCertificateToken() : "N/A");

                Map<Long, String> statusMap = clearanceMap.getOrDefault(s.getId(), Collections.emptyMap());

                int reqCol = 7;
                for (ExitRequirementMaster r : reqs) {
                    row.createCell(reqCol++).setCellValue(statusMap.getOrDefault(r.getId(), "PENDING"));
                }
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            workbook.write(baos);
            return baos.toByteArray();
        }
    }
}
