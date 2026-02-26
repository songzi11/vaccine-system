package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 医生审核预约请求
 */
@Data
public class ReviewAppointmentDTO {

    @NotNull(message = "审核结果不能为空")
    private Boolean approved;
    private Long doctorId;
}
