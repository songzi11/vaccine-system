package com.tjut.edu.vaccine_system.rule.rules;

import com.tjut.edu.vaccine_system.rule.annotation.Rule;
import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.engine.AppointmentRule;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

/**
 * 间隔规则 - 校验同一疫苗的接种间隔是否满足要求
 */
@Slf4j
@Component
@Rule(
        code = "INTERVAL_CHECK",
        name = "接种间隔校验",
        group = "APPOINTMENT",
        priority = 2,
        enabled = true,
        mandatory = true
)
public class IntervalRule implements AppointmentRule {

    @Override
    public String getCode() {
        return "INTERVAL_CHECK";
    }

    @Override
    public String getName() {
        return "接种间隔校验";
    }

    @Override
    public String getGroup() {
        return "APPOINTMENT";
    }

    @Override
    public int getPriority() {
        return 2;
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
        LocalDate appointmentDate = context.getAppointmentDate();
        LocalDate lastVaccinationDate = context.getLastVaccinationDate();
        Integer intervalDays = context.getIntervalDays();

        // 如果没有设置间隔天数要求，则跳过校验
        if (intervalDays == null || intervalDays <= 0) {
            return RuleResult.builder()
                    .passed(true)
                    .ruleCode(getCode())
                    .ruleName(getName())
                    .build();
        }

        // 如果没有上次接种记录，无需校验
        if (lastVaccinationDate == null) {
            return RuleResult.builder()
                    .passed(true)
                    .ruleCode(getCode())
                    .ruleName(getName())
                    .build();
        }

        // 如果没有预约日期，无法校验
        if (appointmentDate == null) {
            return RuleResult.builder()
                    .passed(false)
                    .ruleCode(getCode())
                    .ruleName(getName())
                    .errorCode("INTERVAL_CHECK_INVALID_PARAMS")
                    .errorMessage("无法校验间隔：缺少预约日期")
                    .build();
        }

        // 计算距离上次接种的天数
        long daysSinceLastVaccination = java.time.temporal.ChronoUnit.DAYS.between(lastVaccinationDate, appointmentDate);

        if (daysSinceLastVaccination < intervalDays) {
            LocalDate earliestNextDate = lastVaccinationDate.plusDays(intervalDays);
            return RuleResult.builder()
                    .passed(false)
                    .ruleCode(getCode())
                    .ruleName(getName())
                    .errorCode("INTERVAL_NOT_ENOUGH")
                    .errorMessage("该疫苗两剂间隔至少" + intervalDays + "天，下次可约日期不早于" + earliestNextDate)
                    .build();
        }

        return RuleResult.builder()
                .passed(true)
                .ruleCode(getCode())
                .ruleName(getName())
                .build();
    }
}