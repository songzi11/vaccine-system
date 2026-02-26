package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 登录成功返回给前端的用户信息（id、username、role）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginUserVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String username;
    private String role;
}
