package com.example.demo.repository;

import com.example.demo.model.CurriculumVersion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CurriculumVersionRepository extends JpaRepository<CurriculumVersion, Long> {
    List<CurriculumVersion> findByProgramId(Long programId);
    List<CurriculumVersion> findByDepartmentIdAndRegulationMasterId(Long departmentId, Long regulationId);
    Optional<CurriculumVersion> findByCurriculumCode(String curriculumCode);
}
