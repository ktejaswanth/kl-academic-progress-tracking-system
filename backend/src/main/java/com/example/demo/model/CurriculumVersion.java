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

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "program_id")
    private DegreeProgram program;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "department_id")
    private DepartmentMaster department;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "regulation_id")
    private RegulationMaster regulationMaster;

    @Column(name = "curriculum_code")
    private String curriculumCode;

    @Column(name = "version_name", nullable = false)
    private String versionName;

    @Column(name = "program_name")
    private String programName;

    private String regulation;

    private String status = "ACTIVE";

    @Column(name = "source_file")
    private String sourceFile;

    @Column(name = "source_hash")
    private String sourceHash;

    @Column(name = "effective_from")
    private LocalDate effectiveFrom;

    @Column(name = "effective_to")
    private LocalDate effectiveTo;

    @Column(name = "academic_year")
    private String academicYear;

    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
