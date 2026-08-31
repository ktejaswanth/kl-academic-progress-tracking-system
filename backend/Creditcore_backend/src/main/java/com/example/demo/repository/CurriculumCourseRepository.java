package com.example.demo.repository;

import com.example.demo.model.CurriculumCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CurriculumCourseRepository extends JpaRepository<CurriculumCourse, Long> {
    List<CurriculumCourse> findByCurriculumVersionId(Long curriculumVersionId);
    Optional<CurriculumCourse> findByCurriculumVersionIdAndCourseId(Long curriculumVersionId, Long courseId);
    Optional<CurriculumCourse> findByCurriculumVersionIdAndCourseCourseCode(Long curriculumVersionId, String courseCode);
}
