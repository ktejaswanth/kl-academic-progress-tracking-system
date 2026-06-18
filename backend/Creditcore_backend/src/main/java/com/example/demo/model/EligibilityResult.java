package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "eligibility_results")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EligibilityResult {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "student_id")
    private com.example.demo.model.User student;

    @Column(name = "snapshot_time")
    private LocalDateTime snapshotTime;

    @Column(name = "degree_eligible")
    private Boolean degreeEligible = false;

    @Column(name = "honors_eligible")
    private Boolean honorsEligible = false;

    @Column(name = "minor_eligible")
    private Boolean minorEligible = false;

    @Column(name = "double_major_eligible")
    private Boolean doubleMajorEligible = false;

    @Column(name = "specialization_eligible")
    private Boolean specializationEligible = false;

    @Column(columnDefinition = "jsonb")
    private String details;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
