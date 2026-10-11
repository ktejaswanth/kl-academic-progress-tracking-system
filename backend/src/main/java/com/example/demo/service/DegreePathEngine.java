package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * Degree Path Engine
 * 
 * Resolves a student's degree path based on their department, degree type, and addon selection.
 * 
 * Algorithm:
 *   1. Read student's department, degree type (HTE/HTI/HTR/HONORS/REGULAR), addon type
 *   2. Find matching DegreePath record
 *   3. Assign to student_degree_path table
 */
@Service
@Transactional
public class DegreePathEngine {

    @Autowired
    private StudentRepository studentRepository;
    @Autowired
    private DegreePathRepository degreePathRepository;
    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;
    @Autowired
    private DepartmentMasterRepository departmentMasterRepository;
    @Autowired
    private DegreeTypeMasterRepository degreeTypeMasterRepository;
    @Autowired
    private AddonTypeMasterRepository addonTypeMasterRepository;
    @Autowired
    private UnmatchedStudentQueueRepository unmatchedStudentQueueRepository;
    @Autowired
    private MappingAuditLogRepository mappingAuditLogRepository;

    /**
     * Resolve and assign a degree path for a student based on their profile.
     * Uses the user's department, subDepartment (degree type), specializationType, and specializationName.
     */
    public DegreePath resolveAndAssignPath(Long studentId) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found: " + studentId));

        // Map user fields to DYOD codes
        String deptCode = mapDepartment(student.getDepartment());
        if (deptCode == null) {
            String rawDept = student.getDepartment() != null ? student.getDepartment() : "MISSING";
            enqueueUnmatchedStudent(student, "UNKNOWN_DEPARTMENT",
                    "Unrecognized or missing department code: '" + rawDept + "'. Cannot assign curriculum without verification.");
            throw new RuntimeException("Student " + student.getStudentId() 
                    + " has ambiguous department '" + rawDept + "'. Routed to administrative review queue.");
        }

        String typeCode = mapDegreeType(student.getSubDepartment());
        String addonCode = mapAddonType(student.getSpecializationType());
        String addonName = student.getSpecializationName();
        if ("N/A".equals(addonName) || addonName == null || addonName.isEmpty()) {
            addonName = null;
        }

        // Find the matching degree path within the student's isolated department
        DegreePath path = degreePathRepository.findByCodesAndAddonName(deptCode, typeCode, addonCode, addonName)
                .orElse(null);

        // If no exact match with addon name, try without
        if (path == null && addonName != null) {
            path = degreePathRepository.findByCodesAndAddonName(deptCode, typeCode, addonCode, null)
                    .orElse(null);
        }

        // If still no match, fallback to REGULAR + NONE within the student's department ONLY
        if (path == null) {
            path = degreePathRepository.findByCodesAndAddonName(deptCode, "REGULAR", "NONE", null)
                    .orElse(null);
        }

        if (path == null) {
            enqueueUnmatchedStudent(student, "UNRESOLVED_PATH",
                    "No valid degree path found for department " + deptCode + " (type=" + typeCode + ", addon=" + addonCode + ")");
            throw new RuntimeException("No matching degree path found for student " + studentId 
                + " (dept=" + deptCode + ", type=" + typeCode + ", addon=" + addonCode + ", name=" + addonName + ")");
        }

        // Assign path to student
        return assignPath(studentId, path.getId(), null);
    }

    /**
     * Manually assign a specific degree path to a student.
     */
    public DegreePath assignPath(Long studentId, Long degreePathId, Long assignedById) {
        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        DegreePath path = degreePathRepository.findById(degreePathId)
                .orElseThrow(() -> new RuntimeException("Degree path not found"));

        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId)
                .orElse(new StudentDegreePath());

        sdp.setStudent(student);
        sdp.setDegreePath(path);
        sdp.setIsConfirmed(true);
        sdp.setAssignedBy(assignedById);

        studentDegreePathRepository.save(sdp);

        // If student was pending in review queue, mark as RESOLVED
        unmatchedStudentQueueRepository.findByStudentIdNumAndStatus(student.getStudentId(), "PENDING_REVIEW")
                .ifPresent(q -> {
                    q.setStatus("RESOLVED");
                    q.setResolutionNotes("Resolved and assigned to path " + path.getPathCode());
                    q.setResolvedBy(assignedById != null ? assignedById.toString() : "ADMIN");
                    q.setResolvedAt(java.time.LocalDateTime.now());
                    unmatchedStudentQueueRepository.save(q);
                });

        // Record audit log
        MappingAuditLog audit = new MappingAuditLog();
        audit.setStudent(student);
        audit.setStudentIdNum(student.getStudentId());
        audit.setAction("CURRICULUM_PATH_ASSIGNMENT");
        audit.setChangedBy(assignedById != null ? assignedById.toString() : "SYSTEM");
        audit.setNewValue(path.getPathCode());
        audit.setReason("Degree path assigned under department " + path.getDepartment().getDeptCode());
        mappingAuditLogRepository.save(audit);

        return path;
    }

    /**
     * Helper to route ambiguous or unmapped students to the review queue.
     */
    public void enqueueUnmatchedStudent(Student student, String issueType, String errorMessage) {
        if (!unmatchedStudentQueueRepository.existsByStudentIdNumAndStatus(student.getStudentId(), "PENDING_REVIEW")) {
            UnmatchedStudentQueue queue = new UnmatchedStudentQueue();
            queue.setStudent(student);
            queue.setStudentIdNum(student.getStudentId());
            queue.setStudentName(student.getName());
            queue.setRawDepartment(student.getDepartment());
            queue.setRawRegulation(student.getAcademicYear());
            queue.setIssueType(issueType);
            queue.setErrorMessage(errorMessage);
            queue.setStatus("PENDING_REVIEW");
            unmatchedStudentQueueRepository.save(queue);
        }
    }

    /**
     * Get the currently assigned degree path for a student.
     */
    public Optional<StudentDegreePath> getStudentPath(Long studentId) {
        return studentDegreePathRepository.findByStudentId(studentId);
    }

    /**
     * List all available degree paths for a given department.
     */
    public List<DegreePath> listAvailablePaths(String deptCode) {
        DepartmentMaster dept = departmentMasterRepository.findByDeptCode(deptCode).orElse(null);
        if (dept == null) return Collections.emptyList();
        return degreePathRepository.findByDepartmentId(dept.getId());
    }

    /**
     * Auto-resolve paths for all students who don't have one assigned yet.
     */
    public Map<String, Object> autoAssignAllStudents() {
        List<Student> students = studentRepository.findAll();
        int assigned = 0;
        int failed = 0;
        List<String> errors = new ArrayList<>();

        for (Student student : students) {
            if (studentDegreePathRepository.existsByStudentId(student.getId())) {
                continue; // Already assigned
            }
            try {
                resolveAndAssignPath(student.getId());
                assigned++;
            } catch (Exception e) {
                failed++;
                errors.add(student.getStudentId() + ": " + e.getMessage());
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("assigned", assigned);
        result.put("failed", failed);
        result.put("errors", errors);
        return result;
    }

    // ==================== Private mapping helpers ====================

    private String mapDepartment(String dept) {
        if (dept == null || dept.trim().isEmpty()) return null;
        String upper = dept.toUpperCase().trim();
        // Exact and fuzzy match for CSE
        if (upper.equals("CSE") || upper.equals("B.TECH CSE") || upper.contains("COMPUTER SCIENCE")) return "CSE";
        // Exact and fuzzy match for AIDS
        if (upper.equals("AIDS") || upper.equals("AI&DS") || upper.equals("AI & DS") || upper.equals("B.TECH AIDS") 
                || upper.contains("ARTIFICIAL INTELLIGENCE") || upper.contains("DATA SCIENCE")) return "AIDS";
        // Other departments
        if (upper.equals("CSIT") || upper.contains("INFORMATION TECHNOLOGY")) return "CSIT";
        if (upper.contains("EEE") || upper.contains("ELECTRICAL")) return "EEE";
        if (upper.contains("ECE") || upper.contains("ELECTRONICS")) return "ECE";
        if (upper.contains("MECH") || upper.contains("MECHANICAL")) return "MECH";
        if (upper.contains("CIVIL")) return "CIVIL";
        return null; // Unknown / ambiguous department! Do NOT default to CSE!
    }

    private String mapDegreeType(String subDept) {
        if (subDept == null || subDept.isEmpty() || "REGULAR".equalsIgnoreCase(subDept)) return "REGULAR";
        String upper = subDept.toUpperCase().trim();
        if (upper.contains("HTE")) return "HTE";
        if (upper.contains("HTI")) return "HTI";
        if (upper.contains("HTR")) return "HTR";
        if (upper.contains("HONOR")) return "HONORS";
        return "REGULAR";
    }

    private String mapAddonType(String specType) {
        if (specType == null || specType.isEmpty() || "NONE".equalsIgnoreCase(specType)) return "NONE";
        String upper = specType.toUpperCase().trim();
        if (upper.contains("SPECIALIZATION") || upper.contains("SPEC")) return "SPECIALIZATION";
        if (upper.contains("MINOR")) return "MINOR";
        if (upper.contains("DOUBLE")) return "DOUBLE_MAJOR";
        return "NONE";
    }
}
