package com.example.demo.repository;

import com.example.demo.model.UploadFailedRecord;
import com.example.demo.model.UploadHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UploadFailedRecordRepository extends JpaRepository<UploadFailedRecord, Long> {
    List<UploadFailedRecord> findByUpload(UploadHistory upload);
    List<UploadFailedRecord> findByUploadId(Long uploadId);
}
