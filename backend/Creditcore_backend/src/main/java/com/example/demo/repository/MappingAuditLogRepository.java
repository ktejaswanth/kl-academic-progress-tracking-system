package com.example.demo.repository;

import com.example.demo.model.MappingAuditLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MappingAuditLogRepository extends JpaRepository<MappingAuditLog, Long> {

    List<MappingAuditLog> findByStudentId(Long studentId);

    List<MappingAuditLog> findByStudentIdNum(String studentIdNum);
}
