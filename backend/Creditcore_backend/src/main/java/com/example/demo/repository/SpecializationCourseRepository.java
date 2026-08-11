package com.example.demo.repository;

import com.example.demo.model.SpecializationCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SpecializationCourseRepository extends JpaRepository<SpecializationCourse, Long> {
    List<SpecializationCourse> findBySpecializationId(Long specializationId);
    List<SpecializationCourse> findBySpecializationIdAndRole(Long specializationId, String role);
}
