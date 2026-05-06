package com.example.demo.config;

import com.example.demo.model.User;
import com.example.demo.model.UserRole;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataSeeder implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
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
            System.out.println("✅ Super Admin created successfully with username: admin and password: password123");
        } else {
            // Optional: Update password if needed to ensure it matches
            User admin = userRepository.findByUsername("admin").get();
            admin.setPasswordHash(passwordEncoder.encode("password123"));
            userRepository.save(admin);
            System.out.println("✅ Super Admin password verified and updated.");
        }
    }
}
