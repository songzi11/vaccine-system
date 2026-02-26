package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 疫苗批次状态（与 vaccine_batch 表 status 字段对应）
 */
@Getter
@AllArgsConstructor
public enum BatchStatusEnum {

    /** 正常：可参与 FEFO 分配、可预约 */
    NORMAL(0, "正常"),
    /** 临期：预警，仍可分配 */
    NEAR_EXPIRY(1, "临期"),
    /** 过期：不可预约、不可选，仅可走销毁流程 */
    EXPIRED(2, "过期"),
    /** 已销毁：库存已清零 */
    DISPOSED(3, "已销毁");

    private final int code;
    private final String desc;

    public static BatchStatusEnum fromCode(Integer code) {
        if (code == null) return null;
        for (BatchStatusEnum e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }

    /** 是否可参与 FEFO 分配（正常或临期） */
    public static boolean canAllocate(Integer code) {
        return code != null && (code == NORMAL.getCode() || code == NEAR_EXPIRY.getCode());
    }

    /** 是否已过期或已销毁，不可再使用 */
    public static boolean notUsable(Integer code) {
        return code != null && (code == EXPIRED.getCode() || code == DISPOSED.getCode());
    }
}
