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

    @Autowired private AdminRepository adminRepository;
    @Autowired private StudentProfileRepository studentProfileRepository;
    @Autowired private RequirementRepository requirementRepository;
    @Autowired private CompletedCourseRepository completedCourseRepository;
    @Autowired private PasswordEncoder passwordEncoder;
    @Autowired private Y23AidsCurriculumSeeder y23AidsCurriculumSeeder;
    @Autowired private Y23AidsDataMigration y23AidsDataMigration;

    @Override
    public void run(String... args) throws Exception {
        // 1. Seed or synchronize Super Admin in admins table
        adminRepository.findByUsername("admin").ifPresentOrElse(admin -> {
            if (!passwordEncoder.matches("Password@123", admin.getPassword())) {
                admin.setPassword(passwordEncoder.encode("Password@123"));
                admin.setRawPassword("Password@123");
                adminRepository.save(admin);
                System.out.println("✅ Synchronized Super Admin password to Password@123");
            }
        }, () -> {
            Admin admin = new Admin();
            admin.setUsername("admin");
            admin.setEmpId("ADMIN001");
            admin.setEmail("admin@university.edu");
            admin.setPassword(passwordEncoder.encode("Password@123"));
            admin.setRawPassword("Password@123");
            admin.setFirstName("Super");
            admin.setLastName("Admin");
            admin.setDesignation("Super Administrator");
            admin.setIsActive(true);
            adminRepository.save(admin);
            System.out.println("✅ Super Admin created in admins table with Password@123");
        });

        // 2. Test Student auto-seeding disabled to keep database clean of student data

        // 3. Seed Y23 AIDS Curriculum Structure (Rules and Bucket Requirements Only)
        try {
            y23AidsCurriculumSeeder.seedY23AidsCurriculum();
            System.out.println("✅ Y23 Curriculum Structure validated.");
        } catch (Exception e) {
            System.err.println("⚠️ Y23 Curriculum Seeding notice: " + e.getMessage());
        }

        // 4. Student Course Data: Realtime data only - no automated mock data seeding.
    }
}
