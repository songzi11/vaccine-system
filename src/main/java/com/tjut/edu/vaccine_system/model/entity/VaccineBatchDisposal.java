package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 疫苗批次销毁记录表
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("vaccine_batch_disposal")
public class VaccineBatchDisposal implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long batchId;
    private String disposalReason;
    private LocalDate disposalDate;
    private Long operatorId;
    private String remark;
    private LocalDateTime createTime;
}
