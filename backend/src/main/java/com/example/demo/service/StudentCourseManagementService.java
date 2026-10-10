package com.example.demo.service;

import com.example.demo.dto.StudentCourseDTO;
import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
@Slf4j
public class StudentCourseManagementService {

    @Autowired private StudentRepository studentRepository;
    @Autowired private StudentCourseRepository studentCourseRepository;
    @Autowired private StudentCourseAttemptRepository studentCourseAttemptRepository;
    @Autowired private CompletedCourseRepository completedCourseRepository;
    @Autowired private CourseCatalogRepository courseCatalogRepository;
    @Autowired private CurriculumCourseRepository curriculumCourseRepository;
    @Autowired private AuditHistoryRepository auditHistoryRepository;
    @Autowired private DegreeEligibilityEngine degreeEligibilityEngine;
    @Autowired private FacultyRepository facultyRepository;
    @Autowired private AdminRepository adminRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    private static final Set<String> VALID_CATEGORIES = Set.of(
            "HAS", "BSC", "ESC", "FCC", "PCC", "PEC", "SDC", "PRI", "OEC", "SIL"
    );

    public Student resolveStudent(String identifier) {
        if (identifier == null || identifier.isBlank()) {
            throw new IllegalArgumentException("Student identifier cannot be blank");
        }
        String clean = identifier.trim();
        Optional<Student> studentOpt = studentRepository.findByStudentId(clean);
        if (studentOpt.isPresent()) {
            return studentOpt.get();
        }
        try {
            Long id = Long.parseLong(clean);
            studentOpt = studentRepository.findById(id);
            if (studentOpt.isPresent()) {
                return studentOpt.get();
            }
        } catch (NumberFormatException ignored) {}
        throw new NoSuchElementException("Student not found for identifier: " + clean);
    }

    private Long getUserIdForAudit(String username) {
        if (username == null || username.isBlank()) return 1L;
        Optional<Admin> admin = adminRepository.findByUsername(username);
        if (admin.isPresent()) return admin.get().getId();
        Optional<Faculty> faculty = facultyRepository.findByUsername(username);
        if (faculty.isPresent()) return faculty.get().getId();
        return 1L;
    }

    private void recordAudit(Student student, String actionType, String username, Object payload, Object result) {
        try {
            AuditHistory audit = new AuditHistory();
            audit.setStudent(student);
            audit.setActionType(actionType);
            audit.setPerformedBy(getUserIdForAudit(username));
            audit.setPayload(objectMapper.writeValueAsString(payload));
            audit.setResult(objectMapper.writeValueAsString(result));
            audit.setCreatedAt(LocalDateTime.now());
            auditHistoryRepository.save(audit);
        } catch (Exception e) {
            log.warn("Failed recording audit log for {}: {}", actionType, e.getMessage());
        }
    }

    private String normalizeCategory(String code, String category) {
        if (category != null && !category.isBlank()) {
            String upper = category.trim().toUpperCase();
            if (VALID_CATEGORIES.contains(upper)) {
                return upper;
            }
        }
        // Fallback guess from course code
        if (code == null) return "OEC";
        String c = code.toUpperCase();
        if (c.startsWith("23UC") || c.startsWith("23HS") || c.startsWith("23EN")) return "HAS";
        if (c.startsWith("23SC") || c.startsWith("23MA") || c.startsWith("23PH") || c.startsWith("23CH")) return "BSC";
        if (c.startsWith("23EC") || c.startsWith("23EE") || c.startsWith("23ME")) return "ESC";
        if (c.startsWith("23CS") || c.startsWith("23AD")) return "PCC";
        if (c.startsWith("23SD")) return "SDC";
        if (c.startsWith("23PR") || c.startsWith("23IN") || c.startsWith("23CP")) return "PRI";
        if (c.startsWith("OE")) return "OEC";
        return "PEC";
    }

    /**
     * Read all courses for a student.
     */
    public List<StudentCourseDTO> getStudentCourses(String identifier) {
        Student student = resolveStudent(identifier);
        Long studentId = student.getId();
        String rollNumber = student.getStudentId();

        List<StudentCourse> studentCourses = studentCourseRepository.findByStudentId(studentId);
        if (studentCourses.isEmpty()) {
            studentCourses = studentCourseRepository.findByUniversityId(rollNumber);
        }

        List<StudentCourseAttempt> attempts = studentCourseAttemptRepository.findByUniversityId(rollNumber);
        Map<String, List<StudentCourseAttempt>> attemptMap = attempts.stream()
                .filter(a -> a.getCourseCode() != null)
                .collect(Collectors.groupingBy(a -> a.getCourseCode().trim().toUpperCase()));

        List<CompletedCourse> compCourses = completedCourseRepository.findByStudentId(studentId);
        if (compCourses.isEmpty()) {
            compCourses = completedCourseRepository.findByUniversityId(rollNumber);
        }
        Map<String, CompletedCourse> compMap = compCourses.stream()
                .filter(c -> c.getCourseCode() != null)
                .collect(Collectors.toMap(c -> c.getCourseCode().trim().toUpperCase(), c -> c, (a, b) -> a));

        List<StudentCourseDTO> dtoList = new ArrayList<>();
        Set<String> processedCodes = new HashSet<>();

        for (StudentCourse sc : studentCourses) {
            String code = sc.getCourseCode();
            if (code == null || code.isBlank()) continue;
            String upperCode = code.trim().toUpperCase();
            processedCodes.add(upperCode);

            CompletedCourse comp = compMap.get(upperCode);
            List<StudentCourseAttempt> courseAttempts = attemptMap.getOrDefault(upperCode, Collections.emptyList());

            String attempt1 = "-";
            String attempt2 = "-";
            String attempt3 = "-";

            if (!courseAttempts.isEmpty()) {
                attempt1 = courseAttempts.size() >= 1 && courseAttempts.get(0).getGrade() != null ? courseAttempts.get(0).getGrade() : "-";
                attempt2 = courseAttempts.size() >= 2 && courseAttempts.get(1).getGrade() != null ? courseAttempts.get(1).getGrade() : "-";
                attempt3 = courseAttempts.size() >= 3 && courseAttempts.get(2).getGrade() != null ? courseAttempts.get(2).getGrade() : "-";
            } else if (sc.getGrade() != null && !sc.getGrade().isBlank()) {
                attempt1 = sc.getGrade();
            }

            Double credits = sc.getCredits() != null ? sc.getCredits() : 0.0;
            String grade = sc.getGrade() != null ? sc.getGrade() : (comp != null ? comp.getGrade() : "Pass");
            String status = sc.getStatus() != null ? sc.getStatus() : "COMPLETED";

            Double obtainedCredits = 0.0;
            if (!"FAILED".equalsIgnoreCase(status) && !"DROPPED".equalsIgnoreCase(status) && !"F".equalsIgnoreCase(grade)) {
                obtainedCredits = credits;
            }

            String category = (comp != null && comp.getCategory() != null) ? comp.getCategory() : normalizeCategory(upperCode, null);

            StudentCourseDTO dto = StudentCourseDTO.builder()
                    .id(sc.getId())
                    .studentId(studentId)
                    .rollNumber(rollNumber)
                    .courseCode(upperCode)
                    .courseName(sc.getCourseName() != null ? sc.getCourseName() : (comp != null ? comp.getCourseName() : upperCode))
                    .category(category)
                    .credits(credits)
                    .obtainedCredits(obtainedCredits)
                    .semester(sc.getSemester() != null ? sc.getSemester() : (comp != null ? comp.getSemester() : "Odd Sem"))
                    .academicYear(sc.getAcademicYear() != null ? sc.getAcademicYear() : (comp != null ? comp.getAcademicYear() : "2023-2024"))
                    .attempt1(attempt1)
                    .attempt2(attempt2)
                    .attempt3(attempt3)
                    .grade(grade)
                    .status(status)
                    .isQualifying(obtainedCredits > 0)
                    .completedDate(sc.getCompletedDate() != null ? sc.getCompletedDate().toString() : null)
                    .source("STUDENT_COURSE")
                    .build();

            dtoList.add(dto);
        }

        // Add any completed courses that were not in student_courses
        for (CompletedCourse cc : compCourses) {
            String upperCode = cc.getCourseCode() != null ? cc.getCourseCode().trim().toUpperCase() : "";
            if (upperCode.isBlank() || processedCodes.contains(upperCode)) continue;
            processedCodes.add(upperCode);

            Double credits = cc.getCredits() != null ? cc.getCredits().doubleValue() : 0.0;
            String grade = cc.getGrade() != null ? cc.getGrade() : "Pass";
            String status = cc.getStatus() != null ? cc.getStatus() : "COMPLETED";
            Double obtainedCredits = (!"FAILED".equalsIgnoreCase(status) && !"DROPPED".equalsIgnoreCase(status) && !"F".equalsIgnoreCase(grade)) ? credits : 0.0;

            StudentCourseDTO dto = StudentCourseDTO.builder()
                    .id(cc.getId())
                    .studentId(studentId)
                    .rollNumber(rollNumber)
                    .courseCode(upperCode)
                    .courseName(cc.getCourseName())
                    .category(normalizeCategory(upperCode, cc.getCategory()))
                    .credits(credits)
                    .obtainedCredits(obtainedCredits)
                    .semester(cc.getSemester() != null ? cc.getSemester() : "Odd Sem")
                    .academicYear(cc.getAcademicYear() != null ? cc.getAcademicYear() : "2023-2024")
                    .attempt1(grade)
                    .attempt2("-")
                    .attempt3("-")
                    .grade(grade)
                    .status(status)
                    .isQualifying(obtainedCredits > 0)
                    .completedDate(cc.getCompletedDate() != null ? cc.getCompletedDate().toString() : null)
                    .source("COMPLETED_COURSE")
                    .build();

            dtoList.add(dto);
        }

        // Sort by course code ascending
        dtoList.sort(Comparator.comparing(StudentCourseDTO::getCourseCode));
        return dtoList;
    }

    /**
     * Add course for student.
     */
    public StudentCourseDTO addCourse(String identifier, StudentCourseDTO request, String username) {
        Student student = resolveStudent(identifier);
        if (request.getCourseCode() == null || request.getCourseCode().isBlank()) {
            throw new IllegalArgumentException("Course code is required.");
        }
        String cleanCode = request.getCourseCode().trim().toUpperCase();

        // 1. Authoritative check in course catalog
        Optional<CourseCatalog> catalogOpt = courseCatalogRepository.findByCourseCode(cleanCode);
        CourseCatalog catalog;
        if (catalogOpt.isPresent()) {
            catalog = catalogOpt.get();
        } else {
            List<CurriculumCourse> ccList = curriculumCourseRepository.findByCourse_CourseCode(cleanCode);
            if (!ccList.isEmpty() && ccList.get(0).getCourse() != null) {
                catalog = ccList.get(0).getCourse();
            } else {
                // If not in catalog, auto-create catalog master entry with provided details so registration succeeds
                catalog = new CourseCatalog();
                catalog.setCourseCode(cleanCode);
                catalog.setCourseName(request.getCourseName() != null && !request.getCourseName().isBlank() ? request.getCourseName().trim() : cleanCode);
                catalog.setCredits(request.getCredits() != null && request.getCredits() > 0 ? request.getCredits().intValue() : 3);
                catalog.setCategory(normalizeCategory(cleanCode, request.getCategory()));
                catalog = courseCatalogRepository.save(catalog);
            }
        }

        // Use authoritative catalog values to prevent tampering with course definition
        String officialName = catalog.getCourseName();
        Double officialCredits = catalog.getCredits() != null ? catalog.getCredits().doubleValue() : (request.getCredits() != null ? request.getCredits() : 3.0);
        String category = normalizeCategory(cleanCode, request.getCategory());

        // 2. Prevent duplicate active courses
        List<StudentCourse> existingList = studentCourseRepository.findByStudentId(student.getId());
        boolean hasActive = existingList.stream().anyMatch(sc ->
                cleanCode.equalsIgnoreCase(sc.getCourseCode()) && !"DROPPED".equalsIgnoreCase(sc.getStatus())
        );
        if (hasActive) {
            throw new IllegalStateException("Student " + student.getStudentId() + " already has an active record for course " + cleanCode);
        }

        // 3. Save StudentCourse
        StudentCourse sc = new StudentCourse();
        sc.setStudent(student);
        sc.setUniversityId(student.getStudentId());
        sc.setCourse(catalog);
        sc.setCourseCode(cleanCode);
        sc.setCourseName(officialName);
        sc.setCredits(officialCredits);
        sc.setGrade(request.getGrade() != null ? request.getGrade().trim() : "Pass");
        sc.setStatus(request.getStatus() != null && !request.getStatus().isBlank() ? request.getStatus().trim() : "COMPLETED");
        sc.setSemester(request.getSemester() != null && !request.getSemester().isBlank() ? request.getSemester().trim() : "Odd Sem");
        sc.setAcademicYear(request.getAcademicYear() != null && !request.getAcademicYear().isBlank() ? request.getAcademicYear().trim() : "2023-2024");
        sc.setCompletedDate(LocalDate.now());
        StudentCourse savedSc = studentCourseRepository.save(sc);

        // 4. Save CompletedCourse
        CompletedCourse comp = new CompletedCourse();
        comp.setStudent(student);
        comp.setUniversityId(student.getStudentId());
        comp.setStudentName(((student.getFirstName() != null ? student.getFirstName() : "") + " " + (student.getLastName() != null ? student.getLastName() : "")).trim());
        comp.setCourseCode(cleanCode);
        comp.setCourseName(officialName);
        comp.setCredits(officialCredits.intValue());
        comp.setGrade(sc.getGrade());
        comp.setStatus(sc.getStatus());
        comp.setSemester(sc.getSemester());
        comp.setAcademicYear(sc.getAcademicYear());
        comp.setCategory(category);
        comp.setRegisterDate(LocalDate.now());
        comp.setCompletedDate(LocalDate.now());
        completedCourseRepository.save(comp);

        // 5. Save Attempts
        syncAttempts(student, cleanCode, request.getAttempt1(), request.getAttempt2(), request.getAttempt3(), sc.getGrade(), sc.getSemester(), sc.getAcademicYear(), sc.getStatus());

        // 6. Record Audit
        recordAudit(student, "ADD_COURSE", username, request, savedSc);

        // 7. Recalculate degree eligibility immediately
        try {
            degreeEligibilityEngine.evaluateEligibility(student.getId());
        } catch (Exception e) {
            log.warn("Degree eligibility recalculation for {}: {}", student.getStudentId(), e.getMessage());
        }

        return StudentCourseDTO.builder()
                .id(savedSc.getId())
                .studentId(student.getId())
                .rollNumber(student.getStudentId())
                .courseCode(cleanCode)
                .courseName(officialName)
                .category(category)
                .credits(officialCredits)
                .obtainedCredits("COMPLETED".equalsIgnoreCase(sc.getStatus()) ? officialCredits : 0.0)
                .semester(sc.getSemester())
                .academicYear(sc.getAcademicYear())
                .attempt1(request.getAttempt1() != null ? request.getAttempt1() : sc.getGrade())
                .attempt2(request.getAttempt2() != null ? request.getAttempt2() : "-")
                .attempt3(request.getAttempt3() != null ? request.getAttempt3() : "-")
                .grade(sc.getGrade())
                .status(sc.getStatus())
                .isQualifying(true)
                .completedDate(sc.getCompletedDate().toString())
                .build();
    }

    /**
     * Update existing student course record without modifying course master definitions.
     */
    public StudentCourseDTO updateCourse(String identifier, String courseCode, StudentCourseDTO request, String username) {
        Student student = resolveStudent(identifier);
        String cleanCode = courseCode.trim().toUpperCase();

        // 1. Locate student course
        List<StudentCourse> scList = studentCourseRepository.findByStudentId(student.getId());
        StudentCourse sc = scList.stream()
                .filter(c -> cleanCode.equalsIgnoreCase(c.getCourseCode()))
                .findFirst()
                .orElse(null);

        Map<String, Object> beforeState = new HashMap<>();
        if (sc != null) {
            beforeState.put("grade", sc.getGrade());
            beforeState.put("status", sc.getStatus());
            beforeState.put("semester", sc.getSemester());
            beforeState.put("academicYear", sc.getAcademicYear());
        }

        String newGrade = request.getGrade() != null ? request.getGrade().trim() : (sc != null ? sc.getGrade() : "Pass");
        String newStatus = request.getStatus() != null ? request.getStatus().trim() : (sc != null ? sc.getStatus() : "COMPLETED");
        String newSemester = request.getSemester() != null ? request.getSemester().trim() : (sc != null ? sc.getSemester() : "Odd Sem");
        String newAcademicYear = request.getAcademicYear() != null ? request.getAcademicYear().trim() : (sc != null ? sc.getAcademicYear() : "2023-2024");
        String newCategory = normalizeCategory(cleanCode, request.getCategory());

        if (sc != null) {
            sc.setGrade(newGrade);
            sc.setStatus(newStatus);
            sc.setSemester(newSemester);
            sc.setAcademicYear(newAcademicYear);
            studentCourseRepository.save(sc);
        }

        // Update in CompletedCourse
        Optional<CompletedCourse> ccOpt = completedCourseRepository.findFirstByUniversityIdAndCourseCode(student.getStudentId(), cleanCode);
        if (ccOpt.isPresent()) {
            CompletedCourse cc = ccOpt.get();
            cc.setGrade(newGrade);
            cc.setStatus(newStatus);
            cc.setSemester(newSemester);
            cc.setAcademicYear(newAcademicYear);
            cc.setCategory(newCategory);
            completedCourseRepository.save(cc);
        }

        // Update Attempts
        syncAttempts(student, cleanCode, request.getAttempt1(), request.getAttempt2(), request.getAttempt3(), newGrade, newSemester, newAcademicYear, newStatus);

        // Record Audit
        Map<String, Object> afterState = Map.of(
                "courseCode", cleanCode,
                "grade", newGrade,
                "status", newStatus,
                "category", newCategory,
                "semester", newSemester,
                "academicYear", newAcademicYear
        );
        recordAudit(student, "UPDATE_COURSE", username, Map.of("before", beforeState, "requested", request), afterState);

        // Recalculate
        try {
            degreeEligibilityEngine.evaluateEligibility(student.getId());
        } catch (Exception e) {
            log.warn("Degree eligibility recalculation for {}: {}", student.getStudentId(), e.getMessage());
        }

        Double credits = sc != null && sc.getCredits() != null ? sc.getCredits() : 3.0;
        Double obtained = ("COMPLETED".equalsIgnoreCase(newStatus) && !"F".equalsIgnoreCase(newGrade)) ? credits : 0.0;

        return StudentCourseDTO.builder()
                .id(sc != null ? sc.getId() : 0L)
                .studentId(student.getId())
                .rollNumber(student.getStudentId())
                .courseCode(cleanCode)
                .courseName(sc != null ? sc.getCourseName() : cleanCode)
                .category(newCategory)
                .credits(credits)
                .obtainedCredits(obtained)
                .semester(newSemester)
                .academicYear(newAcademicYear)
                .attempt1(request.getAttempt1() != null ? request.getAttempt1() : newGrade)
                .attempt2(request.getAttempt2() != null ? request.getAttempt2() : "-")
                .attempt3(request.getAttempt3() != null ? request.getAttempt3() : "-")
                .grade(newGrade)
                .status(newStatus)
                .isQualifying(obtained > 0)
                .build();
    }

    /**
     * Delete or soft-delete student course record.
     */
    public void deleteCourse(String identifier, String courseCode, String username) {
        Student student = resolveStudent(identifier);
        String cleanCode = courseCode.trim().toUpperCase();

        List<StudentCourse> scList = studentCourseRepository.findByStudentId(student.getId());
        StudentCourse sc = scList.stream()
                .filter(c -> cleanCode.equalsIgnoreCase(c.getCourseCode()))
                .findFirst()
                .orElse(null);

        if (sc == null) {
            throw new NoSuchElementException("Course record not found for " + cleanCode);
        }

        // Soft deletion: mark status as DROPPED to preserve institutional audit trail
        sc.setStatus("DROPPED");
        studentCourseRepository.save(sc);

        // Also update completed_courses
        Optional<CompletedCourse> ccOpt = completedCourseRepository.findFirstByUniversityIdAndCourseCode(student.getStudentId(), cleanCode);
        if (ccOpt.isPresent()) {
            CompletedCourse cc = ccOpt.get();
            cc.setStatus("DROPPED");
            completedCourseRepository.save(cc);
        }

        // Record Audit
        recordAudit(student, "DELETE_COURSE", username, Map.of("courseCode", cleanCode, "previousStatus", sc.getStatus()), Map.of("status", "DROPPED"));

        // Recalculate degree eligibility
        try {
            degreeEligibilityEngine.evaluateEligibility(student.getId());
        } catch (Exception e) {
            log.warn("Degree eligibility recalculation for {}: {}", student.getStudentId(), e.getMessage());
        }
    }

    private void syncAttempts(Student student, String courseCode, String a1, String a2, String a3,
                              String currentGrade, String semester, String academicYear, String status) {
        List<StudentCourseAttempt> existingAttempts = studentCourseAttemptRepository.findByUniversityId(student.getStudentId())
                .stream()
                .filter(a -> courseCode.equalsIgnoreCase(a.getCourseCode()))
                .sorted(Comparator.comparing(StudentCourseAttempt::getAttemptNumber))
                .collect(Collectors.toList());

        String[] grades = new String[]{
                a1 != null && !a1.isBlank() && !"-".equals(a1) ? a1 : currentGrade,
                a2 != null && !a2.isBlank() && !"-".equals(a2) ? a2 : null,
                a3 != null && !a3.isBlank() && !"-".equals(a3) ? a3 : null
        };

        for (int i = 0; i < 3; i++) {
            int attemptNum = i + 1;
            String g = grades[i];
            if (g == null && attemptNum > 1 && attemptNum > existingAttempts.size()) {
                continue; // no 2nd or 3rd attempt
            }

            StudentCourseAttempt attempt = existingAttempts.stream()
                    .filter(a -> a.getAttemptNumber() != null && a.getAttemptNumber() == attemptNum)
                    .findFirst()
                    .orElseGet(() -> {
                        StudentCourseAttempt na = new StudentCourseAttempt();
                        na.setStudent(student);
                        na.setUniversityId(student.getStudentId());
                        na.setCourseCode(courseCode);
                        na.setAttemptNumber(attemptNum);
                        return na;
                    });

            if (g != null && !g.isBlank()) {
                attempt.setGrade(g);
            }
            attempt.setStatus(status != null ? status : "COMPLETED");
            attempt.setSemester(semester);
            attempt.setAcademicYear(academicYear);
            attempt.setIsQualifying(!"F".equalsIgnoreCase(attempt.getGrade()));
            studentCourseAttemptRepository.save(attempt);
        }
    }

    /**
     * Search authoritative course catalog.
     */
    public List<Map<String, Object>> searchCourseCatalog(String query, String category, int limit) {
        String q = (query != null ? query.trim().toUpperCase() : "");
        List<CourseCatalog> all = courseCatalogRepository.findAll();

        return all.stream()
                .filter(c -> {
                    boolean matchesQuery = q.isEmpty()
                            || (c.getCourseCode() != null && c.getCourseCode().toUpperCase().contains(q))
                            || (c.getCourseName() != null && c.getCourseName().toUpperCase().contains(q));
                    boolean matchesCategory = (category == null || category.isBlank() || "ALL".equalsIgnoreCase(category))
                            || (c.getCategory() != null && c.getCategory().equalsIgnoreCase(category));
                    return matchesQuery && matchesCategory;
                })
                .limit(limit > 0 ? limit : 50)
                .map(c -> {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("courseId", c.getId());
                    map.put("courseCode", c.getCourseCode());
                    map.put("courseName", c.getCourseName());
                    map.put("credits", c.getCredits());
                    map.put("category", normalizeCategory(c.getCourseCode(), c.getCategory()));
                    map.put("offeredSemester", c.getOfferedSemester());
                    return map;
                })
                .collect(Collectors.toList());
    }
}
