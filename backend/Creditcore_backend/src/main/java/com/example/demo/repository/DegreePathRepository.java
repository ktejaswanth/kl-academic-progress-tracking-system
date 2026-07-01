package com.example.demo.repository;

import com.example.demo.model.DegreePath;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DegreePathRepository extends JpaRepository<DegreePath, Long> {
    Optional<DegreePath> findByPathCode(String pathCode);

    @Query("SELECT dp FROM DegreePath dp WHERE dp.department.id = :deptId AND dp.degreeType.id = :typeId AND dp.addonType.id = :addonId AND dp.isActive = true")
    List<DegreePath> findByDepartmentAndTypeAndAddon(@Param("deptId") Long deptId, @Param("typeId") Long typeId, @Param("addonId") Long addonId);

    @Query("SELECT dp FROM DegreePath dp WHERE dp.department.id = :deptId AND dp.regulation.id = :regId AND dp.isActive = true")
    List<DegreePath> findByDepartmentAndRegulation(@Param("deptId") Long deptId, @Param("regId") Long regId);

    List<DegreePath> findByDepartmentId(Long departmentId);

    List<DegreePath> findByIsActiveTrue();

    @Query("SELECT dp FROM DegreePath dp WHERE dp.department.deptCode = :deptCode AND dp.degreeType.typeCode = :typeCode AND dp.addonType.addonCode = :addonCode AND (:addonName IS NULL OR dp.addonName = :addonName) AND dp.isActive = true")
    Optional<DegreePath> findByCodesAndAddonName(@Param("deptCode") String deptCode, @Param("typeCode") String typeCode, @Param("addonCode") String addonCode, @Param("addonName") String addonName);
}
