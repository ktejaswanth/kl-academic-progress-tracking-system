package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "minor_programs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MinorProgram {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "program_id")
    private DegreeProgram program;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @Column(nullable = false)
    private String code;

    @Column(nullable = false)
    private String name;

    private String description;

    @Column(name = "credits_required", nullable = false)
    private Integer creditsRequired = 18;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
