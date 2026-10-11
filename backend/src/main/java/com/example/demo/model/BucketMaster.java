package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "bucket_master")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BucketMaster {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "bucket_code", unique = true, nullable = false)
    private String bucketCode;

    @Column(name = "bucket_name", nullable = false)
    private String bucketName;

    @Column(name = "bucket_category")
    private String bucketCategory;

    private String description;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
