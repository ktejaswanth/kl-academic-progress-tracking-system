package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_import_specialization_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumImportSpecializationCourse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "import_id", nullable = false)
    private CurriculumImport importRecord;

    @Column(name = "specialization_code")
    private String specializationCode;

    @Column(name = "course_code")
    private String courseCode;

    private String role; // PE-1..5, SDC, SDP

    @Column(name = "sequence_no")
    private Integer sequenceNo = 1;

    @Column(name = "source_page")
    private Integer sourcePage;

    @Column(name = "source_section")
    private String sourceSection;

    private Double confidence = 1.0;

    @Column(name = "validation_status")
    private String validationStatus = "VALID";

    @Column(name = "error_message", columnDefinition = "text")
    private String errorMessage;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
