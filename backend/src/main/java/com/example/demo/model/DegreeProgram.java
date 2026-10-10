package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "degree_programs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DegreeProgram {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String code;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String branch;

    @Column(name = "batch_start", nullable = false)
    private Integer batchStart;

    @Column(name = "batch_end")
    private Integer batchEnd;

    private String regulation;

    @Column(name = "duration_years")
    private Integer durationYears = 4;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
