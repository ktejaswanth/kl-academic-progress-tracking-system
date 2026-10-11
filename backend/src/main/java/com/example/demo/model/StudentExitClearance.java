package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "student_exit_clearances", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"student_id", "requirement_id"})
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentExitClearance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "requirement_id", nullable = false)
    private ExitRequirementMaster requirement;

    @Column(nullable = false)
    private String status = "PENDING"; // PENDING, SUBMITTED, IN_REVIEW, APPROVED, REJECTED, WAIVED

    @Column(name = "submission_notes", columnDefinition = "TEXT")
    private String submissionNotes;

    @Column(name = "attachment_url")
    private String attachmentUrl;

    @Column(name = "verified_by")
    private String verifiedBy;

    @Column(name = "verifier_role")
    private String verifierRole; // FACULTY, SUPER_ADMIN, SYSTEM

    @Column(name = "verified_at")
    private LocalDateTime verifiedAt;

    @Column(columnDefinition = "TEXT")
    private String remarks;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
