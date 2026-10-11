package com.example.demo.repository;

import com.example.demo.model.ProgramCourseEquivalence;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProgramCourseEquivalenceRepository extends JpaRepository<ProgramCourseEquivalence, Long> {

    @Query("SELECT pce FROM ProgramCourseEquivalence pce " +
           "WHERE pce.targetCurriculumVersion.id = :targetVersionId " +
           "AND pce.sourceCourseCode = :sourceCourseCode " +
           "AND pce.status = 'APPROVED'")
    List<ProgramCourseEquivalence> findApprovedEquivalencesForTarget(
            @Param("targetVersionId") Long targetVersionId,
            @Param("sourceCourseCode") String sourceCourseCode
    );

    Optional<ProgramCourseEquivalence> findBySourceCurriculumVersionIdAndTargetCurriculumVersionIdAndSourceCourseCodeAndTargetCourseCode(
            Long sourceVersionId,
            Long targetVersionId,
            String sourceCourseCode,
            String targetCourseCode
    );

    List<ProgramCourseEquivalence> findByStatus(String status);
}
