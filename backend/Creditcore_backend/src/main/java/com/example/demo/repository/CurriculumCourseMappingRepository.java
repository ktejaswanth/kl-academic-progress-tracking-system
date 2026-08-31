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
    List<CurriculumCourseMapping> findByDegreePathId(Long degreePathId);
    
    @Query("SELECT ccm FROM CurriculumCourseMapping ccm JOIN FETCH ccm.curriculumCourse cc JOIN FETCH cc.course JOIN FETCH ccm.bucket WHERE ccm.curriculumVersion.id = :versionId AND ccm.bucket.id = :bucketId AND (ccm.degreePath IS NULL OR ccm.degreePath.id = :pathId)")
    List<CurriculumCourseMapping> findByVersionAndBucketAndPath(@Param("versionId") Long versionId, @Param("bucketId") Long bucketId, @Param("pathId") Long pathId);

    @Query("SELECT ccm FROM CurriculumCourseMapping ccm JOIN FETCH ccm.curriculumCourse cc JOIN FETCH cc.course JOIN FETCH ccm.bucket WHERE ccm.curriculumVersion.id = :versionId AND cc.course.courseCode = :courseCode AND (ccm.degreePath.id = :pathId OR ccm.degreePath IS NULL)")
    List<CurriculumCourseMapping> findByVersionAndCourseCodeAndPathOrUniversal(@Param("versionId") Long versionId, @Param("courseCode") String courseCode, @Param("pathId") Long pathId);

    @Query("SELECT ccm FROM CurriculumCourseMapping ccm JOIN FETCH ccm.curriculumCourse cc JOIN FETCH cc.course JOIN FETCH ccm.bucket WHERE cc.course.courseCode = :courseCode AND (ccm.degreePath.id = :pathId OR ccm.degreePath IS NULL)")
    List<CurriculumCourseMapping> findByCourseCodeAndPathOrUniversal(@Param("courseCode") String courseCode, @Param("pathId") Long pathId);
}
