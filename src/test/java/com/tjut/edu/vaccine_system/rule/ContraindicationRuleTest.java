package com.tjut.edu.vaccine_system.rule;

import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;
import com.tjut.edu.vaccine_system.rule.rules.ContraindicationRule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ContraindicationRuleTest {

    private ContraindicationRule contraindicationRule;

    @BeforeEach
    void setUp() {
        contraindicationRule = new ContraindicationRule();
    }

    @Test
    void testValidate_NoContraindication() {
        // Given: 无禁忌症
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .contraindicationAllergy(null)
                .vaccineDescription("本品用于预防乙肝")
                .build();

        // When
        RuleResult result = contraindicationRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_EmptyContraindication() {
        // Given: 禁忌症为空字符串
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .contraindicationAllergy("")
                .vaccineDescription("本品用于预防乙肝")
                .build();

        // When
        RuleResult result = contraindicationRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_ContraindicationConflict() {
        // Given: 儿童有鸡蛋过敏，疫苗描述含鸡蛋
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .contraindicationAllergy("鸡蛋")
                .vaccineDescription("本品含鸡蛋成分")
                .build();

        // When
        RuleResult result = contraindicationRule.validate(context);

        // Then
        assertFalse(result.isPassed());
        assertEquals("CONTRAINDICATION_CONFLICT", result.getErrorCode());
    }

    @Test
    void testValidate_MultipleKeywords_Comma() {
        // Given: 多个关键词，用逗号分隔
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .contraindicationAllergy("鸡蛋,牛奶,花生")
                .vaccineDescription("本品含牛奶成分")
                .build();

        // When
        RuleResult result = contraindicationRule.validate(context);

        // Then: 匹配到牛奶
        assertFalse(result.isPassed());
    }

    @Test
    void testValidate_MultipleKeywords_ChineseComma() {
        // Given: 多个关键词，用中文逗号分隔
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .contraindicationAllergy("鸡蛋，牛奶，花生")
                .vaccineDescription("本品含花生成分")
                .build();

        // When
        RuleResult result = contraindicationRule.validate(context);

        // Then: 匹配到花生
        assertFalse(result.isPassed());
    }

    @Test
    void testValidate_NoConflict() {
        // Given: 有关键词但不冲突
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .contraindicationAllergy("海鲜")
                .vaccineDescription("本品用于预防流感")
                .build();

        // When
        RuleResult result = contraindicationRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_ConflictInAdverseReactionDesc() {
        // Given: 冲突关键词出现在不良反应描述中
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .contraindicationAllergy("青霉素")
                .vaccineDescription("本品用于预防乙肝")
                .adverseReactionDesc("对青霉素过敏者慎用")
                .build();

        // When
        RuleResult result = contraindicationRule.validate(context);

        // Then
        assertFalse(result.isPassed());
    }

    @Test
    void testValidate_WhitespaceInKeywords() {
        // Given: 关键词中有空格
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .contraindicationAllergy("鸡蛋 , 牛奶")
                .vaccineDescription("本品含牛奶")
                .build();

        // When
        RuleResult result = contraindicationRule.validate(context);

        // Then: 应该能正确解析并匹配
        assertFalse(result.isPassed());
    }

    @Test
    void testGetCode() {
        assertEquals("CONTRAINDICATION_CHECK", contraindicationRule.getCode());
    }

    @Test
    void testGetName() {
        assertEquals("禁忌症校验", contraindicationRule.getName());
    }

    @Test
    void testGetGroup() {
        assertEquals("APPOINTMENT", contraindicationRule.getGroup());
    }

    @Test
    void testIsEnabled() {
        assertTrue(contraindicationRule.isEnabled());
    }

    @Test
    void testIsMandatory() {
        assertTrue(contraindicationRule.isMandatory());
    }
}