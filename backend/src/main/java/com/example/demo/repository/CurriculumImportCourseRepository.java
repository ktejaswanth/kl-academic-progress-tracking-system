package com.example.demo.repository;

import com.example.demo.model.CurriculumImportCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CurriculumImportCourseRepository extends JpaRepository<CurriculumImportCourse, Long> {
    List<CurriculumImportCourse> findByImportRecordId(Long importId);
}
