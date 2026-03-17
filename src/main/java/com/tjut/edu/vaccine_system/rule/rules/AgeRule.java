package com.tjut.edu.vaccine_system.rule.rules;

import com.tjut.edu.vaccine_system.rule.annotation.Rule;
import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.engine.AppointmentRule;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * 年龄规则 - 校验儿童的月龄是否满足疫苗的适用起始月龄
 */
@Slf4j
@Component
@Rule(
        code = "AGE_CHECK",
        name = "适用年龄校验",
        group = "APPOINTMENT",
        priority = 1,
        enabled = true,
        mandatory = true
)
public class AgeRule implements AppointmentRule {

    @Override
    public String getCode() {
        return "AGE_CHECK";
    }

    @Override
    public String getName() {
        return "适用年龄校验";
    }

    @Override
    public String getGroup() {
        return "APPOINTMENT";
    }

    @Override
    public int getPriority() {
        return 1;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    @Override
    public boolean isMandatory() {
        return true;
    }

    @Override
    public RuleResult validate(AppointmentRuleContext context) {
        // 获取上下文中的参数
        LocalDate birthDate = context.getBirthDate();
        LocalDate appointmentDate = context.getAppointmentDate();
        Integer applicableAgeMonths = context.getApplicableAgeMonths();

        // 如果没有设置最小月龄要求，则跳过校验
        if (applicableAgeMonths == null || applicableAgeMonths <= 0) {
            return RuleResult.builder()
                    .passed(true)
                    .ruleCode(getCode())
                    .ruleName(getName())
                    .build();
        }

        // 如果没有出生日期或预约日期，无法校验
        if (birthDate == null || appointmentDate == null) {
            return RuleResult.builder()
                    .passed(false)
                    .ruleCode(getCode())
                    .ruleName(getName())
                    .errorCode("AGE_CHECK_INVALID_PARAMS")
                    .errorMessage("无法校验年龄：缺少出生日期或预约日期")
                    .build();
        }

        // 计算儿童的月龄
        long ageMonths = ChronoUnit.MONTHS.between(birthDate, appointmentDate);

        if (ageMonths < applicableAgeMonths) {
            return RuleResult.builder()
                    .passed(false)
                    .ruleCode(getCode())
                    .ruleName(getName())
                    .errorCode("AGE_NOT_APPLICABLE")
                    .errorMessage("该疫苗适用起始月龄为" + applicableAgeMonths + "月，当前儿童未达适用年龄")
                    .build();
        }

        return RuleResult.builder()
                .passed(true)
                .ruleCode(getCode())
                .ruleName(getName())
                .build();
    }
}