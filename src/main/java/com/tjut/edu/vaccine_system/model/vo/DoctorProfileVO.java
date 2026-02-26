package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 医生个人信息 VO（供医生工作台展示，不含密码）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorProfileVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String username;
    private String realName;
    private String phone;
    private String role;
    private Integer gender;
    private String address;
}
