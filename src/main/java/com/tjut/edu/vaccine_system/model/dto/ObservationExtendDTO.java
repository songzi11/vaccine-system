package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 延长留观时间请求
 */
@Data
public class ObservationExtendDTO {

    @NotNull(message = "预约ID不能为空")
    private Long appointmentId;

    @NotNull(message = "延长分钟数不能为空")
    @Min(value = 1, message = "延长分钟数至少为1")
    private Integer extendMinutes;
}
