package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

/**
 * 用户端：接种点信息（含各疫苗库存、驻场医生），仅 status=启用 展示
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteWithStockVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String siteName;
    private String address;
    private String contactPhone;
    private String workTime;
    private Integer status;
    private String statusDesc;
    private String currentDoctorName;
    /** 各疫苗库存数量 */
    private List<SiteStockVO> stockList;
}
