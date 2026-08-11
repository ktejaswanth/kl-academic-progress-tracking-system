package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "specialization_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SpecializationCourse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "specialization_id", nullable = false)
    private Specialization specialization;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "course_id", nullable = false)
    private CourseCatalog course;

    @Column(nullable = false)
    private String role; // PE-1, PE-2, PE-3, PE-4, PE-5, SDC, SDP

    @Column(name = "sequence_no")
    private Integer sequenceNo = 1;

    private Boolean required = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
