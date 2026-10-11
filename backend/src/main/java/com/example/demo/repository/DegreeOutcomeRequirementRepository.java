package com.example.demo.repository;

import com.example.demo.model.DegreeOutcomeRequirement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DegreeOutcomeRequirementRepository extends JpaRepository<DegreeOutcomeRequirement, Long> {
    Optional<DegreeOutcomeRequirement> findByDegreePathId(Long degreePathId);
}
