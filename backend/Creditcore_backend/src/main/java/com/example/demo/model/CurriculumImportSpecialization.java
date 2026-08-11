package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_import_specializations")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumImportSpecialization {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "import_id", nullable = false)
    private CurriculumImport importRecord;

    private String code;

    private String name;

    private String description;

    @Column(name = "source_page")
    private Integer sourcePage;

    @Column(name = "source_section")
    private String sourceSection;

    @Column(name = "raw_value", columnDefinition = "text")
    private String rawValue;

    @Column(name = "parsed_value", columnDefinition = "text")
    private String parsedValue;

    private Double confidence = 1.0;

    @Column(name = "validation_status")
    private String validationStatus = "VALID";

    @Column(name = "error_message", columnDefinition = "text")
    private String errorMessage;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
