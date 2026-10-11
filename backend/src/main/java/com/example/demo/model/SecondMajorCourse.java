package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "second_major_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SecondMajorCourse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "second_major_id", nullable = false)
    private SecondMajorProgram secondMajor;

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
