package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;

@Entity
@Table(name = "path_sub_bucket_requirements",
       uniqueConstraints = @UniqueConstraint(columnNames = {"degree_path_id", "sub_bucket_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PathSubBucketRequirement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "degree_path_id", nullable = false)
    private DegreePath degreePath;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "bucket_id", nullable = false)
    private BucketMaster bucket;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "sub_bucket_id", nullable = false)
    private SubBucketMaster subBucket;

    @Column(name = "target_credits", nullable = false)
    private Double targetCredits = 0.0;

    @Column(name = "min_credits")
    private Double minCredits;

    @Column(name = "max_credits")
    private Double maxCredits;

    @Column(name = "min_courses")
    private Integer minCourses;

    @Column(name = "max_courses")
    private Integer maxCourses;

    @Column(name = "is_mandatory")
    private Boolean isMandatory = true;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "rules_json", columnDefinition = "jsonb")
    private String rulesJson;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
