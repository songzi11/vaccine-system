package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 医生排班表（排班先行）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("doctor_schedule")
public class DoctorSchedule implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long doctorId;
    private Long siteId;
    private LocalDate scheduleDate;
    private String timeSlot;
    private Integer maxCapacity;
    private Integer currentCount;
    /** 0-禁用 1-启用 */
    private Integer status;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
