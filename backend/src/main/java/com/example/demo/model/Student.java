package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "students")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "student_id", unique = true, nullable = false)
    private String studentId;

    @Column(name = "academic_year")
    private String academicYear;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Column(name = "date_of_birth")
    private java.time.LocalDate dateOfBirth;

    @Column(unique = true, nullable = false)
    private String email;

    public String getName() {
        return ((firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "")).trim();
    }

    @Column(nullable = false)
    private String password;

    @Column(name = "raw_password")
    private String rawPassword;

    @Column(name = "is_active")
    private Boolean isActive = true;

    private String department;

    @Column(name = "sub_department")
    private String subDepartment;

    @Column(name = "specialization_type")
    private String specializationType = "NONE";

    @Column(name = "specialization_name")
    private String specializationName;

    @Column(name = "first_login_completed")
    private Boolean firstLoginCompleted = false;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
