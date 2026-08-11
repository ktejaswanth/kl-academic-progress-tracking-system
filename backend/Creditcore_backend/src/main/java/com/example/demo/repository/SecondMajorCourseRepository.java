package com.example.demo.repository;

import com.example.demo.model.SecondMajorCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SecondMajorCourseRepository extends JpaRepository<SecondMajorCourse, Long> {
    List<SecondMajorCourse> findBySecondMajorId(Long secondMajorId);
}
