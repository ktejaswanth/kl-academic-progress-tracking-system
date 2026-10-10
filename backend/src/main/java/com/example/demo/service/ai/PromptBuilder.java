package com.example.demo.service.ai;

import org.springframework.stereotype.Component;

@Component
public class PromptBuilder {

    /**
     * Builds the system prompt that instructs Gemini how to parse curriculum text.
     */
    public String buildSystemPrompt() {
        return """
            You are an expert academic curriculum parser for Indian universities.
            You will receive extracted text from a university curriculum PDF handbook.
            Your task is to parse the curriculum structure and return ONLY valid JSON.
            
            IMPORTANT RULES:
            1. Return ONLY a JSON object. No markdown fences, no explanations, no comments.
            2. Course names may span multiple lines in the source text — join them into a single string.
            3. The course table format is typically:
               S# Cat Sub-Cat CourseCode CourseName Mode Acronym L T P S CR CH Pre-req
            4. Credits (CR) = L + T + (P * 0.5) + (S * 0.25) approximately.
            5. Contact Hours (CH) = L + T + P + S.
            6. Bucket codes follow patterns like: HAS-CORE, BSC-ME-1, PCC-CORE, FCC, HFC-CORE, etc.
            7. Degree types are: REGULAR, HONORS, HTE (Honors through Experiential Learning), HTI (Honors through Innovation), HTR (Honors through Research).
            8. Addon types are: NONE, SPECIALIZATION, MINOR, DOUBLE_MAJOR.
            9. Look for "Credit Requirement" and "Design your own Degree" sections for bucket requirements.
            10. Look for "Program Structure" sections for course listings.
            """;
    }

    /**
     * Builds the user prompt with the extracted text and JSON schema.
     */
    public String buildUserPrompt(String extractedText, String department, String regulation) {
        // Truncate if too long for the API (keep first 500000 chars for the structured course data)
        String truncatedText = extractedText;
        if (extractedText.length() > 500000) {
            truncatedText = extractedText.substring(0, 500000);
        }

        return """
            Parse the following curriculum text for department: %1$s, regulation: %2$s.
            
            Extract ALL information and return it as a JSON object with this exact structure:
            
            {
              "department": "department code like CSE or AIDS",
              "departmentFullName": "full department name",
              "regulation": "regulation code like Y23",
              "programName": "full program name like B.Tech. - Computer Science and Engineering",
              "degreeTypes": ["REGULAR", "HONORS", "HTE", "HTI", "HTR"],
              "addonTypes": ["SPECIALIZATION", "MINOR", "DOUBLE_MAJOR"],
              "courses": [
                {
                  "courseCode": "23CS2104R",
                  "courseName": "Operating Systems",
                  "credits": 4,
                  "category": "PCC",
                  "subCategory": "PCC-CORE",
                  "lectureHours": 3,
                  "tutorialHours": 0,
                  "practicalHours": 2,
                  "skillHours": 0,
                  "contactHours": 5,
                  "mode": "R",
                  "acronym": "OS",
                  "isMandatory": true,
                  "prerequisite": null
                }
              ],
              "bucketRequirements": [
                {
                  "bucketCode": "PCC-CORE",
                  "bucketName": "Professional Core Courses",
                  "bucketCategory": "Professional Core",
                  "minCredits": 56,
                  "maxCredits": 56,
                  "minCourses": 14,
                  "maxCourses": 14,
                  "degreeType": "REGULAR"
                }
              ],
              "degreePaths": [
                {
                  "degreeType": "REGULAR",
                  "addonType": "NONE",
                  "addonName": null,
                  "totalCredits": 163
                },
                {
                  "degreeType": "HTE",
                  "addonType": "SPECIALIZATION",
                  "addonName": null,
                  "totalCredits": 193
                }
              ],
              "specializations": ["Data Science", "Cyber Security", "AI and ML"],
              "minors": ["CSE Minor", "Data Science Minor"],
              "doubleMajors": ["CSE Double Major"]
            }
            
            CRITICAL INSTRUCTIONS:
            - Parse ONLY the courses that belong to the core and elective Program Structure of the %1$s department (Artificial Intelligence & Data Science if %1$s is AIDS).
            - Do NOT parse the entire general university course catalog (which contains thousands of electives from other branches like EEE, ECE, Civil, Mechanical, Biotech, etc. that do not belong to the %1$s core structure).
            - Limit the total extracted courses list to the main 80-120 courses relevant to the %1$s program.
            - For multi-line course names, join them: if a course code appears on line N and the
              next line(s) contain only text without another course code, that text is part of the
              course name on line N.
            - The "Sub-Cat" column contains the bucket code (e.g., HAS-CORE, BSC-ME-1, PCC-CORE).
            - The "Cat" column contains the category abbreviation (e.g., HAS, BSC, ESC, PCC).
            - mode "R" = Regular, "A" = Advanced, "E" = Experiential, "M" = MOOCs, "W" = Work-in-lieu.
            - Parse bucket requirements from "Credit Requirement" tables.
              These tables have columns like: S# Category Sub-Category Min-Credit Max-Credit Min-Courses Max-Courses.
            - Parse degree paths from "Design your own Degree" sections with total credit requirements.
            - If specializations, minors, or double major options are listed, extract their names.
            - Return ONLY the JSON object, nothing else.
            
            CURRICULUM TEXT:
            %3$s
            """.formatted(department, regulation, truncatedText);
    }
}
