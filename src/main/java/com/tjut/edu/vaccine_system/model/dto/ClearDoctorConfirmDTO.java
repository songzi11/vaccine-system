package com.tjut.edu.vaccine_system.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/** 清空驻场医生二次确认请求体 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClearDoctorConfirmDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 为 true 表示管理员已二次确认，执行清空并禁用接种点 */
    private Boolean confirmed;
}
