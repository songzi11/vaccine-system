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
 * 宣传推送记录（如麻腮风接种低谷期向目标家长推送）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("campaign_push_log")
public class CampaignPushLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long vaccineId;
    private String vaccineName;
    private Long siteId;
    private Long targetUserId;
    private String content;
    private String pushChannel;
    private LocalDateTime pushTime;
    private LocalDateTime createTime;
}
