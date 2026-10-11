package com.example.demo.repository;

import com.example.demo.model.CurriculumImportSpecialization;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CurriculumImportSpecializationRepository extends JpaRepository<CurriculumImportSpecialization, Long> {
    List<CurriculumImportSpecialization> findByImportRecordId(Long importId);
}
