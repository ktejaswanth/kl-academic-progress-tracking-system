package com.example.demo.config;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import com.example.demo.service.Y23AidsCurriculumSeeder;
import com.example.demo.service.Y23AidsDataMigration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class DataSeeder implements CommandLineRunner {

    @Autowired private UserRepository userRepository;
    @Autowired private StudentProfileRepository studentProfileRepository;
    @Autowired private RequirementRepository requirementRepository;
    @Autowired private CompletedCourseRepository completedCourseRepository;
    @Autowired private PasswordEncoder passwordEncoder;
    @Autowired private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;
    @Autowired private Y23AidsDataMigration y23AidsDataMigration;

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
            student.setDepartment("AIDS");
            student.setSubDepartment("REGULAR");
            student.setSpecializationType("NONE");
            student.setForcePasswordChange(false);
            student.setIsActive(true);
            userRepository.save(student);

            StudentProfile profile = new StudentProfile();
            profile.setUser(student);
            profile.setUniversityId("2100030001");
            profile.setDegreeType("B.Tech");
            profile.setSpecialization("AIDS");
            profile.setCurrentYear(3);
            profile.setAdmissionYear(2023);
            studentProfileRepository.save(profile);

            // Seed Completed Courses for Test Student
            CompletedCourse c1 = new CompletedCourse();
            c1.setStudent(student); c1.setCourseCode("23AD2101"); c1.setCourseName("Introduction to Data Science & AI");
            c1.setCredits(4); c1.setGrade("A"); c1.setSemester("SEM-1");
            c1.setCompletedDate(LocalDate.now());
            completedCourseRepository.save(c1);

            CompletedCourse c2 = new CompletedCourse();
            c2.setStudent(student); c2.setCourseCode("23AD2102"); c2.setCourseName("Data Structures & Algorithms in Python");
            c2.setCredits(4); c2.setGrade("O"); c2.setSemester("SEM-1");
            c2.setCompletedDate(LocalDate.now());
            completedCourseRepository.save(c2);

            System.out.println("✅ Test AIDS Student and Completions seeded.");
        }

        // 3. Seed Y23 AIDS Curriculum Structure
        try {
            y23AidsCurriculumSeeder.seedY23AidsCurriculum();
            System.out.println("✅ Y23 AIDS Curriculum Structure seeded.");
        } catch (Exception e) {
            System.err.println("⚠️ Y23 AIDS Curriculum Seeding notice: " + e.getMessage());
        }

        // 4. Migrate Student Course Data
        try {
            y23AidsDataMigration.migrateY23AidsStudentData();
            System.out.println("✅ Student Course Data Normalization complete.");
        } catch (Exception e) {
            System.err.println("⚠️ Student Course Data Migration notice: " + e.getMessage());
        }
    }
}
