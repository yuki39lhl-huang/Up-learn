-- 用户备考设置持久化（开发环境可重复执行）
USE `up_learn`;

CREATE TABLE IF NOT EXISTS `user_exam_preference` (
  `id`                    BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`               BIGINT       NOT NULL COMMENT '用户 ID；跨服务只存 ID',
  `province`              VARCHAR(32)  NOT NULL COMMENT '报考省份',
  `cohort_year`           INT          NOT NULL COMMENT '报考届别年份',
  `major_category`        VARCHAR(64)  NOT NULL COMMENT '专业类型',
  `subject_selection_json` JSON         NOT NULL COMMENT '公共课/专业基础课/专业综合课选择',
  `daily_subject`         VARCHAR(128) NOT NULL COMMENT '每日一练科目',
  `daily_subject_mode`    VARCHAR(16)  NOT NULL DEFAULT 'fixed' COMMENT 'fixed固定科目、random随机科目',
  `created_at`             DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`             DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_exam_preference_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='user-service · 用户备考设置';

ALTER TABLE `user_exam_preference`
  MODIFY COLUMN `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id` BIGINT NOT NULL COMMENT '用户 ID；跨服务只存 ID',
  MODIFY COLUMN `province` VARCHAR(32) NOT NULL COMMENT '报考省份',
  MODIFY COLUMN `cohort_year` INT NOT NULL COMMENT '报考届别年份',
  MODIFY COLUMN `major_category` VARCHAR(64) NOT NULL COMMENT '专业类型',
  MODIFY COLUMN `subject_selection_json` JSON NOT NULL COMMENT '公共课/专业基础课/专业综合课选择',
  MODIFY COLUMN `daily_subject` VARCHAR(128) NOT NULL COMMENT '每日一练科目',
  MODIFY COLUMN `daily_subject_mode` VARCHAR(16) NOT NULL DEFAULT 'fixed' COMMENT 'fixed固定科目、random随机科目',
  MODIFY COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  COMMENT='user-service · 用户备考设置';
