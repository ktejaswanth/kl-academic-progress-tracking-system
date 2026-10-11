package com.example.demo.repository;

import com.example.demo.model.SubBucketMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SubBucketMasterRepository extends JpaRepository<SubBucketMaster, Long> {
    Optional<SubBucketMaster> findBySubBucketCode(String subBucketCode);
    List<SubBucketMaster> findByBucketId(Long bucketId);
    List<SubBucketMaster> findByIsActiveTrue();
}
