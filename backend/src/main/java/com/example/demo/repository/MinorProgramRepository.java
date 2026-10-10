package com.example.demo.repository;

import com.example.demo.model.MinorProgram;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MinorProgramRepository extends JpaRepository<MinorProgram, Long> {
    List<MinorProgram> findByProgramId(Long programId);
    List<MinorProgram> findByCurriculumVersionId(Long curriculumVersionId);
    Optional<MinorProgram> findByCode(String code);
}
