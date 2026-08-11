package com.example.demo.repository;

import com.example.demo.model.StudentCourseAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentCourseAttemptRepository extends JpaRepository<StudentCourseAttempt, Long> {
    List<StudentCourseAttempt> findByStudentIdAndCourseCode(Long studentId, String courseCode);
    List<StudentCourseAttempt> findByStudentIdAndIsQualifyingTrue(Long studentId);
}
