package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 医生调遣状态：简化后仅为推送与已读
 */
@Getter
@AllArgsConstructor
public enum DoctorDispatchStatusEnum {

    NOTIFIED(0, "已推送"),
    READ(1, "已读");

    private final int code;
    private final String desc;

    public static DoctorDispatchStatusEnum fromCode(Integer code) {
        if (code == null) return null;
        for (DoctorDispatchStatusEnum e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }
}
