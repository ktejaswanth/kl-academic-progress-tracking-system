package com.example.demo.repository;

import com.example.demo.model.StudentOutcome;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StudentOutcomeRepository extends JpaRepository<StudentOutcome, Long> {
    Optional<StudentOutcome> findByStudentId(Long studentId);
}
