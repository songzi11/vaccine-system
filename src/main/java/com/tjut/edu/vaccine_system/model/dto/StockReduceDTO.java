package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 管理员-接种点库存减少请求（按疫苗 FEFO 扣减可用库存，不退回总仓）
 */
@Data
public class StockReduceDTO {

    @NotNull(message = "疫苗ID不能为空")
    private Long vaccineId;

    /** 减少数量，不传或传 0 时按 1 处理 */
    @Min(value = 1, message = "减少数量至少为1")
    private Integer quantity = 1;
}
