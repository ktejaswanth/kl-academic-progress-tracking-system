package com.example.demo.service;

import com.example.demo.controller.AddCourseController.AddCourseRequest;
import com.example.demo.dto.UpdateCourseRequest;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
@Transactional
public class AddCourseService {

    static {
        IOUtils.setByteArrayMaxOverride(Integer.MAX_VALUE);
        ZipSecureFile.setMinInflateRatio(0.0);
    }

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private CourseCatalogRepository courseCatalogRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private StudentCourseRepository studentCourseRepository;

    @Autowired
    private StudentCourseAttemptRepository studentCourseAttemptRepository;

    @Autowired
    private CurriculumCourseRepository curriculumCourseRepository;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private BucketMappingEngine bucketMappingEngine;

    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    /**
     * Resolves student entity from universityId in students table directly.
     * Checks students table and auto-registers in students table if not found.
     * Does NOT use or populate the users table.
     */
    public Student resolveOrCreateStudent(String universityId, String studentName, String branch, String academicYear) {
        if (universityId == null || universityId.trim().isEmpty()) {
            throw new IllegalArgumentException("University ID cannot be null or empty.");
        }
        String cleanUnivId = universityId.trim();

        // 1. Try finding in students table
        Optional<Student> studentOpt = studentRepository.findByStudentId(cleanUnivId);
        if (studentOpt.isPresent()) {
            return studentOpt.get();
        }

        // 2. Auto-create student in students table
        String firstName = cleanUnivId;
        String lastName = "";
        if (studentName != null && !studentName.trim().isEmpty()) {
            String trimmedName = studentName.trim();
            int spaceIdx = trimmedName.indexOf(' ');
            if (spaceIdx > 0) {
                firstName = trimmedName.substring(0, spaceIdx).trim();
                lastName = trimmedName.substring(spaceIdx + 1).trim();
            } else {
                firstName = trimmedName;
            }
        }
        String dept = (branch != null && !branch.trim().isEmpty()) ? branch.trim() : "CSE";
        String acadYr = (academicYear != null && !academicYear.trim().isEmpty()) ? academicYear.trim() : "Y23";
        String email = cleanUnivId.toLowerCase() + "@kluniversity.in";
        String rawPassword = cleanUnivId;
        String encodedPassword = passwordEncoder.encode(rawPassword);

        Student newStudent = new Student();
        newStudent.setStudentId(cleanUnivId);
        newStudent.setFirstName(firstName);
        newStudent.setLastName(lastName);
        newStudent.setEmail(email);
        newStudent.setPassword(encodedPassword);
        newStudent.setRawPassword(rawPassword);
        newStudent.setDepartment(dept);
        newStudent.setSubDepartment("REGULAR");
        newStudent.setSpecializationType("NONE");
        newStudent.setSpecializationName("N/A");
        newStudent.setAcademicYear(acadYr);
        newStudent.setIsActive(true);
        newStudent.setFirstLoginCompleted(false);
        return studentRepository.save(newStudent);
    }

    /**
     * Resolves course from CourseCatalog. If missing, auto-creates entry so upload never fails.
     */
    public CourseCatalog resolveOrCreateCourseCatalog(String courseCode, String courseName, String ltps, String branch) {
        if (courseCode == null || courseCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Course code cannot be null or empty.");
        }
        String cleanCode = courseCode.trim();

        Optional<CourseCatalog> catalogOpt = courseCatalogRepository.findByCourseCode(cleanCode);
        if (catalogOpt.isPresent()) {
            CourseCatalog cat = catalogOpt.get();
            if (cat.getCredits() == null) {
                int credits = parseCreditsFromLtps(ltps);
                cat.setCredits(credits);
                return courseCatalogRepository.save(cat);
            }
            return cat;
        }

        // Auto-create course catalog entry
        int credits = parseCreditsFromLtps(ltps);
        String finalName = (courseName != null && !courseName.trim().isEmpty()) ? courseName.trim() : cleanCode;
        CourseCatalog newCatalog = new CourseCatalog();
        newCatalog.setCourseCode(cleanCode);
        newCatalog.setCourseName(finalName);
        newCatalog.setCredits(credits);
        newCatalog.setCategory((branch != null && !branch.trim().isEmpty()) ? branch.trim() : "GENERAL");
        return courseCatalogRepository.save(newCatalog);
    }

    /**
     * Parse credits from LTPS string like "3-0-2-0", "3-0-0", "4", etc.
     */
    public static int parseCreditsFromLtps(String ltps) {
        if (ltps == null || ltps.trim().isEmpty()) {
            return 3;
        }
        String clean = ltps.trim();
        try {
            return Integer.parseInt(clean);
        } catch (NumberFormatException ignored) {}

        String[] parts = clean.split("[-:, /]+");
        List<Double> nums = new ArrayList<>();
        for (String p : parts) {
            try {
                nums.add(Double.parseDouble(p.trim()));
            } catch (NumberFormatException ignored) {}
        }
        if (nums.isEmpty()) {
            return 3;
        }
        if (nums.size() == 1) {
            return Math.max(1, nums.get(0).intValue());
        }
        if (nums.size() >= 4) {
            double l = nums.get(0);
            double t = nums.get(1);
            double p = nums.get(2);
            double s = nums.get(3);
            double credits = l + t + (p * 0.5) + (s * 0.5);
            return Math.max(1, (int) Math.round(credits));
        }
        if (nums.size() == 3) {
            double l = nums.get(0);
            double t = nums.get(1);
            double p = nums.get(2);
            double credits = l + t + (p * 0.5);
            return Math.max(1, (int) Math.round(credits));
        }
        return Math.max(1, nums.get(0).intValue());
    }

    /**
     * Add a single completed course entry for a student.
     */
    public Map<String, Object> addSingleCourse(AddCourseRequest request, Long verifiedById) {
        if (request.getUniversityId() == null || request.getUniversityId().trim().isEmpty()) {
            if (request.getStudentId() != null) {
                Optional<Student> sOpt = studentRepository.findById(request.getStudentId());
                if (sOpt.isPresent()) {
                    request.setUniversityId(sOpt.get().getStudentId());
                    if (request.getStudentName() == null || request.getStudentName().trim().isEmpty()) {
                        request.setStudentName(sOpt.get().getFirstName() + " " + (sOpt.get().getLastName() != null ? sOpt.get().getLastName() : ""));
                    }
                } else {
                    throw new RuntimeException("Student not found for ID: " + request.getStudentId());
                }
            } else {
                throw new RuntimeException("Student university ID is required.");
            }
        }

        Student student = resolveOrCreateStudent(request.getUniversityId(), request.getStudentName(), request.getBranch(), request.getAcademicYear());


        CourseCatalog catalog = resolveOrCreateCourseCatalog(request.getCourseCode(), request.getCourseName(), request.getLtps(), request.getBranch());

        Optional<CompletedCourse> existing = completedCourseRepository
                .findFirstByUniversityIdAndCourseCodeAndSemesterAndAcademicYear(
                        student.getStudentId(), catalog.getCourseCode(), request.getSemester(), request.getAcademicYear()
                );
        if (!existing.isPresent()) {
            existing = completedCourseRepository.findFirstByUniversityIdAndCourseCode(student.getStudentId(), catalog.getCourseCode());
        }

        CompletedCourse completed = existing.orElseGet(CompletedCourse::new);
        completed.setStudent(student);
        completed.setUniversityId(student.getStudentId());
        completed.setStudentName(request.getStudentName() != null && !request.getStudentName().isEmpty() ? request.getStudentName() : (student.getFirstName() + " " + student.getLastName()).trim());
        completed.setCourseCode(catalog.getCourseCode());
        completed.setCourseName(request.getCourseName() != null && !request.getCourseName().isEmpty() ? request.getCourseName() : catalog.getCourseName());
        completed.setCredits(catalog.getCredits());
        completed.setGrade(request.getGrade() != null ? request.getGrade().toUpperCase() : null);
        completed.setSemester(request.getSemester() != null ? request.getSemester() : "ODD");

        LocalDate registerDate = null;
        if (request.getRegisterDate() != null && !request.getRegisterDate().isEmpty()) {
            try {
                registerDate = parseDateSafely(null, request.getRegisterDate());
            } catch (Exception ignored) {}
        }
        completed.setRegisterDate(registerDate != null ? registerDate : LocalDate.now());

        completed.setLtps(request.getLtps());
        completed.setBucketGroup(request.getBucketGroup());
        completed.setCourseType(request.getCourseType());
        completed.setAcademicYear(request.getAcademicYear());

        if (request.getStudyYear() != null && !request.getStudyYear().isEmpty()) {
            try {
                completed.setStudyYear(Integer.parseInt(request.getStudyYear()));
            } catch (Exception ignored) {}
        }

        completed.setSectionNo(request.getSectionNo());
        completed.setCourseRef(request.getCourseRef());
        completed.setOfferTo(request.getOfferTo());
        completed.setOfferBy(request.getOfferBy());
        completed.setBranch(request.getBranch());
        completed.setVerifiedBy(verifiedById);
        completed.setStatus("Completed");

        CompletedCourse saved = completedCourseRepository.save(completed);

        // Dual-write into normalized student_courses and student_course_attempts table
        syncStudentCourse(student, catalog, saved.getCourseName(), saved.getCredits() != null ? saved.getCredits().doubleValue() : 0.0,
                saved.getGrade(), saved.getSemester(), saved.getRegisterDate(), saved.getAcademicYear());

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
            } catch (Exception ignored) {}
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("course", saved);
        result.put("mappedBucketCode", bucketCode);
        result.put("mappedBucketName", bucketName);
        return result;
    }

    private static class ParsedCourseRow {
        String universityId;
        String studentName;
        String courseCode;
        String ltps;
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
     * Maps university_id to student/user table, auto-creates missing entities,
     * updates existing or inserts new records, handling max length rows reliably.
     */
    public Map<String, Object> bulkUploadCourses(MultipartFile file, Long verifiedById) throws Exception {
        int added = 0;
        int updated = 0;
        int skipped = 0;
        int failed = 0;
        List<String> errors = new ArrayList<>();
        Set<Long> affectedStudentIds = new HashSet<>();


        List<ParsedCourseRow> rowList = new ArrayList<>();

        try (InputStream is = file.getInputStream(); Workbook workbook = WorkbookFactory.create(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rowIterator = sheet.iterator();

            // Skip header row
            if (rowIterator.hasNext()) {
                rowIterator.next();
            }

            int rowIdx = 1;
            while (rowIterator.hasNext()) {
                rowIdx++;
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

                    if ((universityId == null || universityId.isEmpty()) && (courseCode == null || courseCode.isEmpty())) {
                        continue; // skip empty line
                    }

                    if (universityId == null || universityId.isEmpty()) {
                        throw new RuntimeException("Missing University ID at row " + rowIdx);
                    }
                    if (courseCode == null || courseCode.isEmpty()) {
                        throw new RuntimeException("Missing Course Code for student " + universityId + " at row " + rowIdx);
                    }

                    ParsedCourseRow r = new ParsedCourseRow();
                    r.universityId = universityId.trim();
                    r.studentName = (studentName != null) ? studentName.trim() : "";
                    r.courseCode = courseCode.trim().toUpperCase();
                    r.ltps = (ltps != null) ? ltps.trim() : "";
                    r.courseName = (courseName != null) ? courseName.trim() : "";
                    r.bucketGroup = (bucketGroup != null) ? bucketGroup.trim() : "";
                    r.courseType = (courseType != null) ? courseType.trim() : "";
                    r.academicYear = (academicYear != null) ? academicYear.trim() : "";
                    r.semester = (semester != null) ? semester.trim() : "ODD";
                    if (studyYearStr != null && !studyYearStr.trim().isEmpty()) {
                        try {
                            r.studyYear = Integer.parseInt(studyYearStr.trim());
                        } catch (Exception ignored) {}
                    }
                    r.sectionNo = (sectionNo != null) ? sectionNo.trim() : "";
                    r.registerDate = parseDateSafely(row.getCell(11), dateStr);
                    r.courseRef = (courseRef != null) ? courseRef.trim() : "";
                    r.offerTo = (offerTo != null) ? offerTo.trim() : "";
                    r.offerBy = (offerBy != null) ? offerBy.trim() : "";
                    r.branch = (branch != null) ? branch.trim() : "";

                    rowList.add(r);

                } catch (Exception e) {
                    failed++;
                    if (errors.size() < 100) {
                        errors.add("Row " + rowIdx + ": " + e.getMessage());
                    }
                }
            }
        }

        // Process all extracted course rows
        for (ParsedCourseRow r : rowList) {
            try {
                Student student = resolveOrCreateStudent(r.universityId, r.studentName, r.branch, r.academicYear);
                CourseCatalog catalog = resolveOrCreateCourseCatalog(r.courseCode, r.courseName, r.ltps, r.branch);

                String finalCourseName = (catalog.getCourseName() != null && !catalog.getCourseName().isEmpty())
                        ? catalog.getCourseName()
                        : ((r.courseName != null && !r.courseName.isEmpty()) ? r.courseName : r.courseCode);
                Integer finalCredits = (catalog.getCredits() != null) ? catalog.getCredits() : parseCreditsFromLtps(r.ltps);

                Optional<CompletedCourse> existingOpt = completedCourseRepository
                        .findFirstByUniversityIdAndCourseCodeAndSemesterAndAcademicYear(
                                student.getStudentId(), r.courseCode, r.semester, r.academicYear
                        );
                if (!existingOpt.isPresent()) {
                    existingOpt = completedCourseRepository.findFirstByUniversityIdAndCourseCode(student.getStudentId(), r.courseCode);
                }

                CompletedCourse target;
                boolean isNew = !existingOpt.isPresent();
                if (isNew) {
                    target = new CompletedCourse();
                    target.setStudent(student);
                    target.setUniversityId(student.getStudentId());
                    target.setStudentName(r.studentName);
                    target.setCourseCode(r.courseCode);
                    target.setStatus("Completed");
                } else {
                    target = existingOpt.get();
                    target.setStudent(student);
                    target.setUniversityId(student.getStudentId());
                    if (r.studentName != null && !r.studentName.isEmpty()) {
                        target.setStudentName(r.studentName);
                    }
                }

                target.setCourseName(finalCourseName);
                target.setCredits(finalCredits);
                target.setLtps(mergeLtps(target.getLtps(), r.ltps));
                if (r.bucketGroup != null && !r.bucketGroup.isEmpty()) target.setBucketGroup(r.bucketGroup);
                if (r.courseType != null && !r.courseType.isEmpty()) target.setCourseType(r.courseType);
                if (r.academicYear != null && !r.academicYear.isEmpty()) target.setAcademicYear(r.academicYear);
                if (r.semester != null && !r.semester.isEmpty()) target.setSemester(r.semester);
                if (r.studyYear != null) target.setStudyYear(r.studyYear);
                if (r.sectionNo != null && !r.sectionNo.isEmpty()) target.setSectionNo(r.sectionNo);
                if (r.registerDate != null) target.setRegisterDate(r.registerDate);
                if (r.courseRef != null && !r.courseRef.isEmpty()) target.setCourseRef(r.courseRef);
                if (r.offerTo != null && !r.offerTo.isEmpty()) target.setOfferTo(r.offerTo);
                if (r.offerBy != null && !r.offerBy.isEmpty()) target.setOfferBy(r.offerBy);
                if (r.branch != null && !r.branch.isEmpty()) target.setBranch(r.branch);
                target.setVerifiedBy(verifiedById);

                CompletedCourse saved = completedCourseRepository.save(target);

                // Dual-write into normalized student_courses and student_course_attempts table
                syncStudentCourse(student, catalog, finalCourseName, finalCredits.doubleValue(),
                        saved.getGrade(), saved.getSemester(), saved.getRegisterDate(), saved.getAcademicYear());

                affectedStudentIds.add(student.getId());

                if (isNew) {
                    added++;
                } else {
                    updated++;
                }

            } catch (Exception e) {
                failed++;
                if (errors.size() < 100) {
                    errors.add("Course " + r.courseCode + " for student " + r.universityId + ": " + e.getMessage());
                }
            }
        }

        // Re-evaluate affected students: sync for small sets, background async for large sets
        if (affectedStudentIds.size() <= 20) {
            for (Long studentId : affectedStudentIds) {
                try {
                    degreeEligibilityEngine.evaluateEligibility(studentId);
                } catch (Exception ignored) {}
            }
        } else {
            Set<Long> idsToEval = new HashSet<>(affectedStudentIds);
            CompletableFuture.runAsync(() -> {
                for (Long studentId : idsToEval) {
                    try {
                        degreeEligibilityEngine.evaluateEligibility(studentId);
                    } catch (Exception ignored) {}
                }
            });
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("total", rowList.size());
        result.put("added", added);
        result.put("updated", updated);
        result.put("skipped", skipped);
        result.put("failed", failed);
        result.put("errors", errors);
        result.put("message", "Processed " + (added + updated) + " records (" + added + " added, " + updated + " updated).");
        return result;
    }

    private String mergeLtps(String oldLtps, String newLtps) {
        if (oldLtps == null || oldLtps.trim().isEmpty()) return newLtps;
        if (newLtps == null || newLtps.trim().isEmpty()) return oldLtps;
        if (oldLtps.equalsIgnoreCase(newLtps)) return oldLtps;
        return oldLtps + ", " + newLtps;
    }

    /**
     * Delete a completed course entry.
     */
    public void deleteCourse(Long courseId) {
        CompletedCourse completed = completedCourseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Completed course entry not found"));
        Long studentId = (completed.getStudent() != null) ? completed.getStudent().getId() : null;
        String courseCode = completed.getCourseCode();

        completedCourseRepository.delete(completed);

        if (studentId != null && courseCode != null) {
            List<StudentCourse> scList = studentCourseRepository.findByStudentId(studentId);
            for (StudentCourse sc : scList) {
                if (courseCode.equalsIgnoreCase(sc.getCourseCode())) {
                    studentCourseRepository.delete(sc);
                }
            }
            List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(studentId, courseCode);
            if (attempts != null && !attempts.isEmpty()) {
                studentCourseAttemptRepository.deleteAll(attempts);
            }

            if (studentDegreePathRepository.findByStudentId(studentId).isPresent()) {
                try {
                    degreeEligibilityEngine.evaluateEligibility(studentId);
                } catch (Exception ignored) {}
            }
        }
    }

    /**
     * Update an existing completed course record by Admin/Faculty.
     * Prevents changes to protected fields (id, student ownership).
     * Enforces duplicate validation.
     * Synchronizes normalized student_courses and student_course_attempts.
     * Recalculates student degree eligibility and bucket progress.
     */
    public Map<String, Object> updateCourse(Long courseId, UpdateCourseRequest request, Long verifierId) {
        if (courseId == null) {
            throw new IllegalArgumentException("Course ID must not be null.");
        }
        if (request == null) {
            throw new IllegalArgumentException("Update request body cannot be null.");
        }

        CompletedCourse completed = completedCourseRepository.findById(courseId)
                .orElseThrow(() -> new NoSuchElementException("Completed course record with ID " + courseId + " not found."));

        Student student = completed.getStudent();
        if (student == null && completed.getUniversityId() != null) {
            student = studentRepository.findByStudentId(completed.getUniversityId()).orElse(null);
        }
        if (student == null) {
            throw new IllegalStateException("Associated student record not found for course " + courseId);
        }

        // Prevent changing student ownership (protected field)
        if (request.getStudentId() != null && !request.getStudentId().equals(student.getId())) {
            throw new IllegalArgumentException("Changing student ownership of a course record is not permitted.");
        }
        if (request.getUniversityId() != null && !request.getUniversityId().trim().equalsIgnoreCase(completed.getUniversityId())) {
            throw new IllegalArgumentException("Changing student ownership of a course record is not permitted.");
        }

        if (request.getCourseCode() != null && request.getCourseCode().trim().isEmpty()) {
            throw new IllegalArgumentException("Course code cannot be empty.");
        }

        String oldCourseCode = completed.getCourseCode();
        String newCourseCode = (request.getCourseCode() != null && !request.getCourseCode().trim().isEmpty())
                ? request.getCourseCode().trim().toUpperCase()
                : (oldCourseCode != null ? oldCourseCode.trim().toUpperCase() : "");

        if (newCourseCode.trim().isEmpty()) {
            throw new IllegalArgumentException("Course code cannot be empty.");
        }

        String targetSemester = (request.getSemester() != null && !request.getSemester().trim().isEmpty())
                ? request.getSemester().trim()
                : completed.getSemester();
        String targetAcademicYear = (request.getAcademicYear() != null && !request.getAcademicYear().trim().isEmpty())
                ? request.getAcademicYear().trim()
                : completed.getAcademicYear();

        // Duplicate validation: check if another record for this student already has this courseCode
        List<CompletedCourse> existingStudentCourses = completedCourseRepository.findByStudentId(student.getId());
        for (CompletedCourse other : existingStudentCourses) {
            if (!other.getId().equals(courseId)) {
                if (other.getCourseCode() != null && other.getCourseCode().trim().equalsIgnoreCase(newCourseCode)) {
                    if (targetSemester != null && targetAcademicYear != null
                            && other.getSemester() != null && other.getAcademicYear() != null) {
                        if (other.getSemester().equalsIgnoreCase(targetSemester) && other.getAcademicYear().equalsIgnoreCase(targetAcademicYear)) {
                            throw new IllegalArgumentException("Another course record with code " + newCourseCode + " already exists for semester " + targetSemester + " (" + targetAcademicYear + ").");
                        }
                    } else {
                        throw new IllegalArgumentException("Another course record with code " + newCourseCode + " already exists for this student.");
                    }
                }
            }
        }

        // Validate credits if specified
        if (request.getCredits() != null) {
            if (request.getCredits() < 0 || request.getCredits() > 30) {
                throw new IllegalArgumentException("Credits must be a non-negative integer between 0 and 30.");
            }
            completed.setCredits(request.getCredits());
        }

        completed.setCourseCode(newCourseCode);

        if (request.getCourseName() != null && !request.getCourseName().trim().isEmpty()) {
            completed.setCourseName(request.getCourseName().trim());
        } else if (!newCourseCode.equalsIgnoreCase(oldCourseCode)) {
            // If course code changed and no name given, fetch name from catalog
            Optional<CourseCatalog> catOpt = courseCatalogRepository.findByCourseCode(newCourseCode);
            catOpt.ifPresent(cat -> completed.setCourseName(cat.getCourseName()));
        }

        if (request.getGrade() != null) {
            completed.setGrade(request.getGrade().trim().toUpperCase());
        }

        if (request.getSemester() != null) {
            completed.setSemester(request.getSemester().trim());
        }

        if (request.getAcademicYear() != null) {
            completed.setAcademicYear(request.getAcademicYear().trim());
        }

        if (request.getLtps() != null) {
            completed.setLtps(request.getLtps().trim());
        }

        if (request.getSectionNo() != null) {
            completed.setSectionNo(request.getSectionNo().trim());
        }

        if (request.getStatus() != null) {
            completed.setStatus(request.getStatus().trim());
        }

        if (request.getCategory() != null) {
            completed.setCategory(request.getCategory().trim());
        }

        if (request.getCourseType() != null) {
            completed.setCourseType(request.getCourseType().trim());
        }

        if (request.getBucketGroup() != null) {
            completed.setBucketGroup(request.getBucketGroup().trim());
        }

        if (request.getRegisterDate() != null && !request.getRegisterDate().trim().isEmpty()) {
            try {
                completed.setRegisterDate(parseDateSafely(null, request.getRegisterDate()));
            } catch (Exception ignored) {}
        }

        if (request.getCompletedDate() != null && !request.getCompletedDate().trim().isEmpty()) {
            try {
                completed.setCompletedDate(parseDateSafely(null, request.getCompletedDate()));
            } catch (Exception ignored) {}
        }

        if (verifierId != null) {
            completed.setVerifiedBy(verifierId);
        }

        CompletedCourse saved = completedCourseRepository.save(completed);

        // Clean up old normalized records if course code changed and no other record uses it
        if (oldCourseCode != null && !newCourseCode.equalsIgnoreCase(oldCourseCode)) {
            List<CompletedCourse> remainingOld = completedCourseRepository.findByStudentId(student.getId()).stream()
                    .filter(c -> !c.getId().equals(saved.getId()) && c.getCourseCode() != null && c.getCourseCode().equalsIgnoreCase(oldCourseCode))
                    .toList();
            if (remainingOld.isEmpty()) {
                List<StudentCourse> scList = studentCourseRepository.findByStudentId(student.getId());
                for (StudentCourse sc : scList) {
                    if (sc.getCourseCode() != null && sc.getCourseCode().equalsIgnoreCase(oldCourseCode)) {
                        studentCourseRepository.delete(sc);
                    }
                }
                List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(student.getId(), oldCourseCode);
                if (attempts != null && !attempts.isEmpty()) {
                    studentCourseAttemptRepository.deleteAll(attempts);
                }
            }
        }

        // Dual-write into normalized student_courses and student_course_attempts
        CourseCatalog catalog = resolveOrCreateCourseCatalog(
                newCourseCode,
                saved.getCourseName(),
                saved.getLtps(),
                saved.getBranch() != null ? saved.getBranch() : saved.getCategory()
        );

        syncStudentCourse(
                student,
                catalog,
                saved.getCourseName(),
                saved.getCredits() != null ? saved.getCredits().doubleValue() : 0.0,
                saved.getGrade(),
                saved.getSemester(),
                saved.getCompletedDate() != null ? saved.getCompletedDate() : saved.getRegisterDate(),
                saved.getAcademicYear()
        );

        // Recalculate degree eligibility and bucket progress
        String bucketCode = "N/A";
        String bucketName = "N/A";
        Optional<StudentDegreePath> sdpOpt = studentDegreePathRepository.findByStudentId(student.getId());
        if (sdpOpt.isPresent()) {
            try {
                degreeEligibilityEngine.evaluateEligibility(student.getId());
                Optional<BucketMaster> bucketOpt = bucketMappingEngine.resolveBucket(newCourseCode, sdpOpt.get().getDegreePath().getId());
                if (bucketOpt.isPresent()) {
                    bucketCode = bucketOpt.get().getBucketCode();
                    bucketName = bucketOpt.get().getBucketName();
                }
            } catch (Exception ignored) {}
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("message", "Course record updated successfully.");
        response.put("course", saved);
        response.put("mappedBucketCode", bucketCode);
        response.put("mappedBucketName", bucketName);
        return response;
    }

    /**
     * Add student self-reported custom course.
     * Enforces duplicate validation across completed_courses and student_courses.
     * Dual-writes into normalized student_courses and student_course_attempts marked UNVERIFIED (isQualifying = false).
     * Distinguishes student self-reported courses from officially verified courses (verifiedBy remains null).
     * Triggers degree progress recalculation.
     */
    public CompletedCourse addStudentCustomCourse(Student student, String courseName, String courseCode,
                                                 String category, Integer credits, String status,
                                                 String semester, String academicYear) {
        if (student == null) {
            throw new IllegalArgumentException("Student is required.");
        }
        if (courseName == null || courseName.trim().isEmpty() ||
            courseCode == null || courseCode.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            credits == null || status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("All fields (courseName, courseCode, category, credits, status) are required.");
        }

        String cleanCode = courseCode.trim().toUpperCase();
        String sem = (semester != null && !semester.trim().isEmpty()) ? semester.trim() : "ODD";
        String acadYr = (academicYear != null && !academicYear.trim().isEmpty()) ? academicYear.trim() : student.getAcademicYear();

        // 1. Duplicate check across completed courses
        List<CompletedCourse> studentCompleted = completedCourseRepository.findByStudentId(student.getId());
        if (studentCompleted.isEmpty()) {
            studentCompleted = completedCourseRepository.findByUniversityId(student.getStudentId());
        }
        for (CompletedCourse cc : studentCompleted) {
            if (cc.getCourseCode() != null && cc.getCourseCode().trim().equalsIgnoreCase(cleanCode)) {
                if (semester != null && academicYear != null && cc.getSemester() != null && cc.getAcademicYear() != null) {
                    if (cc.getSemester().equalsIgnoreCase(sem) && cc.getAcademicYear().equalsIgnoreCase(acadYr)) {
                        throw new IllegalArgumentException("Course " + cleanCode + " already exists for semester " + sem + " (" + acadYr + ").");
                    }
                } else {
                    throw new IllegalArgumentException("Course " + cleanCode + " already exists in your academic records.");
                }
            }
        }

        // Also check student_courses
        List<StudentCourse> scList = studentCourseRepository.findByStudentId(student.getId());
        for (StudentCourse sc : scList) {
            if (sc.getCourseCode() != null && sc.getCourseCode().trim().equalsIgnoreCase(cleanCode)) {
                if (semester != null && academicYear != null && sc.getSemester() != null && sc.getAcademicYear() != null) {
                    if (sc.getSemester().equalsIgnoreCase(sem) && sc.getAcademicYear().equalsIgnoreCase(acadYr)) {
                        throw new IllegalArgumentException("Course " + cleanCode + " already exists for semester " + sem + " (" + acadYr + ").");
                    }
                } else {
                    throw new IllegalArgumentException("Course " + cleanCode + " already exists in your academic records.");
                }
            }
        }

        // 2. Save self-reported completed course
        CompletedCourse course = new CompletedCourse();
        course.setStudent(student);
        course.setUniversityId(student.getStudentId());
        course.setStudentName(student.getFirstName() + (student.getLastName() != null ? " " + student.getLastName() : ""));
        course.setCourseName(courseName.trim());
        course.setCourseCode(cleanCode);
        course.setCategory(category.trim());
        course.setCredits(credits);
        course.setStatus(status);
        if ("Completed".equalsIgnoreCase(status)) {
            course.setGrade("Pass");
        } else {
            course.setGrade("IP");
        }
        course.setSemester(sem);
        course.setAcademicYear(acadYr);
        course.setRegisterDate(LocalDate.now());
        course.setVerifiedBy(null); // Explicitly unverified

        CompletedCourse saved = completedCourseRepository.save(course);

        // 3. Dual-write into normalized student_courses and student_course_attempts
        CourseCatalog catalog = resolveOrCreateCourseCatalog(cleanCode, courseName.trim(), String.valueOf(credits), category);

        String normStatus = "Completed".equalsIgnoreCase(status) ? "UNVERIFIED" : "IN_PROGRESS";
        StudentCourse sc = new StudentCourse();
        sc.setStudent(student);
        sc.setUniversityId(student.getStudentId());
        sc.setCourse(catalog);
        sc.setCourseCode(cleanCode);
        sc.setCourseName(courseName.trim());
        sc.setCredits(credits.doubleValue());
        sc.setGrade(saved.getGrade());
        sc.setStatus(normStatus);
        sc.setSemester(sem);
        sc.setAcademicYear(acadYr);
        sc.setCompletedDate(LocalDate.now());
        studentCourseRepository.save(sc);

        StudentCourseAttempt sca = new StudentCourseAttempt();
        sca.setStudent(student);
        sca.setUniversityId(student.getStudentId());
        sca.setCourseCode(cleanCode);
        sca.setAttemptNumber(1);
        sca.setGrade(saved.getGrade());
        sca.setStatus(normStatus);
        sca.setSemester(sem);
        sca.setAcademicYear(acadYr);
        sca.setIsQualifying(false); // Unverified course is never qualifying
        studentCourseAttemptRepository.save(sca);

        // 4. Trigger progress recalculation
        if (studentDegreePathRepository.findByStudentId(student.getId()).isPresent()) {
            try {
                degreeEligibilityEngine.evaluateEligibility(student.getId());
            } catch (Exception ignored) {}
        }

        return saved;
    }

    /**
     * Delete student self-reported course.
     * Validates student ownership and prevents students from deleting officially verified academic records.
     * Cleans up corresponding normalized records and triggers progress recalculation.
     */
    public void deleteStudentCustomCourse(Student student, Long courseId) {
        if (student == null) {
            throw new IllegalArgumentException("Student is required.");
        }
        CompletedCourse course = completedCourseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));

        boolean authorized = false;
        if (course.getStudent() != null && course.getStudent().getId().equals(student.getId())) {
            authorized = true;
        } else if (course.getUniversityId() != null && course.getUniversityId().equalsIgnoreCase(student.getStudentId())) {
            authorized = true;
        }

        if (!authorized) {
            throw new SecurityException("You are not authorized to delete this course.");
        }

        // Students cannot delete officially verified course records
        if (course.getVerifiedBy() != null) {
            throw new IllegalStateException("Cannot delete an officially verified academic course record.");
        }

        String courseCode = course.getCourseCode();
        completedCourseRepository.delete(course);

        // Clean up normalized student_courses and attempts if no other record exists for this course
        if (courseCode != null) {
            List<CompletedCourse> remaining = completedCourseRepository.findByStudentId(student.getId());
            boolean hasRemaining = remaining.stream().anyMatch(c -> c.getCourseCode() != null && c.getCourseCode().trim().equalsIgnoreCase(courseCode.trim()));
            if (!hasRemaining) {
                List<StudentCourse> scList = studentCourseRepository.findByStudentId(student.getId());
                for (StudentCourse sc : scList) {
                    if (sc.getCourseCode() != null && sc.getCourseCode().trim().equalsIgnoreCase(courseCode.trim())) {
                        studentCourseRepository.delete(sc);
                    }
                }
                List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(student.getId(), courseCode.trim());
                if (attempts != null && !attempts.isEmpty()) {
                    studentCourseAttemptRepository.deleteAll(attempts);
                }
            }
        }

        // Recalculate progress
        if (studentDegreePathRepository.findByStudentId(student.getId()).isPresent()) {
            try {
                degreeEligibilityEngine.evaluateEligibility(student.getId());
            } catch (Exception ignored) {}
        }
    }

    private void syncStudentCourse(Student student, CourseCatalog catalog, String courseName, Double credits,
                                   String grade, String semester, LocalDate completedDate, String academicYear) {
        if (student == null || catalog == null) return;

        boolean isPassing = BucketMappingEngine.isPassingGrade(grade);
        String finalStatus = isPassing ? "COMPLETED" : "FAILED";
        boolean qualifying = isPassing;

        List<StudentCourse> existingList = studentCourseRepository.findByStudentId(student.getId());
        Optional<StudentCourse> scOpt = existingList.stream()
                .filter(sc -> sc.getCourseCode().equalsIgnoreCase(catalog.getCourseCode()))
                .findFirst();

        if (!scOpt.isPresent()) {
            StudentCourse sc = new StudentCourse();
            sc.setStudent(student);
            sc.setUniversityId(student.getStudentId());
            sc.setCourse(catalog);
            sc.setCourseCode(catalog.getCourseCode());
            sc.setCourseName(courseName != null ? courseName : catalog.getCourseName());
            sc.setCredits(credits != null ? credits : (catalog.getCredits() != null ? catalog.getCredits().doubleValue() : 0.0));
            sc.setGrade(grade);
            sc.setStatus(finalStatus);
            sc.setSemester(semester != null ? semester : "ODD");
            sc.setAcademicYear(academicYear);
            sc.setCompletedDate(completedDate != null ? completedDate : LocalDate.now());
            studentCourseRepository.save(sc);

            StudentCourseAttempt sca = new StudentCourseAttempt();
            sca.setStudent(student);
            sca.setUniversityId(student.getStudentId());
            sca.setCourseCode(catalog.getCourseCode());
            sca.setAttemptNumber(1);
            sca.setGrade(grade);
            sca.setStatus(finalStatus);
            sca.setSemester(semester != null ? semester : "ODD");
            sca.setAcademicYear(academicYear);
            sca.setIsQualifying(qualifying);
            studentCourseAttemptRepository.save(sca);
        } else {
            StudentCourse sc = scOpt.get();
            if (credits != null) {
                sc.setCredits(credits);
            }
            if (courseName != null && !courseName.trim().isEmpty()) {
                sc.setCourseName(courseName.trim());
            }
            if (grade != null) {
                sc.setGrade(grade);
                sc.setStatus(finalStatus);
            }
            if (semester != null) sc.setSemester(semester);
            if (academicYear != null) sc.setAcademicYear(academicYear);
            if (completedDate != null) sc.setCompletedDate(completedDate);
            studentCourseRepository.save(sc);

            List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByStudentIdAndCourseCode(student.getId(), catalog.getCourseCode());
            if (attempts != null && !attempts.isEmpty()) {
                StudentCourseAttempt sca = attempts.get(attempts.size() - 1);
                sca.setGrade(grade);
                sca.setStatus(finalStatus);
                sca.setIsQualifying(qualifying);
                if (semester != null) sca.setSemester(semester);
                if (academicYear != null) sca.setAcademicYear(academicYear);
                studentCourseAttemptRepository.save(sca);
            }
        }
    }

    /**
     * Get completed courses for a student by ID or university ID.
     */
    public List<CompletedCourse> getStudentCourses(Long studentId) {
        List<CompletedCourse> list = completedCourseRepository.findByStudentIdOrderByRegisterDateDesc(studentId);
        if (list.isEmpty()) {
            Optional<Student> sOpt = studentRepository.findById(studentId);
            if (sOpt.isPresent()) {
                return completedCourseRepository.findByUniversityIdOrderByRegisterDateDesc(sOpt.get().getStudentId());
            }
        }
        return list;
    }

    public List<CompletedCourse> getStudentCoursesByUniversityId(String universityId) {
        return completedCourseRepository.findByUniversityIdOrderByRegisterDateDesc(universityId);
    }

    /**
     * Generate Excel template for bulk completed course uploads (16 columns).
     */
    public byte[] generateTemplate() throws Exception {
        try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = workbook.createSheet("Template");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("UNIVERSITY ID");
            header.createCell(1).setCellValue("STUDENT NAME");
            header.createCell(2).setCellValue("COURSE CODE");
            header.createCell(3).setCellValue("LTPS");
            header.createCell(4).setCellValue("COURSE NAME");
            header.createCell(5).setCellValue("BUCKET GROUP");
            header.createCell(6).setCellValue("COURSE TYPE");
            header.createCell(7).setCellValue("ACADEMIC YEAR");
            header.createCell(8).setCellValue("SEMESTER");
            header.createCell(9).setCellValue("STUDY YEAR");
            header.createCell(10).setCellValue("SECTION");
            header.createCell(11).setCellValue("REGISTER DATE");
            header.createCell(12).setCellValue("COURSE REF");
            header.createCell(13).setCellValue("OFFERED TO");
            header.createCell(14).setCellValue("OFFERED BY");
            header.createCell(15).setCellValue("BRANCH");

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
            case FORMULA -> {
                try {
                    yield cell.getStringCellValue().trim();
                } catch (Exception e) {
                    yield String.valueOf((long) cell.getNumericCellValue());
                }
            }
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
        List<String> formats = Arrays.asList("yyyy-MM-dd", "dd-MM-yyyy", "MM/dd/yyyy", "dd/MM/yyyy", "yyyy/MM/dd", "dd-MM-yy", "d-MMM-yyyy", "dd-MMM-yyyy");
        for (String format : formats) {
            try {
                return LocalDate.parse(val.trim(), DateTimeFormatter.ofPattern(format, Locale.ENGLISH));
            } catch (Exception ignored) {}
        }
        return LocalDate.now();
    }
}
