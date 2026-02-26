package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 接种点新增/修改 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotBlank(message = "接种点名称不能为空")
    private String siteName;
    private String address;
    private String contactPhone;
    private String workTime;
    /** 状态：0-禁用 1-启用，见 SiteStatusEnum */
    private Integer status;
    private String description;
}
