package com.tjut.edu.vaccine_system.rule.result;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 规则执行结果
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RuleResult {
    /**
     * 是否通过
     */
    private boolean passed;

    /**
     * 规则代码
     */
    private String ruleCode;

    /**
     * 规则名称
     */
    private String ruleName;

    /**
     * 错误代码
     */
    private String errorCode;

    /**
     * 错误消息
     */
    private String errorMessage;
}