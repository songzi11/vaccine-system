package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 疫苗库存统计 VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VaccineStockVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long vaccineId;
    private String vaccineName;
    private Long stock;
}
