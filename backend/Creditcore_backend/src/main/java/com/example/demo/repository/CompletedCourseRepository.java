package com.example.demo.repository;

import com.example.demo.model.CompletedCourse;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CompletedCourseRepository extends JpaRepository<CompletedCourse, Long> {
    List<CompletedCourse> findByStudent(User student);
    List<CompletedCourse> findByStudentId(Long studentId);
}
