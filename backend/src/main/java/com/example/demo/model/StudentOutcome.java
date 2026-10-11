package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "student_outcomes")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentOutcome {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "student_id", nullable = false, unique = true)
    private Student student;

    private Double cgpa = 0.0;

    @Column(name = "scopus_publications")
    private Integer scopusPublications = 0;

    @Column(name = "design_patents")
    private Integer designPatents = 0;

    @Column(name = "consultancy_projects")
    private Integer consultancyProjects = 0;

    @Column(name = "has_backlog_history")
    private Boolean hasBacklogHistory = false;

    @Column(name = "has_betterment_history")
    private Boolean hasBettermentHistory = false;

    @Column(name = "completion_years")
    private Integer completionYears = 4;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();
}
