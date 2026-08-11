package com.example.demo.repository;

import com.example.demo.model.CurriculumImportError;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CurriculumImportErrorRepository extends JpaRepository<CurriculumImportError, Long> {
    List<CurriculumImportError> findByImportRecordId(Long importId);
}
