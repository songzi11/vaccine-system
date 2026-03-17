# 疫苗接种管理系统增强设计文档

**项目名称**: 疫苗预约与接种管理系统增强
**版本**: 1.2
**日期**: 2026-03-17
**状态**: 实施中
**实施进度**: Phase 1 ✅ | Phase 2 ✅ | Phase 3 ✅ | Phase 4 ✅ | Phase 5 ⏳

## 一、设计目标

在不修改现有业务代码（已有功能）的前提下，为疫苗接种管理系统增加以下5项增强功能：

1. **密码加密存储** - 从明文密码升级为 BCrypt 加密
2. **规则引擎抽象** - 将业务规则从硬编码转为可配置的规则引擎
3. **接口层抽象** - 统一服务层代理，增强可扩展性
4. **单元测试覆盖** - 增加 Controller/Service 层测试覆盖
5. **Redis 缓存引入** - 为高频访问数据提供缓存支持

## 二、核心设计原则

- **最小侵入**: 仅在认证层面（Spring Security）进行密码升级拦截，不修改业务代码
- **平滑迁移**: 兼容旧数据，用户无感知
- **模块独立**: 各增强模块独立开发测试
- **配置驱动**: 规则和缓存策略可通过配置文件调整

---

## 三、模块详细设计

### 3.1 密码加密存储模块

#### 3.1.1 概述

将用户密码从明文存储升级为 BCrypt 加密存储，同时保持对老用户的兼容。

#### 3.1.2 新增文件

```
src/main/java/com/tjut/edu/vaccine_system/
├── security/
│   ├── CryptoPasswordService.java      # 加密服务接口
│   ├── CryptoPasswordServiceImpl.java  # 加密服务实现
│   └── config/
│       └── SecurityConfig.java         # Spring Security 配置
```

#### 3.1.3 核心接口

```java
public interface CryptoPasswordService {
    /**
     * 加密密码
     */
    String encode(String rawPassword);

    /**
     * 校验密码（兼容明文和加密两种）
     */
    boolean matches(String rawPassword, String encodedPassword);

    /**
     * 升级旧密码（明文 -> 加密）
     */
    boolean upgradePassword(Long userId, String rawPassword);
}
```

#### 3.1.4 兼容策略

1. **首次登录自动迁移**: 用户登录时，先尝试 BCrypt 匹配，失败则尝试明文匹配
2. **匹配成功后升级**: 明文匹配成功后，自动将密码升级为 BCrypt 存储
3. **升级实现**: 通过自定义 `DaoAuthenticationProvider` 在认证层完成密码校验和升级，**不修改现有 SysUserService 代码**

```java
@Component
public class CompatibleDaoAuthenticationProvider extends DaoAuthenticationProvider {

    private final CryptoPasswordService cryptoPasswordService;
    private final SysUserService sysUserService;

    // 通过构造器注入（Spring Security ProviderManager 支持）
    @Autowired
    public CompatibleDaoAuthenticationProvider(
            CryptoPasswordService cryptoPasswordService,
            SysUserService sysUserService,
            UserDetailsService userDetailsService,
            PasswordEncoder passwordEncoder) {
        super.setUserDetailsService(userDetailsService);
        super.setPasswordEncoder(passwordEncoder);
        this.cryptoPasswordService = cryptoPasswordService;
        this.sysUserService = sysUserService;
    }

    @Override
    protected void additionalAuthenticationChecks(UserDetails userDetails,
            UsernamePasswordAuthenticationToken authentication) throws AuthenticationException {
        // 先尝试 BCrypt 匹配
        try {
            super.additionalAuthenticationChecks(userDetails, authentication);
        } catch (BadCredentialsException e) {
            // BCrypt 匹配失败，尝试明文匹配（兼容老用户）
            String rawPassword = (String) authentication.getCredentials();
            String dbPassword = ((SysUser) userDetails).getPassword();
            if (rawPassword != null && rawPassword.equals(dbPassword)) {
                // 明文匹配成功，升级密码
                upgradePasswordToBCrypt(userDetails.getUsername(), rawPassword);
                return;
            }
            throw e;
        }
        // BCrypt 匹配成功，如果原来是明文则升级
        // 通过事件机制异步升级
    }

    @Async
    public void upgradePasswordToBCrypt(String username, String rawPassword) {
        // 使用 CryptoPasswordService 升级密码
        String encoded = cryptoPasswordService.encode(rawPassword);
        SysUser user = sysUserService.getOne(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getUsername, username));
        if (user != null) {
            user.setPassword(encoded);
            sysUserService.updateById(user);
        }
    }
}
```

#### 3.1.5 数据库变更

无需变更，密码字段仍为 `varchar(255)`

#### 3.1.6 依赖引入

```xml
<!-- Spring Security 已有，无需额外引入 -->
<!-- 使用 Spring Security 内置的 BCryptPasswordEncoder -->
```

---

### 3.2 规则引擎抽象模块

#### 3.2.1 概述

将预约校验逻辑（年龄、间隔、禁忌症）从硬编码转为可配置的规则引擎，支持数据库配置和 JSON 文件配置。

#### 3.2.2 新增文件

```
src/main/java/com/tjut/edu/vaccine_system/
├── rule/
│   ├── engine/
│   │   ├── RuleEngine.java             # 规则引擎接口
│   │   ├── RuleEngineImpl.java         # 规则引擎默认实现
│   │   └── context/
│   │       └── AppointmentRuleContext.java  # 预约校验上下文
│   ├── annotation/
│   │   ├── Rule.java                   # 规则定义注解
│   │   └── RuleGroup.java              # 规则组注解
│   ├── registry/
│   │   └── RuleRegistry.java           # 规则注册表
│   └── rules/
│       ├── AgeRule.java                # 年龄规则实现
│       ├── IntervalRule.java           # 间隔规则实现
│       └── ContraindicationRule.java   # 禁忌症规则实现
├── model/
│   ├── entity/
│   │   └── VaccineRule.java            # 疫苗规则实体（数据库）
│   └── dto/
│       └── RuleConfigDTO.java          # 规则配置 DTO
└── resources/
    ├── rules/
    │   ├── age-rules.json              # 年龄规则配置
    │   ├── interval-rules.json         # 间隔规则配置
    │   └── contraindication-rules.json # 禁忌症规则配置
```

#### 3.2.3 规则定义

**规则结构（JSON 配置）**:
```json
{
  "ruleCode": "AGE_CHECK",
  "ruleName": "适用年龄校验",
  "ruleGroup": "APPOINTMENT",
  "priority": 1,
  "enabled": true,
  "params": {
    "minAgeMonths": 0,
    "maxAgeMonths": 216
  },
  "errorCode": "AGE_NOT_APPLICABLE",
  "errorMessage": "该疫苗适用起始月龄为 {minAgeMonths} 月，当前儿童未达适用年龄"
}
```

**规则注解（Java 代码）**:
```java
@Rule(
    code = "AGE_CHECK",
    name = "适用年龄校验",
    group = RuleGroup.APPOINTMENT,
    priority = 1
)
public class AgeRule implements AppointmentRule {
    @Override
    public RuleResult validate(AppointmentRuleContext ctx) {
        // 实现逻辑
    }
}
```

#### 3.2.4 数据库表设计

```sql
-- 疫苗规则配置表
CREATE TABLE vaccine_rule (
    id              BIGINT PRIMARY KEY AUTO_INCREMENT,
    rule_code       VARCHAR(50) NOT NULL UNIQUE COMMENT '规则代码',
    rule_name       VARCHAR(100) NOT NULL COMMENT '规则名称',
    rule_group      VARCHAR(50) NOT NULL COMMENT '规则组',
    priority        INT DEFAULT 0 COMMENT '优先级',
    enabled         TINYINT DEFAULT 1 COMMENT '是否启用',
    params          JSON COMMENT '规则参数',
    error_code      VARCHAR(50) COMMENT '错误代码',
    error_message   VARCHAR(500) COMMENT '错误消息',
    create_time     DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted         TINYINT DEFAULT 0
);

-- 初始化默认规则
INSERT INTO vaccine_rule (rule_code, rule_name, rule_group, priority, enabled, params, error_code, error_message) VALUES
('AGE_CHECK', '适用年龄校验', 'APPOINTMENT', 1, true, '{"minAgeMonths": 0}', 'AGE_NOT_APPLICABLE', '该疫苗适用起始月龄为 {minAgeMonths} 月'),
('INTERVAL_CHECK', '接种间隔校验', 'APPOINTMENT', 2, true, '{}', 'INTERVAL_NOT_ENOUGH', '该疫苗两剂间隔至少 {intervalDays} 天'),
('CONTRAINDICATION_CHECK', '禁忌症校验', 'APPOINTMENT', 3, true, '{}', 'CONTRAINDICATION_CONFLICT', '儿童禁忌症与该疫苗存在冲突');
```

#### 3.2.5 规则加载策略

1. **加载优先级**: 数据库配置 > JSON 文件配置 > 代码默认值
2. **启动时加载**: 从数据库读取已启用的规则，转换为 Java 对象
3. **缓存机制**: 规则配置缓存到内存，支持手动刷新
4. **混合配置**: 规则逻辑在 Java 类，规则值在数据库

**JSON 文件加载机制**:
```java
@Component
public class RuleConfigLoader {
    @Value("classpath:rules/*.json")
    private Resource[] ruleResources;

    @PostConstruct
    public void loadJsonRules() {
        for (Resource resource : ruleResources) {
            try {
                String content = new String(resource.getInputStream().readAllBytes());
                List<VaccineRule> rules = objectMapper.readValue(content,
                    new TypeReference<List<VaccineRule>>() {});
                // 存储到数据库或内存缓存
            } catch (IOException e) {
                log.warn("Failed to load rule file: {}", resource.getFilename(), e);
            }
        }
    }
}
```

**规则引擎集成方式**:
- 在 `AppointmentService.createAppointment()` 方法中，通过 `RuleEngine` 执行规则校验
- 规则引擎返回 `List<RuleResult>`，遍历检查是否有失败项
- 如有失败项，抛出对应的 `BizException`

```java
/**
 * 预约校验上下文
 */
@Data
public class AppointmentRuleContext {
    private Long childId;                    // 儿童 ID
    private LocalDate birthDate;             // 儿童出生日期
    private Long vaccineId;                  // 疫苗 ID
    private Integer applicableAgeMonths;     // 疫苗适用起始月龄
    private Integer intervalDays;            // 疫苗接种间隔天数
    private String contraindicationAllergy;  // 儿童禁忌症/过敏史
    private String vaccineDescription;       // 疫苗描述（含禁忌信息）
    private String adverseReactionDesc;      // 不良反应描述
    private LocalDate appointmentDate;       // 预约日期
    private LocalDate lastVaccinationDate;   // 上次接种日期
}
```

#### 3.2.6 规则执行结果定义

```java
/**
 * 规则执行结果
 */
@Data
@Builder
public class RuleResult {
    private boolean passed;                  // 是否通过
    private String ruleCode;                 // 规则代码
    private String ruleName;                 // 规则名称
    private String errorCode;                // 错误代码
    private String errorMessage;             // 错误消息
}
```

#### 3.2.7 核心接口

```java
public interface RuleEngine {
    /**
     * 执行规则校验
     */
    RuleResult validate(String ruleGroup, RuleContext context);

    /**
     * 执行所有规则
     */
    List<RuleResult> validateAll(String ruleGroup, RuleContext context);

    /**
     * 刷新规则缓存
     */
    void refreshRules();
}
```

---

### 3.3 接口层抽象模块

#### 3.3.1 概述

使用 Spring AOP 为所有 Service 实现类提供统一的代理增强，实现方法日志和性能监控。

#### 3.3.2 新增文件

```
src/main/java/com/tjut/edu/vaccine_system/
└── aspect/
    └── ServiceMethodLogAspect.java     # 服务方法日志切面
```

#### 3.3.3 设计原理

使用 Spring AOP 为所有 `@Service` Bean 创建代理，实现：
- 方法执行日志
- 执行时间统计
- 异常捕获处理

```java
@Aspect
@Component
public class ServiceMethodLogAspect {
    private static final Logger log = LoggerFactory.getLogger(ServiceMethodLogAspect.class);

    @Around("execution(* com.tjut.edu.vaccine_system.service.impl..*.*(..))")
    public Object around(ProceedingJoinPoint pjp) throws Throwable {
        // 前置处理：日志、计时
        long start = System.currentTimeMillis();

        Object result = pjp.proceed();

        // 后置处理：日志、统计
        log.info("Method {} executed in {}ms", pjp.getSignature(), System.currentTimeMillis() - start);

        return result;
    }
}
```

#### 3.3.4 代理能力

| 能力 | 说明 |
|------|------|
| 日志记录 | 方法入参、返回值、异常 |
| 性能监控 | 方法执行时间统计 |
| 重试机制 | 失败自动重试（可选） |
| 熔断保护 | 异常时快速失败（可选） |

---

### 3.4 单元测试覆盖模块

#### 3.4.1 概述

为系统增加完整的测试覆盖，包括 Controller 层 API 测试、Service 层单元测试、集成测试。

#### 3.4.2 新增测试文件

```
src/test/java/com/tjut/edu/vaccine_system/
├── controller/
│   ├── AuthControllerTest.java         # 认证接口测试
│   ├── AppointmentControllerTest.java  # 预约接口测试
│   ├── VaccineControllerTest.java      # 疫苗接口测试
│   └── AdminControllerTest.java        # 管理员接口测试
├── service/
│   ├── SysUserServiceTest.java         # 用户服务测试
│   ├── AppointmentServiceTest.java     # 预约服务测试
│   ├── VaccineServiceTest.java         # 疫苗服务测试
│   └── RuleEngineTest.java             # 规则引擎测试
├── security/
│   └── CryptoPasswordServiceTest.java  # 加密服务测试
├── rule/
│   ├── AgeRuleTest.java                # 年龄规则测试
│   ├── IntervalRuleTest.java           # 间隔规则测试
│   └── ContraindicationRuleTest.java   # 禁忌症规则测试
└── integration/
    ├── BaseIntegrationTest.java        # 集成测试基类
    └── AppointmentFlowTest.java        # 预约流程集成测试
```

#### 3.4.3 测试框架选择

| 测试类型 | 框架 | 理由 |
|----------|------|------|
| Controller 测试 | MockMvc | 无需启动服务器，快速 |
| Service 测试 | Mockito | 单元测试，纯 Java |
| 集成测试 | H2 + Testcontainers | 真实数据库环境 |

#### 3.4.4 测试覆盖目标

| 模块 | 覆盖率目标 |
|------|-----------|
| Controller | 70%+ |
| Service | 80%+ |
| Rule Engine | 90%+ |

#### 3.4.5 依赖引入

```xml
<!-- 测试依赖 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
</dependency>

<!-- H2 内存数据库 -->
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>test</scope>
</dependency>

<!-- Testcontainers -->
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>testcontainers</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>mysql</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
```

#### 3.4.6 测试配置

```yaml
# src/test/resources/application-test.yml
spring:
  datasource:
    url: jdbc:h2:mem:testdb;MODE=MySQL;DATABASE_TO_LOWER=TRUE
    driver-class-name: org.h2.Driver
  jpa:
    hibernate:
      ddl-auto: create-drop
```

---

### 3.5 Redis 缓存模块

#### 3.5.1 概述

为高频访问数据提供缓存支持，使用 Spring Cache 抽象，支持本地缓存和 Redis 缓存无缝切换。

#### 3.5.2 新增文件

```
src/main/java/com/tjut/edu/vaccine_system/
├── cache/
│   ├── config/
│   │   ├── CacheProperties.java        # 缓存配置属性
│   │   └── EmbeddedRedisConfig.java    # 嵌入式 Redis 配置
│   ├── annotation/
│   │   ├── Cacheable.java              # 缓存注解（复用 Spring）
│   │   └── CacheEvict.java             # 缓存清除注解
│   └── aspect/
│       └── CacheMethodInterceptor.java # 缓存切面
└── config/
    └── RedisConfig.java                # Redis 配置
```

#### 3.5.3 缓存策略

| 数据 | 缓存 Key | TTL | 淘汰策略 |
|------|----------|-----|----------|
| 用户信息 | `user:{id}` | 30分钟 | LRU |
| 疫苗信息 | `vaccine:{id}` | 1小时 | LRU |
| 疫苗列表 | `vaccine:list` | 10分钟 | LRU |
| 接种点信息 | `site:{id}` | 10分钟 | LRU |
| 接种点列表 | `site:list` | 5分钟 | LRU |
| 预约可用时段 | `appointment:slots:{siteId}:{date}` | 5分钟 | LRU |
| 统计指标 | `stats:{type}` | 5分钟 | LRU |

#### 3.5.4 缓存注解使用

**说明**: 复用 Spring 原生 `@Cacheable` 和 `@CacheEvict` 注解，无需自定义。

```java
@Service
public class VaccineServiceImpl implements VaccineService {

    @Override
    @Cacheable(value = "vaccine", key = "#id")
    public Vaccine getById(Long id) {
        return baseMapper.selectById(id);
    }

    @Override
    @Cacheable(value = "vaccine:list", key = "'all'")
    public List<Vaccine> list() {
        return baseMapper.selectList(null);  // 查询所有疫苗
    }

    @Override
    @CacheEvict(value = {"vaccine", "vaccine:list"}, allEntries = true)
    public boolean save(Vaccine vaccine) {
        return baseMapper.insert(vaccine) > 0;
    }
}
```

#### 3.5.5 环境适配

**开发/测试环境**: 使用 Embedded Redis（内存模拟）

```java
@Configuration
public class EmbeddedRedisConfig {
    private static final Logger log = LoggerFactory.getLogger(EmbeddedRedisConfig.class);

    @Bean
    public RedisServer redisServer() throws IOException {
        // 自动分配可用端口，避免端口冲突
        int port = SocketUtils.findAvailableTcpPort(10000, 60000);
        log.info("Starting Embedded Redis on port {}", port);
        return new RedisServer(port);
    }

    @Bean
    public RedisConnectionFactory redisConnectionFactory(RedisServer redisServer) {
        // 配置 Redis 连接
        RedisStandaloneConfiguration config = new RedisStandaloneConfiguration();
        config.setPort(redisServer.getBind());
        return new LettuceConnectionFactory(config);
    }
}
```

**生产环境**: 使用外部 Redis

```yaml
# application-prod.yml
spring:
  data:
    redis:
      host: ${REDIS_HOST:localhost}
      port: ${REDIS_PORT:6379}
      password: ${REDIS_PASSWORD:}
```

#### 3.5.6 依赖引入

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

<!-- Embedded Redis (开发环境) -->
<dependency>
    <groupId>it.ozimov</groupId>
    <artifactId>embedded-redis</artifactId>
    <version>0.7.3</version>
    <scope>test</scope>
</dependency>

<!-- Jackson 处理 JSON -->
<dependency>
    <groupId>com.fasterxml.jackson.datatype</groupId>
    <artifactId>jackson-datatype-jsr310</artifactId>
</dependency>
```

---

## 四、集成架构

```
┌─────────────────────────────────────────────────────────────────┐
│                      应用层 (API)                               │
│  Controller -> Service (被代理) -> Mapper                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      增强层 (新增)                              │
├─────────────┬─────────────┬─────────────┬─────────────┬────────┤
│  密码加密    │  规则引擎    │  接口代理    │  单元测试    │  缓存   │
│ (security)  │   (rule)    │  (spring)   │   (test)    │ (cache)│
└─────────────┴─────────────┴─────────────┴─────────────┴────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      基础设施层                                 │
│  MySQL  |  Redis  |  Spring Cache  |  AOP                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 五、实施顺序

| 阶段 | 模块 | 说明 |
|------|------|------|
| **Phase 1** | 密码加密 | 基础安全模块，无依赖 |
| **Phase 2** | 规则引擎 | 业务增强，独立实施 |
| **Phase 3** | 接口代理 | 架构增强，独立实施 |
| **Phase 4** | 单元测试 | 验证所有模块 |
| **Phase 5** | Redis 缓存 | 性能优化，独立实施 |

---

## 六、风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|----------|
| 密码迁移失败 | 用户无法登录 | 保留明文兼容层，逐步迁移 |
| 规则配置错误 | 预约校验异常 | 配置校验，上线前测试 |
| 缓存数据不一致 | 显示过期数据 | 合理的 TTL + 手动清除 |
| Redis 连接失败 | 服务不可用 | 降级为内存缓存 |

---

## 七、验收标准

### 7.1 密码加密 (Phase 1 ✅)

- [x] 新注册用户密码自动加密存储
- [x] 老用户首次登录自动迁移
- [x] 登录验证通过 BCrypt 匹配

### 7.2 规则引擎 (Phase 2 ✅)

- [x] 规则可通过数据库配置
- [x] 规则可通过 JSON 文件配置
- [x] 规则修改无需重启服务

### 7.3 接口代理

- [x] Service 方法自动记录日志
- [x] 方法执行时间自动统计

### 7.4 单元测试

- [x] Service 层单元测试（47 个用例）
- [x] 规则引擎单元测试（AgeRule, IntervalRule, ContraindicationRule）
- [x] H2 内存数据库测试环境配置完成

### 7.5 Redis 缓存

- [ ] 疫苗/接种点/用户信息被缓存
- [ ] 缓存命中时直接返回，不查询数据库
- [ ] 开发环境使用 Embedded Redis

---

## 八、非功能性需求

| 需求 | 说明 |
|------|------|
| 兼容性 | Java 17 + Spring Boot 3.2 |
| 性能 | 缓存响应时间 < 10ms |
| 可维护性 | 模块间低耦合 |
| 可测试性 | 所有新增代码 100% 可测 |

---

## 九、实施记录

| 阶段 | 模块 | 状态 | 完成日期 | 备注 |
|------|------|------|----------|------|
| Phase 1 | 密码加密存储 | ✅ 完成 | 2026-03-17 | |
| Phase 2 | 规则引擎抽象 | ✅ 完成 | 2026-03-17 | |
| Phase 3 | 接口层抽象 | ✅ 完成 | 2026-03-17 | ServiceMethodLogAspect |
| Phase 4 | 单元测试覆盖 | ✅ 完成 | 2026-03-17 | 47 个测试用例 |
| Phase 5 | Redis 缓存 | ⏳ 待实施 | - | |

---

**文档版本**: 1.2
**文档状态**: 实施中
**下一步**: 继续实施 Phase 5 - Redis 缓存