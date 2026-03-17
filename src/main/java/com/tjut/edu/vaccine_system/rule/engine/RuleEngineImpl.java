package com.tjut.edu.vaccine_system.rule.engine;

import com.tjut.edu.vaccine_system.rule.config.RuleConfigLoader;
import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.registry.RuleRegistry;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * 规则引擎默认实现
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RuleEngineImpl implements RuleEngine {

    private final RuleRegistry ruleRegistry;
    private final RuleConfigLoader ruleConfigLoader;

    @Override
    public RuleResult validate(String ruleGroup, AppointmentRuleContext context) {
        List<RuleResult> results = validateAll(ruleGroup, context);
        // 返回第一个未通过的结果，如果没有则返回通过
        return results.stream()
                .filter(r -> !r.isPassed())
                .findFirst()
                .orElse(RuleResult.builder()
                        .passed(true)
                        .ruleCode("ALL")
                        .ruleName("全部规则")
                        .build());
    }

    @Override
    public List<RuleResult> validateAll(String ruleGroup, AppointmentRuleContext context) {
        List<RuleResult> results = new ArrayList<>();

        // 获取规则组中的所有规则，按优先级排序
        List<AppointmentRule> rules = ruleRegistry.getRules(ruleGroup);
        rules.sort(Comparator.comparingInt(AppointmentRule::getPriority));

        for (AppointmentRule rule : rules) {
            try {
                // 检查规则是否启用
                if (!rule.isEnabled()) {
                    continue;
                }
                RuleResult result = rule.validate(context);
                results.add(result);
                // 如果规则未通过且为必须通过的规则，可以选择停止
                if (!result.isPassed() && rule.isMandatory()) {
                    log.debug("Rule {} failed, stopping validation", rule.getCode());
                    break;
                }
            } catch (Exception e) {
                log.error("Error executing rule: {}", rule.getCode(), e);
                results.add(RuleResult.builder()
                        .passed(false)
                        .ruleCode(rule.getCode())
                        .ruleName(rule.getName())
                        .errorCode("RULE_EXECUTION_ERROR")
                        .errorMessage("规则执行异常: " + e.getMessage())
                        .build());
            }
        }

        return results;
    }

    @Override
    public void refreshRules() {
        log.info("Refreshing rule cache");
        ruleRegistry.refreshRules();
        ruleConfigLoader.refresh();
    }
}