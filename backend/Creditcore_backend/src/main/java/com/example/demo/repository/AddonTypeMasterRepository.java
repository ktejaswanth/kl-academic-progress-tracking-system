package com.example.demo.repository;

import com.example.demo.model.AddonTypeMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AddonTypeMasterRepository extends JpaRepository<AddonTypeMaster, Long> {
    Optional<AddonTypeMaster> findByAddonCode(String addonCode);
}
