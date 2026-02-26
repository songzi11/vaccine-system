package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * 注册请求参数（角色：家长/医生/管理员）
 */
@Data
public class RegisterDTO {

    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "密码不能为空")
    private String password;

    /** 角色：RESIDENT-家长，DOCTOR-医生，ADMIN-管理员 */
    @NotBlank(message = "请选择角色")
    @Pattern(regexp = "^(RESIDENT|DOCTOR|ADMIN)$", message = "角色必须为 RESIDENT/DOCTOR/ADMIN")
    private String role;

    private String realName;
    private String phone;
    private String address;
}
