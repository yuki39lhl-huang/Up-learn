-- 随机刷题专项迁移（可重复执行 CREATE TABLE IF NOT EXISTS）
-- 1. user_question_record：间隔复习调度
-- 2. practice_note：备忘录（P2 API 预留）
-- 3. user_exam_preference 扩展列需单独执行 ALTER（见分期开发计划 §1.6a）
USE `up_learn`;

CREATE TABLE IF NOT EXISTS `user_question_record` (
  `id`                   BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`              BIGINT       NOT NULL COMMENT '用户 ID',
  `question_id`          BIGINT       NOT NULL COMMENT '题目 ID',
  `status`               VARCHAR(16)  NOT NULL DEFAULT 'NEW' COMMENT 'NEW/WRONG/RIGHT',
  `last_answer_time`     DATETIME(3)           DEFAULT NULL COMMENT '上次作答时间',
  `next_review_time`     DATETIME(3)           DEFAULT NULL COMMENT '允许下次复习的最早时间',
  `wrong_count`          INT          NOT NULL DEFAULT 0 COMMENT '累计做错次数',
  `right_count`          INT          NOT NULL DEFAULT 0 COMMENT '累计做对次数',
  `review_interval_days` INT          NOT NULL DEFAULT 0 COMMENT '当前复习间隔天数',
  `created_at`           DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`           DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uqr_user_question` (`user_id`, `question_id`),
  KEY `idx_uqr_user_status` (`user_id`, `status`),
  KEY `idx_uqr_user_review` (`user_id`, `next_review_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='刷题服务·题目间隔复习调度表（驱动随机刷题出题池）';

CREATE TABLE IF NOT EXISTS `practice_note` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`     BIGINT       NOT NULL COMMENT '用户 ID',
  `question_id` BIGINT       NOT NULL COMMENT '题目 ID',
  `stem`        TEXT                  DEFAULT NULL COMMENT '题干快照',
  `analysis`    TEXT                  DEFAULT NULL COMMENT '解析快照',
  `user_note`   VARCHAR(2000)         DEFAULT NULL COMMENT '用户备注',
  `created_at`  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_note_user_question` (`user_id`, `question_id`),
  KEY `idx_note_user_time` (`user_id`, `created_at`),
  KEY `idx_note_question` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='practice-service · 随机刷题备忘录（答对后手动收藏）';
