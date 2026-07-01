package com.example.demo.repository;

import com.example.demo.model.BucketMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BucketMasterRepository extends JpaRepository<BucketMaster, Long> {
    Optional<BucketMaster> findByBucketCode(String bucketCode);
    List<BucketMaster> findByBucketCategory(String bucketCategory);
}
