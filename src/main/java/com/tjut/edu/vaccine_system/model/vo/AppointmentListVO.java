package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 用户端-我的预约列表项（含疫苗名、宝宝名、接种点名）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentListVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long userId;
    private Long childId;
    private Long vaccineId;
    private Long siteId;
    private LocalDate appointmentDate;
    private String timeSlot;
    private Integer status;
    /** 状态文案，与后端 AppointmentStatusEnum 一致 */
    private String statusLabel;
    private Long doctorId;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    private String vaccineName;
    private String childName;
    private String siteName;
    /** 预约是否因医生账号注销/禁用而无法审批，家长可再次预约 */
    private Boolean doctorUnavailable;
}
