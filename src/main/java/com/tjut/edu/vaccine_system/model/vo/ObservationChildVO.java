package com.tjut.edu.vaccine_system.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 留观中儿童VO（医生端查看）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ObservationChildVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 预约ID */
    private Long appointmentId;

    /** 儿童ID */
    private Long childId;
    /** 儿童姓名 */
    private String childName;
    /** 性别 */
    private String childGender;
    /** 出生日期 */
    private LocalDate birthDate;
    /** 禁忌症 */
    private String contraindicationAllergy;

    /** 疫苗ID */
    private Long vaccineId;
    /** 疫苗名称 */
    private String vaccineName;
    /** 批次号 */
    private String batchNo;

    /** 留观开始时间 */
    private LocalDateTime observeStartTime;
    /** 留观时长（分钟） */
    private Integer observeDuration;
    /** 预计结束时间 */
    private LocalDateTime observeEndTime;
    /** 剩余时长（分钟） */
    private Integer remainingMinutes;
    /** 状态（留观中/待结束） */
    private String status;

    /** 接种点ID */
    private Long siteId;
    /** 医生ID */
    private Long doctorId;
}
