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
 * 库存调拨日志
 * from_type/to_type: 0-总仓 1-接种点；from_id/to_id 为接种点时存 site_id，总仓时为 null
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("stock_transfer_log")
public class StockTransferLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long batchId;
    /** 0-总仓 1-接种点 */
    private Integer fromType;
    private Long fromId;
    /** 0-总仓 1-接种点 */
    private Integer toType;
    private Long toId;
    private Integer quantity;
    private Long operatorId;
    private LocalDateTime transferTime;
}
