package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class ExitRequirementPdfService {

    private static final Logger log = LoggerFactory.getLogger(ExitRequirementPdfService.class);

    @Autowired private StudentRepository studentRepository;
    @Autowired private StudentCourseRepository studentCourseRepository;
    @Autowired private StudentCourseAttemptRepository attemptRepository;
    @Autowired private BucketSatisfactionEngine bucketSatisfactionEngine;
    @Autowired private StudentDegreeStatusRepository degreeStatusRepository;
    @Autowired private StudentExitSummaryRepository exitSummaryRepository;
    @Autowired private CompletedCourseRepository completedCourseRepository;
    @Autowired private DegreePathEngine degreePathEngine;

    public static class CategoryData {
        public String categoryCode;
        public String description;
        public int requiredCredits;
        public int obtainedCredits = 0;
        public int remainingCredits = 0;
        public String status = "Pending"; // "Complete", "In Progress", "Pending"
        public List<CourseItem> courses = new ArrayList<>();

        public CategoryData(String code, String desc, int req) {
            this.categoryCode = code;
            this.description = desc;
            this.requiredCredits = req;
        }

        public void calculate() {
            this.remainingCredits = Math.max(0, this.requiredCredits - this.obtainedCredits);
            if (this.requiredCredits == 0) {
                this.status = !this.courses.isEmpty() ? "Complete" : "Pending";
            } else if (this.obtainedCredits >= this.requiredCredits) {
                this.status = "Complete";
            } else if (this.obtainedCredits > 0) {
                this.status = "In Progress";
            } else {
                this.status = "Pending";
            }
        }
    }

    public static class CourseItem {
        public String courseCode;
        public String courseName;
        public int credits;
        public String attempt1 = "-";
        public String attempt2 = "-";
        public String attempt3 = "-";
        public String subCategory = "-";

        public CourseItem(String code, String name, int credits, String grade) {
            this.courseCode = code;
            this.courseName = name;
            this.credits = credits;
            if (grade != null && !grade.isBlank() && !"null".equalsIgnoreCase(grade.trim())) {
                this.attempt1 = grade.trim();
            } else {
                this.attempt1 = "Pass";
            }
        }

        public CourseItem(String code, String name, int credits, String grade, String subCategory) {
            this(code, name, credits, grade);
            if (subCategory != null && !subCategory.isBlank()) {
                this.subCategory = subCategory.trim();
            }
        }
    }

    public static class ReportCalculationResult {
        public Student student;
        public Map<String, CategoryData> catMap;
        public int totalRequired;
        public int totalObtained;
        public int totalRemaining;

        public ReportCalculationResult(Student student, Map<String, CategoryData> catMap, int totalRequired, int totalObtained, int totalRemaining) {
            this.student = student;
            this.catMap = catMap;
            this.totalRequired = totalRequired;
            this.totalObtained = totalObtained;
            this.totalRemaining = totalRemaining;
        }
    }

    public Student findStudentByIdentifier(String identifier) {
        if (identifier == null || identifier.isBlank()) {
            throw new RuntimeException("Student ID or Roll Number is required.");
        }
        String cleanId = identifier.trim();
        Optional<Student> studentOpt = studentRepository.findByStudentId(cleanId);
        if (studentOpt.isPresent()) {
            return studentOpt.get();
        }
        try {
            Long id = Long.parseLong(cleanId);
            studentOpt = studentRepository.findById(id);
            if (studentOpt.isPresent()) {
                return studentOpt.get();
            }
        } catch (NumberFormatException ignored) {}

        throw new RuntimeException("Student record not found for: " + cleanId);
    }

    public ReportCalculationResult calculateExitRequirementData(Student student) {
        Long studentId = student.getId();

        // 1. Prepare Categories with Official Curriculum Credits
        Map<String, CategoryData> catMap = new LinkedHashMap<>();
        catMap.put("HAS", new CategoryData("HAS", "Humanities, Arts and Social Sciences (HAS)", 17));
        catMap.put("BSC", new CategoryData("BSC", "Basic Science Courses (BSC)", 32));
        catMap.put("ESC", new CategoryData("ESC", "Engineering Science Courses (ESC)", 30));
        catMap.put("FCC", new CategoryData("FCC", "Flexi Core Courses (FCC)", 3));
        catMap.put("PCC", new CategoryData("PCC", "Professional Core Courses (PCC)", 31));
        catMap.put("PEC", new CategoryData("PEC", "Professional Elective Courses (PEC)", 19));
        catMap.put("SDC", new CategoryData("SDC", "Skill Development Courses (SDC)", 8));
        catMap.put("PRI", new CategoryData("PRI", "Project Research and Internship (PRI)", 16));
        catMap.put("OEC", new CategoryData("OEC", "Open Elective Courses (OEC)", 12));
        catMap.put("SIL", new CategoryData("SIL", "Social Immersive Learning (SIL)", 3));
        catMap.put("VAC", new CategoryData("VAC", "Value Added Courses (VAC)", 0));
        catMap.put("AUC", new CategoryData("AUC", "Audit Courses (AUC)", 0));

        // 2. Load attempts lookup (courseCode -> attempts)
        List<StudentCourseAttempt> attempts = attemptRepository.findByUniversityId(student.getStudentId());
        Map<String, List<StudentCourseAttempt>> attemptMap = attempts.stream()
                .collect(Collectors.groupingBy(StudentCourseAttempt::getCourseCode));

        // 3. Load Courses via BucketSatisfactionEngine & CompletedCourseRepository
        Set<String> processedCourseCodes = new HashSet<>();
        try {
            List<Map<String, Object>> buckets = bucketSatisfactionEngine.getDetailedBucketProgress(studentId);
            for (Map<String, Object> b : buckets) {
                String bucketCode = String.valueOf(b.getOrDefault("bucketCode", "")).toUpperCase();
                String bucketName = String.valueOf(b.getOrDefault("bucketName", ""));
                String targetCat = resolveCategory(bucketCode, bucketName);

                @SuppressWarnings("unchecked")
                List<Map<String, Object>> compCourses = (List<Map<String, Object>>) b.get("completedCourses");
                if (compCourses != null && catMap.containsKey(targetCat)) {
                    CategoryData cat = catMap.get(targetCat);
                    for (Map<String, Object> c : compCourses) {
                        String code = String.valueOf(c.getOrDefault("courseCode", ""));
                        if (code.isBlank() || processedCourseCodes.contains(code)) continue;

                        String name = String.valueOf(c.getOrDefault("courseName", ""));
                        int credits = 0;
                        try {
                            credits = Integer.parseInt(String.valueOf(c.getOrDefault("credits", "0")));
                        } catch (Exception ignored) {}
                        String grade = String.valueOf(c.getOrDefault("grade", "Pass"));

                        String subCategory = resolveSubCategory(code, targetCat, bucketCode, bucketName);
                        CourseItem item = buildCourseItem(code, name, credits, grade, attemptMap.get(code), subCategory);
                        cat.courses.add(item);
                        cat.obtainedCredits += credits;
                        processedCourseCodes.add(code);
                    }
                }
            }
        } catch (Exception e) {
            log.warn("Detailed bucket progress not available for student {}: {}", student.getStudentId(), e.getMessage());
        }

        // Load explicit category assignments if any
        Map<String, String> explicitCategories = new HashMap<>();
        try {
            List<CompletedCourse> ccList = completedCourseRepository.findByStudentId(studentId);
            if (ccList.isEmpty()) {
                ccList = completedCourseRepository.findByUniversityId(student.getStudentId());
            }
            for (CompletedCourse cc : ccList) {
                if (cc.getCourseCode() != null && cc.getCategory() != null && !cc.getCategory().isBlank()) {
                    explicitCategories.put(cc.getCourseCode().trim().toUpperCase(), cc.getCategory().trim().toUpperCase());
                }
            }
        } catch (Exception ignored) {}

        // Supplementary check from StudentCourseRepository to ensure all courses appear
        List<StudentCourse> allStudentCourses = studentCourseRepository.findByStudentId(studentId);
        if (allStudentCourses.isEmpty()) {
            allStudentCourses = studentCourseRepository.findByUniversityId(student.getStudentId());
        }
        for (StudentCourse sc : allStudentCourses) {
            String code = sc.getCourseCode();
            if (code == null || code.isBlank() || processedCourseCodes.contains(code)) continue;
            if (sc.getStatus() != null && (sc.getStatus().equalsIgnoreCase("DROPPED") || sc.getStatus().equalsIgnoreCase("WITHDRAWN"))) {
                continue;
            }

            String targetCat = explicitCategories.get(code.toUpperCase());
            if (targetCat == null || !catMap.containsKey(targetCat)) {
                targetCat = guessCategoryFromCode(code);
            }
            CategoryData cat = catMap.get(targetCat);
            if (cat != null) {
                int cr = sc.getCredits() != null ? sc.getCredits().intValue() : 0;
                String subCategory = resolveSubCategory(code, targetCat, null, null);
                CourseItem item = buildCourseItem(code, sc.getCourseName(), cr, sc.getGrade(), attemptMap.get(code), subCategory);
                cat.courses.add(item);
                cat.obtainedCredits += cr;
                processedCourseCodes.add(code);
            }
        }

        // Calculate totals for all 10 categories
        int totalRequired = 0;
        int totalObtained = 0;
        for (CategoryData cat : catMap.values()) {
            cat.calculate();
            totalRequired += cat.requiredCredits;
            totalObtained += cat.obtainedCredits;
        }

        // Authoritatively resolve required credits from degree_paths matching department, addon, degree type, and academic_year
        if (degreePathEngine != null) {
            int pathRequired = degreePathEngine.getRequiredCreditsForStudent(student);
            if (pathRequired > 0) {
                totalRequired = pathRequired;
            }
        }
        int totalRemaining = Math.max(0, totalRequired - totalObtained);

        return new ReportCalculationResult(student, catMap, totalRequired, totalObtained, totalRemaining);
    }

    public Map<String, Object> getStudentExitRequirementReportData(String identifier) {
        Student student = findStudentByIdentifier(identifier);
        ReportCalculationResult result = calculateExitRequirementData(student);

        String studentName = student.getName();
        if (studentName == null || studentName.isBlank()) {
            studentName = ((student.getFirstName() != null ? student.getFirstName() : "") + " " +
                           (student.getLastName() != null ? student.getLastName() : "")).trim();
        }

        String dept = student.getDepartment() != null ? student.getDepartment().trim() : "AI&DS";
        String branch = ("AIDS".equalsIgnoreCase(dept) || "AI&DS".equalsIgnoreCase(dept)) ? "AI&DS" : dept;

        String spec = (student.getSpecializationName() != null && !student.getSpecializationName().isBlank())
                ? student.getSpecializationName() : "General Track";

        String admYear = student.getAcademicYear() != null ? student.getAcademicYear() : "2023";
        String dateOfAdmission = "July " + (admYear.contains("-") ? admYear.split("-")[0] : admYear);

        DegreePath dp = degreePathEngine != null ? degreePathEngine.findMatchingDegreePath(student) : null;
        String pathCode = dp != null ? dp.getPathCode() : (branch + "-REGULAR");
        String academicYear = dp != null && dp.getAcademicYear() != null ? dp.getAcademicYear() : (degreePathEngine != null ? degreePathEngine.resolveAcademicYear(student) : "Y23");

        Map<String, Object> studentInfo = new LinkedHashMap<>();
        studentInfo.put("studentDbId", student.getId());
        studentInfo.put("rollNumber", student.getStudentId());
        studentInfo.put("studentName", studentName);
        studentInfo.put("programme", "B. TECH");
        studentInfo.put("branch", branch);
        studentInfo.put("department", dept);
        studentInfo.put("counsellor", "Faculty Mentor");
        studentInfo.put("specialization", spec);
        studentInfo.put("dateOfAdmission", dateOfAdmission);
        studentInfo.put("expectedGraduation", "May 2027");
        studentInfo.put("pathCode", pathCode);
        studentInfo.put("academicYear", academicYear);
        studentInfo.put("degreeType", student.getSubDepartment() != null ? student.getSubDepartment() : "REGULAR");
        studentInfo.put("addon", student.getSpecializationType() != null ? student.getSpecializationType() : "NONE");
        studentInfo.put("totalRequiredCredits", result.totalRequired);

        Map<String, Object> summaryInfo = new LinkedHashMap<>();
        summaryInfo.put("totalRequiredCredits", result.totalRequired);
        summaryInfo.put("totalObtainedCredits", result.totalObtained);
        summaryInfo.put("totalRemainingCredits", result.totalRemaining);
        summaryInfo.put("isEligible", result.totalObtained >= result.totalRequired);
        summaryInfo.put("pathCode", pathCode);
        summaryInfo.put("academicYear", academicYear);
        summaryInfo.put("degreeType", student.getSubDepartment() != null ? student.getSubDepartment() : "REGULAR");

        List<Map<String, Object>> categoriesList = new ArrayList<>();
        for (CategoryData cat : result.catMap.values()) {
            Map<String, Object> cMap = new LinkedHashMap<>();
            cMap.put("categoryCode", cat.categoryCode);
            cMap.put("description", cat.description);
            cMap.put("requiredCredits", cat.requiredCredits);
            cMap.put("obtainedCredits", cat.obtainedCredits);
            cMap.put("remainingCredits", cat.remainingCredits);
            cMap.put("status", cat.status);

            List<Map<String, Object>> coursesList = new ArrayList<>();
            int sNo = 1;
            for (CourseItem ci : cat.courses) {
                Map<String, Object> courseMap = new LinkedHashMap<>();
                courseMap.put("sNo", sNo++);
                courseMap.put("courseCode", ci.courseCode);
                courseMap.put("courseName", ci.courseName);
                courseMap.put("credits", ci.credits);
                courseMap.put("subCategory", ci.subCategory);
                courseMap.put("attempt1", ci.attempt1);
                courseMap.put("attempt2", ci.attempt2);
                courseMap.put("attempt3", ci.attempt3);
                coursesList.add(courseMap);
            }
            cMap.put("courses", coursesList);
            categoriesList.add(cMap);
        }

        Map<String, Object> endorsement = new LinkedHashMap<>();
        String formattedDate = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        endorsement.put("date", formattedDate);
        endorsement.put("verified", false);
        endorsement.put("token", null);

        exitSummaryRepository.findByStudentId(student.getId()).ifPresent(s -> {
            if ("CLEARED_FOR_GRADUATION".equalsIgnoreCase(s.getOverallStatus()) && s.getCertificateToken() != null) {
                endorsement.put("verified", true);
                endorsement.put("token", s.getCertificateToken());
            } else if (s.getCertificateToken() != null) {
                endorsement.put("token", s.getCertificateToken());
            }
        });

        if (endorsement.get("token") == null) {
            endorsement.put("token", "KLU-GRAD-" + student.getStudentId() + "-" + Integer.toHexString(student.getStudentId().hashCode()).toUpperCase());
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("student", studentInfo);
        response.put("summary", summaryInfo);
        response.put("categories", categoriesList);
        response.put("endorsement", endorsement);

        return response;
    }

    public byte[] generateStudentExitRequirementPdf(String identifier) throws Exception {
        Student student = findStudentByIdentifier(identifier);
        return generateStudentExitRequirementPdf(student.getId());
    }

    /**
     * Generates a fully populated Student Exit Requirement PDF based strictly on the official 6-page template.
     */
    public byte[] generateStudentExitRequirementPdf(Long studentId) throws Exception {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student record not found for ID: " + studentId));

        ReportCalculationResult result = calculateExitRequirementData(student);
        Map<String, CategoryData> catMap = result.catMap;
        int totalRequired = result.totalRequired;
        int totalObtained = result.totalObtained;
        int totalRemaining = result.totalRemaining;

        // 4. Load the PDF Template
        byte[] templateBytes = loadTemplateBytes();
        try (PDDocument document = Loader.loadPDF(templateBytes)) {
            PDType1Font fontRegular = new PDType1Font(Standard14Fonts.FontName.HELVETICA);
            PDType1Font fontBold = new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD);

            // -------------------------------------------------------------
            // PAGE 1: Student Information & Credit Summary
            // -------------------------------------------------------------
            PDPage page1 = document.getPage(0);
            try (PDPageContentStream cs = new PDPageContentStream(document, page1, PDPageContentStream.AppendMode.APPEND, true, true)) {
                // Student Name
                String studentName = student.getName();
                if (studentName == null || studentName.isBlank()) {
                    studentName = (student.getFirstName() + " " + student.getLastName()).trim();
                }
                drawText(cs, fontBold, 9.0f, 135.0f, 648.6f, studentName);

                // Roll Number
                drawText(cs, fontBold, 9.0f, 135.0f, 627.4f, student.getStudentId());

                // Branch (if CSE, cover AI&DS and write CSE; if AIDS write AI&DS)
                String dept = student.getDepartment() != null ? student.getDepartment().trim() : "AI&DS";
                if (!"AIDS".equalsIgnoreCase(dept) && !"AI&DS".equalsIgnoreCase(dept)) {
                    // Whiteout AI&DS
                    cs.setNonStrokingColor(1f, 1f, 1f);
                    cs.addRect(394.0f, 624.0f, 60.0f, 14.0f);
                    cs.fill();
                    cs.setNonStrokingColor(15f / 255f, 23f / 255f, 42f / 255f);
                    drawText(cs, fontBold, 9.0f, 397.0f, 627.4f, dept);
                }

                // Counsellor
                String counsellor = "Faculty Mentor";
                drawText(cs, fontRegular, 8.5f, 135.0f, 606.2f, counsellor);

                // Specialization
                String spec = student.getSpecializationName() != null && !student.getSpecializationName().isBlank()
                        ? student.getSpecializationName()
                        : "General Track";
                if (spec.length() > 24) spec = spec.substring(0, 22) + "...";
                drawText(cs, fontRegular, 8.0f, 397.0f, 606.2f, spec);

                // Date of Admission & Expected Graduation
                String admYear = student.getAcademicYear() != null ? student.getAcademicYear() : "2023";
                drawText(cs, fontRegular, 8.5f, 135.0f, 574.8f, "July " + admYear.split("-")[0]);
                drawText(cs, fontRegular, 8.5f, 415.0f, 574.8f, "May 2027");

                // Credit Summary Table (Rows 1 to 10 + TOTAL)
                float[] catRowY = {
                        484.6f, // HAS
                        463.4f, // BSC
                        442.3f, // ESC
                        421.2f, // FCC
                        400.0f, // PCC
                        378.8f, // PEC
                        357.7f, // SDC
                        336.6f, // PRI
                        315.5f, // OEC
                        294.2f  // SIL
                };
                String[] mainPdfCategories = { "HAS", "BSC", "ESC", "FCC", "PCC", "PEC", "SDC", "PRI", "OEC", "SIL" };
                for (int i = 0; i < mainPdfCategories.length; i++) {
                    CategoryData cat = catMap.get(mainPdfCategories[i]);
                    if (cat == null) continue;
                    float y = catRowY[i];
                    // Center in Obtained column (415..485)
                    drawCenteredText(cs, fontBold, 8.5f, 415.0f, 485.0f, y, String.valueOf(cat.obtainedCredits));
                    // Center in Remaining column (485..562)
                    drawCenteredText(cs, fontBold, 8.5f, 485.0f, 562.0f, y, String.valueOf(cat.remainingCredits));
                }

                // Total Row
                float totalY = 272.2f;
                drawCenteredText(cs, fontBold, 9.0f, 415.0f, 485.0f, totalY, String.valueOf(totalObtained));
                drawCenteredText(cs, fontBold, 9.0f, 485.0f, 562.0f, totalY, String.valueOf(totalRemaining));
            }

            // -------------------------------------------------------------
            // PAGE 2: HAS Table & Summary, BSC Table
            // -------------------------------------------------------------
            PDPage page2 = document.getPage(1);
            try (PDPageContentStream cs = new PDPageContentStream(document, page2, PDPageContentStream.AppendMode.APPEND, true, true)) {
                // HAS Course Table (max 10 rows)
                float[] hasY = { 629.4f, 609.2f, 589.2f, 569.0f, 548.9f, 528.7f, 508.6f, 488.4f, 468.2f, 448.1f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("HAS").courses, hasY);

                // HAS Summary Bar
                CategoryData hasCat = catMap.get("HAS");
                drawSummaryBar(cs, fontBold, 409.3f, 397.2f, hasCat.obtainedCredits, hasCat.remainingCredits, hasCat.status);

                // BSC Course Table (max 10 rows)
                float[] bscY = { 254.4f, 234.2f, 214.1f, 193.9f, 173.9f, 153.7f, 133.6f, 113.4f, 93.2f, 73.1f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("BSC").courses, bscY);
            }

            // -------------------------------------------------------------
            // PAGE 3: BSC Summary, ESC Table & Summary, FCC Table & Summary
            // -------------------------------------------------------------
            PDPage page3 = document.getPage(2);
            try (PDPageContentStream cs = new PDPageContentStream(document, page3, PDPageContentStream.AppendMode.APPEND, true, true)) {
                // BSC Summary Bar (top of Page 3)
                CategoryData bscCat = catMap.get("BSC");
                drawSummaryBar(cs, fontBold, 712.4f, 700.4f, bscCat.obtainedCredits, bscCat.remainingCredits, bscCat.status);

                // ESC Course Table (max 10 rows)
                float[] escY = { 557.6f, 537.5f, 517.3f, 497.2f, 477.0f, 456.8f, 436.7f, 416.5f, 396.4f, 376.3f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("ESC").courses, escY);

                // ESC Summary Bar
                CategoryData escCat = catMap.get("ESC");
                drawSummaryBar(cs, fontBold, 337.4f, 325.4f, escCat.obtainedCredits, escCat.remainingCredits, escCat.status);

                // FCC Course Table (max 2 rows)
                float[] fccY = { 182.5f, 162.5f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("FCC").courses, fccY);

                // FCC Summary Bar
                CategoryData fccCat = catMap.get("FCC");
                drawSummaryBar(cs, fontBold, 123.6f, 111.6f, fccCat.obtainedCredits, fccCat.remainingCredits, fccCat.status);
            }

            // -------------------------------------------------------------
            // PAGE 4: PCC Table & Summary, PEC Table
            // -------------------------------------------------------------
            PDPage page4 = document.getPage(3);
            try (PDPageContentStream cs = new PDPageContentStream(document, page4, PDPageContentStream.AppendMode.APPEND, true, true)) {
                // PCC Course Table (max 10 rows)
                float[] pccY = { 654.1f, 634.0f, 613.8f, 593.6f, 573.6f, 553.4f, 533.3f, 513.1f, 493.0f, 472.8f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("PCC").courses, pccY);

                // PCC Summary Bar
                CategoryData pccCat = catMap.get("PCC");
                drawSummaryBar(cs, fontBold, 433.9f, 421.9f, pccCat.obtainedCredits, pccCat.remainingCredits, pccCat.status);

                // PEC Course Table (max 10 rows)
                float[] pecY = { 279.1f, 259.0f, 238.8f, 218.6f, 198.5f, 178.3f, 158.3f, 138.1f, 118.0f, 97.8f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("PEC").courses, pecY);
            }

            // -------------------------------------------------------------
            // PAGE 5: PEC Summary, SDC Table & Summary, PRI Table & Summary
            // -------------------------------------------------------------
            PDPage page5 = document.getPage(4);
            try (PDPageContentStream cs = new PDPageContentStream(document, page5, PDPageContentStream.AppendMode.APPEND, true, true)) {
                // PEC Summary Bar (top of Page 5)
                CategoryData pecCat = catMap.get("PEC");
                drawSummaryBar(cs, fontBold, 725.0f, 713.0f, pecCat.obtainedCredits, pecCat.remainingCredits, pecCat.status);

                // SDC Course Table (max 4 rows)
                float[] sdcY = { 570.2f, 550.1f, 529.9f, 509.8f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("SDC").courses, sdcY);

                // SDC Summary Bar
                CategoryData sdcCat = catMap.get("SDC");
                drawSummaryBar(cs, fontBold, 450.8f, 438.8f, sdcCat.obtainedCredits, sdcCat.remainingCredits, sdcCat.status);

                // PRI Course Table (max 4 rows)
                float[] priY = { 295.9f, 275.8f, 255.7f, 235.6f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("PRI").courses, priY);

                // PRI Summary Bar
                CategoryData priCat = catMap.get("PRI");
                drawSummaryBar(cs, fontBold, 176.5f, 164.5f, priCat.obtainedCredits, priCat.remainingCredits, priCat.status);
            }

            // -------------------------------------------------------------
            // PAGE 6: OEC Table & Summary, SIL Table & Summary, Signatures
            // -------------------------------------------------------------
            PDPage page6 = document.getPage(5);
            try (PDPageContentStream cs = new PDPageContentStream(document, page6, PDPageContentStream.AppendMode.APPEND, true, true)) {
                // OEC Course Table (max 5 rows)
                float[] oecY = { 629.4f, 609.2f, 589.2f, 569.0f, 548.9f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("OEC").courses, oecY);

                // OEC Summary Bar
                CategoryData oecCat = catMap.get("OEC");
                drawSummaryBar(cs, fontBold, 510.0f, 498.0f, oecCat.obtainedCredits, oecCat.remainingCredits, oecCat.status);

                // SIL Course Table (max 1 row)
                float[] silY = { 355.2f };
                drawCourseTableRows(cs, fontRegular, fontBold, catMap.get("SIL").courses, silY);

                // SIL Summary Bar
                CategoryData silCat = catMap.get("SIL");
                drawSummaryBar(cs, fontBold, 296.2f, 284.2f, silCat.obtainedCredits, silCat.remainingCredits, silCat.status);

                // Certification and Signatures Section
                String formattedDate = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                drawText(cs, fontRegular, 8.0f, 120.0f, 90.5f, formattedDate);
                drawText(cs, fontRegular, 8.0f, 290.0f, 89.3f, formattedDate);
                drawText(cs, fontRegular, 8.0f, 460.0f, 90.5f, formattedDate);

                // If graduation is approved, print official certificate endorsement
                exitSummaryRepository.findByStudentId(studentId).ifPresent(summary -> {
                    if ("CLEARED_FOR_GRADUATION".equalsIgnoreCase(summary.getOverallStatus()) && summary.getCertificateToken() != null) {
                        try {
                            cs.setNonStrokingColor(180f / 255f, 20f / 255f, 30f / 255f);
                            drawText(cs, fontBold, 7.5f, 50.0f, 175.0f, "OFFICIAL INSTITUTIONAL ENDORSEMENT: " + summary.getCertificateToken());
                        } catch (Exception ignored) {}
                    }
                });
            }

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            document.save(baos);
            return baos.toByteArray();
        }
    }

    private CourseItem buildCourseItem(String code, String name, int credits, String grade, List<StudentCourseAttempt> attempts) {
        return buildCourseItem(code, name, credits, grade, attempts, "-");
    }

    private CourseItem buildCourseItem(String code, String name, int credits, String grade, List<StudentCourseAttempt> attempts, String subCategory) {
        CourseItem item = new CourseItem(code, name, credits, grade, subCategory);
        if (attempts != null && !attempts.isEmpty()) {
            attempts.sort(Comparator.comparing(StudentCourseAttempt::getAttemptNumber, Comparator.nullsLast(Comparator.naturalOrder())));
            if (attempts.size() >= 1 && attempts.get(0).getGrade() != null && !"null".equalsIgnoreCase(attempts.get(0).getGrade().trim())) {
                item.attempt1 = attempts.get(0).getGrade().trim();
            }
            if (attempts.size() >= 2 && attempts.get(1).getGrade() != null && !"null".equalsIgnoreCase(attempts.get(1).getGrade().trim())) {
                item.attempt2 = attempts.get(1).getGrade().trim();
            }
            if (attempts.size() >= 3 && attempts.get(2).getGrade() != null && !"null".equalsIgnoreCase(attempts.get(2).getGrade().trim())) {
                item.attempt3 = attempts.get(2).getGrade().trim();
            }
        }
        if (item.attempt1 == null || item.attempt1.isBlank() || "null".equalsIgnoreCase(item.attempt1.trim())) {
            item.attempt1 = "Pass";
        }
        if (item.attempt2 == null || "null".equalsIgnoreCase(item.attempt2.trim())) item.attempt2 = "-";
        if (item.attempt3 == null || "null".equalsIgnoreCase(item.attempt3.trim())) item.attempt3 = "-";
        return item;
    }

    private void drawCourseTableRows(PDPageContentStream cs, PDType1Font fontRegular, PDType1Font fontBold, List<CourseItem> items, float[] rowY) throws Exception {
        if (items == null) return;
        int max = Math.min(items.size(), rowY.length);
        for (int i = 0; i < max; i++) {
            CourseItem item = items.get(i);
            float y = rowY[i];

            // Course Code (X=89.0)
            drawText(cs, fontBold, 7.5f, 89.0f, y, cleanText(item.courseCode));

            // Course Name (X=165.0, max width 205 pt)
            String truncatedName = truncate(item.courseName, fontRegular, 7.5f, 205.0f);
            drawText(cs, fontRegular, 7.5f, 165.0f, y, truncatedName);

            // Credits (centered in 375..415)
            drawCenteredText(cs, fontBold, 7.5f, 375.0f, 415.0f, y, String.valueOf(item.credits));

            // Attempt 1 (centered in 415..464)
            drawCenteredText(cs, fontRegular, 7.5f, 415.0f, 464.0f, y, cleanText(item.attempt1));

            // Attempt 2 (centered in 464..513)
            drawCenteredText(cs, fontRegular, 7.5f, 464.0f, 513.0f, y, cleanText(item.attempt2));

            // Attempt 3 (centered in 513..562)
            drawCenteredText(cs, fontRegular, 7.5f, 513.0f, 562.0f, y, cleanText(item.attempt3));
        }
    }

    private void drawSummaryBar(PDPageContentStream cs, PDType1Font fontBold, float yLine1, float yLine2, int obtained, int remaining, String status) throws Exception {
        // Obtained Credits on line: centered on underline at 254..284
        drawCenteredText(cs, fontBold, 8.5f, 254.0f, 284.0f, yLine1 + 0.5f, String.valueOf(obtained));

        // Credits Remaining on line: centered on underline at 388..418
        drawCenteredText(cs, fontBold, 8.5f, 388.0f, 418.0f, yLine1 + 0.5f, String.valueOf(remaining));

        // Status checkbox tick
        float tickY;
        float tickX;
        if ("Complete".equalsIgnoreCase(status)) {
            tickX = 472.0f;
            tickY = yLine1 + 2.0f;
        } else if ("In Progress".equalsIgnoreCase(status)) {
            tickX = 530.0f;
            tickY = yLine1 + 2.0f;
        } else {
            tickX = 487.0f;
            tickY = yLine2 + 2.0f;
        }

        // Draw crisp green checkmark in checkbox
        drawCheckmark(cs, tickX, tickY);
    }

    private void drawCheckmark(PDPageContentStream cs, float x, float y) throws Exception {
        cs.setStrokingColor(16f / 255f, 120f / 255f, 40f / 255f); // vibrant green
        cs.setLineWidth(1.3f);
        cs.moveTo(x - 2.5f, y + 1.0f);
        cs.lineTo(x, y - 1.5f);
        cs.lineTo(x + 4.0f, y + 4.5f);
        cs.stroke();
        cs.setNonStrokingColor(15f / 255f, 23f / 255f, 42f / 255f); // reset text color to dark
    }

    private void drawText(PDPageContentStream cs, PDType1Font font, float fontSize, float x, float y, String text) throws Exception {
        if (text == null || text.isBlank()) return;
        String cleaned = cleanText(text);
        if (cleaned.isBlank()) return;
        cs.setNonStrokingColor(15f / 255f, 23f / 255f, 42f / 255f);
        cs.beginText();
        try {
            cs.setFont(font, fontSize);
            cs.newLineAtOffset(x, y);
            cs.showText(cleaned);
        } finally {
            cs.endText();
        }
    }

    private void drawCenteredText(PDPageContentStream cs, PDType1Font font, float fontSize, float leftX, float rightX, float y, String text) throws Exception {
        if (text == null || text.isBlank()) return;
        String cleaned = cleanText(text);
        if (cleaned.isBlank()) return;
        float textWidth = 0f;
        try {
            textWidth = font.getStringWidth(cleaned) / 1000f * fontSize;
        } catch (Exception ignored) {}
        float x = leftX + ((rightX - leftX) - textWidth) / 2f;
        cs.setNonStrokingColor(15f / 255f, 23f / 255f, 42f / 255f);
        cs.beginText();
        try {
            cs.setFont(font, fontSize);
            cs.newLineAtOffset(x, y);
            cs.showText(cleaned);
        } finally {
            cs.endText();
        }
    }

    private String cleanText(String s) {
        if (s == null) return "";
        return s.replace('\n', ' ')
                .replace('\r', ' ')
                .replace('\t', ' ')
                .replace('—', '-')
                .replace('–', '-')
                .replace('“', '"')
                .replace('”', '"')
                .replace('‘', '\'')
                .replace('’', '\'')
                .replaceAll("[^\\x20-\\x7E]", "")
                .trim();
    }

    private String truncate(String text, PDType1Font font, float fontSize, float maxWidth) throws Exception {
        if (text == null) return "";
        String cleaned = cleanText(text);
        if (font.getStringWidth(cleaned) / 1000f * fontSize <= maxWidth) {
            return cleaned;
        }
        while (cleaned.length() > 3 && font.getStringWidth(cleaned + "...") / 1000f * fontSize > maxWidth) {
            cleaned = cleaned.substring(0, cleaned.length() - 1);
        }
        return cleaned + "...";
    }

    private String resolveCategory(String bucketKey, String desc) {
        if (bucketKey == null) bucketKey = "";
        if (desc == null) desc = "";
        String b = (bucketKey + " " + desc).toUpperCase();

        if (b.contains("VAC") || b.contains("VALUE ADDED") || b.contains("CERTIFICATION") || b.contains("SPORTS")) return "VAC";
        if (b.contains("AUC") || b.contains("AUDIT") || b.contains("CAREER") || b.contains("CRT")) return "AUC";
        if (b.contains("HAS") || b.contains("HUMANITIES") || b.contains("MANAGEMENT ELECTIVE")) return "HAS";
        if (b.contains("BSC") || b.contains("BASIC SCIENCE") || b.contains("MATHEMATICS ELECTIVE") || b.contains("SCIENCE ELECTIVE")) return "BSC";
        if (b.contains("ESC") || b.contains("ENGINEERING SCIENCE")) return "ESC";
        if (b.contains("FC-") || b.contains("FCC") || b.contains("FLEXI CORE")) return "FCC";
        if (b.contains("PCC") || b.contains("PROFESSIONAL CORE")) return "PCC";
        if (b.contains("PEC") || b.contains("PROGRAM ELECTIVE") || b.contains("PROFESSIONAL ELECTIVE") || b.contains("PE-") || b.contains("PE1") || b.contains("PE2") || b.contains("PE3") || b.contains("PE4") || b.contains("PE5") || b.contains("HEC")) return "PEC";
        if (b.contains("SDC") || b.contains("SDP") || b.contains("SKILL")) return "SDC";
        if (b.contains("PRI") || b.contains("PROJECT") || b.contains("INTERNSHIP") || b.contains("RESEARCH")) return "PRI";
        if (b.contains("OEC") || b.contains("OE-") || b.contains("OE1") || b.contains("OE2") || b.contains("OE3") || b.contains("OPEN ELECTIVE")) return "OEC";
        if (b.contains("SIL") || b.contains("SOCIAL IMMERSIVE") || b.contains("SELF INITIATED")) return "SIL";
        return null;
    }

    private String guessCategoryFromCode(String code) {
        if (code == null) return "OEC";
        String c = code.toUpperCase();
        if (c.startsWith("23CC") || c.startsWith("23SP") || c.startsWith("VAC") || c.contains("CERT")) return "VAC";
        if (c.startsWith("CRT") || c.startsWith("23UC00") || c.endsWith("L") || c.startsWith("AUC") || c.contains("PRACTICUM")) return "AUC";
        if (c.startsWith("22UC") || c.startsWith("SIL")) return "SIL";
        if (c.startsWith("23UC") || c.startsWith("23HS") || c.startsWith("23EN") || c.startsWith("23MG")) return "HAS";
        if (c.endsWith("F") || c.contains("FCC") || c.contains("FC-")) return "FCC";
        if (c.startsWith("23MT") || c.startsWith("23SC3") || c.startsWith("23MA") || c.startsWith("23PH") || c.startsWith("23CH")) return "BSC";
        if (c.startsWith("23EC") || c.startsWith("23EE") || c.startsWith("23ME") || c.startsWith("23SC1") || "23CS1207".equalsIgnoreCase(c)) return "ESC";
        if (c.startsWith("23SD") || c.contains("SDC") || c.contains("SDP")) return "SDC";
        if (c.startsWith("23IE") || c.startsWith("23PR") || c.startsWith("23IN") || c.startsWith("23CP")) return "PRI";
        if (c.startsWith("23ALT") || c.startsWith("23PE") || c.contains("PEC")) return "PEC";
        if (c.startsWith("23CS") || c.startsWith("23AD")) return "PCC";
        if (c.startsWith("OE")) return "OEC";
        return "PCC";
    }

    private String resolveSubCategory(String code, String targetCategory, String bucketCode, String bucketName) {
        String c = code != null ? code.trim().toUpperCase() : "";
        String bc = bucketCode != null ? bucketCode.trim().toUpperCase() : "";
        String bn = bucketName != null ? bucketName.trim().toUpperCase() : "";

        if (bc.contains("VAC-CERT") || bn.contains("CERTIFICATION") || c.startsWith("23CC") || c.contains("CERT")) {
            return "VAC-CERT (Certification)";
        }
        if (bc.contains("VAC-SPORTS") || bn.contains("SPORTS") || c.startsWith("23SP")) {
            return "VAC-SPORTS (Sports)";
        }
        if ("VAC".equalsIgnoreCase(targetCategory) || bc.startsWith("VAC")) {
            return "VAC-CORE (Value Added)";
        }

        if (bc.contains("AUC-CAREER") || bn.contains("CAREER") || c.startsWith("CRT")) {
            return "AUC-CAREER (Career Training)";
        }
        if (bc.contains("AUC-CORE") || bn.contains("AUDIT") || c.startsWith("23UC00") || c.endsWith("L") || c.contains("PRACTICUM")) {
            return "AUC-CORE (Audit Core)";
        }
        if ("AUC".equalsIgnoreCase(targetCategory) || bc.startsWith("AUC")) {
            return "AUC-AUDIT (Audit Course)";
        }

        if ("PEC".equalsIgnoreCase(targetCategory)) {
            if (bc.contains("PE1") || bc.contains("PE-1") || bn.contains("ELECTIVE 1")) return "PE-1 (Program Elective)";
            if (bc.contains("PE2") || bc.contains("PE-2") || bn.contains("ELECTIVE 2")) return "PE-2 (Program Elective)";
            if (bc.contains("PE3") || bc.contains("PE-3") || bn.contains("ELECTIVE 3")) return "PE-3 (Program Elective)";
            if (bc.contains("PE4") || bc.contains("PE-4") || bn.contains("ELECTIVE 4")) return "PE-4 (Program Elective)";
            if (bc.contains("PE5") || bc.contains("PE-5") || bn.contains("ELECTIVE 5")) return "PE-5 (Program Elective)";
            return "PE-1 (Program Elective)";
        }

        if ("HAS".equalsIgnoreCase(targetCategory)) return "HAS-CORE";
        if ("BSC".equalsIgnoreCase(targetCategory)) {
            if (c.startsWith("23MT") || c.startsWith("23SC3") || bn.contains("MATH")) return "BSC-ME (Math Elective)";
            return "BSC-CORE";
        }
        if ("ESC".equalsIgnoreCase(targetCategory)) return "ESC-CORE";
        if ("FCC".equalsIgnoreCase(targetCategory)) return "FC-1 (Flexi Core)";
        if ("PCC".equalsIgnoreCase(targetCategory)) return "PCC-CORE";
        if ("SDC".equalsIgnoreCase(targetCategory)) return "SDP (Skill Development)";
        if ("PRI".equalsIgnoreCase(targetCategory)) {
            if (bn.contains("INTERN") || c.startsWith("23IE") || c.startsWith("23IN")) return "PRI-INTERNSHIP";
            return "PRI-PROJECT";
        }
        if ("SIL".equalsIgnoreCase(targetCategory)) return "SIL-CORE (Social Immersive)";
        if ("OEC".equalsIgnoreCase(targetCategory)) return "OE-1 (Open Elective)";

        if (!bc.isBlank()) return bc;
        return "-";
    }

    public byte[] loadTemplateBytes() throws Exception {
        String[] possiblePaths = {
                "templates/Student_exit_requirement.pdf",
                "Student_exit_requirement.pdf",
                "/templates/Student_exit_requirement.pdf",
                "/Student_exit_requirement.pdf"
        };
        for (String path : possiblePaths) {
            try {
                ClassPathResource cpr = new ClassPathResource(path);
                if (cpr.exists()) {
                    try (InputStream is = cpr.getInputStream()) {
                        return is.readAllBytes();
                    }
                }
            } catch (Exception ignored) {}
        }

        // Direct filesystem paths
        java.io.File file = new java.io.File("src/main/resources/templates/Student_exit_requirement.pdf");
        if (file.exists()) return java.nio.file.Files.readAllBytes(file.toPath());
        file = new java.io.File("src/main/resources/Student_exit_requirement.pdf");
        if (file.exists()) return java.nio.file.Files.readAllBytes(file.toPath());
        file = new java.io.File("curriculum/Student_exit_requirement.pdf");
        if (file.exists()) return java.nio.file.Files.readAllBytes(file.toPath());
        file = new java.io.File("C:/Users/venka/Downloads/Student_exit_requirement.pdf");
        if (file.exists()) return java.nio.file.Files.readAllBytes(file.toPath());

        throw new IllegalStateException("Student_exit_requirement.pdf template not found.");
    }
}
