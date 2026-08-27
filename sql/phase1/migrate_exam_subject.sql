-- 备考设置考试科目数据（开发环境可重复执行）
USE `up_learn`;

CREATE TABLE IF NOT EXISTS `exam_subject` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`         VARCHAR(128) NOT NULL COMMENT '考试科目名称',
  `subject_type` VARCHAR(32)  NOT NULL COMMENT '科目类型：PUBLIC公共课、FOUNDATION专业基础课、COMPREHENSIVE专业综合课',
  `code`         VARCHAR(64)           DEFAULT NULL COMMENT '稳定业务编码',
  `sort_order`   INT          NOT NULL DEFAULT 0 COMMENT '同类科目展示顺序',
  `enabled`      TINYINT      NOT NULL DEFAULT 1 COMMENT '1启用 0停用',
  `created_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_exam_subject_type_name` (`subject_type`, `name`),
  KEY `idx_exam_subject_type_enabled` (`subject_type`, `enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 考试科目字典';

CREATE TABLE IF NOT EXISTS `exam_subject_rule` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `province`       VARCHAR(32)  NOT NULL COMMENT '省份',
  `major_category` VARCHAR(64)           DEFAULT NULL COMMENT '专业类；为空表示该省通用规则',
  `subject_id`     BIGINT       NOT NULL COMMENT 'exam_subject.id',
  `is_default`     TINYINT      NOT NULL DEFAULT 0 COMMENT '是否默认选中',
  `sort_order`     INT          NOT NULL DEFAULT 0 COMMENT '候选科目展示顺序',
  `year`           INT                   DEFAULT NULL COMMENT '规则适用年份；为空表示通用',
  `enabled`        TINYINT      NOT NULL DEFAULT 1 COMMENT '1启用 0停用',
  `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_exam_subject_rule_scope` (`province`, `major_category`, `subject_id`, `year`),
  KEY `idx_exam_subject_rule_query` (`province`, `major_category`, `enabled`),
  KEY `idx_exam_subject_rule_subject` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 省份专业考试科目规则';

-- 修复已有库的表注释/字段注释（CREATE TABLE IF NOT EXISTS 不会更新旧表定义）。
ALTER TABLE `exam_subject`
  MODIFY COLUMN `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `name` VARCHAR(128) NOT NULL COMMENT '考试科目名称',
  MODIFY COLUMN `subject_type` VARCHAR(32) NOT NULL COMMENT '科目类型：PUBLIC公共课、FOUNDATION专业基础课、COMPREHENSIVE专业综合课',
  MODIFY COLUMN `code` VARCHAR(64) DEFAULT NULL COMMENT '稳定业务编码',
  MODIFY COLUMN `sort_order` INT NOT NULL DEFAULT 0 COMMENT '同类科目展示顺序',
  MODIFY COLUMN `enabled` TINYINT NOT NULL DEFAULT 1 COMMENT '1启用 0停用',
  MODIFY COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  COMMENT='school-service · 考试科目字典';

ALTER TABLE `exam_subject_rule`
  MODIFY COLUMN `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `province` VARCHAR(32) NOT NULL COMMENT '省份',
  MODIFY COLUMN `major_category` VARCHAR(64) DEFAULT NULL COMMENT '专业类；为空表示该省通用规则',
  MODIFY COLUMN `subject_id` BIGINT NOT NULL COMMENT '关联 exam_subject.id',
  MODIFY COLUMN `is_default` TINYINT NOT NULL DEFAULT 0 COMMENT '是否默认选中：1是 0否',
  MODIFY COLUMN `sort_order` INT NOT NULL DEFAULT 0 COMMENT '候选科目展示顺序',
  MODIFY COLUMN `year` INT DEFAULT NULL COMMENT '规则适用年份；为空表示通用规则',
  MODIFY COLUMN `enabled` TINYINT NOT NULL DEFAULT 1 COMMENT '1启用 0停用',
  MODIFY COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  COMMENT='school-service · 省份专业考试科目规则';

INSERT IGNORE INTO `exam_subject`
  (`name`, `subject_type`, `code`, `sort_order`)
VALUES
  ('政治', 'PUBLIC', 'politics', 10),
  ('政治理论', 'PUBLIC', 'political_theory', 20),
  ('大学英语', 'PUBLIC', 'college_english', 30),
  ('英语', 'PUBLIC', 'english', 40),
  ('大学语文', 'PUBLIC', 'college_chinese', 50),
  ('高等数学', 'FOUNDATION', 'advanced_math', 10),
  ('管理学', 'FOUNDATION', 'management', 20),
  ('民法', 'FOUNDATION', 'civil_law', 30),
  ('艺术概论', 'FOUNDATION', 'art_theory', 40),
  ('大学语文', 'FOUNDATION', 'college_chinese', 50),
  ('教育理论', 'FOUNDATION', 'education_theory', 60),
  ('生态学基础', 'FOUNDATION', 'ecology', 70),
  ('生理学', 'FOUNDATION', 'physiology', 80),
  ('经济学', 'FOUNDATION', 'economics', 90),
  ('法理学', 'COMPREHENSIVE', 'jurisprudence', 10),
  ('电子技术基础', 'COMPREHENSIVE', 'electronic_technology', 20),
  ('计算机基础与程序设计', 'COMPREHENSIVE', 'computer_programming', 30),
  ('机械工程基础', 'COMPREHENSIVE', 'mechanical_engineering', 40),
  ('数学专业综合', 'COMPREHENSIVE', 'mathematics', 50),
  ('遗传学', 'COMPREHENSIVE', 'genetics', 60),
  ('学前教育基础', 'COMPREHENSIVE', 'preschool_education', 70),
  ('汉语言文学学科基础', 'COMPREHENSIVE', 'chinese_literature', 80),
  ('英语基础与写作', 'COMPREHENSIVE', 'english_writing', 90),
  ('设计基础', 'COMPREHENSIVE', 'design', 100),
  ('基础会计学', 'COMPREHENSIVE', 'accounting', 110),
  ('电子商务概论', 'COMPREHENSIVE', 'e_commerce', 120),
  ('市场营销学', 'COMPREHENSIVE', 'marketing', 130),
  ('人力资源管理', 'COMPREHENSIVE', 'human_resources', 140),
  ('行政管理学', 'COMPREHENSIVE', 'public_administration', 150),
  ('金融学', 'COMPREHENSIVE', 'finance', 160),
  ('国际贸易理论与实务', 'COMPREHENSIVE', 'international_trade', 170),
  ('院校自命题综合课', 'COMPREHENSIVE', 'school_exam', 180);

-- 两个已支持省份的候选范围。公共课默认值按省份区分。
INSERT IGNORE INTO `exam_subject_rule`
  (`province`, `major_category`, `subject_id`, `is_default`, `sort_order`, `year`)
SELECT p.province,
       NULL,
       s.id,
       CASE
         WHEN p.province = '广东' AND s.subject_type = 'PUBLIC'
              AND s.name IN ('政治', '大学英语') THEN 1
         WHEN p.province = '山东' AND s.subject_type = 'PUBLIC'
              AND s.name IN ('大学语文', '大学英语') THEN 1
         ELSE 0
       END,
       s.sort_order,
       NULL
FROM (
  SELECT '广东' AS province
  UNION ALL
  SELECT '山东'
) p
JOIN `exam_subject` s ON s.enabled = 1;

-- 专业类型默认的专业基础课和专业综合课。
INSERT IGNORE INTO `exam_subject_rule`
  (`province`, `major_category`, `subject_id`, `is_default`, `sort_order`, `year`)
SELECT p.province,
       m.major_category,
       s.id,
       1,
       s.sort_order,
       NULL
FROM (
  SELECT '广东' AS province
  UNION ALL
  SELECT '山东'
) p
JOIN (
  SELECT '计算机类' AS major_category, '高等数学' AS foundation, '计算机基础与程序设计' AS comprehensive
  UNION ALL SELECT '电子信息类', '高等数学', '电子技术基础'
  UNION ALL SELECT '自动化类', '高等数学', '电子技术基础'
  UNION ALL SELECT '机械类', '高等数学', '机械工程基础'
  UNION ALL SELECT '土木类', '高等数学', '院校自命题综合课'
  UNION ALL SELECT '工商管理类', '管理学', '基础会计学'
  UNION ALL SELECT '经济学类', '经济学', '金融学'
  UNION ALL SELECT '教育学类', '教育理论', '学前教育基础'
  UNION ALL SELECT '食品科学与工程类', '高等数学', '遗传学'
  UNION ALL SELECT '法学类', '民法', '法理学'
  UNION ALL SELECT '汉语言文学类', '大学语文', '汉语言文学学科基础'
  UNION ALL SELECT '英语类', '大学语文', '英语基础与写作'
  UNION ALL SELECT '艺术设计类', '艺术概论', '设计基础'
  UNION ALL SELECT '电子商务类', '管理学', '电子商务概论'
  UNION ALL SELECT '市场营销类', '管理学', '市场营销学'
  UNION ALL SELECT '人力资源管理类', '管理学', '人力资源管理'
  UNION ALL SELECT '行政管理类', '管理学', '行政管理学'
  UNION ALL SELECT '国际经济与贸易类', '经济学', '国际贸易理论与实务'
  UNION ALL SELECT '数学类', '高等数学', '数学专业综合'
  UNION ALL SELECT '生物类', '生态学基础', '遗传学'
  UNION ALL SELECT '农学类', '生态学基础', '遗传学'
  UNION ALL SELECT '医学类', '生理学', '院校自命题综合课'
) m
JOIN `exam_subject` s
  ON (s.subject_type = 'FOUNDATION' AND s.name = m.foundation)
  OR (s.subject_type = 'COMPREHENSIVE' AND s.name = m.comprehensive);
