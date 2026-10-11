package com.example.demo.controller;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/minors")
@CrossOrigin(origins = "*")
public class MinorController {

    @Autowired private MinorProgramRepository minorRepo;
    @Autowired private MinorCourseRepository minorCourseRepo;

    @GetMapping
    public ResponseEntity<List<MinorProgram>> getAllMinors() {
        return ResponseEntity.ok(minorRepo.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<MinorProgram> getMinorById(@PathVariable Long id) {
        return minorRepo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/courses")
    public ResponseEntity<List<MinorCourse>> getMinorCourses(@PathVariable Long id) {
        return ResponseEntity.ok(minorCourseRepo.findByMinorId(id));
    }

    @PostMapping
    public ResponseEntity<MinorProgram> createMinor(@RequestBody MinorProgram minor) {
        return ResponseEntity.ok(minorRepo.save(minor));
    }
}
