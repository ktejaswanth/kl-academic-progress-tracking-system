package com.example.demo.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "degree_paths")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DegreePath {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "path_code", unique = true, nullable = false)
    private String pathCode;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "department_id")
    private DepartmentMaster department;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "degree_type_id")
    private DegreeTypeMaster degreeType;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "addon_type_id")
    private AddonTypeMaster addonType;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "regulation_id")
    private RegulationMaster regulation;

    @Column(name = "addon_name")
    private String addonName;

    @Column(name = "total_credits", nullable = false)
    private Integer totalCredits = 0;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
