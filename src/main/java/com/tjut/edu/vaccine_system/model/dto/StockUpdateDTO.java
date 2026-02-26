package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/** 接种点库存-更新预警阈值 DTO */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockUpdateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "库存记录ID不能为空")
    private Long stockId;
    @NotNull(message = "预警阈值不能为空")
    @Min(value = 0, message = "预警阈值不能为负")
    private Integer warningThreshold;
}
