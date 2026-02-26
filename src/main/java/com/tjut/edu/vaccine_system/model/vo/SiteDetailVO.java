package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 接种点详情 VO（管理员）：基础信息 + 库存列表 + 驻场医生 + 今日预约人数
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteDetailVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String siteName;
    private String address;
    private String contactPhone;
    private String workTime;
    private Integer status;
    private String statusDesc;
    private String description;
    private Long currentDoctorId;
    private String currentDoctorName;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    /** 该接种点库存列表（各疫苗） */
    private List<SiteStockVO> stockList;
    /** 今日预约人数 */
    private Long todayAppointmentCount;
}
