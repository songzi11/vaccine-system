package com.tjut.edu.vaccine_system.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 接种点按疫苗汇总可用库存（来自 site_vaccine_stock + vaccine_batch + vaccine）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteVaccineStockSummaryDTO {

    private Long vaccineId;
    private String vaccineName;
    private Integer quantity;
}
