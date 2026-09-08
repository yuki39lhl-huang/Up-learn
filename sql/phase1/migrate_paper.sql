-- 历年真题表（已有库增量执行）
USE up_learn;

CREATE TABLE IF NOT EXISTS `paper` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `province`       VARCHAR(32)  NOT NULL COMMENT '省份：广东/山东',
  `subject`        VARCHAR(64)  NOT NULL COMMENT '展示科目名（与考纲对齐）',
  `year`           INT          NOT NULL COMMENT '试卷年份',
  `title`          VARCHAR(256) NOT NULL COMMENT '展示标题',
  `pdf_url`        VARCHAR(512) DEFAULT NULL COMMENT '题目 PDF：OSS URL 或相对 shijuan 路径',
  `answer_pdf_url` VARCHAR(512) DEFAULT NULL COMMENT '答案 PDF（可空）',
  `has_answer`     TINYINT      NOT NULL DEFAULT 0 COMMENT '是否已有可用参考答案：1 有，0 无',
  `published`      TINYINT      NOT NULL DEFAULT 1 COMMENT '是否上架：1 是，0 否',
  `deleted`        TINYINT      NOT NULL DEFAULT 0 COMMENT '逻辑删除：1 已删，0 未删',
  `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_paper_province_subject_year` (`province`, `subject`, `year`),
  KEY `idx_paper_province_subject` (`province`, `subject`, `published`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='刷题服务·历年真题试卷元数据';

CREATE TABLE IF NOT EXISTS `paper_question` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `paper_id`     BIGINT       NOT NULL COMMENT '试卷 ID',
  `seq`          INT          NOT NULL COMMENT '题序（从 1 起）',
  `q_type`       VARCHAR(16)  NOT NULL COMMENT '题型：choice/fill/calc/essay',
  `stem`         TEXT         NOT NULL COMMENT '题干（支持 Markdown/KaTeX）',
  `options_json` JSON         DEFAULT NULL COMMENT '选择题选项 JSON',
  `answer`       TEXT         DEFAULT NULL COMMENT '标准答案（提交后揭晓）',
  `analysis`     TEXT         DEFAULT NULL COMMENT '解析',
  `score`        INT          NOT NULL DEFAULT 0 COMMENT '分值',
  `input_mode`   VARCHAR(16)  NOT NULL DEFAULT 'reveal_only' COMMENT 'answerable=在线作答；reveal_only=提交后揭晓',
  `deleted`      TINYINT      NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  `created_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_paper_question_seq` (`paper_id`, `seq`),
  KEY `idx_paper_question_paper` (`paper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='刷题服务·历年真题题目';

CREATE TABLE IF NOT EXISTS `paper_attempt` (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id`         BIGINT       NOT NULL COMMENT '用户 ID',
  `paper_id`        BIGINT       NOT NULL COMMENT '试卷 ID',
  `status`          VARCHAR(16)  NOT NULL DEFAULT 'in_progress' COMMENT 'in_progress/submitted',
  `objective_score` INT          DEFAULT NULL COMMENT '客观题得分（仅 choice）',
  `objective_total` INT          DEFAULT NULL COMMENT '客观题满分',
  `submitted_at`    DATETIME(3)  DEFAULT NULL COMMENT '交卷时间',
  `created_at`      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_attempt_user_paper` (`user_id`, `paper_id`, `status`),
  KEY `idx_attempt_paper` (`paper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='刷题服务·历年真题作答会话';

CREATE TABLE IF NOT EXISTS `paper_attempt_answer` (
  `id`                BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `attempt_id`        BIGINT       NOT NULL COMMENT '作答会话 ID',
  `paper_question_id` BIGINT       NOT NULL COMMENT '题目 ID',
  `user_answer`       VARCHAR(512) DEFAULT NULL COMMENT '用户答案（仅 answerable）',
  `correct`           TINYINT      DEFAULT NULL COMMENT '是否正确：1/0；主观题空',
  `created_at`        DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`        DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_attempt_question` (`attempt_id`, `paper_question_id`),
  KEY `idx_attempt_answer_attempt` (`attempt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='刷题服务·历年真题作答明细';
