package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "student_degree_status")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentDegreeStatus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "student_id", unique = true, nullable = false)
    private User student;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "degree_path_id")
    private DegreePath degreePath;

    @Column(name = "total_required_credits")
    private Integer totalRequiredCredits;

    @Column(name = "total_earned_credits")
    private Integer totalEarnedCredits = 0;

    @Column(name = "completion_percentage")
    private BigDecimal completionPercentage = BigDecimal.ZERO;

    @Column(name = "buckets_completed")
    private Integer bucketsCompleted = 0;

    @Column(name = "buckets_total")
    private Integer bucketsTotal = 0;

    @Column(name = "is_degree_eligible")
    private Boolean isDegreeEligible = false;

    @Column(nullable = false)
    private String status = "IN_PROGRESS";

    @Column(name = "last_evaluated")
    private LocalDateTime lastEvaluated = LocalDateTime.now();

    @org.hibernate.annotations.JdbcTypeCode(org.hibernate.type.SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private String details;
}
