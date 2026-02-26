package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.tjut.edu.vaccine_system.model.enums.AppointmentStatusEnum;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 预约接种表
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("appointment")
public class Appointment implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long childId;
    private Long vaccineId;
    /** FEFO 分配的批次ID（预约成功时锁定） */
    private Long batchId;
    private Long siteId;
    /** 排班ID（预约时必选） */
    private Long doctorScheduleId;
    private LocalDate appointmentDate;
    private String timeSlot;
    /** 状态：1已预约 6已签到 7预检通过 9预检未通过 10留观中 2已完成 3已取消 4已过期 */
    private Integer status;
    private Long doctorId;
    private String remark;
    /** 留观开始时间（完成接种时写入） */
    private LocalDateTime observeStartTime;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /** 获取状态枚举（便于业务判断与展示） */
    public AppointmentStatusEnum getStatusEnum() {
        return AppointmentStatusEnum.fromCode(status);
    }
}
