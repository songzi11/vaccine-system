# Phase 5: Redis 缓存模块实施设计

**项目名称**: 疫苗预约与接种管理系统增强
**版本**: 1.0
**日期**: 2026-03-17
**状态**: 待实施

---

## 一、设计概述

为疫苗接种管理系统引入 Redis 缓存，使用 Spring Cache 抽象 + Redis 实现，为高频访问数据提供缓存支持。开发环境使用 Embedded Redis（内存模拟），生产环境使用外部 Redis。

---

## 二、架构设计

```
┌─────────────────────────────────────────────────────────────────┐
│                        应用层                                   │
│  Service (@Cacheable 注解) → Controller                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Spring Cache 抽象层                          │
│  CacheManager → RedisCacheManager → RedisTemplate               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      缓存实现层                                 │
│  开发环境: Embedded Redis (内存模拟)                             │
│  生产环境: 外部 Redis Server                                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 三、缓存策略

| 数据类型 | 缓存 Key | TTL | 淘汰策略 | 适用 Service |
|----------|----------|-----|----------|--------------|
| 用户信息 | `user:{id}` | 30分钟 | LRU | SysUserService |
| 用户列表 | `user:list` | 10分钟 | LRU | SysUserService |
| 疫苗信息 | `vaccine:{id}` | 1小时 | LRU | VaccineService |
| 疫苗列表 | `vaccine:list` | 10分钟 | LRU | VaccineService |
| 接种点信息 | `site:{id}` | 10分钟 | LRU | VaccinationSiteService |
| 接种点列表 | `site:list` | 5分钟 | LRU | VaccinationSiteService |
| 疫苗规则 | `rule:{code}` | 1小时 | LRU | VaccineRuleService |
| 预约可用时段 | `slots:{siteId}:{date}` | 5分钟 | LRU | AppointmentService |
| 统计指标 | `stats:{type}` | 5分钟 | LRU | StatsService |

---

## 四、核心配置

### 4.1 依赖引入（pom.xml）

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

### 4.2 Redis 配置类

**RedisConfig.java**
```java
@Configuration
public class RedisConfig {

    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        // 配置默认缓存过期时间
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(30))
                .serializeKeysWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new GenericJackson2JsonRedisSerializer()))
                .disableCachingNullValues();

        // 设置特定缓存的过期时间
        Map<String, RedisCacheConfiguration> cacheConfigurations = new HashMap<>();
        cacheConfigurations.put("vaccine", config.entryTtl(Duration.ofHours(1)));
        cacheConfigurations.put("vaccine:list", config.entryTtl(Duration.ofMinutes(10)));
        cacheConfigurations.put("site", config.entryTtl(Duration.ofMinutes(10)));
        cacheConfigurations.put("site:list", config.entryTtl(Duration.ofMinutes(5)));
        cacheConfigurations.put("slots", config.entryTtl(Duration.ofMinutes(5)));
        cacheConfigurations.put("stats", config.entryTtl(Duration.ofMinutes(5)));
        cacheConfigurations.put("user", config.entryTtl(Duration.ofMinutes(30)));
        cacheConfigurations.put("user:list", config.entryTtl(Duration.ofMinutes(10)));
        cacheConfigurations.put("rule", config.entryTtl(Duration.ofHours(1)));

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(config)
                .withInitialCacheConfigurations(cacheConfigurations)
                .build();
    }
}
```

### 4.3 Embedded Redis 配置（开发/测试环境）

**EmbeddedRedisConfig.java**
```java
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

    @Bean
    public RedisConnectionFactory redisConnectionFactory(RedisServer redisServer) {
        RedisStandaloneConfiguration config = new RedisStandaloneConfiguration();
        config.setHost("localhost");
        config.setPort(redisServer.getBind());
        return new LettuceConnectionFactory(config);
    }
}
```

### 4.4 缓存配置属性（application.properties）

```properties
# 开发/测试环境自动使用 Embedded Redis（通过 @Profile 控制）
# 生产环境配置（application-prod.properties）
# spring.data.redis.host=localhost
# spring.data.redis.port=6379
# spring.data.redis.password=
# spring.data.redis.timeout=6000
```

---

## 五、缓存注解使用示例

### 5.1 VaccineServiceImpl.java

```java
@Service
public class VaccineServiceImpl extends ServiceImpl<VaccineMapper, Vaccine>
        implements VaccineService {

    // 缓存单个疫苗
    @Override
    @Cacheable(value = "vaccine", key = "#id")
    public Vaccine getById(Long id) {
        return baseMapper.selectById(id);
    }

    // 缓存疫苗列表
    @Override
    @Cacheable(value = "vaccine:list", key = "'all'")
    public List<Vaccine> list() {
        return baseMapper.selectList(null);
    }

    // 新增时清除缓存
    @Override
    @CacheEvict(value = {"vaccine", "vaccine:list"}, allEntries = true)
    public boolean save(Vaccine vaccine) {
        return baseMapper.insert(vaccine) > 0;
    }

    // 更新时清除缓存
    @Override
    @CacheEvict(value = {"vaccine", "vaccine:list"}, allEntries = true)
    public boolean updateById(Vaccine vaccine) {
        return baseMapper.updateById(vaccine) > 0;
    }

    // 删除时清除缓存
    @Override
    @CacheEvict(value = {"vaccine", "vaccine:list"}, allEntries = true)
    public boolean removeById(Long id) {
        return baseMapper.deleteById(id) > 0;
    }
}
```

### 5.2 VaccinationSiteServiceImpl.java

```java
@Service
public class VaccinationSiteServiceImpl extends ServiceImpl<VaccinationSiteMapper, VaccinationSite>
        implements VaccinationSiteService {

    @Override
    @Cacheable(value = "site", key = "#id")
    public VaccinationSite getById(Long id) {
        return baseMapper.selectById(id);
    }

    @Override
    @Cacheable(value = "site:list", key = "'all'")
    public List<VaccinationSite> list() {
        return baseMapper.selectList(null);
    }

    @Override
    @CacheEvict(value = {"site", "site:list"}, allEntries = true)
    public boolean save(VaccinationSite site) {
        return baseMapper.insert(site) > 0;
    }

    @Override
    @CacheEvict(value = {"site", "site:list"}, allEntries = true)
    public boolean updateById(VaccinationSite site) {
        return baseMapper.updateById(site) > 0;
    }

    @Override
    @CacheEvict(value = {"site", "site:list"}, allEntries = true)
    public boolean removeById(Long id) {
        return baseMapper.deleteById(id) > 0;
    }
}
```

### 5.3 SysUserServiceImpl.java

```java
@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser>
        implements SysUserService {

    @Override
    @Cacheable(value = "user", key = "#id")
    public SysUser getById(Long id) {
        return baseMapper.selectById(id);
    }

    @Override
    @Cacheable(value = "user:list", key = "'all'")
    public List<SysUser> list() {
        return baseMapper.selectList(null);
    }

    @Override
    @CacheEvict(value = {"user", "user:list"}, allEntries = true)
    public boolean save(SysUser user) {
        return baseMapper.insert(user) > 0;
    }

    @Override
    @CacheEvict(value = {"user", "user:list"}, allEntries = true)
    public boolean updateById(SysUser user) {
        return baseMapper.updateById(user) > 0;
    }

    @Override
    @CacheEvict(value = {"user", "user:list"}, allEntries = true)
    public boolean removeById(Long id) {
        return baseMapper.deleteById(id) > 0;
    }
}
```

### 5.4 AppointmentServiceImpl.java（预约时段缓存）

```java
@Service
public class AppointmentServiceImpl extends ServiceImpl<AppointmentMapper, Appointment>
        implements AppointmentService {

    // 缓存预约可用时段
    @Cacheable(value = "slots", key = "#siteId + ':' + #date.toString()")
    public List<AppointmentSlot> getAvailableSlots(Long siteId, LocalDate date) {
        // 查询可用时段逻辑
        return baseMapper.selectAvailableSlots(siteId, date);
    }

    // 预约创建/取消/核销时清除时段缓存
    @CacheEvict(value = "slots", allEntries = true)
    public Appointment createAppointment(Appointment appointment) {
        // 创建预约逻辑
        return appointment;
    }
}
```

---

## 六、新增/修改文件清单

### 6.1 新增文件

```
src/main/java/com/tjut/edu/vaccine_system/
├── config/
│   ├── RedisConfig.java                  # Redis 配置
│   └── EmbeddedRedisConfig.java          # 嵌入式 Redis 配置（开发环境）
```

### 6.2 修改文件（添加缓存注解）

| 文件 | 修改内容 |
|------|----------|
| `SysUserServiceImpl.java` | 添加 @Cacheable/@CacheEvict 注解 |
| `VaccineServiceImpl.java` | 添加 @Cacheable/@CacheEvict 注解 |
| `VaccinationSiteServiceImpl.java` | 添加 @Cacheable/@CacheEvict 注解 |
| `VaccineRuleServiceImpl.java` | 添加 @Cacheable/@CacheEvict 注解 |
| `StatsServiceImpl.java` | 添加 @Cacheable/@CacheEvict 注解 |
| `AppointmentServiceImpl.java` | 添加预约时段缓存 |

---

## 七、环境适配

| 环境 | Redis 来源 | 配置方式 |
|------|------------|----------|
| dev | Embedded Redis | @Profile("dev") 自动启用 |
| test | Embedded Redis | @Profile("test") 自动启用 |
| prod | 外部 Redis | application-prod.properties |

**application-prod.properties 示例**:
```properties
spring.data.redis.host=${REDIS_HOST:localhost}
spring.data.redis.port=${REDIS_PORT:6379}
spring.data.redis.password=${REDIS_PASSWORD:}
spring.data.redis.timeout=6000
```

---

## 八、验收标准

- [ ] 疫苗/接种点/用户信息被缓存
- [ ] 缓存命中时直接返回，不查询数据库
- [ ] 新增/更新/删除操作自动清除缓存
- [ ] 开发环境使用 Embedded Redis（自动分配端口）
- [ ] 生产环境可配置外部 Redis
- [ ] 缓存命中率可通过日志监控

---

## 九、风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|----------|
| Redis 连接失败 | 服务不可用 | 降级为内存缓存（Spring Cache 默认） |
| 缓存数据不一致 | 显示过期数据 | 合理的 TTL + 手动清除 |
| 序列化问题 | 缓存无法读取 | 使用 GenericJackson2JsonRedisSerializer |

---

**文档版本**: 1.0
**下一步**: 创建实施计划