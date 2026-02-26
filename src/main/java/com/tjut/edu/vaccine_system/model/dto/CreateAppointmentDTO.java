package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 预约创建请求（前端传 orderDate/orderTime，对应实体 appointmentDate/timeSlot）
 */
@Data
public class CreateAppointmentDTO {

    @NotNull(message = "疫苗ID不能为空")
    private Long vaccineId;
    @NotNull(message = "请选择排班（医生班次）")
    private Long doctorScheduleId;
    private String orderDate;
    private String orderTime;
    private Long userId;
    private Long childId;
    private Long siteId;
    private String remark;
}
