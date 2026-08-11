package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_import_buckets")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumImportBucket {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "import_id", nullable = false)
    private CurriculumImport importRecord;

    @Column(name = "bucket_code")
    private String bucketCode;

    @Column(name = "bucket_name")
    private String bucketName;

    @Column(name = "bucket_category")
    private String bucketCategory;

    private String description;

    @Column(name = "min_credits")
    private Integer minCredits = 0;

    @Column(name = "max_credits")
    private Integer maxCredits = 0;

    @Column(name = "min_courses")
    private Integer minCourses = 0;

    @Column(name = "max_courses")
    private Integer maxCourses = 0;

    @Column(name = "degree_type")
    private String degreeType = "REGULAR";

    @Column(name = "source_page")
    private Integer sourcePage;

    @Column(name = "source_section")
    private String sourceSection;

    @Column(name = "raw_value", columnDefinition = "text")
    private String rawValue;

    @Column(name = "parsed_value", columnDefinition = "text")
    private String parsedValue;

    private Double confidence = 1.0;

    @Column(name = "validation_status")
    private String validationStatus = "VALID";

    @Column(name = "error_message", columnDefinition = "text")
    private String errorMessage;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
