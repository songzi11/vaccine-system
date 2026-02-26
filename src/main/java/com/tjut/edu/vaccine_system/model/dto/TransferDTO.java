package com.tjut.edu.vaccine_system.model.dto;

import lombok.Data;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * 总仓 -> 接种点 调拨请求
 */
@Data
public class TransferDTO {

    @NotNull(message = "批次ID不能为空")
    private Long batchId;

    @NotNull(message = "接种点ID不能为空")
    private Long siteId;

    @NotNull(message = "调拨数量不能为空")
    @Min(value = 1, message = "调拨数量至少为1")
    private Integer quantity;
}
