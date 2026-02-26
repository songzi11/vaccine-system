package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 接种核销请求（医生/管理员操作：按预约完成接种并写入记录）
 */
@Data
public class CreateRecordDTO {

    @NotNull(message = "预约ID不能为空")
    private Long appointmentId;
    private Long operatorUserId;
    private Integer doseNumber;
    private String batchNo;
    private String injectionSite;
    private Integer observationOk;
    private String reaction;
}
