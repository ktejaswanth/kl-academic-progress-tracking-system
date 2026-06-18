package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_versions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumVersion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "program_id")
    private DegreeProgram program;

    @Column(name = "version_name", nullable = false)
    private String versionName;

    private String regulation;

    @Column(name = "effective_from")
    private LocalDate effectiveFrom;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
