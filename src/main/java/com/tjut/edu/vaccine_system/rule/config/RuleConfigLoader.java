package com.tjut.edu.vaccine_system.rule.config;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tjut.edu.vaccine_system.model.entity.VaccineRule;
import com.tjut.edu.vaccine_system.service.VaccineRuleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 规则配置加载器
 * 加载优先级：数据库配置 > JSON 文件配置 > 代码默认值
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RuleConfigLoader {

    @Value("classpath:rules/*.json")
    private Resource[] ruleResources;

    private final VaccineRuleService vaccineRuleService;
    private final ObjectMapper objectMapper;

    /**
     * 规则配置缓存：ruleCode -> params
     */
    private Map<String, Map<String, Object>> ruleParamsCache = new HashMap<>();

    @PostConstruct
    public void init() {
        loadRuleConfigs();
    }

    /**
     * 加载规则配置
     */
    public void loadRuleConfigs() {
        // 1. 先从数据库加载
        loadFromDatabase();

        // 2. 再从 JSON 文件加载（数据库优先级更高，相同 ruleCode 会覆盖）
        loadFromJsonFiles();

        log.info("Rule config loaded, total rules: {}", ruleParamsCache.size());
    }

    /**
     * 从数据库加载规则配置
     */
    private void loadFromDatabase() {
        try {
            // 查询所有启用的规则
            List<VaccineRule> dbRules = vaccineRuleService.list(
                    new LambdaQueryWrapper<VaccineRule>()
                            .eq(VaccineRule::getEnabled, 1)
            );

            for (VaccineRule rule : dbRules) {
                String ruleCode = rule.getRuleCode();
                String params = rule.getParams();

                if (params != null && !params.isEmpty()) {
                    try {
                        Map<String, Object> paramsMap = objectMapper.readValue(params,
                                new TypeReference<Map<String, Object>>() {});
                        ruleParamsCache.put(ruleCode, paramsMap);
                        log.info("Loaded rule config from database: {}", ruleCode);
                    } catch (IOException e) {
                        log.warn("Failed to parse rule params for {}: {}", ruleCode, e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            log.warn("Failed to load rules from database: {}", e.getMessage());
        }
    }

    /**
     * 从 JSON 文件加载规则配置
     */
    private void loadFromJsonFiles() {
        if (ruleResources == null || ruleResources.length == 0) {
            log.info("No rule JSON files found in classpath:rules/");
            return;
        }

        for (Resource resource : ruleResources) {
            try {
                String content = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
                String filename = resource.getFilename();

                log.info("Loading rule config from file: {}", filename);

                // 尝试解析为单个规则或规则列表
                List<Map<String, Object>> rules;
                try {
                    rules = objectMapper.readValue(content,
                            new TypeReference<List<Map<String, Object>>>() {});
                } catch (Exception e) {
                    // 尝试解析为单个规则
                    Map<String, Object> singleRule = objectMapper.readValue(content,
                            new TypeReference<Map<String, Object>>() {});
                    rules = List.of(singleRule);
                }

                for (Map<String, Object> ruleMap : rules) {
                    String ruleCode = (String) ruleMap.get("ruleCode");
                    if (ruleCode != null && !ruleParamsCache.containsKey(ruleCode)) {
                        // 只添加数据库中不存在的规则
                        @SuppressWarnings("unchecked")
                        Map<String, Object> params = (Map<String, Object>) ruleMap.get("params");
                        if (params != null) {
                            ruleParamsCache.put(ruleCode, params);
                            log.info("Loaded rule config from JSON: {}", ruleCode);
                        }
                    }
                }
            } catch (IOException e) {
                log.warn("Failed to load rule file {}: {}", resource.getFilename(), e.getMessage());
            }
        }
    }

    /**
     * 获取规则参数
     *
     * @param ruleCode 规则代码
     * @return 规则参数
     */
    public Map<String, Object> getRuleParams(String ruleCode) {
        return ruleParamsCache.getOrDefault(ruleCode, new HashMap<>());
    }

    /**
     * 刷新规则配置
     */
    public void refresh() {
        ruleParamsCache.clear();
        loadRuleConfigs();
    }
}