package com.example.demo.dto.curriculum;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParsedCourse {
    private String courseCode;
    private String courseName;
    private Double credits;
    private String category;
    private String subCategory;
    private Integer lectureHours;
    private Integer tutorialHours;
    private Integer practicalHours;
    private Integer skillHours;
    private Integer contactHours;
    private String mode;
    private String acronym;
    private Boolean isMandatory;
    private String prerequisite;
}
