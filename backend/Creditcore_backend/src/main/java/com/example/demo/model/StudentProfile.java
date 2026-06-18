package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "student_profiles")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id", unique = true)
    private User user;

    @Column(name = "degree_type", nullable = false)
    private String degreeType;

    private String specialization;

    @Column(name = "honors_type")
    private String honorsType;

    private String branch;

    private Integer batch;

    private String section;

    @Column(name = "honors_option")
    private String honorsOption;

    @Column(name = "extension_type")
    private String extensionType;

    @Column(name = "current_year")
    private Integer currentYear = 1;

    @Column(name = "admission_year")
    private Integer admissionYear;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
