package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

/**
 * 批次销毁请求（管理员确认后执行）
 */
@Data
public class BatchDisposeDTO {

    @NotNull(message = "批次ID不能为空")
    private Long batchId;
    /** 销毁原因，如：过期销毁 */
    private String disposalReason;
    /** 销毁日期，默认当天 */
    private LocalDate disposalDate;
    /** 操作人ID（可从登录上下文获取） */
    private Long operatorId;
    private String remark;
}
