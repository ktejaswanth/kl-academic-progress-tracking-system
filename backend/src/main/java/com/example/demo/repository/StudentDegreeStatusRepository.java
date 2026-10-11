package com.example.demo.repository;

import com.example.demo.model.StudentDegreeStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentDegreeStatusRepository extends JpaRepository<StudentDegreeStatus, Long> {
    Optional<StudentDegreeStatus> findByStudentId(Long studentId);
    List<StudentDegreeStatus> findByIsDegreeEligibleTrue();
    List<StudentDegreeStatus> findByStatus(String status);

    @Query("SELECT sds FROM StudentDegreeStatus sds JOIN sds.student u WHERE u.department = :dept")
    List<StudentDegreeStatus> findByDepartment(@Param("dept") String department);

    @Query("SELECT COUNT(sds) FROM StudentDegreeStatus sds JOIN sds.student u WHERE u.department = :dept AND sds.isDegreeEligible = true")
    long countEligibleByDepartment(@Param("dept") String department);

    @Query("SELECT COUNT(sds) FROM StudentDegreeStatus sds JOIN sds.student u WHERE u.department = :dept")
    long countByDepartment(@Param("dept") String department);
}
