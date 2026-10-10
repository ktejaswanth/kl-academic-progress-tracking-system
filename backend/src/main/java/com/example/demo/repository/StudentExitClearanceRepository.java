package com.example.demo.repository;

import com.example.demo.model.StudentExitClearance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentExitClearanceRepository extends JpaRepository<StudentExitClearance, Long> {
    List<StudentExitClearance> findByStudentIdOrderByRequirement_DisplayOrderAsc(Long studentId);
    Optional<StudentExitClearance> findByStudentIdAndRequirementId(Long studentId, Long requirementId);
    List<StudentExitClearance> findByStudentIdAndStatus(Long studentId, String status);

    @Query("SELECT sec FROM StudentExitClearance sec " +
           "WHERE sec.requirement.responsibleRole = :role AND sec.student.department = :dept " +
           "ORDER BY sec.student.studentId ASC")
    List<StudentExitClearance> findByRoleAndDepartment(@Param("role") String role, @Param("dept") String dept);

    @Query("SELECT sec FROM StudentExitClearance sec " +
           "WHERE sec.student.department = :dept " +
           "ORDER BY sec.student.studentId ASC, sec.requirement.displayOrder ASC")
    List<StudentExitClearance> findByDepartment(@Param("dept") String dept);

    long countByStudentIdAndStatus(Long studentId, String status);
}
