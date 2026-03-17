package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 管理员-接种点库存增加请求（从总仓按疫苗 FEFO 调拨至该接种点）
 */
@Data
public class StockAddDTO {

    @NotNull(message = "疫苗ID不能为空")
    private Long vaccineId;

    @NotNull(message = "增加数量不能为空")
    @Min(value = 1, message = "增加数量至少为1")
    private Integer quantity;
}
