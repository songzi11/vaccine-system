package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 接种点库存行 VO（某接种点下某疫苗的库存）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteStockVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long siteId;
    private Long vaccineId;
    private String vaccineName;
    /** 当前数量（与表字段 stock 对应） */
    private Integer quantity;
    private Integer warningThreshold;
}
