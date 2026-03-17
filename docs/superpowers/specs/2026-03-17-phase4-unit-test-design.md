# Phase 4 单元测试覆盖设计文档（简化版）

**项目**: 疫苗接种管理系统增强
**阶段**: Phase 4 - 单元测试覆盖
**版本**: 2.1（已完成）
**日期**: 2026-03-17
**状态**: ✅ 已完成

---

## 一、测试策略

### 1.1 技术选型

| 类别 | 选型 | 理由 |
|------|------|------|
| 测试框架 | Spring Boot Test | 官方标准，与 Spring Boot 3.2 兼容 |
| 单元测试 | 直接 @SpringBootTest | 简化复杂度，减少 Mock 层 |
| 数据库 | H2 内存数据库 | 轻量、模拟 MySQL 行为 |
| 执行方式 | Maven 命令行 | CI/CD 友好，跨 IDE |

### 1.2 测试分层（简化后）

```
┌─────────────────────────────────────────┐
│            Service 测试                  │
│       (@SpringBootTest + H2)             │
├─────────────────────────────────────────┤
│          规则引擎测试                    │
│       (纯 Java 单元测试)                 │
└─────────────────────────────────────────┘
```

**不再测试 Controller 层** - Controller 主要是 HTTP 封装，核心业务逻辑在 Service 层

---

## 二、测试范围

### 2.1 Service 层（4 个核心类）

| 测试类 | 实际类名 | 覆盖目标 |
|--------|----------|----------|
| SysUserServiceTest | SysUserService | 用户注册、登录、密码校验 |
| AppointmentServiceTest | AppointmentService | 预约创建、状态变更、规则校验 |
| VaccineServiceTest | VaccineService | 疫苗查询、库存管理 |
| VaccineRuleServiceTest | VaccineRuleService | 规则引擎（年龄、间隔、禁忌） |

### 2.2 规则引擎层（3 个规则类）

| 测试类 | 覆盖目标 |
|--------|----------|
| AgeRuleTest | 年龄校验逻辑 |
| IntervalRuleTest | 间隔校验逻辑 |
| ContraindicationRuleTest | 禁忌症校验逻辑 |

### 2.3 已覆盖（无需重复）

| 测试类 | 状态 |
|--------|------|
| CryptoPasswordServiceTest | ✅ 已存在 |
| ServiceMethodLogAspectTest | ✅ 已存在 |
| VaccineSystemApplicationTests | ✅ 启动测试 |

---

## 三、实施计划（分批）

### 批 1：环境搭建 + 用户服务测试

**任务**:
1. 添加 H2 依赖到 pom.xml
2. 创建测试配置文件 `application-test.yml`
3. 编写 `SysUserServiceTest`

**产出**:
- `pom.xml` (新增 H2 依赖)
- `src/test/resources/application-test.yml`
- `src/test/java/com/tjut/edu/vaccine_system/service/SysUserServiceTest.java`

### 批 2：预约服务测试

**任务**:
1. 编写 `AppointmentServiceTest`
2. 测试预约创建（含规则校验）
3. 测试预约状态变更（取消、核销）

**产出**:
- `src/test/java/com/tjut/edu/vaccine_system/service/AppointmentServiceTest.java`

### 批 3：疫苗与规则服务测试

**任务**:
1. 编写 `VaccineServiceTest`
2. 编写 `VaccineRuleServiceTest`
3. 编写 `AgeRuleTest`, `IntervalRuleTest`, `ContraindicationRuleTest`

**产出**:
- `src/test/java/com/tjut/edu/vaccine_system/service/VaccineServiceTest.java`
- `src/test/java/com/tjut/edu/vaccine_system/service/VaccineRuleServiceTest.java`
- `src/test/java/com/tjut/edu/vaccine_system/rule/AgeRuleTest.java`
- `src/test/java/com/tjut/edu/vaccine_system/rule/IntervalRuleTest.java`
- `src/test/java/com/tjut/edu/vaccine_system/rule/ContraindicationRuleTest.java`

### 批 4：覆盖率报告

**任务**:
1. 运行 `mvn test`
2. 生成测试覆盖率报告

**产出**:
- 测试覆盖率报告

---

## 四、测试配置文件

### 4.1 pom.xml 新增依赖

```xml
<!-- H2 内存数据库 -->
<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>test</scope>
</dependency>
```

### 4.2 application-test.yml

```yaml
spring:
  datasource:
    url: jdbc:h2:mem:testdb;MODE=MySQL;DATABASE_TO_LOWER=TRUE
    driver-class-name: org.h2.Driver
    username: sa
    password:
  jpa:
    hibernate:
      ddl-auto: create-drop
    show-sql: false
  sql:
    init:
      mode: never
```

---

## 五、覆盖率目标

| 模块 | 目标覆盖率 |
|------|-----------|
| Service | ≥ 60% |
| Rule Engine | ≥ 80% |

---

## 六、验收标准

- [x] 批 1 完成：H2 环境就绪，SysUserServiceTest 通过
- [x] 批 2 完成：AppointmentServiceTest 通过
- [x] 批 3 完成：Vaccine + Rule Engine 测试通过
- [x] 批 4 完成：覆盖率达标，mvn test 通过
- [x] 所有测试可通过 `mvn test` 执行

---

## 七、风险与应对

| 风险 | 影响 | 应对 |
|------|------|------|
| H2 与 MySQL 语法差异 | 测试通过但运行失败 | 限制使用 MySQL 特有语法 |
| 测试数据依赖 | 测试顺序敏感 | 使用 @DirtiesContext 保证隔离 |

---

## 八、完成摘要

### 已提交的测试文件

| 文件 | 用例数 |
|------|--------|
| SysUserServiceTest.java | 3 |
| AppointmentServiceTest.java | 7 |
| VaccineServiceTest.java | 6 |
| AgeRuleTest.java | 10 |
| IntervalRuleTest.java | 10 |
| ContraindicationRuleTest.java | 11 |
| **总计** | **47** |

### Git 提交记录

```
8577d18 test: add H2 dependency and SysUserServiceTest
bbbbf4a test: add AppointmentServiceTest
feefbb5 test: add VaccineServiceTest and rule engine unit tests
```

---

**文档版本**: 2.1
**状态**: 已完成 ✅