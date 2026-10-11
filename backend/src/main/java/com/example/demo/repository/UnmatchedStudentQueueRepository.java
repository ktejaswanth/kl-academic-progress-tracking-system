package com.example.demo.repository;

import com.example.demo.model.UnmatchedStudentQueue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UnmatchedStudentQueueRepository extends JpaRepository<UnmatchedStudentQueue, Long> {

    List<UnmatchedStudentQueue> findByStatus(String status);

    Optional<UnmatchedStudentQueue> findByStudentIdNumAndStatus(String studentIdNum, String status);

    boolean existsByStudentIdNumAndStatus(String studentIdNum, String status);
}
