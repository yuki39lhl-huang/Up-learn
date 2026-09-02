-- 每日一练签到寄语表（已有库可单独执行本文件建表）
USE `up_learn`;

CREATE TABLE IF NOT EXISTS `daily_encouragement` (
  `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `content`    VARCHAR(512) NOT NULL COMMENT '寄语正文',
  `enabled`    TINYINT      NOT NULL DEFAULT 1 COMMENT '是否启用：1 启用，0 停用',
  `sort_order` INT          NOT NULL DEFAULT 0 COMMENT '排序权重（展示池顺序）',
  `created_at` DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at` DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_daily_encouragement_enabled` (`enabled`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='刷题服务·每日一练签到寄语表';
