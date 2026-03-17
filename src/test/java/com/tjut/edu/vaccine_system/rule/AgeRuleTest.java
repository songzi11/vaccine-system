package com.tjut.edu.vaccine_system.rule;

import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;
import com.tjut.edu.vaccine_system.rule.rules.AgeRule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

class AgeRuleTest {

    private AgeRule ageRule;

    @BeforeEach
    void setUp() {
        ageRule = new AgeRule();
    }

    @Test
    void testValidate_AgeSatisfied() {
        // Given: 儿童 8 个月，疫苗要求 6 个月
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .birthDate(LocalDate.now().minusMonths(8))
                .appointmentDate(LocalDate.now())
                .applicableAgeMonths(6)
                .build();

        // When
        RuleResult result = ageRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_AgeNotSatisfied() {
        // Given: 儿童 4 个月，疫苗要求 6 个月
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .birthDate(LocalDate.now().minusMonths(4))
                .appointmentDate(LocalDate.now())
                .applicableAgeMonths(6)
                .build();

        // When
        RuleResult result = ageRule.validate(context);

        // Then
        assertFalse(result.isPassed());
        assertEquals("AGE_NOT_APPLICABLE", result.getErrorCode());
    }

    @Test
    void testValidate_ExactAgeBoundary() {
        // Given: 儿童刚好 6 个月，疫苗要求 6 个月
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .birthDate(LocalDate.now().minusMonths(6))
                .appointmentDate(LocalDate.now())
                .applicableAgeMonths(6)
                .build();

        // When
        RuleResult result = ageRule.validate(context);

        // Then: 刚好满足
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_NoAgeRequirement() {
        // Given: 疫苗无年龄要求
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .birthDate(LocalDate.now().minusMonths(1))
                .appointmentDate(LocalDate.now())
                .applicableAgeMonths(null)
                .build();

        // When
        RuleResult result = ageRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_ZeroAgeRequirement() {
        // Given: 疫苗要求 0 个月（即出生即可）
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .birthDate(LocalDate.now().minusDays(7))
                .appointmentDate(LocalDate.now())
                .applicableAgeMonths(0)
                .build();

        // When
        RuleResult result = ageRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_MissingBirthDate() {
        // Given: 缺少出生日期
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .birthDate(null)
                .appointmentDate(LocalDate.now())
                .applicableAgeMonths(6)
                .build();

        // When
        RuleResult result = ageRule.validate(context);

        // Then
        assertFalse(result.isPassed());
        assertEquals("AGE_CHECK_INVALID_PARAMS", result.getErrorCode());
    }

    @Test
    void testValidate_MissingAppointmentDate() {
        // Given: 缺少预约日期
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .birthDate(LocalDate.now().minusMonths(8))
                .appointmentDate(null)
                .applicableAgeMonths(6)
                .build();

        // When
        RuleResult result = ageRule.validate(context);

        // Then
        assertFalse(result.isPassed());
        assertEquals("AGE_CHECK_INVALID_PARAMS", result.getErrorCode());
    }

    @Test
    void testGetCode() {
        assertEquals("AGE_CHECK", ageRule.getCode());
    }

    @Test
    void testGetName() {
        assertEquals("适用年龄校验", ageRule.getName());
    }

    @Test
    void testGetGroup() {
        assertEquals("APPOINTMENT", ageRule.getGroup());
    }

    @Test
    void testIsEnabled() {
        assertTrue(ageRule.isEnabled());
    }

    @Test
    void testIsMandatory() {
        assertTrue(ageRule.isMandatory());
    }
}