package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "exit_requirements_master")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExitRequirementMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "requirement_code", unique = true, nullable = false)
    private String requirementCode;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String category; // ACADEMIC, DEPARTMENT, ADMINISTRATIVE, CAREER_ALUMNI

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "responsible_role", nullable = false)
    private String responsibleRole; // SYSTEM_AUTO, FACULTY, SUPER_ADMIN

    @Column(name = "is_mandatory")
    private Boolean isMandatory = true;

    @Column(name = "display_order")
    private Integer displayOrder = 0;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
