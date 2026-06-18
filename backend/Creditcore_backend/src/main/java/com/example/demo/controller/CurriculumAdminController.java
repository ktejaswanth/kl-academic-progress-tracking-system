package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.service.CurriculumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/curriculum")
@PreAuthorize("hasRole('SUPER_ADMIN')")
public class CurriculumAdminController {

    @Autowired
    private CurriculumService curriculumService;

    @PostMapping("/programs")
    public ResponseEntity<DegreeProgram> createProgram(@RequestBody DegreeProgram program) {
        return ResponseEntity.ok(curriculumService.createProgram(program));
    }

    @PutMapping("/programs/{id}")
    public ResponseEntity<DegreeProgram> updateProgram(@PathVariable Long id, @RequestBody DegreeProgram updates) {
        return ResponseEntity.ok(curriculumService.updateProgram(id, updates));
    }

    @DeleteMapping("/programs/{id}")
    public ResponseEntity<?> deleteProgram(@PathVariable Long id) {
        curriculumService.deleteDegreeProgram(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/programs")
    public ResponseEntity<List<DegreeProgram>> listPrograms() {
        return ResponseEntity.ok(curriculumService.listPrograms());
    }

    @PostMapping("/programs/{programId}/specializations")
    public ResponseEntity<Specialization> createSpecialization(@PathVariable Long programId, @RequestBody Specialization specialization) {
        DegreeProgram program = new DegreeProgram();
        program.setId(programId);
        specialization.setProgram(program);
        return ResponseEntity.ok(curriculumService.createSpecialization(specialization));
    }

    @PostMapping("/programs/{programId}/honors")
    public ResponseEntity<HonorsProgram> createHonorsProgram(@PathVariable Long programId, @RequestBody HonorsProgram honorsProgram) {
        DegreeProgram program = new DegreeProgram();
        program.setId(programId);
        honorsProgram.setProgram(program);
        return ResponseEntity.ok(curriculumService.createHonorsProgram(honorsProgram));
    }

    @PostMapping("/courses")
    public ResponseEntity<CourseCatalog> createCourse(@RequestBody CourseCatalog course) {
        return ResponseEntity.ok(curriculumService.createCourse(course));
    }

    @GetMapping("/courses")
    public ResponseEntity<List<CourseCatalog>> listCourses() {
        return ResponseEntity.ok(curriculumService.listCourses());
    }

    @PostMapping("/curriculum-versions")
    public ResponseEntity<CurriculumVersion> createCurriculumVersion(@RequestBody CurriculumVersion version) {
        return ResponseEntity.ok(curriculumService.createCurriculumVersion(version));
    }

    @PostMapping("/curriculum-versions/{versionId}/requirements")
    public ResponseEntity<ProgramRequirement> createProgramRequirement(@PathVariable Long versionId, @RequestBody ProgramRequirement requirement) {
        CurriculumVersion version = new CurriculumVersion();
        version.setId(versionId);
        requirement.setCurriculumVersion(version);
        return ResponseEntity.ok(curriculumService.createProgramRequirement(requirement));
    }

    @PostMapping("/curriculum-versions/{versionId}/courses")
    public ResponseEntity<CurriculumCourse> createCurriculumCourse(@PathVariable Long versionId, @RequestBody CurriculumCourse curriculumCourse) {
        CurriculumVersion version = new CurriculumVersion();
        version.setId(versionId);
        curriculumCourse.setCurriculumVersion(version);
        return ResponseEntity.ok(curriculumService.createCurriculumCourse(curriculumCourse));
    }

    @PutMapping("/programs/{programId}/specializations/{id}")
    public ResponseEntity<Specialization> updateSpecialization(@PathVariable Long programId, @PathVariable Long id, @RequestBody Specialization updates) {
        DegreeProgram program = new DegreeProgram();
        program.setId(programId);
        updates.setProgram(program);
        return ResponseEntity.ok(curriculumService.updateSpecialization(id, updates));
    }

    @DeleteMapping("/programs/{programId}/specializations/{id}")
    public ResponseEntity<?> deleteSpecialization(@PathVariable Long programId, @PathVariable Long id) {
        curriculumService.deleteSpecialization(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/programs/{programId}/honors/{id}")
    public ResponseEntity<HonorsProgram> updateHonorsProgram(@PathVariable Long programId, @PathVariable Long id, @RequestBody HonorsProgram updates) {
        DegreeProgram program = new DegreeProgram();
        program.setId(programId);
        updates.setProgram(program);
        return ResponseEntity.ok(curriculumService.updateHonorsProgram(id, updates));
    }

    @DeleteMapping("/programs/{programId}/honors/{id}")
    public ResponseEntity<?> deleteHonorsProgram(@PathVariable Long programId, @PathVariable Long id) {
        curriculumService.deleteHonorsProgram(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/courses/{id}")
    public ResponseEntity<CourseCatalog> updateCourse(@PathVariable Long id, @RequestBody CourseCatalog updates) {
        return ResponseEntity.ok(curriculumService.updateCourse(id, updates));
    }

    @DeleteMapping("/courses/{id}")
    public ResponseEntity<?> deleteCourse(@PathVariable Long id) {
        curriculumService.deleteCourse(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/curriculum-versions/{versionId}")
    public ResponseEntity<CurriculumVersion> updateCurriculumVersion(@PathVariable Long versionId, @RequestBody CurriculumVersion updates) {
        updates.setId(versionId);
        return ResponseEntity.ok(curriculumService.updateCurriculumVersion(versionId, updates));
    }

    @DeleteMapping("/curriculum-versions/{versionId}")
    public ResponseEntity<?> deleteCurriculumVersion(@PathVariable Long versionId) {
        curriculumService.deleteCurriculumVersion(versionId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/curriculum-versions/{versionId}/requirements")
    public ResponseEntity<List<ProgramRequirement>> getCurriculumRequirements(@PathVariable Long versionId) {
        return ResponseEntity.ok(curriculumService.listProgramRequirementsByVersion(versionId));
    }

    @PutMapping("/curriculum-versions/{versionId}/requirements/{requirementId}")
    public ResponseEntity<ProgramRequirement> updateProgramRequirement(@PathVariable Long versionId, @PathVariable Long requirementId, @RequestBody ProgramRequirement updates) {
        CurriculumVersion version = new CurriculumVersion();
        version.setId(versionId);
        updates.setCurriculumVersion(version);
        return ResponseEntity.ok(curriculumService.updateProgramRequirement(requirementId, updates));
    }

    @DeleteMapping("/curriculum-versions/{versionId}/requirements/{requirementId}")
    public ResponseEntity<?> deleteProgramRequirement(@PathVariable Long versionId, @PathVariable Long requirementId) {
        curriculumService.deleteProgramRequirement(requirementId);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/curriculum-versions/{versionId}/courses/{courseId}")
    public ResponseEntity<CurriculumCourse> updateCurriculumCourse(@PathVariable Long versionId, @PathVariable Long courseId, @RequestBody CurriculumCourse updates) {
        CurriculumVersion version = new CurriculumVersion();
        version.setId(versionId);
        updates.setCurriculumVersion(version);
        updates.setId(courseId);
        return ResponseEntity.ok(curriculumService.updateCurriculumCourse(courseId, updates));
    }

    @DeleteMapping("/curriculum-versions/{versionId}/courses/{courseId}")
    public ResponseEntity<?> deleteCurriculumCourse(@PathVariable Long versionId, @PathVariable Long courseId) {
        curriculumService.deleteCurriculumCourse(courseId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/programs/{programId}/specializations")
    public ResponseEntity<List<Specialization>> getSpecializations(@PathVariable Long programId) {
        return ResponseEntity.ok(curriculumService.getSpecializationsByProgram(programId));
    }

    @GetMapping("/programs/{programId}/honors")
    public ResponseEntity<List<HonorsProgram>> getHonors(@PathVariable Long programId) {
        return ResponseEntity.ok(curriculumService.getHonorsProgramsByProgram(programId));
    }

    @GetMapping("/programs/{programId}/curriculum-versions")
    public ResponseEntity<List<CurriculumVersion>> getCurriculumVersions(@PathVariable Long programId) {
        return ResponseEntity.ok(curriculumService.listCurriculumVersionsByProgram(programId));
    }

    @GetMapping("/curriculum-versions/{versionId}/courses")
    public ResponseEntity<List<CurriculumCourse>> getCurriculumCourses(@PathVariable Long versionId) {
        return ResponseEntity.ok(curriculumService.listCurriculumCoursesByVersion(versionId));
    }
}
