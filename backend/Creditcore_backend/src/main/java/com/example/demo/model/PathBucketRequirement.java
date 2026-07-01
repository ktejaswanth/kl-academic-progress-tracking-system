package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "path_bucket_requirements",
       uniqueConstraints = @UniqueConstraint(columnNames = {"degree_path_id", "bucket_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PathBucketRequirement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "degree_path_id", nullable = false)
    private DegreePath degreePath;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "bucket_id", nullable = false)
    private BucketMaster bucket;

    @Column(name = "required_credits", nullable = false)
    private Integer requiredCredits;

    @Column(name = "min_courses")
    private Integer minCourses;

    @Column(name = "is_mandatory")
    private Boolean isMandatory = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
