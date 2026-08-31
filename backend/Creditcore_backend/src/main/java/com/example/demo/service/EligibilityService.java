package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class EligibilityService {

    @Autowired
    private StudentSelectionRepository studentSelectionRepository;

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private ProgramRequirementRepository programRequirementRepository;

    @Autowired
    private EligibilityResultRepository eligibilityResultRepository;

    @Autowired
    private DegreeEligibilityEngine degreeEligibilityEngine;

    @Autowired
    private BucketSatisfactionEngine bucketSatisfactionEngine;

    @Autowired
    private StudentDegreePathRepository studentDegreePathRepository;

    @Autowired
    private DegreePathEngine degreePathEngine;

    @Autowired
    private CourseCatalogRepository courseCatalogRepository;

    @Autowired
    private CurriculumCourseRepository curriculumCourseRepository;

    public Map<String, Object> calculateEligibility(Long studentId) {
        // 1. Prefer modern DYOD DegreeEligibilityEngine if degree path exists or can be resolved
        try {
            Optional<StudentDegreePath> sdpOpt = studentDegreePathRepository.findByStudentId(studentId);
            if (sdpOpt.isEmpty()) {
                try {
                    degreePathEngine.resolveAndAssignPath(studentId);
                    sdpOpt = studentDegreePathRepository.findByStudentId(studentId);
                } catch (Exception ignored) {}
            }

            if (sdpOpt.isPresent()) {
                StudentDegreeStatus degreeStatus = degreeEligibilityEngine.evaluateEligibility(studentId);
                List<Map<String, Object>> bucketDetails = bucketSatisfactionEngine.getDetailedBucketProgress(studentId);

                Map<String, Object> result = new LinkedHashMap<>();
                result.put("degreeEligible", degreeStatus.getIsDegreeEligible());
                result.put("status", degreeStatus.getStatus());
                result.put("completionPercentage", degreeStatus.getCompletionPercentage());
                result.put("totalRequiredCredits", degreeStatus.getTotalRequiredCredits());
                result.put("totalEarnedCredits", degreeStatus.getTotalEarnedCredits());
                result.put("bucketsCompleted", degreeStatus.getBucketsCompleted());
                result.put("bucketsTotal", degreeStatus.getBucketsTotal());
                result.put("degreePathCode", degreeStatus.getDegreePath() != null ? degreeStatus.getDegreePath().getPathCode() : "N/A");
                result.put("bucketDetails", bucketDetails);

                // Backward compatible boolean flags
                String typeCode = degreeStatus.getDegreePath() != null && degreeStatus.getDegreePath().getDegreeType() != null 
                        ? degreeStatus.getDegreePath().getDegreeType().getTypeCode() : "REGULAR";
                String addonCode = degreeStatus.getDegreePath() != null && degreeStatus.getDegreePath().getAddonType() != null 
                        ? degreeStatus.getDegreePath().getAddonType().getAddonCode() : "NONE";

                result.put("honorsEligible", !"REGULAR".equalsIgnoreCase(typeCode) && degreeStatus.getIsDegreeEligible());
                result.put("specializationEligible", "SPECIALIZATION".equalsIgnoreCase(addonCode) && degreeStatus.getIsDegreeEligible());
                result.put("minorEligible", "MINOR".equalsIgnoreCase(addonCode) && degreeStatus.getIsDegreeEligible());
                result.put("doubleMajorEligible", "DOUBLE_MAJOR".equalsIgnoreCase(addonCode) && degreeStatus.getIsDegreeEligible());
                result.put("completed", degreeStatus.getIsDegreeEligible());

                return result;
            }
        } catch (Exception e) {
            // Fallback to legacy calculation below
        }

        // 2. Legacy fallback calculation
        Optional<StudentSelection> selectionOpt = studentSelectionRepository.findByStudentId(studentId);
        if (selectionOpt.isEmpty()) {
            Map<String, Object> emptyResult = new LinkedHashMap<>();
            emptyResult.put("degreeEligible", false);
            emptyResult.put("status", "NOT_ASSIGNED");
            emptyResult.put("message", "No degree path assigned for student.");
            return emptyResult;
        }

        StudentSelection selection = selectionOpt.get();
        List<CompletedCourse> completed = completedCourseRepository.findByStudentId(studentId);
        List<ProgramRequirement> requirements = selection.getCurriculumVersion() != null 
                ? programRequirementRepository.findByCurriculumVersionId(selection.getCurriculumVersion().getId())
                : Collections.emptyList();

        Map<String, Object> result = new HashMap<>();
        int totalRequiredCredits = requirements.stream().mapToInt(ProgramRequirement::getRequiredCredits).sum();
        int totalCompletedCredits = completed.stream()
                .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                .mapToInt(CompletedCourse::getCredits)
                .sum();

        List<String> missingCoreCourses = new ArrayList<>();
        List<String> missingFlexiCoreCourses = new ArrayList<>();
        List<String> missingElectives = new ArrayList<>();
        List<String> missingHonors = new ArrayList<>();

        boolean degreeEligible = true;
        boolean honorsEligible = true;
        boolean specializationEligible = true;
        boolean minorEligible = true;
        boolean doubleMajorEligible = true;

        Set<String> completedCodes = completed.stream()
                .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                .map(CompletedCourse::getCourseCode)
                .collect(Collectors.toSet());

        for (ProgramRequirement requirement : requirements) {
            List<String> mandatory = parseJsonArray(requirement.getMandatoryCourseCodes());
            if (mandatory != null && !mandatory.isEmpty()) {
                for (String code : mandatory) {
                    if (!completedCodes.contains(code)) {
                        if (requirement.getBucketName().toLowerCase().contains("core")) {
                            missingCoreCourses.add(code);
                        } else if (requirement.getBucketName().toLowerCase().contains("flexi")) {
                            missingFlexiCoreCourses.add(code);
                        } else if (requirement.getBucketName().toLowerCase().contains("honors")) {
                            missingHonors.add(code);
                        } else {
                            missingElectives.add(code);
                        }
                    }
                }
            }
            if (requirement.getRequiredCredits() > completedCreditsInBucket(requirement, completed)) {
                degreeEligible = false;
                if (requirement.getBucketName().toLowerCase().contains("honors")) {
                    honorsEligible = false;
                }
                if (requirement.getBucketName().toLowerCase().contains("specialization")) {
                    specializationEligible = false;
                }
                if (requirement.getBucketName().toLowerCase().contains("minor")) {
                    minorEligible = false;
                }
                if (requirement.getBucketName().toLowerCase().contains("double")) {
                    doubleMajorEligible = false;
                }
            }
        }

        boolean creditsEnough = totalCompletedCredits >= totalRequiredCredits;
        if (!creditsEnough) {
            degreeEligible = false;
        }

        Map<String, Object> details = new HashMap<>();
        details.put("completedCredits", totalCompletedCredits);
        details.put("requiredCredits", totalRequiredCredits);
        details.put("missingCoreCourses", missingCoreCourses);
        details.put("missingFlexiCoreCourses", missingFlexiCoreCourses);
        details.put("missingElectives", missingElectives);
        details.put("missingHonors", missingHonors);
        details.put("creditsEnough", creditsEnough);

        List<Map<String, Object>> missingCourseList = buildCourseList(missingCoreCourses, "Core");
        missingCourseList.addAll(buildCourseList(missingFlexiCoreCourses, "Flexi Core"));
        missingCourseList.addAll(buildCourseList(missingElectives, "Elective"));
        missingCourseList.addAll(buildCourseList(missingHonors, "Honors"));

        List<Map<String, Object>> suggestedCourses = missingCourseList.stream()
                .limit(5)
                .collect(Collectors.toList());

        result.put("degreeEligible", degreeEligible);
        result.put("honorsEligible", honorsEligible);
        result.put("specializationEligible", specializationEligible);
        result.put("minorEligible", minorEligible);
        result.put("doubleMajorEligible", doubleMajorEligible);
        result.put("completed", degreeEligible);
        result.put("missingCourseCount", missingCourseList.size());
        result.put("missingCourses", missingCourseList);
        result.put("suggestedCourses", suggestedCourses);
        result.put("details", details);

        EligibilityResult snapshot = new EligibilityResult();
        snapshot.setStudent(selection.getStudent());
        snapshot.setSnapshotTime(LocalDateTime.now());
        snapshot.setDegreeEligible(degreeEligible);
        snapshot.setHonorsEligible(honorsEligible);
        snapshot.setMinorEligible(minorEligible);
        snapshot.setDoubleMajorEligible(doubleMajorEligible);
        snapshot.setSpecializationEligible(specializationEligible);
        snapshot.setDetails(toJson(details));
        eligibilityResultRepository.save(snapshot);

        return result;
    }

    private List<Map<String, Object>> buildCourseList(List<String> courseCodes, String category) {
        return courseCodes.stream()
                .map(code -> {
                    Map<String, Object> courseInfo = new HashMap<>();
                    courseInfo.put("courseCode", code);
                    courseInfo.put("category", category);
                    courseCatalogRepository.findByCourseCode(code)
                            .ifPresent(catalog -> {
                                courseInfo.put("courseName", catalog.getCourseName());
                                courseInfo.put("courseId", catalog.getId());
                            });
                    if (!courseInfo.containsKey("courseName")) {
                        courseInfo.put("courseName", "TBD");
                        courseInfo.put("courseId", null);
                    }
                    return courseInfo;
                })
                .collect(Collectors.toList());
    }

    public List<Map<String, Object>> generateRoadmap(Long studentId) {
        StudentSelection selection = studentSelectionRepository.findByStudentId(studentId)
                .orElseThrow(() -> new RuntimeException("Student selection not found"));

        List<CompletedCourse> completed = completedCourseRepository.findByStudentId(studentId);
        Set<String> completedCodes = completed.stream()
                .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                .map(CompletedCourse::getCourseCode)
                .collect(Collectors.toSet());

        List<CurriculumCourse> curriculumCourses = new ArrayList<>();
        if (selection.getCurriculumVersion() != null) {
            curriculumCourses = studentSelectionRepository.findByStudentId(studentId)
                    .map(sel -> curriculumCourseRepository.findByCurriculumVersionId(sel.getCurriculumVersion().getId()))
                    .orElseGet(ArrayList::new);
        }

        List<CurriculumCourse> remainingCourses = curriculumCourses.stream()
                .filter(course -> course.getCourse() != null && !completedCodes.contains(course.getCourse().getCourseCode()))
                .sorted(Comparator.comparingInt(c -> c.getMinYear() != null ? c.getMinYear() : Integer.MAX_VALUE))
                .collect(Collectors.toList());

        Map<String, List<Map<String, Object>>> roadmap = new LinkedHashMap<>();
        for (CurriculumCourse course : remainingCourses) {
            String term = "Year " + (course.getMinYear() != null ? course.getMinYear() : 1);
            Map<String, Object> courseInfo = new HashMap<>();
            courseInfo.put("courseId", course.getCourse().getId());
            courseInfo.put("courseCode", course.getCourse().getCourseCode());
            courseInfo.put("courseName", course.getCourse().getCourseName());
            courseInfo.put("bucket", course.getBucketName());
            roadmap.computeIfAbsent(term, key -> new ArrayList<>()).add(courseInfo);
        }

        return roadmap.entrySet().stream()
                .map(entry -> {
                    Map<String, Object> termPlan = new HashMap<>();
                    termPlan.put("term", entry.getKey());
                    termPlan.put("courses", entry.getValue());
                    return termPlan;
                })
                .collect(Collectors.toList());
    }

    private String toJson(Object object) {
        try {
            return new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(object);
        } catch (Exception e) {
            return "{}";
        }
    }

    private List<String> parseJsonArray(String[] jsonArray) {
        if (jsonArray == null) {
            return List.of();
        }
        return Arrays.asList(jsonArray);
    }

    private int completedCreditsInBucket(ProgramRequirement requirement, List<CompletedCourse> completed) {
        List<String> mandatory = parseJsonArray(requirement.getMandatoryCourseCodes());
        if (mandatory == null || mandatory.isEmpty()) {
            return completed.stream()
                    .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                    .mapToInt(CompletedCourse::getCredits)
                    .sum();
        }
        return completed.stream()
                .filter(c -> c.getStatus() == null || !c.getStatus().equalsIgnoreCase("On-Progress"))
                .filter(c -> mandatory.contains(c.getCourseCode()))
                .mapToInt(CompletedCourse::getCredits)
                .sum();
    }
}
