package com.example.demo.repository;

import com.example.demo.model.StudentExitSummary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentExitSummaryRepository extends JpaRepository<StudentExitSummary, Long> {
    Optional<StudentExitSummary> findByStudentId(Long studentId);

    @Query("SELECT ses FROM StudentExitSummary ses WHERE ses.student.department = :dept")
    List<StudentExitSummary> findByDepartment(@Param("dept") String dept);

    @Query("SELECT COUNT(ses) FROM StudentExitSummary ses WHERE ses.overallStatus = :status")
    long countByOverallStatus(@Param("status") String status);

    @Query("SELECT COUNT(ses) FROM StudentExitSummary ses WHERE ses.student.department = :dept AND ses.overallStatus = :status")
    long countByDepartmentAndOverallStatus(@Param("dept") String dept, @Param("status") String status);
}
