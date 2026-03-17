package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 接种核销请求（医生/管理员操作：按预约完成接种并写入记录）
 * 批次号由后端从预约记录中自动获取（预约时已通过FEFO锁定），无需前端传入
 */
@Data
public class CreateRecordDTO {

    @NotNull(message = "预约ID不能为空")
    private Long appointmentId;
    private Long operatorUserId;
    private Integer doseNumber;
    /** 批次号由后端自动获取，前端无需传入 */
    private String batchNo;
    private String injectionSite;
    private Integer observationOk;
    private String reaction;
    /** 留观时长（分钟），默认30分钟 */
    private Integer observationMinutes;
}
