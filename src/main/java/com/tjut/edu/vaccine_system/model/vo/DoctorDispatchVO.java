package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/** 医生调遣申请 VO（含调出/调入接种点名） */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorDispatchVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long doctorId;
    private String doctorName;
    private Long fromSiteId;
    private String fromSiteName;
    private Long toSiteId;
    private String toSiteName;
    private Integer status;
    private String statusDesc;
    private LocalDateTime applyTime;
    private LocalDateTime approveTime;
}
