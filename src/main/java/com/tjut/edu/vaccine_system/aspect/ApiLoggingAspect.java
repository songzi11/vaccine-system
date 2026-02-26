package com.tjut.edu.vaccine_system.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.stream.Collectors;

/**
 * 全局接口日志切面：记录请求路径、方法、耗时（ms）
 * 敏感参数（如 password）不打印明文
 */
@Slf4j
@Aspect
@Component
public class ApiLoggingAspect {

    private static final String[] MASK_KEYS = {"password", "pwd", "token", "secret"};

    @Around("execution(* com.tjut.edu.vaccine_system.controller..*.*(..))")
    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        String method = "";
        String path = "";
        try {
            ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs != null) {
                HttpServletRequest request = attrs.getRequest();
                if (request != null) {
                    path = request.getRequestURI();
                    method = request.getMethod();
                }
            }
        } catch (Exception ignored) {
        }
        MethodSignature signature = (MethodSignature) pjp.getSignature();
        String shortMethod = signature.getDeclaringType().getSimpleName() + "#" + signature.getName();
        Object[] args = pjp.getArgs();
        String argsStr = maskSensitive(args);
        if (argsStr != null && argsStr.length() > 500) {
            argsStr = argsStr.substring(0, 500) + "...";
        }
        log.info("API 请求 start | {} {} | {} | args: {}", method, path, shortMethod, argsStr);
        Object result;
        try {
            result = pjp.proceed();
        } finally {
            long cost = System.currentTimeMillis() - start;
            log.info("API 请求 end   | {} {} | {} | 耗时 {} ms", method, path, shortMethod, cost);
        }
        return result;
    }

    private static String maskSensitive(Object[] args) {
        if (args == null || args.length == 0) return "";
        return Arrays.stream(args)
                .map(arg -> {
                    if (arg == null) return "null";
                    String s = arg.toString();
                    for (String key : MASK_KEYS) {
                        if (s.toLowerCase().contains("\"" + key + "\"") || s.toLowerCase().contains(key + "=")) {
                            return "***";
                        }
                    }
                    return s;
                })
                .collect(Collectors.joining(", "));
    }
}
