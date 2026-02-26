package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.tjut.edu.vaccine_system.model.enums.DoctorDispatchStatusEnum;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 医生调遣申请表
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("doctor_dispatch")
public class DoctorDispatch implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long doctorId;
    private Long fromSiteId;
    private Long toSiteId;
    /** 0已推送 1已读 */
    private Integer status;
    private LocalDateTime applyTime;
    private LocalDateTime approveTime;

    public DoctorDispatchStatusEnum getStatusEnum() {
        return DoctorDispatchStatusEnum.fromCode(status);
    }
}
