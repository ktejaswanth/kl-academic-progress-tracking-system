package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "program_course_equivalences",
       uniqueConstraints = @UniqueConstraint(columnNames = {
               "source_curriculum_version_id",
               "target_curriculum_version_id",
               "source_course_code",
               "target_course_code"
       }))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramCourseEquivalence {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "source_curriculum_version_id", nullable = false)
    private CurriculumVersion sourceCurriculumVersion;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "target_curriculum_version_id", nullable = false)
    private CurriculumVersion targetCurriculumVersion;

    @Column(name = "source_course_code", nullable = false, length = 30)
    private String sourceCourseCode;

    @Column(name = "target_course_code", nullable = false, length = 30)
    private String targetCourseCode;

    @Column(nullable = false, length = 20)
    private String status = "APPROVED"; // PENDING, APPROVED, REJECTED

    @Column(name = "approved_by", length = 100)
    private String approvedBy;

    @Column(name = "approved_at")
    private LocalDateTime approvedAt;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
