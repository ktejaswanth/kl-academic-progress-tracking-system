package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/specializations")
@CrossOrigin(origins = "*")
public class SpecializationController {

    @Autowired private SpecializationRepository specializationRepo;
    @Autowired private SpecializationCourseRepository specializationCourseRepo;

    @GetMapping
    public ResponseEntity<List<Specialization>> getAllSpecializations() {
        return ResponseEntity.ok(specializationRepo.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Specialization> getSpecializationById(@PathVariable Long id) {
        return specializationRepo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/courses")
    public ResponseEntity<List<SpecializationCourse>> getSpecializationCourses(@PathVariable Long id) {
        return ResponseEntity.ok(specializationCourseRepo.findBySpecializationId(id));
    }

    @PostMapping
    public ResponseEntity<Specialization> createSpecialization(@RequestBody Specialization specialization) {
        return ResponseEntity.ok(specializationRepo.save(specialization));
    }

    @PostMapping("/{id}/courses")
    public ResponseEntity<SpecializationCourse> addCourseToSpecialization(@PathVariable Long id, @RequestBody SpecializationCourse course) {
        Specialization spec = specializationRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Specialization not found"));
        course.setSpecialization(spec);
        return ResponseEntity.ok(specializationCourseRepo.save(course));
    }
}
