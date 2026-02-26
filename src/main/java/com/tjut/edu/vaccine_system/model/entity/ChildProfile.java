package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
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
 * 儿童档案表（核心：关联家长，禁忌症用于智能避坑）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("child_profile")
public class ChildProfile implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long parentId;
    private String name;
    private LocalDate birthDate;
    private Integer gender;
    private String contraindicationAllergy;
    private String vaccinationCardNo;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
