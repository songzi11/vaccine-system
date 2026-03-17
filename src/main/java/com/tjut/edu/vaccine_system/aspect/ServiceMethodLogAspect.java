package com.tjut.edu.vaccine_system.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.util.Arrays;

/**
 * Service 层方法日志切面
 * 为所有 Service 实现类提供统一的代理增强：
 * - 方法执行日志
 * - 执行时间统计
 * - 异常捕获处理
 */
@Slf4j
@Aspect
@Component
public class ServiceMethodLogAspect {

    @Around("execution(* com.tjut.edu.vaccine_system.service.impl..*.*(..))")
    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        long startTime = System.currentTimeMillis();

        MethodSignature signature = (MethodSignature) pjp.getSignature();
        String className = signature.getDeclaringType().getSimpleName();
        String methodName = signature.getName();

        // 记录方法入参（脱敏处理）
        Object[] args = pjp.getArgs();
        String argsSummary = getArgsSummary(args);

        log.info("[SERVICE] >>> {}.{}() 开始执行 | 参数: {}", className, methodName, argsSummary);

        Object result = null;
        Throwable thrown = null;

        try {
            result = pjp.proceed();
        } catch (Throwable e) {
            thrown = e;
            throw e;
        } finally {
            long costMs = System.currentTimeMillis() - startTime;

            if (thrown != null) {
                log.error("[SERVICE] !!! {}.{}() 执行异常 | 耗时 {} ms | 异常: {}",
                        className, methodName, costMs, thrown.getClass().getSimpleName());
            } else {
                String resultSummary = getResultSummary(result);
                log.info("[SERVICE] <<< {}.{}() 执行完成 | 耗时 {} ms | 返回: {}",
                        className, methodName, costMs, resultSummary);
            }
        }
        return result;
    }

    /**
     * 获取参数摘要（脱敏处理）
     */
    private String getArgsSummary(Object[] args) {
        if (args == null || args.length == 0) {
            return "[]";
        }
        return Arrays.stream(args)
                .map(this::maskSensitive)
                .limit(5) // 最多显示5个参数
                .toList()
                .toString();
    }

    /**
     * 获取返回值摘要
     */
    private String getResultSummary(Object result) {
        if (result == null) {
            return "null";
        }
        String summary = result.toString();
        if (summary.length() > 200) {
            return summary.substring(0, 200) + "...";
        }
        return summary;
    }

    /**
     * 敏感信息脱敏
     */
    private Object maskSensitive(Object obj) {
        if (obj == null) return "null";
        String str = obj.toString().toLowerCase();
        if (str.contains("password") || str.contains("pwd")) {
            return "***";
        }
        return obj;
    }
}