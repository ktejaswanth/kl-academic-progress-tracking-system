package com.example.demo.repository;

import com.example.demo.model.UploadHistory;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UploadHistoryRepository extends JpaRepository<UploadHistory, Long> {
    List<UploadHistory> findByUploadedBy(User uploadedBy);
}
