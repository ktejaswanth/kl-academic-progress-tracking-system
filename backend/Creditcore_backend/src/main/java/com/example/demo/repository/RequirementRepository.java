package com.example.demo.repository;

import com.example.demo.model.Requirement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RequirementRepository extends JpaRepository<Requirement, Long> {
    List<Requirement> findByDegreeTypeAndSpecializationAndHonorsType(String degreeType, String specialization, String honorsType);
    List<Requirement> findByDegreeTypeAndSpecialization(String degreeType, String specialization);
}
