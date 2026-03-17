package com.tjut.edu.vaccine_system.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 规则配置 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RuleConfigDTO {

    /**
     * 规则代码
     */
    private String ruleCode;

    /**
     * 规则名称
     */
    private String ruleName;

    /**
     * 规则组
     */
    private String ruleGroup;

    /**
     * 优先级
     */
    private Integer priority;

    /**
     * 是否启用
     */
    private Boolean enabled;

    /**
     * 规则参数 (JSON)
     */
    private String params;

    /**
     * 错误代码
     */
    private String errorCode;

    /**
     * 错误消息
     */
    private String errorMessage;
}