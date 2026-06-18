package com.example.demo.controller;

import com.example.demo.model.CurriculumVersion;
import com.example.demo.model.DegreeProgram;
import com.example.demo.model.HonorsProgram;
import com.example.demo.model.Specialization;
import com.example.demo.service.CurriculumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/onboarding/curriculum")
public class StudentCurriculumController {

    @Autowired
    private CurriculumService curriculumService;

    @GetMapping("/programs")
    public ResponseEntity<List<DegreeProgram>> listPrograms() {
        return ResponseEntity.ok(curriculumService.listPrograms());
    }

    @GetMapping("/programs/{programId}/curriculum-versions")
    public ResponseEntity<List<CurriculumVersion>> listProgramVersions(@PathVariable Long programId) {
        return ResponseEntity.ok(curriculumService.listCurriculumVersionsByProgram(programId));
    }

    @GetMapping("/programs/{programId}/specializations")
    public ResponseEntity<List<Specialization>> listSpecializations(@PathVariable Long programId) {
        return ResponseEntity.ok(curriculumService.getSpecializationsByProgram(programId));
    }

    @GetMapping("/programs/{programId}/honors")
    public ResponseEntity<List<HonorsProgram>> listHonors(@PathVariable Long programId) {
        return ResponseEntity.ok(curriculumService.getHonorsProgramsByProgram(programId));
    }
}
