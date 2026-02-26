package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 用户状态枚举（禁止使用字符串状态）
 * 0=正常，1=已禁用，2=已注销（不可恢复）
 */
@Getter
@AllArgsConstructor
public enum UserStatusEnum {

    NORMAL(0, "正常"),
    DISABLED(1, "已禁用"),
    DEACTIVATED(2, "已注销");

    private final int code;
    private final String desc;

    public static UserStatusEnum fromCode(Integer code) {
        if (code == null) return null;
        for (UserStatusEnum e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }

    /** 是否允许登录 */
    public boolean canLogin() {
        return this == NORMAL;
    }
}
