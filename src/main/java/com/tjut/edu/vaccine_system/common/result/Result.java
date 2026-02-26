package com.tjut.edu.vaccine_system.common.result;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 统一 HTTP 响应体，所有接口均返回此结构（code/message/data）。
 * 前端可依赖 code=200 表示成功，message 为提示信息，data 为业务数据。
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Result<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 状态码，200 表示成功 */
    private Integer code;
    /** 提示信息 */
    private String message;
    /** 业务数据，分页时为 PageResult */
    private T data;

    public static <T> Result<T> ok() {
        return Result.<T>builder()
                .code(ResultCode.SUCCESS.getCode())
                .message(ResultCode.SUCCESS.getMessage())
                .build();
    }

    public static <T> Result<T> ok(T data) {
        return Result.<T>builder()
                .code(ResultCode.SUCCESS.getCode())
                .message(ResultCode.SUCCESS.getMessage())
                .data(data)
                .build();
    }

    public static <T> Result<T> ok(String message, T data) {
        return Result.<T>builder()
                .code(ResultCode.SUCCESS.getCode())
                .message(message)
                .data(data)
                .build();
    }

    public static <T> Result<T> ok(String message) {
        return Result.<T>builder()
                .code(ResultCode.SUCCESS.getCode())
                .message(message)
                .build();
    }

    public static <T> Result<T> fail() {
        return Result.<T>builder()
                .code(ResultCode.FAIL.getCode())
                .message(ResultCode.FAIL.getMessage())
                .build();
    }

    public static <T> Result<T> fail(String message) {
        return Result.<T>builder()
                .code(ResultCode.FAIL.getCode())
                .message(message)
                .build();
    }

    public static <T> Result<T> fail(Integer code, String message) {
        return Result.<T>builder()
                .code(code)
                .message(message)
                .build();
    }

    public static <T> Result<T> success() {
        return ok();
    }

    public static <T> Result<T> success(T data) {
        return ok(data);
    }

    public static <T> Result<T> success(String message, T data) {
        return ok(message, data);
    }

    /** 兼容前端 msg 字段 */
    public String getMsg() {
        return message;
    }

    public void setMsg(String msg) {
        this.message = msg;
    }
}
