package com.example.demo.repository;

import com.example.demo.model.CurriculumBucket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CurriculumBucketRepository extends JpaRepository<CurriculumBucket, Long> {
    List<CurriculumBucket> findByCurriculumVersionId(Long curriculumVersionId);
    Optional<CurriculumBucket> findByCurriculumVersionIdAndBucketId(Long curriculumVersionId, Long bucketId);
}
