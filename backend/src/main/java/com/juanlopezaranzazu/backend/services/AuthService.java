package com.juanlopezaranzazu.backend.services;

import com.juanlopezaranzazu.backend.dtos.request.LoginRequest;
import com.juanlopezaranzazu.backend.dtos.request.RefreshTokenRequest;
import com.juanlopezaranzazu.backend.dtos.request.RegisterRequest;
import com.juanlopezaranzazu.backend.dtos.response.AuthResponse;
import com.juanlopezaranzazu.backend.dtos.response.UserResponse;
import com.juanlopezaranzazu.backend.entities.User;

public interface AuthService {
    AuthResponse register(RegisterRequest request);
    AuthResponse login(LoginRequest request);
    AuthResponse refreshToken(RefreshTokenRequest request);
    UserResponse getCurrentUser(User currentUser);
}
