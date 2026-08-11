package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/second-majors")
@CrossOrigin(origins = "*")
public class SecondMajorController {

    @Autowired private SecondMajorProgramRepository secondMajorRepo;
    @Autowired private SecondMajorCourseRepository secondMajorCourseRepo;

    @GetMapping
    public ResponseEntity<List<SecondMajorProgram>> getAllSecondMajors() {
        return ResponseEntity.ok(secondMajorRepo.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<SecondMajorProgram> getSecondMajorById(@PathVariable Long id) {
        return secondMajorRepo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/courses")
    public ResponseEntity<List<SecondMajorCourse>> getSecondMajorCourses(@PathVariable Long id) {
        return ResponseEntity.ok(secondMajorCourseRepo.findBySecondMajorId(id));
    }

    @PostMapping
    public ResponseEntity<SecondMajorProgram> createSecondMajor(@RequestBody SecondMajorProgram secondMajor) {
        return ResponseEntity.ok(secondMajorRepo.save(secondMajor));
    }
}
