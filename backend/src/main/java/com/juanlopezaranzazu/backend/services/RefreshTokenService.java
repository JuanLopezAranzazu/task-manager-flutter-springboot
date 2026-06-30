package com.juanlopezaranzazu.backend.services;

import com.juanlopezaranzazu.backend.entities.RefreshToken;
import com.juanlopezaranzazu.backend.entities.User;

public interface RefreshTokenService {
    RefreshToken createRefreshToken(User user);
    RefreshToken verifyExpiration(RefreshToken token);
    void deleteByUser(User user);
}
