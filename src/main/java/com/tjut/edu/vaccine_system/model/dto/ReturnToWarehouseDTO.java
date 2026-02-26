package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 接种点向总仓退回疫苗（按批次退回，只退可用库存）
 */
@Data
public class ReturnToWarehouseDTO {

    @NotNull(message = "接种点ID不能为空")
    private Long siteId;

    @NotNull(message = "批次ID不能为空")
    private Long batchId;

    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量至少为1")
    private Integer quantity;
}
