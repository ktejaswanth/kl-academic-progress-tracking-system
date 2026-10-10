package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendResetPasswordEmail(String to, String resetLink) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Reset Your Password - Academic Progress Tracking System");
        message.setText("Hello,\n\n" +
                "You requested to reset your password. Click the link below to set a new password:\n\n" +
                resetLink + "\n\n" +
                "This link will expire in 20 minutes.\n\n" +
                "If you did not request this, please ignore this email.\n\n" +
                "Regards,\n" +
                "Academic Progress Team");
        
        mailSender.send(message);
    }
}
