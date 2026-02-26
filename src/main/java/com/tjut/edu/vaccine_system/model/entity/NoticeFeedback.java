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
 * 公告意见表（医生对往期公告提交意见给管理员）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("notice_feedback")
public class NoticeFeedback implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long noticeId;
    private Long userId;
    private String content;
    private LocalDateTime createTime;
}
