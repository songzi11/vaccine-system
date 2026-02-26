package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.tjut.edu.vaccine_system.model.enums.CommonStatus;
import com.tjut.edu.vaccine_system.model.enums.VaccineStatusEnum;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 疫苗信息表
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("vaccine")
public class Vaccine implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    @NotBlank(message = "疫苗名称不能为空")
    private String vaccineName;
    /** 疫苗简称，用于疫苗编号生成，如 DTP、HBV */
    private String shortCode;
    private String category;
    private String manufacturer;
    private String vaccineType;
    private Integer totalDoses;
    private Integer intervalDays;
    private Integer applicableAgeMonths;
    private String dosageDesc;
    private String description;
    private String adverseReactionDesc;
    /** 状态：0-下架，1-上架（见 VaccineStatusEnum） */
    private Integer status;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    public CommonStatus getStatusEnum() {
        return CommonStatus.fromCode(status);
    }

    /** 疫苗上架/下架状态枚举 */
    public VaccineStatusEnum getVaccineStatusEnum() {
        return VaccineStatusEnum.fromCode(status);
    }
}
