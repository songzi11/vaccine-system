package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 管理员用户列表项（含状态标签、创建时间、最后登录时间）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserListVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String username;
    private String realName;
    private String role;
    private Integer gender;
    private String phone;
    private String idCard;
    private String address;
    private String avatar;
    /** 状态码：0=正常 1=已禁用 2=已注销 */
    private Integer status;
    /** 状态标签：正常/已禁用/已注销 */
    private String statusLabel;
    private LocalDateTime createTime;
    private LocalDateTime lastLoginTime;
    private LocalDateTime updateTime;
}
