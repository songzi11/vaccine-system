package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * 接种点按批次库存行（含疫苗名、批号，用于展示与退回）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteStockBatchVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long siteId;
    private Long batchId;
    private Long vaccineId;
    private String vaccineName;
    private String batchNo;
    private LocalDate expiryDate;
    /** 可用库存（可退回部分） */
    private Integer availableStock;
    /** 锁定库存（已预约未核销） */
    private Integer lockedStock;
}
