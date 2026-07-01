package com.example.demo.service;

import com.example.demo.controller.AddCourseController.AddCourseRequest;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@Transactional
public class AddCourseService {

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private CourseCatalogRepository courseCatalogRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private BucketMappingEngine bucketMappingEngine;

    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    /**
     * Add a single completed course entry for a student.
     */
    public Map<String, Object> addSingleCourse(AddCourseRequest request, Long verifiedById) {
        User student = null;
        if (request.getUniversityId() != null && !request.getUniversityId().isEmpty()) {
            student = userRepository.findByUsername(request.getUniversityId())
                    .orElseThrow(() -> new RuntimeException("Student with university ID " + request.getUniversityId() + " not found."));
        } else {
            throw new RuntimeException("Student university ID is required.");
        }

        User verifiedBy = userRepository.findById(verifiedById)
                .orElseThrow(() -> new RuntimeException("Verifier faculty not found"));

        CourseCatalog catalog = courseCatalogRepository.findByCourseCode(request.getCourseCode())
                .orElseThrow(() -> new RuntimeException("Course code " + request.getCourseCode() + " does not exist in the course catalog."));

        if (completedCourseRepository.existsByStudentIdAndCourseCode(student.getId(), request.getCourseCode())) {
            throw new RuntimeException("Course " + request.getCourseCode() + " is already marked as completed for this student.");
        }

        CompletedCourse completed = new CompletedCourse();
        completed.setStudent(student);
        completed.setCourseCode(catalog.getCourseCode());
        completed.setCourseName(request.getCourseName() != null && !request.getCourseName().isEmpty() ? request.getCourseName() : catalog.getCourseName());
        completed.setCredits(catalog.getCredits());
        completed.setGrade(request.getGrade() != null ? request.getGrade().toUpperCase() : null);
        completed.setSemester(request.getSemester() != null ? request.getSemester() : "ODD");
        
        LocalDate registerDate = null;
        if (request.getRegisterDate() != null && !request.getRegisterDate().isEmpty()) {
            try {
                registerDate = parseDateSafely(null, request.getRegisterDate());
            } catch (Exception e) {}
        }
        completed.setRegisterDate(registerDate != null ? registerDate : LocalDate.now());
        
        completed.setLtps(request.getLtps());
        completed.setBucketGroup(request.getBucketGroup());
        completed.setCourseType(request.getCourseType());
        completed.setAcademicYear(request.getAcademicYear());
        
        if (request.getStudyYear() != null && !request.getStudyYear().isEmpty()) {
            try {
                completed.setStudyYear(Integer.parseInt(request.getStudyYear()));
            } catch (Exception e) {}
        }
        
        completed.setSectionNo(request.getSectionNo());
        completed.setCourseRef(request.getCourseRef());
        completed.setOfferTo(request.getOfferTo());
        completed.setOfferBy(request.getOfferBy());
        completed.setBranch(request.getBranch());
        completed.setVerifiedBy(verifiedBy);

        CompletedCourse saved = completedCourseRepository.save(completed);

        // Try evaluating eligibility if a degree path is assigned
        Optional<StudentDegreePath> sdpOpt = studentDegreePathRepository.findByStudentId(student.getId());
        String bucketCode = "N/A";
        String bucketName = "N/A";
        if (sdpOpt.isPresent()) {
            try {
                degreeEligibilityEngine.evaluateEligibility(student.getId());
                Optional<BucketMaster> bucketOpt = bucketMappingEngine.resolveBucket(request.getCourseCode(), sdpOpt.get().getDegreePath().getId());
                if (bucketOpt.isPresent()) {
                    bucketCode = bucketOpt.get().getBucketCode();
                    bucketName = bucketOpt.get().getBucketName();
                }
            } catch (Exception e) {
                // Ignore and proceed
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("course", saved);
        result.put("mappedBucketCode", bucketCode);
        result.put("mappedBucketName", bucketName);
        return result;
    }

    private static class ParsedCourse {
        String universityId;
        String studentName;
        String courseCode;
        Set<String> ltpsComponents = new LinkedHashSet<>();
        String courseName;
        String bucketGroup;
        String courseType;
        String academicYear;
        String semester;
        Integer studyYear;
        String sectionNo;
        LocalDate registerDate;
        String courseRef;
        String offerTo;
        String offerBy;
        String branch;
    }

    /**
     * Bulk upload completed courses for students using Excel.
     */
    public Map<String, Object> bulkUploadCourses(MultipartFile file, Long verifiedById) throws Exception {
        int added = 0;
        int skipped = 0;
        int failed = 0;
        List<String> errors = new ArrayList<>();
        Set<Long> affectedStudentIds = new HashSet<>();

        User verifiedBy = userRepository.findById(verifiedById)
                .orElseThrow(() -> new RuntimeException("Verifier faculty not found"));

        Map<String, ParsedCourse> courseMap = new LinkedHashMap<>();

        try (InputStream is = file.getInputStream(); Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rowIterator = sheet.iterator();

            // Skip header
            if (rowIterator.hasNext()) {
                rowIterator.next();
            }

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                try {
                    String universityId = getCellString(row.getCell(0));
                    String studentName = getCellString(row.getCell(1));
                    String courseCode = getCellString(row.getCell(2));
                    String ltps = getCellString(row.getCell(3));
                    String courseName = getCellString(row.getCell(4));
                    String bucketGroup = getCellString(row.getCell(5));
                    String courseType = getCellString(row.getCell(6));
                    String academicYear = getCellString(row.getCell(7));
                    String semester = getCellString(row.getCell(8));
                    String studyYearStr = getCellString(row.getCell(9));
                    String sectionNo = getCellString(row.getCell(10));
                    String dateStr = getCellString(row.getCell(11));
                    String courseRef = getCellString(row.getCell(12));
                    String offerTo = getCellString(row.getCell(13));
                    String offerBy = getCellString(row.getCell(14));
                    String branch = getCellString(row.getCell(15));

                    if (universityId == null || universityId.isEmpty()) {
                        continue; // empty row
                    }

                    if (courseCode == null || courseCode.isEmpty()) {
                        throw new RuntimeException("Missing course code");
                    }

                    String key = universityId + "|" + courseCode;
                    ParsedCourse pc = courseMap.getOrDefault(key, new ParsedCourse());
                    pc.universityId = universityId;
                    pc.studentName = studentName;
                    pc.courseCode = courseCode;
                    if (ltps != null && !ltps.isEmpty()) {
                        pc.ltpsComponents.add(ltps);
                    }
                    if (pc.courseName == null) pc.courseName = courseName;
                    if (pc.bucketGroup == null) pc.bucketGroup = bucketGroup;
                    if (pc.courseType == null) pc.courseType = courseType;
                    if (pc.academicYear == null) pc.academicYear = academicYear;
                    if (pc.semester == null) pc.semester = semester;
                    if (pc.studyYear == null && studyYearStr != null && !studyYearStr.isEmpty()) {
                        try {
                            pc.studyYear = Integer.parseInt(studyYearStr);
                        } catch (Exception e) {}
                    }
                    if (pc.sectionNo == null) pc.sectionNo = sectionNo;
                    if (pc.registerDate == null) pc.registerDate = parseDateSafely(row.getCell(11), dateStr);
                    if (pc.courseRef == null) pc.courseRef = courseRef;
                    if (pc.offerTo == null) pc.offerTo = offerTo;
                    if (pc.offerBy == null) pc.offerBy = offerBy;
                    if (pc.branch == null) pc.branch = branch;

                    courseMap.put(key, pc);

                } catch (Exception e) {
                    errors.add("Row " + (row.getRowNum() + 1) + ": " + e.getMessage());
                }
            }
        }

        for (Map.Entry<String, ParsedCourse> entry : courseMap.entrySet()) {
            ParsedCourse pc = entry.getValue();
            try {
                User student = userRepository.findByUsername(pc.universityId)
                        .orElseThrow(() -> new RuntimeException("Student with ID/username " + pc.universityId + " not found."));

                CourseCatalog catalog = courseCatalogRepository.findByCourseCode(pc.courseCode).orElse(null);
                
                String finalCourseName = (catalog != null) ? catalog.getCourseName() : pc.courseName;
                Integer finalCredits = (catalog != null) ? catalog.getCredits() : null;

                if (finalCourseName == null || finalCourseName.isEmpty() || finalCredits == null) {
                    throw new RuntimeException("Course code " + pc.courseCode + " not in catalog and name/credits not available.");
                }

                if (completedCourseRepository.existsByStudentIdAndCourseCode(student.getId(), pc.courseCode)) {
                    skipped++;
                    continue;
                }

                CompletedCourse completed = new CompletedCourse();
                completed.setStudent(student);
                completed.setCourseCode(pc.courseCode);
                completed.setCourseName(finalCourseName);
                completed.setCredits(finalCredits);
                // Grade is optional in this format, leave null by default
                completed.setGrade(null); 
                completed.setSemester(pc.semester);
                completed.setRegisterDate(pc.registerDate != null ? pc.registerDate : LocalDate.now());
                
                String combinedLtps = String.join(",", pc.ltpsComponents);
                completed.setLtps(combinedLtps);
                completed.setBucketGroup(pc.bucketGroup);
                completed.setCourseType(pc.courseType);
                completed.setAcademicYear(pc.academicYear);
                completed.setStudyYear(pc.studyYear);
                completed.setSectionNo(pc.sectionNo);
                completed.setCourseRef(pc.courseRef);
                completed.setOfferTo(pc.offerTo);
                completed.setOfferBy(pc.offerBy);
                completed.setBranch(pc.branch);
                completed.setVerifiedBy(verifiedBy);

                completedCourseRepository.save(completed);
                affectedStudentIds.add(student.getId());
                added++;
            } catch (Exception e) {
                failed++;
                errors.add("Course " + pc.courseCode + " for student " + pc.universityId + ": " + e.getMessage());
            }
        }

        // Re-evaluate affected students
        for (Long studentId : affectedStudentIds) {
            try {
                degreeEligibilityEngine.evaluateEligibility(studentId);
            } catch (Exception e) {
                // Ignore if path not assigned
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("added", added);
        result.put("skipped", skipped);
        result.put("failed", failed);
        result.put("errors", errors);
        return result;
    }

    /**
     * Delete a completed course entry.
     */
    public void deleteCourse(Long courseId) {
        CompletedCourse completed = completedCourseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Completed course entry not found"));
        Long studentId = completed.getStudent().getId();
        completedCourseRepository.delete(completed);

        // Re-evaluate eligibility
        try {
            degreeEligibilityEngine.evaluateEligibility(studentId);
        } catch (Exception e) {
            // Ignore if path not assigned
        }
    }

    /**
     * Get completed courses for a student.
     */
    public List<CompletedCourse> getStudentCourses(Long studentId) {
        // We can still use the older method or add findByStudentIdOrderByRegisterDateDesc
        return completedCourseRepository.findByStudentIdOrderByRegisterDateDesc(studentId);
    }

    /**
     * Generate Excel template for bulk completed course uploads (16 columns).
     */
    public byte[] generateTemplate() throws Exception {
        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Template");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("university_id");
            header.createCell(1).setCellValue("student_name");
            header.createCell(2).setCellValue("course_code");
            header.createCell(3).setCellValue("ltps");
            header.createCell(4).setCellValue("course_name");
            header.createCell(5).setCellValue("bucket_group");
            header.createCell(6).setCellValue("course_type");
            header.createCell(7).setCellValue("academic_year");
            header.createCell(8).setCellValue("semester");
            header.createCell(9).setCellValue("study_year");
            header.createCell(10).setCellValue("section");
            header.createCell(11).setCellValue("register_date");
            header.createCell(12).setCellValue("course_ref");
            header.createCell(13).setCellValue("offered_to");
            header.createCell(14).setCellValue("offered_by");
            header.createCell(15).setCellValue("branch");

            // Auto size columns
            for (int i = 0; i < 16; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
            return out.toByteArray();
        }
    }

    private String getCellString(Cell cell) {
        if (cell == null) return null;
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue().trim();
            case NUMERIC -> {
                if (DateUtil.isCellDateFormatted(cell)) {
                    yield cell.getLocalDateTimeCellValue().toLocalDate().toString();
                }
                yield String.valueOf((long) cell.getNumericCellValue());
            }
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            default -> null;
        };
    }

    private LocalDate parseDateSafely(Cell cell, String val) {
        if (cell != null && cell.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cell)) {
            return cell.getLocalDateTimeCellValue().toLocalDate();
        }
        if (val == null || val.trim().isEmpty()) {
            return LocalDate.now();
        }
        List<String> formats = Arrays.asList("yyyy-MM-dd", "dd-MM-yyyy", "MM/dd/yyyy", "dd/MM/yyyy", "yyyy/MM/dd", "dd-MM-yy");
        for (String format : formats) {
            try {
                return LocalDate.parse(val.trim(), DateTimeFormatter.ofPattern(format));
            } catch (Exception e) {
                // Try next
            }
        }
        return LocalDate.now();
    }
}
