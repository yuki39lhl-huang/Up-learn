-- up-learn 一期库表草案（开发对齐 MySQL 9.7.x；正式环境可用 8.4 LTS）
-- 库：up_learn（同实例单库；表归属见 COMMENT / 基线备忘 §七）
-- 本文件仅作结构草案，不强制在本机执行；不引入 Flyway。

CREATE DATABASE IF NOT EXISTS `up_learn`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `up_learn`;

-- ---------------------------------------------------------------------------
-- user-service
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `user` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `email`         VARCHAR(128) NOT NULL COMMENT '登录账号（邮箱）',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '密码哈希，不存明文',
  `nickname`      VARCHAR(64)  NOT NULL COMMENT '昵称；注册时服务端默认「前缀+随机」，用户可改',
  `avatar_url`    VARCHAR(512) NOT NULL COMMENT '头像 URL；注册时默认生成，用户可改',
  `deleted`       TINYINT      NOT NULL DEFAULT 0 COMMENT '0正常 1软删',
  `created_at`    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='user-service · 用户账号（邮箱登录；无手机号/短信）';

CREATE TABLE IF NOT EXISTS `user_target` (
  `id`         BIGINT      NOT NULL AUTO_INCREMENT,
  `user_id`    BIGINT      NOT NULL COMMENT 'user.id',
  `school_id`  BIGINT      NOT NULL COMMENT 'school.id（跨服务只存ID，无外键）',
  `major_id`   BIGINT               DEFAULT NULL COMMENT 'major.id，可选',
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_target` (`user_id`, `school_id`, `major_id`),
  KEY `idx_user_target_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='user-service · 目标院校';

-- ---------------------------------------------------------------------------
-- school-service
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `school` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `name`           VARCHAR(128) NOT NULL,
  `province`       VARCHAR(32)           DEFAULT NULL,
  `city`           VARCHAR(64)           DEFAULT NULL,
  `type`           VARCHAR(16)           DEFAULT NULL COMMENT '公办/民办等',
  `type_tag`       VARCHAR(32)           DEFAULT NULL COMMENT '展示标签',
  `prefer_public`  TINYINT      NOT NULL DEFAULT 0 COMMENT '是否公办标记，便于 preferPublic 筛选',
  `major_count`    INT                   DEFAULT NULL,
  `enrollment`     INT                   DEFAULT NULL COMMENT '招生人数（汇总或最新）',
  `tuition`        INT                   DEFAULT NULL COMMENT '学费（元/年，展示用）',
  `min_score`      INT                   DEFAULT NULL COMMENT '最低分（最新或默认年）',
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_school_province_type` (`province`, `type`),
  KEY `idx_school_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 院校';

CREATE TABLE IF NOT EXISTS `major` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `school_id`      BIGINT       NOT NULL COMMENT 'school.id',
  `name`           VARCHAR(128) NOT NULL,
  `major_category` VARCHAR(64)           DEFAULT NULL COMMENT '专业类，如计算机类',
  `exam_subjects`  VARCHAR(255)          DEFAULT NULL COMMENT '考试科目，逗号或JSON',
  `avg_score`      INT                   DEFAULT NULL COMMENT '均分',
  `enrollment`     INT                   DEFAULT NULL COMMENT '招生人数',
  `tuition`        INT                   DEFAULT NULL COMMENT '学费（元/年）',
  `min_score`      INT                   DEFAULT NULL,
  `year`           INT                   DEFAULT NULL COMMENT '招生年份',
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_major_school` (`school_id`),
  KEY `idx_major_category` (`major_category`),
  KEY `idx_major_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 专业';

CREATE TABLE IF NOT EXISTS `school_year_stat` (
  `id`          BIGINT      NOT NULL AUTO_INCREMENT,
  `school_id`   BIGINT      NOT NULL COMMENT 'school.id',
  `year`        INT         NOT NULL,
  `min_score`   INT                  DEFAULT NULL,
  `enrollment`  INT                  DEFAULT NULL,
  `tuition`     INT                  DEFAULT NULL,
  `extra_json`  JSON                 DEFAULT NULL COMMENT '扩展指标',
  `created_at`  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_school_year` (`school_id`, `year`),
  KEY `idx_stat_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 院校按年招生/分数线';

-- ---------------------------------------------------------------------------
-- practice-service
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `question` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `subject`     VARCHAR(32)  NOT NULL COMMENT '科目：英语/数学等',
  `stem`        TEXT         NOT NULL COMMENT '题干',
  `options_json` JSON                 DEFAULT NULL COMMENT '选项 JSON',
  `answer`      VARCHAR(64)           DEFAULT NULL COMMENT '标准答案',
  `analysis`    TEXT                  DEFAULT NULL COMMENT '解析',
  `difficulty`  TINYINT               DEFAULT NULL,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  `created_at`  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_question_subject` (`subject`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='practice-service · 题库';

CREATE TABLE IF NOT EXISTS `answer_record` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT       NOT NULL COMMENT 'user.id（跨服务只存ID）',
  `question_id`   BIGINT       NOT NULL COMMENT 'question.id',
  `user_answer`   VARCHAR(255)          DEFAULT NULL,
  `correct`       TINYINT      NOT NULL DEFAULT 0 COMMENT '1正确 0错误',
  `source`        VARCHAR(32)           DEFAULT NULL COMMENT 'daily/random/submit 来源',
  `created_at`    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `idx_answer_user_time` (`user_id`, `created_at`),
  KEY `idx_answer_question` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='practice-service · 作答历史';

CREATE TABLE IF NOT EXISTS `wrong_question` (
  `id`           BIGINT      NOT NULL AUTO_INCREMENT,
  `user_id`      BIGINT      NOT NULL,
  `question_id`  BIGINT      NOT NULL,
  `wrong_count`  INT         NOT NULL DEFAULT 1,
  `last_wrong_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `created_at`   DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`   DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wrong_user_question` (`user_id`, `question_id`),
  KEY `idx_wrong_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='practice-service · 错题本';

CREATE TABLE IF NOT EXISTS `study_stats` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `user_id`       BIGINT       NOT NULL,
  `total_answered` INT         NOT NULL DEFAULT 0,
  `correct_count` INT          NOT NULL DEFAULT 0,
  `accuracy`      DECIMAL(5,2)          DEFAULT NULL COMMENT '正确率百分比',
  `streak`        INT          NOT NULL DEFAULT 0 COMMENT '连续打卡天数（一期可先维护）',
  `updated_at`    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `created_at`    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_study_stats_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='practice-service · 学习统计汇总';

-- 二期预留（本期不建）：paper / paper_question；agent 会话可走 Redis
