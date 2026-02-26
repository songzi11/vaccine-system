# 疫苗接种系统 - 接口文档（统一）

**基础 URL**：`http://localhost:8080`

**统一响应**：`Result<T>` — `code`(200 成功)、`message`、`data`。分页为 `PageResult<T>`：`records`、`total`、`current`、`size`、`pages`。

**路由规范**：管理员 `/admin/**`，医生 `/doctor/**`，用户端 `/user/**`，公共 `/common/**`。

**接种点状态（vaccination_site.status，SiteStatusEnum）**：0=禁用，1=启用。禁用后不可预约、用户端不可见（`/user/site/listWithStock` 仅返回启用站点）。

**用户状态（sys_user.status，UserStatusEnum）**：0=正常，1=已禁用，2=已注销（不可恢复）。禁止使用字符串状态。

**预约状态（appointment.status 整数）**：0=待审批 → 5=医生已通过待排班 → 1=已排班 → 2=已完成（接种时生成 record、扣库存）| 3=已取消 | 4=已过期。

**库存扣减**：预约创建时按 FEFO 锁定接种点按批次库存（site_vaccine_stock：available_stock→locked_stock）；医生完成接种时扣减该批次的 locked_stock、写接种记录。总仓（vaccine_batch）仅通过管理员调拨减少。简易库存（vaccine_site_stock）用于预警与阈值，详见使用手册「库存与调拨架构」。

**疫苗上下架（vaccine.status，VaccineStatusEnum）**：0=下架，1=上架。下架后：用户端/医生端不可选该疫苗预约；用户端疫苗列表、预约选疫苗仅返回上架疫苗；用户端接种点列表的库存、管理员接种点详情及库存接口仅展示上架疫苗的库存；预约创建时若疫苗已下架会报错「该疫苗已下架，无法预约」。

---

## 一、公共 Common

### 1.1 登录与校验 `/common/auth`

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/common/auth/login` | 用户登录 |
| GET | `/common/auth/check-username` | 校验用户名是否存在且有效 |
| POST | `/common/auth/register` | 用户注册（RegisterDTO） |

**登录请求体**：`{ "username": "必填", "password": "必填" }`  
**响应 data**：`LoginUserVO`（id、username、role），供前端顶部展示；仅 status=正常 可登录，登录成功更新 last_login_time。

---

## 二、管理员 Admin

### 2.1 用户管理 `/admin/user`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/user/page` | 分页查询用户（current, size, username, role, status），返回 UserListVO（含状态标签、创建时间、最后登录时间） |
| GET | `/admin/user/{id}` | 根据 ID 查询（UserListVO） |
| GET | `/admin/user/detail/{id}` | 用户详情（UserDetailVO：家长含 childList、appointmentList、recordList；医生含 scheduleList、今日预约数、历史接种数） |
| POST | `/admin/user` | 新增用户（密码明文存储） |
| PUT | `/admin/user/{id}` | 更新用户（若传密码则明文更新） |
| PUT | `/admin/user/{id}/reset-password` | 重置密码（请求体含 password，明文存储） |
| POST | `/admin/user/deactivate/{id}` | 注销用户（不可恢复；请求体 `{ "adminPassword": "管理员当前登录密码" }`，请求头 `X-User-Id` 为当前管理员 ID） |
| POST | `/admin/user/disable/{id}` | 禁用用户（可恢复） |
| POST | `/admin/user/enable/{id}` | 恢复用户（仅对已禁用有效） |
| DELETE | `/admin/user/{id}` | 逻辑删除用户 |
| DELETE | `/admin/user/batch` | 批量逻辑删除（请求体：ID 数组） |

### 2.2 疫苗管理 `/admin/vaccine`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/vaccine/page` | 分页（current, size, vaccineName, status）；用户/医生端选疫苗时传 status=1 仅查上架 |
| GET | `/admin/vaccine/{id}` | 详情 |
| POST | `/admin/vaccine` | 新增 |
| PUT | `/admin/vaccine/{id}` | 修改 |
| PUT | `/admin/vaccine/{id}/status` | 上架/下架（请求体 `{ "status": 0|1 }`） |
| DELETE | `/admin/vaccine/{id}` | 删除 |

### 2.3 接种点管理 `/admin/site`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/site/page` | 分页（current, size, siteName, status），返回 SiteVO |
| GET | `/admin/site/{id}` | 详情（含库存列表、驻场医生、今日预约数），返回 SiteDetailVO |
| POST | `/admin/site` | 新增（SiteDTO） |
| PUT | `/admin/site/{id}` | 修改（SiteDTO） |
| DELETE | `/admin/site/{id}` | 删除 |
| POST | `/admin/site/enable/{id}` | 启用接种点 |
| POST | `/admin/site/disable/{id}` | 禁用接种点（禁用后不可预约、用户端不可见） |
| PUT / POST | `/admin/site/{id}/assignDoctor/{doctorId}` | 指定驻场医生（已取消二次验证）；仅管理员可操作；指派后向该医生推送调遣通知 |
| POST | `/admin/site/{id}/clearDoctor` | 清空该接种点驻场医生 |
| GET | `/admin/site/{siteId}/stock` | 某接种点库存列表（SiteStockVO） |
| POST | `/admin/site/{siteId}/stock/add` | 增加库存（StockAddDTO：仅 vaccineId 必填，**每次固定 +1**） |
| POST | `/admin/site/{siteId}/stock/reduce` | 减少库存（StockReduceDTO：仅 vaccineId 必填，**每次固定 -1**） |

### 2.3.1 派遣记录（管理员） `/admin/dispatch`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/dispatch/list` | 全部派遣记录列表（管理员指派驻场医生时自动推送，此处仅查看） |

### 2.4 公告管理 `/admin/notice`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/notice/page` | 分页（current, size, title, type, status） |
| GET | `/admin/notice/pending` | 待审核公告列表（医生提交的公告） |
| GET | `/admin/notice/{id}` | 详情 |
| GET | `/admin/notice/{id}/feedback` | 某公告的意见反馈列表 |
| POST | `/admin/notice` | 新增 |
| PUT | `/admin/notice/{id}` | 修改 |
| PUT | `/admin/notice/{id}/approve` | 审核通过公告 |
| PUT | `/admin/notice/{id}/reject` | 审核拒绝公告（可传拒绝原因） |
| PUT | `/admin/notice/{id}/offline` | 下架公告（仅管理员可见，不物理删除） |
| PUT | `/admin/notice/{id}/online` | 上架公告（重新对用户端展示） |
| PUT | `/admin/notice/{id}/top` | 置顶公告 |
| PUT | `/admin/notice/{id}/untop` | 取消置顶公告 |

### 2.5 库存预警与调拨 `/admin/stock`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/stock/warning` | 库存预警列表（stock < 预警阈值，基于 vaccine_site_stock） |
| GET | `/admin/stock/alerts` | 批次/效期预警记录（limit 默认 50） |
| POST | `/admin/stock/check-and-sync` | 手动执行：百白破剩余率<10%与效期预警并同步供应商 |
| GET | `/admin/stock/site-stock` | 接种点按批次库存（siteId 必填，返回 site_vaccine_stock 可用/锁定） |
| POST | `/admin/stock/transfer` | 总仓调拨至接种点（Body: TransferDTO { batchId, siteId, quantity }，可选 query operatorId） |
| GET | `/admin/stock/transfer-logs` | 调拨日志分页（current, size, batchId, fromTime, toTime） |

### 2.5.1 总仓批次管理 `/admin/batch`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/batch/page`、`/list` | 分页查询批次（current, size, vaccineId, status；status 0正常 1临期 2过期 3已销毁） |
| GET | `/admin/batch/by-status` | 按状态查询批次列表（status 选填） |
| GET | `/admin/batch/{id}` | 批次详情 |
| POST | `/admin/batch` | 新增批次（入库） |
| POST | `/admin/batch/dispose` | 执行销毁（BatchDisposeDTO：batchId、disposalReason、disposalDate、operatorId、remark） |

### 2.6 接种记录管理 `/admin/record`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/record/page` | 分页 record 表（current, size, userId, childId） |
| GET | `/admin/record/vaccination/page` | 分页 vaccination_record 表 |
| GET | `/admin/record/vaccination/{id}` | vaccination_record 详情 |
| POST | `/admin/record` | 新增 record 表记录 |
| POST | `/admin/record/vaccination` | 接种核销（CreateRecordDTO） |
| PUT | `/admin/record/{id}` | 修改 record |
| DELETE | `/admin/record/{id}` | 删除 record |

### 2.6.1 儿童档案（管理员） `/admin/child`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/child/page`、`/list` | 分页（current, size, parentId） |
| GET | `/admin/child/{id}` | 详情 |
| POST | `/admin/child` | 新增（parentId 指定家长） |
| PUT | `/admin/child/{id}` | 修改 |
| DELETE | `/admin/child/{id}` | 删除 |

### 2.6.2 医生统计 `/admin/doctor`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/doctor/{id}/stats` | 医生账号统计（user 信息、scheduleList、今日预约数、历史接种数） |

### 2.7 预约排期 `/admin/appointment`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/appointment/approved`、`/pending` | 待排班列表（status=5 医生已通过，供管理员排期） |
| GET | `/admin/appointment/page` | 预约列表（current, size, status 0/1/2/3/4, userId, siteId） |
| POST | `/admin/appointment/approve/{id}` | 审批/排班（ApproveAppointmentDTO：待审批→已排班，不扣库存） |
| GET | `/admin/appointment/children` | 儿童档案列表（current, size, parentId） |
| GET | `/admin/appointment/doctors` | 医生列表（用于排期选择） |
| POST | `/admin/appointment/schedule` | 排期（兼容，同 approve） |

### 2.8 智能提醒与推送 `/admin/reminder`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/reminder/logs` | 智能提醒推送记录（limit） |
| GET | `/admin/reminder/campaign-logs` | 宣传推送记录（limit） |
| POST | `/admin/reminder/run-72h` | 脊灰第3剂提前72小时推送（baseUrl 选填） |
| POST | `/admin/reminder/campaign-push` | 麻腮风宣传推送（vaccineName, content 选填） |

### 2.9 统计报表 `/admin/stats`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/admin/stats/today-vaccination` | 今日接种人数 |
| GET | `/admin/stats/todayCount` | 今日接种（record 表） |
| GET | `/admin/stats/vaccineCount` | 各疫苗接种次数 |
| GET | `/admin/stats/last7days` | 近7天接种趋势 |
| GET | `/admin/stats/vaccine-stock` | 各疫苗库存统计 |
| GET | `/admin/stats/monthly-trend` | 每月接种趋势（year 选填） |
| GET | `/admin/stats/low-stock` | 低库存预警（threshold 默认 5） |
| GET | `/admin/stats/trend-7days` | 近7天每日趋势 |
| GET | `/admin/stats/heatmap` | 多维热力图（dateFrom, dateTo 选填） |
| GET | `/admin/stats/dashboard` | 统计大屏聚合（lowStockThreshold 默认 5） |

---

## 三、医生 Doctor

### 3.1 个人档案 `/doctor/profile`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/doctor/profile` | 当前医生档案信息（DoctorProfileVO） |
| GET | `/doctor/profile/vaccinated-records` | 当前医生的历史接种记录列表 |

### 3.2 接种处理 `/doctor/vaccinate`

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/doctor/vaccinate/finish/{orderId}` | 完成接种（校验已排班→插 record、扣库存、预约 status=2） |
| POST | `/doctor/vaccinate` | 接种核销（CreateRecordDTO，须已排班，写 vaccination_record） |

### 3.3 预约与档案 `/doctor/appointment`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/doctor/appointment/pending` | 待医生审核的预约列表（status=0） |
| GET | `/doctor/appointment`、`/scheduled` | 今日已排班列表（status=1 且 appointmentDate=今日） |
| GET | `/doctor/appointment/scheduled/future` | 未来已排班列表 |
| GET | `/doctor/appointment/scheduled/detail/{id}` | 已排班预约详情（DoctorAppointmentDetailVO） |
| GET | `/doctor/appointment/child/{id}` | 查看宝宝健康档案 |
| PUT | `/doctor/appointment/{id}/review` | 医生审核预约（ReviewAppointmentDTO：通过→status=5 待排班，拒绝→status=3） |

### 3.4 公告（医生） `/doctor/notice`

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/doctor/notice/submit` | 医生提交公告（待管理员审核） |
| GET | `/doctor/notice/my` | 我提交的公告列表 |
| PUT | `/doctor/notice/{id}/reapply` | 被拒后重新提交 |
| DELETE | `/doctor/notice/{id}/withdraw` | 撤回待审核公告 |
| POST | `/doctor/notice/feedback` | 对某公告提交意见反馈 |

### 3.5 调遣通知 `/doctor/dispatch`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/doctor/dispatch/unreadCount` | 未读调遣通知数量（参数 doctorId），用于首页红点展示 |
| GET | `/doctor/dispatch/list` | 我的调遣通知列表（参数 doctorId），状态：0=已推送，1=已读 |
| POST | `/doctor/dispatch/{id}/read` | 标记已读（参数 doctorId） |

---

## 四、用户 User

### 4.1 接种点信息 `/user/site`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/user/site/listWithStock` | 接种点列表（仅 status=启用），含各疫苗库存、驻场医生（SiteWithStockVO） |

### 4.2 预约 `/user/appointment`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/user/appointment/stock` | 某疫苗某接种点可用库存（vaccineId, siteId） |
| POST | `/user/appointment` | 创建预约（CreateAppointmentDTO，智能检查） |
| GET | `/user/appointment/page` | 分页我的预约（current, size, userId, vaccineId, siteId, status） |
| GET | `/user/appointment/{id}` | 预约详情 |

### 4.3 接种记录 `/user/record`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/user/record/my` | 我的接种记录（含疫苗名、接种点名、医生名，传 userId） |
| GET | `/user/record/child/{childId}` | 根据宝宝查询接种记录 |

### 4.4 儿童档案 `/user/child`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/user/child/page` | 分页儿童档案（current, size, parentId） |
| GET | `/user/child/{id}` | 详情 |
| POST | `/user/child` | 新增儿童档案 |
| PUT | `/user/child/{id}` | 修改 |
| DELETE | `/user/child/{id}` | 删除 |

### 4.5 公告列表 `/user/notice`

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/user/notice/page`、`/list` | 分页已发布公告（仅 status=已发布且管理员发布或医生提交已审核通过），可选 title |
| GET | `/user/notice/{id}` | 公告详情（仅已发布） |

---

## 五、DTO 说明

- **LoginDTO**：`username`, `password`（必填）
- **SiteDTO**：`siteName` 必填；`address`, `contactPhone`, `workTime`, `status`(0禁用 1启用), `description` 选填
- **StockAddDTO**：仅 `vaccineId` 必填（每次固定 +1，无需传 quantity）
- **StockReduceDTO**：仅 `vaccineId` 必填（每次固定 -1，无需传 quantity）
- **DispatchApplyDTO**：`doctorId`, `fromSiteId`, `toSiteId` 必填
- **CreateAppointmentDTO**：`vaccineId`, `orderDate`, `siteId` 必填；`orderTime`, `userId`, `childId`, `remark` 选填（预约时校验接种点启用、库存）
- **CreateRecordDTO**：`appointmentId` 必填；`operatorUserId`, `doseNumber`, `batchNo`, `injectionSite`, `observationOk`, `reaction` 选填
- **TransferDTO**：`batchId`, `siteId`, `quantity` 必填（总仓调拨至接种点）
- **BatchDisposeDTO**：`batchId` 必填；`disposalReason`, `disposalDate`, `operatorId`, `remark` 选填
- **ReviewAppointmentDTO**：`approved`（true/false）, `doctorId`
- **ScheduleAppointmentDTO**：`appointmentId`, `doctorId`, `scheduleDate` 必填；`timeSlot` 选填
- **RegisterDTO**：`username`, `password`, `role` 等注册字段（与新增用户类似）

---

## 六、状态码

| code | 说明     |
|------|----------|
| 200  | 成功     |
| 400  | 请求参数错误 |
| 404  | 资源不存在   |
| 500  | 操作失败    |
