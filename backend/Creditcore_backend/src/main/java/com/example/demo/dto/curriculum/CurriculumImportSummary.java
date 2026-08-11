package com.example.demo.dto.curriculum;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumImportSummary {
    private Long id;
    private String curriculumName;
    private String department;
    private String regulation;
    private String academicYear;
    private String pdfFileName;
    private String status;
    private Integer coursesFound;
    private Integer bucketsFound;
    private Integer degreeTypesFound;
    private Integer specializationsFound;
    private Integer minorsFound;
    private Integer doubleMajorsFound;
    private List<String> validationErrors;
    private LocalDateTime createdAt;
    private LocalDateTime analyzedAt;
    private LocalDateTime approvedAt;
    private String approvedBy;
}
