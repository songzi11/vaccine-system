package com.tjut.edu.vaccine_system.common.exception;

import lombok.Getter;

/**
 * 业务异常：用于可预期的业务错误，由 GlobalExceptionHandler 统一返回 Result
 */
@Getter
public class BizException extends RuntimeException {

    private final int code;
    private final String message;

    public BizException(BizErrorCode errorCode) {
        super(errorCode.getDefaultMessage());
        this.code = errorCode.getCode();
        this.message = errorCode.getDefaultMessage();
    }

    public BizException(BizErrorCode errorCode, String overrideMessage) {
        super(overrideMessage != null && !overrideMessage.isEmpty() ? overrideMessage : errorCode.getDefaultMessage());
        this.code = errorCode.getCode();
        this.message = overrideMessage != null && !overrideMessage.isEmpty() ? overrideMessage : errorCode.getDefaultMessage();
    }

    public BizException(int code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }
}
