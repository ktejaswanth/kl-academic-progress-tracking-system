package com.example.demo.repository;

import com.example.demo.model.CurriculumCourseMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CurriculumCourseMappingRepository extends JpaRepository<CurriculumCourseMapping, Long> {
    List<CurriculumCourseMapping> findByCurriculumVersionId(Long curriculumVersionId);
    List<CurriculumCourseMapping> findByCurriculumVersionIdAndBucketId(Long curriculumVersionId, Long bucketId);
    
    @Query("SELECT ccm FROM CurriculumCourseMapping ccm WHERE ccm.curriculumVersion.id = :versionId AND ccm.bucket.id = :bucketId AND (ccm.degreePath IS NULL OR ccm.degreePath.id = :pathId)")
    List<CurriculumCourseMapping> findByVersionAndBucketAndPath(@Param("versionId") Long versionId, @Param("bucketId") Long bucketId, @Param("pathId") Long pathId);
}
