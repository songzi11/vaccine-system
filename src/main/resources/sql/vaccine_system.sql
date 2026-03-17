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

 Date: 05/03/2026 11:02:32
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
  `observe_duration` int NULL DEFAULT 30 COMMENT '留观时长（分钟，医生核销时设置，默认30分钟）',
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
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '预约单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of appointment
-- ----------------------------
INSERT INTO `appointment` VALUES (18, 8, 12, 3, 4, 1, 1130, '2026-02-27', '09:45-10:00', 2, 2, NULL, '2026-02-27 17:09:38', 30, '2026-02-27 15:47:20', '2026-02-27 15:47:20');

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '儿童档案表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of child_profile
-- ----------------------------
INSERT INTO `child_profile` VALUES (1, 4, '李小宝', '2023-05-10', 1, NULL, 'TJNK20230001', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (2, 4, '李二宝', '2024-01-20', 2, '鸡蛋过敏', 'TJNK20240002', '2026-02-11 23:03:22', '2026-02-24 17:55:58');
INSERT INTO `child_profile` VALUES (6, 5, '赵小明', '2023-02-14', 1, NULL, 'TJNK20230006', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (7, 5, '赵小红', '2023-07-20', 2, NULL, 'TJNK20230007', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (8, 5, '赵小刚', '2024-05-01', 1, '青霉素过敏', 'TJNK20240008', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (9, 5, '赵小丽', '2022-12-25', 2, NULL, 'TJNK20220009', '2026-02-11 23:03:22', '2026-02-11 23:03:22');
INSERT INTO `child_profile` VALUES (12, 8, '孙悟空', '2025-02-27', 1, NULL, '123456', '2026-02-27 15:47:07', '2026-02-27 15:47:07');

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
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '医生调遣申请表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `doctor_dispatch` VALUES (15, 2, 2, 1, 1, '2026-02-24 10:34:08', '2026-02-24 10:34:45');
INSERT INTO `doctor_dispatch` VALUES (17, 2, 2, 1, 1, '2026-02-24 11:30:55', '2026-02-24 11:31:22');
INSERT INTO `doctor_dispatch` VALUES (19, 2, 2, 1, 1, '2026-02-24 15:57:50', '2026-02-24 17:11:17');
INSERT INTO `doctor_dispatch` VALUES (22, 7, 1, 3, 0, '2026-02-25 15:36:50', NULL);
INSERT INTO `doctor_dispatch` VALUES (24, 2, 2, 1, 1, '2026-02-25 16:29:26', '2026-02-27 13:49:10');
INSERT INTO `doctor_dispatch` VALUES (25, 2, 1, 1, 1, '2026-02-26 14:26:12', '2026-02-27 13:49:09');
INSERT INTO `doctor_dispatch` VALUES (26, 7, 3, 3, 0, '2026-02-26 14:26:37', NULL);
INSERT INTO `doctor_dispatch` VALUES (27, 7, 3, 2, 0, '2026-02-26 14:26:47', NULL);

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
INSERT INTO `doctor_schedule` VALUES (2, 2, 1, '2026-03-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4, 7, 2, '2026-03-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (8, 2, 1, '2026-03-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (10, 7, 2, '2026-03-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (14, 2, 1, '2026-03-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (16, 7, 2, '2026-03-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (20, 2, 1, '2026-03-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (22, 7, 2, '2026-03-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (26, 2, 1, '2026-03-23', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (28, 7, 2, '2026-03-23', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (32, 2, 1, '2026-03-20', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (34, 7, 2, '2026-03-20', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (38, 2, 1, '2026-03-19', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (40, 7, 2, '2026-03-19', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (44, 2, 1, '2026-03-18', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (46, 7, 2, '2026-03-18', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (50, 2, 1, '2026-03-17', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (52, 7, 2, '2026-03-17', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (56, 2, 1, '2026-03-16', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (58, 7, 2, '2026-03-16', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (62, 2, 1, '2026-03-13', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (64, 7, 2, '2026-03-13', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (68, 2, 1, '2026-03-12', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (70, 7, 2, '2026-03-12', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (74, 2, 1, '2026-03-11', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (76, 7, 2, '2026-03-11', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (80, 2, 1, '2026-03-10', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (82, 7, 2, '2026-03-10', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (86, 2, 1, '2026-03-09', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (88, 7, 2, '2026-03-09', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (92, 2, 1, '2026-03-06', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (94, 7, 2, '2026-03-06', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (98, 2, 1, '2026-03-05', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (100, 7, 2, '2026-03-05', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (104, 2, 1, '2026-03-04', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (106, 7, 2, '2026-03-04', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (110, 2, 1, '2026-03-03', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (112, 7, 2, '2026-03-03', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (116, 2, 1, '2026-03-02', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (118, 7, 2, '2026-03-02', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (122, 2, 1, '2026-02-27', '08:00-08:15', 5, 1, 1, '2026-02-25 10:44:49', '2026-02-27 11:43:56');
INSERT INTO `doctor_schedule` VALUES (124, 7, 2, '2026-02-27', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (128, 2, 1, '2026-02-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (130, 7, 2, '2026-02-26', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (134, 2, 1, '2026-02-25', '08:00-08:15', 5, 1, 1, '2026-02-25 10:44:49', '2026-02-25 15:10:57');
INSERT INTO `doctor_schedule` VALUES (136, 7, 2, '2026-02-25', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (140, 2, 1, '2026-02-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (142, 7, 2, '2026-02-24', '08:00-08:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (146, 2, 1, '2026-03-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (148, 7, 2, '2026-03-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (152, 2, 1, '2026-03-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (154, 7, 2, '2026-03-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (158, 2, 1, '2026-03-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (160, 7, 2, '2026-03-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (164, 2, 1, '2026-03-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (166, 7, 2, '2026-03-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (170, 2, 1, '2026-03-23', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (172, 7, 2, '2026-03-23', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (176, 2, 1, '2026-03-20', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (178, 7, 2, '2026-03-20', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (182, 2, 1, '2026-03-19', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (184, 7, 2, '2026-03-19', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (188, 2, 1, '2026-03-18', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (190, 7, 2, '2026-03-18', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (194, 2, 1, '2026-03-17', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (196, 7, 2, '2026-03-17', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (200, 2, 1, '2026-03-16', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (202, 7, 2, '2026-03-16', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (206, 2, 1, '2026-03-13', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (208, 7, 2, '2026-03-13', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (212, 2, 1, '2026-03-12', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (214, 7, 2, '2026-03-12', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (218, 2, 1, '2026-03-11', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (220, 7, 2, '2026-03-11', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (224, 2, 1, '2026-03-10', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (226, 7, 2, '2026-03-10', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (230, 2, 1, '2026-03-09', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (232, 7, 2, '2026-03-09', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (236, 2, 1, '2026-03-06', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (238, 7, 2, '2026-03-06', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (242, 2, 1, '2026-03-05', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (244, 7, 2, '2026-03-05', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (248, 2, 1, '2026-03-04', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (250, 7, 2, '2026-03-04', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (254, 2, 1, '2026-03-03', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (256, 7, 2, '2026-03-03', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (260, 2, 1, '2026-03-02', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (262, 7, 2, '2026-03-02', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (266, 2, 1, '2026-02-27', '08:15-08:30', 5, 1, 1, '2026-02-25 10:44:49', '2026-02-27 11:32:25');
INSERT INTO `doctor_schedule` VALUES (268, 7, 2, '2026-02-27', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (272, 2, 1, '2026-02-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (274, 7, 2, '2026-02-26', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (278, 2, 1, '2026-02-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (280, 7, 2, '2026-02-25', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (284, 2, 1, '2026-02-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (286, 7, 2, '2026-02-24', '08:15-08:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (290, 2, 1, '2026-03-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (292, 7, 2, '2026-03-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (296, 2, 1, '2026-03-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (298, 7, 2, '2026-03-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (302, 2, 1, '2026-03-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (304, 7, 2, '2026-03-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (308, 2, 1, '2026-03-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (310, 7, 2, '2026-03-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (314, 2, 1, '2026-03-23', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (316, 7, 2, '2026-03-23', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (320, 2, 1, '2026-03-20', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (322, 7, 2, '2026-03-20', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (326, 2, 1, '2026-03-19', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (328, 7, 2, '2026-03-19', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (332, 2, 1, '2026-03-18', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (334, 7, 2, '2026-03-18', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (338, 2, 1, '2026-03-17', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (340, 7, 2, '2026-03-17', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (344, 2, 1, '2026-03-16', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (346, 7, 2, '2026-03-16', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (350, 2, 1, '2026-03-13', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (352, 7, 2, '2026-03-13', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (356, 2, 1, '2026-03-12', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (358, 7, 2, '2026-03-12', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (362, 2, 1, '2026-03-11', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (364, 7, 2, '2026-03-11', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (368, 2, 1, '2026-03-10', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (370, 7, 2, '2026-03-10', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (374, 2, 1, '2026-03-09', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (376, 7, 2, '2026-03-09', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (380, 2, 1, '2026-03-06', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (382, 7, 2, '2026-03-06', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (386, 2, 1, '2026-03-05', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (388, 7, 2, '2026-03-05', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (392, 2, 1, '2026-03-04', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (394, 7, 2, '2026-03-04', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (398, 2, 1, '2026-03-03', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (400, 7, 2, '2026-03-03', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (404, 2, 1, '2026-03-02', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (406, 7, 2, '2026-03-02', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (410, 2, 1, '2026-02-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (412, 7, 2, '2026-02-27', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (416, 2, 1, '2026-02-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (418, 7, 2, '2026-02-26', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (422, 2, 1, '2026-02-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (424, 7, 2, '2026-02-25', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (428, 2, 1, '2026-02-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (430, 7, 2, '2026-02-24', '08:30-08:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (434, 2, 1, '2026-03-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (436, 7, 2, '2026-03-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (440, 2, 1, '2026-03-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (442, 7, 2, '2026-03-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (446, 2, 1, '2026-03-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (448, 7, 2, '2026-03-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (452, 2, 1, '2026-03-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (454, 7, 2, '2026-03-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (458, 2, 1, '2026-03-23', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (460, 7, 2, '2026-03-23', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (464, 2, 1, '2026-03-20', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (466, 7, 2, '2026-03-20', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (470, 2, 1, '2026-03-19', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (472, 7, 2, '2026-03-19', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (476, 2, 1, '2026-03-18', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (478, 7, 2, '2026-03-18', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (482, 2, 1, '2026-03-17', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (484, 7, 2, '2026-03-17', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (488, 2, 1, '2026-03-16', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (490, 7, 2, '2026-03-16', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (494, 2, 1, '2026-03-13', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (496, 7, 2, '2026-03-13', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (500, 2, 1, '2026-03-12', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (502, 7, 2, '2026-03-12', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (506, 2, 1, '2026-03-11', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (508, 7, 2, '2026-03-11', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (512, 2, 1, '2026-03-10', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (514, 7, 2, '2026-03-10', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (518, 2, 1, '2026-03-09', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (520, 7, 2, '2026-03-09', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (524, 2, 1, '2026-03-06', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (526, 7, 2, '2026-03-06', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (530, 2, 1, '2026-03-05', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (532, 7, 2, '2026-03-05', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (536, 2, 1, '2026-03-04', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (538, 7, 2, '2026-03-04', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (542, 2, 1, '2026-03-03', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (544, 7, 2, '2026-03-03', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (548, 2, 1, '2026-03-02', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (550, 7, 2, '2026-03-02', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (554, 2, 1, '2026-02-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (556, 7, 2, '2026-02-27', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (560, 2, 1, '2026-02-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (562, 7, 2, '2026-02-26', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (566, 2, 1, '2026-02-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (568, 7, 2, '2026-02-25', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (572, 2, 1, '2026-02-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (574, 7, 2, '2026-02-24', '08:45-09:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (578, 2, 1, '2026-03-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (580, 7, 2, '2026-03-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (584, 2, 1, '2026-03-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (586, 7, 2, '2026-03-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (590, 2, 1, '2026-03-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (592, 7, 2, '2026-03-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (596, 2, 1, '2026-03-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (598, 7, 2, '2026-03-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (602, 2, 1, '2026-03-23', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (604, 7, 2, '2026-03-23', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (608, 2, 1, '2026-03-20', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (610, 7, 2, '2026-03-20', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (614, 2, 1, '2026-03-19', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (616, 7, 2, '2026-03-19', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (620, 2, 1, '2026-03-18', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (622, 7, 2, '2026-03-18', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (626, 2, 1, '2026-03-17', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (628, 7, 2, '2026-03-17', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (632, 2, 1, '2026-03-16', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (634, 7, 2, '2026-03-16', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (638, 2, 1, '2026-03-13', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (640, 7, 2, '2026-03-13', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (644, 2, 1, '2026-03-12', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (646, 7, 2, '2026-03-12', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (650, 2, 1, '2026-03-11', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (652, 7, 2, '2026-03-11', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (656, 2, 1, '2026-03-10', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (658, 7, 2, '2026-03-10', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (662, 2, 1, '2026-03-09', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (664, 7, 2, '2026-03-09', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (668, 2, 1, '2026-03-06', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (670, 7, 2, '2026-03-06', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (674, 2, 1, '2026-03-05', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (676, 7, 2, '2026-03-05', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (680, 2, 1, '2026-03-04', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (682, 7, 2, '2026-03-04', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (686, 2, 1, '2026-03-03', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (688, 7, 2, '2026-03-03', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (692, 2, 1, '2026-03-02', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (694, 7, 2, '2026-03-02', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (698, 2, 1, '2026-02-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (700, 7, 2, '2026-02-27', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (704, 2, 1, '2026-02-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (706, 7, 2, '2026-02-26', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (710, 2, 1, '2026-02-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (712, 7, 2, '2026-02-25', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (716, 2, 1, '2026-02-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (718, 7, 2, '2026-02-24', '09:00-09:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (722, 2, 1, '2026-03-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (724, 7, 2, '2026-03-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (728, 2, 1, '2026-03-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (730, 7, 2, '2026-03-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (734, 2, 1, '2026-03-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (736, 7, 2, '2026-03-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (740, 2, 1, '2026-03-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (742, 7, 2, '2026-03-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (746, 2, 1, '2026-03-23', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (748, 7, 2, '2026-03-23', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (752, 2, 1, '2026-03-20', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (754, 7, 2, '2026-03-20', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (758, 2, 1, '2026-03-19', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (760, 7, 2, '2026-03-19', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (764, 2, 1, '2026-03-18', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (766, 7, 2, '2026-03-18', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (770, 2, 1, '2026-03-17', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (772, 7, 2, '2026-03-17', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (776, 2, 1, '2026-03-16', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (778, 7, 2, '2026-03-16', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (782, 2, 1, '2026-03-13', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (784, 7, 2, '2026-03-13', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (788, 2, 1, '2026-03-12', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (790, 7, 2, '2026-03-12', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (794, 2, 1, '2026-03-11', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (796, 7, 2, '2026-03-11', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (800, 2, 1, '2026-03-10', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (802, 7, 2, '2026-03-10', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (806, 2, 1, '2026-03-09', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (808, 7, 2, '2026-03-09', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (812, 2, 1, '2026-03-06', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (814, 7, 2, '2026-03-06', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (818, 2, 1, '2026-03-05', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (820, 7, 2, '2026-03-05', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (824, 2, 1, '2026-03-04', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (826, 7, 2, '2026-03-04', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (830, 2, 1, '2026-03-03', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (832, 7, 2, '2026-03-03', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (836, 2, 1, '2026-03-02', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (838, 7, 2, '2026-03-02', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (842, 2, 1, '2026-02-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (844, 7, 2, '2026-02-27', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (848, 2, 1, '2026-02-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (850, 7, 2, '2026-02-26', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (854, 2, 1, '2026-02-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (856, 7, 2, '2026-02-25', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (860, 2, 1, '2026-02-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (862, 7, 2, '2026-02-24', '09:15-09:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (866, 2, 1, '2026-03-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (868, 7, 2, '2026-03-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (872, 2, 1, '2026-03-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (874, 7, 2, '2026-03-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (878, 2, 1, '2026-03-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (880, 7, 2, '2026-03-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (884, 2, 1, '2026-03-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (886, 7, 2, '2026-03-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (890, 2, 1, '2026-03-23', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (892, 7, 2, '2026-03-23', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (896, 2, 1, '2026-03-20', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (898, 7, 2, '2026-03-20', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (902, 2, 1, '2026-03-19', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (904, 7, 2, '2026-03-19', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (908, 2, 1, '2026-03-18', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (910, 7, 2, '2026-03-18', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (914, 2, 1, '2026-03-17', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (916, 7, 2, '2026-03-17', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (920, 2, 1, '2026-03-16', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (922, 7, 2, '2026-03-16', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (926, 2, 1, '2026-03-13', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (928, 7, 2, '2026-03-13', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (932, 2, 1, '2026-03-12', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (934, 7, 2, '2026-03-12', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (938, 2, 1, '2026-03-11', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (940, 7, 2, '2026-03-11', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (944, 2, 1, '2026-03-10', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (946, 7, 2, '2026-03-10', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (950, 2, 1, '2026-03-09', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (952, 7, 2, '2026-03-09', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (956, 2, 1, '2026-03-06', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (958, 7, 2, '2026-03-06', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (962, 2, 1, '2026-03-05', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (964, 7, 2, '2026-03-05', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (968, 2, 1, '2026-03-04', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (970, 7, 2, '2026-03-04', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (974, 2, 1, '2026-03-03', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (976, 7, 2, '2026-03-03', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (980, 2, 1, '2026-03-02', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (982, 7, 2, '2026-03-02', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (986, 2, 1, '2026-02-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (988, 7, 2, '2026-02-27', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (992, 2, 1, '2026-02-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (994, 7, 2, '2026-02-26', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (998, 2, 1, '2026-02-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1000, 7, 2, '2026-02-25', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1004, 2, 1, '2026-02-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1006, 7, 2, '2026-02-24', '09:30-09:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1010, 2, 1, '2026-03-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1012, 7, 2, '2026-03-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1016, 2, 1, '2026-03-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1018, 7, 2, '2026-03-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1022, 2, 1, '2026-03-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1024, 7, 2, '2026-03-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1028, 2, 1, '2026-03-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1030, 7, 2, '2026-03-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1034, 2, 1, '2026-03-23', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1036, 7, 2, '2026-03-23', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1040, 2, 1, '2026-03-20', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1042, 7, 2, '2026-03-20', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1046, 2, 1, '2026-03-19', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1048, 7, 2, '2026-03-19', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1052, 2, 1, '2026-03-18', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1054, 7, 2, '2026-03-18', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1058, 2, 1, '2026-03-17', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1060, 7, 2, '2026-03-17', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1064, 2, 1, '2026-03-16', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1066, 7, 2, '2026-03-16', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1070, 2, 1, '2026-03-13', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1072, 7, 2, '2026-03-13', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1076, 2, 1, '2026-03-12', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1078, 7, 2, '2026-03-12', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1082, 2, 1, '2026-03-11', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1084, 7, 2, '2026-03-11', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1088, 2, 1, '2026-03-10', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1090, 7, 2, '2026-03-10', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1094, 2, 1, '2026-03-09', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1096, 7, 2, '2026-03-09', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1100, 2, 1, '2026-03-06', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1102, 7, 2, '2026-03-06', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1106, 2, 1, '2026-03-05', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1108, 7, 2, '2026-03-05', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1112, 2, 1, '2026-03-04', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1114, 7, 2, '2026-03-04', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1118, 2, 1, '2026-03-03', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1120, 7, 2, '2026-03-03', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1124, 2, 1, '2026-03-02', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1126, 7, 2, '2026-03-02', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1130, 2, 1, '2026-02-27', '09:45-10:00', 5, 1, 1, '2026-02-25 10:44:49', '2026-02-27 15:47:20');
INSERT INTO `doctor_schedule` VALUES (1132, 7, 2, '2026-02-27', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1136, 2, 1, '2026-02-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1138, 7, 2, '2026-02-26', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1142, 2, 1, '2026-02-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1144, 7, 2, '2026-02-25', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1148, 2, 1, '2026-02-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1150, 7, 2, '2026-02-24', '09:45-10:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1154, 2, 1, '2026-03-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1156, 7, 2, '2026-03-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1160, 2, 1, '2026-03-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1162, 7, 2, '2026-03-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1166, 2, 1, '2026-03-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1168, 7, 2, '2026-03-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1172, 2, 1, '2026-03-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1174, 7, 2, '2026-03-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1178, 2, 1, '2026-03-23', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1180, 7, 2, '2026-03-23', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1184, 2, 1, '2026-03-20', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1186, 7, 2, '2026-03-20', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1190, 2, 1, '2026-03-19', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1192, 7, 2, '2026-03-19', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1196, 2, 1, '2026-03-18', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1198, 7, 2, '2026-03-18', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1202, 2, 1, '2026-03-17', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1204, 7, 2, '2026-03-17', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1208, 2, 1, '2026-03-16', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1210, 7, 2, '2026-03-16', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1214, 2, 1, '2026-03-13', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1216, 7, 2, '2026-03-13', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1220, 2, 1, '2026-03-12', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1222, 7, 2, '2026-03-12', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1226, 2, 1, '2026-03-11', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1228, 7, 2, '2026-03-11', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1232, 2, 1, '2026-03-10', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1234, 7, 2, '2026-03-10', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1238, 2, 1, '2026-03-09', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1240, 7, 2, '2026-03-09', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1244, 2, 1, '2026-03-06', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1246, 7, 2, '2026-03-06', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1250, 2, 1, '2026-03-05', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1252, 7, 2, '2026-03-05', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1256, 2, 1, '2026-03-04', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1258, 7, 2, '2026-03-04', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1262, 2, 1, '2026-03-03', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1264, 7, 2, '2026-03-03', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1268, 2, 1, '2026-03-02', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1270, 7, 2, '2026-03-02', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1274, 2, 1, '2026-02-27', '10:00-10:15', 5, 1, 1, '2026-02-25 10:44:49', '2026-02-27 14:00:12');
INSERT INTO `doctor_schedule` VALUES (1276, 7, 2, '2026-02-27', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1280, 2, 1, '2026-02-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1282, 7, 2, '2026-02-26', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1286, 2, 1, '2026-02-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1288, 7, 2, '2026-02-25', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1292, 2, 1, '2026-02-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1294, 7, 2, '2026-02-24', '10:00-10:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1298, 2, 1, '2026-03-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1300, 7, 2, '2026-03-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1304, 2, 1, '2026-03-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1306, 7, 2, '2026-03-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1310, 2, 1, '2026-03-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1312, 7, 2, '2026-03-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1316, 2, 1, '2026-03-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1318, 7, 2, '2026-03-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1322, 2, 1, '2026-03-23', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1324, 7, 2, '2026-03-23', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1328, 2, 1, '2026-03-20', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1330, 7, 2, '2026-03-20', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1334, 2, 1, '2026-03-19', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1336, 7, 2, '2026-03-19', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1340, 2, 1, '2026-03-18', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1342, 7, 2, '2026-03-18', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1346, 2, 1, '2026-03-17', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1348, 7, 2, '2026-03-17', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1352, 2, 1, '2026-03-16', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1354, 7, 2, '2026-03-16', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1358, 2, 1, '2026-03-13', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1360, 7, 2, '2026-03-13', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1364, 2, 1, '2026-03-12', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1366, 7, 2, '2026-03-12', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1370, 2, 1, '2026-03-11', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1372, 7, 2, '2026-03-11', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1376, 2, 1, '2026-03-10', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1378, 7, 2, '2026-03-10', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1382, 2, 1, '2026-03-09', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1384, 7, 2, '2026-03-09', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1388, 2, 1, '2026-03-06', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1390, 7, 2, '2026-03-06', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1394, 2, 1, '2026-03-05', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1396, 7, 2, '2026-03-05', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1400, 2, 1, '2026-03-04', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1402, 7, 2, '2026-03-04', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1406, 2, 1, '2026-03-03', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1408, 7, 2, '2026-03-03', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1412, 2, 1, '2026-03-02', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1414, 7, 2, '2026-03-02', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1418, 2, 1, '2026-02-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1420, 7, 2, '2026-02-27', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1424, 2, 1, '2026-02-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1426, 7, 2, '2026-02-26', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1430, 2, 1, '2026-02-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1432, 7, 2, '2026-02-25', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1436, 2, 1, '2026-02-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1438, 7, 2, '2026-02-24', '10:15-10:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1442, 2, 1, '2026-03-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1444, 7, 2, '2026-03-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1448, 2, 1, '2026-03-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1450, 7, 2, '2026-03-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1454, 2, 1, '2026-03-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1456, 7, 2, '2026-03-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1460, 2, 1, '2026-03-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1462, 7, 2, '2026-03-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1466, 2, 1, '2026-03-23', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1468, 7, 2, '2026-03-23', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1472, 2, 1, '2026-03-20', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1474, 7, 2, '2026-03-20', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1478, 2, 1, '2026-03-19', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1480, 7, 2, '2026-03-19', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1484, 2, 1, '2026-03-18', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1486, 7, 2, '2026-03-18', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1490, 2, 1, '2026-03-17', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1492, 7, 2, '2026-03-17', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1496, 2, 1, '2026-03-16', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1498, 7, 2, '2026-03-16', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1502, 2, 1, '2026-03-13', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1504, 7, 2, '2026-03-13', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1508, 2, 1, '2026-03-12', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1510, 7, 2, '2026-03-12', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1514, 2, 1, '2026-03-11', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1516, 7, 2, '2026-03-11', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1520, 2, 1, '2026-03-10', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1522, 7, 2, '2026-03-10', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1526, 2, 1, '2026-03-09', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1528, 7, 2, '2026-03-09', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1532, 2, 1, '2026-03-06', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1534, 7, 2, '2026-03-06', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1538, 2, 1, '2026-03-05', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1540, 7, 2, '2026-03-05', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1544, 2, 1, '2026-03-04', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1546, 7, 2, '2026-03-04', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1550, 2, 1, '2026-03-03', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1552, 7, 2, '2026-03-03', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1556, 2, 1, '2026-03-02', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1558, 7, 2, '2026-03-02', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1562, 2, 1, '2026-02-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1564, 7, 2, '2026-02-27', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1568, 2, 1, '2026-02-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1570, 7, 2, '2026-02-26', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1574, 2, 1, '2026-02-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1576, 7, 2, '2026-02-25', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1580, 2, 1, '2026-02-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1582, 7, 2, '2026-02-24', '10:30-10:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1586, 2, 1, '2026-03-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1588, 7, 2, '2026-03-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1592, 2, 1, '2026-03-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1594, 7, 2, '2026-03-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1598, 2, 1, '2026-03-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1600, 7, 2, '2026-03-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1604, 2, 1, '2026-03-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1606, 7, 2, '2026-03-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1610, 2, 1, '2026-03-23', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1612, 7, 2, '2026-03-23', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1616, 2, 1, '2026-03-20', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1618, 7, 2, '2026-03-20', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1622, 2, 1, '2026-03-19', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1624, 7, 2, '2026-03-19', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1628, 2, 1, '2026-03-18', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1630, 7, 2, '2026-03-18', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1634, 2, 1, '2026-03-17', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1636, 7, 2, '2026-03-17', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1640, 2, 1, '2026-03-16', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1642, 7, 2, '2026-03-16', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1646, 2, 1, '2026-03-13', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1648, 7, 2, '2026-03-13', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1652, 2, 1, '2026-03-12', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1654, 7, 2, '2026-03-12', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1658, 2, 1, '2026-03-11', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1660, 7, 2, '2026-03-11', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1664, 2, 1, '2026-03-10', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1666, 7, 2, '2026-03-10', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1670, 2, 1, '2026-03-09', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1672, 7, 2, '2026-03-09', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1676, 2, 1, '2026-03-06', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1678, 7, 2, '2026-03-06', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1682, 2, 1, '2026-03-05', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1684, 7, 2, '2026-03-05', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1688, 2, 1, '2026-03-04', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1690, 7, 2, '2026-03-04', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1694, 2, 1, '2026-03-03', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1696, 7, 2, '2026-03-03', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1700, 2, 1, '2026-03-02', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1702, 7, 2, '2026-03-02', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1706, 2, 1, '2026-02-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1708, 7, 2, '2026-02-27', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1712, 2, 1, '2026-02-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1714, 7, 2, '2026-02-26', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1718, 2, 1, '2026-02-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1720, 7, 2, '2026-02-25', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1724, 2, 1, '2026-02-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1726, 7, 2, '2026-02-24', '10:45-11:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1730, 2, 1, '2026-03-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1732, 7, 2, '2026-03-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1736, 2, 1, '2026-03-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1738, 7, 2, '2026-03-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1742, 2, 1, '2026-03-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1744, 7, 2, '2026-03-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1748, 2, 1, '2026-03-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1750, 7, 2, '2026-03-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1754, 2, 1, '2026-03-23', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1756, 7, 2, '2026-03-23', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1760, 2, 1, '2026-03-20', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1762, 7, 2, '2026-03-20', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1766, 2, 1, '2026-03-19', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1768, 7, 2, '2026-03-19', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1772, 2, 1, '2026-03-18', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1774, 7, 2, '2026-03-18', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1778, 2, 1, '2026-03-17', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1780, 7, 2, '2026-03-17', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1784, 2, 1, '2026-03-16', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1786, 7, 2, '2026-03-16', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1790, 2, 1, '2026-03-13', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1792, 7, 2, '2026-03-13', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1796, 2, 1, '2026-03-12', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1798, 7, 2, '2026-03-12', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1802, 2, 1, '2026-03-11', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1804, 7, 2, '2026-03-11', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1808, 2, 1, '2026-03-10', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1810, 7, 2, '2026-03-10', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1814, 2, 1, '2026-03-09', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1816, 7, 2, '2026-03-09', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1820, 2, 1, '2026-03-06', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1822, 7, 2, '2026-03-06', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1826, 2, 1, '2026-03-05', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1828, 7, 2, '2026-03-05', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1832, 2, 1, '2026-03-04', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1834, 7, 2, '2026-03-04', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1838, 2, 1, '2026-03-03', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1840, 7, 2, '2026-03-03', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1844, 2, 1, '2026-03-02', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1846, 7, 2, '2026-03-02', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1850, 2, 1, '2026-02-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1852, 7, 2, '2026-02-27', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1856, 2, 1, '2026-02-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1858, 7, 2, '2026-02-26', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1862, 2, 1, '2026-02-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1864, 7, 2, '2026-02-25', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1868, 2, 1, '2026-02-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1870, 7, 2, '2026-02-24', '11:00-11:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1874, 2, 1, '2026-03-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1876, 7, 2, '2026-03-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1880, 2, 1, '2026-03-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1882, 7, 2, '2026-03-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1886, 2, 1, '2026-03-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1888, 7, 2, '2026-03-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1892, 2, 1, '2026-03-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1894, 7, 2, '2026-03-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1898, 2, 1, '2026-03-23', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1900, 7, 2, '2026-03-23', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1904, 2, 1, '2026-03-20', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1906, 7, 2, '2026-03-20', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1910, 2, 1, '2026-03-19', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1912, 7, 2, '2026-03-19', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1916, 2, 1, '2026-03-18', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1918, 7, 2, '2026-03-18', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1922, 2, 1, '2026-03-17', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1924, 7, 2, '2026-03-17', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1928, 2, 1, '2026-03-16', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1930, 7, 2, '2026-03-16', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1934, 2, 1, '2026-03-13', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1936, 7, 2, '2026-03-13', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1940, 2, 1, '2026-03-12', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1942, 7, 2, '2026-03-12', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1946, 2, 1, '2026-03-11', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1948, 7, 2, '2026-03-11', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1952, 2, 1, '2026-03-10', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1954, 7, 2, '2026-03-10', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1958, 2, 1, '2026-03-09', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1960, 7, 2, '2026-03-09', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1964, 2, 1, '2026-03-06', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1966, 7, 2, '2026-03-06', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1970, 2, 1, '2026-03-05', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1972, 7, 2, '2026-03-05', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1976, 2, 1, '2026-03-04', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1978, 7, 2, '2026-03-04', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1982, 2, 1, '2026-03-03', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1984, 7, 2, '2026-03-03', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1988, 2, 1, '2026-03-02', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1990, 7, 2, '2026-03-02', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (1994, 2, 1, '2026-02-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (1996, 7, 2, '2026-02-27', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2000, 2, 1, '2026-02-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2002, 7, 2, '2026-02-26', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2006, 2, 1, '2026-02-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2008, 7, 2, '2026-02-25', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2012, 2, 1, '2026-02-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2014, 7, 2, '2026-02-24', '11:15-11:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2018, 2, 1, '2026-03-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2020, 7, 2, '2026-03-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2024, 2, 1, '2026-03-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2026, 7, 2, '2026-03-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2030, 2, 1, '2026-03-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2032, 7, 2, '2026-03-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2036, 2, 1, '2026-03-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2038, 7, 2, '2026-03-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2042, 2, 1, '2026-03-23', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2044, 7, 2, '2026-03-23', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2048, 2, 1, '2026-03-20', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2050, 7, 2, '2026-03-20', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2054, 2, 1, '2026-03-19', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2056, 7, 2, '2026-03-19', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2060, 2, 1, '2026-03-18', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2062, 7, 2, '2026-03-18', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2066, 2, 1, '2026-03-17', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2068, 7, 2, '2026-03-17', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2072, 2, 1, '2026-03-16', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2074, 7, 2, '2026-03-16', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2078, 2, 1, '2026-03-13', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2080, 7, 2, '2026-03-13', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2084, 2, 1, '2026-03-12', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2086, 7, 2, '2026-03-12', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2090, 2, 1, '2026-03-11', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2092, 7, 2, '2026-03-11', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2096, 2, 1, '2026-03-10', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2098, 7, 2, '2026-03-10', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2102, 2, 1, '2026-03-09', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2104, 7, 2, '2026-03-09', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2108, 2, 1, '2026-03-06', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2110, 7, 2, '2026-03-06', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2114, 2, 1, '2026-03-05', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2116, 7, 2, '2026-03-05', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2120, 2, 1, '2026-03-04', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2122, 7, 2, '2026-03-04', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2126, 2, 1, '2026-03-03', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2128, 7, 2, '2026-03-03', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2132, 2, 1, '2026-03-02', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2134, 7, 2, '2026-03-02', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2138, 2, 1, '2026-02-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2140, 7, 2, '2026-02-27', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2144, 2, 1, '2026-02-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2146, 7, 2, '2026-02-26', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2150, 2, 1, '2026-02-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2152, 7, 2, '2026-02-25', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2156, 2, 1, '2026-02-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2158, 7, 2, '2026-02-24', '11:30-11:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2162, 2, 1, '2026-03-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2164, 7, 2, '2026-03-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2168, 2, 1, '2026-03-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2170, 7, 2, '2026-03-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2174, 2, 1, '2026-03-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2176, 7, 2, '2026-03-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2180, 2, 1, '2026-03-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2182, 7, 2, '2026-03-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2186, 2, 1, '2026-03-23', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2188, 7, 2, '2026-03-23', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2192, 2, 1, '2026-03-20', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2194, 7, 2, '2026-03-20', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2198, 2, 1, '2026-03-19', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2200, 7, 2, '2026-03-19', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2204, 2, 1, '2026-03-18', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2206, 7, 2, '2026-03-18', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2210, 2, 1, '2026-03-17', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2212, 7, 2, '2026-03-17', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2216, 2, 1, '2026-03-16', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2218, 7, 2, '2026-03-16', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2222, 2, 1, '2026-03-13', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2224, 7, 2, '2026-03-13', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2228, 2, 1, '2026-03-12', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2230, 7, 2, '2026-03-12', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2234, 2, 1, '2026-03-11', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2236, 7, 2, '2026-03-11', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2240, 2, 1, '2026-03-10', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2242, 7, 2, '2026-03-10', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2246, 2, 1, '2026-03-09', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2248, 7, 2, '2026-03-09', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2252, 2, 1, '2026-03-06', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2254, 7, 2, '2026-03-06', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2258, 2, 1, '2026-03-05', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2260, 7, 2, '2026-03-05', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2264, 2, 1, '2026-03-04', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2266, 7, 2, '2026-03-04', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2270, 2, 1, '2026-03-03', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2272, 7, 2, '2026-03-03', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2276, 2, 1, '2026-03-02', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2278, 7, 2, '2026-03-02', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2282, 2, 1, '2026-02-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2284, 7, 2, '2026-02-27', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2288, 2, 1, '2026-02-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2290, 7, 2, '2026-02-26', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2294, 2, 1, '2026-02-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2296, 7, 2, '2026-02-25', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2300, 2, 1, '2026-02-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2302, 7, 2, '2026-02-24', '11:45-12:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2306, 2, 1, '2026-03-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2308, 7, 2, '2026-03-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2312, 2, 1, '2026-03-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2314, 7, 2, '2026-03-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2318, 2, 1, '2026-03-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2320, 7, 2, '2026-03-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2324, 2, 1, '2026-03-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2326, 7, 2, '2026-03-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2330, 2, 1, '2026-03-23', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2332, 7, 2, '2026-03-23', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2336, 2, 1, '2026-03-20', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2338, 7, 2, '2026-03-20', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2342, 2, 1, '2026-03-19', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2344, 7, 2, '2026-03-19', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2348, 2, 1, '2026-03-18', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2350, 7, 2, '2026-03-18', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2354, 2, 1, '2026-03-17', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2356, 7, 2, '2026-03-17', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2360, 2, 1, '2026-03-16', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2362, 7, 2, '2026-03-16', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2366, 2, 1, '2026-03-13', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2368, 7, 2, '2026-03-13', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2372, 2, 1, '2026-03-12', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2374, 7, 2, '2026-03-12', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2378, 2, 1, '2026-03-11', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2380, 7, 2, '2026-03-11', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2384, 2, 1, '2026-03-10', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2386, 7, 2, '2026-03-10', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2390, 2, 1, '2026-03-09', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2392, 7, 2, '2026-03-09', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2396, 2, 1, '2026-03-06', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2398, 7, 2, '2026-03-06', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2402, 2, 1, '2026-03-05', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2404, 7, 2, '2026-03-05', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2408, 2, 1, '2026-03-04', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2410, 7, 2, '2026-03-04', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2414, 2, 1, '2026-03-03', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2416, 7, 2, '2026-03-03', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2420, 2, 1, '2026-03-02', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2422, 7, 2, '2026-03-02', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2426, 2, 1, '2026-02-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2428, 7, 2, '2026-02-27', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2432, 2, 1, '2026-02-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2434, 7, 2, '2026-02-26', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2438, 2, 1, '2026-02-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2440, 7, 2, '2026-02-25', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2444, 2, 1, '2026-02-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2446, 7, 2, '2026-02-24', '12:00-12:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2450, 2, 1, '2026-03-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2452, 7, 2, '2026-03-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2456, 2, 1, '2026-03-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2458, 7, 2, '2026-03-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2462, 2, 1, '2026-03-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2464, 7, 2, '2026-03-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2468, 2, 1, '2026-03-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2470, 7, 2, '2026-03-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2474, 2, 1, '2026-03-23', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2476, 7, 2, '2026-03-23', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2480, 2, 1, '2026-03-20', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2482, 7, 2, '2026-03-20', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2486, 2, 1, '2026-03-19', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2488, 7, 2, '2026-03-19', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2492, 2, 1, '2026-03-18', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2494, 7, 2, '2026-03-18', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2498, 2, 1, '2026-03-17', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2500, 7, 2, '2026-03-17', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2504, 2, 1, '2026-03-16', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2506, 7, 2, '2026-03-16', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2510, 2, 1, '2026-03-13', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2512, 7, 2, '2026-03-13', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2516, 2, 1, '2026-03-12', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2518, 7, 2, '2026-03-12', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2522, 2, 1, '2026-03-11', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2524, 7, 2, '2026-03-11', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2528, 2, 1, '2026-03-10', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2530, 7, 2, '2026-03-10', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2534, 2, 1, '2026-03-09', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2536, 7, 2, '2026-03-09', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2540, 2, 1, '2026-03-06', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2542, 7, 2, '2026-03-06', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2546, 2, 1, '2026-03-05', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2548, 7, 2, '2026-03-05', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2552, 2, 1, '2026-03-04', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2554, 7, 2, '2026-03-04', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2558, 2, 1, '2026-03-03', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2560, 7, 2, '2026-03-03', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2564, 2, 1, '2026-03-02', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2566, 7, 2, '2026-03-02', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2570, 2, 1, '2026-02-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2572, 7, 2, '2026-02-27', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2576, 2, 1, '2026-02-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2578, 7, 2, '2026-02-26', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2582, 2, 1, '2026-02-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2584, 7, 2, '2026-02-25', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2588, 2, 1, '2026-02-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2590, 7, 2, '2026-02-24', '12:15-12:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2594, 2, 1, '2026-03-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2596, 7, 2, '2026-03-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2600, 2, 1, '2026-03-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2602, 7, 2, '2026-03-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2606, 2, 1, '2026-03-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2608, 7, 2, '2026-03-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2612, 2, 1, '2026-03-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2614, 7, 2, '2026-03-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2618, 2, 1, '2026-03-23', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2620, 7, 2, '2026-03-23', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2624, 2, 1, '2026-03-20', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2626, 7, 2, '2026-03-20', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2630, 2, 1, '2026-03-19', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2632, 7, 2, '2026-03-19', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2636, 2, 1, '2026-03-18', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2638, 7, 2, '2026-03-18', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2642, 2, 1, '2026-03-17', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2644, 7, 2, '2026-03-17', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2648, 2, 1, '2026-03-16', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2650, 7, 2, '2026-03-16', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2654, 2, 1, '2026-03-13', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2656, 7, 2, '2026-03-13', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2660, 2, 1, '2026-03-12', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2662, 7, 2, '2026-03-12', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2666, 2, 1, '2026-03-11', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2668, 7, 2, '2026-03-11', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2672, 2, 1, '2026-03-10', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2674, 7, 2, '2026-03-10', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2678, 2, 1, '2026-03-09', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2680, 7, 2, '2026-03-09', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2684, 2, 1, '2026-03-06', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2686, 7, 2, '2026-03-06', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2690, 2, 1, '2026-03-05', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2692, 7, 2, '2026-03-05', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2696, 2, 1, '2026-03-04', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2698, 7, 2, '2026-03-04', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2702, 2, 1, '2026-03-03', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2704, 7, 2, '2026-03-03', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2708, 2, 1, '2026-03-02', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2710, 7, 2, '2026-03-02', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2714, 2, 1, '2026-02-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2716, 7, 2, '2026-02-27', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2720, 2, 1, '2026-02-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2722, 7, 2, '2026-02-26', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2726, 2, 1, '2026-02-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2728, 7, 2, '2026-02-25', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2732, 2, 1, '2026-02-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2734, 7, 2, '2026-02-24', '12:30-12:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2738, 2, 1, '2026-03-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2740, 7, 2, '2026-03-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2744, 2, 1, '2026-03-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2746, 7, 2, '2026-03-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2750, 2, 1, '2026-03-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2752, 7, 2, '2026-03-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2756, 2, 1, '2026-03-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2758, 7, 2, '2026-03-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2762, 2, 1, '2026-03-23', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2764, 7, 2, '2026-03-23', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2768, 2, 1, '2026-03-20', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2770, 7, 2, '2026-03-20', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2774, 2, 1, '2026-03-19', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2776, 7, 2, '2026-03-19', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2780, 2, 1, '2026-03-18', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2782, 7, 2, '2026-03-18', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2786, 2, 1, '2026-03-17', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2788, 7, 2, '2026-03-17', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2792, 2, 1, '2026-03-16', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2794, 7, 2, '2026-03-16', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2798, 2, 1, '2026-03-13', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2800, 7, 2, '2026-03-13', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2804, 2, 1, '2026-03-12', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2806, 7, 2, '2026-03-12', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2810, 2, 1, '2026-03-11', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2812, 7, 2, '2026-03-11', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2816, 2, 1, '2026-03-10', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2818, 7, 2, '2026-03-10', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2822, 2, 1, '2026-03-09', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2824, 7, 2, '2026-03-09', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2828, 2, 1, '2026-03-06', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2830, 7, 2, '2026-03-06', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2834, 2, 1, '2026-03-05', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2836, 7, 2, '2026-03-05', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2840, 2, 1, '2026-03-04', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2842, 7, 2, '2026-03-04', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2846, 2, 1, '2026-03-03', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2848, 7, 2, '2026-03-03', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2852, 2, 1, '2026-03-02', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2854, 7, 2, '2026-03-02', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2858, 2, 1, '2026-02-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2860, 7, 2, '2026-02-27', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2864, 2, 1, '2026-02-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2866, 7, 2, '2026-02-26', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2870, 2, 1, '2026-02-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2872, 7, 2, '2026-02-25', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2876, 2, 1, '2026-02-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2878, 7, 2, '2026-02-24', '12:45-13:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2882, 2, 1, '2026-03-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2884, 7, 2, '2026-03-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2888, 2, 1, '2026-03-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2890, 7, 2, '2026-03-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2894, 2, 1, '2026-03-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2896, 7, 2, '2026-03-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2900, 2, 1, '2026-03-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2902, 7, 2, '2026-03-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2906, 2, 1, '2026-03-23', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2908, 7, 2, '2026-03-23', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2912, 2, 1, '2026-03-20', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2914, 7, 2, '2026-03-20', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2918, 2, 1, '2026-03-19', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2920, 7, 2, '2026-03-19', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2924, 2, 1, '2026-03-18', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2926, 7, 2, '2026-03-18', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2930, 2, 1, '2026-03-17', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2932, 7, 2, '2026-03-17', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2936, 2, 1, '2026-03-16', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2938, 7, 2, '2026-03-16', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2942, 2, 1, '2026-03-13', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2944, 7, 2, '2026-03-13', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2948, 2, 1, '2026-03-12', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2950, 7, 2, '2026-03-12', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2954, 2, 1, '2026-03-11', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2956, 7, 2, '2026-03-11', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2960, 2, 1, '2026-03-10', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2962, 7, 2, '2026-03-10', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2966, 2, 1, '2026-03-09', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2968, 7, 2, '2026-03-09', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2972, 2, 1, '2026-03-06', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2974, 7, 2, '2026-03-06', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2978, 2, 1, '2026-03-05', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2980, 7, 2, '2026-03-05', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2984, 2, 1, '2026-03-04', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2986, 7, 2, '2026-03-04', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2990, 2, 1, '2026-03-03', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2992, 7, 2, '2026-03-03', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (2996, 2, 1, '2026-03-02', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (2998, 7, 2, '2026-03-02', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3002, 2, 1, '2026-02-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3004, 7, 2, '2026-02-27', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3008, 2, 1, '2026-02-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3010, 7, 2, '2026-02-26', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3014, 2, 1, '2026-02-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3016, 7, 2, '2026-02-25', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3020, 2, 1, '2026-02-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3022, 7, 2, '2026-02-24', '13:00-13:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3026, 2, 1, '2026-03-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3028, 7, 2, '2026-03-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3032, 2, 1, '2026-03-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3034, 7, 2, '2026-03-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3038, 2, 1, '2026-03-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3040, 7, 2, '2026-03-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3044, 2, 1, '2026-03-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3046, 7, 2, '2026-03-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3050, 2, 1, '2026-03-23', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3052, 7, 2, '2026-03-23', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3056, 2, 1, '2026-03-20', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3058, 7, 2, '2026-03-20', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3062, 2, 1, '2026-03-19', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3064, 7, 2, '2026-03-19', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3068, 2, 1, '2026-03-18', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3070, 7, 2, '2026-03-18', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3074, 2, 1, '2026-03-17', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3076, 7, 2, '2026-03-17', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3080, 2, 1, '2026-03-16', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3082, 7, 2, '2026-03-16', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3086, 2, 1, '2026-03-13', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3088, 7, 2, '2026-03-13', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3092, 2, 1, '2026-03-12', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3094, 7, 2, '2026-03-12', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3098, 2, 1, '2026-03-11', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3100, 7, 2, '2026-03-11', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3104, 2, 1, '2026-03-10', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3106, 7, 2, '2026-03-10', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3110, 2, 1, '2026-03-09', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3112, 7, 2, '2026-03-09', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3116, 2, 1, '2026-03-06', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3118, 7, 2, '2026-03-06', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3122, 2, 1, '2026-03-05', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3124, 7, 2, '2026-03-05', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3128, 2, 1, '2026-03-04', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3130, 7, 2, '2026-03-04', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3134, 2, 1, '2026-03-03', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3136, 7, 2, '2026-03-03', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3140, 2, 1, '2026-03-02', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3142, 7, 2, '2026-03-02', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3146, 2, 1, '2026-02-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3148, 7, 2, '2026-02-27', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3152, 2, 1, '2026-02-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3154, 7, 2, '2026-02-26', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3158, 2, 1, '2026-02-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3160, 7, 2, '2026-02-25', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3164, 2, 1, '2026-02-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3166, 7, 2, '2026-02-24', '13:15-13:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3170, 2, 1, '2026-03-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3172, 7, 2, '2026-03-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3176, 2, 1, '2026-03-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3178, 7, 2, '2026-03-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3182, 2, 1, '2026-03-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3184, 7, 2, '2026-03-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3188, 2, 1, '2026-03-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3190, 7, 2, '2026-03-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3194, 2, 1, '2026-03-23', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3196, 7, 2, '2026-03-23', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3200, 2, 1, '2026-03-20', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3202, 7, 2, '2026-03-20', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3206, 2, 1, '2026-03-19', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3208, 7, 2, '2026-03-19', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3212, 2, 1, '2026-03-18', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3214, 7, 2, '2026-03-18', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3218, 2, 1, '2026-03-17', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3220, 7, 2, '2026-03-17', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3224, 2, 1, '2026-03-16', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3226, 7, 2, '2026-03-16', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3230, 2, 1, '2026-03-13', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3232, 7, 2, '2026-03-13', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3236, 2, 1, '2026-03-12', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3238, 7, 2, '2026-03-12', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3242, 2, 1, '2026-03-11', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3244, 7, 2, '2026-03-11', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3248, 2, 1, '2026-03-10', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3250, 7, 2, '2026-03-10', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3254, 2, 1, '2026-03-09', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3256, 7, 2, '2026-03-09', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3260, 2, 1, '2026-03-06', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3262, 7, 2, '2026-03-06', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3266, 2, 1, '2026-03-05', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3268, 7, 2, '2026-03-05', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3272, 2, 1, '2026-03-04', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3274, 7, 2, '2026-03-04', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3278, 2, 1, '2026-03-03', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3280, 7, 2, '2026-03-03', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3284, 2, 1, '2026-03-02', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3286, 7, 2, '2026-03-02', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3290, 2, 1, '2026-02-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3292, 7, 2, '2026-02-27', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3296, 2, 1, '2026-02-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3298, 7, 2, '2026-02-26', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3302, 2, 1, '2026-02-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3304, 7, 2, '2026-02-25', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3308, 2, 1, '2026-02-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3310, 7, 2, '2026-02-24', '13:30-13:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3314, 2, 1, '2026-03-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3316, 7, 2, '2026-03-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3320, 2, 1, '2026-03-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3322, 7, 2, '2026-03-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3326, 2, 1, '2026-03-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3328, 7, 2, '2026-03-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3332, 2, 1, '2026-03-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3334, 7, 2, '2026-03-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3338, 2, 1, '2026-03-23', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3340, 7, 2, '2026-03-23', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3344, 2, 1, '2026-03-20', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3346, 7, 2, '2026-03-20', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3350, 2, 1, '2026-03-19', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3352, 7, 2, '2026-03-19', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3356, 2, 1, '2026-03-18', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3358, 7, 2, '2026-03-18', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3362, 2, 1, '2026-03-17', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3364, 7, 2, '2026-03-17', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3368, 2, 1, '2026-03-16', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3370, 7, 2, '2026-03-16', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3374, 2, 1, '2026-03-13', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3376, 7, 2, '2026-03-13', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3380, 2, 1, '2026-03-12', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3382, 7, 2, '2026-03-12', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3386, 2, 1, '2026-03-11', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3388, 7, 2, '2026-03-11', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3392, 2, 1, '2026-03-10', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3394, 7, 2, '2026-03-10', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3398, 2, 1, '2026-03-09', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3400, 7, 2, '2026-03-09', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3404, 2, 1, '2026-03-06', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3406, 7, 2, '2026-03-06', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3410, 2, 1, '2026-03-05', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3412, 7, 2, '2026-03-05', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3416, 2, 1, '2026-03-04', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3418, 7, 2, '2026-03-04', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3422, 2, 1, '2026-03-03', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3424, 7, 2, '2026-03-03', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3428, 2, 1, '2026-03-02', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3430, 7, 2, '2026-03-02', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3434, 2, 1, '2026-02-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3436, 7, 2, '2026-02-27', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3440, 2, 1, '2026-02-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3442, 7, 2, '2026-02-26', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3446, 2, 1, '2026-02-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3448, 7, 2, '2026-02-25', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3452, 2, 1, '2026-02-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3454, 7, 2, '2026-02-24', '13:45-14:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3458, 2, 1, '2026-03-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3460, 7, 2, '2026-03-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3464, 2, 1, '2026-03-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3466, 7, 2, '2026-03-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3470, 2, 1, '2026-03-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3472, 7, 2, '2026-03-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3476, 2, 1, '2026-03-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3478, 7, 2, '2026-03-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3482, 2, 1, '2026-03-23', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3484, 7, 2, '2026-03-23', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3488, 2, 1, '2026-03-20', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3490, 7, 2, '2026-03-20', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3494, 2, 1, '2026-03-19', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3496, 7, 2, '2026-03-19', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3500, 2, 1, '2026-03-18', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3502, 7, 2, '2026-03-18', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3506, 2, 1, '2026-03-17', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3508, 7, 2, '2026-03-17', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3512, 2, 1, '2026-03-16', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3514, 7, 2, '2026-03-16', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3518, 2, 1, '2026-03-13', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3520, 7, 2, '2026-03-13', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3524, 2, 1, '2026-03-12', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3526, 7, 2, '2026-03-12', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3530, 2, 1, '2026-03-11', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3532, 7, 2, '2026-03-11', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3536, 2, 1, '2026-03-10', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3538, 7, 2, '2026-03-10', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3542, 2, 1, '2026-03-09', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3544, 7, 2, '2026-03-09', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3548, 2, 1, '2026-03-06', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3550, 7, 2, '2026-03-06', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3554, 2, 1, '2026-03-05', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3556, 7, 2, '2026-03-05', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3560, 2, 1, '2026-03-04', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3562, 7, 2, '2026-03-04', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3566, 2, 1, '2026-03-03', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3568, 7, 2, '2026-03-03', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3572, 2, 1, '2026-03-02', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3574, 7, 2, '2026-03-02', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3578, 2, 1, '2026-02-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3580, 7, 2, '2026-02-27', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3584, 2, 1, '2026-02-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3586, 7, 2, '2026-02-26', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3590, 2, 1, '2026-02-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3592, 7, 2, '2026-02-25', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3596, 2, 1, '2026-02-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3598, 7, 2, '2026-02-24', '14:00-14:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3602, 2, 1, '2026-03-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3604, 7, 2, '2026-03-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3608, 2, 1, '2026-03-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3610, 7, 2, '2026-03-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3614, 2, 1, '2026-03-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3616, 7, 2, '2026-03-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3620, 2, 1, '2026-03-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3622, 7, 2, '2026-03-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3626, 2, 1, '2026-03-23', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3628, 7, 2, '2026-03-23', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3632, 2, 1, '2026-03-20', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3634, 7, 2, '2026-03-20', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3638, 2, 1, '2026-03-19', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3640, 7, 2, '2026-03-19', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3644, 2, 1, '2026-03-18', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3646, 7, 2, '2026-03-18', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3650, 2, 1, '2026-03-17', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3652, 7, 2, '2026-03-17', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3656, 2, 1, '2026-03-16', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3658, 7, 2, '2026-03-16', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3662, 2, 1, '2026-03-13', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3664, 7, 2, '2026-03-13', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3668, 2, 1, '2026-03-12', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3670, 7, 2, '2026-03-12', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3674, 2, 1, '2026-03-11', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3676, 7, 2, '2026-03-11', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3680, 2, 1, '2026-03-10', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3682, 7, 2, '2026-03-10', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3686, 2, 1, '2026-03-09', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3688, 7, 2, '2026-03-09', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3692, 2, 1, '2026-03-06', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3694, 7, 2, '2026-03-06', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3698, 2, 1, '2026-03-05', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3700, 7, 2, '2026-03-05', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3704, 2, 1, '2026-03-04', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3706, 7, 2, '2026-03-04', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3710, 2, 1, '2026-03-03', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3712, 7, 2, '2026-03-03', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3716, 2, 1, '2026-03-02', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3718, 7, 2, '2026-03-02', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3722, 2, 1, '2026-02-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3724, 7, 2, '2026-02-27', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3728, 2, 1, '2026-02-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3730, 7, 2, '2026-02-26', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3734, 2, 1, '2026-02-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3736, 7, 2, '2026-02-25', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3740, 2, 1, '2026-02-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3742, 7, 2, '2026-02-24', '14:15-14:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3746, 2, 1, '2026-03-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3748, 7, 2, '2026-03-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3752, 2, 1, '2026-03-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3754, 7, 2, '2026-03-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3758, 2, 1, '2026-03-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3760, 7, 2, '2026-03-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3764, 2, 1, '2026-03-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3766, 7, 2, '2026-03-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3770, 2, 1, '2026-03-23', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3772, 7, 2, '2026-03-23', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3776, 2, 1, '2026-03-20', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3778, 7, 2, '2026-03-20', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3782, 2, 1, '2026-03-19', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3784, 7, 2, '2026-03-19', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3788, 2, 1, '2026-03-18', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3790, 7, 2, '2026-03-18', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3794, 2, 1, '2026-03-17', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3796, 7, 2, '2026-03-17', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3800, 2, 1, '2026-03-16', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3802, 7, 2, '2026-03-16', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3806, 2, 1, '2026-03-13', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3808, 7, 2, '2026-03-13', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3812, 2, 1, '2026-03-12', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3814, 7, 2, '2026-03-12', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3818, 2, 1, '2026-03-11', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3820, 7, 2, '2026-03-11', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3824, 2, 1, '2026-03-10', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3826, 7, 2, '2026-03-10', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3830, 2, 1, '2026-03-09', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3832, 7, 2, '2026-03-09', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3836, 2, 1, '2026-03-06', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3838, 7, 2, '2026-03-06', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3842, 2, 1, '2026-03-05', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3844, 7, 2, '2026-03-05', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3848, 2, 1, '2026-03-04', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3850, 7, 2, '2026-03-04', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3854, 2, 1, '2026-03-03', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3856, 7, 2, '2026-03-03', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3860, 2, 1, '2026-03-02', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3862, 7, 2, '2026-03-02', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3866, 2, 1, '2026-02-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3868, 7, 2, '2026-02-27', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3872, 2, 1, '2026-02-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3874, 7, 2, '2026-02-26', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3878, 2, 1, '2026-02-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3880, 7, 2, '2026-02-25', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3884, 2, 1, '2026-02-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3886, 7, 2, '2026-02-24', '14:30-14:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3890, 2, 1, '2026-03-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3892, 7, 2, '2026-03-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3896, 2, 1, '2026-03-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3898, 7, 2, '2026-03-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3902, 2, 1, '2026-03-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3904, 7, 2, '2026-03-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3908, 2, 1, '2026-03-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3910, 7, 2, '2026-03-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3914, 2, 1, '2026-03-23', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3916, 7, 2, '2026-03-23', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3920, 2, 1, '2026-03-20', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3922, 7, 2, '2026-03-20', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3926, 2, 1, '2026-03-19', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3928, 7, 2, '2026-03-19', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3932, 2, 1, '2026-03-18', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3934, 7, 2, '2026-03-18', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3938, 2, 1, '2026-03-17', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3940, 7, 2, '2026-03-17', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3944, 2, 1, '2026-03-16', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3946, 7, 2, '2026-03-16', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3950, 2, 1, '2026-03-13', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3952, 7, 2, '2026-03-13', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3956, 2, 1, '2026-03-12', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3958, 7, 2, '2026-03-12', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3962, 2, 1, '2026-03-11', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3964, 7, 2, '2026-03-11', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3968, 2, 1, '2026-03-10', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3970, 7, 2, '2026-03-10', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3974, 2, 1, '2026-03-09', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3976, 7, 2, '2026-03-09', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3980, 2, 1, '2026-03-06', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3982, 7, 2, '2026-03-06', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3986, 2, 1, '2026-03-05', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3988, 7, 2, '2026-03-05', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3992, 2, 1, '2026-03-04', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (3994, 7, 2, '2026-03-04', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (3998, 2, 1, '2026-03-03', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4000, 7, 2, '2026-03-03', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4004, 2, 1, '2026-03-02', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4006, 7, 2, '2026-03-02', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4010, 2, 1, '2026-02-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4012, 7, 2, '2026-02-27', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4016, 2, 1, '2026-02-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4018, 7, 2, '2026-02-26', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4022, 2, 1, '2026-02-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4024, 7, 2, '2026-02-25', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4028, 2, 1, '2026-02-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4030, 7, 2, '2026-02-24', '14:45-15:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4034, 2, 1, '2026-03-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4036, 7, 2, '2026-03-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4040, 2, 1, '2026-03-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4042, 7, 2, '2026-03-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4046, 2, 1, '2026-03-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4048, 7, 2, '2026-03-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4052, 2, 1, '2026-03-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4054, 7, 2, '2026-03-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4058, 2, 1, '2026-03-23', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4060, 7, 2, '2026-03-23', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4064, 2, 1, '2026-03-20', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4066, 7, 2, '2026-03-20', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4070, 2, 1, '2026-03-19', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4072, 7, 2, '2026-03-19', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4076, 2, 1, '2026-03-18', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4078, 7, 2, '2026-03-18', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4082, 2, 1, '2026-03-17', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4084, 7, 2, '2026-03-17', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4088, 2, 1, '2026-03-16', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4090, 7, 2, '2026-03-16', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4094, 2, 1, '2026-03-13', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4096, 7, 2, '2026-03-13', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4100, 2, 1, '2026-03-12', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4102, 7, 2, '2026-03-12', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4106, 2, 1, '2026-03-11', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4108, 7, 2, '2026-03-11', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4112, 2, 1, '2026-03-10', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4114, 7, 2, '2026-03-10', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4118, 2, 1, '2026-03-09', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4120, 7, 2, '2026-03-09', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4124, 2, 1, '2026-03-06', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4126, 7, 2, '2026-03-06', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4130, 2, 1, '2026-03-05', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4132, 7, 2, '2026-03-05', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4136, 2, 1, '2026-03-04', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4138, 7, 2, '2026-03-04', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4142, 2, 1, '2026-03-03', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4144, 7, 2, '2026-03-03', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4148, 2, 1, '2026-03-02', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4150, 7, 2, '2026-03-02', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4154, 2, 1, '2026-02-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4156, 7, 2, '2026-02-27', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4160, 2, 1, '2026-02-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4162, 7, 2, '2026-02-26', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4166, 2, 1, '2026-02-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4168, 7, 2, '2026-02-25', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4172, 2, 1, '2026-02-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4174, 7, 2, '2026-02-24', '15:00-15:15', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4178, 2, 1, '2026-03-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4180, 7, 2, '2026-03-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4184, 2, 1, '2026-03-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4186, 7, 2, '2026-03-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4190, 2, 1, '2026-03-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4192, 7, 2, '2026-03-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4196, 2, 1, '2026-03-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4198, 7, 2, '2026-03-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4202, 2, 1, '2026-03-23', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4204, 7, 2, '2026-03-23', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4208, 2, 1, '2026-03-20', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4210, 7, 2, '2026-03-20', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4214, 2, 1, '2026-03-19', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4216, 7, 2, '2026-03-19', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4220, 2, 1, '2026-03-18', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4222, 7, 2, '2026-03-18', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4226, 2, 1, '2026-03-17', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4228, 7, 2, '2026-03-17', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4232, 2, 1, '2026-03-16', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4234, 7, 2, '2026-03-16', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4238, 2, 1, '2026-03-13', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4240, 7, 2, '2026-03-13', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4244, 2, 1, '2026-03-12', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4246, 7, 2, '2026-03-12', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4250, 2, 1, '2026-03-11', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4252, 7, 2, '2026-03-11', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4256, 2, 1, '2026-03-10', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4258, 7, 2, '2026-03-10', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4262, 2, 1, '2026-03-09', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4264, 7, 2, '2026-03-09', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4268, 2, 1, '2026-03-06', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4270, 7, 2, '2026-03-06', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4274, 2, 1, '2026-03-05', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4276, 7, 2, '2026-03-05', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4280, 2, 1, '2026-03-04', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4282, 7, 2, '2026-03-04', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4286, 2, 1, '2026-03-03', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4288, 7, 2, '2026-03-03', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4292, 2, 1, '2026-03-02', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4294, 7, 2, '2026-03-02', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4298, 2, 1, '2026-02-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4300, 7, 2, '2026-02-27', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4304, 2, 1, '2026-02-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4306, 7, 2, '2026-02-26', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4310, 2, 1, '2026-02-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4312, 7, 2, '2026-02-25', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4316, 2, 1, '2026-02-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4318, 7, 2, '2026-02-24', '15:15-15:30', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4322, 2, 1, '2026-03-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4324, 7, 2, '2026-03-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4328, 2, 1, '2026-03-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4330, 7, 2, '2026-03-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4334, 2, 1, '2026-03-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4336, 7, 2, '2026-03-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4340, 2, 1, '2026-03-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4342, 7, 2, '2026-03-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4346, 2, 1, '2026-03-23', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4348, 7, 2, '2026-03-23', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4352, 2, 1, '2026-03-20', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4354, 7, 2, '2026-03-20', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4358, 2, 1, '2026-03-19', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4360, 7, 2, '2026-03-19', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4364, 2, 1, '2026-03-18', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4366, 7, 2, '2026-03-18', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4370, 2, 1, '2026-03-17', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4372, 7, 2, '2026-03-17', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4376, 2, 1, '2026-03-16', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4378, 7, 2, '2026-03-16', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4382, 2, 1, '2026-03-13', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4384, 7, 2, '2026-03-13', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4388, 2, 1, '2026-03-12', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4390, 7, 2, '2026-03-12', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4394, 2, 1, '2026-03-11', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4396, 7, 2, '2026-03-11', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4400, 2, 1, '2026-03-10', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4402, 7, 2, '2026-03-10', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4406, 2, 1, '2026-03-09', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4408, 7, 2, '2026-03-09', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4412, 2, 1, '2026-03-06', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4414, 7, 2, '2026-03-06', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4418, 2, 1, '2026-03-05', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4420, 7, 2, '2026-03-05', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4424, 2, 1, '2026-03-04', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4426, 7, 2, '2026-03-04', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4430, 2, 1, '2026-03-03', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4432, 7, 2, '2026-03-03', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4436, 2, 1, '2026-03-02', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4438, 7, 2, '2026-03-02', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4442, 2, 1, '2026-02-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4444, 7, 2, '2026-02-27', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4448, 2, 1, '2026-02-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4450, 7, 2, '2026-02-26', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4454, 2, 1, '2026-02-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4456, 7, 2, '2026-02-25', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4460, 2, 1, '2026-02-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4462, 7, 2, '2026-02-24', '15:30-15:45', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4466, 2, 1, '2026-03-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4468, 7, 2, '2026-03-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4472, 2, 1, '2026-03-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4474, 7, 2, '2026-03-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4478, 2, 1, '2026-03-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4480, 7, 2, '2026-03-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4484, 2, 1, '2026-03-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4486, 7, 2, '2026-03-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4490, 2, 1, '2026-03-23', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4492, 7, 2, '2026-03-23', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4496, 2, 1, '2026-03-20', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4498, 7, 2, '2026-03-20', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4502, 2, 1, '2026-03-19', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4504, 7, 2, '2026-03-19', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4508, 2, 1, '2026-03-18', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4510, 7, 2, '2026-03-18', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4514, 2, 1, '2026-03-17', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4516, 7, 2, '2026-03-17', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4520, 2, 1, '2026-03-16', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4522, 7, 2, '2026-03-16', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4526, 2, 1, '2026-03-13', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4528, 7, 2, '2026-03-13', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4532, 2, 1, '2026-03-12', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4534, 7, 2, '2026-03-12', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4538, 2, 1, '2026-03-11', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4540, 7, 2, '2026-03-11', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4544, 2, 1, '2026-03-10', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4546, 7, 2, '2026-03-10', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4550, 2, 1, '2026-03-09', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4552, 7, 2, '2026-03-09', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4556, 2, 1, '2026-03-06', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4558, 7, 2, '2026-03-06', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4562, 2, 1, '2026-03-05', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4564, 7, 2, '2026-03-05', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4568, 2, 1, '2026-03-04', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4570, 7, 2, '2026-03-04', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4574, 2, 1, '2026-03-03', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4576, 7, 2, '2026-03-03', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4580, 2, 1, '2026-03-02', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4582, 7, 2, '2026-03-02', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4586, 2, 1, '2026-02-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4588, 7, 2, '2026-02-27', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4592, 2, 1, '2026-02-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4594, 7, 2, '2026-02-26', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4598, 2, 1, '2026-02-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4600, 7, 2, '2026-02-25', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');
INSERT INTO `doctor_schedule` VALUES (4604, 2, 1, '2026-02-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-25 10:44:49');
INSERT INTO `doctor_schedule` VALUES (4606, 7, 2, '2026-02-24', '15:45-16:00', 5, 0, 1, '2026-02-25 10:44:49', '2026-02-27 15:12:36');

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
INSERT INTO `notice` VALUES (14, '12122121fdfdf', 'yuutuy', 'NORMAL', NULL, 'ADMIN', 'APPROVED', NULL, 0, 0, '2026-02-24 17:13:20', NULL, 'NORMAL', '2026-02-24 17:13:20', '2026-02-24 17:13:20');
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
-- Table structure for site_vaccine_stock
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
  CONSTRAINT `fk_svs_batch` FOREIGN KEY (`batch_id`) REFERENCES `vaccine_batch` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_svs_site` FOREIGN KEY (`site_id`) REFERENCES `vaccination_site` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '接种点库存（按批次，与总仓调拨联动）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of site_vaccine_stock
-- ----------------------------
INSERT INTO `site_vaccine_stock` VALUES (1, 1, 1, 20, 0, '2026-02-27 15:42:38', '2026-02-27 15:42:38');
INSERT INTO `site_vaccine_stock` VALUES (2, 1, 3, 20, 0, '2026-02-27 15:42:38', '2026-02-27 15:42:38');
INSERT INTO `site_vaccine_stock` VALUES (3, 1, 4, 19, 0, '2026-02-27 15:42:38', '2026-02-27 17:09:37');
INSERT INTO `site_vaccine_stock` VALUES (4, 1, 5, 20, 0, '2026-02-27 15:42:38', '2026-02-27 15:42:38');
INSERT INTO `site_vaccine_stock` VALUES (5, 1, 7, 20, 0, '2026-02-27 15:42:38', '2026-02-27 15:42:38');
INSERT INTO `site_vaccine_stock` VALUES (6, 1, 8, 20, 0, '2026-02-27 15:42:38', '2026-02-27 15:42:38');
INSERT INTO `site_vaccine_stock` VALUES (7, 1, 9, 20, 0, '2026-02-27 15:42:38', '2026-02-27 15:42:38');
INSERT INTO `site_vaccine_stock` VALUES (8, 2, 1, 0, 0, '2026-02-27 15:43:38', '2026-02-27 16:41:09');
INSERT INTO `site_vaccine_stock` VALUES (9, 2, 3, 0, 0, '2026-02-27 15:43:38', '2026-02-27 16:41:09');
INSERT INTO `site_vaccine_stock` VALUES (10, 2, 4, 0, 0, '2026-02-27 15:43:38', '2026-02-27 16:41:09');
INSERT INTO `site_vaccine_stock` VALUES (11, 2, 5, 0, 0, '2026-02-27 15:43:38', '2026-02-27 16:41:09');
INSERT INTO `site_vaccine_stock` VALUES (12, 2, 7, 0, 0, '2026-02-27 15:43:38', '2026-02-27 16:41:09');
INSERT INTO `site_vaccine_stock` VALUES (13, 2, 8, 0, 0, '2026-02-27 15:43:38', '2026-02-27 16:41:09');
INSERT INTO `site_vaccine_stock` VALUES (14, 2, 9, 0, 0, '2026-02-27 15:43:38', '2026-02-27 16:41:09');

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
-- Table structure for stock_transfer_log
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
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '库存调拨日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stock_transfer_log
-- ----------------------------
INSERT INTO `stock_transfer_log` VALUES (1, 1, 0, NULL, 1, 1, 20, NULL, '2026-02-27 15:42:39');
INSERT INTO `stock_transfer_log` VALUES (2, 3, 0, NULL, 1, 1, 20, NULL, '2026-02-27 15:42:39');
INSERT INTO `stock_transfer_log` VALUES (3, 4, 0, NULL, 1, 1, 20, NULL, '2026-02-27 15:42:39');
INSERT INTO `stock_transfer_log` VALUES (4, 5, 0, NULL, 1, 1, 20, NULL, '2026-02-27 15:42:39');
INSERT INTO `stock_transfer_log` VALUES (5, 7, 0, NULL, 1, 1, 20, NULL, '2026-02-27 15:42:39');
INSERT INTO `stock_transfer_log` VALUES (6, 8, 0, NULL, 1, 1, 20, NULL, '2026-02-27 15:42:39');
INSERT INTO `stock_transfer_log` VALUES (7, 9, 0, NULL, 1, 1, 20, NULL, '2026-02-27 15:42:39');
INSERT INTO `stock_transfer_log` VALUES (8, 1, 0, NULL, 1, 2, 20, NULL, '2026-02-27 15:43:38');
INSERT INTO `stock_transfer_log` VALUES (9, 3, 0, NULL, 1, 2, 20, NULL, '2026-02-27 15:43:38');
INSERT INTO `stock_transfer_log` VALUES (10, 4, 0, NULL, 1, 2, 20, NULL, '2026-02-27 15:43:38');
INSERT INTO `stock_transfer_log` VALUES (11, 5, 0, NULL, 1, 2, 20, NULL, '2026-02-27 15:43:38');
INSERT INTO `stock_transfer_log` VALUES (12, 7, 0, NULL, 1, 2, 20, NULL, '2026-02-27 15:43:38');
INSERT INTO `stock_transfer_log` VALUES (13, 8, 0, NULL, 1, 2, 20, NULL, '2026-02-27 15:43:38');
INSERT INTO `stock_transfer_log` VALUES (14, 9, 0, NULL, 1, 2, 20, NULL, '2026-02-27 15:43:38');
INSERT INTO `stock_transfer_log` VALUES (15, 1, 1, 2, 0, NULL, 20, NULL, '2026-02-27 16:41:10');
INSERT INTO `stock_transfer_log` VALUES (16, 3, 1, 2, 0, NULL, 20, NULL, '2026-02-27 16:41:10');
INSERT INTO `stock_transfer_log` VALUES (17, 4, 1, 2, 0, NULL, 20, NULL, '2026-02-27 16:41:10');
INSERT INTO `stock_transfer_log` VALUES (18, 5, 1, 2, 0, NULL, 20, NULL, '2026-02-27 16:41:10');
INSERT INTO `stock_transfer_log` VALUES (19, 7, 1, 2, 0, NULL, 20, NULL, '2026-02-27 16:41:10');
INSERT INTO `stock_transfer_log` VALUES (20, 8, 1, 2, 0, NULL, 20, NULL, '2026-02-27 16:41:10');
INSERT INTO `stock_transfer_log` VALUES (21, 9, 1, 2, 0, NULL, 20, NULL, '2026-02-27 16:41:10');

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '123456', '系统管理员', 'ADMIN', 1, '13800000001', NULL, '天津市南开区', NULL, 0, '2026-02-11 23:03:22', '2026-02-27 16:43:05', '2026-02-27 16:43:05', NULL, 0);
INSERT INTO `sys_user` VALUES (2, 'doctor01', '123456', '张医生', 'DOCTOR', 2, '13800000002', NULL, '天津市南开区', NULL, 0, '2026-02-11 23:03:22', '2026-02-27 17:09:19', '2026-02-27 17:09:19', NULL, 0);
INSERT INTO `sys_user` VALUES (3, 'doctor02', '123456', '马医生', 'DOCTOR', 1, '13800000003', NULL, '天津市南开区', NULL, 2, '2026-02-11 23:03:22', '2026-02-25 15:33:46', NULL, NULL, 0);
INSERT INTO `sys_user` VALUES (4, 'parent01', '123456', '李家长', 'RESIDENT', 1, '13800000004', NULL, '天津市南开区某某小区', NULL, 0, '2026-02-11 23:03:22', '2026-02-25 15:10:14', '2026-02-25 15:10:14', NULL, 0);
INSERT INTO `sys_user` VALUES (5, 'parent02', '123456', '赵家长', 'RESIDENT', 2, '13800000005', NULL, '天津市南开区某某街道', NULL, 0, '2026-02-11 23:03:22', '2026-02-11 23:03:22', NULL, NULL, 0);
INSERT INTO `sys_user` VALUES (6, 'doctor03', '123456', '刘医生', 'DOCTOR', NULL, NULL, NULL, NULL, NULL, 2, '2026-02-12 00:10:21', '2026-02-12 08:31:24', '2026-02-12 08:31:25', NULL, 0);
INSERT INTO `sys_user` VALUES (7, 'doctor04', '123456', '王医生', 'DOCTOR', NULL, '123', NULL, '123', NULL, 0, '2026-02-12 07:55:23', '2026-02-24 17:57:27', '2026-02-24 17:57:27', NULL, 0);
INSERT INTO `sys_user` VALUES (8, 'parent03', '123456', '孙家长', 'RESIDENT', NULL, NULL, NULL, NULL, NULL, 0, '2026-02-27 15:45:44', '2026-02-27 16:44:25', '2026-02-27 16:44:25', NULL, 0);
INSERT INTO `sys_user` VALUES (9, 'parent04', '123456', '宋家长', 'RESIDENT', NULL, NULL, NULL, NULL, NULL, 0, '2026-02-27 15:46:00', '2026-02-27 15:46:00', NULL, NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '接种记录表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `vaccination_record` VALUES (16, 12, 8, 3, 18, NULL, 4, 'V3-20260227-503001-0001', 'IPV202503001', 1, '2026-02-27 17:09:38', NULL, 1, '口服', NULL, NULL, '2026-03-27', '2026-02-27 17:09:37', '2026-02-27 17:09:37');

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
INSERT INTO `vaccination_site` VALUES (2, '南开区妇幼保健院接种点', '天津市南开区YY大道200号', '022-87654321', '周一至周六 8:00-11:00', 1, NULL, 7, '2026-02-11 23:03:22', '2026-02-27 15:12:36');
INSERT INTO `vaccination_site` VALUES (3, '南开区第一接种点', '天津市南开区AA街1号', '022-11111111', '周一至周五 8:00-11:00', 0, NULL, 7, '2026-02-11 23:03:22', '2026-02-11 23:03:22');

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
INSERT INTO `vaccine` VALUES (1, '乙肝疫苗', NULL, 'CLASS_I', '北京生物', '重组酵母', 3, 30, 0, '0.5ml/支', '预防乙型肝炎。', '偶见发热、局部红肿，一般可自行缓解。', 1, '2026-02-11 23:03:22', '2026-02-11 23:03:22');
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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '疫苗批次表（FEFO 分配）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vaccine_batch
-- ----------------------------
INSERT INTO `vaccine_batch` VALUES (1, 1, 'HBV202501001', '2025-01-10', '2027-01-10', 80, 30, 0, '2026-02-27 15:06:46', '2026-02-27 16:41:09');
INSERT INTO `vaccine_batch` VALUES (2, 1, 'HBV202506002', '2025-06-01', '2027-06-01', 80, 30, 0, '2026-02-27 15:06:46', '2026-02-27 15:06:46');
INSERT INTO `vaccine_batch` VALUES (3, 2, 'BCG202502001', '2025-02-15', '2026-08-15', 30, 30, 0, '2026-02-27 15:06:46', '2026-02-27 16:41:09');
INSERT INTO `vaccine_batch` VALUES (4, 3, 'IPV202503001', '2025-03-01', '2027-03-01', 100, 30, 0, '2026-02-27 15:06:46', '2026-02-27 16:41:09');
INSERT INTO `vaccine_batch` VALUES (5, 4, 'DTP202504001', '2025-04-10', '2027-04-10', 70, 30, 0, '2026-02-27 15:06:46', '2026-02-27 16:41:09');
INSERT INTO `vaccine_batch` VALUES (6, 4, 'DTP202508002', '2025-08-01', '2027-08-01', 60, 30, 0, '2026-02-27 15:06:46', '2026-02-27 15:06:46');
INSERT INTO `vaccine_batch` VALUES (7, 5, 'MMR202505001', '2025-05-20', '2027-05-20', 50, 30, 0, '2026-02-27 15:06:46', '2026-02-27 16:41:09');
INSERT INTO `vaccine_batch` VALUES (8, 6, 'FLU202509001', '2025-09-01', '2026-09-01', 180, 30, 0, '2026-02-27 15:06:46', '2026-02-27 16:41:09');
INSERT INTO `vaccine_batch` VALUES (9, 7, 'VAR202506001', '2025-06-15', '2027-06-15', 20, 30, 0, '2026-02-27 15:06:46', '2026-02-27 16:41:09');
INSERT INTO `vaccine_batch` VALUES (10, 10, 'ROT202507001', '2025-07-01', '2026-07-01', 85, 30, 0, '2026-02-27 15:06:46', '2026-02-27 15:06:46');

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '批次销毁记录' ROW_FORMAT = DYNAMIC;

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

SET FOREIGN_KEY_CHECKS = 1;
