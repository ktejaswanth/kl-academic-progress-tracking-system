package com.example.demo.repository;

import com.example.demo.model.CurriculumCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CurriculumCourseRepository extends JpaRepository<CurriculumCourse, Long> {
    List<CurriculumCourse> findByCurriculumVersionId(Long curriculumVersionId);
}
