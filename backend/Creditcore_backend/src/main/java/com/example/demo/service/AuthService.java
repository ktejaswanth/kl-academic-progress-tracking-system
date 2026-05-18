package com.example.demo.service;

import com.example.demo.config.JwtUtil;
import com.example.demo.dto.LoginRequest;
import com.example.demo.dto.LoginResponse;
import com.example.demo.model.PasswordResetToken;
import com.example.demo.model.User;
import com.example.demo.repository.PasswordResetTokenRepository;
import com.example.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    private UserRepository userRepository;

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
        User user = userRepository.findByUsername(request.getUsername()).orElseThrow();
        
        String jwt = jwtUtil.generateToken(userDetails, user.getRole().name());

        return new LoginResponse(
                jwt,
                user.getUsername(),
                user.getRole().name(),
                user.getForcePasswordChange(),
                user.getFirstName(),
                user.getLastName()
        );
    }

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private EmailService emailService;

    public String initiatePasswordReset(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("No user found with this email address."));

        // Use findByUser or similar if exists, but we can also just find it manually
        // For simplicity and to avoid adding more methods to repo, let's fetch it via a query if needed
        // But better yet, let's just make the delete explicit and flush it
        
        // Actually, let's add findByUser to the repository for a cleaner fix
        tokenRepository.deleteByUser(user);
        tokenRepository.flush(); // Force the delete to happen NOW

        PasswordResetToken token = new PasswordResetToken(user);
        tokenRepository.save(token);

        // Send real email via SMTP
        String resetLink = "http://localhost:3086/reset-password?token=" + token.getToken();
        try {
            emailService.sendResetPasswordEmail(email, resetLink);
            System.out.println("✅ REAL PASSWORD RESET EMAIL SENT to: " + email);
        } catch (Exception e) {
            System.err.println("❌ FAILED TO SEND EMAIL: " + e.getMessage());
            throw new RuntimeException("Could not send reset email. Please check SMTP configuration.");
        }

        return "A password reset link has been sent to your email address (" + email + ").";
    }

    public void resetPassword(String token, String newPassword) {
        PasswordResetToken resetToken = tokenRepository.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Invalid or missing password reset token."));

        if (resetToken.isExpired()) {
            tokenRepository.delete(resetToken);
            throw new RuntimeException("This password reset token has expired (20 min limit).");
        }

        User user = resetToken.getUser();
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setRawPassword(newPassword);
        user.setForcePasswordChange(false);
        userRepository.save(user);

        // Delete token after successful use
        tokenRepository.delete(resetToken);
    }

    public void changePassword(String username, String newPassword) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setRawPassword(newPassword);
        user.setForcePasswordChange(false);
        userRepository.save(user);
    }
}
