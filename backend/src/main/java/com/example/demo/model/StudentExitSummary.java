package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "student_exit_summary")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentExitSummary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "student_id", unique = true, nullable = false)
    private Student student;

    @Column(name = "overall_status", nullable = false)
    private String overallStatus = "IN_PROGRESS"; // NOT_STARTED, IN_PROGRESS, PENDING_FINAL_APPROVAL, CLEARED_FOR_GRADUATION

    @Column(name = "total_requirements")
    private Integer totalRequirements = 0;

    @Column(name = "approved_count")
    private Integer approvedCount = 0;

    @Column(name = "clearance_percentage", precision = 5, scale = 2)
    private BigDecimal clearancePercentage = BigDecimal.ZERO;

    @Column(name = "certificate_token")
    private String certificateToken;

    @Column(name = "final_approved_by")
    private String finalApprovedBy;

    @Column(name = "final_approved_at")
    private LocalDateTime finalApprovedAt;

    @Column(name = "final_remarks", columnDefinition = "TEXT")
    private String finalRemarks;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
