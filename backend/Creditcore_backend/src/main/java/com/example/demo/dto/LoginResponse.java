package com.example.demo.dto;

import com.example.demo.model.UserRole;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private String username;
    private String role;
    private Boolean forcePasswordChange;
    private String firstName;
    private String lastName;
}
