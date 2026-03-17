# Redis 缓存模块实施计划

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为疫苗接种管理系统引入 Redis 缓存，使用 Spring Cache 抽象，为高频访问数据提供缓存支持。

**Architecture:** 使用 Spring Cache 注解（@Cacheable、@CacheEvict）+ Redis 实现，开发环境使用 Embedded Redis，生产环境使用外部 Redis。

**Tech Stack:** Spring Boot 3.2, Spring Data Redis, Embedded Redis 0.7.3

---

## 文件结构

```
src/main/java/com/tjut/edu/vaccine_system/
├── config/
│   ├── RedisConfig.java                  # Redis 配置 + CacheManager
│   └── EmbeddedRedisConfig.java          # 嵌入式 Redis 配置（dev/test 环境）
```

**修改文件（添加缓存注解）:**
- `service/impl/SysUserServiceImpl.java`
- `service/impl/VaccineServiceImpl.java`
- `service/impl/VaccinationSiteServiceImpl.java`

---

## 实施任务

### Task 1: 添加 Redis 依赖到 pom.xml

**Files:**
- Modify: `pom.xml`

- [ ] **Step 1: 编辑 pom.xml 添加 Redis 依赖**

在 `</dependencies>` 标签前添加：

```xml
        <!-- Redis -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>

        <!-- 缓存抽象 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-cache</artifactId>
        </dependency>

        <!-- Jackson 处理 JSON -->
        <dependency>
            <groupId>com.fasterxml.jackson.datatype</groupId>
            <artifactId>jackson-datatype-jsr310</artifactId>
        </dependency>

        <!-- Embedded Redis (开发/测试环境) -->
        <dependency>
            <groupId>it.ozimov</groupId>
            <artifactId>embedded-redis</artifactId>
            <version>0.7.3</version>
            <scope>test</scope>
        </dependency>
```

- [ ] **Step 2: 提交更改**

```bash
git add pom.xml
git commit -m "feat: 添加 Redis 缓存依赖

- spring-boot-starter-data-redis
- spring-boot-starter-cache
- jackson-datatype-jsr310
- embedded-redis (test scope)

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 2: 创建 Redis 配置类

**Files:**
- Create: `src/main/java/com/tjut/edu/vaccine_system/config/RedisConfig.java`

- [ ] **Step 1: 创建 RedisConfig.java**

```java
package com.tjut.edu.vaccine_system.config;

import org.springframework.cache.CacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java duration.Duration;
import java.util.HashMap;
import java.util.Map;

@Configuration
public class RedisConfig {

    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);

        // key 使用 String 序列化
        StringRedisSerializer stringSerializer = new StringRedisSerializer();
        template.setKeySerializer(stringSerializer);
        template.setHashKeySerializer(stringSerializer);

        // value 使用 JSON 序列化
        GenericJackson2JsonRedisSerializer jsonSerializer = new GenericJackson2JsonRedisSerializer();
        template.setValueSerializer(jsonSerializer);
        template.setHashValueSerializer(jsonSerializer);

        template.afterPropertiesSet();
        return template;
    }

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        // 默认缓存配置
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(30))
                .serializeKeysWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new GenericJackson2JsonRedisSerializer()))
                .disableCachingNullValues();

        // 设置特定缓存的过期时间
        Map<String, RedisCacheConfiguration> cacheConfigurations = new HashMap<>();

        // 疫苗缓存
        cacheConfigurations.put("vaccine", config.entryTtl(Duration.ofHours(1)));
        cacheConfigurations.put("vaccine:list", config.entryTtl(Duration.ofMinutes(10)));

        // 接种点缓存
        cacheConfigurations.put("site", config.entryTtl(Duration.ofMinutes(10)));
        cacheConfigurations.put("site:list", config.entryTtl(Duration.ofMinutes(5)));

        // 用户缓存
        cacheConfigurations.put("user", config.entryTtl(Duration.ofMinutes(30)));
        cacheConfigurations.put("user:list", config.entryTtl(Duration.ofMinutes(10)));

        // 预约时段缓存
        cacheConfigurations.put("slots", config.entryTtl(Duration.ofMinutes(5)));

        // 统计缓存
        cacheConfigurations.put("stats", config.entryTtl(Duration.ofMinutes(5)));

        // 规则缓存
        cacheConfigurations.put("rule", config.entryTtl(Duration.ofHours(1)));

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(config)
                .withInitialCacheConfigurations(cacheConfigurations)
                .build();
    }
}
```

- [ ] **Step 2: 提交更改**

```bash
git add src/main/java/com/tjut/edu/vaccine_system/config/RedisConfig.java
git commit -m "feat: 添加 Redis 配置类

- RedisTemplate 配置（String key, JSON value）
- CacheManager 配置（各缓存 TTL 设置）

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 3: 创建 Embedded Redis 配置

**Files:**
- Create: `src/main/java/com/tjut/edu/vaccine_system/config/EmbeddedRedisConfig.java`

- [ ] **Step 1: 创建 EmbeddedRedisConfig.java**

```java
package com.tjut.edu.vaccine_system.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.util.SocketUtils;
import redis.embedded.RedisServer;

import java.io.IOException;

@Configuration
@Profile({"dev", "test"})
public class EmbeddedRedisConfig {

    private static final Logger log = LoggerFactory.getLogger(EmbeddedRedisConfig.class);

    @Bean
    public RedisServer redisServer() throws IOException {
        int port = SocketUtils.findAvailableTcpPort(10000, 60000);
        log.info("Starting Embedded Redis on port {}", port);
        return new RedisServer(port);
    }
}
```

- [ ] **Step 2: 提交更改**

```bash
git add src/main/java/com/tjut/edu/vaccine_system/config/EmbeddedRedisConfig.java
git commit -m "feat: 添加 Embedded Redis 配置

- 开发/测试环境自动使用嵌入式 Redis
- 自动分配可用端口（10000-60000）

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 4: 为 VaccineServiceImpl 添加缓存注解

**Files:**
- Modify: `src/main/java/com/tjut/edu/vaccine_system/service/impl/VaccineServiceImpl.java`

- [ ] **Step 1: 添加缓存注解到 VaccineServiceImpl**

在类定义上方添加 `@EnableCaching` 注解的 import，然后修改方法：

1. 在类上添加 `@EnableCaching`（如果需要的话，通常在配置类中添加）
2. 在 `getById` 方法上添加 `@Cacheable(value = "vaccine", key = "#p0")`
3. 在 `updateStatus` 方法上添加 `@CacheEvict(value = {"vaccine", "vaccine:list"}, allEntries = true)`

```java
package com.tjut.edu.vaccine_system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tjut.edu.vaccine_system.common.exception.BizErrorCode;
import com.tjut.edu.vaccine_system.common.exception.BizException;
import com.tjut.edu.vaccine_system.model.entity.Vaccine;
import com.tjut.edu.vaccine_system.model.enums.VaccineStatusEnum;
import com.tjut.edu.vaccine_system.mapper.VaccineMapper;
import com.tjut.edu.vaccine_system.service.VaccineService;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

/**
 * 疫苗信息 Service 实现
 */
@Service
public class VaccineServiceImpl extends ServiceImpl<VaccineMapper, Vaccine> implements VaccineService {

    @Override
    @Cacheable(value = "vaccine", key = "#id")
    public Vaccine getById(Long id) {
        return super.getById(id);
    }

    @Override
    public IPage<Vaccine> pageVaccines(long current, long size, String vaccineName, Integer status) {
        Page<Vaccine> page = new Page<>(current, size);
        LambdaQueryWrapper<Vaccine> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(vaccineName), Vaccine::getVaccineName, vaccineName)
                .eq(status != null, Vaccine::getStatus, status)
                .orderByDesc(Vaccine::getCreateTime);
        return page(page, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = {"vaccine", "vaccine:list"}, allEntries = true)
    public void updateStatus(Long id, Integer status) {
        Vaccine vaccine = getById(id);
        if (vaccine == null) {
            throw new BizException(BizErrorCode.NOT_FOUND, "疫苗不存在");
        }
        VaccineStatusEnum statusEnum = VaccineStatusEnum.fromCode(status);
        if (statusEnum == null) {
            throw new BizException(BizErrorCode.BAD_REQUEST, "状态值无效，仅支持 0-下架、1-上架");
        }
        vaccine.setStatus(statusEnum.getCode());
        updateById(vaccine);
    }
}
```

- [ ] **Step 2: 提交更改**

```bash
git add src/main/java/com/tjut/edu/vaccine_system/service/impl/VaccineServiceImpl.java
git commit -m "feat: 为 VaccineServiceImpl 添加缓存注解

- getById: @Cacheable(value = "vaccine", key = "#id")
- updateStatus: @CacheEvict 清除疫苗缓存

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 5: 为 VaccinationSiteServiceImpl 添加缓存注解

**Files:**
- Modify: `src/main/java/com/tjut/edu/vaccine_system/service/impl/VaccinationSiteServiceImpl.java`

- [ ] **Step 1: 添加缓存注解到 VaccinationSiteServiceImpl**

修改文件，添加以下注解：

1. 添加 import：
```java
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
```

2. 在 `getById` 方法（继承自 ServiceImpl，需要重写）上添加 `@Cacheable`：
```java
@Override
@Cacheable(value = "site", key = "#id")
public VaccinationSite getById(Long id) {
    return super.getById(id);
}
```

3. 在相关更新方法上添加 `@CacheEvict`：
```java
@Override
@Transactional(rollbackFor = Exception.class)
@CacheEvict(value = {"site", "site:list"}, allEntries = true)
public boolean updateById(VaccinationSite entity) {
    return super.updateById(entity);
}

@Override
@Transactional(rollbackFor = Exception.class)
@CacheEvict(value = {"site", "site:list"}, allEntries = true)
public boolean save(VaccinationSite entity) {
    return super.save(entity);
}

@Override
@Transactional(rollbackFor = Exception.class)
@CacheEvict(value = {"site", "site:list"}, allEntries = true)
public boolean removeById(Long id) {
    return super.removeById(id);
}
```

- [ ] **Step 2: 提交更改**

```bash
git add src/main/java/com/tjut/edu/vaccine_system/service/impl/VaccinationSiteServiceImpl.java
git commit -m "feat: 为 VaccinationSiteServiceImpl 添加缓存注解

- getById: @Cacheable(value = "site", key = "#id")
- save/updateById/removeById: @CacheEvict 清除缓存

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 6: 为 SysUserServiceImpl 添加缓存注解

**Files:**
- Modify: `src/main/java/com/tjut/edu/vaccine_system/service/impl/SysUserServiceImpl.java`

- [ ] **Step 1: 添加缓存注解到 SysUserServiceImpl**

修改文件，添加以下注解：

1. 添加 import：
```java
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
```

2. 在 `getById` 方法上添加缓存：
```java
@Override
@Cacheable(value = "user", key = "#id")
public SysUser getById(Long id) {
    return super.getById(id);
}
```

3. 在更新和保存方法上添加 `@CacheEvict`：
```java
@Override
@Transactional(rollbackFor = Exception.class)
@CacheEvict(value = {"user", "user:list"}, allEntries = true)
public boolean updateById(SysUser entity) {
    return super.updateById(entity);
}

@Override
@Transactional(rollbackFor = Exception.class)
@CacheEvict(value = {"user", "user:list"}, allEntries = true)
public boolean save(SysUser entity) {
    return super.save(entity);
}
```

- [ ] **Step 2: 提交更改**

```bash
git add src/main/java/com/tjut/edu/vaccine_system/service/impl/SysUserServiceImpl.java
git commit -m "feat: 为 SysUserServiceImpl 添加缓存注解

- getById: @Cacheable(value = "user", key = "#id")
- save/updateById: @CacheEvict 清除缓存

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

### Task 7: 验证缓存功能

- [ ] **Step 1: 启动应用验证**

```bash
cd vaccine_system
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

预期：
- Embedded Redis 启动日志：`Starting Embedded Redis on port XXXXX`
- 应用正常启动

- [ ] **Step 2: 测试缓存生效**

调用疫苗查询 API，验证第二次请求不查询数据库（通过日志或断点）。

- [ ] **Step 3: 测试缓存清除**

调用疫苗状态更新 API，验证缓存被清除。

- [ ] **Step 4: 提交验证结果**

```bash
git commit --allow-empty -m "test: 验证 Redis 缓存功能

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## 总结

| 任务 | 描述 | 文件变更 |
|------|------|----------|
| Task 1 | 添加 Redis 依赖 | pom.xml |
| Task 2 | Redis 配置类 | 新建 RedisConfig.java |
| Task 3 | Embedded Redis 配置 | 新建 EmbeddedRedisConfig.java |
| Task 4 | 疫苗服务缓存 | 修改 VaccineServiceImpl.java |
| Task 5 | 接种点服务缓存 | 修改 VaccinationSiteServiceImpl.java |
| Task 6 | 用户服务缓存 | 修改 SysUserServiceImpl.java |
| Task 7 | 验证测试 | - |

**Plan complete and saved to `docs/superpowers/plans/2026-03-17-redis-cache-plan.md`. Ready to execute?**