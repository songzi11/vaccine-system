package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/** 接种点库存-减少 DTO */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockReduceDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "疫苗ID不能为空")
    private Long vaccineId;
    /** 已废弃，接口固定每次-1，无需传 */
    private Integer quantity;
}
