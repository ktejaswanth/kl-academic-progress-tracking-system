package com.example.demo.repository;

import com.example.demo.model.PathSubBucketRequirement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PathSubBucketRequirementRepository extends JpaRepository<PathSubBucketRequirement, Long> {
    List<PathSubBucketRequirement> findByDegreePathId(Long degreePathId);
    List<PathSubBucketRequirement> findByDegreePathIdAndBucketId(Long degreePathId, Long bucketId);
    Optional<PathSubBucketRequirement> findByDegreePathIdAndSubBucketId(Long degreePathId, Long subBucketId);
}
