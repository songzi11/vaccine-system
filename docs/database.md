# 疫苗接种系统 - 数据库设计文档（统一）

## 一、表关系说明

### 1. 总体关系

```
sys_user（系统用户：管理员、医生、居民/家长）
  ├── child_profile：家长 ──1:N── 儿童档案（parent_id）
  ├── appointment：家长 ──1:N── 预约（user_id，可选 child_id）
  ├── vaccination_record：居民/家长 ──1:N── 接种记录（user_id 冗余）
  └── notice：发布人 ──1:N── 通知公告（publisher_id）

child_profile（儿童档案）
  ├── appointment：儿童 ──0:N── 预约（child_id 可选）
  └── vaccination_record：儿童 ──1:N── 接种记录（child_id）

vaccination_site（接种点）
  ├── vaccine_site_stock：接种点 ──1:N── 按点库存（乐观锁 version）
  ├── vaccine_inventory：接种点 ──1:N── 按批次库存
  ├── appointment：接种点 ──1:N── 预约
  ├── vaccination_record：接种点 ──1:N── 接种记录
  └── doctor_dispatch：调出/调入站点 ──N:1── 医生调遣申请（from_site_id / to_site_id）

vaccine（疫苗信息）
  ├── vaccine_site_stock：疫苗 ──1:N── 按点库存（预约扣减）
  ├── vaccine_inventory：疫苗 ──1:N── 按批次库存（溯源）
  ├── appointment：疫苗 ──1:N── 预约
  └── vaccination_record：疫苗 ──1:N── 接种记录

appointment（预约单）
  └── vaccination_record：预约 ──0:1── 接种记录（一次预约对应一条完成记录）

vaccination_record（接种记录）
  └── adverse_reaction：接种记录 ──1:N── 不良反应上报

record（接种记录简表，与预约 order_id 关联）
  └── 与 appointment 关联，完成接种时写入
```

### 2. 核心业务关系

| 关系 | 说明 |
|------|------|
| 用户 ↔ 角色 | `sys_user.role`：ADMIN / DOCTOR / RESIDENT。 |
| 家长 ↔ 儿童档案 | `child_profile.parent_id`，用于预约选儿童、禁忌症避坑。 |
| 疫苗 ↔ 库存 | `vaccine_site_stock` 按疫苗+接种点，预约扣减、乐观锁；`vaccine_inventory` 按批次溯源。 |
| 预约 | 关联家长、儿童、接种点、疫苗；状态为整数：0-待审批，5-医生已通过待排班，1-已排班，2-已完成，3-已取消，4-已过期。 |
| 接种记录 | `record` 表与 `vaccination_record` 表：关联预约、儿童、疫苗批号、接种部位、留观无异常等。 |

---

## 二、核心表与字段

### 1. sys_user（系统用户表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键，自增。 |
| username | varchar(64) | 登录账号，唯一。 |
| password | varchar(128) | 密码（明文存储）。 |
| real_name | varchar(32) | 真实姓名。 |
| role | varchar(20) | ADMIN / DOCTOR / RESIDENT。 |
| gender | tinyint | 0-未知，1-男，2-女。 |
| phone | varchar(20) | 手机号。 |
| id_card | varchar(18) | 身份证号。 |
| address | varchar(200) | 常住地址。 |
| avatar | varchar(255) | 头像 URL。 |
| status | tinyint | 0-正常，1-已禁用，2-已注销（不可恢复）。见 UserStatusEnum。 |
| last_login_time | datetime | 最后登录时间（审计）。 |
| is_deleted | tinyint | 逻辑删除：0-未删除，1-已删除（注销不置 1）。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 2. child_profile（儿童档案表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| parent_id | bigint | 家长用户ID。 |
| name | varchar(32) | 儿童姓名。 |
| birth_date | date | 出生日期（计算月龄）。 |
| gender | tinyint | 0-未知，1-男，2-女。 |
| contraindication_allergy | varchar(500) | 禁忌症/过敏史。 |
| vaccination_card_no | varchar(64) | 接种卡号。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 3. vaccination_site（接种点表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| site_name | varchar(100) | 接种点名称。 |
| address | varchar(200) | 详细地址。 |
| contact_phone | varchar(20) | 联系电话。 |
| work_time | varchar(100) | 工作时间。 |
| status | tinyint | 0-禁用，1-启用（SiteStatusEnum）。禁用后不可预约、用户端不可见。 |
| description | varchar(500) | 备注。 |
| current_doctor_id | bigint | 当前驻场医生用户ID。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 3.1 doctor_dispatch（医生调遣申请表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| doctor_id | bigint | 医生用户ID。 |
| from_site_id | bigint | 调出接种点ID。 |
| to_site_id | bigint | 调入接种点ID。 |
| status | tinyint | 0-待审批，1-同意，2-拒绝（DoctorDispatchStatusEnum）。 |
| apply_time | datetime | 申请时间。 |
| approve_time | datetime | 审批时间。 |

同意后自动更新 vaccination_site.current_doctor_id（调入站点设驻场医生，调出站点若为该医生则清空）。

### 4. vaccine（疫苗信息表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| vaccine_name | varchar(100) | 疫苗名称。 |
| category | varchar(20) | CLASS_I / CLASS_II。 |
| manufacturer | varchar(100) | 生产厂家。 |
| vaccine_type | varchar(50) | 灭活、重组蛋白等。 |
| total_doses | int | 总剂次。 |
| interval_days | int | 剂次间隔天数。 |
| applicable_age_months | int | 适用起始月龄。 |
| dosage_desc | varchar(100) | 剂型/规格。 |
| description | text | 疫苗说明、注意事项。 |
| adverse_reaction_desc | text | 不良反应说明。 |
| status | tinyint | 0-下架，1-上架。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 5. vaccine_site_stock（疫苗按接种点库存，乐观锁）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| vaccine_id | bigint | 疫苗ID。 |
| site_id | bigint | 接种点ID。 |
| stock | int | 当前可用库存，预约时扣减。 |
| warning_threshold | int | 库存预警阈值。 |
| version | int | 乐观锁版本号。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 6. vaccine_inventory（疫苗库存表，按批次）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| vaccine_id | bigint | 疫苗ID。 |
| site_id | bigint | 接种点ID。 |
| batch_no | varchar(50) | 批次号。 |
| quantity | int | 入库数量。 |
| used_quantity | int | 已使用数量。 |
| expiry_date | date | 有效期至。 |
| storage_location | varchar(100) | 存放位置。 |
| status | tinyint | 0-停用，1-有效。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 7. appointment（预约单表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| user_id | bigint | 家长/居民用户ID。 |
| child_id | bigint | 儿童档案ID（可选）。 |
| vaccine_id | bigint | 疫苗ID。 |
| site_id | bigint | 接种点ID。 |
| appointment_date | date | 预约日期。 |
| time_slot | varchar(20) | 时段。 |
| status | tinyint | 0-待审批，5-医生已通过待排班，1-已排班，2-已完成，3-已取消，4-已过期。 |
| doctor_id | bigint | 分配医生ID。 |
| remark | varchar(200) | 备注。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 8. record（接种记录表，与预约关联）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| order_id | bigint | 预约ID。 |
| user_id | bigint | 家长ID。 |
| child_id | bigint | 宝宝ID。 |
| vaccine_id | bigint | 疫苗ID。 |
| doctor_id | bigint | 医生ID。 |
| site_id | bigint | 接种点ID。 |
| vaccinate_time | datetime | 接种时间。 |
| status | varchar(20) | 已接种/异常/取消。 |
| remark | varchar(255) | 备注。 |
| create_time / update_time | datetime | 创建/更新时间。 |
| is_deleted | tinyint | 逻辑删除。 |

### 9. vaccination_record（接种记录表，详表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| child_id | bigint | 接种儿童档案ID。 |
| user_id | bigint | 家长/居民ID（冗余）。 |
| vaccine_id | bigint | 疫苗ID。 |
| appointment_id | bigint | 关联预约ID。 |
| inventory_id | bigint | 使用的库存批次ID。 |
| batch_no | varchar(50) | 疫苗批号。 |
| dose_number | int | 第几针/剂次。 |
| vaccination_date | datetime | 实际接种时间。 |
| doctor_id | bigint | 接种医生ID。 |
| site_id | bigint | 接种点ID。 |
| injection_site | varchar(50) | 接种部位。 |
| observation_ok | tinyint | 留观无异常：0-否，1-是。 |
| reaction | varchar(500) | 不良反应简要记录。 |
| next_dose_date | date | 下次接种日期。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 10. adverse_reaction（不良反应上报表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| record_id | bigint | 接种记录ID。 |
| reporter_id | bigint | 上报人（家长）用户ID。 |
| symptoms | text | 症状描述。 |
| severity | varchar(20) | MILD / MODERATE / SEVERE。 |
| report_time | datetime | 上报时间。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 11. notice（通知公告表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| title | varchar(200) | 标题。 |
| content | text | 正文内容。 |
| type | varchar(20) | NORMAL / IMPORTANT / SYSTEM。 |
| publisher_id | bigint | 发布人ID。 |
| publisher_role | varchar(20) | 发布者角色：ADMIN / DOCTOR。 |
| audit_status | varchar(20) | 审核状态：PENDING / APPROVED / REJECTED（医生提交的公告需管理员审核）。 |
| reject_reason | varchar(500) | 未通过原因。 |
| is_top | tinyint | 是否置顶：0-否，1-是。 |
| status | tinyint | 0-草稿/下架，1-已发布。 |
| publish_time | datetime | 发布时间。 |
| create_time / update_time | datetime | 创建/更新时间。 |

### 12. notice_feedback（公告意见表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| notice_id | bigint | 公告ID。 |
| user_id | bigint | 提交人（医生）ID。 |
| content | text | 意见内容。 |
| create_time | datetime | 创建时间。 |

### 13. user_notice_read（用户公告已读表）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键。 |
| user_id | bigint | 用户ID。 |
| notice_id | bigint | 公告ID。 |
| read_time | datetime | 阅读时间。 |
| create_time / update_time | datetime | 创建/更新时间。 |

唯一约束：同一用户对同一公告仅一条已读记录。

### 14. ~~doctor_site（已移除）~~

医生-接种点关系由 **doctor_schedule**（排班表，含 doctor_id + site_id）与 **doctor_dispatch**（调遣审批）及 **vaccination_site.current_doctor_id**（驻场医生）体现，无需单独 doctor_site 表。

---

## 三、文献能力扩展表（库存预警、智能提醒、宣传推送）

### 1. stock_alert_log（库存/效期预警与补货提醒）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键 |
| alert_type | varchar(20) | LOW_STOCK / EXPIRY |
| vaccine_id | bigint | 疫苗ID |
| vaccine_name | varchar(100) | 疫苗名称（冗余） |
| site_id | bigint | 接种点ID |
| inventory_id | bigint | 批次库存ID |
| batch_no | varchar(50) | 批次号 |
| quantity | int | 入库数量 |
| used_quantity | int | 已使用数量 |
| remaining_ratio | decimal(5,2) | 剩余率（%） |
| expiry_date | date | 有效期至 |
| synced_to_supplier | tinyint | 是否已同步供应商：0-否，1-是 |
| create_time | datetime | 创建时间 |

### 2. supplier_sync_log（供应商同步记录）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键 |
| stock_alert_log_id | bigint | 关联 stock_alert_log.id |
| supplier_endpoint | varchar(255) | 供应商接口地址 |
| request_body | text | 请求体（JSON） |
| response_code | int | HTTP 状态码 |
| response_body | text | 响应体 |
| sync_time | datetime | 同步时间 |

### 3. vaccination_reminder_log（智能提醒推送记录）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键 |
| child_id | bigint | 儿童档案ID |
| user_id | bigint | 家长用户ID |
| vaccine_id | bigint | 疫苗ID |
| vaccine_name | varchar(100) | 疫苗名称 |
| dose_number | int | 待接种剂次 |
| remind_type | varchar(20) | SCHEDULE_72H 等 |
| appointment_link | varchar(500) | 预约链接 |
| push_channel | varchar(20) | WECHAT / APP / SMS |
| push_time | datetime | 推送时间 |
| create_time | datetime | 创建时间 |

### 4. campaign_push_log（宣传推送记录）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint | 主键 |
| vaccine_id | bigint | 疫苗ID |
| vaccine_name | varchar(100) | 疫苗名称 |
| site_id | bigint | 接种点ID（可选） |
| target_user_id | bigint | 目标家长用户ID |
| content | text | 推送内容 |
| push_channel | varchar(20) | 推送渠道 |
| push_time | datetime | 推送时间 |
| create_time | datetime | 创建时间 |

---

## 四、建表与执行顺序

- **完整建表脚本**：`src/main/resources/sql/vaccine_system.sql`

该脚本包含本文档所述全部表结构及外键、索引，执行顺序已按依赖关系排列（先父表后子表）。首次部署时直接执行该脚本即可完成数据库初始化。热力图等统计功能不建新表，由 vaccination_record 等表聚合查询。
