package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "degree_outcome_requirements")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DegreeOutcomeRequirement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "degree_path_id", nullable = false, unique = true)
    private DegreePath degreePath;

    @Column(name = "min_cgpa")
    private Double minCgpa = 0.0;

    @Column(name = "min_scopus_publications")
    private Integer minScopusPublications = 0;

    @Column(name = "min_design_patents")
    private Integer minDesignPatents = 0;

    @Column(name = "min_consultancy_projects")
    private Integer minConsultancyProjects = 0;

    @Column(name = "no_backlog_history")
    private Boolean noBacklogHistory = false;

    @Column(name = "no_betterment_history")
    private Boolean noBettermentHistory = false;

    @Column(name = "max_completion_years")
    private Integer maxCompletionYears = 4;

    @Column(columnDefinition = "TEXT")
    private String description;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
