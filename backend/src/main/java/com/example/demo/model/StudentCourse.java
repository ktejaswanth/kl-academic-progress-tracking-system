package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "student_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentCourse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @Column(name = "university_id", nullable = false)
    private String universityId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_version_id")
    private CurriculumVersion curriculumVersion;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "course_id")
    private CourseCatalog course;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "curriculum_course_id")
    private CurriculumCourse curriculumCourse;

    @Column(name = "course_code", nullable = false)
    private String courseCode;

    @Column(name = "course_name")
    private String courseName;

    private Double credits = 0.0;

    private String grade;

    private String status = "COMPLETED";

    private String semester;

    @Column(name = "academic_year")
    private String academicYear;

    @Column(name = "completed_date")
    private LocalDate completedDate;

    @Column(name = "upload_id")
    private Long uploadId;

    @Column(name = "source_row")
    private Integer sourceRow;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
