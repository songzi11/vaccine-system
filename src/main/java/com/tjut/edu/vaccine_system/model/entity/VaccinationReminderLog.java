package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 智能提醒推送记录（如脊灰第3剂提前72小时推送预约链接）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("vaccination_reminder_log")
public class VaccinationReminderLog implements Serializable {

    private static final long serialVersionUID = 1L;

    public static final String REMIND_TYPE_SCHEDULE_72H = "SCHEDULE_72H";
    public static final String PUSH_CHANNEL_WECHAT = "WECHAT";
    public static final String PUSH_CHANNEL_APP = "APP";
    public static final String PUSH_CHANNEL_SMS = "SMS";

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long childId;
    private Long userId;
    private Long vaccineId;
    private String vaccineName;
    private Integer doseNumber;
    private String remindType;
    private String appointmentLink;
    private String pushChannel;
    private LocalDateTime pushTime;
    private LocalDateTime createTime;
}
