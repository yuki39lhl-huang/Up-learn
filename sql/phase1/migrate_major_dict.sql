-- 将旧 major 表迁移为 major_dict + school_major（开发环境可重复执行）
USE `up_learn`;

DROP TABLE IF EXISTS `school_major`;
DROP TABLE IF EXISTS `major_dict`;
DROP TABLE IF EXISTS `major`;

CREATE TABLE `major_dict` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `name`           VARCHAR(128) NOT NULL COMMENT '专业名称（全局唯一）',
  `major_category` VARCHAR(64)           DEFAULT NULL COMMENT '专业类',
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_major_dict_name` (`name`),
  KEY `idx_major_dict_category` (`major_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 专业词典';

CREATE TABLE `school_major` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `school_id`      BIGINT       NOT NULL COMMENT 'school.id',
  `major_dict_id`  BIGINT       NOT NULL COMMENT 'major_dict.id',
  `exam_subjects`  VARCHAR(255)          DEFAULT NULL,
  `avg_score`      INT                   DEFAULT NULL,
  `enrollment`     INT                   DEFAULT NULL,
  `tuition`        INT                   DEFAULT NULL,
  `min_score`      INT                   DEFAULT NULL,
  `year`           INT                   DEFAULT NULL,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_school_major_year` (`school_id`, `major_dict_id`, `year`),
  KEY `idx_school_major_school` (`school_id`),
  KEY `idx_school_major_dict` (`major_dict_id`),
  KEY `idx_school_major_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 院校开设专业';
