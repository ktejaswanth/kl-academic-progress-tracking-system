package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class ReportService {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private StudentDegreeStatusRepository studentDegreeStatusRepository;

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private StudentCourseRepository studentCourseRepository;

    @Autowired
    private StudentBucketProgressRepository studentBucketProgressRepository;

    @Autowired
    private BucketSatisfactionEngine bucketSatisfactionEngine;

    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private DegreePathEngine degreePathEngine;

    /**
     * Individual student progress report.
     */
    public Map<String, Object> getStudentReport(Long studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        // Ensure student has assigned degree path before progress evaluation
        if (studentDegreePathRepository.findByStudentId(studentId).isEmpty() && degreePathEngine != null) {
            try {
                degreePathEngine.resolveAndAssignPath(studentId);
            } catch (Exception ignored) {
                // Resolution error handled in downstream evaluations
            }
        }

        StudentDegreeStatus status = studentDegreeStatusRepository.findByStudentId(studentId).orElse(null);
        if (status == null) {
            try {
                status = degreeEligibilityEngine.evaluateEligibility(studentId);
            } catch (Exception e) {
                status = new StudentDegreeStatus();
                status.setStudent(student);
                status.setIsDegreeEligible(false);
                status.setCompletionPercentage(BigDecimal.ZERO);
                status.setTotalEarnedCredits(0);
                status.setTotalRequiredCredits(160);
                status.setBucketsCompleted(0);
                status.setBucketsTotal(12);
            }
        }

        List<Map<String, Object>> buckets = bucketSatisfactionEngine.getDetailedBucketProgress(studentId);
        List<CompletedCourse> courses = completedCourseRepository.findByStudentIdOrderByRegisterDateDesc(studentId);

        Map<String, Object> report = new LinkedHashMap<>();
        report.put("studentId", student.getId());
        report.put("studentUsername", student.getStudentId());
        report.put("studentName", (student.getFirstName() != null ? student.getFirstName() : "") + " " + (student.getLastName() != null ? student.getLastName() : ""));
        report.put("department", student.getDepartment());
        report.put("subDepartment", student.getSubDepartment());
        report.put("specialization", student.getSpecializationName());
        report.put("status", status);
        report.put("buckets", buckets);
        report.put("courses", courses);
        return report;
    }

    /**
     * Excel export of student progress report.
     */
    public byte[] exportStudentReportExcel(Long studentId) throws Exception {
        Map<String, Object> report = getStudentReport(studentId);
        StudentDegreeStatus status = (StudentDegreeStatus) report.get("status");
        List<Map<String, Object>> buckets = (List<Map<String, Object>>) report.get("buckets");
        List<CompletedCourse> courses = (List<CompletedCourse>) report.get("courses");

        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Student Progress Report");

            // Title
            Row titleRow = sheet.createRow(0);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("KL UNIVERSITY — STUDENT DEGREE PROGRESS AUDIT REPORT");
            CellStyle titleStyle = workbook.createCellStyle();
            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            titleCell.setCellStyle(titleStyle);

            // Student Meta
            int rowIdx = 2;
            createMetaRow(sheet, rowIdx++, "Student Name:", (String) report.get("studentName"), "Student ID:", (String) report.get("studentUsername"));
            createMetaRow(sheet, rowIdx++, "Department:", (String) report.get("department"), "Degree Path:", status.getDegreePath() != null ? status.getDegreePath().getPathCode() : "N/A");
            createMetaRow(sheet, rowIdx++, "Audit Score %:", status.getCompletionPercentage() + "%", "Eligibility Status:", status.getIsDegreeEligible() ? "ELIGIBLE" : "IN PROGRESS");
            createMetaRow(sheet, rowIdx++, "Credits Earned:", status.getTotalEarnedCredits() + " / " + status.getTotalRequiredCredits(), "Buckets Satisfied:", status.getBucketsCompleted() + " / " + status.getBucketsTotal());

            // Header Style
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font boldFont = workbook.createFont();
            boldFont.setBold(true);
            headerStyle.setFont(boldFont);

            rowIdx += 2;
            // Section 1: Buckets
            Row sec1Header = sheet.createRow(rowIdx++);
            sec1Header.createCell(0).setCellValue("CURRICULUM BUCKETS PROGRESS CHECKLIST");
            sec1Header.getCell(0).setCellStyle(titleStyle);

            Row bucketsHeader = sheet.createRow(rowIdx++);
            String[] bCols = {"Bucket Code", "Bucket Name", "Category", "Required Credits", "Earned Credits", "Status", "Completion %"};
            for (int i = 0; i < bCols.length; i++) {
                Cell cell = bucketsHeader.createCell(i);
                cell.setCellValue(bCols[i]);
                cell.setCellStyle(headerStyle);
            }

            for (Map<String, Object> bucket : buckets) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue((String) bucket.get("bucketCode"));
                row.createCell(1).setCellValue((String) bucket.get("bucketName"));
                row.createCell(2).setCellValue((String) bucket.get("bucketCategory"));
                row.createCell(3).setCellValue((Integer) bucket.get("requiredCredits"));
                row.createCell(4).setCellValue((Integer) bucket.get("earnedCredits"));
                row.createCell(5).setCellValue((String) bucket.get("status"));
                row.createCell(6).setCellValue(bucket.get("completionPercentage").toString() + "%");
            }

            rowIdx += 2;
            // Section 2: Courses
            Row sec2Header = sheet.createRow(rowIdx++);
            sec2Header.createCell(0).setCellValue("COMPLETED COURSES HISTORICAL ROSTER");
            sec2Header.getCell(0).setCellStyle(titleStyle);

            Row coursesHeader = sheet.createRow(rowIdx++);
            String[] cCols = {"Course Code", "Course Name", "Credits", "Grade", "Semester", "Completed Date"};
            for (int i = 0; i < cCols.length; i++) {
                Cell cell = coursesHeader.createCell(i);
                cell.setCellValue(cCols[i]);
                cell.setCellStyle(headerStyle);
            }

            if (courses != null && !courses.isEmpty()) {
                for (CompletedCourse course : courses) {
                    Row row = sheet.createRow(rowIdx++);
                    row.createCell(0).setCellValue(course.getCourseCode() != null ? course.getCourseCode() : "");
                    row.createCell(1).setCellValue(course.getCourseName() != null ? course.getCourseName() : "");
                    row.createCell(2).setCellValue(course.getCredits() != null ? course.getCredits() : 0);
                    row.createCell(3).setCellValue(course.getGrade() != null ? course.getGrade() : "-");
                    row.createCell(4).setCellValue(course.getSemester() != null ? course.getSemester() : "-");
                    row.createCell(5).setCellValue(course.getCompletedDate() != null ? course.getCompletedDate().toString() : "N/A");
                }
            } else {
                List<StudentCourse> studentCourses = studentCourseRepository.findByStudentId(studentId);
                if (studentCourses.isEmpty()) {
                    String roll = (String) report.get("studentUsername");
                    if (roll != null) studentCourses = studentCourseRepository.findByUniversityId(roll);
                }
                for (StudentCourse sc : studentCourses) {
                    Row row = sheet.createRow(rowIdx++);
                    row.createCell(0).setCellValue(sc.getCourseCode() != null ? sc.getCourseCode() : "");
                    row.createCell(1).setCellValue(sc.getCourseName() != null ? sc.getCourseName() : "");
                    row.createCell(2).setCellValue(sc.getCredits() != null ? sc.getCredits().intValue() : 0);
                    row.createCell(3).setCellValue(sc.getGrade() != null ? sc.getGrade() : "-");
                    row.createCell(4).setCellValue(sc.getSemester() != null ? sc.getSemester() : "-");
                    row.createCell(5).setCellValue(sc.getStatus() != null ? sc.getStatus() : "COMPLETED");
                }
            }

            // Adjust columns
            for (int i = 0; i < 7; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            return out.toByteArray();
        }
    }

    /**
     * Graduation Eligibility Audit Report (Official PDF)
     */
    public byte[] exportEligibilityAuditPdf(Long studentId) throws Exception {
        Map<String, Object> report = getStudentReport(studentId);
        StudentDegreeStatus status = (StudentDegreeStatus) report.get("status");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> buckets = (List<Map<String, Object>>) report.get("buckets");
        String studentName = (String) report.get("studentName");
        String rollNumber = (String) report.get("studentUsername");
        String dept = (String) report.get("department");
        String spec = (String) report.get("specialization");
        String pathCode = (status != null && status.getDegreePath() != null) ? status.getDegreePath().getPathCode() : "REGULAR";

        try (PDDocument document = new PDDocument(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            PDPage page = new PDPage(PDRectangle.A4);
            document.addPage(page);

            PDType1Font fontBold = new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD);
            PDType1Font fontRegular = new PDType1Font(Standard14Fonts.FontName.HELVETICA);

            try (PDPageContentStream cs = new PDPageContentStream(document, page)) {
                // Header Banner
                cs.setNonStrokingColor(139f / 255f, 0f / 255f, 0f / 255f); // #8B0000 Maroon
                cs.addRect(0, 792, 595.27f, 50);
                cs.fill();

                // University Title
                cs.setNonStrokingColor(1f, 1f, 1f);
                cs.beginText();
                cs.setFont(fontBold, 15f);
                cs.newLineAtOffset(40, 816);
                cs.showText("KL DEEMED TO BE UNIVERSITY");
                cs.endText();

                cs.beginText();
                cs.setFont(fontRegular, 8.5f);
                cs.newLineAtOffset(40, 802);
                cs.showText("OFFICIAL GRADUATION ELIGIBILITY & DEGREE AUDIT REPORT");
                cs.endText();

                // Candidate Details Box
                cs.setNonStrokingColor(248f / 255f, 250f / 255f, 252f / 255f);
                cs.addRect(36, 680, 523, 95);
                cs.fill();
                cs.setStrokingColor(226f / 255f, 232f / 255f, 240f / 255f);
                cs.addRect(36, 680, 523, 95);
                cs.stroke();

                cs.setNonStrokingColor(30f / 255f, 41f / 255f, 59f / 255f);
                drawPdfText(cs, fontBold, 9f, 50, 755, "Student Name:");
                drawPdfText(cs, fontRegular, 9f, 140, 755, studentName != null ? studentName : "-");
                drawPdfText(cs, fontBold, 9f, 320, 755, "Roll Number:");
                drawPdfText(cs, fontRegular, 9f, 410, 755, rollNumber != null ? rollNumber : "-");

                drawPdfText(cs, fontBold, 9f, 50, 735, "Department:");
                drawPdfText(cs, fontRegular, 9f, 140, 735, dept != null ? dept : "-");
                drawPdfText(cs, fontBold, 9f, 320, 735, "Degree Path:");
                drawPdfText(cs, fontRegular, 9f, 410, 735, pathCode != null ? pathCode : "-");

                drawPdfText(cs, fontBold, 9f, 50, 715, "Specialization:");
                drawPdfText(cs, fontRegular, 9f, 140, 715, spec != null && !spec.isBlank() ? spec : "General Track");
                drawPdfText(cs, fontBold, 9f, 320, 715, "Date of Audit:");
                drawPdfText(cs, fontRegular, 9f, 410, 715, LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMMM yyyy")));

                drawPdfText(cs, fontBold, 9f, 50, 695, "Clearance Status:");
                boolean eligible = status != null && Boolean.TRUE.equals(status.getIsDegreeEligible());
                if (eligible) {
                    cs.setNonStrokingColor(22f / 255f, 101f / 255f, 52f / 255f);
                    drawPdfText(cs, fontBold, 9.5f, 140, 695, "ELIGIBLE FOR DEGREE AWARD");
                } else {
                    cs.setNonStrokingColor(180f / 255f, 83f / 255f, 9f / 255f);
                    drawPdfText(cs, fontBold, 9.5f, 140, 695, "IN PROGRESS / UNDER EVALUATION");
                }
                cs.setNonStrokingColor(30f / 255f, 41f / 255f, 59f / 255f);
                drawPdfText(cs, fontBold, 9f, 320, 695, "Audit Progress:");
                String pct = (status != null && status.getCompletionPercentage() != null) ? status.getCompletionPercentage().toString() : "0";
                drawPdfText(cs, fontBold, 9f, 410, 695, pct + "% Completed");

                // Table Header
                float tableTop = 645;
                cs.setNonStrokingColor(241f / 255f, 245f / 255f, 249f / 255f);
                cs.addRect(36, tableTop - 18, 523, 20);
                cs.fill();

                cs.setNonStrokingColor(71f / 255f, 85f / 255f, 105f / 255f);
                drawPdfText(cs, fontBold, 8f, 42, tableTop - 13, "BUCKET CODE");
                drawPdfText(cs, fontBold, 8f, 115, tableTop - 13, "BUCKET / CATEGORY NAME");
                drawPdfText(cs, fontBold, 8f, 325, tableTop - 13, "REQ");
                drawPdfText(cs, fontBold, 8f, 375, tableTop - 13, "EARNED");
                drawPdfText(cs, fontBold, 8f, 435, tableTop - 13, "COUNTED");
                drawPdfText(cs, fontBold, 8f, 500, tableTop - 13, "STATUS");

                // Table Rows
                float y = tableTop - 34;
                if (buckets != null) {
                    for (Map<String, Object> b : buckets) {
                        if (y < 130) break;
                        cs.setStrokingColor(241f / 255f, 245f / 255f, 249f / 255f);
                        cs.moveTo(36, y - 4);
                        cs.lineTo(559, y - 4);
                        cs.stroke();

                        cs.setNonStrokingColor(30f / 255f, 41f / 255f, 59f / 255f);
                        String bCode = String.valueOf(b.getOrDefault("bucketCode", ""));
                        String bName = String.valueOf(b.getOrDefault("bucketName", ""));
                        if (bName.length() > 32) bName = bName.substring(0, 30) + "...";
                        String req = String.valueOf(b.getOrDefault("requiredCredits", "0"));
                        String earned = String.valueOf(b.getOrDefault("earnedCredits", "0"));
                        String counted = String.valueOf(b.getOrDefault("countedCredits", earned));
                        String bStatus = String.valueOf(b.getOrDefault("status", "PENDING"));

                        drawPdfText(cs, fontBold, 8f, 42, y, bCode);
                        drawPdfText(cs, fontRegular, 8f, 115, y, bName);
                        drawPdfText(cs, fontRegular, 8f, 330, y, req);
                        drawPdfText(cs, fontRegular, 8f, 385, y, earned);
                        drawPdfText(cs, fontBold, 8f, 445, y, counted);

                        if ("COMPLETED".equalsIgnoreCase(bStatus)) {
                            cs.setNonStrokingColor(22f / 255f, 101f / 255f, 52f / 255f);
                            drawPdfText(cs, fontBold, 7.5f, 500, y, "COMPLETED");
                        } else {
                            cs.setNonStrokingColor(180f / 255f, 83f / 255f, 9f / 255f);
                            drawPdfText(cs, fontBold, 7.5f, 500, y, "IN PROGRESS");
                        }

                        y -= 18;
                    }
                }

                // Summary Totals Row
                cs.setNonStrokingColor(241f / 255f, 245f / 255f, 249f / 255f);
                cs.addRect(36, y - 6, 523, 18);
                cs.fill();
                cs.setNonStrokingColor(15f / 255f, 23f / 255f, 42f / 255f);
                drawPdfText(cs, fontBold, 8.5f, 42, y, "TOTAL DEGREE CREDITS AUDIT");
                int totReq = status != null ? status.getTotalRequiredCredits() : 160;
                int totEarned = status != null ? status.getTotalEarnedCredits() : 0;
                drawPdfText(cs, fontBold, 8.5f, 330, y, String.valueOf(totReq));
                drawPdfText(cs, fontBold, 8.5f, 445, y, String.valueOf(totEarned));

                // Certification Statement & Signatures
                float footerY = 90;
                cs.setNonStrokingColor(100f / 255f, 116f / 255f, 139f / 255f);
                drawPdfText(cs, fontRegular, 7.5f, 36, footerY + 20, "This institutional audit report is electronically validated by the CreditCore Degree Audit System.");
                drawPdfText(cs, fontRegular, 7.5f, 36, footerY + 10, "Any discrepancy should be referred to the Office of the Dean (Academics), KL Deemed to be University.");

                // Signature lines
                cs.setStrokingColor(148f / 255f, 163f / 255f, 184f / 255f);
                cs.moveTo(50, footerY - 15);
                cs.lineTo(170, footerY - 15);
                cs.stroke();
                drawPdfText(cs, fontBold, 7.5f, 65, footerY - 26, "Head of Department");

                cs.moveTo(240, footerY - 15);
                cs.lineTo(360, footerY - 15);
                cs.stroke();
                drawPdfText(cs, fontBold, 7.5f, 265, footerY - 26, "Dean (Academics)");

                cs.moveTo(430, footerY - 15);
                cs.lineTo(550, footerY - 15);
                cs.stroke();
                drawPdfText(cs, fontBold, 7.5f, 440, footerY - 26, "Controller of Examinations");
            }

            document.save(out);
            return out.toByteArray();
        }
    }

    private void drawPdfText(PDPageContentStream cs, PDType1Font font, float fontSize, float x, float y, String text) throws Exception {
        if (text == null) text = "";
        cs.beginText();
        cs.setFont(font, fontSize);
        cs.newLineAtOffset(x, y);
        cs.showText(text);
        cs.endText();
    }

    private void createMetaRow(Sheet sheet, int rowIdx, String lbl1, String val1, String lbl2, String val2) {
        Row row = sheet.createRow(rowIdx);
        row.createCell(0).setCellValue(lbl1);
        row.createCell(1).setCellValue(val1);
        row.createCell(3).setCellValue(lbl2);
        row.createCell(4).setCellValue(val2);
    }

    /**
     * Department aggregate report.
     */
    public Map<String, Object> getDepartmentReport(String dept) {
        List<StudentDegreeStatus> students = studentDegreeStatusRepository.findByDepartment(dept);
        
        long totalStudents = studentDegreeStatusRepository.countByDepartment(dept);
        long eligibleStudents = studentDegreeStatusRepository.countEligibleByDepartment(dept);
        long pendingStudents = totalStudents - eligibleStudents;

        double avgCompletion = 0.0;
        if (totalStudents > 0) {
            avgCompletion = students.stream()
                    .map(StudentDegreeStatus::getCompletionPercentage)
                    .mapToDouble(BigDecimal::doubleValue)
                    .average()
                    .orElse(0.0);
            avgCompletion = BigDecimal.valueOf(avgCompletion).setScale(2, RoundingMode.HALF_UP).doubleValue();
        }

        Map<String, Object> report = new LinkedHashMap<>();
        report.put("department", dept);
        report.put("totalStudents", totalStudents);
        report.put("eligibleStudents", eligibleStudents);
        report.put("pendingStudents", pendingStudents);
        report.put("averageCompletionPercentage", avgCompletion);
        report.put("students", students);
        return report;
    }

    /**
     * Excel export of department aggregate report.
     */
    public byte[] exportDepartmentReportExcel(String dept) throws Exception {
        Map<String, Object> report = getDepartmentReport(dept);
        List<StudentDegreeStatus> students = (List<StudentDegreeStatus>) report.get("students");

        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Department Report");

            // Title
            Row titleRow = sheet.createRow(0);
            titleRow.createCell(0).setCellValue("DEPARTMENT ACADEMIC REPORT — " + dept.toUpperCase());
            CellStyle titleStyle = workbook.createCellStyle();
            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            titleRow.getCell(0).setCellStyle(titleStyle);

            // Metrics
            int rowIdx = 2;
            createMetaRow(sheet, rowIdx++, "Total Students:", report.get("totalStudents").toString(), "Eligible Count:", report.get("eligibleStudents").toString());
            createMetaRow(sheet, rowIdx++, "Pending Count:", report.get("pendingStudents").toString(), "Avg Completion %:", report.get("averageCompletionPercentage").toString() + "%");

            rowIdx += 2;
            // Student list Header
            Row listHeader = sheet.createRow(rowIdx++);
            listHeader.createCell(0).setCellValue("STUDENTS COMPLIANCE LIST");
            listHeader.getCell(0).setCellStyle(titleStyle);

            Row tableHeader = sheet.createRow(rowIdx++);
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font boldFont = workbook.createFont();
            boldFont.setBold(true);
            headerStyle.setFont(boldFont);

            String[] cols = {"Student ID", "Student Name", "Degree Path", "Required Credits", "Earned Credits", "Buckets Sat.", "Completion %", "Status"};
            for (int i = 0; i < cols.length; i++) {
                Cell cell = tableHeader.createCell(i);
                cell.setCellValue(cols[i]);
                cell.setCellStyle(headerStyle);
            }

            for (StudentDegreeStatus status : students) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(status.getStudent().getStudentId());
                row.createCell(1).setCellValue(status.getStudent().getFirstName() + " " + status.getStudent().getLastName());
                row.createCell(2).setCellValue(status.getDegreePath() != null ? status.getDegreePath().getPathCode() : "N/A");
                row.createCell(3).setCellValue(status.getTotalRequiredCredits());
                row.createCell(4).setCellValue(status.getTotalEarnedCredits());
                row.createCell(5).setCellValue(status.getBucketsCompleted() + " / " + status.getBucketsTotal());
                row.createCell(6).setCellValue(status.getCompletionPercentage().toString() + "%");
                row.createCell(7).setCellValue(status.getStatus());
            }

            for (int i = 0; i < cols.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            return out.toByteArray();
        }
    }

    /**
     * University-wide graduation readiness report.
     */
    public Map<String, Object> getGraduationReadinessReport() {
        List<StudentDegreeStatus> roster = studentDegreeStatusRepository.findAll().stream()
                .sorted((s1, s2) -> s2.getCompletionPercentage().compareTo(s1.getCompletionPercentage()))
                .collect(Collectors.toList());

        long totalCount = roster.size();
        long eligibleCount = roster.stream().filter(StudentDegreeStatus::getIsDegreeEligible).count();

        Map<String, Object> report = new LinkedHashMap<>();
        report.put("totalStudentsAudited", totalCount);
        report.put("eligibleCount", eligibleCount);
        report.put("pendingCount", totalCount - eligibleCount);
        report.put("roster", roster);
        return report;
    }

    /**
     * Excel export of graduation readiness report.
     */
    public byte[] exportGraduationReadinessExcel() throws Exception {
        Map<String, Object> report = getGraduationReadinessReport();
        List<StudentDegreeStatus> roster = (List<StudentDegreeStatus>) report.get("roster");

        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Graduation Readiness");

            // Title
            Row titleRow = sheet.createRow(0);
            titleRow.createCell(0).setCellValue("UNIVERSITY GRADUATION READINESS & COMPLIANCE AUDIT");
            CellStyle titleStyle = workbook.createCellStyle();
            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);
            titleRow.getCell(0).setCellStyle(titleStyle);

            // Metrics
            int rowIdx = 2;
            createMetaRow(sheet, rowIdx++, "Total Students Audited:", report.get("totalStudentsAudited").toString(), "Eligible Graduates:", report.get("eligibleCount").toString());
            createMetaRow(sheet, rowIdx++, "In-Progress Students:", report.get("pendingCount").toString(), "", "");

            rowIdx += 2;
            Row tableHeader = sheet.createRow(rowIdx++);
            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            Font boldFont = workbook.createFont();
            boldFont.setBold(true);
            headerStyle.setFont(boldFont);

            String[] cols = {"Student ID", "Student Name", "Department", "Degree Path", "Required Credits", "Earned Credits", "Buckets Completed", "Completion %", "Graduation Status"};
            for (int i = 0; i < cols.length; i++) {
                Cell cell = tableHeader.createCell(i);
                cell.setCellValue(cols[i]);
                cell.setCellStyle(headerStyle);
            }

            for (StudentDegreeStatus status : roster) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(status.getStudent().getStudentId());
                row.createCell(1).setCellValue(status.getStudent().getFirstName() + " " + status.getStudent().getLastName());
                row.createCell(2).setCellValue(status.getStudent().getDepartment());
                row.createCell(3).setCellValue(status.getDegreePath() != null ? status.getDegreePath().getPathCode() : "N/A");
                row.createCell(4).setCellValue(status.getTotalRequiredCredits());
                row.createCell(5).setCellValue(status.getTotalEarnedCredits());
                row.createCell(6).setCellValue(status.getBucketsCompleted() + " / " + status.getBucketsTotal());
                row.createCell(7).setCellValue(status.getCompletionPercentage().toString() + "%");
                row.createCell(8).setCellValue(status.getIsDegreeEligible() ? "ELIGIBLE" : "PENDING");
            }

            for (int i = 0; i < cols.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            return out.toByteArray();
        }
    }
}
