-- 考纲表（开发环境可重复执行）
USE `up_learn`;

CREATE TABLE IF NOT EXISTS `syllabus` (
  `id`                     BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `province`               VARCHAR(32)  NOT NULL COMMENT '省份：广东/山东',
  `year`                   INT          NOT NULL COMMENT '考纲年份',
  `subject`                VARCHAR(64)  NOT NULL COMMENT '科目展示名（与官方一致，如政治理论/英语/大学语文）',
  `source_title`           VARCHAR(256)          DEFAULT NULL COMMENT '来源说明，如广东省2026年…考试要求',
  `scope_json`             JSON         NOT NULL COMMENT '考试范围树 {blocks:[{heading,paragraphs,items,children,highlight}]}',
  `references_json`        JSON                  DEFAULT NULL COMMENT '参考书目数组',
  `designated_works_json`  JSON                  DEFAULT NULL COMMENT '指定篇目数组（可空）',
  `created_at`             DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`             DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_syllabus_province_year_subject` (`province`, `year`, `subject`),
  KEY `idx_syllabus_province_year` (`province`, `year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='院校服务·专升本考纲表（省+年+科目）';
