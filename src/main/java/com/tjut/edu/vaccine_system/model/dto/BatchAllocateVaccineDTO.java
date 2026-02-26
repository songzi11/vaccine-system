package com.tjut.edu.vaccine_system.model.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

/**
 * 管理员按接种点批量分配多种疫苗（总仓 FEFO 自动选批）
 */
@Data
public class BatchAllocateVaccineDTO {

    @NotNull(message = "接种点ID不能为空")
    private Long siteId;

    @NotEmpty(message = "至少选择一种疫苗及数量")
    @Valid
    private List<AllocateVaccineItem> items;

    @Data
    public static class AllocateVaccineItem {
        @NotNull(message = "疫苗ID不能为空")
        private Long vaccineId;

        @NotNull(message = "数量不能为空")
        @Min(value = 1, message = "数量至少为1")
        private Integer quantity;
    }
}
