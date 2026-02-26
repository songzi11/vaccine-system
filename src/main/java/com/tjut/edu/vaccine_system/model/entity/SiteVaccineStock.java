package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 接种点库存（按批次）
 * 总仓调拨至接种点后在此表按 batch 维度记录 available_stock / locked_stock
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("site_vaccine_stock")
public class SiteVaccineStock implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long siteId;
    private Long batchId;
    /** 可用库存（可被预约锁定） */
    private Integer availableStock;
    /** 预约锁定库存（已预约未核销） */
    private Integer lockedStock;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
