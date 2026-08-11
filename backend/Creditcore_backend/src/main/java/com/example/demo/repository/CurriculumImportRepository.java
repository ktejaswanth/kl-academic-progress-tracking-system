package com.example.demo.repository;

import com.example.demo.model.CurriculumImport;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CurriculumImportRepository extends JpaRepository<CurriculumImport, Long> {
    List<CurriculumImport> findByStatus(String status);
    List<CurriculumImport> findByDepartmentAndRegulation(String department, String regulation);
    List<CurriculumImport> findAllByOrderByCreatedAtDesc();
}
