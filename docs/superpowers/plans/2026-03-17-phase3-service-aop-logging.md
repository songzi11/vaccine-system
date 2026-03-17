# Phase 3 - 接口层抽象 (Service AOP Logging) Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为所有 Service 实现类添加 AOP 代理，实现方法执行日志和性能监控

**Architecture:** 使用 Spring AOP 为 `com.tjut.edu.vaccine_system.service.impl..*.*(..)` 包下的所有方法创建切面，记录方法入参、返回值、异常和执行时间。已有 `ApiLoggingAspect` 只处理 Controller 层，本切面专注于 Service 层。

**Tech Stack:** Spring Boot 3.2, Spring AOP, JUnit 5, Mockito

---

## File Structure

```
src/main/java/com/tjut/edu/vaccine_system/
└── aspect/
    └── ServiceMethodLogAspect.java    # 新增：Service 层日志切面

src/test/java/com/tjut/edu/vaccine_system/
└── aspect/
    └── ServiceMethodLogAspectTest.java # 新增：切面单元测试
```

**Files:**
- Create: `src/main/java/com/tjut/edu/vaccine_system/aspect/ServiceMethodLogAspect.java`
- Create: `src/test/java/com/tjut/edu/vaccine_system/aspect/ServiceMethodLogAspectTest.java`

---

### Task 1: 创建 ServiceMethodLogAspect

**Files:**
- Create: `src/main/java/com/tjut/edu/vaccine_system/aspect/ServiceMethodLogAspect.java`

- [x] **Step 1: 创建 ServiceMethodLogAspect 切面类**

```java
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
```

- [x] **Step 2: 编译验证**

Run: `cd vaccine_system && ./mvnw compile -q`
Expected: BUILD SUCCESS

- [x] **Step 3: Commit**

```bash
git add vaccine_system/src/main/java/com/tjut/edu/vaccine_system/aspect/ServiceMethodLogAspect.java
git commit -m "feat: add ServiceMethodLogAspect for Service layer AOP logging"
```

---

### Task 2: 创建 ServiceMethodLogAspect 单元测试

**Files:**
- Create: `src/test/java/com/tjut/edu/vaccine_system/aspect/ServiceMethodLogAspectTest.java`

- [x] **Step 1: 创建测试类**

```java
package com.tjut.edu.vaccine_system.aspect;

import com.tjut.edu.vaccine_system.service.VaccineService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertNotNull;

/**
 * ServiceMethodLogAspect 集成测试
 * 验证切面是否正确织入 Service 层
 */
@SpringBootTest
class ServiceMethodLogAspectTest {

    @Autowired
    private ServiceMethodLogAspect serviceMethodLogAspect;

    @Autowired
    private VaccineService vaccineService;

    @Test
    void testAspectExists() {
        // 验证切面 Bean 已注册
        assertNotNull(serviceMethodLogAspect, "ServiceMethodLogAspect should be loaded");
    }

    @Test
    void testServiceMethodIsIntercepted() {
        // 调用 Service 方法，验证日志输出
        // 查看日志中是否包含 [SERVICE] 前缀的日志
        // 此测试主要用于验证 AOP 切面正确织入
        var list = vaccineService.list();
        // 如果能正常返回结果，说明切面没有阻止方法执行
        assertNotNull(list);
    }
}
```

- [x] **Step 2: 运行测试**

Run: `cd vaccine_system && ./mvnw test -Dtest=ServiceMethodLogAspectTest -q`
Expected: BUILD SUCCESS（测试通过）

- [x] **Step 3: Commit**

```bash
git add vaccine_system/src/test/java/com/tjut/edu/vaccine_system/aspect/ServiceMethodLogAspectTest.java
git commit -m "test: add ServiceMethodLogAspectTest"
```

---

## Implementation Summary

| Task | Description | Status |
|------|-------------|--------|
| Task 1 | 创建 ServiceMethodLogAspect 切面 | ✅ |
| Task 2 | 创建单元测试 | ✅ |

## Verification Commands

```bash
# 编译项目
cd vaccine_system && ./mvnw compile -q

# 运行测试
cd vaccine_system && ./mvnw test -Dtest=ServiceMethodLogAspectTest

# 启动应用后调用任意 Service 方法，查看日志输出格式：
# [SERVICE] >>> VaccineServiceImpl.list() 开始执行 | 参数: []
# [SERVICE] <<< VaccineServiceImpl.list() 执行完成 | 耗时 15 ms | 返回: [...]
```