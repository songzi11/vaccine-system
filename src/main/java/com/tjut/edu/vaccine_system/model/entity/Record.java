package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.tjut.edu.vaccine_system.model.enums.RecordStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 接种记录表（record）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("record")
public class Record implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 状态：已接种 */
    public static final String STATUS_DONE = "已接种";
    /** 状态：异常 */
    public static final String STATUS_ABNORMAL = "异常";
    /** 状态：取消 */
    public static final String STATUS_CANCELLED = "取消";

    @TableId(type = IdType.AUTO)
    private Long id;
    /** 预约ID */
    private Long orderId;
    /** 家长ID */
    private Long userId;
    /** 宝宝ID */
    private Long childId;
    /** 疫苗ID */
    private Long vaccineId;
    /** 医生ID */
    private Long doctorId;
    /** 接种点ID */
    private Long siteId;
    /** 接种时间 */
    private LocalDateTime vaccinateTime;
    /** 状态（code 存表，见 RecordStatus） */
    private String status;
    /** 备注 */
    private String remark;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    /** 逻辑删除：0-未删除 1-已删除 */
    @TableLogic
    private Integer isDeleted;

    public RecordStatus getStatusEnum() {
        return RecordStatus.fromCode(status);
    }
}
