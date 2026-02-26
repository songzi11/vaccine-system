package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 疫苗上架/下架状态（与 vaccine 表 status 字段对应）
 */
@Getter
@AllArgsConstructor
public enum VaccineStatusEnum {

    /** 下架：不可选、不可预约、不可录入接种记录 */
    DOWN(0, "下架"),
    /** 上架：可预约、可显示、可录入 */
    UP(1, "上架");

    private final int code;
    private final String desc;

    public static VaccineStatusEnum fromCode(Integer code) {
        if (code == null) return null;
        for (VaccineStatusEnum e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }

    /** 是否上架 */
    public static boolean isUp(Integer code) {
        return UP.getCode() == (code != null ? code : -1);
    }
}
