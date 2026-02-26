package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/** 低库存预警 VO（疫苗+接种点维度，供管理员大屏展示） */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LowStockVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long vaccineId;
    private String vaccineName;
    private Long siteId;
    private String siteName;
    private Integer stock;
    private Integer warningThreshold;
}
