package com.example.demo.controller;

import com.example.demo.model.DegreePath;
import com.example.demo.model.StudentDegreePath;
import com.example.demo.service.DegreePathEngine;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/dyod/paths")
@CrossOrigin(origins = "http://localhost:5173")
public class DegreePathController {

    @Autowired
    private DegreePathEngine degreePathEngine;

    @PostMapping("/student/{studentId}/resolve")
    public ResponseEntity<DegreePath> resolvePathForStudent(@PathVariable Long studentId) {
        return ResponseEntity.ok(degreePathEngine.resolveAndAssignPath(studentId));
    }

    @GetMapping("/student/{studentId}")
    public ResponseEntity<?> getAssignedPath(@PathVariable Long studentId) {
        Optional<StudentDegreePath> path = degreePathEngine.getStudentPath(studentId);
        if (path.isPresent()) {
            return ResponseEntity.ok(path.get());
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping("/student/{studentId}/assign/{pathId}")
    public ResponseEntity<DegreePath> manuallyAssignPath(@PathVariable Long studentId, @PathVariable Long pathId) {
        return ResponseEntity.ok(degreePathEngine.assignPath(studentId, pathId, null));
    }

    @PostMapping("/auto-assign-all")
    public ResponseEntity<Map<String, Object>> autoAssignAll() {
        return ResponseEntity.ok(degreePathEngine.autoAssignAllStudents());
    }
}
