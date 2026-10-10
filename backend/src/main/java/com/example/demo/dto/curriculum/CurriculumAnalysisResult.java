package com.example.demo.dto.curriculum;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumAnalysisResult {
    private String department;
    private String departmentFullName;
    private String regulation;
    private String programName;
    private List<String> degreeTypes;
    private List<String> addonTypes;
    private List<ParsedCourse> courses;
    private List<ParsedBucketRequirement> bucketRequirements;
    private List<ParsedDegreePath> degreePaths;
    private List<String> specializations;
    private List<String> minors;
    private List<String> doubleMajors;
}
