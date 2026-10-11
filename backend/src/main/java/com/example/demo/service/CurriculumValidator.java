package com.example.demo.service;

import com.example.demo.dto.curriculum.CurriculumAnalysisResult;
import com.example.demo.dto.curriculum.ParsedCourse;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class CurriculumValidator {

    /**
     * Validates the AI-parsed curriculum data and returns a list of warnings/errors.
     * Returns an empty list if everything is valid.
     */
    public List<String> validate(CurriculumAnalysisResult result) {
        List<String> errors = new ArrayList<>();

        if (result == null) {
            errors.add("ERROR: Analysis result is null");
            return errors;
        }

        // Validate department
        if (result.getDepartment() == null || result.getDepartment().isBlank()) {
            errors.add("ERROR: Department is missing");
        }

        // Validate regulation
        if (result.getRegulation() == null || result.getRegulation().isBlank()) {
            errors.add("ERROR: Regulation is missing");
        }

        // Validate courses
        if (result.getCourses() == null || result.getCourses().isEmpty()) {
            errors.add("ERROR: No courses found in the curriculum");
        } else {
            validateCourses(result.getCourses(), errors);
        }

        // Validate degree types
        if (result.getDegreeTypes() == null || result.getDegreeTypes().isEmpty()) {
            errors.add("WARNING: No degree types found");
        }

        // Validate bucket requirements
        if (result.getBucketRequirements() == null || result.getBucketRequirements().isEmpty()) {
            errors.add("WARNING: No bucket requirements found");
        }

        // Validate degree paths
        if (result.getDegreePaths() == null || result.getDegreePaths().isEmpty()) {
            errors.add("WARNING: No degree paths found");
        }

        return errors;
    }

    private void validateCourses(List<ParsedCourse> courses, List<String> errors) {
        Set<String> seenCodes = new HashSet<>();
        int invalidCount = 0;

        for (int i = 0; i < courses.size(); i++) {
            ParsedCourse course = courses.get(i);

            // Check for missing course code
            if (course.getCourseCode() == null || course.getCourseCode().isBlank()) {
                errors.add("WARNING: Course #" + (i + 1) + " has no course code");
                invalidCount++;
                continue;
            }

            // Check for duplicates
            if (seenCodes.contains(course.getCourseCode())) {
                errors.add("WARNING: Duplicate course code: " + course.getCourseCode());
            }
            seenCodes.add(course.getCourseCode());

            // Check for missing course name
            if (course.getCourseName() == null || course.getCourseName().isBlank()) {
                errors.add("WARNING: Course " + course.getCourseCode() + " has no name");
            }

            // Check for invalid credits
            if (course.getCredits() == null || course.getCredits() <= 0) {
                errors.add("WARNING: Course " + course.getCourseCode() + " has invalid credits: " + course.getCredits());
            } else if (course.getCredits() > 12) {
                errors.add("WARNING: Course " + course.getCourseCode() + " has unusually high credits: " + course.getCredits());
            }

            // Check for missing bucket (sub-category)
            if (course.getSubCategory() == null || course.getSubCategory().isBlank()) {
                errors.add("WARNING: Course " + course.getCourseCode() + " has no bucket assignment (subCategory)");
            }
        }

        if (invalidCount > 0) {
            errors.add("INFO: " + invalidCount + " courses have missing course codes");
        }

        errors.add(0, "INFO: Total courses parsed: " + courses.size());
    }
}
