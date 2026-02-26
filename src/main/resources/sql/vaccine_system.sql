/*
 Navicat Premium Data Transfer

 Source Server         : localatabase
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : vaccine_system

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 26/02/2026 10:03:18
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for adverse_reaction
-- ----------------------------
DROP TABLE IF EXISTS `adverse_reaction`;
CREATE TABLE `adverse_reaction`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `record_id` bigint NOT NULL COMMENT '接种记录ID',
  `reporter_id` bigint NULL DEFAULT NULL COMMENT '上报人（家长）用户ID',
  `symptoms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '症状描述',
  `severity` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '严重程度：MILD/MODERATE/SEVERE',
  `report_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上报时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_record_id`(`record_id` ASC) USING BTREE,
  INDEX `idx_reporter_id`(`reporter_id` ASC) USING BTREE,
  INDEX `idx_report_time`(`report_time` ASC) USING BTREE,
  CONSTRAINT `fk_ar_record` FOREIGN KEY (`record_id`) REFERENCES `vaccination_record` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_ar_reporter` FOREIGN KEY (`reporter_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '不良反应上报表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of adverse_reaction
-- ----------------------------
INSERT INTO `adverse_reaction` VALUES (1, 1, 4, '接种处轻微红肿', 'MILD', '2025-02-17 14:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (2, 2, 4, '无', 'MILD', '2025-02-18 15:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (3, 3, 5, '无', 'MILD', '2025-02-20 16:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (4, 4, 5, '低热 37.5℃', 'MILD', '2025-02-21 18:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (5, 5, 5, '无', 'MILD', '2025-02-22 17:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (6, 6, 5, '无', 'MILD', '2025-02-24 19:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (7, 7, 4, '无', 'MILD', '2025-01-10 20:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (8, 8, 4, '乏力半天', 'MILD', '2025-01-15 21:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (9, 9, 4, '无', 'MILD', '2025-01-20 22:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `adverse_reaction` VALUES (10, 10, 5, '发热 38℃ 持续一天', 'MODERATE', '2025-01-26 10:00:00', '2026-02-11 23:03:22', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for appointment
-- ----------------------------
DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '家长/居民用户ID',
  `child_id` bigint NULL DEFAULT NULL COMMENT '儿童档案ID',
  `vaccine_id` bigint NOT NULL COMMENT '疫苗ID',
  `batch_id` bigint NULL DEFAULT NULL COMMENT 'FEFO 分配的批次ID',
  `site_id` bigint NOT NULL COMMENT '接种点ID',
  `doctor_schedule_id` bigint NULL DEFAULT NULL COMMENT '排班ID（预约时必选）',
  `appointment_date` date NOT NULL COMMENT '预约日期',
  `time_slot` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时段',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1已预约 6已签到 7预检通过 9预检未通过 10留观中 2已完成 3已取消 4已过期',
  `doctor_id` bigint NULL DEFAULT NULL COMMENT '分配医生ID',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `observe_start_time` datetime NULL DEFAULT NULL COMMENT '留观开始时间（完成接种时写入）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_child_id`(`child_id` ASC) USING BTREE,
  INDEX `idx_vaccine_id`(`vaccine_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_appointment_date`(`appointment_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_doctor_id`(`doctor_id` ASC) USING BTREE,
  INDEX `idx_doctor_schedule_id`(`doctor_schedule_id` ASC) USING BTREE,
  INDEX `idx_batch_id`(`batch_id` ASC) USING BTREE,
  CONSTRAINT `fk_appointment_batch` FOREIGN KEY (`batch_id`) REFERENCES `vaccine_batch` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_child` FOREIGN KEY (`child_id`) REFERENCES `child_profile` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_doctor_schedule` FOREIGN KEY (`doctor_schedule_id`) REFERENCES `doctor_schedule` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_site` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_vaccine` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccine` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '预约单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of appointment
-- ----------------------------
INSERT INTO `appointment` VALUES (1, 4, 1, 1, NULL, 1, NULL, '2026-02-11', '08:00-09:00', 2, 2, '第一针', NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (2, 4, 2, 6, NULL, 1, NULL, '2026-02-11', '08:00-09:00', 2, 2, NULL, NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (3, 4, NULL, 3, NULL, 1, NULL, '2025-02-17', '08:00-09:00', 2, 2, '第二针', NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (4, 4, NULL, 4, NULL, 1, NULL, '2025-02-18', '10:00-11:00', 2, 2, NULL, NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (5, 4, NULL, 8, NULL, 1, NULL, '2025-02-19', '08:00-09:00', 3, NULL, '改期', NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (6, 5, 6, 2, NULL, 1, NULL, '2025-02-20', '09:00-10:00', 2, 2, NULL, NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (7, 5, 7, 7, NULL, 2, NULL, '2025-02-21', '08:00-09:00', 2, 3, NULL, NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (8, 5, 8, 1, NULL, 2, NULL, '2025-02-22', '10:00-11:00', 2, 3, '第一针', NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (9, 5, 9, 5, NULL, 2, NULL, '2025-02-23', '08:00-09:00', 4, NULL, NULL, NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (10, 5, 10, 9, NULL, 2, NULL, '2025-02-24', '09:00-10:00', 2, 3, NULL, NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `appointment` VALUES (11, 4, NULL, 1, NULL, 1, NULL, '2026-02-11', '08:00-09:00', 4, 2, NULL, NULL, '2026-02-11 23:39:28', '2026-02-11 23:39:28');
INSERT INTO `appointment` VALUES (12, 4, NULL, 1, NULL, 1, NULL, '2026-02-12', '08:00-09:00', 2, 6, NULL, NULL, '2026-02-12 07:57:14', '2026-02-12 07:57:14');
INSERT INTO `appointment` VALUES (13, 4, 2, 1, NULL, 1, NULL, '2026-03-12', '08:00-09:00', 3, 2, NULL, NULL, '2026-02-12 08:28:15', '2026-02-12 08:28:15');
INSERT INTO `appointment` VALUES (14, 4, 1, 5, NULL, 1, NULL, '2026-04-30', '08:00-09:00', 3, NULL, NULL, NULL, '2026-02-12 19:19:42', '2026-02-12 19:19:42');
INSERT INTO `appointment` VALUES (15, 4, 1, 3, NULL, 1, NULL, '2026-02-24', '08:00-09:00', 2, 7, NULL, NULL, '2026-02-24 09:58:27', '2026-02-24 09:58:27');
INSERT INTO `appointment` VALUES (16, 4, 1, 6, NULL, 1, NULL, '2026-02-26', '08:00-09:00', 3, 2, NULL, NULL, '2026-02-24 17:25:24', '2026-02-24 17:25:24');
INSERT INTO `appointment` VALUES (17, 4, 1, 2, NULL, 1, 134, '2026-02-25', '08:00-08:15', 10, 2, NULL, '2026-02-25 15:34:43', '2026-02-25 15:10:58', '2026-02-25 15:10:58');

-- ----------------------------
-- Table structure for campaign_push_log
-- ----------------------------
DROP TABLE IF EXISTS `campaign_push_log`;
CREATE TABLE `campaign_push_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vaccine_id` bigint NOT NULL COMMENT '疫苗ID',
  `vaccine_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '疫苗名称',
  `site_id` bigint NULL DEFAULT NULL COMMENT '接种点ID',
  `target_user_id` bigint NOT NULL COMMENT '目标家长用户ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '推送内容',
  `push_channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'WECHAT' COMMENT '推送渠道',
  `push_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '推送时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_vaccine_id`(`vaccine_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_target_user_id`(`target_user_id` ASC) USING BTREE,
  INDEX `idx_push_time`(`push_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '宣传推送记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of campaign_push_log
-- ----------------------------
INSERT INTO `campaign_push_log` VALUES (1, 6, '流感疫苗', 1, 4, '流感高发季来临，建议为宝宝预约流感疫苗，南开区社区卫生服务中心可接种。', 'WECHAT', '2025-02-02 10:30:00', '2026-02-11 23:03:22');
INSERT INTO `campaign_push_log` VALUES (2, 6, '流感疫苗', 2, 5, '流感疫苗到货，南开区妇幼保健院接种点开放预约，请及时为儿童接种。', 'WECHAT', '2025-02-02 11:00:00', '2026-02-11 23:03:22');
INSERT INTO `campaign_push_log` VALUES (3, 8, '手足口疫苗', 1, 4, 'EV71手足口疫苗可预防重症手足口病，建议6月龄以上儿童接种。', 'APP', '2025-02-04 09:00:00', '2026-02-11 23:03:22');
INSERT INTO `campaign_push_log` VALUES (4, 7, '水痘疫苗', 2, 5, '水痘疫苗两针程序可长期保护，第二针与第一针间隔3个月以上。', 'WECHAT', '2025-02-05 14:00:00', '2026-02-11 23:03:22');
INSERT INTO `campaign_push_log` VALUES (5, 9, '肺炎球菌疫苗', 1, 4, '13价肺炎疫苗适合2月龄起接种，可有效预防肺炎球菌感染。', 'WECHAT', '2025-02-06 10:00:00', '2026-02-11 23:03:22');
INSERT INTO `campaign_push_log` VALUES (6, 10, '轮状病毒疫苗', 2, 5, '轮状病毒疫苗口服接种，预防婴幼儿腹泻，请关注接种时间。', 'APP', '2025-02-07 09:30:00', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for child_profile
-- ----------------------------
DROP TABLE IF EXISTS `child_profile`;
CREATE TABLE `child_profile`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` bigint NOT NULL COMMENT '家长用户ID',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '儿童姓名',
  `birth_date` date NOT NULL COMMENT '出生日期',
  `gender` tinyint NOT NULL COMMENT '性别：0-未知，1-男，2-女',
  `contraindication_allergy` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '禁忌症/过敏史',
  `vaccination_card_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '接种卡号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_birth_date`(`birth_date` ASC) USING BTREE,
  INDEX `idx_vaccination_card_no`(`vaccination_card_no` ASC) USING BTREE,
  CONSTRAINT `fk_child_parent` FOREIGN KEY (`parent_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '儿童档案表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of child_profile
-- ----------------------------
INSERT INTO `child_profile` VALUES (1, 4, '李小宝', '2023-05-10', 1, NULL, 'TJNK20230001', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (2, 4, '李二宝', '2024-01-20', 2, '鸡蛋过敏', 'TJNK20240002', '2026-02-11 23:03:22', '2026-02-24 17:55:58');
INSERT INTO `child_profile` VALUES (6, 5, '赵小明', '2023-02-14', 1, NULL, 'TJNK20230006', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (7, 5, '赵小红', '2023-07-20', 2, NULL, 'TJNK20230007', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (8, 5, '赵小刚', '2024-05-01', 1, '青霉素过敏', 'TJNK20240008', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (9, 5, '赵小丽', '2022-12-25', 2, NULL, 'TJNK20220009', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (10, 5, '赵小强', '2023-09-10', 1, NULL, 'TJNK20230010', '2026-02-11 23:03:22', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for doctor_dispatch
-- ----------------------------
DROP TABLE IF EXISTS `doctor_dispatch`;
CREATE TABLE `doctor_dispatch`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `doctor_id` bigint NOT NULL COMMENT '医生用户ID',
  `from_site_id` bigint NOT NULL COMMENT '调出接种点ID',
  `to_site_id` bigint NOT NULL COMMENT '调入接种点ID',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0-待审批，1-同意，2-拒绝',
  `apply_time` datetime NULL DEFAULT NULL COMMENT '申请时间',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_doctor_id`(`doctor_id` ASC) USING BTREE,
  INDEX `idx_from_site_id`(`from_site_id` ASC) USING BTREE,
  INDEX `idx_to_site_id`(`to_site_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_dispatch_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_dispatch_from_site` FOREIGN KEY (`from_site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_dispatch_to_site` FOREIGN KEY (`to_site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '医生调遣申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of doctor_dispatch
-- ----------------------------
INSERT INTO `doctor_dispatch` VALUES (1, 2, 1, 2, 1, '2025-01-15 09:00:00', '2025-01-15 14:00:00');
INSERT INTO `doctor_dispatch` VALUES (2, 2, 2, 3, 2, '2025-02-01 10:00:00', '2026-02-11 23:23:14');
INSERT INTO `doctor_dispatch` VALUES (6, 2, 2, 1, 1, '2026-02-11 23:22:41', '2026-02-11 23:23:10');
INSERT INTO `doctor_dispatch` VALUES (7, 6, 1, 3, 0, '2026-02-12 00:11:52', NULL);
INSERT INTO `doctor_dispatch` VALUES (8, 6, 1, 3, 1, '2026-02-12 08:30:57', '2026-02-12 08:31:40');
INSERT INTO `doctor_dispatch` VALUES (9, 7, 1, 2, 1, '2026-02-24 09:33:32', '2026-02-24 17:57:37');
INSERT INTO `doctor_dispatch` VALUES (10, 7, 1, 2, 1, '2026-02-24 10:19:51', '2026-02-24 17:57:37');
INSERT INTO `doctor_dispatch` VALUES (11, 7, 1, 2, 1, '2026-02-24 10:20:38', '2026-02-24 17:57:36');
INSERT INTO `doctor_dispatch` VALUES (12, 7, 1, 2, 1, '2026-02-24 10:20:43', '2026-02-24 17:57:35');
INSERT INTO `doctor_dispatch` VALUES (13, 2, 2, 1, 1, '2026-02-24 10:33:56', '2026-02-24 10:34:43');
INSERT INTO `doctor_dispatch` VALUES (14, 7, 4, 1, 1, '2026-02-24 10:34:01', '2026-02-24 17:57:39');
INSERT INTO `doctor_dispatch` VALUES (15, 2, 2, 1, 1, '2026-02-24 10:34:08', '2026-02-24 10:34:45');
INSERT INTO `doctor_dispatch` VALUES (16, 7, 4, 1, 1, '2026-02-24 11:30:12', '2026-02-24 17:57:33');
INSERT INTO `doctor_dispatch` VALUES (17, 2, 2, 1, 1, '2026-02-24 11:30:55', '2026-02-24 11:31:22');
INSERT INTO `doctor_dispatch` VALUES (18, 7, 4, 1, 1, '2026-02-24 15:57:46', '2026-02-24 17:57:33');
INSERT INTO `doctor_dispatch` VALUES (19, 2, 2, 1, 1, '2026-02-24 15:57:50', '2026-02-24 17:11:17');
INSERT INTO `doctor_dispatch` VALUES (20, 7, 4, 1, 1, '2026-02-24 17:50:56', '2026-02-24 17:57:32');
INSERT INTO `doctor_dispatch` VALUES (21, 7, 1, 4, 0, '2026-02-25 15:36:39', NULL);
INSERT INTO `doctor_dispatch` VALUES (22, 7, 1, 3, 0, '2026-02-25 15:36:50', NULL);
INSERT INTO `doctor_dispatch` VALUES (23, 7, 1, 4, 0, '2026-02-25 16:29:14', NULL);
INSERT INTO `doctor_dispatch` VALUES (24, 2, 2, 1, 0, '2026-02-25 16:29:26', NULL);

-- ----------------------------
-- Table structure for doctor_schedule
-- ----------------------------
DROP TABLE IF EXISTS `doctor_schedule`;
CREATE TABLE `doctor_schedule`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `doctor_id` bigint NOT NULL COMMENT '医生用户ID',
  `site_id` bigint NOT NULL COMMENT '接种点ID',
  `schedule_date` date NOT NULL COMMENT '排班日期',
  `time_slot` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '时段，如 08:00-09:00',
  `max_capacity` int NOT NULL DEFAULT 0 COMMENT '该时段最大预约数',
  `current_count` int NOT NULL DEFAULT 0 COMMENT '当前已预约数',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_doctor_id`(`doctor_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_schedule_date`(`schedule_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_site_date_slot`(`site_id` ASC, `schedule_date` ASC, `time_slot` ASC) USING BTREE,
  CONSTRAINT `fk_ds_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_ds_site` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8192 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '医生排班表（排班先行）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of doctor_schedule
-- ----------------------------
INSERT INTO `doctor_schedule` VALUES (1, 6, 1, '2026-03-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2, 2, 1, '2026-03-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3, 6, 2, '2026-03-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4, 2, 2, '2026-03-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (5, 6, 4, '2026-03-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (6, 2, 4, '2026-03-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (7, 6, 1, '2026-03-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (8, 2, 1, '2026-03-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (9, 6, 2, '2026-03-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (10, 2, 2, '2026-03-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (11, 6, 4, '2026-03-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (12, 2, 4, '2026-03-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (13, 6, 1, '2026-03-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (14, 2, 1, '2026-03-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (15, 6, 2, '2026-03-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (16, 2, 2, '2026-03-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (17, 6, 4, '2026-03-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (18, 2, 4, '2026-03-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (19, 6, 1, '2026-03-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (20, 2, 1, '2026-03-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (21, 6, 2, '2026-03-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (22, 2, 2, '2026-03-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (23, 6, 4, '2026-03-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (24, 2, 4, '2026-03-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (25, 6, 1, '2026-03-23', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (26, 2, 1, '2026-03-23', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (27, 6, 2, '2026-03-23', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (28, 2, 2, '2026-03-23', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (29, 6, 4, '2026-03-23', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (30, 2, 4, '2026-03-23', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (31, 6, 1, '2026-03-20', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (32, 2, 1, '2026-03-20', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (33, 6, 2, '2026-03-20', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (34, 2, 2, '2026-03-20', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (35, 6, 4, '2026-03-20', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (36, 2, 4, '2026-03-20', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (37, 6, 1, '2026-03-19', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (38, 2, 1, '2026-03-19', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (39, 6, 2, '2026-03-19', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (40, 2, 2, '2026-03-19', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (41, 6, 4, '2026-03-19', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (42, 2, 4, '2026-03-19', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (43, 6, 1, '2026-03-18', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (44, 2, 1, '2026-03-18', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (45, 6, 2, '2026-03-18', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (46, 2, 2, '2026-03-18', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (47, 6, 4, '2026-03-18', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (48, 2, 4, '2026-03-18', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (49, 6, 1, '2026-03-17', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (50, 2, 1, '2026-03-17', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (51, 6, 2, '2026-03-17', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (52, 2, 2, '2026-03-17', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (53, 6, 4, '2026-03-17', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (54, 2, 4, '2026-03-17', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (55, 6, 1, '2026-03-16', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (56, 2, 1, '2026-03-16', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (57, 6, 2, '2026-03-16', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (58, 2, 2, '2026-03-16', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (59, 6, 4, '2026-03-16', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (60, 2, 4, '2026-03-16', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (61, 6, 1, '2026-03-13', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (62, 2, 1, '2026-03-13', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (63, 6, 2, '2026-03-13', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (64, 2, 2, '2026-03-13', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (65, 6, 4, '2026-03-13', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (66, 2, 4, '2026-03-13', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (67, 6, 1, '2026-03-12', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (68, 2, 1, '2026-03-12', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (69, 6, 2, '2026-03-12', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (70, 2, 2, '2026-03-12', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (71, 6, 4, '2026-03-12', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (72, 2, 4, '2026-03-12', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (73, 6, 1, '2026-03-11', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (74, 2, 1, '2026-03-11', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (75, 6, 2, '2026-03-11', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (76, 2, 2, '2026-03-11', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (77, 6, 4, '2026-03-11', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (78, 2, 4, '2026-03-11', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (79, 6, 1, '2026-03-10', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (80, 2, 1, '2026-03-10', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (81, 6, 2, '2026-03-10', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (82, 2, 2, '2026-03-10', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (83, 6, 4, '2026-03-10', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (84, 2, 4, '2026-03-10', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (85, 6, 1, '2026-03-09', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (86, 2, 1, '2026-03-09', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (87, 6, 2, '2026-03-09', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (88, 2, 2, '2026-03-09', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (89, 6, 4, '2026-03-09', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (90, 2, 4, '2026-03-09', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (91, 6, 1, '2026-03-06', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (92, 2, 1, '2026-03-06', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (93, 6, 2, '2026-03-06', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (94, 2, 2, '2026-03-06', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (95, 6, 4, '2026-03-06', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (96, 2, 4, '2026-03-06', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (97, 6, 1, '2026-03-05', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (98, 2, 1, '2026-03-05', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (99, 6, 2, '2026-03-05', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (100, 2, 2, '2026-03-05', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (101, 6, 4, '2026-03-05', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (102, 2, 4, '2026-03-05', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (103, 6, 1, '2026-03-04', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (104, 2, 1, '2026-03-04', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (105, 6, 2, '2026-03-04', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (106, 2, 2, '2026-03-04', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (107, 6, 4, '2026-03-04', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (108, 2, 4, '2026-03-04', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (109, 6, 1, '2026-03-03', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (110, 2, 1, '2026-03-03', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (111, 6, 2, '2026-03-03', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (112, 2, 2, '2026-03-03', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (113, 6, 4, '2026-03-03', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (114, 2, 4, '2026-03-03', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (115, 6, 1, '2026-03-02', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (116, 2, 1, '2026-03-02', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (117, 6, 2, '2026-03-02', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (118, 2, 2, '2026-03-02', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (119, 6, 4, '2026-03-02', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (120, 2, 4, '2026-03-02', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (121, 6, 1, '2026-02-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (122, 2, 1, '2026-02-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (123, 6, 2, '2026-02-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (124, 2, 2, '2026-02-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (125, 6, 4, '2026-02-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (126, 2, 4, '2026-02-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (127, 6, 1, '2026-02-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (128, 2, 1, '2026-02-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (129, 6, 2, '2026-02-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (130, 2, 2, '2026-02-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (131, 6, 4, '2026-02-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (132, 2, 4, '2026-02-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (133, 6, 1, '2026-02-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (134, 2, 1, '2026-02-25', '08:00-08:15', 5, 1, 1, '2026-02-25 10:44:49', '2026-02-25 15:10:57');
INSERT INTO `doctor_schedule` VALUES (135, 6, 2, '2026-02-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (136, 2, 2, '2026-02-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (137, 6, 4, '2026-02-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (138, 2, 4, '2026-02-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (139, 6, 1, '2026-02-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (140, 2, 1, '2026-02-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (141, 6, 2, '2026-02-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (142, 2, 2, '2026-02-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (143, 6, 4, '2026-02-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (144, 2, 4, '2026-02-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (145, 6, 1, '2026-03-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (146, 2, 1, '2026-03-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (147, 6, 2, '2026-03-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (148, 2, 2, '2026-03-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (149, 6, 4, '2026-03-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (150, 2, 4, '2026-03-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (151, 6, 1, '2026-03-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (152, 2, 1, '2026-03-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (153, 6, 2, '2026-03-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (154, 2, 2, '2026-03-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (155, 6, 4, '2026-03-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (156, 2, 4, '2026-03-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (157, 6, 1, '2026-03-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (158, 2, 1, '2026-03-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (159, 6, 2, '2026-03-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (160, 2, 2, '2026-03-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (161, 6, 4, '2026-03-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (162, 2, 4, '2026-03-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (163, 6, 1, '2026-03-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (164, 2, 1, '2026-03-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (165, 6, 2, '2026-03-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (166, 2, 2, '2026-03-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (167, 6, 4, '2026-03-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (168, 2, 4, '2026-03-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (169, 6, 1, '2026-03-23', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (170, 2, 1, '2026-03-23', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (171, 6, 2, '2026-03-23', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (172, 2, 2, '2026-03-23', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (173, 6, 4, '2026-03-23', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (174, 2, 4, '2026-03-23', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (175, 6, 1, '2026-03-20', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (176, 2, 1, '2026-03-20', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (177, 6, 2, '2026-03-20', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (178, 2, 2, '2026-03-20', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (179, 6, 4, '2026-03-20', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (180, 2, 4, '2026-03-20', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (181, 6, 1, '2026-03-19', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (182, 2, 1, '2026-03-19', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (183, 6, 2, '2026-03-19', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (184, 2, 2, '2026-03-19', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (185, 6, 4, '2026-03-19', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (186, 2, 4, '2026-03-19', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (187, 6, 1, '2026-03-18', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (188, 2, 1, '2026-03-18', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (189, 6, 2, '2026-03-18', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (190, 2, 2, '2026-03-18', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (191, 6, 4, '2026-03-18', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (192, 2, 4, '2026-03-18', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (193, 6, 1, '2026-03-17', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (194, 2, 1, '2026-03-17', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (195, 6, 2, '2026-03-17', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (196, 2, 2, '2026-03-17', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (197, 6, 4, '2026-03-17', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (198, 2, 4, '2026-03-17', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (199, 6, 1, '2026-03-16', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (200, 2, 1, '2026-03-16', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (201, 6, 2, '2026-03-16', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (202, 2, 2, '2026-03-16', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (203, 6, 4, '2026-03-16', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (204, 2, 4, '2026-03-16', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (205, 6, 1, '2026-03-13', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (206, 2, 1, '2026-03-13', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (207, 6, 2, '2026-03-13', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (208, 2, 2, '2026-03-13', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (209, 6, 4, '2026-03-13', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (210, 2, 4, '2026-03-13', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (211, 6, 1, '2026-03-12', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (212, 2, 1, '2026-03-12', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (213, 6, 2, '2026-03-12', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (214, 2, 2, '2026-03-12', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (215, 6, 4, '2026-03-12', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (216, 2, 4, '2026-03-12', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (217, 6, 1, '2026-03-11', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (218, 2, 1, '2026-03-11', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (219, 6, 2, '2026-03-11', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (220, 2, 2, '2026-03-11', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (221, 6, 4, '2026-03-11', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (222, 2, 4, '2026-03-11', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (223, 6, 1, '2026-03-10', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (224, 2, 1, '2026-03-10', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (225, 6, 2, '2026-03-10', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (226, 2, 2, '2026-03-10', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (227, 6, 4, '2026-03-10', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (228, 2, 4, '2026-03-10', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (229, 6, 1, '2026-03-09', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (230, 2, 1, '2026-03-09', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (231, 6, 2, '2026-03-09', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (232, 2, 2, '2026-03-09', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (233, 6, 4, '2026-03-09', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (234, 2, 4, '2026-03-09', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (235, 6, 1, '2026-03-06', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (236, 2, 1, '2026-03-06', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (237, 6, 2, '2026-03-06', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (238, 2, 2, '2026-03-06', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (239, 6, 4, '2026-03-06', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (240, 2, 4, '2026-03-06', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (241, 6, 1, '2026-03-05', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (242, 2, 1, '2026-03-05', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (243, 6, 2, '2026-03-05', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (244, 2, 2, '2026-03-05', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (245, 6, 4, '2026-03-05', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (246, 2, 4, '2026-03-05', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (247, 6, 1, '2026-03-04', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (248, 2, 1, '2026-03-04', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (249, 6, 2, '2026-03-04', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (250, 2, 2, '2026-03-04', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (251, 6, 4, '2026-03-04', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (252, 2, 4, '2026-03-04', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (253, 6, 1, '2026-03-03', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (254, 2, 1, '2026-03-03', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (255, 6, 2, '2026-03-03', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (256, 2, 2, '2026-03-03', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (257, 6, 4, '2026-03-03', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (258, 2, 4, '2026-03-03', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (259, 6, 1, '2026-03-02', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (260, 2, 1, '2026-03-02', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (261, 6, 2, '2026-03-02', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (262, 2, 2, '2026-03-02', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (263, 6, 4, '2026-03-02', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (264, 2, 4, '2026-03-02', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (265, 6, 1, '2026-02-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (266, 2, 1, '2026-02-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (267, 6, 2, '2026-02-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (268, 2, 2, '2026-02-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (269, 6, 4, '2026-02-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (270, 2, 4, '2026-02-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (271, 6, 1, '2026-02-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (272, 2, 1, '2026-02-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (273, 6, 2, '2026-02-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (274, 2, 2, '2026-02-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (275, 6, 4, '2026-02-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (276, 2, 4, '2026-02-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (277, 6, 1, '2026-02-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (278, 2, 1, '2026-02-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (279, 6, 2, '2026-02-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (280, 2, 2, '2026-02-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (281, 6, 4, '2026-02-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (282, 2, 4, '2026-02-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (283, 6, 1, '2026-02-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (284, 2, 1, '2026-02-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (285, 6, 2, '2026-02-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (286, 2, 2, '2026-02-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (287, 6, 4, '2026-02-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (288, 2, 4, '2026-02-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (289, 6, 1, '2026-03-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (290, 2, 1, '2026-03-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (291, 6, 2, '2026-03-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (292, 2, 2, '2026-03-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (293, 6, 4, '2026-03-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (294, 2, 4, '2026-03-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (295, 6, 1, '2026-03-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (296, 2, 1, '2026-03-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (297, 6, 2, '2026-03-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (298, 2, 2, '2026-03-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (299, 6, 4, '2026-03-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (300, 2, 4, '2026-03-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (301, 6, 1, '2026-03-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (302, 2, 1, '2026-03-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (303, 6, 2, '2026-03-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (304, 2, 2, '2026-03-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (305, 6, 4, '2026-03-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (306, 2, 4, '2026-03-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (307, 6, 1, '2026-03-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (308, 2, 1, '2026-03-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (309, 6, 2, '2026-03-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (310, 2, 2, '2026-03-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (311, 6, 4, '2026-03-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (312, 2, 4, '2026-03-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (313, 6, 1, '2026-03-23', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (314, 2, 1, '2026-03-23', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (315, 6, 2, '2026-03-23', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (316, 2, 2, '2026-03-23', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (317, 6, 4, '2026-03-23', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (318, 2, 4, '2026-03-23', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (319, 6, 1, '2026-03-20', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (320, 2, 1, '2026-03-20', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (321, 6, 2, '2026-03-20', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (322, 2, 2, '2026-03-20', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (323, 6, 4, '2026-03-20', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (324, 2, 4, '2026-03-20', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (325, 6, 1, '2026-03-19', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (326, 2, 1, '2026-03-19', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (327, 6, 2, '2026-03-19', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (328, 2, 2, '2026-03-19', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (329, 6, 4, '2026-03-19', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (330, 2, 4, '2026-03-19', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (331, 6, 1, '2026-03-18', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (332, 2, 1, '2026-03-18', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (333, 6, 2, '2026-03-18', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (334, 2, 2, '2026-03-18', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (335, 6, 4, '2026-03-18', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (336, 2, 4, '2026-03-18', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (337, 6, 1, '2026-03-17', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (338, 2, 1, '2026-03-17', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (339, 6, 2, '2026-03-17', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (340, 2, 2, '2026-03-17', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (341, 6, 4, '2026-03-17', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (342, 2, 4, '2026-03-17', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (343, 6, 1, '2026-03-16', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (344, 2, 1, '2026-03-16', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (345, 6, 2, '2026-03-16', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (346, 2, 2, '2026-03-16', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (347, 6, 4, '2026-03-16', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (348, 2, 4, '2026-03-16', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (349, 6, 1, '2026-03-13', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (350, 2, 1, '2026-03-13', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (351, 6, 2, '2026-03-13', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (352, 2, 2, '2026-03-13', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (353, 6, 4, '2026-03-13', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (354, 2, 4, '2026-03-13', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (355, 6, 1, '2026-03-12', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (356, 2, 1, '2026-03-12', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (357, 6, 2, '2026-03-12', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (358, 2, 2, '2026-03-12', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (359, 6, 4, '2026-03-12', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (360, 2, 4, '2026-03-12', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (361, 6, 1, '2026-03-11', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (362, 2, 1, '2026-03-11', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (363, 6, 2, '2026-03-11', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (364, 2, 2, '2026-03-11', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (365, 6, 4, '2026-03-11', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (366, 2, 4, '2026-03-11', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (367, 6, 1, '2026-03-10', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (368, 2, 1, '2026-03-10', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (369, 6, 2, '2026-03-10', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (370, 2, 2, '2026-03-10', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (371, 6, 4, '2026-03-10', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (372, 2, 4, '2026-03-10', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (373, 6, 1, '2026-03-09', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (374, 2, 1, '2026-03-09', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (375, 6, 2, '2026-03-09', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (376, 2, 2, '2026-03-09', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (377, 6, 4, '2026-03-09', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (378, 2, 4, '2026-03-09', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (379, 6, 1, '2026-03-06', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (380, 2, 1, '2026-03-06', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (381, 6, 2, '2026-03-06', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (382, 2, 2, '2026-03-06', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (383, 6, 4, '2026-03-06', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (384, 2, 4, '2026-03-06', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (385, 6, 1, '2026-03-05', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (386, 2, 1, '2026-03-05', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (387, 6, 2, '2026-03-05', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (388, 2, 2, '2026-03-05', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (389, 6, 4, '2026-03-05', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (390, 2, 4, '2026-03-05', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (391, 6, 1, '2026-03-04', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (392, 2, 1, '2026-03-04', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (393, 6, 2, '2026-03-04', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (394, 2, 2, '2026-03-04', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (395, 6, 4, '2026-03-04', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (396, 2, 4, '2026-03-04', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (397, 6, 1, '2026-03-03', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (398, 2, 1, '2026-03-03', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (399, 6, 2, '2026-03-03', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (400, 2, 2, '2026-03-03', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (401, 6, 4, '2026-03-03', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (402, 2, 4, '2026-03-03', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (403, 6, 1, '2026-03-02', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (404, 2, 1, '2026-03-02', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (405, 6, 2, '2026-03-02', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (406, 2, 2, '2026-03-02', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (407, 6, 4, '2026-03-02', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (408, 2, 4, '2026-03-02', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (409, 6, 1, '2026-02-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (410, 2, 1, '2026-02-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (411, 6, 2, '2026-02-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (412, 2, 2, '2026-02-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (413, 6, 4, '2026-02-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (414, 2, 4, '2026-02-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (415, 6, 1, '2026-02-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (416, 2, 1, '2026-02-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (417, 6, 2, '2026-02-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (418, 2, 2, '2026-02-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (419, 6, 4, '2026-02-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (420, 2, 4, '2026-02-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (421, 6, 1, '2026-02-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (422, 2, 1, '2026-02-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (423, 6, 2, '2026-02-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (424, 2, 2, '2026-02-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (425, 6, 4, '2026-02-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (426, 2, 4, '2026-02-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (427, 6, 1, '2026-02-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (428, 2, 1, '2026-02-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (429, 6, 2, '2026-02-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (430, 2, 2, '2026-02-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (431, 6, 4, '2026-02-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (432, 2, 4, '2026-02-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (433, 6, 1, '2026-03-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (434, 2, 1, '2026-03-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (435, 6, 2, '2026-03-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (436, 2, 2, '2026-03-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (437, 6, 4, '2026-03-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (438, 2, 4, '2026-03-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (439, 6, 1, '2026-03-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (440, 2, 1, '2026-03-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (441, 6, 2, '2026-03-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (442, 2, 2, '2026-03-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (443, 6, 4, '2026-03-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (444, 2, 4, '2026-03-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (445, 6, 1, '2026-03-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (446, 2, 1, '2026-03-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (447, 6, 2, '2026-03-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (448, 2, 2, '2026-03-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (449, 6, 4, '2026-03-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (450, 2, 4, '2026-03-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (451, 6, 1, '2026-03-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (452, 2, 1, '2026-03-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (453, 6, 2, '2026-03-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (454, 2, 2, '2026-03-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (455, 6, 4, '2026-03-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (456, 2, 4, '2026-03-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (457, 6, 1, '2026-03-23', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (458, 2, 1, '2026-03-23', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (459, 6, 2, '2026-03-23', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (460, 2, 2, '2026-03-23', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (461, 6, 4, '2026-03-23', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (462, 2, 4, '2026-03-23', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (463, 6, 1, '2026-03-20', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (464, 2, 1, '2026-03-20', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (465, 6, 2, '2026-03-20', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (466, 2, 2, '2026-03-20', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (467, 6, 4, '2026-03-20', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (468, 2, 4, '2026-03-20', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (469, 6, 1, '2026-03-19', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (470, 2, 1, '2026-03-19', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (471, 6, 2, '2026-03-19', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (472, 2, 2, '2026-03-19', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (473, 6, 4, '2026-03-19', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (474, 2, 4, '2026-03-19', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (475, 6, 1, '2026-03-18', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (476, 2, 1, '2026-03-18', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (477, 6, 2, '2026-03-18', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (478, 2, 2, '2026-03-18', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (479, 6, 4, '2026-03-18', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (480, 2, 4, '2026-03-18', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (481, 6, 1, '2026-03-17', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (482, 2, 1, '2026-03-17', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (483, 6, 2, '2026-03-17', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (484, 2, 2, '2026-03-17', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (485, 6, 4, '2026-03-17', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (486, 2, 4, '2026-03-17', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (487, 6, 1, '2026-03-16', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (488, 2, 1, '2026-03-16', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (489, 6, 2, '2026-03-16', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (490, 2, 2, '2026-03-16', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (491, 6, 4, '2026-03-16', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (492, 2, 4, '2026-03-16', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (493, 6, 1, '2026-03-13', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (494, 2, 1, '2026-03-13', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (495, 6, 2, '2026-03-13', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (496, 2, 2, '2026-03-13', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (497, 6, 4, '2026-03-13', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (498, 2, 4, '2026-03-13', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (499, 6, 1, '2026-03-12', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (500, 2, 1, '2026-03-12', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (501, 6, 2, '2026-03-12', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (502, 2, 2, '2026-03-12', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (503, 6, 4, '2026-03-12', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (504, 2, 4, '2026-03-12', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (505, 6, 1, '2026-03-11', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (506, 2, 1, '2026-03-11', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (507, 6, 2, '2026-03-11', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (508, 2, 2, '2026-03-11', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (509, 6, 4, '2026-03-11', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (510, 2, 4, '2026-03-11', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (511, 6, 1, '2026-03-10', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (512, 2, 1, '2026-03-10', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (513, 6, 2, '2026-03-10', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (514, 2, 2, '2026-03-10', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (515, 6, 4, '2026-03-10', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (516, 2, 4, '2026-03-10', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (517, 6, 1, '2026-03-09', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (518, 2, 1, '2026-03-09', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (519, 6, 2, '2026-03-09', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (520, 2, 2, '2026-03-09', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (521, 6, 4, '2026-03-09', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (522, 2, 4, '2026-03-09', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (523, 6, 1, '2026-03-06', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (524, 2, 1, '2026-03-06', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (525, 6, 2, '2026-03-06', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (526, 2, 2, '2026-03-06', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (527, 6, 4, '2026-03-06', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (528, 2, 4, '2026-03-06', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (529, 6, 1, '2026-03-05', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (530, 2, 1, '2026-03-05', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (531, 6, 2, '2026-03-05', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (532, 2, 2, '2026-03-05', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (533, 6, 4, '2026-03-05', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (534, 2, 4, '2026-03-05', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (535, 6, 1, '2026-03-04', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (536, 2, 1, '2026-03-04', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (537, 6, 2, '2026-03-04', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (538, 2, 2, '2026-03-04', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (539, 6, 4, '2026-03-04', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (540, 2, 4, '2026-03-04', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (541, 6, 1, '2026-03-03', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (542, 2, 1, '2026-03-03', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (543, 6, 2, '2026-03-03', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (544, 2, 2, '2026-03-03', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (545, 6, 4, '2026-03-03', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (546, 2, 4, '2026-03-03', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (547, 6, 1, '2026-03-02', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (548, 2, 1, '2026-03-02', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (549, 6, 2, '2026-03-02', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (550, 2, 2, '2026-03-02', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (551, 6, 4, '2026-03-02', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (552, 2, 4, '2026-03-02', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (553, 6, 1, '2026-02-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (554, 2, 1, '2026-02-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (555, 6, 2, '2026-02-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (556, 2, 2, '2026-02-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (557, 6, 4, '2026-02-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (558, 2, 4, '2026-02-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (559, 6, 1, '2026-02-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (560, 2, 1, '2026-02-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (561, 6, 2, '2026-02-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (562, 2, 2, '2026-02-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (563, 6, 4, '2026-02-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (564, 2, 4, '2026-02-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (565, 6, 1, '2026-02-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (566, 2, 1, '2026-02-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (567, 6, 2, '2026-02-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (568, 2, 2, '2026-02-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (569, 6, 4, '2026-02-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (570, 2, 4, '2026-02-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (571, 6, 1, '2026-02-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (572, 2, 1, '2026-02-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (573, 6, 2, '2026-02-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (574, 2, 2, '2026-02-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (575, 6, 4, '2026-02-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (576, 2, 4, '2026-02-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (577, 6, 1, '2026-03-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (578, 2, 1, '2026-03-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (579, 6, 2, '2026-03-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (580, 2, 2, '2026-03-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (581, 6, 4, '2026-03-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (582, 2, 4, '2026-03-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (583, 6, 1, '2026-03-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (584, 2, 1, '2026-03-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (585, 6, 2, '2026-03-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (586, 2, 2, '2026-03-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (587, 6, 4, '2026-03-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (588, 2, 4, '2026-03-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (589, 6, 1, '2026-03-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (590, 2, 1, '2026-03-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (591, 6, 2, '2026-03-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (592, 2, 2, '2026-03-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (593, 6, 4, '2026-03-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (594, 2, 4, '2026-03-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (595, 6, 1, '2026-03-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (596, 2, 1, '2026-03-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (597, 6, 2, '2026-03-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (598, 2, 2, '2026-03-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (599, 6, 4, '2026-03-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (600, 2, 4, '2026-03-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (601, 6, 1, '2026-03-23', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (602, 2, 1, '2026-03-23', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (603, 6, 2, '2026-03-23', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (604, 2, 2, '2026-03-23', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (605, 6, 4, '2026-03-23', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (606, 2, 4, '2026-03-23', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (607, 6, 1, '2026-03-20', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (608, 2, 1, '2026-03-20', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (609, 6, 2, '2026-03-20', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (610, 2, 2, '2026-03-20', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (611, 6, 4, '2026-03-20', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (612, 2, 4, '2026-03-20', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (613, 6, 1, '2026-03-19', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (614, 2, 1, '2026-03-19', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (615, 6, 2, '2026-03-19', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (616, 2, 2, '2026-03-19', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (617, 6, 4, '2026-03-19', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (618, 2, 4, '2026-03-19', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (619, 6, 1, '2026-03-18', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (620, 2, 1, '2026-03-18', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (621, 6, 2, '2026-03-18', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (622, 2, 2, '2026-03-18', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (623, 6, 4, '2026-03-18', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (624, 2, 4, '2026-03-18', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (625, 6, 1, '2026-03-17', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (626, 2, 1, '2026-03-17', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (627, 6, 2, '2026-03-17', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (628, 2, 2, '2026-03-17', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (629, 6, 4, '2026-03-17', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (630, 2, 4, '2026-03-17', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (631, 6, 1, '2026-03-16', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (632, 2, 1, '2026-03-16', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (633, 6, 2, '2026-03-16', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (634, 2, 2, '2026-03-16', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (635, 6, 4, '2026-03-16', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (636, 2, 4, '2026-03-16', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (637, 6, 1, '2026-03-13', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (638, 2, 1, '2026-03-13', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (639, 6, 2, '2026-03-13', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (640, 2, 2, '2026-03-13', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (641, 6, 4, '2026-03-13', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (642, 2, 4, '2026-03-13', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (643, 6, 1, '2026-03-12', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (644, 2, 1, '2026-03-12', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (645, 6, 2, '2026-03-12', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (646, 2, 2, '2026-03-12', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (647, 6, 4, '2026-03-12', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (648, 2, 4, '2026-03-12', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (649, 6, 1, '2026-03-11', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (650, 2, 1, '2026-03-11', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (651, 6, 2, '2026-03-11', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (652, 2, 2, '2026-03-11', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (653, 6, 4, '2026-03-11', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (654, 2, 4, '2026-03-11', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (655, 6, 1, '2026-03-10', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (656, 2, 1, '2026-03-10', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (657, 6, 2, '2026-03-10', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (658, 2, 2, '2026-03-10', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (659, 6, 4, '2026-03-10', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (660, 2, 4, '2026-03-10', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (661, 6, 1, '2026-03-09', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (662, 2, 1, '2026-03-09', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (663, 6, 2, '2026-03-09', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (664, 2, 2, '2026-03-09', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (665, 6, 4, '2026-03-09', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (666, 2, 4, '2026-03-09', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (667, 6, 1, '2026-03-06', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (668, 2, 1, '2026-03-06', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (669, 6, 2, '2026-03-06', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (670, 2, 2, '2026-03-06', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (671, 6, 4, '2026-03-06', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (672, 2, 4, '2026-03-06', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (673, 6, 1, '2026-03-05', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (674, 2, 1, '2026-03-05', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (675, 6, 2, '2026-03-05', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (676, 2, 2, '2026-03-05', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (677, 6, 4, '2026-03-05', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (678, 2, 4, '2026-03-05', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (679, 6, 1, '2026-03-04', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (680, 2, 1, '2026-03-04', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (681, 6, 2, '2026-03-04', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (682, 2, 2, '2026-03-04', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (683, 6, 4, '2026-03-04', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (684, 2, 4, '2026-03-04', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (685, 6, 1, '2026-03-03', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (686, 2, 1, '2026-03-03', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (687, 6, 2, '2026-03-03', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (688, 2, 2, '2026-03-03', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (689, 6, 4, '2026-03-03', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (690, 2, 4, '2026-03-03', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (691, 6, 1, '2026-03-02', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (692, 2, 1, '2026-03-02', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (693, 6, 2, '2026-03-02', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (694, 2, 2, '2026-03-02', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (695, 6, 4, '2026-03-02', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (696, 2, 4, '2026-03-02', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (697, 6, 1, '2026-02-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (698, 2, 1, '2026-02-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (699, 6, 2, '2026-02-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (700, 2, 2, '2026-02-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (701, 6, 4, '2026-02-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (702, 2, 4, '2026-02-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (703, 6, 1, '2026-02-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (704, 2, 1, '2026-02-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (705, 6, 2, '2026-02-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (706, 2, 2, '2026-02-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (707, 6, 4, '2026-02-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (708, 2, 4, '2026-02-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (709, 6, 1, '2026-02-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (710, 2, 1, '2026-02-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (711, 6, 2, '2026-02-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (712, 2, 2, '2026-02-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (713, 6, 4, '2026-02-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (714, 2, 4, '2026-02-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (715, 6, 1, '2026-02-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (716, 2, 1, '2026-02-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (717, 6, 2, '2026-02-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (718, 2, 2, '2026-02-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (719, 6, 4, '2026-02-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (720, 2, 4, '2026-02-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (721, 6, 1, '2026-03-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (722, 2, 1, '2026-03-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (723, 6, 2, '2026-03-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (724, 2, 2, '2026-03-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (725, 6, 4, '2026-03-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (726, 2, 4, '2026-03-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (727, 6, 1, '2026-03-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (728, 2, 1, '2026-03-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (729, 6, 2, '2026-03-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (730, 2, 2, '2026-03-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (731, 6, 4, '2026-03-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (732, 2, 4, '2026-03-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (733, 6, 1, '2026-03-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (734, 2, 1, '2026-03-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (735, 6, 2, '2026-03-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (736, 2, 2, '2026-03-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (737, 6, 4, '2026-03-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (738, 2, 4, '2026-03-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (739, 6, 1, '2026-03-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (740, 2, 1, '2026-03-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (741, 6, 2, '2026-03-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (742, 2, 2, '2026-03-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (743, 6, 4, '2026-03-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (744, 2, 4, '2026-03-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (745, 6, 1, '2026-03-23', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (746, 2, 1, '2026-03-23', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (747, 6, 2, '2026-03-23', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (748, 2, 2, '2026-03-23', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (749, 6, 4, '2026-03-23', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (750, 2, 4, '2026-03-23', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (751, 6, 1, '2026-03-20', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (752, 2, 1, '2026-03-20', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (753, 6, 2, '2026-03-20', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (754, 2, 2, '2026-03-20', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (755, 6, 4, '2026-03-20', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (756, 2, 4, '2026-03-20', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (757, 6, 1, '2026-03-19', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (758, 2, 1, '2026-03-19', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (759, 6, 2, '2026-03-19', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (760, 2, 2, '2026-03-19', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (761, 6, 4, '2026-03-19', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (762, 2, 4, '2026-03-19', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (763, 6, 1, '2026-03-18', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (764, 2, 1, '2026-03-18', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (765, 6, 2, '2026-03-18', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (766, 2, 2, '2026-03-18', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (767, 6, 4, '2026-03-18', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (768, 2, 4, '2026-03-18', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (769, 6, 1, '2026-03-17', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (770, 2, 1, '2026-03-17', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (771, 6, 2, '2026-03-17', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (772, 2, 2, '2026-03-17', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (773, 6, 4, '2026-03-17', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (774, 2, 4, '2026-03-17', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (775, 6, 1, '2026-03-16', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (776, 2, 1, '2026-03-16', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (777, 6, 2, '2026-03-16', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (778, 2, 2, '2026-03-16', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (779, 6, 4, '2026-03-16', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (780, 2, 4, '2026-03-16', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (781, 6, 1, '2026-03-13', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (782, 2, 1, '2026-03-13', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (783, 6, 2, '2026-03-13', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (784, 2, 2, '2026-03-13', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (785, 6, 4, '2026-03-13', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (786, 2, 4, '2026-03-13', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (787, 6, 1, '2026-03-12', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (788, 2, 1, '2026-03-12', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (789, 6, 2, '2026-03-12', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (790, 2, 2, '2026-03-12', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (791, 6, 4, '2026-03-12', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (792, 2, 4, '2026-03-12', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (793, 6, 1, '2026-03-11', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (794, 2, 1, '2026-03-11', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (795, 6, 2, '2026-03-11', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (796, 2, 2, '2026-03-11', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (797, 6, 4, '2026-03-11', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (798, 2, 4, '2026-03-11', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (799, 6, 1, '2026-03-10', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (800, 2, 1, '2026-03-10', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (801, 6, 2, '2026-03-10', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (802, 2, 2, '2026-03-10', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (803, 6, 4, '2026-03-10', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (804, 2, 4, '2026-03-10', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (805, 6, 1, '2026-03-09', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (806, 2, 1, '2026-03-09', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (807, 6, 2, '2026-03-09', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (808, 2, 2, '2026-03-09', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (809, 6, 4, '2026-03-09', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (810, 2, 4, '2026-03-09', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (811, 6, 1, '2026-03-06', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (812, 2, 1, '2026-03-06', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (813, 6, 2, '2026-03-06', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (814, 2, 2, '2026-03-06', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (815, 6, 4, '2026-03-06', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (816, 2, 4, '2026-03-06', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (817, 6, 1, '2026-03-05', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (818, 2, 1, '2026-03-05', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (819, 6, 2, '2026-03-05', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (820, 2, 2, '2026-03-05', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (821, 6, 4, '2026-03-05', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (822, 2, 4, '2026-03-05', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (823, 6, 1, '2026-03-04', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (824, 2, 1, '2026-03-04', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (825, 6, 2, '2026-03-04', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (826, 2, 2, '2026-03-04', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (827, 6, 4, '2026-03-04', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (828, 2, 4, '2026-03-04', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (829, 6, 1, '2026-03-03', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (830, 2, 1, '2026-03-03', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (831, 6, 2, '2026-03-03', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (832, 2, 2, '2026-03-03', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (833, 6, 4, '2026-03-03', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (834, 2, 4, '2026-03-03', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (835, 6, 1, '2026-03-02', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (836, 2, 1, '2026-03-02', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (837, 6, 2, '2026-03-02', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (838, 2, 2, '2026-03-02', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (839, 6, 4, '2026-03-02', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (840, 2, 4, '2026-03-02', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (841, 6, 1, '2026-02-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (842, 2, 1, '2026-02-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (843, 6, 2, '2026-02-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (844, 2, 2, '2026-02-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (845, 6, 4, '2026-02-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (846, 2, 4, '2026-02-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (847, 6, 1, '2026-02-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (848, 2, 1, '2026-02-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (849, 6, 2, '2026-02-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (850, 2, 2, '2026-02-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (851, 6, 4, '2026-02-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (852, 2, 4, '2026-02-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (853, 6, 1, '2026-02-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (854, 2, 1, '2026-02-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (855, 6, 2, '2026-02-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (856, 2, 2, '2026-02-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (857, 6, 4, '2026-02-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (858, 2, 4, '2026-02-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (859, 6, 1, '2026-02-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (860, 2, 1, '2026-02-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (861, 6, 2, '2026-02-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (862, 2, 2, '2026-02-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (863, 6, 4, '2026-02-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (864, 2, 4, '2026-02-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (865, 6, 1, '2026-03-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (866, 2, 1, '2026-03-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (867, 6, 2, '2026-03-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (868, 2, 2, '2026-03-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (869, 6, 4, '2026-03-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (870, 2, 4, '2026-03-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (871, 6, 1, '2026-03-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (872, 2, 1, '2026-03-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (873, 6, 2, '2026-03-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (874, 2, 2, '2026-03-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (875, 6, 4, '2026-03-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (876, 2, 4, '2026-03-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (877, 6, 1, '2026-03-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (878, 2, 1, '2026-03-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (879, 6, 2, '2026-03-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (880, 2, 2, '2026-03-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (881, 6, 4, '2026-03-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (882, 2, 4, '2026-03-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (883, 6, 1, '2026-03-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (884, 2, 1, '2026-03-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (885, 6, 2, '2026-03-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (886, 2, 2, '2026-03-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (887, 6, 4, '2026-03-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (888, 2, 4, '2026-03-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (889, 6, 1, '2026-03-23', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (890, 2, 1, '2026-03-23', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (891, 6, 2, '2026-03-23', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (892, 2, 2, '2026-03-23', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (893, 6, 4, '2026-03-23', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (894, 2, 4, '2026-03-23', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (895, 6, 1, '2026-03-20', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (896, 2, 1, '2026-03-20', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (897, 6, 2, '2026-03-20', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (898, 2, 2, '2026-03-20', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (899, 6, 4, '2026-03-20', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (900, 2, 4, '2026-03-20', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (901, 6, 1, '2026-03-19', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (902, 2, 1, '2026-03-19', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (903, 6, 2, '2026-03-19', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (904, 2, 2, '2026-03-19', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (905, 6, 4, '2026-03-19', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (906, 2, 4, '2026-03-19', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (907, 6, 1, '2026-03-18', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (908, 2, 1, '2026-03-18', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (909, 6, 2, '2026-03-18', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (910, 2, 2, '2026-03-18', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (911, 6, 4, '2026-03-18', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (912, 2, 4, '2026-03-18', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (913, 6, 1, '2026-03-17', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (914, 2, 1, '2026-03-17', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (915, 6, 2, '2026-03-17', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (916, 2, 2, '2026-03-17', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (917, 6, 4, '2026-03-17', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (918, 2, 4, '2026-03-17', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (919, 6, 1, '2026-03-16', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (920, 2, 1, '2026-03-16', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (921, 6, 2, '2026-03-16', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (922, 2, 2, '2026-03-16', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (923, 6, 4, '2026-03-16', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (924, 2, 4, '2026-03-16', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (925, 6, 1, '2026-03-13', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (926, 2, 1, '2026-03-13', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (927, 6, 2, '2026-03-13', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (928, 2, 2, '2026-03-13', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (929, 6, 4, '2026-03-13', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (930, 2, 4, '2026-03-13', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (931, 6, 1, '2026-03-12', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (932, 2, 1, '2026-03-12', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (933, 6, 2, '2026-03-12', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (934, 2, 2, '2026-03-12', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (935, 6, 4, '2026-03-12', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (936, 2, 4, '2026-03-12', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (937, 6, 1, '2026-03-11', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (938, 2, 1, '2026-03-11', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (939, 6, 2, '2026-03-11', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (940, 2, 2, '2026-03-11', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (941, 6, 4, '2026-03-11', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (942, 2, 4, '2026-03-11', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (943, 6, 1, '2026-03-10', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (944, 2, 1, '2026-03-10', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (945, 6, 2, '2026-03-10', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (946, 2, 2, '2026-03-10', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (947, 6, 4, '2026-03-10', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (948, 2, 4, '2026-03-10', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (949, 6, 1, '2026-03-09', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (950, 2, 1, '2026-03-09', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (951, 6, 2, '2026-03-09', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (952, 2, 2, '2026-03-09', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (953, 6, 4, '2026-03-09', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (954, 2, 4, '2026-03-09', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (955, 6, 1, '2026-03-06', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (956, 2, 1, '2026-03-06', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (957, 6, 2, '2026-03-06', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (958, 2, 2, '2026-03-06', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (959, 6, 4, '2026-03-06', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (960, 2, 4, '2026-03-06', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (961, 6, 1, '2026-03-05', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (962, 2, 1, '2026-03-05', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (963, 6, 2, '2026-03-05', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (964, 2, 2, '2026-03-05', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (965, 6, 4, '2026-03-05', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (966, 2, 4, '2026-03-05', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (967, 6, 1, '2026-03-04', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (968, 2, 1, '2026-03-04', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (969, 6, 2, '2026-03-04', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (970, 2, 2, '2026-03-04', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (971, 6, 4, '2026-03-04', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (972, 2, 4, '2026-03-04', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (973, 6, 1, '2026-03-03', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (974, 2, 1, '2026-03-03', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (975, 6, 2, '2026-03-03', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (976, 2, 2, '2026-03-03', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (977, 6, 4, '2026-03-03', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (978, 2, 4, '2026-03-03', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (979, 6, 1, '2026-03-02', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (980, 2, 1, '2026-03-02', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (981, 6, 2, '2026-03-02', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (982, 2, 2, '2026-03-02', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (983, 6, 4, '2026-03-02', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (984, 2, 4, '2026-03-02', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (985, 6, 1, '2026-02-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (986, 2, 1, '2026-02-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (987, 6, 2, '2026-02-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (988, 2, 2, '2026-02-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (989, 6, 4, '2026-02-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (990, 2, 4, '2026-02-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (991, 6, 1, '2026-02-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (992, 2, 1, '2026-02-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (993, 6, 2, '2026-02-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (994, 2, 2, '2026-02-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (995, 6, 4, '2026-02-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (996, 2, 4, '2026-02-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (997, 6, 1, '2026-02-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (998, 2, 1, '2026-02-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (999, 6, 2, '2026-02-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1000, 2, 2, '2026-02-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1001, 6, 4, '2026-02-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1002, 2, 4, '2026-02-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1003, 6, 1, '2026-02-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1004, 2, 1, '2026-02-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1005, 6, 2, '2026-02-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1006, 2, 2, '2026-02-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1007, 6, 4, '2026-02-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1008, 2, 4, '2026-02-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1009, 6, 1, '2026-03-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1010, 2, 1, '2026-03-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1011, 6, 2, '2026-03-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1012, 2, 2, '2026-03-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1013, 6, 4, '2026-03-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1014, 2, 4, '2026-03-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1015, 6, 1, '2026-03-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1016, 2, 1, '2026-03-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1017, 6, 2, '2026-03-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1018, 2, 2, '2026-03-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1019, 6, 4, '2026-03-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1020, 2, 4, '2026-03-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1021, 6, 1, '2026-03-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1022, 2, 1, '2026-03-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1023, 6, 2, '2026-03-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1024, 2, 2, '2026-03-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1025, 6, 4, '2026-03-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1026, 2, 4, '2026-03-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1027, 6, 1, '2026-03-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1028, 2, 1, '2026-03-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1029, 6, 2, '2026-03-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1030, 2, 2, '2026-03-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1031, 6, 4, '2026-03-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1032, 2, 4, '2026-03-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1033, 6, 1, '2026-03-23', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1034, 2, 1, '2026-03-23', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1035, 6, 2, '2026-03-23', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1036, 2, 2, '2026-03-23', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1037, 6, 4, '2026-03-23', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1038, 2, 4, '2026-03-23', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1039, 6, 1, '2026-03-20', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1040, 2, 1, '2026-03-20', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1041, 6, 2, '2026-03-20', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1042, 2, 2, '2026-03-20', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1043, 6, 4, '2026-03-20', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1044, 2, 4, '2026-03-20', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1045, 6, 1, '2026-03-19', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1046, 2, 1, '2026-03-19', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1047, 6, 2, '2026-03-19', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1048, 2, 2, '2026-03-19', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1049, 6, 4, '2026-03-19', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1050, 2, 4, '2026-03-19', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1051, 6, 1, '2026-03-18', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1052, 2, 1, '2026-03-18', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1053, 6, 2, '2026-03-18', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1054, 2, 2, '2026-03-18', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1055, 6, 4, '2026-03-18', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1056, 2, 4, '2026-03-18', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1057, 6, 1, '2026-03-17', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1058, 2, 1, '2026-03-17', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1059, 6, 2, '2026-03-17', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1060, 2, 2, '2026-03-17', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1061, 6, 4, '2026-03-17', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1062, 2, 4, '2026-03-17', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1063, 6, 1, '2026-03-16', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1064, 2, 1, '2026-03-16', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1065, 6, 2, '2026-03-16', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1066, 2, 2, '2026-03-16', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1067, 6, 4, '2026-03-16', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1068, 2, 4, '2026-03-16', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1069, 6, 1, '2026-03-13', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1070, 2, 1, '2026-03-13', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1071, 6, 2, '2026-03-13', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1072, 2, 2, '2026-03-13', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1073, 6, 4, '2026-03-13', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1074, 2, 4, '2026-03-13', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1075, 6, 1, '2026-03-12', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1076, 2, 1, '2026-03-12', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1077, 6, 2, '2026-03-12', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1078, 2, 2, '2026-03-12', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1079, 6, 4, '2026-03-12', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1080, 2, 4, '2026-03-12', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1081, 6, 1, '2026-03-11', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1082, 2, 1, '2026-03-11', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1083, 6, 2, '2026-03-11', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1084, 2, 2, '2026-03-11', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1085, 6, 4, '2026-03-11', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1086, 2, 4, '2026-03-11', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1087, 6, 1, '2026-03-10', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1088, 2, 1, '2026-03-10', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1089, 6, 2, '2026-03-10', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1090, 2, 2, '2026-03-10', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1091, 6, 4, '2026-03-10', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1092, 2, 4, '2026-03-10', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1093, 6, 1, '2026-03-09', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1094, 2, 1, '2026-03-09', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1095, 6, 2, '2026-03-09', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1096, 2, 2, '2026-03-09', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1097, 6, 4, '2026-03-09', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1098, 2, 4, '2026-03-09', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1099, 6, 1, '2026-03-06', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1100, 2, 1, '2026-03-06', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1101, 6, 2, '2026-03-06', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1102, 2, 2, '2026-03-06', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1103, 6, 4, '2026-03-06', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1104, 2, 4, '2026-03-06', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1105, 6, 1, '2026-03-05', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1106, 2, 1, '2026-03-05', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1107, 6, 2, '2026-03-05', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1108, 2, 2, '2026-03-05', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1109, 6, 4, '2026-03-05', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1110, 2, 4, '2026-03-05', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1111, 6, 1, '2026-03-04', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1112, 2, 1, '2026-03-04', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1113, 6, 2, '2026-03-04', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1114, 2, 2, '2026-03-04', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1115, 6, 4, '2026-03-04', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1116, 2, 4, '2026-03-04', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1117, 6, 1, '2026-03-03', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1118, 2, 1, '2026-03-03', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1119, 6, 2, '2026-03-03', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1120, 2, 2, '2026-03-03', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1121, 6, 4, '2026-03-03', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1122, 2, 4, '2026-03-03', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1123, 6, 1, '2026-03-02', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1124, 2, 1, '2026-03-02', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1125, 6, 2, '2026-03-02', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1126, 2, 2, '2026-03-02', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1127, 6, 4, '2026-03-02', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1128, 2, 4, '2026-03-02', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1129, 6, 1, '2026-02-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1130, 2, 1, '2026-02-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1131, 6, 2, '2026-02-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1132, 2, 2, '2026-02-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1133, 6, 4, '2026-02-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1134, 2, 4, '2026-02-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1135, 6, 1, '2026-02-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1136, 2, 1, '2026-02-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1137, 6, 2, '2026-02-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1138, 2, 2, '2026-02-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1139, 6, 4, '2026-02-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1140, 2, 4, '2026-02-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1141, 6, 1, '2026-02-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1142, 2, 1, '2026-02-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1143, 6, 2, '2026-02-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1144, 2, 2, '2026-02-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1145, 6, 4, '2026-02-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1146, 2, 4, '2026-02-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1147, 6, 1, '2026-02-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1148, 2, 1, '2026-02-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1149, 6, 2, '2026-02-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1150, 2, 2, '2026-02-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1151, 6, 4, '2026-02-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1152, 2, 4, '2026-02-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1153, 6, 1, '2026-03-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1154, 2, 1, '2026-03-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1155, 6, 2, '2026-03-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1156, 2, 2, '2026-03-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1157, 6, 4, '2026-03-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1158, 2, 4, '2026-03-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1159, 6, 1, '2026-03-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1160, 2, 1, '2026-03-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1161, 6, 2, '2026-03-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1162, 2, 2, '2026-03-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1163, 6, 4, '2026-03-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1164, 2, 4, '2026-03-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1165, 6, 1, '2026-03-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1166, 2, 1, '2026-03-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1167, 6, 2, '2026-03-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1168, 2, 2, '2026-03-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1169, 6, 4, '2026-03-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1170, 2, 4, '2026-03-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1171, 6, 1, '2026-03-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1172, 2, 1, '2026-03-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1173, 6, 2, '2026-03-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1174, 2, 2, '2026-03-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1175, 6, 4, '2026-03-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1176, 2, 4, '2026-03-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1177, 6, 1, '2026-03-23', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1178, 2, 1, '2026-03-23', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1179, 6, 2, '2026-03-23', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1180, 2, 2, '2026-03-23', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1181, 6, 4, '2026-03-23', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1182, 2, 4, '2026-03-23', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1183, 6, 1, '2026-03-20', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1184, 2, 1, '2026-03-20', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1185, 6, 2, '2026-03-20', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1186, 2, 2, '2026-03-20', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1187, 6, 4, '2026-03-20', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1188, 2, 4, '2026-03-20', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1189, 6, 1, '2026-03-19', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1190, 2, 1, '2026-03-19', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1191, 6, 2, '2026-03-19', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1192, 2, 2, '2026-03-19', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1193, 6, 4, '2026-03-19', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1194, 2, 4, '2026-03-19', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1195, 6, 1, '2026-03-18', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1196, 2, 1, '2026-03-18', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1197, 6, 2, '2026-03-18', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1198, 2, 2, '2026-03-18', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1199, 6, 4, '2026-03-18', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1200, 2, 4, '2026-03-18', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1201, 6, 1, '2026-03-17', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1202, 2, 1, '2026-03-17', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1203, 6, 2, '2026-03-17', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1204, 2, 2, '2026-03-17', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1205, 6, 4, '2026-03-17', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1206, 2, 4, '2026-03-17', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1207, 6, 1, '2026-03-16', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1208, 2, 1, '2026-03-16', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1209, 6, 2, '2026-03-16', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1210, 2, 2, '2026-03-16', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1211, 6, 4, '2026-03-16', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1212, 2, 4, '2026-03-16', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1213, 6, 1, '2026-03-13', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1214, 2, 1, '2026-03-13', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1215, 6, 2, '2026-03-13', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1216, 2, 2, '2026-03-13', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1217, 6, 4, '2026-03-13', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1218, 2, 4, '2026-03-13', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1219, 6, 1, '2026-03-12', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1220, 2, 1, '2026-03-12', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1221, 6, 2, '2026-03-12', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1222, 2, 2, '2026-03-12', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1223, 6, 4, '2026-03-12', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1224, 2, 4, '2026-03-12', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1225, 6, 1, '2026-03-11', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1226, 2, 1, '2026-03-11', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1227, 6, 2, '2026-03-11', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1228, 2, 2, '2026-03-11', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1229, 6, 4, '2026-03-11', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1230, 2, 4, '2026-03-11', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1231, 6, 1, '2026-03-10', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1232, 2, 1, '2026-03-10', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1233, 6, 2, '2026-03-10', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1234, 2, 2, '2026-03-10', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1235, 6, 4, '2026-03-10', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1236, 2, 4, '2026-03-10', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1237, 6, 1, '2026-03-09', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1238, 2, 1, '2026-03-09', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1239, 6, 2, '2026-03-09', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1240, 2, 2, '2026-03-09', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1241, 6, 4, '2026-03-09', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1242, 2, 4, '2026-03-09', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1243, 6, 1, '2026-03-06', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1244, 2, 1, '2026-03-06', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1245, 6, 2, '2026-03-06', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1246, 2, 2, '2026-03-06', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1247, 6, 4, '2026-03-06', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1248, 2, 4, '2026-03-06', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1249, 6, 1, '2026-03-05', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1250, 2, 1, '2026-03-05', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1251, 6, 2, '2026-03-05', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1252, 2, 2, '2026-03-05', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1253, 6, 4, '2026-03-05', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1254, 2, 4, '2026-03-05', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1255, 6, 1, '2026-03-04', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1256, 2, 1, '2026-03-04', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1257, 6, 2, '2026-03-04', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1258, 2, 2, '2026-03-04', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1259, 6, 4, '2026-03-04', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1260, 2, 4, '2026-03-04', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1261, 6, 1, '2026-03-03', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1262, 2, 1, '2026-03-03', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1263, 6, 2, '2026-03-03', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1264, 2, 2, '2026-03-03', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1265, 6, 4, '2026-03-03', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1266, 2, 4, '2026-03-03', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1267, 6, 1, '2026-03-02', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1268, 2, 1, '2026-03-02', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1269, 6, 2, '2026-03-02', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1270, 2, 2, '2026-03-02', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1271, 6, 4, '2026-03-02', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1272, 2, 4, '2026-03-02', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1273, 6, 1, '2026-02-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1274, 2, 1, '2026-02-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1275, 6, 2, '2026-02-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1276, 2, 2, '2026-02-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1277, 6, 4, '2026-02-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1278, 2, 4, '2026-02-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1279, 6, 1, '2026-02-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1280, 2, 1, '2026-02-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1281, 6, 2, '2026-02-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1282, 2, 2, '2026-02-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1283, 6, 4, '2026-02-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1284, 2, 4, '2026-02-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1285, 6, 1, '2026-02-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1286, 2, 1, '2026-02-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1287, 6, 2, '2026-02-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1288, 2, 2, '2026-02-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1289, 6, 4, '2026-02-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1290, 2, 4, '2026-02-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1291, 6, 1, '2026-02-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1292, 2, 1, '2026-02-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1293, 6, 2, '2026-02-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1294, 2, 2, '2026-02-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1295, 6, 4, '2026-02-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1296, 2, 4, '2026-02-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1297, 6, 1, '2026-03-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1298, 2, 1, '2026-03-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1299, 6, 2, '2026-03-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1300, 2, 2, '2026-03-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1301, 6, 4, '2026-03-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1302, 2, 4, '2026-03-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1303, 6, 1, '2026-03-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1304, 2, 1, '2026-03-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1305, 6, 2, '2026-03-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1306, 2, 2, '2026-03-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1307, 6, 4, '2026-03-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1308, 2, 4, '2026-03-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1309, 6, 1, '2026-03-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1310, 2, 1, '2026-03-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1311, 6, 2, '2026-03-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1312, 2, 2, '2026-03-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1313, 6, 4, '2026-03-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1314, 2, 4, '2026-03-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1315, 6, 1, '2026-03-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1316, 2, 1, '2026-03-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1317, 6, 2, '2026-03-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1318, 2, 2, '2026-03-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1319, 6, 4, '2026-03-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1320, 2, 4, '2026-03-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1321, 6, 1, '2026-03-23', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1322, 2, 1, '2026-03-23', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1323, 6, 2, '2026-03-23', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1324, 2, 2, '2026-03-23', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1325, 6, 4, '2026-03-23', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1326, 2, 4, '2026-03-23', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1327, 6, 1, '2026-03-20', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1328, 2, 1, '2026-03-20', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1329, 6, 2, '2026-03-20', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1330, 2, 2, '2026-03-20', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1331, 6, 4, '2026-03-20', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1332, 2, 4, '2026-03-20', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1333, 6, 1, '2026-03-19', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1334, 2, 1, '2026-03-19', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1335, 6, 2, '2026-03-19', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1336, 2, 2, '2026-03-19', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1337, 6, 4, '2026-03-19', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1338, 2, 4, '2026-03-19', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1339, 6, 1, '2026-03-18', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1340, 2, 1, '2026-03-18', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1341, 6, 2, '2026-03-18', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1342, 2, 2, '2026-03-18', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1343, 6, 4, '2026-03-18', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1344, 2, 4, '2026-03-18', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1345, 6, 1, '2026-03-17', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1346, 2, 1, '2026-03-17', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1347, 6, 2, '2026-03-17', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1348, 2, 2, '2026-03-17', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1349, 6, 4, '2026-03-17', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1350, 2, 4, '2026-03-17', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1351, 6, 1, '2026-03-16', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1352, 2, 1, '2026-03-16', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1353, 6, 2, '2026-03-16', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1354, 2, 2, '2026-03-16', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1355, 6, 4, '2026-03-16', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1356, 2, 4, '2026-03-16', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1357, 6, 1, '2026-03-13', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1358, 2, 1, '2026-03-13', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1359, 6, 2, '2026-03-13', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1360, 2, 2, '2026-03-13', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1361, 6, 4, '2026-03-13', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1362, 2, 4, '2026-03-13', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1363, 6, 1, '2026-03-12', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1364, 2, 1, '2026-03-12', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1365, 6, 2, '2026-03-12', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1366, 2, 2, '2026-03-12', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1367, 6, 4, '2026-03-12', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1368, 2, 4, '2026-03-12', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1369, 6, 1, '2026-03-11', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1370, 2, 1, '2026-03-11', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1371, 6, 2, '2026-03-11', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1372, 2, 2, '2026-03-11', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1373, 6, 4, '2026-03-11', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1374, 2, 4, '2026-03-11', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1375, 6, 1, '2026-03-10', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1376, 2, 1, '2026-03-10', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1377, 6, 2, '2026-03-10', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1378, 2, 2, '2026-03-10', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1379, 6, 4, '2026-03-10', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1380, 2, 4, '2026-03-10', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1381, 6, 1, '2026-03-09', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1382, 2, 1, '2026-03-09', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1383, 6, 2, '2026-03-09', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1384, 2, 2, '2026-03-09', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1385, 6, 4, '2026-03-09', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1386, 2, 4, '2026-03-09', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1387, 6, 1, '2026-03-06', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1388, 2, 1, '2026-03-06', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1389, 6, 2, '2026-03-06', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1390, 2, 2, '2026-03-06', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1391, 6, 4, '2026-03-06', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1392, 2, 4, '2026-03-06', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1393, 6, 1, '2026-03-05', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1394, 2, 1, '2026-03-05', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1395, 6, 2, '2026-03-05', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1396, 2, 2, '2026-03-05', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1397, 6, 4, '2026-03-05', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1398, 2, 4, '2026-03-05', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1399, 6, 1, '2026-03-04', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1400, 2, 1, '2026-03-04', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1401, 6, 2, '2026-03-04', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1402, 2, 2, '2026-03-04', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1403, 6, 4, '2026-03-04', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1404, 2, 4, '2026-03-04', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1405, 6, 1, '2026-03-03', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1406, 2, 1, '2026-03-03', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1407, 6, 2, '2026-03-03', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1408, 2, 2, '2026-03-03', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1409, 6, 4, '2026-03-03', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1410, 2, 4, '2026-03-03', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1411, 6, 1, '2026-03-02', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1412, 2, 1, '2026-03-02', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1413, 6, 2, '2026-03-02', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1414, 2, 2, '2026-03-02', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1415, 6, 4, '2026-03-02', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1416, 2, 4, '2026-03-02', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1417, 6, 1, '2026-02-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1418, 2, 1, '2026-02-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1419, 6, 2, '2026-02-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1420, 2, 2, '2026-02-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1421, 6, 4, '2026-02-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1422, 2, 4, '2026-02-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1423, 6, 1, '2026-02-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1424, 2, 1, '2026-02-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1425, 6, 2, '2026-02-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1426, 2, 2, '2026-02-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1427, 6, 4, '2026-02-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1428, 2, 4, '2026-02-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1429, 6, 1, '2026-02-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1430, 2, 1, '2026-02-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1431, 6, 2, '2026-02-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1432, 2, 2, '2026-02-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1433, 6, 4, '2026-02-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1434, 2, 4, '2026-02-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1435, 6, 1, '2026-02-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1436, 2, 1, '2026-02-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1437, 6, 2, '2026-02-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1438, 2, 2, '2026-02-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1439, 6, 4, '2026-02-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1440, 2, 4, '2026-02-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1441, 6, 1, '2026-03-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1442, 2, 1, '2026-03-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1443, 6, 2, '2026-03-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1444, 2, 2, '2026-03-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1445, 6, 4, '2026-03-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1446, 2, 4, '2026-03-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1447, 6, 1, '2026-03-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1448, 2, 1, '2026-03-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1449, 6, 2, '2026-03-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1450, 2, 2, '2026-03-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1451, 6, 4, '2026-03-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1452, 2, 4, '2026-03-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1453, 6, 1, '2026-03-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1454, 2, 1, '2026-03-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1455, 6, 2, '2026-03-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1456, 2, 2, '2026-03-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1457, 6, 4, '2026-03-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1458, 2, 4, '2026-03-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1459, 6, 1, '2026-03-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1460, 2, 1, '2026-03-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1461, 6, 2, '2026-03-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1462, 2, 2, '2026-03-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1463, 6, 4, '2026-03-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1464, 2, 4, '2026-03-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1465, 6, 1, '2026-03-23', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1466, 2, 1, '2026-03-23', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1467, 6, 2, '2026-03-23', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1468, 2, 2, '2026-03-23', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1469, 6, 4, '2026-03-23', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1470, 2, 4, '2026-03-23', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1471, 6, 1, '2026-03-20', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1472, 2, 1, '2026-03-20', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1473, 6, 2, '2026-03-20', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1474, 2, 2, '2026-03-20', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1475, 6, 4, '2026-03-20', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1476, 2, 4, '2026-03-20', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1477, 6, 1, '2026-03-19', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1478, 2, 1, '2026-03-19', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1479, 6, 2, '2026-03-19', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1480, 2, 2, '2026-03-19', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1481, 6, 4, '2026-03-19', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1482, 2, 4, '2026-03-19', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1483, 6, 1, '2026-03-18', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1484, 2, 1, '2026-03-18', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1485, 6, 2, '2026-03-18', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1486, 2, 2, '2026-03-18', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1487, 6, 4, '2026-03-18', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1488, 2, 4, '2026-03-18', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1489, 6, 1, '2026-03-17', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1490, 2, 1, '2026-03-17', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1491, 6, 2, '2026-03-17', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1492, 2, 2, '2026-03-17', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1493, 6, 4, '2026-03-17', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1494, 2, 4, '2026-03-17', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1495, 6, 1, '2026-03-16', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1496, 2, 1, '2026-03-16', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1497, 6, 2, '2026-03-16', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1498, 2, 2, '2026-03-16', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1499, 6, 4, '2026-03-16', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1500, 2, 4, '2026-03-16', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1501, 6, 1, '2026-03-13', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1502, 2, 1, '2026-03-13', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1503, 6, 2, '2026-03-13', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1504, 2, 2, '2026-03-13', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1505, 6, 4, '2026-03-13', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1506, 2, 4, '2026-03-13', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1507, 6, 1, '2026-03-12', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1508, 2, 1, '2026-03-12', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1509, 6, 2, '2026-03-12', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1510, 2, 2, '2026-03-12', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1511, 6, 4, '2026-03-12', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1512, 2, 4, '2026-03-12', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1513, 6, 1, '2026-03-11', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1514, 2, 1, '2026-03-11', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1515, 6, 2, '2026-03-11', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1516, 2, 2, '2026-03-11', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1517, 6, 4, '2026-03-11', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1518, 2, 4, '2026-03-11', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1519, 6, 1, '2026-03-10', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1520, 2, 1, '2026-03-10', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1521, 6, 2, '2026-03-10', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1522, 2, 2, '2026-03-10', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1523, 6, 4, '2026-03-10', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1524, 2, 4, '2026-03-10', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1525, 6, 1, '2026-03-09', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1526, 2, 1, '2026-03-09', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1527, 6, 2, '2026-03-09', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1528, 2, 2, '2026-03-09', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1529, 6, 4, '2026-03-09', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1530, 2, 4, '2026-03-09', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1531, 6, 1, '2026-03-06', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1532, 2, 1, '2026-03-06', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1533, 6, 2, '2026-03-06', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1534, 2, 2, '2026-03-06', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1535, 6, 4, '2026-03-06', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1536, 2, 4, '2026-03-06', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1537, 6, 1, '2026-03-05', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1538, 2, 1, '2026-03-05', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1539, 6, 2, '2026-03-05', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1540, 2, 2, '2026-03-05', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1541, 6, 4, '2026-03-05', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1542, 2, 4, '2026-03-05', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1543, 6, 1, '2026-03-04', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1544, 2, 1, '2026-03-04', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1545, 6, 2, '2026-03-04', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1546, 2, 2, '2026-03-04', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1547, 6, 4, '2026-03-04', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1548, 2, 4, '2026-03-04', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1549, 6, 1, '2026-03-03', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1550, 2, 1, '2026-03-03', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1551, 6, 2, '2026-03-03', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1552, 2, 2, '2026-03-03', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1553, 6, 4, '2026-03-03', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1554, 2, 4, '2026-03-03', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1555, 6, 1, '2026-03-02', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1556, 2, 1, '2026-03-02', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1557, 6, 2, '2026-03-02', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1558, 2, 2, '2026-03-02', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1559, 6, 4, '2026-03-02', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1560, 2, 4, '2026-03-02', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1561, 6, 1, '2026-02-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1562, 2, 1, '2026-02-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1563, 6, 2, '2026-02-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1564, 2, 2, '2026-02-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1565, 6, 4, '2026-02-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1566, 2, 4, '2026-02-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1567, 6, 1, '2026-02-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1568, 2, 1, '2026-02-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1569, 6, 2, '2026-02-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1570, 2, 2, '2026-02-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1571, 6, 4, '2026-02-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1572, 2, 4, '2026-02-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1573, 6, 1, '2026-02-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1574, 2, 1, '2026-02-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1575, 6, 2, '2026-02-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1576, 2, 2, '2026-02-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1577, 6, 4, '2026-02-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1578, 2, 4, '2026-02-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1579, 6, 1, '2026-02-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1580, 2, 1, '2026-02-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1581, 6, 2, '2026-02-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1582, 2, 2, '2026-02-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1583, 6, 4, '2026-02-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1584, 2, 4, '2026-02-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1585, 6, 1, '2026-03-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1586, 2, 1, '2026-03-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1587, 6, 2, '2026-03-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1588, 2, 2, '2026-03-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1589, 6, 4, '2026-03-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1590, 2, 4, '2026-03-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1591, 6, 1, '2026-03-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1592, 2, 1, '2026-03-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1593, 6, 2, '2026-03-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1594, 2, 2, '2026-03-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1595, 6, 4, '2026-03-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1596, 2, 4, '2026-03-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1597, 6, 1, '2026-03-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1598, 2, 1, '2026-03-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1599, 6, 2, '2026-03-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1600, 2, 2, '2026-03-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1601, 6, 4, '2026-03-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1602, 2, 4, '2026-03-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1603, 6, 1, '2026-03-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1604, 2, 1, '2026-03-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1605, 6, 2, '2026-03-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1606, 2, 2, '2026-03-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1607, 6, 4, '2026-03-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1608, 2, 4, '2026-03-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1609, 6, 1, '2026-03-23', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1610, 2, 1, '2026-03-23', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1611, 6, 2, '2026-03-23', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1612, 2, 2, '2026-03-23', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1613, 6, 4, '2026-03-23', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1614, 2, 4, '2026-03-23', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1615, 6, 1, '2026-03-20', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1616, 2, 1, '2026-03-20', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1617, 6, 2, '2026-03-20', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1618, 2, 2, '2026-03-20', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1619, 6, 4, '2026-03-20', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1620, 2, 4, '2026-03-20', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1621, 6, 1, '2026-03-19', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1622, 2, 1, '2026-03-19', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1623, 6, 2, '2026-03-19', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1624, 2, 2, '2026-03-19', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1625, 6, 4, '2026-03-19', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1626, 2, 4, '2026-03-19', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1627, 6, 1, '2026-03-18', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1628, 2, 1, '2026-03-18', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1629, 6, 2, '2026-03-18', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1630, 2, 2, '2026-03-18', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1631, 6, 4, '2026-03-18', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1632, 2, 4, '2026-03-18', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1633, 6, 1, '2026-03-17', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1634, 2, 1, '2026-03-17', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1635, 6, 2, '2026-03-17', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1636, 2, 2, '2026-03-17', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1637, 6, 4, '2026-03-17', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1638, 2, 4, '2026-03-17', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1639, 6, 1, '2026-03-16', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1640, 2, 1, '2026-03-16', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1641, 6, 2, '2026-03-16', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1642, 2, 2, '2026-03-16', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1643, 6, 4, '2026-03-16', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1644, 2, 4, '2026-03-16', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1645, 6, 1, '2026-03-13', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1646, 2, 1, '2026-03-13', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1647, 6, 2, '2026-03-13', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1648, 2, 2, '2026-03-13', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1649, 6, 4, '2026-03-13', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1650, 2, 4, '2026-03-13', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1651, 6, 1, '2026-03-12', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1652, 2, 1, '2026-03-12', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1653, 6, 2, '2026-03-12', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1654, 2, 2, '2026-03-12', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1655, 6, 4, '2026-03-12', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1656, 2, 4, '2026-03-12', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1657, 6, 1, '2026-03-11', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1658, 2, 1, '2026-03-11', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1659, 6, 2, '2026-03-11', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1660, 2, 2, '2026-03-11', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1661, 6, 4, '2026-03-11', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1662, 2, 4, '2026-03-11', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1663, 6, 1, '2026-03-10', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1664, 2, 1, '2026-03-10', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1665, 6, 2, '2026-03-10', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1666, 2, 2, '2026-03-10', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1667, 6, 4, '2026-03-10', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1668, 2, 4, '2026-03-10', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1669, 6, 1, '2026-03-09', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1670, 2, 1, '2026-03-09', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1671, 6, 2, '2026-03-09', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1672, 2, 2, '2026-03-09', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1673, 6, 4, '2026-03-09', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1674, 2, 4, '2026-03-09', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1675, 6, 1, '2026-03-06', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1676, 2, 1, '2026-03-06', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1677, 6, 2, '2026-03-06', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1678, 2, 2, '2026-03-06', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1679, 6, 4, '2026-03-06', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1680, 2, 4, '2026-03-06', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1681, 6, 1, '2026-03-05', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1682, 2, 1, '2026-03-05', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1683, 6, 2, '2026-03-05', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1684, 2, 2, '2026-03-05', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1685, 6, 4, '2026-03-05', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1686, 2, 4, '2026-03-05', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1687, 6, 1, '2026-03-04', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1688, 2, 1, '2026-03-04', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1689, 6, 2, '2026-03-04', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1690, 2, 2, '2026-03-04', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1691, 6, 4, '2026-03-04', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1692, 2, 4, '2026-03-04', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1693, 6, 1, '2026-03-03', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1694, 2, 1, '2026-03-03', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1695, 6, 2, '2026-03-03', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1696, 2, 2, '2026-03-03', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1697, 6, 4, '2026-03-03', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1698, 2, 4, '2026-03-03', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1699, 6, 1, '2026-03-02', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1700, 2, 1, '2026-03-02', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1701, 6, 2, '2026-03-02', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1702, 2, 2, '2026-03-02', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1703, 6, 4, '2026-03-02', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1704, 2, 4, '2026-03-02', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1705, 6, 1, '2026-02-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1706, 2, 1, '2026-02-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1707, 6, 2, '2026-02-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1708, 2, 2, '2026-02-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1709, 6, 4, '2026-02-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1710, 2, 4, '2026-02-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1711, 6, 1, '2026-02-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1712, 2, 1, '2026-02-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1713, 6, 2, '2026-02-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1714, 2, 2, '2026-02-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1715, 6, 4, '2026-02-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1716, 2, 4, '2026-02-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1717, 6, 1, '2026-02-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1718, 2, 1, '2026-02-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1719, 6, 2, '2026-02-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1720, 2, 2, '2026-02-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1721, 6, 4, '2026-02-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1722, 2, 4, '2026-02-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1723, 6, 1, '2026-02-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1724, 2, 1, '2026-02-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1725, 6, 2, '2026-02-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1726, 2, 2, '2026-02-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1727, 6, 4, '2026-02-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1728, 2, 4, '2026-02-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1729, 6, 1, '2026-03-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1730, 2, 1, '2026-03-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1731, 6, 2, '2026-03-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1732, 2, 2, '2026-03-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1733, 6, 4, '2026-03-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1734, 2, 4, '2026-03-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1735, 6, 1, '2026-03-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1736, 2, 1, '2026-03-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1737, 6, 2, '2026-03-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1738, 2, 2, '2026-03-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1739, 6, 4, '2026-03-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1740, 2, 4, '2026-03-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1741, 6, 1, '2026-03-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1742, 2, 1, '2026-03-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1743, 6, 2, '2026-03-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1744, 2, 2, '2026-03-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1745, 6, 4, '2026-03-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1746, 2, 4, '2026-03-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1747, 6, 1, '2026-03-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1748, 2, 1, '2026-03-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1749, 6, 2, '2026-03-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1750, 2, 2, '2026-03-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1751, 6, 4, '2026-03-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1752, 2, 4, '2026-03-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1753, 6, 1, '2026-03-23', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1754, 2, 1, '2026-03-23', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1755, 6, 2, '2026-03-23', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1756, 2, 2, '2026-03-23', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1757, 6, 4, '2026-03-23', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1758, 2, 4, '2026-03-23', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1759, 6, 1, '2026-03-20', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1760, 2, 1, '2026-03-20', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1761, 6, 2, '2026-03-20', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1762, 2, 2, '2026-03-20', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1763, 6, 4, '2026-03-20', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1764, 2, 4, '2026-03-20', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1765, 6, 1, '2026-03-19', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1766, 2, 1, '2026-03-19', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1767, 6, 2, '2026-03-19', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1768, 2, 2, '2026-03-19', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1769, 6, 4, '2026-03-19', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1770, 2, 4, '2026-03-19', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1771, 6, 1, '2026-03-18', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1772, 2, 1, '2026-03-18', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1773, 6, 2, '2026-03-18', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1774, 2, 2, '2026-03-18', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1775, 6, 4, '2026-03-18', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1776, 2, 4, '2026-03-18', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1777, 6, 1, '2026-03-17', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1778, 2, 1, '2026-03-17', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1779, 6, 2, '2026-03-17', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1780, 2, 2, '2026-03-17', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1781, 6, 4, '2026-03-17', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1782, 2, 4, '2026-03-17', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1783, 6, 1, '2026-03-16', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1784, 2, 1, '2026-03-16', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1785, 6, 2, '2026-03-16', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1786, 2, 2, '2026-03-16', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1787, 6, 4, '2026-03-16', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1788, 2, 4, '2026-03-16', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1789, 6, 1, '2026-03-13', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1790, 2, 1, '2026-03-13', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1791, 6, 2, '2026-03-13', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1792, 2, 2, '2026-03-13', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1793, 6, 4, '2026-03-13', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1794, 2, 4, '2026-03-13', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1795, 6, 1, '2026-03-12', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1796, 2, 1, '2026-03-12', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1797, 6, 2, '2026-03-12', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1798, 2, 2, '2026-03-12', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1799, 6, 4, '2026-03-12', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1800, 2, 4, '2026-03-12', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1801, 6, 1, '2026-03-11', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1802, 2, 1, '2026-03-11', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1803, 6, 2, '2026-03-11', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1804, 2, 2, '2026-03-11', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1805, 6, 4, '2026-03-11', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1806, 2, 4, '2026-03-11', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1807, 6, 1, '2026-03-10', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1808, 2, 1, '2026-03-10', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1809, 6, 2, '2026-03-10', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1810, 2, 2, '2026-03-10', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1811, 6, 4, '2026-03-10', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1812, 2, 4, '2026-03-10', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1813, 6, 1, '2026-03-09', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1814, 2, 1, '2026-03-09', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1815, 6, 2, '2026-03-09', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1816, 2, 2, '2026-03-09', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1817, 6, 4, '2026-03-09', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1818, 2, 4, '2026-03-09', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1819, 6, 1, '2026-03-06', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1820, 2, 1, '2026-03-06', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1821, 6, 2, '2026-03-06', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1822, 2, 2, '2026-03-06', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1823, 6, 4, '2026-03-06', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1824, 2, 4, '2026-03-06', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1825, 6, 1, '2026-03-05', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1826, 2, 1, '2026-03-05', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1827, 6, 2, '2026-03-05', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1828, 2, 2, '2026-03-05', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1829, 6, 4, '2026-03-05', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1830, 2, 4, '2026-03-05', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1831, 6, 1, '2026-03-04', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1832, 2, 1, '2026-03-04', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1833, 6, 2, '2026-03-04', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1834, 2, 2, '2026-03-04', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1835, 6, 4, '2026-03-04', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1836, 2, 4, '2026-03-04', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1837, 6, 1, '2026-03-03', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1838, 2, 1, '2026-03-03', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1839, 6, 2, '2026-03-03', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1840, 2, 2, '2026-03-03', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1841, 6, 4, '2026-03-03', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1842, 2, 4, '2026-03-03', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1843, 6, 1, '2026-03-02', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1844, 2, 1, '2026-03-02', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1845, 6, 2, '2026-03-02', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1846, 2, 2, '2026-03-02', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1847, 6, 4, '2026-03-02', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1848, 2, 4, '2026-03-02', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1849, 6, 1, '2026-02-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1850, 2, 1, '2026-02-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1851, 6, 2, '2026-02-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1852, 2, 2, '2026-02-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1853, 6, 4, '2026-02-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1854, 2, 4, '2026-02-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1855, 6, 1, '2026-02-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1856, 2, 1, '2026-02-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1857, 6, 2, '2026-02-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1858, 2, 2, '2026-02-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1859, 6, 4, '2026-02-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1860, 2, 4, '2026-02-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1861, 6, 1, '2026-02-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1862, 2, 1, '2026-02-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1863, 6, 2, '2026-02-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1864, 2, 2, '2026-02-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1865, 6, 4, '2026-02-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1866, 2, 4, '2026-02-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1867, 6, 1, '2026-02-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1868, 2, 1, '2026-02-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1869, 6, 2, '2026-02-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1870, 2, 2, '2026-02-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1871, 6, 4, '2026-02-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1872, 2, 4, '2026-02-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1873, 6, 1, '2026-03-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1874, 2, 1, '2026-03-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1875, 6, 2, '2026-03-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1876, 2, 2, '2026-03-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1877, 6, 4, '2026-03-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1878, 2, 4, '2026-03-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1879, 6, 1, '2026-03-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1880, 2, 1, '2026-03-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1881, 6, 2, '2026-03-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1882, 2, 2, '2026-03-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1883, 6, 4, '2026-03-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1884, 2, 4, '2026-03-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1885, 6, 1, '2026-03-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1886, 2, 1, '2026-03-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1887, 6, 2, '2026-03-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1888, 2, 2, '2026-03-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1889, 6, 4, '2026-03-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1890, 2, 4, '2026-03-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1891, 6, 1, '2026-03-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1892, 2, 1, '2026-03-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1893, 6, 2, '2026-03-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1894, 2, 2, '2026-03-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1895, 6, 4, '2026-03-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1896, 2, 4, '2026-03-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1897, 6, 1, '2026-03-23', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1898, 2, 1, '2026-03-23', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1899, 6, 2, '2026-03-23', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1900, 2, 2, '2026-03-23', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1901, 6, 4, '2026-03-23', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1902, 2, 4, '2026-03-23', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1903, 6, 1, '2026-03-20', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1904, 2, 1, '2026-03-20', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1905, 6, 2, '2026-03-20', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1906, 2, 2, '2026-03-20', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1907, 6, 4, '2026-03-20', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1908, 2, 4, '2026-03-20', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1909, 6, 1, '2026-03-19', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1910, 2, 1, '2026-03-19', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1911, 6, 2, '2026-03-19', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1912, 2, 2, '2026-03-19', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1913, 6, 4, '2026-03-19', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1914, 2, 4, '2026-03-19', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1915, 6, 1, '2026-03-18', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1916, 2, 1, '2026-03-18', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1917, 6, 2, '2026-03-18', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1918, 2, 2, '2026-03-18', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1919, 6, 4, '2026-03-18', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1920, 2, 4, '2026-03-18', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1921, 6, 1, '2026-03-17', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1922, 2, 1, '2026-03-17', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1923, 6, 2, '2026-03-17', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1924, 2, 2, '2026-03-17', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1925, 6, 4, '2026-03-17', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1926, 2, 4, '2026-03-17', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1927, 6, 1, '2026-03-16', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1928, 2, 1, '2026-03-16', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1929, 6, 2, '2026-03-16', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1930, 2, 2, '2026-03-16', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1931, 6, 4, '2026-03-16', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1932, 2, 4, '2026-03-16', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1933, 6, 1, '2026-03-13', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1934, 2, 1, '2026-03-13', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1935, 6, 2, '2026-03-13', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1936, 2, 2, '2026-03-13', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1937, 6, 4, '2026-03-13', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1938, 2, 4, '2026-03-13', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1939, 6, 1, '2026-03-12', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1940, 2, 1, '2026-03-12', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1941, 6, 2, '2026-03-12', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1942, 2, 2, '2026-03-12', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1943, 6, 4, '2026-03-12', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1944, 2, 4, '2026-03-12', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1945, 6, 1, '2026-03-11', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1946, 2, 1, '2026-03-11', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1947, 6, 2, '2026-03-11', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1948, 2, 2, '2026-03-11', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1949, 6, 4, '2026-03-11', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1950, 2, 4, '2026-03-11', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1951, 6, 1, '2026-03-10', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1952, 2, 1, '2026-03-10', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1953, 6, 2, '2026-03-10', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1954, 2, 2, '2026-03-10', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1955, 6, 4, '2026-03-10', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1956, 2, 4, '2026-03-10', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1957, 6, 1, '2026-03-09', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1958, 2, 1, '2026-03-09', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1959, 6, 2, '2026-03-09', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1960, 2, 2, '2026-03-09', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1961, 6, 4, '2026-03-09', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1962, 2, 4, '2026-03-09', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1963, 6, 1, '2026-03-06', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1964, 2, 1, '2026-03-06', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1965, 6, 2, '2026-03-06', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1966, 2, 2, '2026-03-06', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1967, 6, 4, '2026-03-06', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1968, 2, 4, '2026-03-06', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1969, 6, 1, '2026-03-05', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1970, 2, 1, '2026-03-05', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1971, 6, 2, '2026-03-05', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1972, 2, 2, '2026-03-05', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1973, 6, 4, '2026-03-05', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1974, 2, 4, '2026-03-05', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1975, 6, 1, '2026-03-04', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1976, 2, 1, '2026-03-04', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1977, 6, 2, '2026-03-04', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1978, 2, 2, '2026-03-04', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1979, 6, 4, '2026-03-04', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1980, 2, 4, '2026-03-04', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1981, 6, 1, '2026-03-03', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1982, 2, 1, '2026-03-03', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1983, 6, 2, '2026-03-03', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1984, 2, 2, '2026-03-03', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1985, 6, 4, '2026-03-03', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1986, 2, 4, '2026-03-03', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1987, 6, 1, '2026-03-02', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1988, 2, 1, '2026-03-02', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1989, 6, 2, '2026-03-02', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1990, 2, 2, '2026-03-02', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1991, 6, 4, '2026-03-02', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1992, 2, 4, '2026-03-02', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1993, 6, 1, '2026-02-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1994, 2, 1, '2026-02-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1995, 6, 2, '2026-02-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1996, 2, 2, '2026-02-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1997, 6, 4, '2026-02-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1998, 2, 4, '2026-02-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1999, 6, 1, '2026-02-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2000, 2, 1, '2026-02-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2001, 6, 2, '2026-02-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2002, 2, 2, '2026-02-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2003, 6, 4, '2026-02-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2004, 2, 4, '2026-02-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2005, 6, 1, '2026-02-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2006, 2, 1, '2026-02-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2007, 6, 2, '2026-02-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2008, 2, 2, '2026-02-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2009, 6, 4, '2026-02-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2010, 2, 4, '2026-02-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2011, 6, 1, '2026-02-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2012, 2, 1, '2026-02-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2013, 6, 2, '2026-02-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2014, 2, 2, '2026-02-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2015, 6, 4, '2026-02-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2016, 2, 4, '2026-02-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2017, 6, 1, '2026-03-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2018, 2, 1, '2026-03-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2019, 6, 2, '2026-03-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2020, 2, 2, '2026-03-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2021, 6, 4, '2026-03-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2022, 2, 4, '2026-03-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2023, 6, 1, '2026-03-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2024, 2, 1, '2026-03-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2025, 6, 2, '2026-03-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2026, 2, 2, '2026-03-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2027, 6, 4, '2026-03-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2028, 2, 4, '2026-03-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2029, 6, 1, '2026-03-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2030, 2, 1, '2026-03-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2031, 6, 2, '2026-03-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2032, 2, 2, '2026-03-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2033, 6, 4, '2026-03-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2034, 2, 4, '2026-03-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2035, 6, 1, '2026-03-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2036, 2, 1, '2026-03-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2037, 6, 2, '2026-03-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2038, 2, 2, '2026-03-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2039, 6, 4, '2026-03-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2040, 2, 4, '2026-03-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2041, 6, 1, '2026-03-23', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2042, 2, 1, '2026-03-23', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2043, 6, 2, '2026-03-23', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2044, 2, 2, '2026-03-23', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2045, 6, 4, '2026-03-23', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2046, 2, 4, '2026-03-23', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2047, 6, 1, '2026-03-20', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2048, 2, 1, '2026-03-20', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2049, 6, 2, '2026-03-20', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2050, 2, 2, '2026-03-20', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2051, 6, 4, '2026-03-20', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2052, 2, 4, '2026-03-20', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2053, 6, 1, '2026-03-19', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2054, 2, 1, '2026-03-19', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2055, 6, 2, '2026-03-19', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2056, 2, 2, '2026-03-19', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2057, 6, 4, '2026-03-19', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2058, 2, 4, '2026-03-19', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2059, 6, 1, '2026-03-18', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2060, 2, 1, '2026-03-18', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2061, 6, 2, '2026-03-18', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2062, 2, 2, '2026-03-18', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2063, 6, 4, '2026-03-18', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2064, 2, 4, '2026-03-18', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2065, 6, 1, '2026-03-17', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2066, 2, 1, '2026-03-17', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2067, 6, 2, '2026-03-17', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2068, 2, 2, '2026-03-17', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2069, 6, 4, '2026-03-17', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2070, 2, 4, '2026-03-17', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2071, 6, 1, '2026-03-16', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2072, 2, 1, '2026-03-16', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2073, 6, 2, '2026-03-16', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2074, 2, 2, '2026-03-16', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2075, 6, 4, '2026-03-16', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2076, 2, 4, '2026-03-16', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2077, 6, 1, '2026-03-13', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2078, 2, 1, '2026-03-13', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2079, 6, 2, '2026-03-13', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2080, 2, 2, '2026-03-13', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2081, 6, 4, '2026-03-13', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2082, 2, 4, '2026-03-13', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2083, 6, 1, '2026-03-12', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2084, 2, 1, '2026-03-12', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2085, 6, 2, '2026-03-12', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2086, 2, 2, '2026-03-12', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2087, 6, 4, '2026-03-12', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2088, 2, 4, '2026-03-12', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2089, 6, 1, '2026-03-11', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2090, 2, 1, '2026-03-11', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2091, 6, 2, '2026-03-11', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2092, 2, 2, '2026-03-11', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2093, 6, 4, '2026-03-11', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2094, 2, 4, '2026-03-11', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2095, 6, 1, '2026-03-10', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2096, 2, 1, '2026-03-10', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2097, 6, 2, '2026-03-10', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2098, 2, 2, '2026-03-10', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2099, 6, 4, '2026-03-10', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2100, 2, 4, '2026-03-10', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2101, 6, 1, '2026-03-09', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2102, 2, 1, '2026-03-09', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2103, 6, 2, '2026-03-09', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2104, 2, 2, '2026-03-09', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2105, 6, 4, '2026-03-09', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2106, 2, 4, '2026-03-09', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2107, 6, 1, '2026-03-06', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2108, 2, 1, '2026-03-06', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2109, 6, 2, '2026-03-06', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2110, 2, 2, '2026-03-06', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2111, 6, 4, '2026-03-06', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2112, 2, 4, '2026-03-06', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2113, 6, 1, '2026-03-05', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2114, 2, 1, '2026-03-05', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2115, 6, 2, '2026-03-05', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2116, 2, 2, '2026-03-05', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2117, 6, 4, '2026-03-05', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2118, 2, 4, '2026-03-05', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2119, 6, 1, '2026-03-04', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2120, 2, 1, '2026-03-04', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2121, 6, 2, '2026-03-04', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2122, 2, 2, '2026-03-04', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2123, 6, 4, '2026-03-04', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2124, 2, 4, '2026-03-04', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2125, 6, 1, '2026-03-03', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2126, 2, 1, '2026-03-03', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2127, 6, 2, '2026-03-03', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2128, 2, 2, '2026-03-03', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2129, 6, 4, '2026-03-03', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2130, 2, 4, '2026-03-03', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2131, 6, 1, '2026-03-02', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2132, 2, 1, '2026-03-02', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2133, 6, 2, '2026-03-02', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2134, 2, 2, '2026-03-02', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2135, 6, 4, '2026-03-02', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2136, 2, 4, '2026-03-02', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2137, 6, 1, '2026-02-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2138, 2, 1, '2026-02-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2139, 6, 2, '2026-02-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2140, 2, 2, '2026-02-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2141, 6, 4, '2026-02-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2142, 2, 4, '2026-02-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2143, 6, 1, '2026-02-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2144, 2, 1, '2026-02-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2145, 6, 2, '2026-02-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2146, 2, 2, '2026-02-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2147, 6, 4, '2026-02-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2148, 2, 4, '2026-02-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2149, 6, 1, '2026-02-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2150, 2, 1, '2026-02-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2151, 6, 2, '2026-02-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2152, 2, 2, '2026-02-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2153, 6, 4, '2026-02-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2154, 2, 4, '2026-02-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2155, 6, 1, '2026-02-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2156, 2, 1, '2026-02-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2157, 6, 2, '2026-02-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2158, 2, 2, '2026-02-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2159, 6, 4, '2026-02-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2160, 2, 4, '2026-02-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2161, 6, 1, '2026-03-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2162, 2, 1, '2026-03-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2163, 6, 2, '2026-03-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2164, 2, 2, '2026-03-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2165, 6, 4, '2026-03-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2166, 2, 4, '2026-03-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2167, 6, 1, '2026-03-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2168, 2, 1, '2026-03-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2169, 6, 2, '2026-03-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2170, 2, 2, '2026-03-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2171, 6, 4, '2026-03-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2172, 2, 4, '2026-03-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2173, 6, 1, '2026-03-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2174, 2, 1, '2026-03-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2175, 6, 2, '2026-03-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2176, 2, 2, '2026-03-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2177, 6, 4, '2026-03-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2178, 2, 4, '2026-03-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2179, 6, 1, '2026-03-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2180, 2, 1, '2026-03-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2181, 6, 2, '2026-03-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2182, 2, 2, '2026-03-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2183, 6, 4, '2026-03-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2184, 2, 4, '2026-03-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2185, 6, 1, '2026-03-23', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2186, 2, 1, '2026-03-23', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2187, 6, 2, '2026-03-23', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2188, 2, 2, '2026-03-23', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2189, 6, 4, '2026-03-23', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2190, 2, 4, '2026-03-23', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2191, 6, 1, '2026-03-20', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2192, 2, 1, '2026-03-20', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2193, 6, 2, '2026-03-20', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2194, 2, 2, '2026-03-20', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2195, 6, 4, '2026-03-20', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2196, 2, 4, '2026-03-20', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2197, 6, 1, '2026-03-19', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2198, 2, 1, '2026-03-19', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2199, 6, 2, '2026-03-19', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2200, 2, 2, '2026-03-19', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2201, 6, 4, '2026-03-19', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2202, 2, 4, '2026-03-19', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2203, 6, 1, '2026-03-18', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2204, 2, 1, '2026-03-18', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2205, 6, 2, '2026-03-18', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2206, 2, 2, '2026-03-18', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2207, 6, 4, '2026-03-18', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2208, 2, 4, '2026-03-18', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2209, 6, 1, '2026-03-17', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2210, 2, 1, '2026-03-17', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2211, 6, 2, '2026-03-17', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2212, 2, 2, '2026-03-17', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2213, 6, 4, '2026-03-17', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2214, 2, 4, '2026-03-17', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2215, 6, 1, '2026-03-16', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2216, 2, 1, '2026-03-16', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2217, 6, 2, '2026-03-16', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2218, 2, 2, '2026-03-16', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2219, 6, 4, '2026-03-16', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2220, 2, 4, '2026-03-16', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2221, 6, 1, '2026-03-13', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2222, 2, 1, '2026-03-13', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2223, 6, 2, '2026-03-13', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2224, 2, 2, '2026-03-13', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2225, 6, 4, '2026-03-13', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2226, 2, 4, '2026-03-13', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2227, 6, 1, '2026-03-12', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2228, 2, 1, '2026-03-12', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2229, 6, 2, '2026-03-12', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2230, 2, 2, '2026-03-12', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2231, 6, 4, '2026-03-12', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2232, 2, 4, '2026-03-12', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2233, 6, 1, '2026-03-11', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2234, 2, 1, '2026-03-11', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2235, 6, 2, '2026-03-11', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2236, 2, 2, '2026-03-11', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2237, 6, 4, '2026-03-11', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2238, 2, 4, '2026-03-11', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2239, 6, 1, '2026-03-10', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2240, 2, 1, '2026-03-10', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2241, 6, 2, '2026-03-10', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2242, 2, 2, '2026-03-10', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2243, 6, 4, '2026-03-10', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2244, 2, 4, '2026-03-10', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2245, 6, 1, '2026-03-09', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2246, 2, 1, '2026-03-09', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2247, 6, 2, '2026-03-09', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2248, 2, 2, '2026-03-09', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2249, 6, 4, '2026-03-09', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2250, 2, 4, '2026-03-09', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2251, 6, 1, '2026-03-06', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2252, 2, 1, '2026-03-06', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2253, 6, 2, '2026-03-06', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2254, 2, 2, '2026-03-06', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2255, 6, 4, '2026-03-06', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2256, 2, 4, '2026-03-06', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2257, 6, 1, '2026-03-05', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2258, 2, 1, '2026-03-05', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2259, 6, 2, '2026-03-05', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2260, 2, 2, '2026-03-05', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2261, 6, 4, '2026-03-05', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2262, 2, 4, '2026-03-05', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2263, 6, 1, '2026-03-04', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2264, 2, 1, '2026-03-04', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2265, 6, 2, '2026-03-04', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2266, 2, 2, '2026-03-04', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2267, 6, 4, '2026-03-04', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2268, 2, 4, '2026-03-04', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2269, 6, 1, '2026-03-03', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2270, 2, 1, '2026-03-03', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2271, 6, 2, '2026-03-03', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2272, 2, 2, '2026-03-03', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2273, 6, 4, '2026-03-03', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2274, 2, 4, '2026-03-03', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2275, 6, 1, '2026-03-02', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2276, 2, 1, '2026-03-02', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2277, 6, 2, '2026-03-02', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2278, 2, 2, '2026-03-02', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2279, 6, 4, '2026-03-02', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2280, 2, 4, '2026-03-02', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2281, 6, 1, '2026-02-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2282, 2, 1, '2026-02-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2283, 6, 2, '2026-02-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2284, 2, 2, '2026-02-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2285, 6, 4, '2026-02-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2286, 2, 4, '2026-02-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2287, 6, 1, '2026-02-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2288, 2, 1, '2026-02-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2289, 6, 2, '2026-02-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2290, 2, 2, '2026-02-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2291, 6, 4, '2026-02-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2292, 2, 4, '2026-02-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2293, 6, 1, '2026-02-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2294, 2, 1, '2026-02-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2295, 6, 2, '2026-02-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2296, 2, 2, '2026-02-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2297, 6, 4, '2026-02-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2298, 2, 4, '2026-02-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2299, 6, 1, '2026-02-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2300, 2, 1, '2026-02-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2301, 6, 2, '2026-02-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2302, 2, 2, '2026-02-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2303, 6, 4, '2026-02-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2304, 2, 4, '2026-02-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2305, 6, 1, '2026-03-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2306, 2, 1, '2026-03-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2307, 6, 2, '2026-03-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2308, 2, 2, '2026-03-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2309, 6, 4, '2026-03-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2310, 2, 4, '2026-03-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2311, 6, 1, '2026-03-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2312, 2, 1, '2026-03-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2313, 6, 2, '2026-03-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2314, 2, 2, '2026-03-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2315, 6, 4, '2026-03-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2316, 2, 4, '2026-03-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2317, 6, 1, '2026-03-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2318, 2, 1, '2026-03-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2319, 6, 2, '2026-03-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2320, 2, 2, '2026-03-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2321, 6, 4, '2026-03-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2322, 2, 4, '2026-03-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2323, 6, 1, '2026-03-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2324, 2, 1, '2026-03-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2325, 6, 2, '2026-03-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2326, 2, 2, '2026-03-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2327, 6, 4, '2026-03-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2328, 2, 4, '2026-03-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2329, 6, 1, '2026-03-23', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2330, 2, 1, '2026-03-23', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2331, 6, 2, '2026-03-23', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2332, 2, 2, '2026-03-23', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2333, 6, 4, '2026-03-23', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2334, 2, 4, '2026-03-23', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2335, 6, 1, '2026-03-20', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2336, 2, 1, '2026-03-20', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2337, 6, 2, '2026-03-20', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2338, 2, 2, '2026-03-20', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2339, 6, 4, '2026-03-20', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2340, 2, 4, '2026-03-20', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2341, 6, 1, '2026-03-19', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2342, 2, 1, '2026-03-19', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2343, 6, 2, '2026-03-19', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2344, 2, 2, '2026-03-19', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2345, 6, 4, '2026-03-19', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2346, 2, 4, '2026-03-19', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2347, 6, 1, '2026-03-18', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2348, 2, 1, '2026-03-18', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2349, 6, 2, '2026-03-18', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2350, 2, 2, '2026-03-18', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2351, 6, 4, '2026-03-18', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2352, 2, 4, '2026-03-18', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2353, 6, 1, '2026-03-17', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2354, 2, 1, '2026-03-17', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2355, 6, 2, '2026-03-17', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2356, 2, 2, '2026-03-17', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2357, 6, 4, '2026-03-17', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2358, 2, 4, '2026-03-17', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2359, 6, 1, '2026-03-16', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2360, 2, 1, '2026-03-16', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2361, 6, 2, '2026-03-16', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2362, 2, 2, '2026-03-16', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2363, 6, 4, '2026-03-16', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2364, 2, 4, '2026-03-16', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2365, 6, 1, '2026-03-13', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2366, 2, 1, '2026-03-13', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2367, 6, 2, '2026-03-13', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2368, 2, 2, '2026-03-13', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2369, 6, 4, '2026-03-13', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2370, 2, 4, '2026-03-13', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2371, 6, 1, '2026-03-12', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2372, 2, 1, '2026-03-12', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2373, 6, 2, '2026-03-12', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2374, 2, 2, '2026-03-12', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2375, 6, 4, '2026-03-12', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2376, 2, 4, '2026-03-12', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2377, 6, 1, '2026-03-11', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2378, 2, 1, '2026-03-11', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2379, 6, 2, '2026-03-11', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2380, 2, 2, '2026-03-11', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2381, 6, 4, '2026-03-11', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2382, 2, 4, '2026-03-11', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2383, 6, 1, '2026-03-10', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2384, 2, 1, '2026-03-10', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2385, 6, 2, '2026-03-10', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2386, 2, 2, '2026-03-10', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2387, 6, 4, '2026-03-10', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2388, 2, 4, '2026-03-10', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2389, 6, 1, '2026-03-09', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2390, 2, 1, '2026-03-09', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2391, 6, 2, '2026-03-09', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2392, 2, 2, '2026-03-09', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2393, 6, 4, '2026-03-09', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2394, 2, 4, '2026-03-09', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2395, 6, 1, '2026-03-06', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2396, 2, 1, '2026-03-06', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2397, 6, 2, '2026-03-06', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2398, 2, 2, '2026-03-06', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2399, 6, 4, '2026-03-06', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2400, 2, 4, '2026-03-06', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2401, 6, 1, '2026-03-05', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2402, 2, 1, '2026-03-05', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2403, 6, 2, '2026-03-05', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2404, 2, 2, '2026-03-05', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2405, 6, 4, '2026-03-05', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2406, 2, 4, '2026-03-05', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2407, 6, 1, '2026-03-04', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2408, 2, 1, '2026-03-04', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2409, 6, 2, '2026-03-04', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2410, 2, 2, '2026-03-04', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2411, 6, 4, '2026-03-04', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2412, 2, 4, '2026-03-04', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2413, 6, 1, '2026-03-03', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2414, 2, 1, '2026-03-03', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2415, 6, 2, '2026-03-03', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2416, 2, 2, '2026-03-03', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2417, 6, 4, '2026-03-03', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2418, 2, 4, '2026-03-03', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2419, 6, 1, '2026-03-02', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2420, 2, 1, '2026-03-02', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2421, 6, 2, '2026-03-02', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2422, 2, 2, '2026-03-02', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2423, 6, 4, '2026-03-02', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2424, 2, 4, '2026-03-02', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2425, 6, 1, '2026-02-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2426, 2, 1, '2026-02-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2427, 6, 2, '2026-02-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2428, 2, 2, '2026-02-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2429, 6, 4, '2026-02-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2430, 2, 4, '2026-02-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2431, 6, 1, '2026-02-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2432, 2, 1, '2026-02-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2433, 6, 2, '2026-02-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2434, 2, 2, '2026-02-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2435, 6, 4, '2026-02-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2436, 2, 4, '2026-02-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2437, 6, 1, '2026-02-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2438, 2, 1, '2026-02-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2439, 6, 2, '2026-02-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2440, 2, 2, '2026-02-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2441, 6, 4, '2026-02-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2442, 2, 4, '2026-02-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2443, 6, 1, '2026-02-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2444, 2, 1, '2026-02-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2445, 6, 2, '2026-02-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2446, 2, 2, '2026-02-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2447, 6, 4, '2026-02-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2448, 2, 4, '2026-02-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2449, 6, 1, '2026-03-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2450, 2, 1, '2026-03-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2451, 6, 2, '2026-03-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2452, 2, 2, '2026-03-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2453, 6, 4, '2026-03-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2454, 2, 4, '2026-03-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2455, 6, 1, '2026-03-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2456, 2, 1, '2026-03-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2457, 6, 2, '2026-03-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2458, 2, 2, '2026-03-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2459, 6, 4, '2026-03-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2460, 2, 4, '2026-03-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2461, 6, 1, '2026-03-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2462, 2, 1, '2026-03-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2463, 6, 2, '2026-03-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2464, 2, 2, '2026-03-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2465, 6, 4, '2026-03-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2466, 2, 4, '2026-03-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2467, 6, 1, '2026-03-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2468, 2, 1, '2026-03-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2469, 6, 2, '2026-03-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2470, 2, 2, '2026-03-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2471, 6, 4, '2026-03-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2472, 2, 4, '2026-03-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2473, 6, 1, '2026-03-23', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2474, 2, 1, '2026-03-23', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2475, 6, 2, '2026-03-23', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2476, 2, 2, '2026-03-23', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2477, 6, 4, '2026-03-23', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2478, 2, 4, '2026-03-23', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2479, 6, 1, '2026-03-20', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2480, 2, 1, '2026-03-20', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2481, 6, 2, '2026-03-20', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2482, 2, 2, '2026-03-20', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2483, 6, 4, '2026-03-20', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2484, 2, 4, '2026-03-20', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2485, 6, 1, '2026-03-19', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2486, 2, 1, '2026-03-19', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2487, 6, 2, '2026-03-19', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2488, 2, 2, '2026-03-19', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2489, 6, 4, '2026-03-19', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2490, 2, 4, '2026-03-19', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2491, 6, 1, '2026-03-18', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2492, 2, 1, '2026-03-18', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2493, 6, 2, '2026-03-18', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2494, 2, 2, '2026-03-18', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2495, 6, 4, '2026-03-18', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2496, 2, 4, '2026-03-18', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2497, 6, 1, '2026-03-17', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2498, 2, 1, '2026-03-17', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2499, 6, 2, '2026-03-17', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2500, 2, 2, '2026-03-17', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2501, 6, 4, '2026-03-17', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2502, 2, 4, '2026-03-17', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2503, 6, 1, '2026-03-16', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2504, 2, 1, '2026-03-16', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2505, 6, 2, '2026-03-16', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2506, 2, 2, '2026-03-16', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2507, 6, 4, '2026-03-16', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2508, 2, 4, '2026-03-16', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2509, 6, 1, '2026-03-13', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2510, 2, 1, '2026-03-13', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2511, 6, 2, '2026-03-13', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2512, 2, 2, '2026-03-13', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2513, 6, 4, '2026-03-13', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2514, 2, 4, '2026-03-13', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2515, 6, 1, '2026-03-12', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2516, 2, 1, '2026-03-12', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2517, 6, 2, '2026-03-12', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2518, 2, 2, '2026-03-12', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2519, 6, 4, '2026-03-12', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2520, 2, 4, '2026-03-12', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2521, 6, 1, '2026-03-11', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2522, 2, 1, '2026-03-11', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2523, 6, 2, '2026-03-11', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2524, 2, 2, '2026-03-11', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2525, 6, 4, '2026-03-11', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2526, 2, 4, '2026-03-11', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2527, 6, 1, '2026-03-10', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2528, 2, 1, '2026-03-10', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2529, 6, 2, '2026-03-10', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2530, 2, 2, '2026-03-10', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2531, 6, 4, '2026-03-10', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2532, 2, 4, '2026-03-10', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2533, 6, 1, '2026-03-09', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2534, 2, 1, '2026-03-09', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2535, 6, 2, '2026-03-09', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2536, 2, 2, '2026-03-09', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2537, 6, 4, '2026-03-09', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2538, 2, 4, '2026-03-09', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2539, 6, 1, '2026-03-06', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2540, 2, 1, '2026-03-06', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2541, 6, 2, '2026-03-06', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2542, 2, 2, '2026-03-06', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2543, 6, 4, '2026-03-06', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2544, 2, 4, '2026-03-06', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2545, 6, 1, '2026-03-05', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2546, 2, 1, '2026-03-05', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2547, 6, 2, '2026-03-05', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2548, 2, 2, '2026-03-05', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2549, 6, 4, '2026-03-05', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2550, 2, 4, '2026-03-05', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2551, 6, 1, '2026-03-04', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2552, 2, 1, '2026-03-04', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2553, 6, 2, '2026-03-04', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2554, 2, 2, '2026-03-04', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2555, 6, 4, '2026-03-04', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2556, 2, 4, '2026-03-04', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2557, 6, 1, '2026-03-03', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2558, 2, 1, '2026-03-03', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2559, 6, 2, '2026-03-03', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2560, 2, 2, '2026-03-03', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2561, 6, 4, '2026-03-03', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2562, 2, 4, '2026-03-03', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2563, 6, 1, '2026-03-02', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2564, 2, 1, '2026-03-02', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2565, 6, 2, '2026-03-02', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2566, 2, 2, '2026-03-02', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2567, 6, 4, '2026-03-02', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2568, 2, 4, '2026-03-02', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2569, 6, 1, '2026-02-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2570, 2, 1, '2026-02-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2571, 6, 2, '2026-02-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2572, 2, 2, '2026-02-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2573, 6, 4, '2026-02-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2574, 2, 4, '2026-02-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2575, 6, 1, '2026-02-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2576, 2, 1, '2026-02-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2577, 6, 2, '2026-02-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2578, 2, 2, '2026-02-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2579, 6, 4, '2026-02-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2580, 2, 4, '2026-02-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2581, 6, 1, '2026-02-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2582, 2, 1, '2026-02-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2583, 6, 2, '2026-02-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2584, 2, 2, '2026-02-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2585, 6, 4, '2026-02-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2586, 2, 4, '2026-02-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2587, 6, 1, '2026-02-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2588, 2, 1, '2026-02-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2589, 6, 2, '2026-02-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2590, 2, 2, '2026-02-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2591, 6, 4, '2026-02-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2592, 2, 4, '2026-02-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2593, 6, 1, '2026-03-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2594, 2, 1, '2026-03-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2595, 6, 2, '2026-03-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2596, 2, 2, '2026-03-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2597, 6, 4, '2026-03-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2598, 2, 4, '2026-03-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2599, 6, 1, '2026-03-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2600, 2, 1, '2026-03-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2601, 6, 2, '2026-03-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2602, 2, 2, '2026-03-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2603, 6, 4, '2026-03-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2604, 2, 4, '2026-03-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2605, 6, 1, '2026-03-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2606, 2, 1, '2026-03-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2607, 6, 2, '2026-03-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2608, 2, 2, '2026-03-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2609, 6, 4, '2026-03-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2610, 2, 4, '2026-03-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2611, 6, 1, '2026-03-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2612, 2, 1, '2026-03-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2613, 6, 2, '2026-03-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2614, 2, 2, '2026-03-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2615, 6, 4, '2026-03-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2616, 2, 4, '2026-03-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2617, 6, 1, '2026-03-23', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2618, 2, 1, '2026-03-23', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2619, 6, 2, '2026-03-23', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2620, 2, 2, '2026-03-23', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2621, 6, 4, '2026-03-23', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2622, 2, 4, '2026-03-23', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2623, 6, 1, '2026-03-20', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2624, 2, 1, '2026-03-20', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2625, 6, 2, '2026-03-20', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2626, 2, 2, '2026-03-20', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2627, 6, 4, '2026-03-20', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2628, 2, 4, '2026-03-20', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2629, 6, 1, '2026-03-19', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2630, 2, 1, '2026-03-19', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2631, 6, 2, '2026-03-19', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2632, 2, 2, '2026-03-19', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2633, 6, 4, '2026-03-19', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2634, 2, 4, '2026-03-19', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2635, 6, 1, '2026-03-18', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2636, 2, 1, '2026-03-18', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2637, 6, 2, '2026-03-18', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2638, 2, 2, '2026-03-18', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2639, 6, 4, '2026-03-18', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2640, 2, 4, '2026-03-18', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2641, 6, 1, '2026-03-17', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2642, 2, 1, '2026-03-17', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2643, 6, 2, '2026-03-17', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2644, 2, 2, '2026-03-17', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2645, 6, 4, '2026-03-17', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2646, 2, 4, '2026-03-17', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2647, 6, 1, '2026-03-16', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2648, 2, 1, '2026-03-16', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2649, 6, 2, '2026-03-16', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2650, 2, 2, '2026-03-16', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2651, 6, 4, '2026-03-16', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2652, 2, 4, '2026-03-16', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2653, 6, 1, '2026-03-13', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2654, 2, 1, '2026-03-13', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2655, 6, 2, '2026-03-13', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2656, 2, 2, '2026-03-13', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2657, 6, 4, '2026-03-13', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2658, 2, 4, '2026-03-13', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2659, 6, 1, '2026-03-12', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2660, 2, 1, '2026-03-12', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2661, 6, 2, '2026-03-12', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2662, 2, 2, '2026-03-12', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2663, 6, 4, '2026-03-12', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2664, 2, 4, '2026-03-12', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2665, 6, 1, '2026-03-11', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2666, 2, 1, '2026-03-11', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2667, 6, 2, '2026-03-11', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2668, 2, 2, '2026-03-11', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2669, 6, 4, '2026-03-11', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2670, 2, 4, '2026-03-11', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2671, 6, 1, '2026-03-10', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2672, 2, 1, '2026-03-10', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2673, 6, 2, '2026-03-10', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2674, 2, 2, '2026-03-10', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2675, 6, 4, '2026-03-10', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2676, 2, 4, '2026-03-10', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2677, 6, 1, '2026-03-09', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2678, 2, 1, '2026-03-09', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2679, 6, 2, '2026-03-09', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2680, 2, 2, '2026-03-09', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2681, 6, 4, '2026-03-09', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2682, 2, 4, '2026-03-09', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2683, 6, 1, '2026-03-06', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2684, 2, 1, '2026-03-06', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2685, 6, 2, '2026-03-06', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2686, 2, 2, '2026-03-06', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2687, 6, 4, '2026-03-06', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2688, 2, 4, '2026-03-06', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2689, 6, 1, '2026-03-05', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2690, 2, 1, '2026-03-05', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2691, 6, 2, '2026-03-05', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2692, 2, 2, '2026-03-05', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2693, 6, 4, '2026-03-05', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2694, 2, 4, '2026-03-05', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2695, 6, 1, '2026-03-04', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2696, 2, 1, '2026-03-04', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2697, 6, 2, '2026-03-04', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2698, 2, 2, '2026-03-04', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2699, 6, 4, '2026-03-04', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2700, 2, 4, '2026-03-04', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2701, 6, 1, '2026-03-03', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2702, 2, 1, '2026-03-03', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2703, 6, 2, '2026-03-03', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2704, 2, 2, '2026-03-03', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2705, 6, 4, '2026-03-03', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2706, 2, 4, '2026-03-03', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2707, 6, 1, '2026-03-02', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2708, 2, 1, '2026-03-02', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2709, 6, 2, '2026-03-02', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2710, 2, 2, '2026-03-02', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2711, 6, 4, '2026-03-02', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2712, 2, 4, '2026-03-02', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2713, 6, 1, '2026-02-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2714, 2, 1, '2026-02-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2715, 6, 2, '2026-02-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2716, 2, 2, '2026-02-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2717, 6, 4, '2026-02-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2718, 2, 4, '2026-02-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2719, 6, 1, '2026-02-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2720, 2, 1, '2026-02-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2721, 6, 2, '2026-02-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2722, 2, 2, '2026-02-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2723, 6, 4, '2026-02-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2724, 2, 4, '2026-02-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2725, 6, 1, '2026-02-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2726, 2, 1, '2026-02-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2727, 6, 2, '2026-02-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2728, 2, 2, '2026-02-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2729, 6, 4, '2026-02-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2730, 2, 4, '2026-02-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2731, 6, 1, '2026-02-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2732, 2, 1, '2026-02-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2733, 6, 2, '2026-02-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2734, 2, 2, '2026-02-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2735, 6, 4, '2026-02-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2736, 2, 4, '2026-02-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2737, 6, 1, '2026-03-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2738, 2, 1, '2026-03-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2739, 6, 2, '2026-03-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2740, 2, 2, '2026-03-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2741, 6, 4, '2026-03-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2742, 2, 4, '2026-03-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2743, 6, 1, '2026-03-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2744, 2, 1, '2026-03-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2745, 6, 2, '2026-03-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2746, 2, 2, '2026-03-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2747, 6, 4, '2026-03-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2748, 2, 4, '2026-03-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2749, 6, 1, '2026-03-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2750, 2, 1, '2026-03-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2751, 6, 2, '2026-03-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2752, 2, 2, '2026-03-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2753, 6, 4, '2026-03-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2754, 2, 4, '2026-03-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2755, 6, 1, '2026-03-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2756, 2, 1, '2026-03-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2757, 6, 2, '2026-03-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2758, 2, 2, '2026-03-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2759, 6, 4, '2026-03-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2760, 2, 4, '2026-03-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2761, 6, 1, '2026-03-23', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2762, 2, 1, '2026-03-23', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2763, 6, 2, '2026-03-23', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2764, 2, 2, '2026-03-23', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2765, 6, 4, '2026-03-23', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2766, 2, 4, '2026-03-23', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2767, 6, 1, '2026-03-20', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2768, 2, 1, '2026-03-20', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2769, 6, 2, '2026-03-20', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2770, 2, 2, '2026-03-20', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2771, 6, 4, '2026-03-20', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2772, 2, 4, '2026-03-20', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2773, 6, 1, '2026-03-19', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2774, 2, 1, '2026-03-19', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2775, 6, 2, '2026-03-19', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2776, 2, 2, '2026-03-19', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2777, 6, 4, '2026-03-19', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2778, 2, 4, '2026-03-19', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2779, 6, 1, '2026-03-18', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2780, 2, 1, '2026-03-18', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2781, 6, 2, '2026-03-18', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2782, 2, 2, '2026-03-18', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2783, 6, 4, '2026-03-18', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2784, 2, 4, '2026-03-18', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2785, 6, 1, '2026-03-17', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2786, 2, 1, '2026-03-17', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2787, 6, 2, '2026-03-17', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2788, 2, 2, '2026-03-17', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2789, 6, 4, '2026-03-17', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2790, 2, 4, '2026-03-17', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2791, 6, 1, '2026-03-16', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2792, 2, 1, '2026-03-16', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2793, 6, 2, '2026-03-16', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2794, 2, 2, '2026-03-16', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2795, 6, 4, '2026-03-16', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2796, 2, 4, '2026-03-16', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2797, 6, 1, '2026-03-13', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2798, 2, 1, '2026-03-13', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2799, 6, 2, '2026-03-13', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2800, 2, 2, '2026-03-13', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2801, 6, 4, '2026-03-13', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2802, 2, 4, '2026-03-13', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2803, 6, 1, '2026-03-12', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2804, 2, 1, '2026-03-12', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2805, 6, 2, '2026-03-12', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2806, 2, 2, '2026-03-12', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2807, 6, 4, '2026-03-12', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2808, 2, 4, '2026-03-12', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2809, 6, 1, '2026-03-11', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2810, 2, 1, '2026-03-11', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2811, 6, 2, '2026-03-11', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2812, 2, 2, '2026-03-11', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2813, 6, 4, '2026-03-11', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2814, 2, 4, '2026-03-11', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2815, 6, 1, '2026-03-10', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2816, 2, 1, '2026-03-10', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2817, 6, 2, '2026-03-10', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2818, 2, 2, '2026-03-10', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2819, 6, 4, '2026-03-10', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2820, 2, 4, '2026-03-10', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2821, 6, 1, '2026-03-09', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2822, 2, 1, '2026-03-09', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2823, 6, 2, '2026-03-09', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2824, 2, 2, '2026-03-09', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2825, 6, 4, '2026-03-09', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2826, 2, 4, '2026-03-09', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2827, 6, 1, '2026-03-06', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2828, 2, 1, '2026-03-06', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2829, 6, 2, '2026-03-06', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2830, 2, 2, '2026-03-06', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2831, 6, 4, '2026-03-06', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2832, 2, 4, '2026-03-06', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2833, 6, 1, '2026-03-05', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2834, 2, 1, '2026-03-05', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2835, 6, 2, '2026-03-05', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2836, 2, 2, '2026-03-05', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2837, 6, 4, '2026-03-05', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2838, 2, 4, '2026-03-05', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2839, 6, 1, '2026-03-04', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2840, 2, 1, '2026-03-04', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2841, 6, 2, '2026-03-04', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2842, 2, 2, '2026-03-04', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2843, 6, 4, '2026-03-04', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2844, 2, 4, '2026-03-04', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2845, 6, 1, '2026-03-03', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2846, 2, 1, '2026-03-03', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2847, 6, 2, '2026-03-03', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2848, 2, 2, '2026-03-03', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2849, 6, 4, '2026-03-03', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2850, 2, 4, '2026-03-03', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2851, 6, 1, '2026-03-02', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2852, 2, 1, '2026-03-02', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2853, 6, 2, '2026-03-02', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2854, 2, 2, '2026-03-02', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2855, 6, 4, '2026-03-02', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2856, 2, 4, '2026-03-02', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2857, 6, 1, '2026-02-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2858, 2, 1, '2026-02-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2859, 6, 2, '2026-02-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2860, 2, 2, '2026-02-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2861, 6, 4, '2026-02-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2862, 2, 4, '2026-02-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2863, 6, 1, '2026-02-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2864, 2, 1, '2026-02-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2865, 6, 2, '2026-02-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2866, 2, 2, '2026-02-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2867, 6, 4, '2026-02-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2868, 2, 4, '2026-02-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2869, 6, 1, '2026-02-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2870, 2, 1, '2026-02-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2871, 6, 2, '2026-02-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2872, 2, 2, '2026-02-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2873, 6, 4, '2026-02-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2874, 2, 4, '2026-02-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2875, 6, 1, '2026-02-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2876, 2, 1, '2026-02-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2877, 6, 2, '2026-02-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2878, 2, 2, '2026-02-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2879, 6, 4, '2026-02-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2880, 2, 4, '2026-02-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2881, 6, 1, '2026-03-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2882, 2, 1, '2026-03-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2883, 6, 2, '2026-03-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2884, 2, 2, '2026-03-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2885, 6, 4, '2026-03-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2886, 2, 4, '2026-03-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2887, 6, 1, '2026-03-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2888, 2, 1, '2026-03-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2889, 6, 2, '2026-03-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2890, 2, 2, '2026-03-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2891, 6, 4, '2026-03-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2892, 2, 4, '2026-03-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2893, 6, 1, '2026-03-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2894, 2, 1, '2026-03-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2895, 6, 2, '2026-03-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2896, 2, 2, '2026-03-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2897, 6, 4, '2026-03-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2898, 2, 4, '2026-03-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2899, 6, 1, '2026-03-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2900, 2, 1, '2026-03-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2901, 6, 2, '2026-03-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2902, 2, 2, '2026-03-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2903, 6, 4, '2026-03-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2904, 2, 4, '2026-03-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2905, 6, 1, '2026-03-23', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2906, 2, 1, '2026-03-23', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2907, 6, 2, '2026-03-23', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2908, 2, 2, '2026-03-23', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2909, 6, 4, '2026-03-23', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2910, 2, 4, '2026-03-23', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2911, 6, 1, '2026-03-20', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2912, 2, 1, '2026-03-20', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2913, 6, 2, '2026-03-20', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2914, 2, 2, '2026-03-20', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2915, 6, 4, '2026-03-20', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2916, 2, 4, '2026-03-20', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2917, 6, 1, '2026-03-19', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2918, 2, 1, '2026-03-19', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2919, 6, 2, '2026-03-19', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2920, 2, 2, '2026-03-19', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2921, 6, 4, '2026-03-19', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2922, 2, 4, '2026-03-19', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2923, 6, 1, '2026-03-18', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2924, 2, 1, '2026-03-18', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2925, 6, 2, '2026-03-18', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2926, 2, 2, '2026-03-18', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2927, 6, 4, '2026-03-18', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2928, 2, 4, '2026-03-18', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2929, 6, 1, '2026-03-17', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2930, 2, 1, '2026-03-17', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2931, 6, 2, '2026-03-17', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2932, 2, 2, '2026-03-17', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2933, 6, 4, '2026-03-17', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2934, 2, 4, '2026-03-17', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2935, 6, 1, '2026-03-16', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2936, 2, 1, '2026-03-16', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2937, 6, 2, '2026-03-16', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2938, 2, 2, '2026-03-16', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2939, 6, 4, '2026-03-16', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2940, 2, 4, '2026-03-16', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2941, 6, 1, '2026-03-13', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2942, 2, 1, '2026-03-13', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2943, 6, 2, '2026-03-13', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2944, 2, 2, '2026-03-13', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2945, 6, 4, '2026-03-13', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2946, 2, 4, '2026-03-13', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2947, 6, 1, '2026-03-12', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2948, 2, 1, '2026-03-12', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2949, 6, 2, '2026-03-12', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2950, 2, 2, '2026-03-12', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2951, 6, 4, '2026-03-12', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2952, 2, 4, '2026-03-12', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2953, 6, 1, '2026-03-11', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2954, 2, 1, '2026-03-11', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2955, 6, 2, '2026-03-11', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2956, 2, 2, '2026-03-11', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2957, 6, 4, '2026-03-11', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2958, 2, 4, '2026-03-11', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2959, 6, 1, '2026-03-10', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2960, 2, 1, '2026-03-10', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2961, 6, 2, '2026-03-10', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2962, 2, 2, '2026-03-10', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2963, 6, 4, '2026-03-10', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2964, 2, 4, '2026-03-10', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2965, 6, 1, '2026-03-09', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2966, 2, 1, '2026-03-09', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2967, 6, 2, '2026-03-09', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2968, 2, 2, '2026-03-09', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2969, 6, 4, '2026-03-09', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2970, 2, 4, '2026-03-09', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2971, 6, 1, '2026-03-06', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2972, 2, 1, '2026-03-06', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2973, 6, 2, '2026-03-06', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2974, 2, 2, '2026-03-06', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2975, 6, 4, '2026-03-06', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2976, 2, 4, '2026-03-06', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2977, 6, 1, '2026-03-05', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2978, 2, 1, '2026-03-05', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2979, 6, 2, '2026-03-05', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2980, 2, 2, '2026-03-05', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2981, 6, 4, '2026-03-05', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2982, 2, 4, '2026-03-05', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2983, 6, 1, '2026-03-04', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2984, 2, 1, '2026-03-04', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2985, 6, 2, '2026-03-04', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2986, 2, 2, '2026-03-04', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2987, 6, 4, '2026-03-04', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2988, 2, 4, '2026-03-04', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2989, 6, 1, '2026-03-03', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2990, 2, 1, '2026-03-03', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2991, 6, 2, '2026-03-03', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2992, 2, 2, '2026-03-03', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2993, 6, 4, '2026-03-03', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2994, 2, 4, '2026-03-03', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2995, 6, 1, '2026-03-02', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2996, 2, 1, '2026-03-02', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2997, 6, 2, '2026-03-02', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2998, 2, 2, '2026-03-02', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2999, 6, 4, '2026-03-02', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3000, 2, 4, '2026-03-02', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3001, 6, 1, '2026-02-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3002, 2, 1, '2026-02-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3003, 6, 2, '2026-02-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3004, 2, 2, '2026-02-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3005, 6, 4, '2026-02-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3006, 2, 4, '2026-02-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3007, 6, 1, '2026-02-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3008, 2, 1, '2026-02-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3009, 6, 2, '2026-02-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3010, 2, 2, '2026-02-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3011, 6, 4, '2026-02-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3012, 2, 4, '2026-02-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3013, 6, 1, '2026-02-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3014, 2, 1, '2026-02-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3015, 6, 2, '2026-02-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3016, 2, 2, '2026-02-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3017, 6, 4, '2026-02-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3018, 2, 4, '2026-02-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3019, 6, 1, '2026-02-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3020, 2, 1, '2026-02-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3021, 6, 2, '2026-02-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3022, 2, 2, '2026-02-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3023, 6, 4, '2026-02-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3024, 2, 4, '2026-02-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3025, 6, 1, '2026-03-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3026, 2, 1, '2026-03-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3027, 6, 2, '2026-03-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3028, 2, 2, '2026-03-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3029, 6, 4, '2026-03-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3030, 2, 4, '2026-03-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3031, 6, 1, '2026-03-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3032, 2, 1, '2026-03-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3033, 6, 2, '2026-03-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3034, 2, 2, '2026-03-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3035, 6, 4, '2026-03-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3036, 2, 4, '2026-03-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3037, 6, 1, '2026-03-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3038, 2, 1, '2026-03-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3039, 6, 2, '2026-03-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3040, 2, 2, '2026-03-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3041, 6, 4, '2026-03-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3042, 2, 4, '2026-03-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3043, 6, 1, '2026-03-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3044, 2, 1, '2026-03-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3045, 6, 2, '2026-03-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3046, 2, 2, '2026-03-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3047, 6, 4, '2026-03-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3048, 2, 4, '2026-03-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3049, 6, 1, '2026-03-23', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3050, 2, 1, '2026-03-23', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3051, 6, 2, '2026-03-23', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3052, 2, 2, '2026-03-23', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3053, 6, 4, '2026-03-23', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3054, 2, 4, '2026-03-23', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3055, 6, 1, '2026-03-20', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3056, 2, 1, '2026-03-20', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3057, 6, 2, '2026-03-20', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3058, 2, 2, '2026-03-20', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3059, 6, 4, '2026-03-20', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3060, 2, 4, '2026-03-20', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3061, 6, 1, '2026-03-19', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3062, 2, 1, '2026-03-19', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3063, 6, 2, '2026-03-19', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3064, 2, 2, '2026-03-19', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3065, 6, 4, '2026-03-19', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3066, 2, 4, '2026-03-19', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3067, 6, 1, '2026-03-18', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3068, 2, 1, '2026-03-18', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3069, 6, 2, '2026-03-18', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3070, 2, 2, '2026-03-18', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3071, 6, 4, '2026-03-18', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3072, 2, 4, '2026-03-18', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3073, 6, 1, '2026-03-17', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3074, 2, 1, '2026-03-17', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3075, 6, 2, '2026-03-17', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3076, 2, 2, '2026-03-17', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3077, 6, 4, '2026-03-17', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3078, 2, 4, '2026-03-17', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3079, 6, 1, '2026-03-16', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3080, 2, 1, '2026-03-16', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3081, 6, 2, '2026-03-16', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3082, 2, 2, '2026-03-16', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3083, 6, 4, '2026-03-16', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3084, 2, 4, '2026-03-16', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3085, 6, 1, '2026-03-13', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3086, 2, 1, '2026-03-13', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3087, 6, 2, '2026-03-13', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3088, 2, 2, '2026-03-13', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3089, 6, 4, '2026-03-13', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3090, 2, 4, '2026-03-13', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3091, 6, 1, '2026-03-12', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3092, 2, 1, '2026-03-12', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3093, 6, 2, '2026-03-12', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3094, 2, 2, '2026-03-12', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3095, 6, 4, '2026-03-12', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3096, 2, 4, '2026-03-12', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3097, 6, 1, '2026-03-11', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3098, 2, 1, '2026-03-11', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3099, 6, 2, '2026-03-11', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3100, 2, 2, '2026-03-11', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3101, 6, 4, '2026-03-11', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3102, 2, 4, '2026-03-11', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3103, 6, 1, '2026-03-10', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3104, 2, 1, '2026-03-10', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3105, 6, 2, '2026-03-10', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3106, 2, 2, '2026-03-10', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3107, 6, 4, '2026-03-10', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3108, 2, 4, '2026-03-10', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3109, 6, 1, '2026-03-09', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3110, 2, 1, '2026-03-09', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3111, 6, 2, '2026-03-09', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3112, 2, 2, '2026-03-09', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3113, 6, 4, '2026-03-09', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3114, 2, 4, '2026-03-09', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3115, 6, 1, '2026-03-06', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3116, 2, 1, '2026-03-06', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3117, 6, 2, '2026-03-06', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3118, 2, 2, '2026-03-06', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3119, 6, 4, '2026-03-06', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3120, 2, 4, '2026-03-06', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3121, 6, 1, '2026-03-05', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3122, 2, 1, '2026-03-05', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3123, 6, 2, '2026-03-05', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3124, 2, 2, '2026-03-05', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3125, 6, 4, '2026-03-05', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3126, 2, 4, '2026-03-05', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3127, 6, 1, '2026-03-04', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3128, 2, 1, '2026-03-04', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3129, 6, 2, '2026-03-04', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3130, 2, 2, '2026-03-04', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3131, 6, 4, '2026-03-04', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3132, 2, 4, '2026-03-04', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3133, 6, 1, '2026-03-03', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3134, 2, 1, '2026-03-03', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3135, 6, 2, '2026-03-03', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3136, 2, 2, '2026-03-03', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3137, 6, 4, '2026-03-03', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3138, 2, 4, '2026-03-03', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3139, 6, 1, '2026-03-02', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3140, 2, 1, '2026-03-02', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3141, 6, 2, '2026-03-02', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3142, 2, 2, '2026-03-02', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3143, 6, 4, '2026-03-02', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3144, 2, 4, '2026-03-02', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3145, 6, 1, '2026-02-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3146, 2, 1, '2026-02-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3147, 6, 2, '2026-02-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3148, 2, 2, '2026-02-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3149, 6, 4, '2026-02-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3150, 2, 4, '2026-02-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3151, 6, 1, '2026-02-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3152, 2, 1, '2026-02-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3153, 6, 2, '2026-02-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3154, 2, 2, '2026-02-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3155, 6, 4, '2026-02-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3156, 2, 4, '2026-02-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3157, 6, 1, '2026-02-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3158, 2, 1, '2026-02-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3159, 6, 2, '2026-02-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3160, 2, 2, '2026-02-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3161, 6, 4, '2026-02-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3162, 2, 4, '2026-02-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3163, 6, 1, '2026-02-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3164, 2, 1, '2026-02-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3165, 6, 2, '2026-02-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3166, 2, 2, '2026-02-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3167, 6, 4, '2026-02-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3168, 2, 4, '2026-02-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3169, 6, 1, '2026-03-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3170, 2, 1, '2026-03-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3171, 6, 2, '2026-03-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3172, 2, 2, '2026-03-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3173, 6, 4, '2026-03-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3174, 2, 4, '2026-03-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3175, 6, 1, '2026-03-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3176, 2, 1, '2026-03-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3177, 6, 2, '2026-03-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3178, 2, 2, '2026-03-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3179, 6, 4, '2026-03-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3180, 2, 4, '2026-03-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3181, 6, 1, '2026-03-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3182, 2, 1, '2026-03-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3183, 6, 2, '2026-03-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3184, 2, 2, '2026-03-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3185, 6, 4, '2026-03-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3186, 2, 4, '2026-03-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3187, 6, 1, '2026-03-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3188, 2, 1, '2026-03-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3189, 6, 2, '2026-03-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3190, 2, 2, '2026-03-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3191, 6, 4, '2026-03-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3192, 2, 4, '2026-03-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3193, 6, 1, '2026-03-23', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3194, 2, 1, '2026-03-23', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3195, 6, 2, '2026-03-23', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3196, 2, 2, '2026-03-23', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3197, 6, 4, '2026-03-23', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3198, 2, 4, '2026-03-23', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3199, 6, 1, '2026-03-20', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3200, 2, 1, '2026-03-20', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3201, 6, 2, '2026-03-20', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3202, 2, 2, '2026-03-20', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3203, 6, 4, '2026-03-20', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3204, 2, 4, '2026-03-20', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3205, 6, 1, '2026-03-19', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3206, 2, 1, '2026-03-19', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3207, 6, 2, '2026-03-19', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3208, 2, 2, '2026-03-19', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3209, 6, 4, '2026-03-19', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3210, 2, 4, '2026-03-19', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3211, 6, 1, '2026-03-18', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3212, 2, 1, '2026-03-18', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3213, 6, 2, '2026-03-18', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3214, 2, 2, '2026-03-18', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3215, 6, 4, '2026-03-18', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3216, 2, 4, '2026-03-18', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3217, 6, 1, '2026-03-17', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3218, 2, 1, '2026-03-17', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3219, 6, 2, '2026-03-17', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3220, 2, 2, '2026-03-17', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3221, 6, 4, '2026-03-17', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3222, 2, 4, '2026-03-17', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3223, 6, 1, '2026-03-16', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3224, 2, 1, '2026-03-16', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3225, 6, 2, '2026-03-16', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3226, 2, 2, '2026-03-16', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3227, 6, 4, '2026-03-16', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3228, 2, 4, '2026-03-16', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3229, 6, 1, '2026-03-13', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3230, 2, 1, '2026-03-13', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3231, 6, 2, '2026-03-13', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3232, 2, 2, '2026-03-13', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3233, 6, 4, '2026-03-13', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3234, 2, 4, '2026-03-13', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3235, 6, 1, '2026-03-12', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3236, 2, 1, '2026-03-12', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3237, 6, 2, '2026-03-12', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3238, 2, 2, '2026-03-12', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3239, 6, 4, '2026-03-12', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3240, 2, 4, '2026-03-12', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3241, 6, 1, '2026-03-11', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3242, 2, 1, '2026-03-11', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3243, 6, 2, '2026-03-11', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3244, 2, 2, '2026-03-11', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3245, 6, 4, '2026-03-11', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3246, 2, 4, '2026-03-11', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3247, 6, 1, '2026-03-10', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3248, 2, 1, '2026-03-10', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3249, 6, 2, '2026-03-10', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3250, 2, 2, '2026-03-10', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3251, 6, 4, '2026-03-10', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3252, 2, 4, '2026-03-10', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3253, 6, 1, '2026-03-09', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3254, 2, 1, '2026-03-09', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3255, 6, 2, '2026-03-09', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3256, 2, 2, '2026-03-09', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3257, 6, 4, '2026-03-09', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3258, 2, 4, '2026-03-09', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3259, 6, 1, '2026-03-06', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3260, 2, 1, '2026-03-06', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3261, 6, 2, '2026-03-06', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3262, 2, 2, '2026-03-06', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3263, 6, 4, '2026-03-06', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3264, 2, 4, '2026-03-06', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3265, 6, 1, '2026-03-05', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3266, 2, 1, '2026-03-05', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3267, 6, 2, '2026-03-05', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3268, 2, 2, '2026-03-05', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3269, 6, 4, '2026-03-05', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3270, 2, 4, '2026-03-05', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3271, 6, 1, '2026-03-04', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3272, 2, 1, '2026-03-04', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3273, 6, 2, '2026-03-04', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3274, 2, 2, '2026-03-04', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3275, 6, 4, '2026-03-04', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3276, 2, 4, '2026-03-04', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3277, 6, 1, '2026-03-03', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3278, 2, 1, '2026-03-03', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3279, 6, 2, '2026-03-03', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3280, 2, 2, '2026-03-03', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3281, 6, 4, '2026-03-03', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3282, 2, 4, '2026-03-03', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3283, 6, 1, '2026-03-02', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3284, 2, 1, '2026-03-02', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3285, 6, 2, '2026-03-02', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3286, 2, 2, '2026-03-02', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3287, 6, 4, '2026-03-02', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3288, 2, 4, '2026-03-02', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3289, 6, 1, '2026-02-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3290, 2, 1, '2026-02-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3291, 6, 2, '2026-02-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3292, 2, 2, '2026-02-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3293, 6, 4, '2026-02-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3294, 2, 4, '2026-02-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3295, 6, 1, '2026-02-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3296, 2, 1, '2026-02-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3297, 6, 2, '2026-02-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3298, 2, 2, '2026-02-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3299, 6, 4, '2026-02-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3300, 2, 4, '2026-02-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3301, 6, 1, '2026-02-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3302, 2, 1, '2026-02-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3303, 6, 2, '2026-02-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3304, 2, 2, '2026-02-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3305, 6, 4, '2026-02-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3306, 2, 4, '2026-02-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3307, 6, 1, '2026-02-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3308, 2, 1, '2026-02-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3309, 6, 2, '2026-02-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3310, 2, 2, '2026-02-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3311, 6, 4, '2026-02-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3312, 2, 4, '2026-02-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3313, 6, 1, '2026-03-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3314, 2, 1, '2026-03-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3315, 6, 2, '2026-03-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3316, 2, 2, '2026-03-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3317, 6, 4, '2026-03-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3318, 2, 4, '2026-03-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3319, 6, 1, '2026-03-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3320, 2, 1, '2026-03-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3321, 6, 2, '2026-03-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3322, 2, 2, '2026-03-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3323, 6, 4, '2026-03-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3324, 2, 4, '2026-03-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3325, 6, 1, '2026-03-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3326, 2, 1, '2026-03-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3327, 6, 2, '2026-03-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3328, 2, 2, '2026-03-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3329, 6, 4, '2026-03-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3330, 2, 4, '2026-03-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3331, 6, 1, '2026-03-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3332, 2, 1, '2026-03-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3333, 6, 2, '2026-03-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3334, 2, 2, '2026-03-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3335, 6, 4, '2026-03-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3336, 2, 4, '2026-03-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3337, 6, 1, '2026-03-23', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3338, 2, 1, '2026-03-23', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3339, 6, 2, '2026-03-23', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3340, 2, 2, '2026-03-23', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3341, 6, 4, '2026-03-23', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3342, 2, 4, '2026-03-23', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3343, 6, 1, '2026-03-20', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3344, 2, 1, '2026-03-20', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3345, 6, 2, '2026-03-20', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3346, 2, 2, '2026-03-20', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3347, 6, 4, '2026-03-20', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3348, 2, 4, '2026-03-20', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3349, 6, 1, '2026-03-19', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3350, 2, 1, '2026-03-19', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3351, 6, 2, '2026-03-19', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3352, 2, 2, '2026-03-19', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3353, 6, 4, '2026-03-19', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3354, 2, 4, '2026-03-19', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3355, 6, 1, '2026-03-18', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3356, 2, 1, '2026-03-18', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3357, 6, 2, '2026-03-18', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3358, 2, 2, '2026-03-18', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3359, 6, 4, '2026-03-18', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3360, 2, 4, '2026-03-18', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3361, 6, 1, '2026-03-17', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3362, 2, 1, '2026-03-17', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3363, 6, 2, '2026-03-17', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3364, 2, 2, '2026-03-17', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3365, 6, 4, '2026-03-17', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3366, 2, 4, '2026-03-17', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3367, 6, 1, '2026-03-16', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3368, 2, 1, '2026-03-16', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3369, 6, 2, '2026-03-16', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3370, 2, 2, '2026-03-16', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3371, 6, 4, '2026-03-16', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3372, 2, 4, '2026-03-16', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3373, 6, 1, '2026-03-13', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3374, 2, 1, '2026-03-13', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3375, 6, 2, '2026-03-13', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3376, 2, 2, '2026-03-13', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3377, 6, 4, '2026-03-13', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3378, 2, 4, '2026-03-13', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3379, 6, 1, '2026-03-12', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3380, 2, 1, '2026-03-12', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3381, 6, 2, '2026-03-12', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3382, 2, 2, '2026-03-12', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3383, 6, 4, '2026-03-12', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3384, 2, 4, '2026-03-12', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3385, 6, 1, '2026-03-11', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3386, 2, 1, '2026-03-11', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3387, 6, 2, '2026-03-11', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3388, 2, 2, '2026-03-11', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3389, 6, 4, '2026-03-11', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3390, 2, 4, '2026-03-11', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3391, 6, 1, '2026-03-10', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3392, 2, 1, '2026-03-10', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3393, 6, 2, '2026-03-10', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3394, 2, 2, '2026-03-10', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3395, 6, 4, '2026-03-10', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3396, 2, 4, '2026-03-10', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3397, 6, 1, '2026-03-09', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3398, 2, 1, '2026-03-09', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3399, 6, 2, '2026-03-09', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3400, 2, 2, '2026-03-09', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3401, 6, 4, '2026-03-09', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3402, 2, 4, '2026-03-09', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3403, 6, 1, '2026-03-06', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3404, 2, 1, '2026-03-06', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3405, 6, 2, '2026-03-06', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3406, 2, 2, '2026-03-06', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3407, 6, 4, '2026-03-06', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3408, 2, 4, '2026-03-06', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3409, 6, 1, '2026-03-05', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3410, 2, 1, '2026-03-05', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3411, 6, 2, '2026-03-05', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3412, 2, 2, '2026-03-05', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3413, 6, 4, '2026-03-05', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3414, 2, 4, '2026-03-05', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3415, 6, 1, '2026-03-04', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3416, 2, 1, '2026-03-04', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3417, 6, 2, '2026-03-04', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3418, 2, 2, '2026-03-04', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3419, 6, 4, '2026-03-04', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3420, 2, 4, '2026-03-04', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3421, 6, 1, '2026-03-03', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3422, 2, 1, '2026-03-03', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3423, 6, 2, '2026-03-03', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3424, 2, 2, '2026-03-03', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3425, 6, 4, '2026-03-03', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3426, 2, 4, '2026-03-03', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3427, 6, 1, '2026-03-02', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3428, 2, 1, '2026-03-02', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3429, 6, 2, '2026-03-02', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3430, 2, 2, '2026-03-02', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3431, 6, 4, '2026-03-02', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3432, 2, 4, '2026-03-02', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3433, 6, 1, '2026-02-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3434, 2, 1, '2026-02-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3435, 6, 2, '2026-02-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3436, 2, 2, '2026-02-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3437, 6, 4, '2026-02-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3438, 2, 4, '2026-02-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3439, 6, 1, '2026-02-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3440, 2, 1, '2026-02-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3441, 6, 2, '2026-02-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3442, 2, 2, '2026-02-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3443, 6, 4, '2026-02-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3444, 2, 4, '2026-02-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3445, 6, 1, '2026-02-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3446, 2, 1, '2026-02-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3447, 6, 2, '2026-02-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3448, 2, 2, '2026-02-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3449, 6, 4, '2026-02-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3450, 2, 4, '2026-02-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3451, 6, 1, '2026-02-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3452, 2, 1, '2026-02-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3453, 6, 2, '2026-02-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3454, 2, 2, '2026-02-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3455, 6, 4, '2026-02-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3456, 2, 4, '2026-02-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3457, 6, 1, '2026-03-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3458, 2, 1, '2026-03-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3459, 6, 2, '2026-03-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3460, 2, 2, '2026-03-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3461, 6, 4, '2026-03-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3462, 2, 4, '2026-03-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3463, 6, 1, '2026-03-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3464, 2, 1, '2026-03-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3465, 6, 2, '2026-03-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3466, 2, 2, '2026-03-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3467, 6, 4, '2026-03-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3468, 2, 4, '2026-03-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3469, 6, 1, '2026-03-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3470, 2, 1, '2026-03-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3471, 6, 2, '2026-03-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3472, 2, 2, '2026-03-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3473, 6, 4, '2026-03-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3474, 2, 4, '2026-03-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3475, 6, 1, '2026-03-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3476, 2, 1, '2026-03-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3477, 6, 2, '2026-03-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3478, 2, 2, '2026-03-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3479, 6, 4, '2026-03-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3480, 2, 4, '2026-03-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3481, 6, 1, '2026-03-23', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3482, 2, 1, '2026-03-23', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3483, 6, 2, '2026-03-23', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3484, 2, 2, '2026-03-23', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3485, 6, 4, '2026-03-23', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3486, 2, 4, '2026-03-23', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3487, 6, 1, '2026-03-20', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3488, 2, 1, '2026-03-20', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3489, 6, 2, '2026-03-20', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3490, 2, 2, '2026-03-20', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3491, 6, 4, '2026-03-20', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3492, 2, 4, '2026-03-20', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3493, 6, 1, '2026-03-19', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3494, 2, 1, '2026-03-19', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3495, 6, 2, '2026-03-19', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3496, 2, 2, '2026-03-19', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3497, 6, 4, '2026-03-19', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3498, 2, 4, '2026-03-19', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3499, 6, 1, '2026-03-18', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3500, 2, 1, '2026-03-18', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3501, 6, 2, '2026-03-18', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3502, 2, 2, '2026-03-18', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3503, 6, 4, '2026-03-18', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3504, 2, 4, '2026-03-18', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3505, 6, 1, '2026-03-17', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3506, 2, 1, '2026-03-17', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3507, 6, 2, '2026-03-17', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3508, 2, 2, '2026-03-17', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3509, 6, 4, '2026-03-17', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3510, 2, 4, '2026-03-17', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3511, 6, 1, '2026-03-16', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3512, 2, 1, '2026-03-16', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3513, 6, 2, '2026-03-16', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3514, 2, 2, '2026-03-16', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3515, 6, 4, '2026-03-16', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3516, 2, 4, '2026-03-16', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3517, 6, 1, '2026-03-13', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3518, 2, 1, '2026-03-13', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3519, 6, 2, '2026-03-13', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3520, 2, 2, '2026-03-13', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3521, 6, 4, '2026-03-13', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3522, 2, 4, '2026-03-13', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3523, 6, 1, '2026-03-12', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3524, 2, 1, '2026-03-12', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3525, 6, 2, '2026-03-12', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3526, 2, 2, '2026-03-12', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3527, 6, 4, '2026-03-12', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3528, 2, 4, '2026-03-12', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3529, 6, 1, '2026-03-11', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3530, 2, 1, '2026-03-11', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3531, 6, 2, '2026-03-11', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3532, 2, 2, '2026-03-11', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3533, 6, 4, '2026-03-11', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3534, 2, 4, '2026-03-11', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3535, 6, 1, '2026-03-10', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3536, 2, 1, '2026-03-10', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3537, 6, 2, '2026-03-10', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3538, 2, 2, '2026-03-10', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3539, 6, 4, '2026-03-10', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3540, 2, 4, '2026-03-10', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3541, 6, 1, '2026-03-09', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3542, 2, 1, '2026-03-09', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3543, 6, 2, '2026-03-09', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3544, 2, 2, '2026-03-09', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3545, 6, 4, '2026-03-09', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3546, 2, 4, '2026-03-09', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3547, 6, 1, '2026-03-06', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3548, 2, 1, '2026-03-06', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3549, 6, 2, '2026-03-06', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3550, 2, 2, '2026-03-06', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3551, 6, 4, '2026-03-06', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3552, 2, 4, '2026-03-06', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3553, 6, 1, '2026-03-05', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3554, 2, 1, '2026-03-05', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3555, 6, 2, '2026-03-05', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3556, 2, 2, '2026-03-05', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3557, 6, 4, '2026-03-05', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3558, 2, 4, '2026-03-05', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3559, 6, 1, '2026-03-04', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3560, 2, 1, '2026-03-04', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3561, 6, 2, '2026-03-04', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3562, 2, 2, '2026-03-04', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3563, 6, 4, '2026-03-04', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3564, 2, 4, '2026-03-04', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3565, 6, 1, '2026-03-03', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3566, 2, 1, '2026-03-03', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3567, 6, 2, '2026-03-03', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3568, 2, 2, '2026-03-03', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3569, 6, 4, '2026-03-03', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3570, 2, 4, '2026-03-03', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3571, 6, 1, '2026-03-02', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3572, 2, 1, '2026-03-02', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3573, 6, 2, '2026-03-02', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3574, 2, 2, '2026-03-02', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3575, 6, 4, '2026-03-02', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3576, 2, 4, '2026-03-02', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3577, 6, 1, '2026-02-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3578, 2, 1, '2026-02-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3579, 6, 2, '2026-02-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3580, 2, 2, '2026-02-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3581, 6, 4, '2026-02-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3582, 2, 4, '2026-02-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3583, 6, 1, '2026-02-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3584, 2, 1, '2026-02-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3585, 6, 2, '2026-02-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3586, 2, 2, '2026-02-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3587, 6, 4, '2026-02-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3588, 2, 4, '2026-02-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3589, 6, 1, '2026-02-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3590, 2, 1, '2026-02-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3591, 6, 2, '2026-02-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3592, 2, 2, '2026-02-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3593, 6, 4, '2026-02-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3594, 2, 4, '2026-02-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3595, 6, 1, '2026-02-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3596, 2, 1, '2026-02-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3597, 6, 2, '2026-02-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3598, 2, 2, '2026-02-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3599, 6, 4, '2026-02-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3600, 2, 4, '2026-02-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3601, 6, 1, '2026-03-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3602, 2, 1, '2026-03-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3603, 6, 2, '2026-03-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3604, 2, 2, '2026-03-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3605, 6, 4, '2026-03-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3606, 2, 4, '2026-03-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3607, 6, 1, '2026-03-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3608, 2, 1, '2026-03-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3609, 6, 2, '2026-03-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3610, 2, 2, '2026-03-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3611, 6, 4, '2026-03-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3612, 2, 4, '2026-03-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3613, 6, 1, '2026-03-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3614, 2, 1, '2026-03-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3615, 6, 2, '2026-03-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3616, 2, 2, '2026-03-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3617, 6, 4, '2026-03-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3618, 2, 4, '2026-03-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3619, 6, 1, '2026-03-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3620, 2, 1, '2026-03-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3621, 6, 2, '2026-03-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3622, 2, 2, '2026-03-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3623, 6, 4, '2026-03-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3624, 2, 4, '2026-03-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3625, 6, 1, '2026-03-23', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3626, 2, 1, '2026-03-23', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3627, 6, 2, '2026-03-23', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3628, 2, 2, '2026-03-23', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3629, 6, 4, '2026-03-23', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3630, 2, 4, '2026-03-23', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3631, 6, 1, '2026-03-20', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3632, 2, 1, '2026-03-20', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3633, 6, 2, '2026-03-20', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3634, 2, 2, '2026-03-20', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3635, 6, 4, '2026-03-20', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3636, 2, 4, '2026-03-20', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3637, 6, 1, '2026-03-19', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3638, 2, 1, '2026-03-19', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3639, 6, 2, '2026-03-19', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3640, 2, 2, '2026-03-19', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3641, 6, 4, '2026-03-19', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3642, 2, 4, '2026-03-19', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3643, 6, 1, '2026-03-18', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3644, 2, 1, '2026-03-18', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3645, 6, 2, '2026-03-18', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3646, 2, 2, '2026-03-18', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3647, 6, 4, '2026-03-18', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3648, 2, 4, '2026-03-18', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3649, 6, 1, '2026-03-17', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3650, 2, 1, '2026-03-17', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3651, 6, 2, '2026-03-17', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3652, 2, 2, '2026-03-17', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3653, 6, 4, '2026-03-17', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3654, 2, 4, '2026-03-17', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3655, 6, 1, '2026-03-16', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3656, 2, 1, '2026-03-16', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3657, 6, 2, '2026-03-16', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3658, 2, 2, '2026-03-16', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3659, 6, 4, '2026-03-16', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3660, 2, 4, '2026-03-16', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3661, 6, 1, '2026-03-13', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3662, 2, 1, '2026-03-13', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3663, 6, 2, '2026-03-13', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3664, 2, 2, '2026-03-13', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3665, 6, 4, '2026-03-13', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3666, 2, 4, '2026-03-13', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3667, 6, 1, '2026-03-12', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3668, 2, 1, '2026-03-12', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3669, 6, 2, '2026-03-12', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3670, 2, 2, '2026-03-12', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3671, 6, 4, '2026-03-12', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3672, 2, 4, '2026-03-12', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3673, 6, 1, '2026-03-11', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3674, 2, 1, '2026-03-11', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3675, 6, 2, '2026-03-11', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3676, 2, 2, '2026-03-11', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3677, 6, 4, '2026-03-11', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3678, 2, 4, '2026-03-11', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3679, 6, 1, '2026-03-10', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3680, 2, 1, '2026-03-10', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3681, 6, 2, '2026-03-10', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3682, 2, 2, '2026-03-10', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3683, 6, 4, '2026-03-10', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3684, 2, 4, '2026-03-10', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3685, 6, 1, '2026-03-09', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3686, 2, 1, '2026-03-09', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3687, 6, 2, '2026-03-09', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3688, 2, 2, '2026-03-09', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3689, 6, 4, '2026-03-09', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3690, 2, 4, '2026-03-09', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3691, 6, 1, '2026-03-06', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3692, 2, 1, '2026-03-06', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3693, 6, 2, '2026-03-06', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3694, 2, 2, '2026-03-06', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3695, 6, 4, '2026-03-06', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3696, 2, 4, '2026-03-06', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3697, 6, 1, '2026-03-05', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3698, 2, 1, '2026-03-05', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3699, 6, 2, '2026-03-05', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3700, 2, 2, '2026-03-05', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3701, 6, 4, '2026-03-05', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3702, 2, 4, '2026-03-05', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3703, 6, 1, '2026-03-04', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3704, 2, 1, '2026-03-04', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3705, 6, 2, '2026-03-04', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3706, 2, 2, '2026-03-04', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3707, 6, 4, '2026-03-04', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3708, 2, 4, '2026-03-04', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3709, 6, 1, '2026-03-03', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3710, 2, 1, '2026-03-03', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3711, 6, 2, '2026-03-03', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3712, 2, 2, '2026-03-03', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3713, 6, 4, '2026-03-03', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3714, 2, 4, '2026-03-03', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3715, 6, 1, '2026-03-02', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3716, 2, 1, '2026-03-02', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3717, 6, 2, '2026-03-02', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3718, 2, 2, '2026-03-02', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3719, 6, 4, '2026-03-02', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3720, 2, 4, '2026-03-02', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3721, 6, 1, '2026-02-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3722, 2, 1, '2026-02-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3723, 6, 2, '2026-02-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3724, 2, 2, '2026-02-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3725, 6, 4, '2026-02-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3726, 2, 4, '2026-02-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3727, 6, 1, '2026-02-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3728, 2, 1, '2026-02-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3729, 6, 2, '2026-02-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3730, 2, 2, '2026-02-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3731, 6, 4, '2026-02-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3732, 2, 4, '2026-02-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3733, 6, 1, '2026-02-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3734, 2, 1, '2026-02-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3735, 6, 2, '2026-02-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3736, 2, 2, '2026-02-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3737, 6, 4, '2026-02-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3738, 2, 4, '2026-02-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3739, 6, 1, '2026-02-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3740, 2, 1, '2026-02-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3741, 6, 2, '2026-02-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3742, 2, 2, '2026-02-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3743, 6, 4, '2026-02-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3744, 2, 4, '2026-02-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3745, 6, 1, '2026-03-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3746, 2, 1, '2026-03-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3747, 6, 2, '2026-03-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3748, 2, 2, '2026-03-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3749, 6, 4, '2026-03-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3750, 2, 4, '2026-03-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3751, 6, 1, '2026-03-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3752, 2, 1, '2026-03-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3753, 6, 2, '2026-03-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3754, 2, 2, '2026-03-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3755, 6, 4, '2026-03-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3756, 2, 4, '2026-03-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3757, 6, 1, '2026-03-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3758, 2, 1, '2026-03-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3759, 6, 2, '2026-03-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3760, 2, 2, '2026-03-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3761, 6, 4, '2026-03-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3762, 2, 4, '2026-03-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3763, 6, 1, '2026-03-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3764, 2, 1, '2026-03-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3765, 6, 2, '2026-03-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3766, 2, 2, '2026-03-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3767, 6, 4, '2026-03-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3768, 2, 4, '2026-03-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3769, 6, 1, '2026-03-23', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3770, 2, 1, '2026-03-23', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3771, 6, 2, '2026-03-23', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3772, 2, 2, '2026-03-23', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3773, 6, 4, '2026-03-23', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3774, 2, 4, '2026-03-23', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3775, 6, 1, '2026-03-20', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3776, 2, 1, '2026-03-20', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3777, 6, 2, '2026-03-20', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3778, 2, 2, '2026-03-20', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3779, 6, 4, '2026-03-20', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3780, 2, 4, '2026-03-20', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3781, 6, 1, '2026-03-19', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3782, 2, 1, '2026-03-19', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3783, 6, 2, '2026-03-19', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3784, 2, 2, '2026-03-19', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3785, 6, 4, '2026-03-19', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3786, 2, 4, '2026-03-19', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3787, 6, 1, '2026-03-18', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3788, 2, 1, '2026-03-18', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3789, 6, 2, '2026-03-18', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3790, 2, 2, '2026-03-18', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3791, 6, 4, '2026-03-18', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3792, 2, 4, '2026-03-18', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3793, 6, 1, '2026-03-17', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3794, 2, 1, '2026-03-17', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3795, 6, 2, '2026-03-17', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3796, 2, 2, '2026-03-17', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3797, 6, 4, '2026-03-17', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3798, 2, 4, '2026-03-17', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3799, 6, 1, '2026-03-16', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3800, 2, 1, '2026-03-16', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3801, 6, 2, '2026-03-16', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3802, 2, 2, '2026-03-16', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3803, 6, 4, '2026-03-16', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3804, 2, 4, '2026-03-16', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3805, 6, 1, '2026-03-13', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3806, 2, 1, '2026-03-13', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3807, 6, 2, '2026-03-13', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3808, 2, 2, '2026-03-13', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3809, 6, 4, '2026-03-13', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3810, 2, 4, '2026-03-13', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3811, 6, 1, '2026-03-12', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3812, 2, 1, '2026-03-12', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3813, 6, 2, '2026-03-12', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3814, 2, 2, '2026-03-12', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3815, 6, 4, '2026-03-12', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3816, 2, 4, '2026-03-12', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3817, 6, 1, '2026-03-11', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3818, 2, 1, '2026-03-11', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3819, 6, 2, '2026-03-11', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3820, 2, 2, '2026-03-11', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3821, 6, 4, '2026-03-11', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3822, 2, 4, '2026-03-11', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3823, 6, 1, '2026-03-10', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3824, 2, 1, '2026-03-10', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3825, 6, 2, '2026-03-10', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3826, 2, 2, '2026-03-10', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3827, 6, 4, '2026-03-10', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3828, 2, 4, '2026-03-10', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3829, 6, 1, '2026-03-09', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3830, 2, 1, '2026-03-09', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3831, 6, 2, '2026-03-09', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3832, 2, 2, '2026-03-09', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3833, 6, 4, '2026-03-09', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3834, 2, 4, '2026-03-09', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3835, 6, 1, '2026-03-06', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3836, 2, 1, '2026-03-06', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3837, 6, 2, '2026-03-06', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3838, 2, 2, '2026-03-06', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3839, 6, 4, '2026-03-06', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3840, 2, 4, '2026-03-06', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3841, 6, 1, '2026-03-05', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3842, 2, 1, '2026-03-05', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3843, 6, 2, '2026-03-05', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3844, 2, 2, '2026-03-05', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3845, 6, 4, '2026-03-05', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3846, 2, 4, '2026-03-05', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3847, 6, 1, '2026-03-04', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3848, 2, 1, '2026-03-04', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3849, 6, 2, '2026-03-04', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3850, 2, 2, '2026-03-04', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3851, 6, 4, '2026-03-04', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3852, 2, 4, '2026-03-04', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3853, 6, 1, '2026-03-03', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3854, 2, 1, '2026-03-03', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3855, 6, 2, '2026-03-03', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3856, 2, 2, '2026-03-03', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3857, 6, 4, '2026-03-03', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3858, 2, 4, '2026-03-03', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3859, 6, 1, '2026-03-02', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3860, 2, 1, '2026-03-02', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3861, 6, 2, '2026-03-02', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3862, 2, 2, '2026-03-02', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3863, 6, 4, '2026-03-02', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3864, 2, 4, '2026-03-02', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3865, 6, 1, '2026-02-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3866, 2, 1, '2026-02-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3867, 6, 2, '2026-02-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3868, 2, 2, '2026-02-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3869, 6, 4, '2026-02-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3870, 2, 4, '2026-02-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3871, 6, 1, '2026-02-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3872, 2, 1, '2026-02-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3873, 6, 2, '2026-02-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3874, 2, 2, '2026-02-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3875, 6, 4, '2026-02-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3876, 2, 4, '2026-02-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3877, 6, 1, '2026-02-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3878, 2, 1, '2026-02-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3879, 6, 2, '2026-02-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3880, 2, 2, '2026-02-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3881, 6, 4, '2026-02-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3882, 2, 4, '2026-02-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3883, 6, 1, '2026-02-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3884, 2, 1, '2026-02-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3885, 6, 2, '2026-02-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3886, 2, 2, '2026-02-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3887, 6, 4, '2026-02-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3888, 2, 4, '2026-02-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3889, 6, 1, '2026-03-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3890, 2, 1, '2026-03-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3891, 6, 2, '2026-03-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3892, 2, 2, '2026-03-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3893, 6, 4, '2026-03-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3894, 2, 4, '2026-03-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3895, 6, 1, '2026-03-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3896, 2, 1, '2026-03-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3897, 6, 2, '2026-03-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3898, 2, 2, '2026-03-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3899, 6, 4, '2026-03-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3900, 2, 4, '2026-03-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3901, 6, 1, '2026-03-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3902, 2, 1, '2026-03-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3903, 6, 2, '2026-03-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3904, 2, 2, '2026-03-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3905, 6, 4, '2026-03-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3906, 2, 4, '2026-03-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3907, 6, 1, '2026-03-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3908, 2, 1, '2026-03-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3909, 6, 2, '2026-03-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3910, 2, 2, '2026-03-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3911, 6, 4, '2026-03-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3912, 2, 4, '2026-03-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3913, 6, 1, '2026-03-23', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3914, 2, 1, '2026-03-23', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3915, 6, 2, '2026-03-23', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3916, 2, 2, '2026-03-23', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3917, 6, 4, '2026-03-23', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3918, 2, 4, '2026-03-23', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3919, 6, 1, '2026-03-20', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3920, 2, 1, '2026-03-20', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3921, 6, 2, '2026-03-20', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3922, 2, 2, '2026-03-20', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3923, 6, 4, '2026-03-20', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3924, 2, 4, '2026-03-20', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3925, 6, 1, '2026-03-19', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3926, 2, 1, '2026-03-19', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3927, 6, 2, '2026-03-19', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3928, 2, 2, '2026-03-19', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3929, 6, 4, '2026-03-19', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3930, 2, 4, '2026-03-19', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3931, 6, 1, '2026-03-18', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3932, 2, 1, '2026-03-18', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3933, 6, 2, '2026-03-18', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3934, 2, 2, '2026-03-18', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3935, 6, 4, '2026-03-18', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3936, 2, 4, '2026-03-18', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3937, 6, 1, '2026-03-17', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3938, 2, 1, '2026-03-17', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3939, 6, 2, '2026-03-17', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3940, 2, 2, '2026-03-17', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3941, 6, 4, '2026-03-17', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3942, 2, 4, '2026-03-17', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3943, 6, 1, '2026-03-16', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3944, 2, 1, '2026-03-16', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3945, 6, 2, '2026-03-16', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3946, 2, 2, '2026-03-16', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3947, 6, 4, '2026-03-16', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3948, 2, 4, '2026-03-16', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3949, 6, 1, '2026-03-13', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3950, 2, 1, '2026-03-13', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3951, 6, 2, '2026-03-13', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3952, 2, 2, '2026-03-13', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3953, 6, 4, '2026-03-13', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3954, 2, 4, '2026-03-13', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3955, 6, 1, '2026-03-12', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3956, 2, 1, '2026-03-12', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3957, 6, 2, '2026-03-12', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3958, 2, 2, '2026-03-12', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3959, 6, 4, '2026-03-12', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3960, 2, 4, '2026-03-12', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3961, 6, 1, '2026-03-11', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3962, 2, 1, '2026-03-11', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3963, 6, 2, '2026-03-11', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3964, 2, 2, '2026-03-11', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3965, 6, 4, '2026-03-11', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3966, 2, 4, '2026-03-11', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3967, 6, 1, '2026-03-10', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3968, 2, 1, '2026-03-10', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3969, 6, 2, '2026-03-10', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3970, 2, 2, '2026-03-10', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3971, 6, 4, '2026-03-10', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3972, 2, 4, '2026-03-10', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3973, 6, 1, '2026-03-09', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3974, 2, 1, '2026-03-09', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3975, 6, 2, '2026-03-09', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3976, 2, 2, '2026-03-09', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3977, 6, 4, '2026-03-09', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3978, 2, 4, '2026-03-09', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3979, 6, 1, '2026-03-06', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3980, 2, 1, '2026-03-06', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3981, 6, 2, '2026-03-06', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3982, 2, 2, '2026-03-06', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3983, 6, 4, '2026-03-06', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3984, 2, 4, '2026-03-06', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3985, 6, 1, '2026-03-05', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3986, 2, 1, '2026-03-05', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3987, 6, 2, '2026-03-05', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3988, 2, 2, '2026-03-05', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3989, 6, 4, '2026-03-05', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3990, 2, 4, '2026-03-05', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3991, 6, 1, '2026-03-04', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3992, 2, 1, '2026-03-04', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3993, 6, 2, '2026-03-04', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3994, 2, 2, '2026-03-04', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3995, 6, 4, '2026-03-04', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3996, 2, 4, '2026-03-04', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3997, 6, 1, '2026-03-03', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3998, 2, 1, '2026-03-03', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3999, 6, 2, '2026-03-03', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4000, 2, 2, '2026-03-03', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4001, 6, 4, '2026-03-03', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4002, 2, 4, '2026-03-03', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4003, 6, 1, '2026-03-02', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4004, 2, 1, '2026-03-02', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4005, 6, 2, '2026-03-02', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4006, 2, 2, '2026-03-02', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4007, 6, 4, '2026-03-02', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4008, 2, 4, '2026-03-02', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4009, 6, 1, '2026-02-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4010, 2, 1, '2026-02-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4011, 6, 2, '2026-02-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4012, 2, 2, '2026-02-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4013, 6, 4, '2026-02-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4014, 2, 4, '2026-02-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4015, 6, 1, '2026-02-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4016, 2, 1, '2026-02-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4017, 6, 2, '2026-02-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4018, 2, 2, '2026-02-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4019, 6, 4, '2026-02-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4020, 2, 4, '2026-02-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4021, 6, 1, '2026-02-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4022, 2, 1, '2026-02-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4023, 6, 2, '2026-02-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4024, 2, 2, '2026-02-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4025, 6, 4, '2026-02-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4026, 2, 4, '2026-02-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4027, 6, 1, '2026-02-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4028, 2, 1, '2026-02-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4029, 6, 2, '2026-02-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4030, 2, 2, '2026-02-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4031, 6, 4, '2026-02-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4032, 2, 4, '2026-02-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4033, 6, 1, '2026-03-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4034, 2, 1, '2026-03-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4035, 6, 2, '2026-03-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4036, 2, 2, '2026-03-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4037, 6, 4, '2026-03-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4038, 2, 4, '2026-03-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4039, 6, 1, '2026-03-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4040, 2, 1, '2026-03-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4041, 6, 2, '2026-03-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4042, 2, 2, '2026-03-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4043, 6, 4, '2026-03-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4044, 2, 4, '2026-03-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4045, 6, 1, '2026-03-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4046, 2, 1, '2026-03-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4047, 6, 2, '2026-03-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4048, 2, 2, '2026-03-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4049, 6, 4, '2026-03-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4050, 2, 4, '2026-03-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4051, 6, 1, '2026-03-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4052, 2, 1, '2026-03-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4053, 6, 2, '2026-03-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4054, 2, 2, '2026-03-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4055, 6, 4, '2026-03-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4056, 2, 4, '2026-03-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4057, 6, 1, '2026-03-23', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4058, 2, 1, '2026-03-23', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4059, 6, 2, '2026-03-23', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4060, 2, 2, '2026-03-23', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4061, 6, 4, '2026-03-23', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4062, 2, 4, '2026-03-23', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4063, 6, 1, '2026-03-20', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4064, 2, 1, '2026-03-20', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4065, 6, 2, '2026-03-20', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4066, 2, 2, '2026-03-20', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4067, 6, 4, '2026-03-20', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4068, 2, 4, '2026-03-20', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4069, 6, 1, '2026-03-19', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4070, 2, 1, '2026-03-19', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4071, 6, 2, '2026-03-19', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4072, 2, 2, '2026-03-19', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4073, 6, 4, '2026-03-19', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4074, 2, 4, '2026-03-19', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4075, 6, 1, '2026-03-18', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4076, 2, 1, '2026-03-18', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4077, 6, 2, '2026-03-18', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4078, 2, 2, '2026-03-18', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4079, 6, 4, '2026-03-18', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4080, 2, 4, '2026-03-18', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4081, 6, 1, '2026-03-17', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4082, 2, 1, '2026-03-17', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4083, 6, 2, '2026-03-17', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4084, 2, 2, '2026-03-17', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4085, 6, 4, '2026-03-17', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4086, 2, 4, '2026-03-17', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4087, 6, 1, '2026-03-16', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4088, 2, 1, '2026-03-16', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4089, 6, 2, '2026-03-16', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4090, 2, 2, '2026-03-16', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4091, 6, 4, '2026-03-16', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4092, 2, 4, '2026-03-16', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4093, 6, 1, '2026-03-13', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4094, 2, 1, '2026-03-13', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4095, 6, 2, '2026-03-13', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4096, 2, 2, '2026-03-13', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4097, 6, 4, '2026-03-13', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4098, 2, 4, '2026-03-13', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4099, 6, 1, '2026-03-12', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4100, 2, 1, '2026-03-12', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4101, 6, 2, '2026-03-12', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4102, 2, 2, '2026-03-12', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4103, 6, 4, '2026-03-12', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4104, 2, 4, '2026-03-12', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4105, 6, 1, '2026-03-11', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4106, 2, 1, '2026-03-11', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4107, 6, 2, '2026-03-11', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4108, 2, 2, '2026-03-11', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4109, 6, 4, '2026-03-11', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4110, 2, 4, '2026-03-11', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4111, 6, 1, '2026-03-10', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4112, 2, 1, '2026-03-10', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4113, 6, 2, '2026-03-10', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4114, 2, 2, '2026-03-10', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4115, 6, 4, '2026-03-10', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4116, 2, 4, '2026-03-10', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4117, 6, 1, '2026-03-09', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4118, 2, 1, '2026-03-09', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4119, 6, 2, '2026-03-09', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4120, 2, 2, '2026-03-09', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4121, 6, 4, '2026-03-09', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4122, 2, 4, '2026-03-09', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4123, 6, 1, '2026-03-06', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4124, 2, 1, '2026-03-06', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4125, 6, 2, '2026-03-06', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4126, 2, 2, '2026-03-06', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4127, 6, 4, '2026-03-06', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4128, 2, 4, '2026-03-06', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4129, 6, 1, '2026-03-05', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4130, 2, 1, '2026-03-05', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4131, 6, 2, '2026-03-05', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4132, 2, 2, '2026-03-05', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4133, 6, 4, '2026-03-05', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4134, 2, 4, '2026-03-05', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4135, 6, 1, '2026-03-04', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4136, 2, 1, '2026-03-04', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4137, 6, 2, '2026-03-04', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4138, 2, 2, '2026-03-04', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4139, 6, 4, '2026-03-04', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4140, 2, 4, '2026-03-04', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4141, 6, 1, '2026-03-03', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4142, 2, 1, '2026-03-03', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4143, 6, 2, '2026-03-03', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4144, 2, 2, '2026-03-03', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4145, 6, 4, '2026-03-03', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4146, 2, 4, '2026-03-03', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4147, 6, 1, '2026-03-02', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4148, 2, 1, '2026-03-02', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4149, 6, 2, '2026-03-02', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4150, 2, 2, '2026-03-02', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4151, 6, 4, '2026-03-02', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4152, 2, 4, '2026-03-02', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4153, 6, 1, '2026-02-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4154, 2, 1, '2026-02-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4155, 6, 2, '2026-02-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4156, 2, 2, '2026-02-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4157, 6, 4, '2026-02-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4158, 2, 4, '2026-02-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4159, 6, 1, '2026-02-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4160, 2, 1, '2026-02-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4161, 6, 2, '2026-02-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4162, 2, 2, '2026-02-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4163, 6, 4, '2026-02-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4164, 2, 4, '2026-02-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4165, 6, 1, '2026-02-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4166, 2, 1, '2026-02-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4167, 6, 2, '2026-02-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4168, 2, 2, '2026-02-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4169, 6, 4, '2026-02-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4170, 2, 4, '2026-02-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4171, 6, 1, '2026-02-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4172, 2, 1, '2026-02-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4173, 6, 2, '2026-02-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4174, 2, 2, '2026-02-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4175, 6, 4, '2026-02-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4176, 2, 4, '2026-02-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4177, 6, 1, '2026-03-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4178, 2, 1, '2026-03-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4179, 6, 2, '2026-03-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4180, 2, 2, '2026-03-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4181, 6, 4, '2026-03-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4182, 2, 4, '2026-03-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4183, 6, 1, '2026-03-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4184, 2, 1, '2026-03-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4185, 6, 2, '2026-03-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4186, 2, 2, '2026-03-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4187, 6, 4, '2026-03-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4188, 2, 4, '2026-03-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4189, 6, 1, '2026-03-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4190, 2, 1, '2026-03-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4191, 6, 2, '2026-03-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4192, 2, 2, '2026-03-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4193, 6, 4, '2026-03-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4194, 2, 4, '2026-03-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4195, 6, 1, '2026-03-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4196, 2, 1, '2026-03-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4197, 6, 2, '2026-03-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4198, 2, 2, '2026-03-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4199, 6, 4, '2026-03-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4200, 2, 4, '2026-03-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4201, 6, 1, '2026-03-23', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4202, 2, 1, '2026-03-23', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4203, 6, 2, '2026-03-23', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4204, 2, 2, '2026-03-23', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4205, 6, 4, '2026-03-23', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4206, 2, 4, '2026-03-23', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4207, 6, 1, '2026-03-20', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4208, 2, 1, '2026-03-20', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4209, 6, 2, '2026-03-20', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4210, 2, 2, '2026-03-20', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4211, 6, 4, '2026-03-20', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4212, 2, 4, '2026-03-20', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4213, 6, 1, '2026-03-19', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4214, 2, 1, '2026-03-19', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4215, 6, 2, '2026-03-19', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4216, 2, 2, '2026-03-19', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4217, 6, 4, '2026-03-19', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4218, 2, 4, '2026-03-19', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4219, 6, 1, '2026-03-18', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4220, 2, 1, '2026-03-18', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4221, 6, 2, '2026-03-18', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4222, 2, 2, '2026-03-18', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4223, 6, 4, '2026-03-18', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4224, 2, 4, '2026-03-18', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4225, 6, 1, '2026-03-17', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4226, 2, 1, '2026-03-17', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4227, 6, 2, '2026-03-17', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4228, 2, 2, '2026-03-17', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4229, 6, 4, '2026-03-17', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4230, 2, 4, '2026-03-17', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4231, 6, 1, '2026-03-16', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4232, 2, 1, '2026-03-16', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4233, 6, 2, '2026-03-16', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4234, 2, 2, '2026-03-16', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4235, 6, 4, '2026-03-16', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4236, 2, 4, '2026-03-16', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4237, 6, 1, '2026-03-13', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4238, 2, 1, '2026-03-13', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4239, 6, 2, '2026-03-13', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4240, 2, 2, '2026-03-13', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4241, 6, 4, '2026-03-13', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4242, 2, 4, '2026-03-13', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4243, 6, 1, '2026-03-12', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4244, 2, 1, '2026-03-12', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4245, 6, 2, '2026-03-12', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4246, 2, 2, '2026-03-12', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4247, 6, 4, '2026-03-12', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4248, 2, 4, '2026-03-12', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4249, 6, 1, '2026-03-11', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4250, 2, 1, '2026-03-11', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4251, 6, 2, '2026-03-11', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4252, 2, 2, '2026-03-11', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4253, 6, 4, '2026-03-11', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4254, 2, 4, '2026-03-11', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4255, 6, 1, '2026-03-10', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4256, 2, 1, '2026-03-10', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4257, 6, 2, '2026-03-10', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4258, 2, 2, '2026-03-10', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4259, 6, 4, '2026-03-10', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4260, 2, 4, '2026-03-10', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4261, 6, 1, '2026-03-09', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4262, 2, 1, '2026-03-09', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4263, 6, 2, '2026-03-09', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4264, 2, 2, '2026-03-09', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4265, 6, 4, '2026-03-09', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4266, 2, 4, '2026-03-09', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4267, 6, 1, '2026-03-06', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4268, 2, 1, '2026-03-06', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4269, 6, 2, '2026-03-06', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4270, 2, 2, '2026-03-06', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4271, 6, 4, '2026-03-06', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4272, 2, 4, '2026-03-06', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4273, 6, 1, '2026-03-05', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4274, 2, 1, '2026-03-05', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4275, 6, 2, '2026-03-05', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4276, 2, 2, '2026-03-05', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4277, 6, 4, '2026-03-05', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4278, 2, 4, '2026-03-05', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4279, 6, 1, '2026-03-04', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4280, 2, 1, '2026-03-04', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4281, 6, 2, '2026-03-04', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4282, 2, 2, '2026-03-04', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4283, 6, 4, '2026-03-04', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4284, 2, 4, '2026-03-04', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4285, 6, 1, '2026-03-03', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4286, 2, 1, '2026-03-03', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4287, 6, 2, '2026-03-03', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4288, 2, 2, '2026-03-03', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4289, 6, 4, '2026-03-03', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4290, 2, 4, '2026-03-03', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4291, 6, 1, '2026-03-02', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4292, 2, 1, '2026-03-02', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4293, 6, 2, '2026-03-02', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4294, 2, 2, '2026-03-02', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4295, 6, 4, '2026-03-02', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4296, 2, 4, '2026-03-02', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4297, 6, 1, '2026-02-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4298, 2, 1, '2026-02-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4299, 6, 2, '2026-02-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4300, 2, 2, '2026-02-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4301, 6, 4, '2026-02-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4302, 2, 4, '2026-02-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4303, 6, 1, '2026-02-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4304, 2, 1, '2026-02-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4305, 6, 2, '2026-02-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4306, 2, 2, '2026-02-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4307, 6, 4, '2026-02-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4308, 2, 4, '2026-02-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4309, 6, 1, '2026-02-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4310, 2, 1, '2026-02-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4311, 6, 2, '2026-02-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4312, 2, 2, '2026-02-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4313, 6, 4, '2026-02-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4314, 2, 4, '2026-02-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4315, 6, 1, '2026-02-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4316, 2, 1, '2026-02-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4317, 6, 2, '2026-02-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4318, 2, 2, '2026-02-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4319, 6, 4, '2026-02-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4320, 2, 4, '2026-02-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4321, 6, 1, '2026-03-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4322, 2, 1, '2026-03-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4323, 6, 2, '2026-03-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4324, 2, 2, '2026-03-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4325, 6, 4, '2026-03-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4326, 2, 4, '2026-03-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4327, 6, 1, '2026-03-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4328, 2, 1, '2026-03-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4329, 6, 2, '2026-03-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4330, 2, 2, '2026-03-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4331, 6, 4, '2026-03-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4332, 2, 4, '2026-03-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4333, 6, 1, '2026-03-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4334, 2, 1, '2026-03-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4335, 6, 2, '2026-03-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4336, 2, 2, '2026-03-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4337, 6, 4, '2026-03-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4338, 2, 4, '2026-03-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4339, 6, 1, '2026-03-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4340, 2, 1, '2026-03-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4341, 6, 2, '2026-03-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4342, 2, 2, '2026-03-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4343, 6, 4, '2026-03-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4344, 2, 4, '2026-03-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4345, 6, 1, '2026-03-23', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4346, 2, 1, '2026-03-23', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4347, 6, 2, '2026-03-23', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4348, 2, 2, '2026-03-23', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4349, 6, 4, '2026-03-23', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4350, 2, 4, '2026-03-23', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4351, 6, 1, '2026-03-20', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4352, 2, 1, '2026-03-20', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4353, 6, 2, '2026-03-20', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4354, 2, 2, '2026-03-20', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4355, 6, 4, '2026-03-20', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4356, 2, 4, '2026-03-20', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4357, 6, 1, '2026-03-19', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4358, 2, 1, '2026-03-19', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4359, 6, 2, '2026-03-19', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4360, 2, 2, '2026-03-19', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4361, 6, 4, '2026-03-19', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4362, 2, 4, '2026-03-19', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4363, 6, 1, '2026-03-18', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4364, 2, 1, '2026-03-18', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4365, 6, 2, '2026-03-18', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4366, 2, 2, '2026-03-18', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4367, 6, 4, '2026-03-18', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4368, 2, 4, '2026-03-18', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4369, 6, 1, '2026-03-17', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4370, 2, 1, '2026-03-17', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4371, 6, 2, '2026-03-17', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4372, 2, 2, '2026-03-17', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4373, 6, 4, '2026-03-17', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4374, 2, 4, '2026-03-17', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4375, 6, 1, '2026-03-16', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4376, 2, 1, '2026-03-16', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4377, 6, 2, '2026-03-16', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4378, 2, 2, '2026-03-16', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4379, 6, 4, '2026-03-16', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4380, 2, 4, '2026-03-16', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4381, 6, 1, '2026-03-13', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4382, 2, 1, '2026-03-13', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4383, 6, 2, '2026-03-13', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4384, 2, 2, '2026-03-13', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4385, 6, 4, '2026-03-13', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4386, 2, 4, '2026-03-13', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4387, 6, 1, '2026-03-12', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4388, 2, 1, '2026-03-12', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4389, 6, 2, '2026-03-12', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4390, 2, 2, '2026-03-12', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4391, 6, 4, '2026-03-12', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4392, 2, 4, '2026-03-12', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4393, 6, 1, '2026-03-11', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4394, 2, 1, '2026-03-11', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4395, 6, 2, '2026-03-11', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4396, 2, 2, '2026-03-11', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4397, 6, 4, '2026-03-11', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4398, 2, 4, '2026-03-11', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4399, 6, 1, '2026-03-10', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4400, 2, 1, '2026-03-10', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4401, 6, 2, '2026-03-10', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4402, 2, 2, '2026-03-10', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4403, 6, 4, '2026-03-10', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4404, 2, 4, '2026-03-10', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4405, 6, 1, '2026-03-09', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4406, 2, 1, '2026-03-09', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4407, 6, 2, '2026-03-09', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4408, 2, 2, '2026-03-09', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4409, 6, 4, '2026-03-09', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4410, 2, 4, '2026-03-09', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4411, 6, 1, '2026-03-06', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4412, 2, 1, '2026-03-06', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4413, 6, 2, '2026-03-06', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4414, 2, 2, '2026-03-06', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4415, 6, 4, '2026-03-06', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4416, 2, 4, '2026-03-06', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4417, 6, 1, '2026-03-05', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4418, 2, 1, '2026-03-05', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4419, 6, 2, '2026-03-05', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4420, 2, 2, '2026-03-05', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4421, 6, 4, '2026-03-05', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4422, 2, 4, '2026-03-05', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4423, 6, 1, '2026-03-04', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4424, 2, 1, '2026-03-04', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4425, 6, 2, '2026-03-04', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4426, 2, 2, '2026-03-04', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4427, 6, 4, '2026-03-04', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4428, 2, 4, '2026-03-04', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4429, 6, 1, '2026-03-03', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4430, 2, 1, '2026-03-03', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4431, 6, 2, '2026-03-03', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4432, 2, 2, '2026-03-03', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4433, 6, 4, '2026-03-03', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4434, 2, 4, '2026-03-03', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4435, 6, 1, '2026-03-02', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4436, 2, 1, '2026-03-02', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4437, 6, 2, '2026-03-02', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4438, 2, 2, '2026-03-02', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4439, 6, 4, '2026-03-02', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4440, 2, 4, '2026-03-02', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4441, 6, 1, '2026-02-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4442, 2, 1, '2026-02-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4443, 6, 2, '2026-02-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4444, 2, 2, '2026-02-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4445, 6, 4, '2026-02-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4446, 2, 4, '2026-02-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4447, 6, 1, '2026-02-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4448, 2, 1, '2026-02-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4449, 6, 2, '2026-02-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4450, 2, 2, '2026-02-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4451, 6, 4, '2026-02-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4452, 2, 4, '2026-02-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4453, 6, 1, '2026-02-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4454, 2, 1, '2026-02-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4455, 6, 2, '2026-02-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4456, 2, 2, '2026-02-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4457, 6, 4, '2026-02-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4458, 2, 4, '2026-02-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4459, 6, 1, '2026-02-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4460, 2, 1, '2026-02-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4461, 6, 2, '2026-02-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4462, 2, 2, '2026-02-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4463, 6, 4, '2026-02-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4464, 2, 4, '2026-02-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4465, 6, 1, '2026-03-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4466, 2, 1, '2026-03-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4467, 6, 2, '2026-03-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4468, 2, 2, '2026-03-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4469, 6, 4, '2026-03-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4470, 2, 4, '2026-03-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4471, 6, 1, '2026-03-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4472, 2, 1, '2026-03-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4473, 6, 2, '2026-03-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4474, 2, 2, '2026-03-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4475, 6, 4, '2026-03-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4476, 2, 4, '2026-03-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4477, 6, 1, '2026-03-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4478, 2, 1, '2026-03-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4479, 6, 2, '2026-03-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4480, 2, 2, '2026-03-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4481, 6, 4, '2026-03-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4482, 2, 4, '2026-03-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4483, 6, 1, '2026-03-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4484, 2, 1, '2026-03-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4485, 6, 2, '2026-03-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4486, 2, 2, '2026-03-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4487, 6, 4, '2026-03-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4488, 2, 4, '2026-03-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4489, 6, 1, '2026-03-23', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4490, 2, 1, '2026-03-23', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4491, 6, 2, '2026-03-23', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4492, 2, 2, '2026-03-23', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4493, 6, 4, '2026-03-23', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4494, 2, 4, '2026-03-23', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4495, 6, 1, '2026-03-20', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4496, 2, 1, '2026-03-20', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4497, 6, 2, '2026-03-20', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4498, 2, 2, '2026-03-20', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4499, 6, 4, '2026-03-20', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4500, 2, 4, '2026-03-20', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4501, 6, 1, '2026-03-19', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4502, 2, 1, '2026-03-19', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4503, 6, 2, '2026-03-19', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4504, 2, 2, '2026-03-19', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4505, 6, 4, '2026-03-19', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4506, 2, 4, '2026-03-19', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4507, 6, 1, '2026-03-18', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4508, 2, 1, '2026-03-18', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4509, 6, 2, '2026-03-18', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4510, 2, 2, '2026-03-18', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4511, 6, 4, '2026-03-18', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4512, 2, 4, '2026-03-18', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4513, 6, 1, '2026-03-17', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4514, 2, 1, '2026-03-17', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4515, 6, 2, '2026-03-17', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4516, 2, 2, '2026-03-17', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4517, 6, 4, '2026-03-17', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4518, 2, 4, '2026-03-17', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4519, 6, 1, '2026-03-16', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4520, 2, 1, '2026-03-16', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4521, 6, 2, '2026-03-16', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4522, 2, 2, '2026-03-16', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4523, 6, 4, '2026-03-16', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4524, 2, 4, '2026-03-16', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4525, 6, 1, '2026-03-13', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4526, 2, 1, '2026-03-13', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4527, 6, 2, '2026-03-13', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4528, 2, 2, '2026-03-13', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4529, 6, 4, '2026-03-13', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4530, 2, 4, '2026-03-13', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4531, 6, 1, '2026-03-12', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4532, 2, 1, '2026-03-12', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4533, 6, 2, '2026-03-12', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4534, 2, 2, '2026-03-12', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4535, 6, 4, '2026-03-12', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4536, 2, 4, '2026-03-12', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4537, 6, 1, '2026-03-11', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4538, 2, 1, '2026-03-11', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4539, 6, 2, '2026-03-11', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4540, 2, 2, '2026-03-11', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4541, 6, 4, '2026-03-11', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4542, 2, 4, '2026-03-11', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4543, 6, 1, '2026-03-10', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4544, 2, 1, '2026-03-10', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4545, 6, 2, '2026-03-10', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4546, 2, 2, '2026-03-10', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4547, 6, 4, '2026-03-10', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4548, 2, 4, '2026-03-10', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4549, 6, 1, '2026-03-09', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4550, 2, 1, '2026-03-09', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4551, 6, 2, '2026-03-09', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4552, 2, 2, '2026-03-09', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4553, 6, 4, '2026-03-09', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4554, 2, 4, '2026-03-09', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4555, 6, 1, '2026-03-06', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4556, 2, 1, '2026-03-06', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4557, 6, 2, '2026-03-06', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4558, 2, 2, '2026-03-06', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4559, 6, 4, '2026-03-06', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4560, 2, 4, '2026-03-06', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4561, 6, 1, '2026-03-05', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4562, 2, 1, '2026-03-05', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4563, 6, 2, '2026-03-05', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4564, 2, 2, '2026-03-05', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4565, 6, 4, '2026-03-05', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4566, 2, 4, '2026-03-05', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4567, 6, 1, '2026-03-04', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4568, 2, 1, '2026-03-04', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4569, 6, 2, '2026-03-04', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4570, 2, 2, '2026-03-04', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4571, 6, 4, '2026-03-04', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4572, 2, 4, '2026-03-04', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4573, 6, 1, '2026-03-03', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4574, 2, 1, '2026-03-03', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4575, 6, 2, '2026-03-03', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4576, 2, 2, '2026-03-03', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4577, 6, 4, '2026-03-03', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4578, 2, 4, '2026-03-03', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4579, 6, 1, '2026-03-02', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4580, 2, 1, '2026-03-02', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4581, 6, 2, '2026-03-02', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4582, 2, 2, '2026-03-02', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4583, 6, 4, '2026-03-02', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4584, 2, 4, '2026-03-02', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4585, 6, 1, '2026-02-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4586, 2, 1, '2026-02-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4587, 6, 2, '2026-02-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4588, 2, 2, '2026-02-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4589, 6, 4, '2026-02-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4590, 2, 4, '2026-02-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4591, 6, 1, '2026-02-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4592, 2, 1, '2026-02-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4593, 6, 2, '2026-02-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4594, 2, 2, '2026-02-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4595, 6, 4, '2026-02-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4596, 2, 4, '2026-02-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4597, 6, 1, '2026-02-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4598, 2, 1, '2026-02-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4599, 6, 2, '2026-02-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4600, 2, 2, '2026-02-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4601, 6, 4, '2026-02-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4602, 2, 4, '2026-02-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4603, 6, 1, '2026-02-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4604, 2, 1, '2026-02-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4605, 6, 2, '2026-02-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4606, 2, 2, '2026-02-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4607, 6, 4, '2026-02-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4608, 2, 4, '2026-02-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');

-- ----------------------------
-- Table structure for doctor_site
-- ----------------------------
DROP TABLE IF EXISTS `doctor_site`;
CREATE TABLE `doctor_site`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '医生用户ID',
  `site_id` bigint NOT NULL COMMENT '接种点ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_doctor_site`(`user_id` ASC, `site_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  CONSTRAINT `fk_doctor_site_site` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_doctor_site_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '医生-接种点关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of doctor_site
-- ----------------------------
INSERT INTO `doctor_site` VALUES (1, 2, 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `doctor_site` VALUES (2, 2, 2, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `doctor_site` VALUES (3, 2, 3, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `doctor_site` VALUES (4, 2, 4, '2026-02-11 23:03:22', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '正文内容',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'NORMAL' COMMENT '类型：NORMAL/IMPORTANT/SYSTEM',
  `publisher_id` bigint NULL DEFAULT NULL COMMENT '发布人ID',
  `publisher_role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'ADMIN' COMMENT '发布者角色：ADMIN-管理员，DOCTOR-医生',
  `audit_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'PENDING/APPROVED/REJECTED',
  `reject_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '未通过原因',
  `is_top` tinyint NOT NULL DEFAULT 0 COMMENT '是否置顶：0-否，1-是',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-草稿/下架，1-发布',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `target_user_id` bigint NULL DEFAULT NULL COMMENT '定向用户ID：非空时仅该用户可见',
  `notice_style` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'NORMAL' COMMENT '展示样式：NORMAL/WARNING/FROZEN',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type`(`type` ASC) USING BTREE,
  INDEX `idx_is_top`(`is_top` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_publish_time`(`publish_time` ASC) USING BTREE,
  INDEX `fk_notice_publisher`(`publisher_id` ASC) USING BTREE,
  CONSTRAINT `fk_notice_publisher` FOREIGN KEY (`publisher_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '2025年2月接种安排通知', '本月每周一至周五上午开放接种，请家长提前在系统预约，携带接种证与儿童到场。', 'NORMAL', 1, 'ADMIN', NULL, NULL, 0, 1, '2026-02-24 17:13:01', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (2, '流感疫苗接种提醒', '当前为流感高发季，建议6月龄以上儿童及时接种流感疫苗。', 'IMPORTANT', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-02 10:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (3, '一类疫苗缺货说明', '卡介苗近期到货，请需接种的家长关注预约开放时间。', 'NORMAL', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-03 11:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (4, '留观须知', '接种后请在留观区观察30分钟，无异常后方可离开。', 'SYSTEM', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-04 09:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (5, '春节假期接种点开放时间', '除夕至初三休息，初四起正常开放。', 'NORMAL', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-05 10:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (6, '儿童接种证补办流程', '遗失接种证可携带户口本到接种点补办。', 'NORMAL', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-06 11:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (7, '鸡蛋过敏儿童接种须知', '鸡蛋过敏者部分疫苗需谨慎，请提前告知医生。', 'IMPORTANT', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-07 09:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (8, '不良反应上报渠道', '接种后如有不适可通过本系统上报或到接种点登记。', 'SYSTEM', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-08 10:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (9, '三月疫苗库存预告', '三月将到货百白破、麻腮风等疫苗，请关注预约。', 'NORMAL', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-09 11:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (10, '接种点联系方式汇总', '各接种点地址与电话已更新，详见系统内接种点列表。', 'NORMAL', 1, 'ADMIN', NULL, NULL, 0, 1, '2025-02-10 09:00:00', NULL, 'NORMAL', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `notice` VALUES (11, '好奥i设计及', '12121211', 'NORMAL', 2, 'DOCTOR', 'APPROVED', NULL, 0, 0, '2026-02-12 19:18:47', NULL, 'NORMAL', '2026-02-12 19:18:22', '2026-02-12 19:18:22');
INSERT INTO `notice` VALUES (12, '123', '123', 'NORMAL', NULL, 'ADMIN', 'APPROVED', NULL, 0, 0, '2026-02-24 16:02:00', NULL, 'NORMAL', '2026-02-24 16:02:00', '2026-02-24 16:02:00');
INSERT INTO `notice` VALUES (13, 'nih你好', '测试一i', 'NORMAL', 2, 'DOCTOR', 'APPROVED', NULL, 0, 1, '2026-02-24 17:12:51', NULL, 'NORMAL', '2026-02-24 17:12:03', '2026-02-24 17:12:03');
INSERT INTO `notice` VALUES (14, '12122121fdfdf', 'yuutuy', 'NORMAL', NULL, 'ADMIN', 'APPROVED', NULL, 0, 1, '2026-02-24 17:13:20', NULL, 'NORMAL', '2026-02-24 17:13:20', '2026-02-24 17:13:20');
INSERT INTO `notice` VALUES (15, '1212adsad', 'ghmvh', 'NORMAL', 2, 'DOCTOR', 'REJECTED', '妮妮ininii', 0, 0, NULL, NULL, 'NORMAL', '2026-02-24 17:28:57', '2026-02-24 17:28:57');

-- ----------------------------
-- Table structure for notice_feedback
-- ----------------------------
DROP TABLE IF EXISTS `notice_feedback`;
CREATE TABLE `notice_feedback`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `notice_id` bigint NOT NULL COMMENT '公告ID',
  `user_id` bigint NOT NULL COMMENT '提交人（医生）ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '意见内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_notice_id`(`notice_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_feedback_notice` FOREIGN KEY (`notice_id`) REFERENCES `notice` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_feedback_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告意见表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice_feedback
-- ----------------------------
INSERT INTO `notice_feedback` VALUES (1, 10, 2, '测试测试', '2026-02-24 17:12:17');
INSERT INTO `notice_feedback` VALUES (2, 10, 2, 'bhjgjhjg', '2026-02-24 17:29:04');
INSERT INTO `notice_feedback` VALUES (3, 8, 2, 'gjhgjgjh', '2026-02-24 17:29:07');

-- ----------------------------
-- Table structure for record
-- ----------------------------
DROP TABLE IF EXISTS `record`;
CREATE TABLE `record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id` bigint NULL DEFAULT NULL COMMENT '预约ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '家长ID',
  `child_id` bigint NULL DEFAULT NULL COMMENT '宝宝ID',
  `vaccine_id` bigint NULL DEFAULT NULL COMMENT '疫苗ID',
  `doctor_id` bigint NULL DEFAULT NULL COMMENT '医生ID',
  `site_id` bigint NULL DEFAULT NULL COMMENT '接种点ID',
  `vaccinate_time` datetime NULL DEFAULT NULL COMMENT '接种时间',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '状态：已接种/异常/取消',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_child_id`(`child_id` ASC) USING BTREE,
  INDEX `idx_vaccinate_time`(`vaccinate_time` ASC) USING BTREE,
  INDEX `idx_is_deleted`(`is_deleted` ASC) USING BTREE,
  INDEX `fk_record_vaccine_r`(`vaccine_id` ASC) USING BTREE,
  INDEX `fk_record_doctor_r`(`doctor_id` ASC) USING BTREE,
  INDEX `fk_record_site_r`(`site_id` ASC) USING BTREE,
  CONSTRAINT `fk_record_child_r` FOREIGN KEY (`child_id`) REFERENCES `child_profile` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_doctor_r` FOREIGN KEY (`doctor_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_order` FOREIGN KEY (`order_id`) REFERENCES `appointment` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_site_r` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_user_r` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_vaccine_r` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccine` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '简易接种记录表（统计与医生完成接种）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of record
-- ----------------------------
INSERT INTO `record` VALUES (1, 3, 4, NULL, 3, 2, 1, '2025-02-17 08:20:00', '已接种', '脊灰第二针', '2026-02-11 23:03:22', '2026-02-11 23:03:22', 0);
INSERT INTO `record` VALUES (2, 4, 4, NULL, 4, 2, 1, '2025-02-18 10:15:00', '已接种', NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22', 0);
INSERT INTO `record` VALUES (3, 6, 5, 6, 2, 2, 1, '2025-02-20 09:10:00', '已接种', '卡介苗', '2026-02-11 23:03:22', '2026-02-11 23:03:22', 0);
INSERT INTO `record` VALUES (4, 7, 5, 7, 7, 3, 2, '2025-02-21 08:25:00', '已接种', NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22', 0);
INSERT INTO `record` VALUES (5, 8, 5, 8, 1, 3, 2, '2025-02-22 10:05:00', '已接种', '乙肝第一针', '2026-02-11 23:03:22', '2026-02-11 23:03:22', 0);
INSERT INTO `record` VALUES (6, 10, 5, 10, 9, 3, 2, '2025-02-24 09:30:00', '已接种', NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22', 0);
INSERT INTO `record` VALUES (7, NULL, 4, 1, 1, 2, 1, '2025-01-10 09:00:00', '已接种', '补录', '2026-02-11 23:03:22', '2026-02-11 23:03:22', 0);
INSERT INTO `record` VALUES (8, NULL, 5, 9, 5, 3, 2, '2025-01-25 09:00:00', '异常', '轻微发热已观察', '2026-02-11 23:03:22', '2026-02-11 23:03:22', 0);

-- ----------------------------
-- Table structure for stock_alert_log
-- ----------------------------
DROP TABLE IF EXISTS `stock_alert_log`;
CREATE TABLE `stock_alert_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `alert_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'LOW_STOCK-批次剩余率低，EXPIRY-效期临近',
  `vaccine_id` bigint NOT NULL COMMENT '疫苗ID',
  `vaccine_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '疫苗名称（冗余）',
  `site_id` bigint NOT NULL COMMENT '接种点ID',
  `inventory_id` bigint NOT NULL COMMENT '批次库存ID',
  `batch_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '批次号',
  `quantity` int NOT NULL DEFAULT 0 COMMENT '入库数量',
  `used_quantity` int NOT NULL DEFAULT 0 COMMENT '已使用数量',
  `remaining_ratio` decimal(5, 2) NULL DEFAULT NULL COMMENT '剩余率（如 8.50 表示 8.5%）',
  `expiry_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `synced_to_supplier` tinyint NOT NULL DEFAULT 0 COMMENT '是否已同步供应商：0-否，1-是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_alert_type`(`alert_type` ASC) USING BTREE,
  INDEX `idx_vaccine_id`(`vaccine_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_inventory_id`(`inventory_id` ASC) USING BTREE,
  INDEX `idx_synced`(`synced_to_supplier` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '库存/效期预警与补货提醒记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stock_alert_log
-- ----------------------------
INSERT INTO `stock_alert_log` VALUES (1, 'LOW_STOCK', 5, '麻腮风疫苗', 1, 5, 'MMR202501001', 70, 65, 7.14, '2026-02-01', 1, '2025-02-01 10:00:00');
INSERT INTO `stock_alert_log` VALUES (2, 'LOW_STOCK', 9, '肺炎球菌疫苗', 2, 9, 'PCV202502001', 40, 36, 10.00, '2026-08-01', 1, '2025-02-03 11:00:00');
INSERT INTO `stock_alert_log` VALUES (3, 'EXPIRY', 6, '流感疫苗', 2, 6, 'FLU202502001', 60, 10, 83.33, '2025-08-01', 1, '2025-02-05 09:00:00');
INSERT INTO `stock_alert_log` VALUES (4, 'EXPIRY', 2, '卡介苗', 1, 2, 'BCG202501001', 80, 5, 93.75, '2026-03-01', 1, '2025-02-07 14:00:00');
INSERT INTO `stock_alert_log` VALUES (5, 'LOW_STOCK', 4, '百白破疫苗', 1, 4, 'DPT202501001', 90, 82, 8.89, '2026-04-01', 1, '2025-02-09 08:00:00');
INSERT INTO `stock_alert_log` VALUES (6, 'EXPIRY', 2, '卡介苗', 1, 2, 'BCG202501001', 80, 0, 100.00, '2026-03-01', 1, '2026-02-12 08:00:00');

-- ----------------------------
-- Table structure for supplier_sync_log
-- ----------------------------
DROP TABLE IF EXISTS `supplier_sync_log`;
CREATE TABLE `supplier_sync_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `stock_alert_log_id` bigint NOT NULL COMMENT '关联 stock_alert_log.id',
  `supplier_endpoint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '供应商接口地址',
  `request_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求体（JSON）',
  `response_code` int NULL DEFAULT NULL COMMENT 'HTTP 状态码',
  `response_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '响应体',
  `sync_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '同步时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_stock_alert_log_id`(`stock_alert_log_id` ASC) USING BTREE,
  INDEX `idx_sync_time`(`sync_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '供应商同步记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of supplier_sync_log
-- ----------------------------
INSERT INTO `supplier_sync_log` VALUES (1, 1, 'https://api.supplier.example.com/alert', '{\"vaccine\":\"麻腮风疫苗\",\"batch\":\"MMR202501001\",\"remaining_ratio\":7.14}', 200, '{\"code\":0,\"msg\":\"已记录补货需求\"}', '2025-02-01 10:05:00');
INSERT INTO `supplier_sync_log` VALUES (2, 2, 'https://api.supplier.example.com/alert', '{\"vaccine\":\"肺炎球菌疫苗\",\"batch\":\"PCV202502001\",\"remaining_ratio\":10}', 200, '{\"code\":0,\"msg\":\"已记录补货需求\"}', '2025-02-03 11:10:00');
INSERT INTO `supplier_sync_log` VALUES (3, 5, 'https://api.supplier.example.com/alert', '{\"vaccine\":\"百白破疫苗\",\"batch\":\"DPT202501001\",\"remaining_ratio\":8.89}', 200, '{\"code\":0,\"msg\":\"已记录补货需求\"}', '2025-02-09 08:15:00');
INSERT INTO `supplier_sync_log` VALUES (4, 3, '', '{\"alertId\":3}', 0, 'supplier URL not configured, log only', '2026-02-12 08:00:00');
INSERT INTO `supplier_sync_log` VALUES (5, 4, '', '{\"alertId\":4}', 0, 'supplier URL not configured, log only', '2026-02-12 08:00:00');
INSERT INTO `supplier_sync_log` VALUES (6, 6, '', '{\"alertId\":6}', 0, 'supplier URL not configured, log only', '2026-02-12 08:00:00');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录账号',
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码（明文存储）',
  `real_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色：ADMIN-管理员，DOCTOR-医生，RESIDENT-居民/家长',
  `gender` tinyint NULL DEFAULT NULL COMMENT '性别：0-未知，1-男，2-女',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '常住地址',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0-正常，1-已禁用，2-已注销（不可恢复）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `reservation_ban_until` datetime NULL DEFAULT NULL COMMENT '预约禁约截止时间：爽约超3次当日逾期未核销则30日内不可预约',
  `is_deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  INDEX `idx_role`(`role` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_id_card`(`id_card` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_last_login_time`(`last_login_time` ASC) USING BTREE,
  INDEX `idx_is_deleted`(`is_deleted` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '123456', '系统管理员', 'ADMIN', 1, '13800000001', NULL, '天津市南开区', NULL, 0, '2026-02-11 23:03:22', '2026-02-26 09:12:30', '2026-02-26 09:12:30', NULL, 0);
INSERT INTO `sys_user` VALUES (2, 'doctor01', '123456', '张医生', 'DOCTOR', 2, '13800000002', NULL, '天津市南开区', NULL, 0, '2026-02-11 23:03:22', '2026-02-25 15:34:35', '2026-02-25 15:34:35', NULL, 0);
INSERT INTO `sys_user` VALUES (3, 'doctor02', '123456', '马医生', 'DOCTOR', 1, '13800000003', NULL, '天津市南开区', NULL, 2, '2026-02-11 23:03:22', '2026-02-25 15:33:46', NULL, NULL, 0);
INSERT INTO `sys_user` VALUES (4, 'parent01', '123456', '李家长', 'RESIDENT', 1, '13800000004', NULL, '天津市南开区某某小区', NULL, 0, '2026-02-11 23:03:22', '2026-02-25 15:10:14', '2026-02-25 15:10:14', NULL, 0);
INSERT INTO `sys_user` VALUES (5, 'parent02', '123456', '赵家长', 'RESIDENT', 2, '13800000005', NULL, '天津市南开区某某街道', NULL, 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22', NULL, NULL, 0);
INSERT INTO `sys_user` VALUES (6, 'doctor03', '123456', '刘医生', 'DOCTOR', NULL, NULL, NULL, NULL, NULL, 2, '2026-02-12 00:10:21', '2026-02-12 08:31:24', '2026-02-12 08:31:25', NULL, 0);
INSERT INTO `sys_user` VALUES (7, 'doctor04', '123456', '王医生', 'DOCTOR', NULL, '123', NULL, '123', NULL, 0, '2026-02-12 07:55:23', '2026-02-24 17:57:27', '2026-02-24 17:57:27', NULL, 0);

-- ----------------------------
-- Table structure for user_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `user_notice_read`;
CREATE TABLE `user_notice_read`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `notice_id` bigint NOT NULL COMMENT '公告ID',
  `read_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '阅读时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE,
  INDEX `idx_notice_id`(`notice_id` ASC) USING BTREE,
  CONSTRAINT `fk_read_notice` FOREIGN KEY (`notice_id`) REFERENCES `notice` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_read_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户公告已读表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_notice_read
-- ----------------------------
INSERT INTO `user_notice_read` VALUES (1, 1, 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (2, 1, 2, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (3, 2, 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (4, 2, 3, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (5, 3, 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (6, 3, 4, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (7, 4, 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (8, 4, 2, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (9, 4, 5, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `user_notice_read` VALUES (10, 5, 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for vaccination_record
-- ----------------------------
DROP TABLE IF EXISTS `vaccination_record`;
CREATE TABLE `vaccination_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `child_id` bigint NULL DEFAULT NULL COMMENT '接种儿童档案ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '家长/居民ID',
  `vaccine_id` bigint NOT NULL COMMENT '疫苗ID',
  `appointment_id` bigint NULL DEFAULT NULL COMMENT '关联预约ID',
  `inventory_id` bigint NULL DEFAULT NULL COMMENT '使用的库存批次ID',
  `batch_id` bigint NULL DEFAULT NULL COMMENT '接种使用批次ID',
  `vaccine_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '疫苗编号，核销时自动生成，不可修改',
  `batch_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '疫苗批号',
  `dose_number` int NOT NULL DEFAULT 1 COMMENT '第几针/剂次',
  `vaccination_date` datetime NOT NULL COMMENT '实际接种时间',
  `doctor_id` bigint NULL DEFAULT NULL COMMENT '接种医生ID',
  `site_id` bigint NOT NULL COMMENT '接种点ID',
  `injection_site` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '接种部位',
  `observation_ok` tinyint NULL DEFAULT NULL COMMENT '留观无异常：0-否，1-是',
  `reaction` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '不良反应简要记录',
  `next_dose_date` date NULL DEFAULT NULL COMMENT '下次接种日期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_vaccine_code`(`vaccine_code` ASC) USING BTREE,
  INDEX `idx_child_id`(`child_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_vaccine_id`(`vaccine_id` ASC) USING BTREE,
  INDEX `idx_appointment_id`(`appointment_id` ASC) USING BTREE,
  INDEX `idx_inventory_id`(`inventory_id` ASC) USING BTREE,
  INDEX `idx_vaccination_date`(`vaccination_date` ASC) USING BTREE,
  INDEX `idx_doctor_id`(`doctor_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_batch_id`(`batch_id` ASC) USING BTREE,
  CONSTRAINT `fk_record_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_batch` FOREIGN KEY (`batch_id`) REFERENCES `vaccine_batch` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_child` FOREIGN KEY (`child_id`) REFERENCES `child_profile` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_inventory` FOREIGN KEY (`inventory_id`) REFERENCES `vaccine_inventory` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_site` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_vaccine` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccine` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '接种记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vaccination_record
-- ----------------------------
INSERT INTO `vaccination_record` VALUES (1, NULL, 4, 3, 3, 3, NULL, NULL, 'PV202501001', 2, '2025-02-17 08:20:00', 2, 1, '左上臂', 1, NULL, '2025-03-17', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (2, NULL, 4, 4, 4, 4, NULL, NULL, 'DPT202501001', 1, '2025-02-18 10:15:00', 2, 1, '左上臂', 1, NULL, '2025-03-18', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (3, 6, 5, 2, 6, 2, NULL, NULL, 'BCG202501001', 1, '2025-02-20 09:10:00', 2, 1, '左上臂', 1, NULL, NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (4, 7, 5, 7, 7, 7, NULL, NULL, 'VAR202502001', 1, '2025-02-21 08:25:00', 3, 2, '左上臂', 1, NULL, '2025-05-21', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (5, 8, 5, 1, 8, 1, NULL, NULL, 'HBV202501001', 1, '2025-02-22 10:05:00', 3, 2, '左上臂', 1, NULL, '2025-03-24', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (6, 10, 5, 9, 10, 9, NULL, NULL, 'PCV202502001', 1, '2025-02-24 09:30:00', 3, 2, '左上臂', 1, NULL, '2025-04-25', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (7, 1, 4, 1, NULL, 1, NULL, NULL, 'HBV202501001', 1, '2025-01-10 09:00:00', 2, 1, '左上臂', 1, NULL, '2025-02-09', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (8, 2, 4, 6, NULL, 6, NULL, NULL, 'FLU202502001', 1, '2025-01-15 10:00:00', 2, 2, '左上臂', 1, NULL, NULL, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (9, NULL, 4, 3, NULL, 3, NULL, NULL, 'PV202501001', 1, '2025-01-20 08:30:00', 2, 1, '左上臂', 1, NULL, '2025-02-17', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (10, 9, 5, 5, NULL, 5, NULL, NULL, 'MMR202501001', 1, '2025-01-25 09:00:00', 3, 2, '左上臂', 1, '轻微发热', '2026-01-25', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_record` VALUES (11, 1, 4, 1, 1, NULL, NULL, NULL, '12121', 1, '2026-02-11 23:27:40', 2, 1, '12121', 1, NULL, '2026-03-13', '2026-02-11 23:27:39', '2026-02-11 23:27:39');
INSERT INTO `vaccination_record` VALUES (12, 2, 4, 6, 2, NULL, NULL, NULL, '1212', 1, '2026-02-11 23:52:24', 2, 1, '1212', 1, '121', NULL, '2026-02-11 23:52:23', '2026-02-11 23:52:23');
INSERT INTO `vaccination_record` VALUES (13, NULL, 4, 1, 12, NULL, NULL, NULL, '123456', 1, '2026-02-12 07:59:37', 6, 1, '1234', 1, NULL, '2026-03-14', '2026-02-12 07:59:36', '2026-02-12 07:59:36');
INSERT INTO `vaccination_record` VALUES (14, 1, 4, 3, 15, NULL, NULL, NULL, '12345', 1, '2026-02-24 10:01:30', 7, 1, '123', 1, '123', '2026-03-24', '2026-02-24 10:01:30', '2026-02-24 10:01:30');
INSERT INTO `vaccination_record` VALUES (15, 1, 4, 2, 17, NULL, NULL, NULL, '12212', 1, '2026-02-25 15:34:43', 2, 1, '12121', 1, '12121212', NULL, '2026-02-25 15:34:42', '2026-02-25 15:34:42');

-- ----------------------------
-- Table structure for vaccination_reminder_log
-- ----------------------------
DROP TABLE IF EXISTS `vaccination_reminder_log`;
CREATE TABLE `vaccination_reminder_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `child_id` bigint NOT NULL COMMENT '儿童档案ID',
  `user_id` bigint NOT NULL COMMENT '家长用户ID',
  `vaccine_id` bigint NOT NULL COMMENT '疫苗ID',
  `vaccine_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '疫苗名称',
  `dose_number` int NOT NULL COMMENT '待接种剂次',
  `remind_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SCHEDULE_72H' COMMENT 'SCHEDULE_72H-提前72小时预约提醒',
  `appointment_link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预约链接',
  `push_channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'WECHAT' COMMENT 'WECHAT/APP/SMS',
  `push_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '推送时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_child_id`(`child_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_vaccine_id`(`vaccine_id` ASC) USING BTREE,
  INDEX `idx_push_time`(`push_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '智能提醒推送记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vaccination_reminder_log
-- ----------------------------
INSERT INTO `vaccination_reminder_log` VALUES (1, 1, 4, 1, '乙肝疫苗', 2, 'SCHEDULE_72H', '/appointment?vaccine=1', 'WECHAT', '2025-02-12 09:00:00', '2026-02-11 23:03:22');
INSERT INTO `vaccination_reminder_log` VALUES (2, 2, 4, 6, '流感疫苗', 1, 'SCHEDULE_72H', '/appointment?vaccine=6', 'APP', '2025-02-13 10:00:00', '2026-02-11 23:03:22');
INSERT INTO `vaccination_reminder_log` VALUES (3, 1, 4, 3, '脊灰疫苗', 2, 'SCHEDULE_72H', '/appointment?vaccine=3', 'WECHAT', '2025-02-14 08:00:00', '2026-02-11 23:03:22');
INSERT INTO `vaccination_reminder_log` VALUES (4, 6, 5, 2, '卡介苗', 1, 'SCHEDULE_72H', '/appointment?vaccine=2', 'WECHAT', '2025-02-17 09:00:00', '2026-02-11 23:03:22');
INSERT INTO `vaccination_reminder_log` VALUES (5, 7, 5, 7, '水痘疫苗', 1, 'SCHEDULE_72H', '/appointment?vaccine=7', 'SMS', '2025-02-18 10:00:00', '2026-02-11 23:03:22');
INSERT INTO `vaccination_reminder_log` VALUES (6, 8, 5, 1, '乙肝疫苗', 1, 'SCHEDULE_72H', '/appointment?vaccine=1', 'WECHAT', '2025-02-19 08:00:00', '2026-02-11 23:03:22');
INSERT INTO `vaccination_reminder_log` VALUES (7, 10, 5, 9, '肺炎球菌疫苗', 1, 'SCHEDULE_72H', '/appointment?vaccine=9', 'APP', '2025-02-21 09:00:00', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for vaccination_site
-- ----------------------------
DROP TABLE IF EXISTS `vaccination_site`;
CREATE TABLE `vaccination_site`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '接种点名称',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `work_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '工作时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `current_doctor_id` bigint NULL DEFAULT NULL COMMENT '当前驻场医生用户ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_current_doctor_id`(`current_doctor_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '接种点表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vaccination_site
-- ----------------------------
INSERT INTO `vaccination_site` VALUES (1, '南开区社区卫生服务中心', '天津市南开区XX路100号', '022-12345678', '周一至周五 8:00-11:30 14:00-17:00', 1, NULL, 2, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_site` VALUES (2, '南开区妇幼保健院接种点', '天津市南开区YY大道200号', '022-87654321', '周一至周六 8:00-11:00', 0, NULL, 2, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_site` VALUES (3, '南开区第一接种点', '天津市南开区AA街1号', '022-11111111', '周一至周五 8:00-11:00', 0, NULL, 7, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccination_site` VALUES (4, '南开区第二接种点', '天津市南开区BB街2号', '022-22222222', '周一至周五 8:00-11:00', 1, NULL, 7, '2026-02-11 23:03:22', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for vaccine
-- ----------------------------
DROP TABLE IF EXISTS `vaccine`;
CREATE TABLE `vaccine`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vaccine_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '疫苗名称',
  `short_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '疫苗简称，用于疫苗编号生成，如 DTP、HBV',
  `category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CLASS_II' COMMENT '类别：CLASS_I-一类，CLASS_II-二类',
  `manufacturer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生产厂家',
  `vaccine_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '疫苗类型',
  `total_doses` int NOT NULL DEFAULT 1 COMMENT '总剂次',
  `interval_days` int NULL DEFAULT NULL COMMENT '剂次间隔天数',
  `applicable_age_months` int NULL DEFAULT NULL COMMENT '适用起始月龄',
  `dosage_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '剂型/规格说明',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '疫苗说明、注意事项',
  `adverse_reaction_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '不良反应说明',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-下架，1-上架',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_vaccine_name`(`vaccine_name` ASC) USING BTREE,
  INDEX `idx_category`(`category` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_short_code`(`short_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '疫苗信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vaccine
-- ----------------------------
INSERT INTO `vaccine` VALUES (1, '乙肝疫苗', NULL, 'CLASS_I', '北京生物', '重组酵母', 3, 30, 0, '0.5ml/支', '预防乙型肝炎。', '偶见发热、局部红肿，一般可自行缓解。', 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine` VALUES (2, '卡介苗', NULL, 'CLASS_I', '上海生物', '减毒活疫苗', 1, NULL, 0, '0.1ml/支', '预防结核病。', '局部红肿、化脓属正常反应。', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine` VALUES (3, '脊灰疫苗', NULL, 'CLASS_I', '北京生物', '灭活疫苗', 4, 28, 2, '0.5ml/支', '预防脊髓灰质炎。', '少数发热、食欲减退。', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine` VALUES (4, '百白破疫苗', NULL, 'CLASS_I', '武汉生物', '联合疫苗', 4, 28, 3, '0.5ml/支', '预防百日咳、白喉、破伤风。', '局部红肿、发热较常见。', 1, '2026-02-11 23:03:22', '2026-02-24 15:57:10');
INSERT INTO `vaccine` VALUES (5, '麻腮风疫苗', NULL, 'CLASS_I', '北京生物', '减毒活疫苗', 2, 365, 8, '0.5ml/支', '预防麻疹、流行性腮腺炎、风疹。', '少数发热、皮疹。', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine` VALUES (6, '流感疫苗', NULL, 'CLASS_II', '华兰生物', '灭活疫苗', 1, NULL, 6, '0.5ml/支', '预防流行性感冒。', '少数发热、乏力，鸡蛋过敏者禁用。', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine` VALUES (7, '水痘疫苗', NULL, 'CLASS_II', '长春百克', '减毒活疫苗', 2, 90, 12, '0.5ml/支', '预防水痘。', '偶见发热、局部红肿。', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine` VALUES (8, '手足口疫苗', NULL, 'CLASS_II', '北京科兴', '灭活疫苗', 2, 28, 6, '0.5ml/支', '预防EV71引起的手足口病。', '少数发热、局部反应。', 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine` VALUES (9, '肺炎球菌疫苗', NULL, 'CLASS_II', '辉瑞', '多糖结合疫苗', 4, 60, 2, '0.5ml/支', '预防肺炎球菌感染。', '发热、局部红肿较常见。', 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine` VALUES (10, '轮状病毒疫苗', NULL, 'CLASS_II', '兰州生物', '减毒活疫苗', 3, 28, 2, '1.5ml/支', '预防轮状病毒肠炎。', '偶见发热、腹泻。', 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for vaccine_batch
-- ----------------------------
DROP TABLE IF EXISTS `vaccine_batch`;
CREATE TABLE `vaccine_batch`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vaccine_id` bigint NOT NULL COMMENT '疫苗ID',
  `batch_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '批号',
  `production_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `expiry_date` date NOT NULL COMMENT '有效期至',
  `stock` int NOT NULL DEFAULT 0 COMMENT '可用库存',
  `warning_days` int NOT NULL DEFAULT 30 COMMENT '临期预警天数',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0正常 1临期 2过期 3已销毁',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_vaccine_id`(`vaccine_id` ASC) USING BTREE,
  INDEX `idx_expiry_date`(`expiry_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_fefo`(`vaccine_id` ASC, `stock` ASC, `expiry_date` ASC) USING BTREE,
  CONSTRAINT `fk_batch_vaccine` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccine` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '疫苗批次表（FEFO 分配）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vaccine_batch（与 vaccine 表联动，vaccine_id 对应 vaccine.id）
-- ----------------------------
INSERT INTO `vaccine_batch` (`id`, `vaccine_id`, `batch_no`, `production_date`, `expiry_date`, `stock`, `warning_days`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'HBV202501001', '2025-01-10', '2027-01-10', 100, 30, 0, NOW(), NOW()),
(2, 1, 'HBV202506002', '2025-06-01', '2027-06-01', 80, 30, 0, NOW(), NOW()),
(3, 2, 'BCG202502001', '2025-02-15', '2026-08-15', 50, 30, 0, NOW(), NOW()),
(4, 3, 'IPV202503001', '2025-03-01', '2027-03-01', 120, 30, 0, NOW(), NOW()),
(5, 4, 'DTP202504001', '2025-04-10', '2027-04-10', 90, 30, 0, NOW(), NOW()),
(6, 4, 'DTP202508002', '2025-08-01', '2027-08-01', 60, 30, 0, NOW(), NOW()),
(7, 5, 'MMR202505001', '2025-05-20', '2027-05-20', 70, 30, 0, NOW(), NOW()),
(8, 6, 'FLU202509001', '2025-09-01', '2026-09-01', 200, 30, 0, NOW(), NOW()),
(9, 7, 'VAR202506001', '2025-06-15', '2027-06-15', 40, 30, 0, NOW(), NOW()),
(10, 10, 'ROT202507001', '2025-07-01', '2026-07-01', 85, 30, 0, NOW(), NOW());

-- ----------------------------
-- Table structure for vaccine_batch_disposal
-- ----------------------------
DROP TABLE IF EXISTS `vaccine_batch_disposal`;
CREATE TABLE `vaccine_batch_disposal`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `batch_id` bigint NOT NULL COMMENT '批次ID',
  `disposal_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '销毁原因',
  `disposal_date` date NOT NULL COMMENT '销毁日期',
  `operator_id` bigint NULL DEFAULT NULL COMMENT '操作人ID',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_batch_id`(`batch_id` ASC) USING BTREE,
  INDEX `fk_disposal_operator`(`operator_id` ASC) USING BTREE,
  CONSTRAINT `fk_disposal_batch` FOREIGN KEY (`batch_id`) REFERENCES `vaccine_batch` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_disposal_operator` FOREIGN KEY (`operator_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '批次销毁记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vaccine_batch_disposal
-- ----------------------------

-- ----------------------------
-- Table structure for vaccine_inventory
-- ----------------------------
DROP TABLE IF EXISTS `vaccine_inventory`;
CREATE TABLE `vaccine_inventory`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vaccine_id` bigint NOT NULL COMMENT '疫苗ID',
  `site_id` bigint NOT NULL COMMENT '接种点ID',
  `batch_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '批次号',
  `quantity` int NOT NULL DEFAULT 0 COMMENT '入库数量',
  `used_quantity` int NOT NULL DEFAULT 0 COMMENT '已使用数量',
  `expiry_date` date NOT NULL COMMENT '有效期至',
  `storage_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '存放位置',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-停用，1-有效',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_vaccine_id`(`vaccine_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_batch_no`(`batch_no` ASC) USING BTREE,
  INDEX `idx_expiry_date`(`expiry_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_inventory_site` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_inventory_vaccine` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccine` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '疫苗库存表（按批次）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vaccine_inventory
-- ----------------------------
INSERT INTO `vaccine_inventory` VALUES (1, 1, 1, 'HBV202501001', 100, 0, '2026-06-01', 'A区1号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (2, 2, 1, 'BCG202501001', 80, 0, '2026-03-01', 'A区2号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (3, 3, 1, 'PV202501001', 120, 0, '2026-05-01', 'A区1号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (4, 4, 1, 'DPT202501001', 90, 0, '2026-04-01', 'A区2号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (5, 5, 1, 'MMR202501001', 70, 0, '2026-02-01', 'A区1号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (6, 6, 2, 'FLU202502001', 60, 0, '2025-08-01', 'B区1号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (7, 7, 2, 'VAR202502001', 50, 0, '2026-07-01', 'B区2号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (8, 8, 2, 'EV71202502001', 80, 0, '2026-06-01', 'B区1号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (9, 9, 2, 'PCV202502001', 40, 0, '2026-08-01', 'B区2号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_inventory` VALUES (10, 10, 2, 'ROT202502001', 55, 0, '2026-04-01', 'B区1号冰箱', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');

-- ----------------------------
-- Table structure for vaccine_site_stock
-- ----------------------------
DROP TABLE IF EXISTS `vaccine_site_stock`;
CREATE TABLE `vaccine_site_stock`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vaccine_id` bigint NOT NULL COMMENT '疫苗ID',
  `site_id` bigint NOT NULL COMMENT '接种点ID',
  `stock` int NOT NULL DEFAULT 0 COMMENT '当前可用库存',
  `warning_threshold` int NOT NULL DEFAULT 10 COMMENT '库存预警阈值',
  `version` int NOT NULL DEFAULT 0 COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_vaccine_site`(`vaccine_id` ASC, `site_id` ASC) USING BTREE,
  INDEX `idx_vaccine_id`(`vaccine_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_stock`(`stock` ASC) USING BTREE,
  CONSTRAINT `fk_stock_site` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_stock_vaccine` FOREIGN KEY (`vaccine_id`) REFERENCES `vaccine` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '疫苗按接种点库存（乐观锁）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vaccine_site_stock
-- ----------------------------
INSERT INTO `vaccine_site_stock` VALUES (2, 2, 1, 31, 10, 0, '2026-02-11 23:03:22', '2026-02-25 15:34:42');
INSERT INTO `vaccine_site_stock` VALUES (3, 3, 1, 39, 10, 0, '2026-02-11 23:03:22', '2026-02-24 10:01:30');
INSERT INTO `vaccine_site_stock` VALUES (4, 4, 1, 35, 10, 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_site_stock` VALUES (5, 5, 1, 25, 10, 0, '2026-02-11 23:03:22', '2026-02-12 19:13:43');
INSERT INTO `vaccine_site_stock` VALUES (6, 6, 1, 60, 10, 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_site_stock` VALUES (7, 7, 1, 45, 10, 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_site_stock` VALUES (8, 8, 1, 50, 10, 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_site_stock` VALUES (9, 9, 1, 33, 10, 0, '2026-02-11 23:03:22', '2026-02-24 15:59:14');
INSERT INTO `vaccine_site_stock` VALUES (10, 10, 1, 40, 10, 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `vaccine_site_stock` VALUES (11, 1, 4, 10, 10, 1, '2026-02-12 19:12:50', '2026-02-12 19:13:12');
INSERT INTO `vaccine_site_stock` VALUES (12, 4, 4, 10, 10, 0, '2026-02-12 19:12:59', '2026-02-12 19:12:59');
INSERT INTO `vaccine_site_stock` VALUES (13, 1, 1, 25, 10, 1, '2026-02-24 09:34:34', '2026-02-24 17:41:44');
INSERT INTO `vaccine_site_stock` VALUES (14, 1, 2, 10, 10, 0, '2026-02-24 11:06:31', '2026-02-24 11:06:31');
INSERT INTO `vaccine_site_stock` VALUES (15, 2, 2, 10, 10, 0, '2026-02-24 11:06:35', '2026-02-24 11:06:35');
INSERT INTO `vaccine_site_stock` VALUES (16, 7, 2, 10, 10, 0, '2026-02-24 11:06:38', '2026-02-24 11:06:38');
INSERT INTO `vaccine_site_stock` VALUES (17, 5, 2, 10, 10, 0, '2026-02-24 11:06:41', '2026-02-24 11:06:41');
INSERT INTO `vaccine_site_stock` VALUES (18, 9, 4, 21, 10, 0, '2026-02-24 15:59:37', '2026-02-24 15:59:44');

-- ----------------------------
-- 库存联动架构增强：接种点批次库存 + 调拨日志（总仓 -> 接种点 -> 接种记录）
-- ----------------------------
-- Table structure for site_vaccine_stock（接种点库存，按批次）
-- ----------------------------
DROP TABLE IF EXISTS `site_vaccine_stock`;
CREATE TABLE `site_vaccine_stock`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` bigint NOT NULL COMMENT '接种点ID',
  `batch_id` bigint NOT NULL COMMENT '疫苗批次ID',
  `available_stock` int NOT NULL DEFAULT 0 COMMENT '可用库存（可被预约锁定）',
  `locked_stock` int NOT NULL DEFAULT 0 COMMENT '预约锁定库存（已预约未核销）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_site_batch`(`site_id` ASC, `batch_id` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_batch_id`(`batch_id` ASC) USING BTREE,
  CONSTRAINT `fk_svs_site` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_svs_batch` FOREIGN KEY (`batch_id`) REFERENCES `vaccine_batch` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '接种点库存（按批次，与总仓调拨联动）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for stock_transfer_log（调拨日志）
-- ----------------------------
DROP TABLE IF EXISTS `stock_transfer_log`;
CREATE TABLE `stock_transfer_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `batch_id` bigint NOT NULL COMMENT '批次ID',
  `from_type` tinyint NOT NULL COMMENT '调出方类型：0-总仓 1-接种点',
  `from_id` bigint NULL DEFAULT NULL COMMENT '调出方ID（总仓时为NULL，接种点时为 site_id）',
  `to_type` tinyint NOT NULL COMMENT '调入方类型：0-总仓 1-接种点',
  `to_id` bigint NULL DEFAULT NULL COMMENT '调入方ID（总仓时为NULL，接种点时为 site_id）',
  `quantity` int NOT NULL COMMENT '调拨数量',
  `operator_id` bigint NULL DEFAULT NULL COMMENT '操作人用户ID',
  `transfer_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '调拨时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_batch_id`(`batch_id` ASC) USING BTREE,
  INDEX `idx_from`(`from_type` ASC, `from_id` ASC) USING BTREE,
  INDEX `idx_to`(`to_type` ASC, `to_id` ASC) USING BTREE,
  INDEX `idx_transfer_time`(`transfer_time` ASC) USING BTREE,
  CONSTRAINT `fk_stl_batch` FOREIGN KEY (`batch_id`) REFERENCES `vaccine_batch` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '库存调拨日志' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
