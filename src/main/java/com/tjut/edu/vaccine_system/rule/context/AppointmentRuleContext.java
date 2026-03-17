package com.tjut.edu.vaccine_system.rule.context;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * 预约校验上下文
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentRuleContext {
    /**
     * 儿童 ID
     */
    private Long childId;

    /**
     * 儿童出生日期
     */
    private LocalDate birthDate;

    /**
     * 疫苗 ID
     */
    private Long vaccineId;

    /**
     * 疫苗适用起始月龄
     */
    private Integer applicableAgeMonths;

    /**
     * 疫苗接种间隔天数
     */
    private Integer intervalDays;

    /**
     * 儿童禁忌症/过敏史
     */
    private String contraindicationAllergy;

    /**
     * 疫苗描述（含禁忌信息）
     */
    private String vaccineDescription;

    /**
     * 不良反应描述
     */
    private String adverseReactionDesc;

    /**
     * 预约日期
     */
    private LocalDate appointmentDate;

    /**
     * 上次接种日期
     */
    private LocalDate lastVaccinationDate;
}