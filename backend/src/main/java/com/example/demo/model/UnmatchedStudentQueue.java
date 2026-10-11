package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "unmatched_student_queue")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UnmatchedStudentQueue {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id")
    private Student student;

    @Column(name = "student_id_num", nullable = false, length = 50)
    private String studentIdNum;

    @Column(name = "student_name", length = 150)
    private String studentName;

    @Column(name = "raw_department", length = 100)
    private String rawDepartment;

    @Column(name = "raw_regulation", length = 50)
    private String rawRegulation;

    @Column(name = "issue_type", nullable = false, length = 50)
    private String issueType; // UNKNOWN_DEPARTMENT, MISSING_REGULATION, AMBIGUOUS_MAPPING, UNRESOLVED_PATH

    @Column(name = "error_message", nullable = false, columnDefinition = "TEXT")
    private String errorMessage;

    @Column(nullable = false, length = 20)
    private String status = "PENDING_REVIEW"; // PENDING_REVIEW, RESOLVED, DISMISSED

    @Column(name = "resolution_notes", columnDefinition = "TEXT")
    private String resolutionNotes;

    @Column(name = "resolved_by", length = 100)
    private String resolvedBy;

    @Column(name = "resolved_at")
    private LocalDateTime resolvedAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
