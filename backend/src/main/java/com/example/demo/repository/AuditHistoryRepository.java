package com.example.demo.repository;

import com.example.demo.model.AuditHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuditHistoryRepository extends JpaRepository<AuditHistory, Long> {
    List<AuditHistory> findByStudentId(Long studentId);
}
