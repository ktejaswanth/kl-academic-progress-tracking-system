package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateCourseRequest {
    private Long studentId;
    private String universityId;
    private String courseCode;
    private String courseName;
    private Integer credits;
    private String grade;
    private String semester;
    private String academicYear;
    private String ltps;
    private String sectionNo;
    private String status;
    private String category;
    private String courseType;
    private String bucketGroup;
    private String registerDate;
    private String completedDate;
}
