package com.example.demo.repository;

import com.example.demo.model.StudentDegreePath;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentDegreePathRepository extends JpaRepository<StudentDegreePath, Long> {
    Optional<StudentDegreePath> findByStudentId(Long studentId);
    List<StudentDegreePath> findByDegreePathId(Long degreePathId);
    boolean existsByStudentId(Long studentId);
}
