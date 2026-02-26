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
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 疫苗库存表（按批次，用于效期与剩余量监测）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("vaccine_inventory")
public class VaccineInventory implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long vaccineId;
    private Long siteId;
    private String batchNo;
    private Integer quantity;
    private Integer usedQuantity;
    private LocalDate expiryDate;
    private String storageLocation;
    /** 状态（0-停用 1-有效，见 CommonStatus） */
    private Integer status;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    public int getRemainingQuantity() {
        int q = quantity != null ? quantity : 0;
        int u = usedQuantity != null ? usedQuantity : 0;
        return Math.max(0, q - u);
    }

    public double getRemainingRatioPercent() {
        if (quantity == null || quantity <= 0) return 0;
        return 100.0 * getRemainingQuantity() / quantity;
    }

    public CommonStatus getStatusEnum() {
        return CommonStatus.fromCode(status);
    }
}
