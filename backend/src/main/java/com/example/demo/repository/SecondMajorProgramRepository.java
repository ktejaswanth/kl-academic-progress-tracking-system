package com.example.demo.repository;

import com.example.demo.model.SecondMajorProgram;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SecondMajorProgramRepository extends JpaRepository<SecondMajorProgram, Long> {
    List<SecondMajorProgram> findByDepartmentId(Long departmentId);
    List<SecondMajorProgram> findByCurriculumVersionId(Long curriculumVersionId);
    Optional<SecondMajorProgram> findByCode(String code);
}
