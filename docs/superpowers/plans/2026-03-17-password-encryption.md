# 密码加密存储实现计划

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将用户密码从明文存储升级为 BCrypt 加密，同时保持对老用户的兼容性

**Architecture:** 通过自定义 Spring Security DaoAuthenticationProvider 在认证层完成密码校验和升级，不修改现有业务代码

**Tech Stack:** Spring Security BCryptPasswordEncoder, Spring AOP

---

## 文件结构

```
src/main/java/com/tjut/edu/vaccine_system/
├── security/
│   ├── CryptoPasswordService.java           # 加密服务接口
│   ├── CryptoPasswordServiceImpl.java       # 加密服务实现
│   └── config/
│       └── SecurityConfig.java              # Spring Security 配置（扩展）
```

---

## Chunk 1: 加密服务基础实现

**Files:**
- Create: `src/main/java/com/tjut/edu/vaccine_system/security/CryptoPasswordService.java`
- Create: `src/main/java/com/tjut/edu/vaccine_system/security/CryptoPasswordServiceImpl.java`
- Test: `src/test/java/com/tjut/edu/vaccine_system/security/CryptoPasswordServiceTest.java`

- [ ] **Step 1: 创建 CryptoPasswordService 接口**

```java
package com.tjut.edu.vaccine_system.security;

import java.util.Optional;

/**
 * 密码加密服务接口
 */
public interface CryptoPasswordService {

    /**
     * 使用 BCrypt 加密密码
     * @param rawPassword 明文密码
     * @return 加密后的密码
     */
    String encode(String rawPassword);

    /**
     * 校验密码（兼容明文和加密两种）
     * @param rawPassword 明文密码
     * @param encodedPassword 加密后的密码
     * @return 是否匹配
     */
    boolean matches(String rawPassword, String encodedPassword);

    /**
     * 判断密码是否已加密
     * @param password 密码
     * @return 是否已加密
     */
    boolean isEncoded(String password);
}
```

- [ ] **Step 2: 创建 CryptoPasswordServiceImpl 实现**

```java
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
```

- [ ] **Step 3: 创建单元测试 CryptoPasswordServiceTest**

```java
package com.tjut.edu.vaccine_system.security;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class CryptoPasswordServiceTest {

    @MockBean
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
```

- [ ] **Step 4: 运行测试验证实现**

Run: `mvn test -Dtest=CryptoPasswordServiceTest -DfailIfNoTests=false`
Expected: BUILD SUCCESS

- [ ] **Step 5: 提交代码**

```bash
git add src/main/java/com/tjut/edu/vaccine_system/security/CryptoPasswordService.java
git add src/main/java/com/tjut/edu/vaccine_system/security/CryptoPasswordServiceImpl.java
git add src/test/java/com/tjut/edu/vaccine_system/security/CryptoPasswordServiceTest.java
git commit -m "feat(security): add password encryption service with BCrypt"
```

---

## Chunk 2: 认证层集成

**Files:**
- Create: `src/main/java/com/tjut/edu/vaccine_system/security/CompatibleDaoAuthenticationProvider.java`
- Modify: `src/main/java/com/tjut/edu/vaccine_system/config/SecurityConfig.java` (如需要)

- [ ] **Step 1: 创建 CompatibleDaoAuthenticationProvider**

```java
package com.tjut.edu.vaccine_system.security;

import com.tjut.edu.vaccine_system.mapper.SysUserMapper;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * 兼容型认证提供者，支持明文和 BCrypt 两种密码格式
 * 首次登录时自动将明文密码迁移为 BCrypt
 */
@Component
public class CompatibleDaoAuthenticationProvider extends DaoAuthenticationProvider {

    private final CryptoPasswordService cryptoPasswordService;
    private final SysUserMapper sysUserMapper;

    @Autowired
    public CompatibleDaoAuthenticationProvider(
            CryptoPasswordService cryptoPasswordService,
            SysUserMapper sysUserMapper,
            UserDetailsService userDetailsService,
            PasswordEncoder passwordEncoder) {
        super.setUserDetailsService(userDetailsService);
        super.setPasswordEncoder(passwordEncoder);
        this.cryptoPasswordService = cryptoPasswordService;
        this.sysUserMapper = sysUserMapper;
    }

    @Override
    protected void additionalAuthenticationChecks(UserDetails userDetails,
            UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        String rawPassword = (String) authentication.getCredentials();
        String dbPassword = ((SysUser) userDetails).getPassword();

        // 判断数据库密码是否已加密
        if (cryptoPasswordService.isEncoded(dbPassword)) {
            // 已加密：使用 BCrypt 匹配
            try {
                super.additionalAuthenticationChecks(userDetails, authentication);
            } catch (BadCredentialsException e) {
                throw new BadCredentialsException("密码错误");
            }
        } else {
            // 未加密（明文）：尝试明文匹配
            if (rawPassword != null && rawPassword.equals(dbPassword)) {
                // 明文匹配成功，升级密码
                upgradePasswordToBCrypt(userDetails.getUsername(), rawPassword);
                // 设置认证成功
                authentication.setAuthenticated(true);
            } else {
                throw new BadCredentialsException("密码错误");
            }
        }
    }

    /**
     * 将明文密码升级为 BCrypt
     */
    private void upgradePasswordToBCrypt(String username, String rawPassword) {
        try {
            String encoded = cryptoPasswordService.encode(rawPassword);
            SysUser user = sysUserMapper.selectOne(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username));
            if (user != null) {
                user.setPassword(encoded);
                sysUserMapper.updateById(user);
            }
        } catch (Exception e) {
            // 密码升级失败不影响登录，但记录日志
            // 可使用 Spring Event 异步处理
        }
    }
}
```

- [ ] **Step 2: 修改 SecurityConfig 注册自定义 AuthenticationProvider**

首先检查现有的 SecurityConfig：

```bash
cat src/main/java/com/tjut/edu/vaccine_system/config/SecurityConfig.java
```

然后添加：

```java
@Autowired
private CompatibleDaoAuthenticationProvider compatibleDaoAuthenticationProvider;

@Bean
public AuthenticationManager authenticationManager() {
    ProviderManager providerManager = new ProviderManager(compatibleDaoAuthenticationProvider);
    return providerManager;
}
```

- [ ] **Step 3: 验证编译**

Run: `mvn compile -DskipTests`
Expected: BUILD SUCCESS

- [ ] **Step 4: 提交代码**

```bash
git add src/main/java/com/tjut/edu/vaccine_system/security/CompatibleDaoAuthenticationProvider.java
git add src/main/java/com/tjut/edu/vaccine_system/config/SecurityConfig.java
git commit -m "feat(security): integrate password encryption with Spring Security"
```

---

## Chunk 3: 测试验证

**Files:**
- Test: `src/test/java/com/tjut/edu/vaccine_system/security/CompatibleDaoAuthenticationProviderTest.java`

- [ ] **Step 1: 创建认证提供者测试**

```java
package com.tjut.edu.vaccine_system.security;

import com.tjut.edu.vaccine_system.model.entity.SysUser;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CompatibleDaoAuthenticationProviderTest {

    @Mock
    private CryptoPasswordService cryptoPasswordService;

    @Mock
    private SysUserMapper sysUserMapper;

    @Mock
    private UserDetailsService userDetailsService;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private CompatibleDaoAuthenticationProvider provider;

    private SysUser testUser;

    @BeforeEach
    void setUp() {
        testUser = new SysUser();
        testUser.setId(1L);
        testUser.setUsername("testuser");
        testUser.setPassword("plaintextpassword");
    }

    @Test
    void testAuthenticateWithPlainTextPasswordShouldUpgrade() throws Exception {
        // Given
        UserDetails userDetails = testUser;
        UsernamePasswordAuthenticationToken token =
            new UsernamePasswordAuthenticationToken("testuser", "plaintextpassword");

        when(userDetailsService.loadUserByUsername("testuser")).thenReturn(userDetails);
        when(cryptoPasswordService.isEncoded("plaintextpassword")).thenReturn(false);

        // When
        provider.authenticate(token);

        // Then
        verify(cryptoPasswordService).encode("plaintextpassword");
        verify(sysUserMapper).updateById(any(SysUser.class));
    }

    @Test
    void testAuthenticateWithEncodedPasswordShouldUseBCrypt() throws Exception {
        // Given
        String encodedPassword = "$2a$10$encodedpasswordhash";
        testUser.setPassword(encodedPassword);
        UserDetails userDetails = testUser;
        UsernamePasswordAuthenticationToken token =
            new UsernamePasswordAuthenticationToken("testuser", "rawpassword");

        when(userDetailsService.loadUserByUsername("testuser")).thenReturn(userDetails);
        when(cryptoPasswordService.isEncoded(encodedPassword)).thenReturn(true);
        when(passwordEncoder.matches("rawpassword", encodedPassword)).thenReturn(true);

        // When
        var result = provider.authenticate(token);

        // Then
        assertNotNull(result);
        verify(sysUserMapper, never()).updateById(any());
    }
}
```

- [ ] **Step 2: 运行测试**

Run: `mvn test -Dtest=CompatibleDaoAuthenticationProviderTest -DfailIfNoTests=false`
Expected: BUILD SUCCESS

- [ ] **Step 3: 提交代码**

```bash
git add src/test/java/com/tjut/edu/vaccine_system/security/CompatibleDaoAuthenticationProviderTest.java
git commit -m "test(security): add authentication provider tests"
```

---

## 验收标准

- [ ] 新注册用户密码自动加密存储
- [ ] 老用户首次登录自动迁移到 BCrypt
- [ ] 登录验证通过 BCrypt 匹配
- [ ] 单元测试覆盖率 > 80%
- [ ] 现有业务代码零修改