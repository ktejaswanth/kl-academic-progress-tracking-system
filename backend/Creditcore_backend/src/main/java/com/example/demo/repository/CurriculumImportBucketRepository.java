package com.example.demo.repository;

import com.example.demo.model.CurriculumImportBucket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CurriculumImportBucketRepository extends JpaRepository<CurriculumImportBucket, Long> {
    List<CurriculumImportBucket> findByImportRecordId(Long importId);
}
