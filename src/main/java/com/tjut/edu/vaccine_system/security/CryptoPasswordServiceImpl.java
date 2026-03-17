package com.tjut.edu.vaccine_system.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * 密码加密服务实现
 */
@Service
public class CryptoPasswordServiceImpl implements CryptoPasswordService {

    private final PasswordEncoder passwordEncoder;

    public CryptoPasswordServiceImpl() {
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    @Override
    public String encode(String rawPassword) {
        if (rawPassword == null) {
            return null;
        }
        return passwordEncoder.encode(rawPassword);
    }

    @Override
    public boolean matches(String rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null) {
            return false;
        }
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }

    @Override
    public boolean isEncoded(String password) {
        if (password == null) {
            return false;
        }
        // BCrypt 加密后的密码以 $2a$/$2b$/$2y$ 开头
        return password.matches("^\\$2[aby]\\$\\d{2}\\$.{53}$");
    }
}