package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "student_selections")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentSelection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "student_id", unique = true)
    private com.example.demo.model.User student;

    @ManyToOne
    @JoinColumn(name = "program_id")
    private DegreeProgram program;

    @ManyToOne
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @ManyToOne
    @JoinColumn(name = "honors_program_id")
    private HonorsProgram honorsProgram;

    @ManyToOne
    @JoinColumn(name = "specialization_id")
    private Specialization specialization;

    @org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.ARRAY)
    @Column(name = "minor_program_ids")
    private Long[] minorProgramIds;

    @org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.ARRAY)
    @Column(name = "double_major_ids")
    private Long[] doubleMajorIds;

    @Column(name = "extension_type")
    private String extensionType;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
