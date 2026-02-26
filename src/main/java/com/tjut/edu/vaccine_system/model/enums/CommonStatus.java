package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 通用启用状态（0-禁用/下架/停用，1-正常/上架/启用）- 用于 user/site/vaccine/notice/inventory
 */
@Getter
@AllArgsConstructor
public enum CommonStatus {

    DISABLED(0, "禁用"),
    ENABLED(1, "正常");

    private final int code;
    private final String desc;

    public static CommonStatus fromCode(Integer code) {
        if (code == null) return null;
        for (CommonStatus e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }
}
