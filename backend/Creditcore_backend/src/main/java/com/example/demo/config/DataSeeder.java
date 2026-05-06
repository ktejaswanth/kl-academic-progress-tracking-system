package com.example.demo.config;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class DataSeeder implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private RequirementRepository requirementRepository;

    @Autowired
    private CompletedCourseRepository completedCourseRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // 1. Seed Super Admin
        if (userRepository.findByUsername("admin").isEmpty()) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@university.edu");
            admin.setPasswordHash(passwordEncoder.encode("password123"));
            admin.setFirstName("Super");
            admin.setLastName("Admin");
            admin.setRole(UserRole.SUPER_ADMIN);
            admin.setDepartment("ALL");
            admin.setForcePasswordChange(false);
            admin.setIsActive(true);
            userRepository.save(admin);
            System.out.println("✅ Super Admin created.");
        }

        // 2. Seed a Test Student
        if (userRepository.findByUsername("2100030001").isEmpty()) {
            User student = new User();
            student.setUsername("2100030001");
            student.setEmail("student@kluniversity.in");
            student.setPasswordHash(passwordEncoder.encode("password123"));
            student.setFirstName("Rajesh");
            student.setLastName("Kumar");
            student.setRole(UserRole.STUDENT);
            student.setDepartment("CSE");
            student.setForcePasswordChange(false);
            student.setIsActive(true);
            userRepository.save(student);

            StudentProfile profile = new StudentProfile();
            profile.setUser(student);
            profile.setDegreeType("B.Tech");
            profile.setSpecialization("CSE");
            profile.setCurrentYear(3);
            profile.setAdmissionYear(2021);
            studentProfileRepository.save(profile);

            // 3. Seed Requirements
            Requirement r1 = new Requirement();
            r1.setDegreeType("B.Tech"); r1.setSpecialization("CSE");
            r1.setBucketName("MANDATORY"); r1.setCourseCode("CS101"); r1.setCourseName("Data Structures");
            r1.setCredits(4); r1.setIsMandatory(true);
            requirementRepository.save(r1);

            Requirement r2 = new Requirement();
            r2.setDegreeType("B.Tech"); r2.setSpecialization("CSE");
            r2.setBucketName("MANDATORY"); r2.setCourseCode("CS102"); r2.setCourseName("Algorithms");
            r2.setCredits(4); r2.setIsMandatory(true);
            requirementRepository.save(r2);

            Requirement r3 = new Requirement();
            r3.setDegreeType("B.Tech"); r3.setSpecialization("CSE");
            r3.setBucketName("ELECTIVE"); r3.setCourseCode("CS201"); r3.setCourseName("Artificial Intelligence");
            r3.setCredits(3); r3.setIsMandatory(false);
            requirementRepository.save(r3);

            // 4. Seed Completed Courses
            CompletedCourse c1 = new CompletedCourse();
            c1.setStudent(student); c1.setCourseCode("CS101"); c1.setCourseName("Data Structures");
            c1.setCredits(4); c1.setGrade("A"); c1.setSemester("SEM-1");
            c1.setCompletedDate(LocalDate.now());
            completedCourseRepository.save(c1);

            System.out.println("✅ Test Student, Requirements, and Completions seeded.");
        }
    }
}
