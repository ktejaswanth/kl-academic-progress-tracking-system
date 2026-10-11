package com.example.demo.service;

import com.example.demo.config.JwtUtil;
import com.example.demo.dto.LoginRequest;
import com.example.demo.dto.LoginResponse;
import com.example.demo.model.Admin;
import com.example.demo.model.Faculty;
import com.example.demo.model.PasswordResetToken;
import com.example.demo.model.Student;
import com.example.demo.repository.AdminRepository;
import com.example.demo.repository.FacultyRepository;
import com.example.demo.repository.PasswordResetTokenRepository;
import com.example.demo.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public LoginResponse login(LoginRequest request) {
        System.out.println("🔐 Login Attempt: " + request.getUsername());
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
            );
            System.out.println("✅ Login Success: " + request.getUsername());
        } catch (Exception e) {
            System.out.println("❌ Login Failed: " + request.getUsername() + " - " + e.getMessage());
            throw e;
        }

        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getUsername());

        // 1. Check Admin table
        Optional<Admin> adminOpt = adminRepository.findByUsername(request.getUsername());
        if (adminOpt.isPresent()) {
            Admin a = adminOpt.get();
            String jwt = jwtUtil.generateToken(userDetails, "SUPER_ADMIN");
            return new LoginResponse(
                    jwt,
                    a.getUsername(),
                    "SUPER_ADMIN",
                    false,
                    a.getFirstName(),
                    a.getLastName()
            );
        }

        // 2. Check Faculty table
        Optional<Faculty> facultyOpt = facultyRepository.findByUsername(request.getUsername());
        if (facultyOpt.isPresent()) {
            Faculty f = facultyOpt.get();
            String jwt = jwtUtil.generateToken(userDetails, "FACULTY");
            return new LoginResponse(
                    jwt,
                    f.getUsername(),
                    "FACULTY",
                    !Boolean.TRUE.equals(f.getFirstLoginCompleted()),
                    f.getFirstName(),
                    f.getLastName()
            );
        }

        // 3. Check Student table
        Optional<Student> studentOpt = studentRepository.findByStudentId(request.getUsername());
        if (studentOpt.isPresent()) {
            Student s = studentOpt.get();
            String jwt = jwtUtil.generateToken(userDetails, "STUDENT");
            return new LoginResponse(
                    jwt,
                    s.getStudentId(),
                    "STUDENT",
                    !Boolean.TRUE.equals(s.getFirstLoginCompleted()),
                    s.getFirstName(),
                    s.getLastName()
            );
        }

        throw new RuntimeException("User record not found in system.");
    }

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private EmailService emailService;

    public String initiatePasswordReset(String email) {
        String username = null;
        Long userId = null;

        var studentOpt = studentRepository.findByEmail(email);
        if (studentOpt.isPresent()) {
            username = studentOpt.get().getStudentId();
            userId = studentOpt.get().getId();
        } else {
            var facultyOpt = facultyRepository.findByEmail(email);
            if (facultyOpt.isPresent()) {
                username = facultyOpt.get().getUsername();
                userId = facultyOpt.get().getId();
            } else {
                var adminOpt = adminRepository.findByEmail(email);
                if (adminOpt.isPresent()) {
                    username = adminOpt.get().getUsername();
                    userId = adminOpt.get().getId();
                }
            }
        }

        if (username != null) {
            tokenRepository.deleteByUsername(username);
            tokenRepository.flush();

            PasswordResetToken token = new PasswordResetToken(username, userId);
            tokenRepository.save(token);

            String resetLink = "http://localhost:3086/reset-password?token=" + token.getToken();
            try {
                emailService.sendResetPasswordEmail(email, resetLink);
            } catch (Exception e) {
                System.err.println("❌ FAILED TO SEND EMAIL: " + e.getMessage());
            }
        }
        return "If an account matches this email, a reset link will be sent.";
    }

    public void resetPassword(String token, String newPassword) {
        PasswordResetToken resetToken = tokenRepository.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Invalid or missing password reset token."));

        if (resetToken.isExpired()) {
            tokenRepository.delete(resetToken);
            throw new RuntimeException("This password reset token has expired (20 min limit).");
        }

        String username = resetToken.getUsername();
        String encoded = passwordEncoder.encode(newPassword);
        syncPasswordToRoleTable(username, encoded);
        tokenRepository.delete(resetToken);
    }

    public void changePassword(String username, String newPassword) {
        String encoded = passwordEncoder.encode(newPassword);
        syncPasswordToRoleTable(username, encoded);
    }

    private void syncPasswordToRoleTable(String username, String encodedPassword) {
        studentRepository.findByStudentId(username).ifPresent(s -> {
            s.setPassword(encodedPassword);
            s.setRawPassword(null);
            s.setFirstLoginCompleted(true);
            studentRepository.save(s);
        });
        facultyRepository.findByUsername(username).ifPresent(f -> {
            f.setPassword(encodedPassword);
            f.setRawPassword(null);
            f.setFirstLoginCompleted(true);
            facultyRepository.save(f);
        });
        adminRepository.findByUsername(username).ifPresent(a -> {
            a.setPassword(encodedPassword);
            a.setRawPassword(null);
            adminRepository.save(a);
        });
    }
}
