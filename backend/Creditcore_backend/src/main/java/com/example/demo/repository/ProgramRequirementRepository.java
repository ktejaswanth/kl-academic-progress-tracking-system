package com.example.demo.repository;

import com.example.demo.model.ProgramRequirement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProgramRequirementRepository extends JpaRepository<ProgramRequirement, Long> {
    List<ProgramRequirement> findByCurriculumVersionId(Long curriculumVersionId);
}
