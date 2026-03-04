package com.juanlopezaranzazu.backend.controllers;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import com.juanlopezaranzazu.backend.dtos.request.LoginRequest;
import com.juanlopezaranzazu.backend.dtos.request.RefreshTokenRequest;
import com.juanlopezaranzazu.backend.dtos.request.RegisterRequest;
import com.juanlopezaranzazu.backend.dtos.response.ApiResponse;
import com.juanlopezaranzazu.backend.dtos.response.AuthResponse;
import com.juanlopezaranzazu.backend.dtos.response.UserResponse;
import com.juanlopezaranzazu.backend.entities.User;
import com.juanlopezaranzazu.backend.services.AuthService;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse authResponse = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("User registered successfully", authResponse));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse authResponse = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Login successful", authResponse));
    }

    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<AuthResponse>> refreshToken(@Valid @RequestBody RefreshTokenRequest request) {
        AuthResponse authResponse = authService.refreshToken(request);
        return ResponseEntity.ok(ApiResponse.success("Token refreshed successfully", authResponse));
    }

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserResponse>> getCurrentUser(@AuthenticationPrincipal User currentUser) {
        UserResponse userResponse = authService.getCurrentUser(currentUser);
        return ResponseEntity.ok(ApiResponse.success(userResponse));
    }
}

