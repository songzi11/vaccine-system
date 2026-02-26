package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 排班列表 VO（含医生状态，用于前端判断是否可操作）
 * doctorStatus：0=正常 1=已禁用 2=已注销；仅正常状态可编辑/删除
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorScheduleListVO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long doctorId;
    private Long siteId;
    private LocalDate scheduleDate;
    private String timeSlot;
    private Integer maxCapacity;
    private Integer currentCount;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    /** 医生用户状态：0=正常 1=已禁用 2=已注销；注销/禁用时不可操作 */
    private Integer doctorStatus;
}
