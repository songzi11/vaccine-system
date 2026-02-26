package com.tjut.edu.vaccine_system.model.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/** 调拨方类型：0-总仓 1-接种点 */
@Getter
@AllArgsConstructor
public enum TransferTypeEnum {
    WAREHOUSE(0, "总仓"),
    SITE(1, "接种点");

    private final int code;
    private final String desc;

    public static TransferTypeEnum fromCode(Integer code) {
        if (code == null) return null;
        for (TransferTypeEnum e : values()) {
            if (e.getCode() == code) return e;
        }
        return null;
    }
}
