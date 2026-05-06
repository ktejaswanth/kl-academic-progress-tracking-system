package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "upload_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UploadHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "uploaded_by", referencedColumnName = "id")
    private User uploadedBy;

    @Column(name = "file_name")
    private String fileName;

    @Column(name = "total_records")
    private Integer totalRecords = 0;

    @Column(name = "success_count")
    private Integer successCount = 0;

    @Column(name = "failed_count")
    private Integer failedCount = 0;

    private String status = "PROCESSING";

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
