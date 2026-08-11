package com.example.demo.dto.curriculum;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParsedBucketRequirement {
    private String bucketCode;
    private String bucketName;
    private String bucketCategory;
    private Integer minCredits;
    private Integer maxCredits;
    private Integer minCourses;
    private Integer maxCourses;
    private String degreeType;
}
