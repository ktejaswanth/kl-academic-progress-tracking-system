package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "student_bucket_progress",
       uniqueConstraints = @UniqueConstraint(columnNames = {"student_id", "bucket_id", "degree_path_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentBucketProgress {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "bucket_id", nullable = false)
    private BucketMaster bucket;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "degree_path_id", nullable = false)
    private DegreePath degreePath;

    @Column(name = "required_credits", nullable = false)
    private Integer requiredCredits;

    @Column(name = "earned_credits", nullable = false)
    private Integer earnedCredits = 0;

    @Column(name = "course_count", nullable = false)
    private Integer courseCount = 0;

    @Column(nullable = false)
    private String status = "PENDING";

    @Column(name = "last_calculated")
    private LocalDateTime lastCalculated = LocalDateTime.now();
}
