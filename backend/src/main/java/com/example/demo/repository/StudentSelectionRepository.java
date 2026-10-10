package com.example.demo.repository;

import com.example.demo.model.StudentSelection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StudentSelectionRepository extends JpaRepository<StudentSelection, Long> {
    Optional<StudentSelection> findByStudentId(Long studentId);
}
