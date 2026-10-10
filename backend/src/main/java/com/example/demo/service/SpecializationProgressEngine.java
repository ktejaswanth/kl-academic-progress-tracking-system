package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional(readOnly = true)
public class SpecializationProgressEngine {

    @Autowired private SpecializationRepository specializationRepo;
    @Autowired private SpecializationCourseRepository specializationCourseRepo;
    @Autowired private StudentCourseRepository studentCourseRepo;
    @Autowired private CompletedCourseRepository completedCourseRepo;

    public Map<String, Object> calculateSpecializationProgress(Long studentId, Long specializationId) {
        Map<String, Object> result = new LinkedHashMap<>();

        if (specializationId == null) {
            result.put("status", "NOT_APPLICABLE");
            return result;
        }

        Optional<Specialization> specOpt = specializationRepo.findById(specializationId);
        if (specOpt.isEmpty()) {
            result.put("status", "NOT_FOUND");
            return result;
        }

        Specialization spec = specOpt.get();
        result.put("specializationId", spec.getId());
        result.put("specializationCode", spec.getCode());
        result.put("specializationName", spec.getName());

        List<SpecializationCourse> specCourses = specializationCourseRepo.findBySpecializationId(specializationId);
        
        // Find completed courses by student
        List<StudentCourse> studentCourses = studentCourseRepo.findByStudentIdAndStatus(studentId, "COMPLETED");
        Set<String> completedCodes = new HashSet<>();
        for (StudentCourse sc : studentCourses) {
            completedCodes.add(sc.getCourseCode());
        }
        
        // Also check raw completed courses as fallback
        List<CompletedCourse> rawCompleted = completedCourseRepo.findByStudentId(studentId);
        for (CompletedCourse cc : rawCompleted) {
            if (cc.getStatus() == null || !cc.getStatus().equalsIgnoreCase("On-Progress")) {
                completedCodes.add(cc.getCourseCode());
            }
        }

        List<Map<String, Object>> completedList = new ArrayList<>();
        List<Map<String, Object>> pendingList = new ArrayList<>();
        int requiredCount = specCourses.size();
        int completedCount = 0;
        double requiredCredits = 0.0;
        double earnedCredits = 0.0;

        for (SpecializationCourse sc : specCourses) {
            double courseCredits = sc.getCourse().getCredits() != null ? sc.getCourse().getCredits() : 0.0;
            requiredCredits += courseCredits;

            Map<String, Object> courseInfo = new LinkedHashMap<>();
            courseInfo.put("courseId", sc.getCourse().getId());
            courseInfo.put("courseCode", sc.getCourse().getCourseCode());
            courseInfo.put("courseName", sc.getCourse().getCourseName());
            courseInfo.put("role", sc.getRole());
            courseInfo.put("credits", courseCredits);

            if (completedCodes.contains(sc.getCourse().getCourseCode())) {
                completedCount++;
                earnedCredits += courseCredits;
                completedList.add(courseInfo);
            } else {
                pendingList.add(courseInfo);
            }
        }

        boolean isCompleted = (requiredCount > 0 && completedCount >= requiredCount) || (requiredCredits > 0 && earnedCredits >= requiredCredits);
        String status = isCompleted ? "COMPLETED" : (earnedCredits > 0 ? "IN_PROGRESS" : "PENDING");

        double progressPercentage = requiredCredits > 0 ? Math.min(100.0, (earnedCredits / requiredCredits) * 100.0) : (isCompleted ? 100.0 : 0.0);

        result.put("requiredCourses", requiredCount);
        result.put("completedCoursesCount", completedCount);
        result.put("pendingCoursesCount", requiredCount - completedCount);
        result.put("requiredCredits", requiredCredits);
        result.put("earnedCredits", earnedCredits);
        result.put("progressPercentage", Math.round(progressPercentage * 100.0) / 100.0);
        result.put("status", status);
        result.put("completedCourses", completedList);
        result.put("pendingCourses", pendingList);

        return result;
    }
}
