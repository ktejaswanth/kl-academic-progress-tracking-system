package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "minor_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MinorCourse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "minor_id", nullable = false)
    private MinorProgram minor;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "course_id", nullable = false)
    private CourseCatalog course;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "bucket_id")
    private BucketMaster bucket;

    private Boolean required = true;

    @Column(name = "sequence_no")
    private Integer sequenceNo = 1;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
