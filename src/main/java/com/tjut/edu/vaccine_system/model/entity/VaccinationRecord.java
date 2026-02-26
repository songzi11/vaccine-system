package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.FieldStrategy;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 接种记录表
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("vaccination_record")
public class VaccinationRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    /** 接种儿童档案ID */
    private Long childId;
    /** 家长/居民ID（冗余便于按家长查） */
    private Long userId;
    /** 疫苗ID */
    private Long vaccineId;
    /** 关联预约ID；现场接种可为空 */
    private Long appointmentId;
    /** 使用的库存批次ID（旧表 vaccine_inventory，兼容） */
    private Long inventoryId;
    /** 接种使用批次ID（vaccine_batch，FEFO 分配） */
    private Long batchId;
    /** 疫苗编号：核销时自动生成，唯一且不可修改；格式 SHORTNAME-YYYYMMDD-BATCHSUFFIX-序号；update 不包含此字段 */
    @Getter
    @Setter(AccessLevel.NONE)
    @TableField(updateStrategy = FieldStrategy.NEVER)
    private String vaccineCode;
    /** 接种批次号冗余（展示用，可从 batch 带出） */
    private String batchNo;
    /** 第几针/剂次 */
    private Integer doseNumber;
    /** 接种时间 */
    private LocalDateTime vaccinationDate;
    /** 接种医生ID */
    private Long doctorId;
    /** 接种点ID */
    private Long siteId;
    /** 接种部位（如左上臂） */
    private String injectionSite;
    /** 留观无异常：0-否，1-是 */
    private Integer observationOk;
    /** 不良反应记录 */
    private String reaction;
    /** 下次接种日期 */
    private LocalDate nextDoseDate;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
