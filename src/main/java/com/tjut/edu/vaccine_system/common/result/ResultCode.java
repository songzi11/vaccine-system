package com.tjut.edu.vaccine_system.common.result;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 通用 HTTP 响应状态码，与 Result 配合使用。
 */
@Getter
@AllArgsConstructor
public enum ResultCode {

    SUCCESS(200, "操作成功"),
    FAIL(500, "操作失败"),
    NOT_FOUND(404, "资源不存在"),
    BAD_REQUEST(400, "请求参数错误"),
    FORBIDDEN(403, "无权限");

    private final Integer code;
    private final String message;
}
