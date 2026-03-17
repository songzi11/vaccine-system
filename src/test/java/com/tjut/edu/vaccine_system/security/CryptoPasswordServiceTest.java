package com.tjut.edu.vaccine_system.security;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class CryptoPasswordServiceTest {

    @Autowired
    private CryptoPasswordService cryptoPasswordService;

    @Test
    void testEncodeShouldReturnBCryptHash() {
        // Given
        String rawPassword = "test123";

        // When
        String encoded = cryptoPasswordService.encode(rawPassword);

        // Then
        assertNotNull(encoded);
        assertTrue(encoded.startsWith("$2"));
        assertNotEquals(rawPassword, encoded);
    }

    @Test
    void testMatchesShouldReturnTrueForCorrectPassword() {
        // Given
        String rawPassword = "test123";
        String encoded = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";

        // When
        boolean matches = cryptoPasswordService.matches(rawPassword, encoded);

        // Then
        assertTrue(matches);
    }

    @Test
    void testMatchesShouldReturnFalseForWrongPassword() {
        // Given
        String rawPassword = "wrongpassword";
        String encoded = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";

        // When
        boolean matches = cryptoPasswordService.matches(rawPassword, encoded);

        // Then
        assertFalse(matches);
    }

    @Test
    void testIsEncodedShouldReturnTrueForBCryptHash() {
        // Given
        String bcryptHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";

        // When
        boolean isEncoded = cryptoPasswordService.isEncoded(bcryptHash);

        // Then
        assertTrue(isEncoded);
    }

    @Test
    void testIsEncodedShouldReturnFalseForPlainText() {
        // Given
        String plainText = "password123";

        // When
        boolean isEncoded = cryptoPasswordService.isEncoded(plainText);

        // Then
        assertFalse(isEncoded);
    }
}