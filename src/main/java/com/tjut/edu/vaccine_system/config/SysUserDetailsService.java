package com.tjut.edu.vaccine_system.config;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.tjut.edu.vaccine_system.model.entity.SysUser;
import com.tjut.edu.vaccine_system.model.enums.UserStatusEnum;
import com.tjut.edu.vaccine_system.service.SysUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

/**
 * 从 sys_user 表加载用户，供 Spring Security 使用。
 * 提供此 Bean 后不再生成默认的随机安全密码，避免启动时 WARN 日志。
 */
@Service
@RequiredArgsConstructor
public class SysUserDetailsService implements UserDetailsService {

    private final SysUserService sysUserService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        SysUser user = sysUserService.getOne(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username));
        if (user == null) {
            throw new UsernameNotFoundException("用户不存在: " + username);
        }
        UserStatusEnum statusEnum = UserStatusEnum.fromCode(user.getStatus());
        boolean enabled = statusEnum != null && statusEnum.canLogin();
        return User.builder()
                .username(user.getUsername())
                .password(user.getPassword())
                .authorities(Collections.singletonList(
                        new SimpleGrantedAuthority("ROLE_" + user.getRole())))
                .disabled(!enabled)
                .build();
    }
}
