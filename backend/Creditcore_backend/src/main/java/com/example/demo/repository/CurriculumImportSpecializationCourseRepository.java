package com.example.demo.repository;

import com.example.demo.model.CurriculumImportSpecializationCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CurriculumImportSpecializationCourseRepository extends JpaRepository<CurriculumImportSpecializationCourse, Long> {
    List<CurriculumImportSpecializationCourse> findByImportRecordId(Long importId);
}
