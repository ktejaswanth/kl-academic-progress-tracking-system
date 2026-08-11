package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "curriculum_import_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumImportCourse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "import_id", nullable = false)
    private CurriculumImport importRecord;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_name")
    private String courseName;

    private Double credits;

    private String category;

    private String subcategory;

    @Column(name = "lecture_hours")
    private Integer lectureHours = 0;

    @Column(name = "tutorial_hours")
    private Integer tutorialHours = 0;

    @Column(name = "practical_hours")
    private Integer practicalHours = 0;

    @Column(name = "skill_hours")
    private Integer skillHours = 0;

    @Column(name = "contact_hours")
    private Integer contactHours = 0;

    private String mode;

    private String acronym;

    @Column(name = "is_mandatory")
    private Boolean isMandatory = false;

    private String prerequisite;

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
