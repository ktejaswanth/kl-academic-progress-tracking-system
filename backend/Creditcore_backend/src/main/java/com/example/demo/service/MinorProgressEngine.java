package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional(readOnly = true)
public class MinorProgressEngine {

    @Autowired private MinorProgramRepository minorRepo;
    @Autowired private MinorCourseRepository minorCourseRepo;
    @Autowired private StudentCourseRepository studentCourseRepo;
    @Autowired private CompletedCourseRepository completedCourseRepo;

    public Map<String, Object> calculateMinorProgress(Long studentId, Long minorId) {
        Map<String, Object> result = new LinkedHashMap<>();

        if (minorId == null) {
            result.put("status", "NOT_APPLICABLE");
            return result;
        }

        Optional<MinorProgram> minorOpt = minorRepo.findById(minorId);
        if (minorOpt.isEmpty()) {
            result.put("status", "NOT_FOUND");
            return result;
        }

        MinorProgram minor = minorOpt.get();
        result.put("minorId", minor.getId());
        result.put("minorCode", minor.getCode());
        result.put("minorName", minor.getName());

        List<MinorCourse> minorCourses = minorCourseRepo.findByMinorId(minorId);
        
        List<StudentCourse> studentCourses = studentCourseRepo.findByStudentIdAndStatus(studentId, "COMPLETED");
        Set<String> completedCodes = new HashSet<>();
        for (StudentCourse sc : studentCourses) {
            if (sc.getCourseCode() != null && BucketMappingEngine.isPassingGrade(sc.getGrade())) {
                completedCodes.add(sc.getCourseCode().trim().toUpperCase());
            }
        }
        
        List<CompletedCourse> rawCompleted = completedCourseRepo.findByStudentId(studentId);
        for (CompletedCourse cc : rawCompleted) {
            if (cc.getCourseCode() == null) continue;
            boolean isCompletedStatus = cc.getStatus() == null || cc.getStatus().equalsIgnoreCase("Completed") || cc.getStatus().equalsIgnoreCase("COMPLETED");
            boolean isVerified = cc.getVerifiedBy() != null || cc.getLtps() != null || cc.getSectionNo() != null;
            boolean isPassing = BucketMappingEngine.isPassingGrade(cc.getGrade());
            if (isCompletedStatus && isVerified && isPassing) {
                completedCodes.add(cc.getCourseCode().trim().toUpperCase());
            }
        }

        List<Map<String, Object>> completedList = new ArrayList<>();
        List<Map<String, Object>> pendingList = new ArrayList<>();
        int requiredCount = minorCourses.size();
        int completedCount = 0;
        double requiredCredits = minor.getCreditsRequired() != null ? minor.getCreditsRequired().doubleValue() : 18.0;
        double earnedCredits = 0.0;

        for (MinorCourse mc : minorCourses) {
            double courseCredits = mc.getCourse().getCredits() != null ? mc.getCourse().getCredits() : 0.0;

            Map<String, Object> courseInfo = new LinkedHashMap<>();
            courseInfo.put("courseId", mc.getCourse().getId());
            courseInfo.put("courseCode", mc.getCourse().getCourseCode());
            courseInfo.put("courseName", mc.getCourse().getCourseName());
            courseInfo.put("credits", courseCredits);

            String cCode = mc.getCourse().getCourseCode() != null ? mc.getCourse().getCourseCode().trim().toUpperCase() : "";
            if (completedCodes.contains(cCode)) {
                completedCount++;
                earnedCredits += courseCredits;
                completedList.add(courseInfo);
            } else {
                pendingList.add(courseInfo);
            }
        }

        boolean isCompleted = earnedCredits >= requiredCredits;
        String status = isCompleted ? "COMPLETED" : (earnedCredits > 0 ? "IN_PROGRESS" : "PENDING");
        double progressPercentage = requiredCredits > 0 ? Math.min(100.0, (earnedCredits / requiredCredits) * 100.0) : 0.0;

        result.put("requiredCredits", requiredCredits);
        result.put("earnedCredits", earnedCredits);
        result.put("progressPercentage", Math.round(progressPercentage * 100.0) / 100.0);
        result.put("status", status);
        result.put("completedCourses", completedList);
        result.put("pendingCourses", pendingList);

        return result;
    }
}
