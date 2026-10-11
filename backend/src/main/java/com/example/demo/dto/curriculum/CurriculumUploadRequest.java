package com.example.demo.dto.curriculum;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurriculumUploadRequest {
    private String curriculumName;
    private String department;
    private String regulation;
    private String academicYear;
}
