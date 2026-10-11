package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudentCourseDTO {
    private Long id;
    private Long studentId;
    private String rollNumber;
    private String courseCode;
    private String courseName;
    private String category; // HAS, BSC, ESC, FCC, PCC, PEC, SDC, PRI, OEC, SIL
    private Double credits;
    private Double obtainedCredits;
    private String semester;
    private String academicYear;
    private String attempt1;
    private String attempt2;
    private String attempt3;
    private String grade;
    private String status; // COMPLETED, IN_PROGRESS, FAILED, DROPPED
    private Boolean isQualifying;
    private String completedDate;
    private String source;
}
