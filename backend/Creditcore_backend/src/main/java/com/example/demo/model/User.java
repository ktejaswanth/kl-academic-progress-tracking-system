package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(unique = true, nullable = false)
    private String email;

    @com.fasterxml.jackson.annotation.JsonIgnore
    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Transient
    @com.fasterxml.jackson.annotation.JsonProperty(access = com.fasterxml.jackson.annotation.JsonProperty.Access.WRITE_ONLY)
    private String password;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserRole role;

    private String department;

    @Column(name = "sub_department")
    private String subDepartment;

    @Column(name = "specialization_type")
    private String specializationType = "NONE";

    @Column(name = "specialization_name")
    private String specializationName;

    @Column(name = "emp_id")
    private String empId;

    @Column(name = "academic_year")
    private String academicYear;

    private String designation;

    @Column(name = "cabin_no")
    private String cabinNo;

    @Column(name = "contact_no")
    private String contactNo;

    @com.fasterxml.jackson.annotation.JsonIgnore
    @Column(name = "raw_password")
    private String rawPassword;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "first_login_completed")
    private Boolean firstLoginCompleted = false;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "force_password_change")
    private Boolean forcePasswordChange = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
