package com.example.demo.repository;

import com.example.demo.model.StudentCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentCourseRepository extends JpaRepository<StudentCourse, Long> {
    List<StudentCourse> findByStudentId(Long studentId);
    List<StudentCourse> findByUniversityId(String universityId);
    List<StudentCourse> findByStudentIdAndStatus(Long studentId, String status);
}
