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

    // Stored as text[] in DB; map as String containing JSON or CSV for simplicity
    @Column(name = "mandatory_course_codes", columnDefinition = "text[]")
    private String[] mandatoryCourseCodes;

    @Column(name = "allowed_electives", columnDefinition = "text[]")
    private String[] allowedElectives;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
