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

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "course_id")
    private CourseCatalog course;

    @Column(name = "course_name")
    private String courseName;

    private Double credits;

    private String ltps;

    @Column(name = "lecture_hours")
    private Integer lectureHours = 0;

    @Column(name = "tutorial_hours")
    private Integer tutorialHours = 0;

    @Column(name = "practical_hours")
    private Integer practicalHours = 0;

    @Column(name = "skill_hours")
    private Integer skillHours = 0;

    @Column(name = "course_type")
    private String courseType;

    private String category;

    private String subcategory;

    private String semester;

    @Column(name = "study_year")
    private Integer studyYear;

    private String prerequisite;

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
