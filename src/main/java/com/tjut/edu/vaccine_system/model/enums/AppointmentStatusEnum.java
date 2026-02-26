package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 预约状态（整数存表）
 * 1已预约 6已签到 7预检通过 9预检未通过 10留观中 2已完成 3已取消 4已过期
 */
@Getter
@AllArgsConstructor
public enum AppointmentStatusEnum {

    /** 已预约 */
    BOOKED(1, "已预约"),
    /** 已完成 */
    COMPLETED(2, "已完成"),
    /** 已取消 */
    CANCELLED(3, "已取消"),
    /** 已过期 */
    EXPIRED(4, "已过期"),
    /** 已签到 */
    CHECKED_IN(6, "已签到"),
    /** 预检通过 */
    PRE_CHECK_PASS(7, "预检通过"),
    /** 预检未通过 */
    PRE_CHECK_FAIL(9, "预检未通过"),
    /** 留观中 */
    OBSERVING(10, "留观中");

    private final int code;
    private final String desc;

    public static AppointmentStatusEnum fromCode(Integer code) {
        if (code == null) return null;
        for (AppointmentStatusEnum e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }
}
