package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/** 排班状态：0-禁用 1-启用 */
@Getter
@AllArgsConstructor
public enum ScheduleStatusEnum {
    DISABLED(0, "禁用"),
    ENABLED(1, "启用");

    private final int code;
    private final String desc;

    public static ScheduleStatusEnum fromCode(Integer code) {
        if (code == null) return null;
        for (ScheduleStatusEnum e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }

    public static boolean isEnabled(Integer code) {
        return Integer.valueOf(ENABLED.getCode()).equals(code);
    }
}
