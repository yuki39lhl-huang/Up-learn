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
  COMMENT='user-service · 用户账号（邮箱验证码登录；password_hash 为占位哈希）';

CREATE TABLE IF NOT EXISTS `user_target` (
  `id`         BIGINT      NOT NULL AUTO_INCREMENT,
  `user_id`    BIGINT      NOT NULL COMMENT 'user.id',
  `school_id`  BIGINT      NOT NULL COMMENT 'school.id（跨服务只存ID，无外键）',
  `major_id`   BIGINT               DEFAULT NULL COMMENT 'school_major.id，可选（某校开设）',
  `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_target` (`user_id`, `school_id`, `major_id`),
  KEY `idx_user_target_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='user-service · 目标院校';

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

-- ---------------------------------------------------------------------------
-- school-service
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `school` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
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

CREATE TABLE IF NOT EXISTS `major_dict` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`           VARCHAR(128) NOT NULL COMMENT '专业名称（全局唯一语义）',
  `major_category` VARCHAR(64)           DEFAULT NULL COMMENT '专业类，如计算机类',
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_major_dict_name` (`name`),
  KEY `idx_major_dict_category` (`major_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 专业词典（Combobox / 筛选用）';

CREATE TABLE IF NOT EXISTS `exam_subject` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name`         VARCHAR(128) NOT NULL COMMENT '考试科目名称',
  `subject_type` VARCHAR(32)  NOT NULL COMMENT '科目类型：PUBLIC公共课、FOUNDATION专业基础课、COMPREHENSIVE专业综合课',
  `code`         VARCHAR(64)           DEFAULT NULL COMMENT '稳定业务编码',
  `sort_order`   INT          NOT NULL DEFAULT 0 COMMENT '同类科目展示顺序',
  `enabled`      TINYINT      NOT NULL DEFAULT 1 COMMENT '1启用 0停用',
  `created_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`   DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
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

CREATE TABLE IF NOT EXISTS `school_major` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `school_id`      BIGINT       NOT NULL COMMENT 'school.id',
  `major_dict_id`  BIGINT       NOT NULL COMMENT 'major_dict.id',
  `exam_subjects`  VARCHAR(255)          DEFAULT NULL COMMENT '考试科目，逗号分隔',
  `avg_score`      INT                   DEFAULT NULL COMMENT '均分',
  `enrollment`     INT                   DEFAULT NULL COMMENT '招生人数',
  `tuition`        INT                   DEFAULT NULL COMMENT '学费（元/年）',
  `min_score`      INT                   DEFAULT NULL,
  `year`           INT                   DEFAULT NULL COMMENT '招生年份',
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_school_major_year` (`school_id`, `major_dict_id`, `year`),
  KEY `idx_school_major_school` (`school_id`),
  KEY `idx_school_major_dict` (`major_dict_id`),
  KEY `idx_school_major_year` (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='school-service · 院校开设专业（招生信息）';

-- 旧表 major 已废弃，新库勿再建；已有库执行 sql/phase1/migrate_major_dict.sql

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

-- ---------------------------------------------------------------------------
-- school-service · 备考考试科目种子（已有库可执行 migrate_exam_subject.sql）
-- ---------------------------------------------------------------------------
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

INSERT IGNORE INTO `exam_subject_rule`
  (`province`, `major_category`, `subject_id`, `is_default`, `sort_order`, `year`)
SELECT p.province, m.major_category, s.id, 1, s.sort_order, NULL
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
