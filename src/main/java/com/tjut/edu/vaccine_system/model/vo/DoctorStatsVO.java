package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 医生账号统计（管理员查看）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorStatsVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户基本信息（不含密码） */
    private Long id;
    private String username;
    private String realName;
    private String role;
    private Integer status;
    private String statusLabel;
    private LocalDateTime createTime;
    private LocalDateTime lastLoginTime;

    /** 排班/预约列表（按医生） */
    private List<AppointmentSimpleVO> scheduleList;
    /** 今日预约数 */
    private Long todayAppointmentCount;
    /** 历史接种数（record 表） */
    private Long historyRecordCount;
}
