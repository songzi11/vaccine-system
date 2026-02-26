package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 不良反应上报表（家长反馈发热等，关联接种记录）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("adverse_reaction")
public class AdverseReaction implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long recordId;
    private Long reporterId;
    private String symptoms;
    private String severity;
    private LocalDateTime reportTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
