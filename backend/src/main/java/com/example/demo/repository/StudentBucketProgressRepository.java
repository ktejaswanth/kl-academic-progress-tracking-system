package com.example.demo.repository;

import com.example.demo.model.StudentBucketProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentBucketProgressRepository extends JpaRepository<StudentBucketProgress, Long> {
    List<StudentBucketProgress> findByStudentId(Long studentId);
    List<StudentBucketProgress> findByStudentIdAndDegreePathId(Long studentId, Long degreePathId);
    Optional<StudentBucketProgress> findByStudentIdAndBucketIdAndDegreePathId(Long studentId, Long bucketId, Long degreePathId);
    void deleteByStudentIdAndDegreePathId(Long studentId, Long degreePathId);

    @Query("SELECT COUNT(sbp) FROM StudentBucketProgress sbp WHERE sbp.student.id = :studentId AND sbp.status = 'COMPLETED'")
    int countCompletedBuckets(@Param("studentId") Long studentId);

    @Query("SELECT COALESCE(SUM(sbp.earnedCredits), 0) FROM StudentBucketProgress sbp WHERE sbp.student.id = :studentId AND sbp.degreePath.id = :pathId")
    int sumEarnedCredits(@Param("studentId") Long studentId, @Param("pathId") Long pathId);
}
