package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "program_requirements")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramRequirement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @Column(name = "bucket_name", nullable = false)
    private String bucketName;

    @Column(name = "required_credits", nullable = false)
    private Integer requiredCredits;

    @org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.ARRAY)
    @Column(name = "mandatory_course_codes")
    private String[] mandatoryCourseCodes;

    @org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.ARRAY)
    @Column(name = "allowed_electives")
    private String[] allowedElectives;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
