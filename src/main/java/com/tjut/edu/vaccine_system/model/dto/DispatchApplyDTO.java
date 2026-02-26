package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/** 医生调遣申请 DTO */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DispatchApplyDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "医生ID不能为空")
    private Long doctorId;
    @NotNull(message = "调出接种点ID不能为空")
    private Long fromSiteId;
    @NotNull(message = "调入接种点ID不能为空")
    private Long toSiteId;
}
