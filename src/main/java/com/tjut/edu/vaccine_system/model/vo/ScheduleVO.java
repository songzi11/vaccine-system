package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * 排班VO（带是否已被预约标记）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ScheduleVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 排班ID */
    private Long id;

    /** 医生ID */
    private Long doctorId;

    /** 医生姓名 */
    private String doctorName;

    /** 接种点ID */
    private Long siteId;

    /** 排班日期 */
    private LocalDate scheduleDate;

    /** 时段 */
    private String timeSlot;

    /** 最大容量 */
    private Integer maxCapacity;

    /** 当前预约数 */
    private Integer currentCount;

    /** 是否已被预约（true=已被占用，不可选） */
    private Boolean booked;

    /** 是否已过期（true=当天时间已过去，不可选） */
    private Boolean expired;

    /** 排班状态 0-禁用 1-启用 */
    private Integer status;
}
