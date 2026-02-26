package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/** 接种点库存-直接设置数量 DTO（管理员修正用） */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockSetQuantityDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "库存记录ID不能为空")
    private Long stockId;
    @NotNull(message = "数量不能为空")
    @Min(value = 0, message = "数量不能为负")
    private Integer quantity;
}
