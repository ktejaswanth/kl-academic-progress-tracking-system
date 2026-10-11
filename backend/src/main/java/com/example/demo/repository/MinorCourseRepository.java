package com.example.demo.repository;

import com.example.demo.model.MinorCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MinorCourseRepository extends JpaRepository<MinorCourse, Long> {
    List<MinorCourse> findByMinorId(Long minorId);
}
