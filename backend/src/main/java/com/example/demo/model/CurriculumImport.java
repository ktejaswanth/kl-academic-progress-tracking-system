package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_imports")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumImport {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "curriculum_name", nullable = false)
    private String curriculumName;

    @Column(nullable = false)
    private String department;

    @Column(nullable = false)
    private String regulation;

    @Column(name = "academic_year")
    private String academicYear;

    @Column(name = "pdf_file_name")
    private String pdfFileName;

    @Column(nullable = false)
    private String status = "UPLOADED";

    @Column(name = "source_hash")
    private String sourceHash;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @Column(name = "extracted_text", columnDefinition = "text")
    private String extractedText;

    @Column(name = "ai_analysis_json", columnDefinition = "text")
    private String aiAnalysisJson;

    @Column(name = "validation_errors", columnDefinition = "text")
    private String validationErrors;

    @Column(name = "courses_found")
    private Integer coursesFound;

    @Column(name = "buckets_found")
    private Integer bucketsFound;

    @Column(name = "degree_types_found")
    private Integer degreeTypesFound;

    @Column(name = "specializations_found")
    private Integer specializationsFound;

    @Column(name = "minors_found")
    private Integer minorsFound;

    @Column(name = "double_majors_found")
    private Integer doubleMajorsFound;

    @Column(name = "analyzed_at")
    private LocalDateTime analyzedAt;

    @Column(name = "approved_at")
    private LocalDateTime approvedAt;

    @Column(name = "approved_by")
    private String approvedBy;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
