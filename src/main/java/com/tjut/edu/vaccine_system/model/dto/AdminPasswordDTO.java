package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 管理员密码确认（如注销账号时校验当前登录人密码）
 */
@Data
public class AdminPasswordDTO {

    @NotBlank(message = "请输入管理员密码")
    private String adminPassword;
}
