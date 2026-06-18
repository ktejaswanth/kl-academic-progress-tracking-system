package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumCourse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @ManyToOne
    @JoinColumn(name = "course_id")
    private CourseCatalog course;

    @Column(name = "is_mandatory")
    private Boolean isMandatory = false;

    @Column(name = "bucket_name")
    private String bucketName;

    @Column(name = "min_year")
    private Integer minYear;

    @Column(name = "max_year")
    private Integer maxYear;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
