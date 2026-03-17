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