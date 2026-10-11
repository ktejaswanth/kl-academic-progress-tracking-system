package com.example.demo.service;

import com.example.demo.model.Admin;
import com.example.demo.model.Faculty;
import com.example.demo.model.Student;
import com.example.demo.repository.AdminRepository;
import com.example.demo.repository.FacultyRepository;
import com.example.demo.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Optional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private StudentRepository studentRepository;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 1. Check Admin in admins table
        Optional<Admin> admin = adminRepository.findByUsername(username);
        if (admin.isPresent()) {
            return new org.springframework.security.core.userdetails.User(
                    admin.get().getUsername(),
                    admin.get().getPassword(),
                    Collections.singletonList(new SimpleGrantedAuthority("ROLE_SUPER_ADMIN"))
            );
        }

        // 2. Check Faculty in faculty table
        Optional<Faculty> faculty = facultyRepository.findByUsername(username);
        if (faculty.isPresent()) {
            return new org.springframework.security.core.userdetails.User(
                    faculty.get().getUsername(),
                    faculty.get().getPassword(),
                    Collections.singletonList(new SimpleGrantedAuthority("ROLE_FACULTY"))
            );
        }

        // 3. Check Student in students table
        Optional<Student> student = studentRepository.findByStudentId(username);
        if (student.isPresent()) {
            return new org.springframework.security.core.userdetails.User(
                    student.get().getStudentId(),
                    student.get().getPassword(),
                    Collections.singletonList(new SimpleGrantedAuthority("ROLE_STUDENT"))
            );
        }

        throw new UsernameNotFoundException("User not found: " + username);
    }
}
