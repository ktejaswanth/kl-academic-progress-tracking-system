package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "completed_courses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CompletedCourse {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    private User student;

    @Column(name = "course_code", nullable = false)
    private String courseCode;

    @Column(name = "course_name", nullable = false)
    private String courseName;

    @Column(nullable = false)
    private Integer credits;

    private String grade;

    private String semester;

    private String ltps;

    @Column(name = "bucket_group")
    private String bucketGroup;

    @Column(name = "course_type")
    private String courseType;

    @Column(name = "academic_year")
    private String academicYear;

    @Column(name = "study_year")
    private Integer studyYear;

    @Column(name = "section_no")
    private String sectionNo;

    @Column(name = "course_ref")
    private String courseRef;

    @Column(name = "offer_to")
    private String offerTo;

    @Column(name = "offer_by")
    private String offerBy;

    private String branch;

    @Column(name = "register_date")
    private LocalDate registerDate;

    @Column(name = "completed_date")
    private LocalDate completedDate;

    @ManyToOne
    @JoinColumn(name = "verified_by", referencedColumnName = "id")
    private User verifiedBy;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
