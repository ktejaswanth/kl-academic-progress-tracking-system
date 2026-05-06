package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.model.UserRole;
import com.example.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
public class SuperAdminController {

    @Autowired
    private UserService userService;

    @PostMapping("/faculty")
    public ResponseEntity<?> createFaculty(@RequestBody User faculty) {
        try {
            return ResponseEntity.status(201).body(userService.createFaculty(faculty));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating faculty: " + e.getMessage());
        }
    }

    @GetMapping("/analytics")
    public ResponseEntity<?> getAnalytics() {
        return ResponseEntity.ok(userService.getDashboardAnalytics());
    }

    @GetMapping("/users")
    public ResponseEntity<?> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/faculty")
    public ResponseEntity<?> getFaculty() {
        return ResponseEntity.ok(userService.getUsersByRole(UserRole.FACULTY));
    }

    @GetMapping("/students")
    public ResponseEntity<?> getStudents() {
        return ResponseEntity.ok(userService.getUsersByRole(UserRole.STUDENT));
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.ok("User deleted successfully");
    }
}
