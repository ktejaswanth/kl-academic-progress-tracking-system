package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "course_bucket_mapping")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CourseBucketMapping {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "course_id", nullable = false)
    private CourseCatalog course;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "bucket_id", nullable = false)
    private BucketMaster bucket;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "degree_path_id")
    private DegreePath degreePath;

    @Column(name = "is_mandatory")
    private Boolean isMandatory = false;

    @Column(name = "semester_offered")
    private String semesterOffered;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
