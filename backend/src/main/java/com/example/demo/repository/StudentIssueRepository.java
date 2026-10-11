package com.example.demo.repository;

import com.example.demo.model.StudentIssue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentIssueRepository extends JpaRepository<StudentIssue, Long> {
    List<StudentIssue> findByStudentId(Long studentId);
    List<StudentIssue> findAllByOrderByCreatedAtDesc();
}
