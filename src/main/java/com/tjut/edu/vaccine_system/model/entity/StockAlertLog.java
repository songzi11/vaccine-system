package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 库存/效期预警与补货提醒记录
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("stock_alert_log")
public class StockAlertLog implements Serializable {

    private static final long serialVersionUID = 1L;

    public static final String ALERT_TYPE_LOW_STOCK = "LOW_STOCK";
    public static final String ALERT_TYPE_EXPIRY = "EXPIRY";

    @TableId(type = IdType.AUTO)
    private Long id;
    private String alertType;
    private Long vaccineId;
    private String vaccineName;
    private Long siteId;
    private Long inventoryId;
    private String batchNo;
    private Integer quantity;
    private Integer usedQuantity;
    private BigDecimal remainingRatio;
    private LocalDate expiryDate;
    private Integer syncedToSupplier;
    private LocalDateTime createTime;
}
