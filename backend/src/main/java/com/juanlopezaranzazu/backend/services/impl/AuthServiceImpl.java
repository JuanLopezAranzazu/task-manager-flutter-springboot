package com.juanlopezaranzazu.backend.services.impl;

import com.juanlopezaranzazu.backend.dtos.AuthResponse;
import com.juanlopezaranzazu.backend.dtos.LoginRequest;
import com.juanlopezaranzazu.backend.dtos.RefreshTokenRequest;
import com.juanlopezaranzazu.backend.dtos.RegisterRequest;
import com.juanlopezaranzazu.backend.dtos.UserResponse;
import com.juanlopezaranzazu.backend.entities.RefreshToken;
import com.juanlopezaranzazu.backend.entities.User;
import com.juanlopezaranzazu.backend.exceptions.BadRequestException;
import com.juanlopezaranzazu.backend.exceptions.TokenException;
import com.juanlopezaranzazu.backend.repositories.RefreshTokenRepository;
import com.juanlopezaranzazu.backend.repositories.UserRepository;
import com.juanlopezaranzazu.backend.security.JwtService;
import com.juanlopezaranzazu.backend.services.AuthService;
import com.juanlopezaranzazu.backend.services.RefreshTokenService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final RefreshTokenService refreshTokenService;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Email is already registered: " + request.getEmail());
        }

        User user = User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(User.Role.USER)
                .build();

        userRepository.save(user);
        log.info("New user registered: {}", user.getEmail());

        return buildAuthResponse(user);
    }

    @Override
    @Transactional
    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new BadRequestException("User not found"));

        log.info("User logged in: {}", user.getEmail());
        return buildAuthResponse(user);
    }

    @Override
    @Transactional
    public AuthResponse refreshToken(RefreshTokenRequest request) {
        RefreshToken refreshToken = refreshTokenRepository.findByToken(request.getRefreshToken())
                .orElseThrow(() -> new TokenException("Invalid refresh token"));

        refreshToken = refreshTokenService.verifyExpiration(refreshToken);
        User user = refreshToken.getUser();

        String newAccessToken = jwtService.generateAccessToken(user);
        RefreshToken newRefreshToken = refreshTokenService.createRefreshToken(user);

        return AuthResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(newRefreshToken.getToken())
                .expiresIn(jwtService.getAccessTokenExpiration())
                .user(UserResponse.fromUser(user))
                .build();
    }

    @Override
    public UserResponse getCurrentUser(User currentUser) {
        return UserResponse.fromUser(currentUser);
    }

    private AuthResponse buildAuthResponse(User user) {
        String accessToken = jwtService.generateAccessToken(user);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(user);

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken.getToken())
                .expiresIn(jwtService.getAccessTokenExpiration())
                .user(UserResponse.fromUser(user))
                .build();
    }
}