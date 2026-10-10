package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_import_errors")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumImportError {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "import_id", nullable = false)
    private CurriculumImport importRecord;

    @Column(name = "entity_type")
    private String entityType;

    @Column(name = "field_name")
    private String fieldName;

    @Column(name = "raw_value", columnDefinition = "text")
    private String rawValue;

    @Column(name = "error_severity")
    private String errorSeverity = "ERROR";

    @Column(name = "error_message", columnDefinition = "text", nullable = false)
    private String errorMessage;

    @Column(name = "source_page")
    private Integer sourcePage;

    @Column(name = "source_section")
    private String sourceSection;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
