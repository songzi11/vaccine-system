package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 接种记录状态（record 表，与 DB 约定：code 存表）
 */
@Getter
@AllArgsConstructor
public enum RecordStatus {

    DONE("已接种", "已接种"),
    ABNORMAL("异常", "异常"),
    CANCELLED("取消", "取消");

    private final String code;
    private final String desc;

    public static RecordStatus fromCode(String code) {
        if (code == null) return null;
        for (RecordStatus e : values()) {
            if (e.getCode().equals(code)) return e;
        }
        return null;
    }
}
