package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "regulation_master")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RegulationMaster {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "reg_code", unique = true, nullable = false)
    private String regCode;

    @Column(name = "reg_name", nullable = false)
    private String regName;

    @Column(name = "effective_year")
    private Integer effectiveYear;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
