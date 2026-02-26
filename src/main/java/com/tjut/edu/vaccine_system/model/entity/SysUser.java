package com.tjut.edu.vaccine_system.model.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.tjut.edu.vaccine_system.model.enums.UserStatusEnum;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 系统用户表（管理员、医生、居民）
 * status：0=正常 1=已禁用 2=已注销（UserStatusEnum）
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("sys_user")
public class SysUser implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;
    private String username;
    private String password;
    private String realName;
    private String role;
    private Integer gender;
    private String phone;
    private String idCard;
    private String address;
    private String avatar;
    /** 状态：0=正常 1=已禁用 2=已注销（见 UserStatusEnum） */
    private Integer status;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    /** 最后登录时间 */
    private LocalDateTime lastLoginTime;
    /** 预约禁约截止时间：当日逾期未核销超过3次则30日内不可预约 */
    private LocalDateTime reservationBanUntil;
    /** 逻辑删除：0-未删除 1-已删除（注销不置 1，仅管理员删除时置 1） */
    @TableLogic(value = "0", delval = "1")
    @TableField(value = "is_deleted")
    private Integer isDeleted;

    public UserStatusEnum getStatusEnum() {
        return UserStatusEnum.fromCode(status);
    }
}
