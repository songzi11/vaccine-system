package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 管理员按疫苗分配至接种点（免选批次，总仓 FEFO 自动选批）
 */
@Data
public class AllocateVaccineDTO {

    @NotNull(message = "接种点ID不能为空")
    private Long siteId;

    @NotNull(message = "疫苗ID不能为空")
    private Long vaccineId;

    @NotNull(message = "数量不能为空")
    @Min(value = 1, message = "数量至少为1")
    private Integer quantity;
}
