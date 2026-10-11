package com.example.demo.repository;

import com.example.demo.model.CourseBucketMapping;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseBucketMappingRepository extends JpaRepository<CourseBucketMapping, Long> {
    List<CourseBucketMapping> findByCourseId(Long courseId);
    List<CourseBucketMapping> findByBucketId(Long bucketId);
    List<CourseBucketMapping> findByDegreePathId(Long degreePathId);

    @Query("SELECT cbm FROM CourseBucketMapping cbm WHERE cbm.course.id = :courseId AND (cbm.degreePath.id = :pathId OR cbm.degreePath IS NULL)")
    List<CourseBucketMapping> findByCourseIdAndPathOrUniversal(@Param("courseId") Long courseId, @Param("pathId") Long pathId);

    @Query("SELECT cbm FROM CourseBucketMapping cbm JOIN FETCH cbm.course JOIN FETCH cbm.bucket WHERE cbm.bucket.id = :bucketId AND (cbm.degreePath.id = :pathId OR cbm.degreePath IS NULL)")
    List<CourseBucketMapping> findByBucketIdAndPathOrUniversal(@Param("bucketId") Long bucketId, @Param("pathId") Long pathId);

    @Query("SELECT cbm FROM CourseBucketMapping cbm JOIN FETCH cbm.course JOIN FETCH cbm.bucket WHERE cbm.course.courseCode = :courseCode AND (cbm.degreePath.id = :pathId OR cbm.degreePath IS NULL)")
    List<CourseBucketMapping> findByCourseCodeAndPathOrUniversal(@Param("courseCode") String courseCode, @Param("pathId") Long pathId);

    boolean existsByCourseIdAndBucketIdAndDegreePathId(Long courseId, Long bucketId, Long degreePathId);
}
