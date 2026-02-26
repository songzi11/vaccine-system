package com.tjut.edu.vaccine_system.config;

import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.common.result.Result;
import com.tjut.edu.vaccine_system.common.result.ResultCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import jakarta.validation.ConstraintViolationException;
import java.util.stream.Collectors;

/**
 * 全局异常处理，统一返回 Result 格式
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 参数校验异常（@RequestBody @Valid）
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleMethodArgumentNotValid(MethodArgumentNotValidException e) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(err -> err.getField() + ": " + err.getDefaultMessage())
                .collect(Collectors.joining("; "));
        log.warn("参数校验失败: {}", message);
        return Result.fail(ResultCode.BAD_REQUEST.getCode(), message);
    }

    /**
     * 参数绑定异常（表单、@RequestParam 等）
     */
    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleBindException(BindException e) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(err -> err.getField() + ": " + err.getDefaultMessage())
                .collect(Collectors.joining("; "));
        log.warn("参数绑定失败: {}", message);
        return Result.fail(ResultCode.BAD_REQUEST.getCode(), message);
    }

    /**
     * 约束违反（@Validated 方法参数等）
     */
    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleConstraintViolation(ConstraintViolationException e) {
        String message = e.getConstraintViolations().stream()
                .map(v -> v.getPropertyPath() + ": " + v.getMessage())
                .collect(Collectors.joining("; "));
        log.warn("约束违反: {}", message);
        return Result.fail(ResultCode.BAD_REQUEST.getCode(), message);
    }

    /**
     * 缺少请求参数
     */
    @ExceptionHandler(MissingServletRequestParameterException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleMissingParam(MissingServletRequestParameterException e) {
        log.warn("缺少请求参数: {}", e.getParameterName());
        return Result.fail(ResultCode.BAD_REQUEST.getCode(), "缺少参数: " + e.getParameterName());
    }

    /**
     * 静态资源未找到（如请求路径为 "." 或错误的前端路由打到后端）
     */
    @ExceptionHandler(NoResourceFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public Result<Void> handleNoResourceFound(NoResourceFoundException e) {
        log.warn("资源未找到: {}", e.getResourcePath());
        return Result.fail(404, "资源不存在: " + e.getResourcePath());
    }

    /**
     * 请求方法不支持
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    @ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
    public Result<Void> handleMethodNotAllowed(HttpRequestMethodNotSupportedException e) {
        log.warn("请求方法不支持: {}", e.getMethod());
        return Result.fail(405, "不支持的请求方法: " + e.getMethod());
    }

    /**
     * 业务异常（BizException）：按 code 返回 400 或 404
     */
    @ExceptionHandler(BizException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleBizException(BizException e) {
        log.warn("业务异常: [{}] {}", e.getCode(), e.getMessage());
        return Result.fail(e.getCode(), e.getMessage());
    }

    /**
     * 业务状态异常（如密码数据异常）
     */
    @ExceptionHandler(IllegalStateException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleIllegalState(IllegalStateException e) {
        log.warn("业务状态异常: {}", e.getMessage());
        return Result.fail(ResultCode.FAIL.getCode(), e.getMessage());
    }

    /**
     * 业务参数/规则异常（如仅预检通过可核销），返回 400 与明确文案，避免被当作 500 系统异常
     */
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<Void> handleIllegalArgument(IllegalArgumentException e) {
        log.warn("业务规则异常: {}", e.getMessage());
        return Result.fail(ResultCode.BAD_REQUEST.getCode(), e.getMessage());
    }

    /**
     * 其他未捕获异常
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Result<Void> handleException(Exception e) {
        log.error("系统异常", e);
        return Result.fail(ResultCode.FAIL.getCode(), "系统繁忙，请稍后重试");
    }
}
