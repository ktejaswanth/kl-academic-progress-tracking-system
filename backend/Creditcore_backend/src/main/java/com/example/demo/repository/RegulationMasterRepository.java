package com.example.demo.repository;

import com.example.demo.model.RegulationMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RegulationMasterRepository extends JpaRepository<RegulationMaster, Long> {
    Optional<RegulationMaster> findByRegCode(String regCode);
}
