package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.tjut.edu.vaccine_system.model.enums.CommonStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 通知公告表
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("notice")
public class Notice implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String content;
    private String type;
    private Long publisherId;
    /** 发布者角色：ADMIN-管理员，DOCTOR-医生 */
    private String publisherRole;
    /** 医生申请时：PENDING-待审批，APPROVED-通过，REJECTED-未通过 */
    private String auditStatus;
    /** 未通过时管理员填写的原因 */
    private String rejectReason;
    private Integer isTop;
    /** 状态（0-草稿 1-发布，见 CommonStatus） */
    private Integer status;
    private LocalDateTime publishTime;
    /** 定向用户ID：非空时仅该用户可见（爽约警告/冻结公告） */
    private Long targetUserId;
    /** 展示样式：NORMAL-普通，WARNING-红色框警告，FROZEN-冻结通知 */
    private String noticeStyle;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    public CommonStatus getStatusEnum() {
        return CommonStatus.fromCode(status);
    }
}
