# 疫苗接种系统 (Vaccine Management System)

疫苗预约与接种管理系统：支持管理员、医生、居民三端，覆盖预约审核、排期、接种核销、库存调拨、统计报表与智能提醒。

| 角色     | 说明 |
|----------|------|
| **管理员** | 用户/疫苗/接种点/公告管理、排期、库存调拨与预警、统计大屏 |
| **医生**   | 预约审核、待接种核销、派遣信息、公告发布（需审核） |
| **居民**   | 宝宝档案、预约接种、接种点查询、我的预约、接种记录、公告 |

- **后端**：本仓库 `vaccine_system`（Spring Boot 3.2 + MyBatis-Plus + MySQL）  
- **前端**：UniApp 多端应用（H5 / 小程序 / App），可与同工作区下的 `vaccine.app` 项目配合使用。  
- **接口基础 URL**：默认 `http://localhost:8080`（可配置）。

---

## 功能概览

- **预约流程**：居民提交预约 → 医生审核（通过/拒绝）→ 管理员排期（指定医生与日期）→ 医生完成接种（核销、扣减接种点批次库存、写接种记录）。
- **库存架构**：总仓批次（`vaccine_batch`）仅通过**调拨**减少；接种点按批次库存（`site_vaccine_stock`）负责预约锁定（FEFO）与核销扣减；简易库存（`vaccine_site_stock`）用于预警与阈值。
- **其他**：接种点启用/禁用与驻场医生指派、公告管理（含医生提交审核）、库存预警与智能提醒（如 72 小时接种提醒）、统计报表与统计大屏。

---

## 技术栈

| 端   | 技术 |
|------|------|
| 后端 | Java 17、Spring Boot 3.2、MyBatis-Plus、MySQL 8、Lombok、AOP、Validation |
| 前端 | UniApp（Vue 2/3）、多端（H5 / 微信小程序 / App） |

---

## 快速开始

### 环境要求

- JDK 17  
- Maven 3.6+  
- MySQL 8（库名默认 `vaccine_system`）

### 后端

```bash
cd vaccine_system
# 修改 src/main/resources/application.properties 中的数据库连接（url、username、password）
mvn spring-boot:run
```

服务默认端口：`8080`。

### 前端（vaccine.app）

- 使用 HBuilderX 或 CLI 打开 `vaccine.app` 项目，配置请求 baseURL 为 `http://localhost:8080`（或你的后端地址）。
- 运行到浏览器 / 微信开发者工具 / 真机等。详见 [使用手册](docs/使用文档.md) 中的前端页面与模块说明。

### 数据库

- 需先创建数据库并执行建表脚本（表结构说明见 [docs/database.md](docs/database.md)）。

---

## 项目结构（后端）

```
vaccine_system/
├── src/main/java/com/tjut/edu/vaccine_system/
│   ├── controller/   # admin / doctor / user / common
│   ├── service/       # 业务与库存、调拨、预约、核销等
│   ├── mapper/        # MyBatis-Plus Mapper
│   ├── model/         # entity / dto / vo
│   ├── config/        # 安全、CORS、异常处理等
│   └── task/          # 定时任务（库存预警、提醒、过期联动）
├── src/main/resources/
│   ├── application.properties
│   └── mapper/*.xml
├── docs/              # 文档目录
└── pom.xml
```

---

## 文档

| 文档 | 说明 |
|------|------|
| [使用手册](docs/使用文档.md) | 三端功能说明、预约与库存流程、前端页面与模块对应、注意事项 |
| [API 接口文档](docs/API.md) | 接口路径、请求/响应、路由规范（admin/doctor/user/common） |
| [数据库设计](docs/database.md) | 表结构与关系说明 |

业务或接口变更时，请同步更新上述文档。

---

## 注意事项

- **密码**：当前为明文存储，生产环境请改为加密存储并做好权限与审计。  
- **跨域与 baseURL**：前端需与后端端口、协议一致，后端已提供 CORS 配置。  
- **权限**：接口按路径区分角色（admin/doctor/user/common），前端按登录角色控制菜单与按钮。

---

## 许可证

本项目仅供学习与毕业设计使用。
