package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户详情（管理员查看：含关联儿童、预约、接种记录等）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDetailVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 用户基本信息（不含密码） */
    private Long id;
    private String username;
    private String realName;
    private String role;
    private Integer gender;
    private String phone;
    private String idCard;
    private String address;
    private String avatar;
    private Integer status;
    private String statusLabel;
    private LocalDateTime createTime;
    private LocalDateTime lastLoginTime;
    private LocalDateTime updateTime;

    /** 家长账号：关联儿童列表 */
    private List<ChildProfileSimpleVO> childList;
    /** 家长账号：预约列表 */
    private List<AppointmentSimpleVO> appointmentList;
    /** 家长账号：接种记录列表（record 表） */
    private List<RecordSimpleVO> recordList;

    /** 医生账号：今日预约数 */
    private Long todayAppointmentCount;
    /** 医生账号：历史接种数 */
    private Long historyRecordCount;
    /** 医生账号：排班/预约列表（按日期） */
    private List<AppointmentSimpleVO> scheduleList;
}
