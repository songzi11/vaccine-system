package com.tjut.edu.vaccine_system.rule.engine;

import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;

import java.util.List;

/**
 * 规则引擎接口
 */
public interface RuleEngine {

    /**
     * 执行规则校验
     *
     * @param ruleGroup 规则组
     * @param context   规则上下文
     * @return 规则执行结果
     */
    RuleResult validate(String ruleGroup, AppointmentRuleContext context);

    /**
     * 执行所有规则
     *
     * @param ruleGroup 规则组
     * @param context   规则上下文
     * @return 规则执行结果列表
     */
    List<RuleResult> validateAll(String ruleGroup, AppointmentRuleContext context);

    /**
     * 刷新规则缓存
     */
    void refreshRules();
}