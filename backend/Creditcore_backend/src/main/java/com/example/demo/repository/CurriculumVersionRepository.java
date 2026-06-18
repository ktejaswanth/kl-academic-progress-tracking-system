package com.example.demo.repository;

import com.example.demo.model.CurriculumVersion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CurriculumVersionRepository extends JpaRepository<CurriculumVersion, Long> {
    List<CurriculumVersion> findByProgramId(Long programId);
}
