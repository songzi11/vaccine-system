package com.tjut.edu.vaccine_system.service;

import com.tjut.edu.vaccine_system.model.dto.RegisterDTO;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class SysUserServiceTest {

    @Autowired
    private SysUserService sysUserService;

    @Test
    void testLoginSuccess() {
        // Given: 先注册一个用户
        RegisterDTO registerDTO = new RegisterDTO();
        registerDTO.setUsername("testuser_" + System.currentTimeMillis());
        registerDTO.setPassword("password123");
        registerDTO.setRole("RESIDENT");

        SysUser registered = sysUserService.register(registerDTO);
        assertNotNull(registered.getId());

        // When: 登录
        Optional<SysUser> result = sysUserService.login(registerDTO.getUsername(), registerDTO.getPassword());

        // Then: 登录成功
        assertTrue(result.isPresent());
        assertEquals(registerDTO.getUsername(), result.get().getUsername());
    }

    @Test
    void testLoginWrongPassword() {
        // Given: 注册用户
        RegisterDTO registerDTO = new RegisterDTO();
        registerDTO.setUsername("testuser2_" + System.currentTimeMillis());
        registerDTO.setPassword("correctpassword");
        registerDTO.setRole("RESIDENT");

        sysUserService.register(registerDTO);

        // When: 使用错误密码登录
        Optional<SysUser> result = sysUserService.login(registerDTO.getUsername(), "wrongpassword");

        // Then: 登录失败
        assertTrue(result.isEmpty());
    }

    @Test
    void testIsUsernameValid() {
        // Given: 注册用户
        String username = "validuser_" + System.currentTimeMillis();
        RegisterDTO registerDTO = new RegisterDTO();
        registerDTO.setUsername(username);
        registerDTO.setPassword("password123");
        registerDTO.setRole("RESIDENT");

        sysUserService.register(registerDTO);

        // When: 校验用户名
        boolean valid = sysUserService.isUsernameValid(username);
        boolean invalid = sysUserService.isUsernameValid("nonexistent_user_12345");

        // Then
        assertTrue(valid);
        assertFalse(invalid);
    }
}