package com.tjut.edu.vaccine_system.rule.engine;

import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;

/**
 * 预约规则接口
 */
public interface AppointmentRule {

    /**
     * 获取规则代码
     */
    String getCode();

    /**
     * 获取规则名称
     */
    String getName();

    /**
     * 获取规则组
     */
    String getGroup();

    /**
     * 获取优先级
     */
    int getPriority();

    /**
     * 是否启用
     */
    boolean isEnabled();

    /**
     * 是否为必须通过的规则
     */
    boolean isMandatory();

    /**
     * 校验规则
     *
     * @param context 规则上下文
     * @return 规则执行结果
     */
    RuleResult validate(AppointmentRuleContext context);
}