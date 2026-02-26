package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 每月接种趋势 VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MonthlyTrendVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String month;
    private Long count;
}
