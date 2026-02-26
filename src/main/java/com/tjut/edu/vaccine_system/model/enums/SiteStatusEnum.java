package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 接种点状态：0-禁用，1-启用
 * 禁用后不可预约、用户端不可见
 */
@Getter
@AllArgsConstructor
public enum SiteStatusEnum {

    DISABLED(0, "禁用"),
    ENABLED(1, "启用");

    private final int code;
    private final String desc;

    public static SiteStatusEnum fromCode(Integer code) {
        if (code == null) return null;
        for (SiteStatusEnum e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }
}
