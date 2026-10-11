package com.example.demo.repository;

import com.example.demo.model.DegreeTypeMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DegreeTypeMasterRepository extends JpaRepository<DegreeTypeMaster, Long> {
    Optional<DegreeTypeMaster> findByTypeCode(String typeCode);
}
