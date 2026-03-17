package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 疫苗规则配置实体
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@TableName("vaccine_rule")
public class VaccineRule {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 规则代码
     */
    private String ruleCode;

    /**
     * 规则名称
     */
    private String ruleName;

    /**
     * 规则组
     */
    private String ruleGroup;

    /**
     * 优先级
     */
    private Integer priority;

    /**
     * 是否启用
     */
    private Integer enabled;

    /**
     * 规则参数 (JSON)
     */
    private String params;

    /**
     * 错误代码
     */
    private String errorCode;

    /**
     * 错误消息
     */
    private String errorMessage;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /**
     * 删除标志
     */
    @TableLogic
    private Integer deleted;
}