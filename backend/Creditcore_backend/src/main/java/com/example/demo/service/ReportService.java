package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ReportService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudentDegreeStatusRepository studentDegreeStatusRepository;

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private StudentBucketProgressRepository studentBucketProgressRepository;

    @Autowired
    private BucketSatisfactionEngine bucketSatisfactionEngine;

    /**
     * Individual student progress report.
     */
    public Map<String, Object> getStudentReport(Long studentId) {
        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        StudentDegreeStatus status = studentDegreeStatusRepository.findByStudentId(studentId)
                .orElseThrow(() -> new RuntimeException("No degree evaluation status found for student."));

        List<Map<String, Object>> buckets = bucketSatisfactionEngine.getDetailedBucketProgress(studentId);
        List<CompletedCourse> courses = completedCourseRepository.findByStudentIdOrderByRegisterDateDesc(studentId);

        Map<String, Object> report = new LinkedHashMap<>();
        report.put("studentId", student.getId());
        report.put("studentUsername", student.getUsername());
        report.put("studentName", student.getFirstName() + " " + student.getLastName());
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

            for (CompletedCourse course : courses) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(course.getCourseCode());
                row.createCell(1).setCellValue(course.getCourseName());
                row.createCell(2).setCellValue(course.getCredits());
                row.createCell(3).setCellValue(course.getGrade());
                row.createCell(4).setCellValue(course.getSemester());
                row.createCell(5).setCellValue(course.getCompletedDate() != null ? course.getCompletedDate().toString() : "N/A");
            }

            // Adjust columns
            for (int i = 0; i < 7; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            return out.toByteArray();
        }
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
                row.createCell(0).setCellValue(status.getStudent().getUsername());
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
                row.createCell(0).setCellValue(status.getStudent().getUsername());
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
