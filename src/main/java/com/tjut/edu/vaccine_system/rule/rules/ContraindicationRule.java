package com.tjut.edu.vaccine_system.rule.rules;

import com.tjut.edu.vaccine_system.rule.annotation.Rule;
import com.tjut.edu.vaccine_system.rule.context.AppointmentRuleContext;
import com.tjut.edu.vaccine_system.rule.engine.AppointmentRule;
import com.tjut.edu.vaccine_system.rule.result.RuleResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.regex.Pattern;

/**
 * 禁忌症规则 - 校验儿童的禁忌症/过敏史是否与疫苗存在冲突
 */
@Slf4j
@Component
@Rule(
        code = "CONTRAINDICATION_CHECK",
        name = "禁忌症校验",
        group = "APPOINTMENT",
        priority = 3,
        enabled = true,
        mandatory = true
)
public class ContraindicationRule implements AppointmentRule {

    private static final Pattern SPLIT_KEYWORDS = Pattern.compile("[,，\\s]+");

    @Override
    public String getCode() {
        return "CONTRAINDICATION_CHECK";
    }

    @Override
    public String getName() {
        return "禁忌症校验";
    }

    @Override
    public String getGroup() {
        return "APPOINTMENT";
    }

    @Override
    public int getPriority() {
        return 3;
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
        String contraindicationAllergy = context.getContraindicationAllergy();
        String vaccineDescription = context.getVaccineDescription();
        String adverseReactionDesc = context.getAdverseReactionDesc();

        // 如果没有禁忌症/过敏史，则跳过校验
        if (!StringUtils.hasText(contraindicationAllergy)) {
            return RuleResult.builder()
                    .passed(true)
                    .ruleCode(getCode())
                    .ruleName(getName())
                    .build();
        }

        // 合并疫苗描述信息
        String desc = (vaccineDescription != null ? vaccineDescription : "")
                + (adverseReactionDesc != null ? adverseReactionDesc : "");

        // 检查每个禁忌症关键词是否出现在疫苗描述中
        String allergy = contraindicationAllergy.trim();
        for (String keyword : SPLIT_KEYWORDS.split(allergy)) {
            String k = keyword.trim();
            if (k.isEmpty()) continue;
            if (desc.contains(k)) {
                return RuleResult.builder()
                        .passed(false)
                        .ruleCode(getCode())
                        .ruleName(getName())
                        .errorCode("CONTRAINDICATION_CONFLICT")
                        .errorMessage("儿童禁忌症/过敏史【" + k + "】与该疫苗说明存在冲突，请咨询医生后再预约")
                        .build();
            }
        }

        return RuleResult.builder()
                .passed(true)
                .ruleCode(getCode())
                .ruleName(getName())
                .build();
    }
}