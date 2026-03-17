package com.tjut.edu.vaccine_system.security;

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