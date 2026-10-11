package com.example.demo.repository;

import com.example.demo.model.PathBucketRequirement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PathBucketRequirementRepository extends JpaRepository<PathBucketRequirement, Long> {
    List<PathBucketRequirement> findByDegreePathId(Long degreePathId);
    Optional<PathBucketRequirement> findByDegreePathIdAndBucketId(Long degreePathId, Long bucketId);
    void deleteByDegreePathId(Long degreePathId);
}
