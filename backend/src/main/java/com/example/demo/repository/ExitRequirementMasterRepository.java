package com.example.demo.repository;

import com.example.demo.model.ExitRequirementMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ExitRequirementMasterRepository extends JpaRepository<ExitRequirementMaster, Long> {
    Optional<ExitRequirementMaster> findByRequirementCode(String requirementCode);
    List<ExitRequirementMaster> findAllByOrderByDisplayOrderAsc();
    List<ExitRequirementMaster> findByCategoryOrderByDisplayOrderAsc(String category);
    List<ExitRequirementMaster> findByResponsibleRoleOrderByDisplayOrderAsc(String responsibleRole);
}
