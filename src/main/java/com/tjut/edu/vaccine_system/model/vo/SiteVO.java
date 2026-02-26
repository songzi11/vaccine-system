package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 接种点列表/简要详情 VO（不直接返回 entity）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SiteVO implements Serializable {

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
}
