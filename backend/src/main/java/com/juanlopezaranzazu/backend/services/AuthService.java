package com.juanlopezaranzazu.backend.services;

import com.juanlopezaranzazu.backend.dtos.AuthResponse;
import com.juanlopezaranzazu.backend.dtos.LoginRequest;
import com.juanlopezaranzazu.backend.dtos.RefreshTokenRequest;
import com.juanlopezaranzazu.backend.dtos.RegisterRequest;
import com.juanlopezaranzazu.backend.dtos.UserResponse;
import com.juanlopezaranzazu.backend.entities.User;

public interface AuthService {
    AuthResponse register(RegisterRequest request);
    AuthResponse login(LoginRequest request);
    AuthResponse refreshToken(RefreshTokenRequest request);
    UserResponse getCurrentUser(User currentUser);
}
