package com.example.demo.service;

import com.example.demo.model.Student;
import com.example.demo.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Service providing role checks and authorization validation to prevent
 * Insecure Direct Object Reference (IDOR) attacks across student-related endpoints.
 */
@Service
public class UserSecurityService {

    @Autowired
    private StudentRepository studentRepository;

    /**
     * Checks if the authenticated principal has administrative or faculty privileges.
     */
    public boolean isStaff(Authentication auth) {
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return false;
        }
        return auth.getAuthorities().stream().anyMatch(a ->
                "ROLE_SUPER_ADMIN".equals(a.getAuthority()) ||
                "ROLE_ADMIN".equals(a.getAuthority()) ||
                "ROLE_FACULTY".equals(a.getAuthority())
        );
    }

    /**
     * Evaluates whether the caller is authorized to view or modify the target student's data:
     * - Staff members (SUPER_ADMIN, ADMIN, FACULTY) are authorized for any student.
     * - Students (ROLE_STUDENT) are authorized ONLY for their own student record matching
     *   their verified authentication principal.
     */
    public boolean canAccessStudentData(Authentication auth, Long targetStudentId) {
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName()) || targetStudentId == null) {
            return false;
        }

        if (isStaff(auth)) {
            return true;
        }

        boolean isStudent = auth.getAuthorities().stream().anyMatch(a ->
                "ROLE_STUDENT".equals(a.getAuthority())
        );

        if (isStudent) {
            String username = auth.getName();
            Optional<Student> studentOpt = studentRepository.findByStudentId(username);
            return studentOpt.isPresent() && targetStudentId.equals(studentOpt.get().getId());
        }

        return false;
    }

    /**
     * Overload resolving current SecurityContext.
     */
    public boolean canAccessStudentData(Long targetStudentId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return canAccessStudentData(auth, targetStudentId);
    }

    /**
     * Retrieves the authenticated student entity if current principal is an active student.
     */
    public Optional<Student> getAuthenticatedStudent() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getName())) {
            return Optional.empty();
        }
        return studentRepository.findByStudentId(auth.getName());
    }
}
