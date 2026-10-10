package com.example.demo.repository;

import com.example.demo.model.DepartmentMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DepartmentMasterRepository extends JpaRepository<DepartmentMaster, Long> {
    Optional<DepartmentMaster> findByDeptCode(String deptCode);
}
