package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 热力图单格：按接种点、疫苗类型、时间维度
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HeatmapCellVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long siteId;
    private String siteName;
    private Long vaccineId;
    private String vaccineName;
    private String timeLabel;
    private Long count;
}
