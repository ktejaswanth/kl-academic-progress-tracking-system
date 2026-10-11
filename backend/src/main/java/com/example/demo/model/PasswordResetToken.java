package com.example.demo.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "password_reset_tokens")
@Data
@NoArgsConstructor
public class PasswordResetToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String token;

    @Column(name = "username")
    private String username;

    @Column(name = "user_id")
    private Long userId;

    @Column(nullable = false)
    private LocalDateTime expiryDate;

    public PasswordResetToken(String username, Long userId) {
        this.username = username;
        this.userId = userId;
        this.token = UUID.randomUUID().toString();
        // Set expiry to 20 minutes from now
        this.expiryDate = LocalDateTime.now().plusMinutes(20);
    }

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.expiryDate);
    }
}
