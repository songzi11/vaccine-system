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
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
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

        // 从数据库获取最新密码（可能已被加密）
        SysUser dbUser = sysUserMapper.selectOne(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, userDetails.getUsername()));

        if (dbUser == null) {
            throw new BadCredentialsException("用户不存在");
        }

        String dbPassword = dbUser.getPassword();

        // 判断数据库密码是否已加密
        if (cryptoPasswordService.isEncoded(dbPassword)) {
            // 已加密：使用 BCrypt 匹配
            super.additionalAuthenticationChecks(userDetails, authentication);
        } else {
            // 未加密（明文）：尝试明文匹配
            if (rawPassword != null && rawPassword.equals(dbPassword)) {
                // 明文匹配成功，升级密码
                upgradePasswordToBCrypt(userDetails.getUsername(), rawPassword);
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