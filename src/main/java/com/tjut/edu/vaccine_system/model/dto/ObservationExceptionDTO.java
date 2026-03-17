package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 异常终止留观请求
 */
@Data
public class ObservationExceptionDTO {

    @NotNull(message = "预约ID不能为空")
    private Long appointmentId;

    @NotBlank(message = "异常原因不能为空")
    private String reason;
}
