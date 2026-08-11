package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_course_mapping")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumCourseMapping {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_version_id", nullable = false)
    private CurriculumVersion curriculumVersion;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_course_id", nullable = false)
    private CurriculumCourse curriculumCourse;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "bucket_id", nullable = false)
    private BucketMaster bucket;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "degree_path_id")
    private DegreePath degreePath;

    @Column(name = "is_mandatory")
    private Boolean isMandatory = false;

    @Column(name = "selection_group")
    private String selectionGroup;

    @Column(name = "selection_order")
    private Integer selectionOrder = 0;

    @Column(name = "semester_offered")
    private String semesterOffered;

    @Column(name = "mapping_source")
    private String mappingSource = "MANUAL";

    @Column(name = "mapping_confidence")
    private Double mappingConfidence = 1.0;

    @Column(name = "source_page")
    private Integer sourcePage;

    @Column(name = "source_section")
    private String sourceSection;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
