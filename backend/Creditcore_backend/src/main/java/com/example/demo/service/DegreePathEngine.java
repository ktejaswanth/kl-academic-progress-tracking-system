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
    private UserRepository userRepository;
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

    /**
     * Resolve and assign a degree path for a student based on their profile.
     * Uses the user's department, subDepartment (degree type), specializationType, and specializationName.
     */
    public DegreePath resolveAndAssignPath(Long studentId) {
        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found: " + studentId));

        // Map user fields to DYOD codes
        String deptCode = mapDepartment(student.getDepartment());
        String typeCode = mapDegreeType(student.getSubDepartment());
        String addonCode = mapAddonType(student.getSpecializationType());
        String addonName = student.getSpecializationName();
        if ("N/A".equals(addonName) || addonName == null || addonName.isEmpty()) {
            addonName = null;
        }

        // Find the matching degree path
        DegreePath path = degreePathRepository.findByCodesAndAddonName(deptCode, typeCode, addonCode, addonName)
                .orElse(null);

        // If no exact match with addon name, try without
        if (path == null && addonName != null) {
            path = degreePathRepository.findByCodesAndAddonName(deptCode, typeCode, addonCode, null)
                    .orElse(null);
        }

        // If still no match, try REGULAR + NONE as fallback
        if (path == null) {
            path = degreePathRepository.findByCodesAndAddonName(deptCode, "REGULAR", "NONE", null)
                    .orElse(null);
        }

        if (path == null) {
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
        User student = userRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Student not found"));
        DegreePath path = degreePathRepository.findById(degreePathId)
                .orElseThrow(() -> new RuntimeException("Degree path not found"));

        StudentDegreePath sdp = studentDegreePathRepository.findByStudentId(studentId)
                .orElse(new StudentDegreePath());

        sdp.setStudent(student);
        sdp.setDegreePath(path);
        sdp.setIsConfirmed(true);

        if (assignedById != null) {
            User assignedBy = userRepository.findById(assignedById).orElse(null);
            sdp.setAssignedBy(assignedBy);
        }

        studentDegreePathRepository.save(sdp);
        return path;
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
        List<User> students = userRepository.findByRole(UserRole.STUDENT);
        int assigned = 0;
        int failed = 0;
        List<String> errors = new ArrayList<>();

        for (User student : students) {
            if (studentDegreePathRepository.existsByStudentId(student.getId())) {
                continue; // Already assigned
            }
            try {
                resolveAndAssignPath(student.getId());
                assigned++;
            } catch (Exception e) {
                failed++;
                errors.add(student.getUsername() + ": " + e.getMessage());
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
        if (dept == null || dept.isEmpty()) return "CSE";
        String upper = dept.toUpperCase().trim();
        // Handle common variations
        if (upper.contains("CSE") || upper.contains("COMPUTER SCIENCE")) return "CSE";
        if (upper.contains("AIDS") || upper.contains("AI") || upper.contains("DATA SCIENCE")) return "AIDS";
        if (upper.contains("CSIT") || upper.contains("INFORMATION TECHNOLOGY")) return "CSIT";
        if (upper.contains("EEE") || upper.contains("ELECTRICAL")) return "EEE";
        if (upper.contains("ECE") || upper.contains("ELECTRONICS AND COMM")) return "ECE";
        if (upper.contains("MECH") || upper.contains("MECHANICAL")) return "MECH";
        if (upper.contains("CIVIL")) return "CIVIL";
        return upper;
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
