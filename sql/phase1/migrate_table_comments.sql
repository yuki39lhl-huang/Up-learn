-- =============================================================================
-- migrate_table_comments.sql
-- 为 up_learn 库全部一期表补充中文表注释与字段注释（可重复执行）
-- 执行：mysql -h host -P port -u root -p up_learn < sql/phase1/migrate_table_comments.sql
-- =============================================================================
USE `up_learn`;

-- ---------------------------------------------------------------------------
-- user-service · 用户服务
-- ---------------------------------------------------------------------------

ALTER TABLE `user` COMMENT = '用户服务·用户账号表（邮箱验证码登录）';
ALTER TABLE `user`
  MODIFY COLUMN `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `email`         VARCHAR(128) NOT NULL COMMENT '登录邮箱（唯一）',
  MODIFY COLUMN `password_hash` VARCHAR(255) NOT NULL COMMENT '密码哈希，不存明文',
  MODIFY COLUMN `nickname`      VARCHAR(64)  NOT NULL COMMENT '昵称，注册时可默认生成',
  MODIFY COLUMN `avatar_url`    VARCHAR(512) NOT NULL COMMENT '头像 URL',
  MODIFY COLUMN `deleted`       TINYINT      NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
  MODIFY COLUMN `created_at`    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`    DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `user_target` COMMENT = '用户服务·目标院校表（用户意向报考学校/专业）';
ALTER TABLE `user_target`
  MODIFY COLUMN `id`         BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`    BIGINT      NOT NULL COMMENT '用户 ID，关联 user.id',
  MODIFY COLUMN `school_id`  BIGINT      NOT NULL COMMENT '院校 ID，关联 school.id',
  MODIFY COLUMN `major_id`   BIGINT               DEFAULT NULL COMMENT '院校专业 ID，关联 school_major.id，可选',
  MODIFY COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `user_exam_preference` COMMENT = '用户服务·备考设置表（省份、届别、科目与刷题偏好）';
ALTER TABLE `user_exam_preference`
  MODIFY COLUMN `id`                     BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`                BIGINT       NOT NULL COMMENT '用户 ID，关联 user.id',
  MODIFY COLUMN `province`               VARCHAR(32)  NOT NULL COMMENT '报考省份',
  MODIFY COLUMN `cohort_year`            INT          NOT NULL COMMENT '报考届别年份',
  MODIFY COLUMN `major_category`         VARCHAR(64)  NOT NULL COMMENT '专业类型/专业类',
  MODIFY COLUMN `subject_selection_json` JSON         NOT NULL COMMENT '考试科目选择 JSON（公共课/专业基础/专业综合）',
  MODIFY COLUMN `daily_subject`          VARCHAR(128) NOT NULL COMMENT '每日一练默认科目',
  MODIFY COLUMN `daily_subject_mode`     VARCHAR(16)  NOT NULL DEFAULT 'fixed' COMMENT '每日一练模式：fixed 固定科目，random 随机科目',
  MODIFY COLUMN `random_subject_mode`    VARCHAR(16)  NOT NULL DEFAULT 'all' COMMENT '随机刷题筛选：all 全科，single 指定一科',
  MODIFY COLUMN `random_subject`         VARCHAR(128)          DEFAULT NULL COMMENT 'random 为 single 时的题库科目名',
  MODIFY COLUMN `created_at`             DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`             DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

-- ---------------------------------------------------------------------------
-- school-service · 院校服务
-- ---------------------------------------------------------------------------

ALTER TABLE `school` COMMENT = '院校服务·院校基础信息表';
ALTER TABLE `school`
  MODIFY COLUMN `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `name`          VARCHAR(128) NOT NULL COMMENT '院校名称',
  MODIFY COLUMN `province`       VARCHAR(32)           DEFAULT NULL COMMENT '所在省份',
  MODIFY COLUMN `city`           VARCHAR(64)           DEFAULT NULL COMMENT '所在城市',
  MODIFY COLUMN `type`           VARCHAR(16)           DEFAULT NULL COMMENT '院校类型：公办/民办等',
  MODIFY COLUMN `type_tag`       VARCHAR(32)           DEFAULT NULL COMMENT '展示用类型标签',
  MODIFY COLUMN `prefer_public`  TINYINT      NOT NULL DEFAULT 0 COMMENT '是否公办：1 是，0 否',
  MODIFY COLUMN `major_count`    INT                   DEFAULT NULL COMMENT '开设专业数量（展示用）',
  MODIFY COLUMN `enrollment`     INT                   DEFAULT NULL COMMENT '招生人数（汇总或最新）',
  MODIFY COLUMN `tuition`        INT                   DEFAULT NULL COMMENT '学费（元/年，展示用）',
  MODIFY COLUMN `min_score`      INT                   DEFAULT NULL COMMENT '最低录取分（最新或默认年）',
  MODIFY COLUMN `deleted`        TINYINT      NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
  MODIFY COLUMN `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `major_dict` COMMENT = '院校服务·专业词典表（全局专业名称）';
ALTER TABLE `major_dict`
  MODIFY COLUMN `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `name`           VARCHAR(128) NOT NULL COMMENT '专业名称（全局唯一语义）',
  MODIFY COLUMN `major_category` VARCHAR(64)           DEFAULT NULL COMMENT '专业类，如计算机类',
  MODIFY COLUMN `deleted`        TINYINT      NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
  MODIFY COLUMN `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `exam_subject` COMMENT = '院校服务·考试科目字典表';
ALTER TABLE `exam_subject`
  MODIFY COLUMN `id`           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `name`         VARCHAR(128) NOT NULL COMMENT '考试科目名称',
  MODIFY COLUMN `subject_type` VARCHAR(32)  NOT NULL COMMENT '科目类型：PUBLIC/FOUNDATION/COMPREHENSIVE',
  MODIFY COLUMN `code`         VARCHAR(64)           DEFAULT NULL COMMENT '稳定业务编码',
  MODIFY COLUMN `sort_order`   INT          NOT NULL DEFAULT 0 COMMENT '同类科目展示排序',
  MODIFY COLUMN `enabled`      TINYINT      NOT NULL DEFAULT 1 COMMENT '是否启用：1 启用，0 停用',
  MODIFY COLUMN `created_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `exam_subject_rule` COMMENT = '院校服务·省份专业考试科目规则表';
ALTER TABLE `exam_subject_rule`
  MODIFY COLUMN `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `province`       VARCHAR(32)  NOT NULL COMMENT '适用省份',
  MODIFY COLUMN `major_category` VARCHAR(64)           DEFAULT NULL COMMENT '专业类；空表示该省通用',
  MODIFY COLUMN `subject_id`     BIGINT       NOT NULL COMMENT '考试科目 ID，关联 exam_subject.id',
  MODIFY COLUMN `is_default`     TINYINT      NOT NULL DEFAULT 0 COMMENT '是否默认选中：1 是，0 否',
  MODIFY COLUMN `sort_order`     INT          NOT NULL DEFAULT 0 COMMENT '候选科目展示排序',
  MODIFY COLUMN `year`           INT                   DEFAULT NULL COMMENT '规则适用年份；空表示通用',
  MODIFY COLUMN `enabled`        TINYINT      NOT NULL DEFAULT 1 COMMENT '是否启用：1 启用，0 停用',
  MODIFY COLUMN `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `school_major` COMMENT = '院校服务·院校开设专业表（招生信息）';
ALTER TABLE `school_major`
  MODIFY COLUMN `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `school_id`      BIGINT       NOT NULL COMMENT '院校 ID，关联 school.id',
  MODIFY COLUMN `major_dict_id`  BIGINT       NOT NULL COMMENT '专业词典 ID，关联 major_dict.id',
  MODIFY COLUMN `exam_subjects`  VARCHAR(255)          DEFAULT NULL COMMENT '考试科目，逗号分隔',
  MODIFY COLUMN `avg_score`      INT                   DEFAULT NULL COMMENT '平均分',
  MODIFY COLUMN `enrollment`     INT                   DEFAULT NULL COMMENT '招生人数',
  MODIFY COLUMN `tuition`        INT                   DEFAULT NULL COMMENT '学费（元/年）',
  MODIFY COLUMN `min_score`      INT                   DEFAULT NULL COMMENT '最低录取分',
  MODIFY COLUMN `year`           INT                   DEFAULT NULL COMMENT '招生年份',
  MODIFY COLUMN `deleted`        TINYINT      NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
  MODIFY COLUMN `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `school_year_stat` COMMENT = '院校服务·院校按年招生统计表';
ALTER TABLE `school_year_stat`
  MODIFY COLUMN `id`          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `school_id`   BIGINT      NOT NULL COMMENT '院校 ID，关联 school.id',
  MODIFY COLUMN `year`        INT         NOT NULL COMMENT '统计年份',
  MODIFY COLUMN `min_score`   INT                  DEFAULT NULL COMMENT '最低录取分',
  MODIFY COLUMN `enrollment`  INT                  DEFAULT NULL COMMENT '招生人数',
  MODIFY COLUMN `tuition`     INT                  DEFAULT NULL COMMENT '学费（元/年）',
  MODIFY COLUMN `extra_json`  JSON                 DEFAULT NULL COMMENT '扩展指标 JSON',
  MODIFY COLUMN `created_at`  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

-- ---------------------------------------------------------------------------
-- practice-service · 刷题服务
-- ---------------------------------------------------------------------------

ALTER TABLE `question` COMMENT = '刷题服务·题库题目表';
ALTER TABLE `question`
  MODIFY COLUMN `id`           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `subject`      VARCHAR(32)  NOT NULL COMMENT '题库科目：政治/大学英语/高等数学/计算机基础',
  MODIFY COLUMN `stem`         TEXT         NOT NULL COMMENT '题干正文',
  MODIFY COLUMN `options_json` JSON                 DEFAULT NULL COMMENT '选项列表 JSON',
  MODIFY COLUMN `answer`       VARCHAR(64)           DEFAULT NULL COMMENT '标准答案（如 A/B/C/D）',
  MODIFY COLUMN `analysis`     TEXT                  DEFAULT NULL COMMENT '题目解析',
  MODIFY COLUMN `difficulty`   TINYINT               DEFAULT NULL COMMENT '难度等级（一期可选）',
  MODIFY COLUMN `deleted`      TINYINT      NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
  MODIFY COLUMN `created_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `answer_record` COMMENT = '刷题服务·用户作答历史表';
ALTER TABLE `answer_record`
  MODIFY COLUMN `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`     BIGINT       NOT NULL COMMENT '用户 ID，关联 user.id',
  MODIFY COLUMN `question_id` BIGINT       NOT NULL COMMENT '题目 ID，关联 question.id',
  MODIFY COLUMN `user_answer` VARCHAR(255)          DEFAULT NULL COMMENT '用户提交的答案',
  MODIFY COLUMN `correct`     TINYINT      NOT NULL DEFAULT 0 COMMENT '是否正确：1 正确，0 错误',
  MODIFY COLUMN `source`      VARCHAR(32)           DEFAULT NULL COMMENT '答题来源：daily 每日一练，random 随机刷题',
  MODIFY COLUMN `created_at`  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '作答时间';

ALTER TABLE `wrong_question` COMMENT = '刷题服务·手动错题本表（用户主动收藏，与复习调度独立）';
ALTER TABLE `wrong_question`
  MODIFY COLUMN `id`                BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`           BIGINT       NOT NULL COMMENT '用户 ID，关联 user.id',
  MODIFY COLUMN `question_id`       BIGINT       NOT NULL COMMENT '题目 ID，关联 question.id',
  MODIFY COLUMN `user_answer`       VARCHAR(255)          DEFAULT NULL COMMENT '加入错题本时的错选快照（A/B/C/D）',
  MODIFY COLUMN `analysis_snapshot` TEXT                  DEFAULT NULL COMMENT '加入时的解析快照',
  MODIFY COLUMN `wrong_count`       INT          NOT NULL DEFAULT 1 COMMENT '累计加入次数',
  MODIFY COLUMN `last_wrong_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近一次加入时间',
  MODIFY COLUMN `created_at`        DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '首次加入时间',
  MODIFY COLUMN `updated_at`        DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `study_stats` COMMENT = '刷题服务·用户学习统计汇总表（每日一练打卡等）';
ALTER TABLE `study_stats`
  MODIFY COLUMN `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`        BIGINT       NOT NULL COMMENT '用户 ID，关联 user.id',
  MODIFY COLUMN `total_answered` INT          NOT NULL DEFAULT 0 COMMENT '累计答题数',
  MODIFY COLUMN `correct_count`  INT          NOT NULL DEFAULT 0 COMMENT '累计答对数',
  MODIFY COLUMN `accuracy`       DECIMAL(5,2)           DEFAULT NULL COMMENT '正确率百分比',
  MODIFY COLUMN `streak`         INT          NOT NULL DEFAULT 0 COMMENT '连续打卡天数',
  MODIFY COLUMN `updated_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '统计更新时间',
  MODIFY COLUMN `created_at`     DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间';

ALTER TABLE `user_question_record` COMMENT = '刷题服务·题目间隔复习调度表（驱动随机刷题出题池）';
ALTER TABLE `user_question_record`
  MODIFY COLUMN `id`                   BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`              BIGINT       NOT NULL COMMENT '用户 ID，关联 user.id',
  MODIFY COLUMN `question_id`          BIGINT       NOT NULL COMMENT '题目 ID，关联 question.id',
  MODIFY COLUMN `status`                 VARCHAR(16)  NOT NULL DEFAULT 'NEW' COMMENT '调度状态：NEW/WRONG/RIGHT',
  MODIFY COLUMN `last_answer_time`     DATETIME(3)           DEFAULT NULL COMMENT '上次作答时间',
  MODIFY COLUMN `next_review_time`     DATETIME(3)           DEFAULT NULL COMMENT '允许下次复习的最早时间',
  MODIFY COLUMN `wrong_count`          INT          NOT NULL DEFAULT 0 COMMENT '累计做错次数',
  MODIFY COLUMN `right_count`          INT          NOT NULL DEFAULT 0 COMMENT '累计做对次数（连续做对计间隔）',
  MODIFY COLUMN `review_interval_days` INT          NOT NULL DEFAULT 0 COMMENT '当前复习间隔天数',
  MODIFY COLUMN `created_at`           DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at`           DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

ALTER TABLE `practice_note` COMMENT = '刷题服务·随机刷题备忘录表（答对后手动收藏）';
ALTER TABLE `practice_note`
  MODIFY COLUMN `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`     BIGINT       NOT NULL COMMENT '用户 ID，关联 user.id',
  MODIFY COLUMN `question_id` BIGINT       NOT NULL COMMENT '题目 ID，同一用户不可重复收藏',
  MODIFY COLUMN `stem`        TEXT                  DEFAULT NULL COMMENT '题干快照',
  MODIFY COLUMN `analysis`    TEXT                  DEFAULT NULL COMMENT '解析快照',
  MODIFY COLUMN `user_note`   VARCHAR(2000)         DEFAULT NULL COMMENT '用户自定义备注',
  MODIFY COLUMN `created_at`  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间';

ALTER TABLE `daily_encouragement` COMMENT = '刷题服务·每日一练签到寄语表';
ALTER TABLE `daily_encouragement`
  MODIFY COLUMN `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `content`    VARCHAR(512) NOT NULL COMMENT '寄语正文',
  MODIFY COLUMN `enabled`    TINYINT      NOT NULL DEFAULT 1 COMMENT '是否启用：1 启用，0 停用',
  MODIFY COLUMN `sort_order` INT          NOT NULL DEFAULT 0 COMMENT '排序权重（展示池顺序）',
  MODIFY COLUMN `created_at` DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at` DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';
