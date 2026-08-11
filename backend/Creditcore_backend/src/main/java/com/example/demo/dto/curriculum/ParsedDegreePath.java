package com.example.demo.dto.curriculum;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParsedDegreePath {
    private String degreeType;
    private String addonType;
    private String addonName;
    private Integer totalCredits;
}
