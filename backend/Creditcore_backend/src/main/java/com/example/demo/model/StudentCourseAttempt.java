package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "student_course_attempts")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentCourseAttempt {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(name = "university_id", nullable = false)
    private String universityId;

    @Column(name = "course_code", nullable = false)
    private String courseCode;

    @Column(name = "attempt_number")
    private Integer attemptNumber = 1;

    private String grade;

    @Column(name = "grade_points")
    private Double gradePoints = 0.0;

    @Column(nullable = false)
    private String status; // REGISTERED, IN_PROGRESS, COMPLETED, FAILED, DT, WITHDRAWN

    private String semester;

    @Column(name = "academic_year")
    private String academicYear;

    @Column(name = "is_qualifying")
    private Boolean isQualifying = false;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
