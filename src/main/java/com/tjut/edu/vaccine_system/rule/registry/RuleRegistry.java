package com.tjut.edu.vaccine_system.rule.registry;

import com.tjut.edu.vaccine_system.rule.annotation.Rule;
import com.tjut.edu.vaccine_system.rule.engine.AppointmentRule;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * 规则注册表
 */
@Slf4j
@Component
public class RuleRegistry {

    @Autowired
    private ApplicationContext applicationContext;

    /**
     * 规则缓存：group -> rules
     */
    private final Map<String, List<AppointmentRule>> rulesCache = new ConcurrentHashMap<>();

    /**
     * 所有规则列表
     */
    private List<AppointmentRule> allRules;

    @PostConstruct
    public void init() {
        registerRules();
    }

    /**
     * 注册所有规则
     */
    private void registerRules() {
        // 获取所有实现了 AppointmentRule 接口的 Bean
        Map<String, AppointmentRule> ruleBeans = applicationContext.getBeansOfType(AppointmentRule.class);

        allRules = ruleBeans.values().stream()
                .collect(Collectors.toList());

        // 按规则组分类
        for (AppointmentRule rule : allRules) {
            String group = rule.getGroup();
            rulesCache.computeIfAbsent(group, k -> new ArrayList<>()).add(rule);
            log.info("Registered rule: code={}, name={}, group={}, priority={}",
                    rule.getCode(), rule.getName(), rule.getGroup(), rule.getPriority());
        }

        log.info("Total rules registered: {}", allRules.size());
    }

    /**
     * 获取指定规则组的所有规则
     *
     * @param ruleGroup 规则组
     * @return 规则列表
     */
    public List<AppointmentRule> getRules(String ruleGroup) {
        return rulesCache.getOrDefault(ruleGroup, new ArrayList<>());
    }

    /**
     * 根据规则代码获取规则
     *
     * @param ruleCode 规则代码
     * @return 规则
     */
    public Optional<AppointmentRule> getRuleByCode(String ruleCode) {
        return allRules.stream()
                .filter(r -> r.getCode().equals(ruleCode))
                .findFirst();
    }

    /**
     * 刷新规则缓存
     */
    public void refreshRules() {
        rulesCache.clear();
        registerRules();
    }
}