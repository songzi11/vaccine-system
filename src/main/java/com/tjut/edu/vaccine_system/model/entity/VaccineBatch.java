package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.tjut.edu.vaccine_system.model.enums.BatchStatusEnum;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 疫苗批次表（FEFO 分配、保质期监控）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("vaccine_batch")
public class VaccineBatch implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long vaccineId;
    private String batchNo;
    private LocalDate productionDate;
    private LocalDate expiryDate;
    private Integer stock;
    private Integer warningDays;
    /** 0正常 1临期 2过期 3已销毁 */
    private Integer status;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;

    public BatchStatusEnum getStatusEnum() {
        return BatchStatusEnum.fromCode(status);
    }
}
