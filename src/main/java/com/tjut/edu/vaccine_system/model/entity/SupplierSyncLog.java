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
 * 供应商同步记录
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("supplier_sync_log")
public class SupplierSyncLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long stockAlertLogId;
    private String supplierEndpoint;
    private String requestBody;
    private Integer responseCode;
    private String responseBody;
    private LocalDateTime syncTime;
}
