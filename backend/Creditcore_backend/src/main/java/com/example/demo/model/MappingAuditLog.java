package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "mapping_audit_logs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MappingAuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id")
    private Student student;

    @Column(name = "student_id_num", length = 50)
    private String studentIdNum;

    @Column(nullable = false, length = 50)
    private String action; // MANUAL_CURRICULUM_ASSIGNMENT, DEPARTMENT_CORRECTION, EQUIVALENCE_APPROVED

    @Column(name = "changed_by", nullable = false, length = 100)
    private String changedBy;

    @Column(name = "previous_value", columnDefinition = "TEXT")
    private String previousValue;

    @Column(name = "new_value", columnDefinition = "TEXT")
    private String newValue;

    @Column(columnDefinition = "TEXT")
    private String reason;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
