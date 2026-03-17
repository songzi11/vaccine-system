package com.tjut.edu.vaccine_system.rule;

import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;
import com.tjut.edu.vaccine_system.rule.rules.IntervalRule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

class IntervalRuleTest {

    private IntervalRule intervalRule;

    @BeforeEach
    void setUp() {
        intervalRule = new IntervalRule();
    }

    @Test
    void testValidate_IntervalSatisfied() {
        // Given: 间隔 30 天，疫苗要求 14 天
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .lastVaccinationDate(LocalDate.now().minusDays(30))
                .appointmentDate(LocalDate.now())
                .intervalDays(14)
                .build();

        // When
        RuleResult result = intervalRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_IntervalNotSatisfied() {
        // Given: 间隔 7 天，疫苗要求 14 天
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .lastVaccinationDate(LocalDate.now().minusDays(7))
                .appointmentDate(LocalDate.now())
                .intervalDays(14)
                .build();

        // When
        RuleResult result = intervalRule.validate(context);

        // Then
        assertFalse(result.isPassed());
        assertEquals("INTERVAL_NOT_ENOUGH", result.getErrorCode());
    }

    @Test
    void testValidate_ExactIntervalBoundary() {
        // Given: 间隔刚好 14 天，疫苗要求 14 天
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .lastVaccinationDate(LocalDate.now().minusDays(14))
                .appointmentDate(LocalDate.now())
                .intervalDays(14)
                .build();

        // When
        RuleResult result = intervalRule.validate(context);

        // Then: 刚好满足
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_NoPreviousVaccination() {
        // Given: 无上次接种记录
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .lastVaccinationDate(null)
                .appointmentDate(LocalDate.now())
                .intervalDays(14)
                .build();

        // When
        RuleResult result = intervalRule.validate(context);

        // Then: 首次接种，无需校验间隔
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_NoIntervalRequirement() {
        // Given: 疫苗无间隔要求
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .lastVaccinationDate(LocalDate.now().minusDays(1))
                .appointmentDate(LocalDate.now())
                .intervalDays(null)
                .build();

        // When
        RuleResult result = intervalRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_ZeroIntervalRequirement() {
        // Given: 疫苗要求 0 天间隔
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .lastVaccinationDate(LocalDate.now().minusDays(1))
                .appointmentDate(LocalDate.now())
                .intervalDays(0)
                .build();

        // When
        RuleResult result = intervalRule.validate(context);

        // Then
        assertTrue(result.isPassed());
    }

    @Test
    void testValidate_MissingAppointmentDate() {
        // Given: 缺少预约日期
        AppointmentRuleContext context = AppointmentRuleContext.builder()
                .lastVaccinationDate(LocalDate.now().minusDays(7))
                .appointmentDate(null)
                .intervalDays(14)
                .build();

        // When
        RuleResult result = intervalRule.validate(context);

        // Then
        assertFalse(result.isPassed());
        assertEquals("INTERVAL_CHECK_INVALID_PARAMS", result.getErrorCode());
    }

    @Test
    void testGetCode() {
        assertEquals("INTERVAL_CHECK", intervalRule.getCode());
    }

    @Test
    void testGetName() {
        assertEquals("接种间隔校验", intervalRule.getName());
    }

    @Test
    void testGetGroup() {
        assertEquals("APPOINTMENT", intervalRule.getGroup());
    }

    @Test
    void testIsEnabled() {
        assertTrue(intervalRule.isEnabled());
    }

    @Test
    void testIsMandatory() {
        assertTrue(intervalRule.isMandatory());
    }
}