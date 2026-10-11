package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional(readOnly = true)
public class SecondMajorProgressEngine {

    @Autowired private SecondMajorProgramRepository secondMajorRepo;
    @Autowired private SecondMajorCourseRepository secondMajorCourseRepo;
    @Autowired private StudentCourseRepository studentCourseRepo;
    @Autowired private CompletedCourseRepository completedCourseRepo;

    public Map<String, Object> calculateSecondMajorProgress(Long studentId, Long secondMajorId) {
        Map<String, Object> result = new LinkedHashMap<>();

        if (secondMajorId == null) {
            result.put("status", "NOT_APPLICABLE");
            return result;
        }

        Optional<SecondMajorProgram> smOpt = secondMajorRepo.findById(secondMajorId);
        if (smOpt.isEmpty()) {
            result.put("status", "NOT_FOUND");
            return result;
        }

        SecondMajorProgram sm = smOpt.get();
        result.put("secondMajorId", sm.getId());
        result.put("secondMajorCode", sm.getCode());
        result.put("secondMajorName", sm.getName());

        List<SecondMajorCourse> smCourses = secondMajorCourseRepo.findBySecondMajorId(secondMajorId);
        
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
        double requiredCredits = sm.getRequiredCredits() != null ? sm.getRequiredCredits().doubleValue() : 40.0;
        double earnedCredits = 0.0;

        for (SecondMajorCourse smc : smCourses) {
            double courseCredits = smc.getCourse().getCredits() != null ? smc.getCourse().getCredits() : 0.0;

            Map<String, Object> courseInfo = new LinkedHashMap<>();
            courseInfo.put("courseId", smc.getCourse().getId());
            courseInfo.put("courseCode", smc.getCourse().getCourseCode());
            courseInfo.put("courseName", smc.getCourse().getCourseName());
            courseInfo.put("credits", courseCredits);

            String cCode = smc.getCourse().getCourseCode() != null ? smc.getCourse().getCourseCode().trim().toUpperCase() : "";
            if (completedCodes.contains(cCode)) {
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
