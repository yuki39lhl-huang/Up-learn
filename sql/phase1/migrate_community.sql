-- =============================================================================
-- migrate_community.sql
-- 社区模块表（同库 up_learn）；字段均含中文注释
-- 可重复执行：CREATE IF NOT EXISTS + ALTER 修正注释/乱码
-- 执行（务必 utf8mb4）：
--   mysql --default-character-set=utf8mb4 -h127.0.0.1 -P3308 -uroot -p up_learn < sql/phase1/migrate_community.sql
-- =============================================================================
USE `up_learn`;

CREATE TABLE IF NOT EXISTS `community_post` (
    `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`        BIGINT       NOT NULL COMMENT '作者用户 ID，关联 user.id',
    `title`          VARCHAR(120) NOT NULL COMMENT '帖子标题',
    `content`        TEXT         NOT NULL COMMENT '帖子正文',
    `cover_url`      VARCHAR(512)          DEFAULT NULL COMMENT '封面图 URL（可选，OSS 公网地址）',
    `tag`            VARCHAR(64)           DEFAULT NULL COMMENT '话题标签，如经验/院校/专业/科目',
    `like_count`     INT          NOT NULL DEFAULT 0 COMMENT '点赞数',
    `comment_count`  INT          NOT NULL DEFAULT 0 COMMENT '评论数（含二级回复）',
    `favorite_count` INT          NOT NULL DEFAULT 0 COMMENT '收藏数',
    `status`         TINYINT      NOT NULL DEFAULT 1 COMMENT '状态：1 正常，0 隐藏',
    `deleted`        TINYINT      NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
    `created_at`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_post_user` (`user_id`),
    KEY `idx_post_created` (`created_at`),
    KEY `idx_post_like` (`like_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区服务·帖子表';

CREATE TABLE IF NOT EXISTS `community_comment` (
    `id`               BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    `post_id`          BIGINT        NOT NULL COMMENT '所属帖子 ID，关联 community_post.id',
    `user_id`          BIGINT        NOT NULL COMMENT '评论用户 ID，关联 user.id',
    `parent_id`        BIGINT                 DEFAULT NULL COMMENT '一级评论 ID；NULL 表示一级评论，非空表示二级回复',
    `reply_to_user_id` BIGINT                 DEFAULT NULL COMMENT '被回复用户 ID（二级回复时）',
    `content`          VARCHAR(1000) NOT NULL COMMENT '评论/回复正文',
    `like_count`       INT           NOT NULL DEFAULT 0 COMMENT '点赞数',
    `status`           TINYINT       NOT NULL DEFAULT 1 COMMENT '状态：1 正常，0 隐藏',
    `deleted`          TINYINT       NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
    `created_at`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_cmt_post` (`post_id`),
    KEY `idx_cmt_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区服务·评论表（仅支持二级）';

CREATE TABLE IF NOT EXISTS `community_like` (
    `id`          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`     BIGINT      NOT NULL COMMENT '点赞用户 ID，关联 user.id',
    `target_type` VARCHAR(16) NOT NULL COMMENT '目标类型：POST 帖子 / COMMENT 评论',
    `target_id`   BIGINT      NOT NULL COMMENT '目标 ID（帖子或评论主键）',
    `created_at`  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_like` (`user_id`, `target_type`, `target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区服务·点赞表';

CREATE TABLE IF NOT EXISTS `community_favorite` (
    `id`         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`    BIGINT   NOT NULL COMMENT '收藏用户 ID，关联 user.id',
    `post_id`    BIGINT   NOT NULL COMMENT '收藏帖子 ID，关联 community_post.id',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_fav` (`user_id`, `post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区服务·收藏表';

CREATE TABLE IF NOT EXISTS `community_follow` (
    `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `follower_id` BIGINT   NOT NULL COMMENT '关注者用户 ID',
    `followee_id` BIGINT   NOT NULL COMMENT '被关注者用户 ID',
    `created_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_follow` (`follower_id`, `followee_id`),
    KEY `idx_followee` (`followee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区服务·关注关系表';

CREATE TABLE IF NOT EXISTS `community_notification` (
    `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`    BIGINT       NOT NULL COMMENT '接收人用户 ID',
    `type`       VARCHAR(32)  NOT NULL COMMENT '通知类型：COMMENT / LIKE / FOLLOW 等',
    `ref_id`     BIGINT                DEFAULT NULL COMMENT '关联业务 ID（帖子/评论等）',
    `actor_id`   BIGINT                DEFAULT NULL COMMENT '触发人用户 ID',
    `content`    VARCHAR(255)          DEFAULT NULL COMMENT '通知文案摘要',
    `read_flag`  TINYINT      NOT NULL DEFAULT 0 COMMENT '已读标记：0 未读，1 已读',
    `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_notif_user` (`user_id`, `read_flag`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社区服务·站内通知表';

-- ---------------------------------------------------------------------------
-- 修正已存在表的字段注释（修复导入乱码；可重复执行）
-- ---------------------------------------------------------------------------

ALTER TABLE `community_post` COMMENT = '社区服务·帖子表';
ALTER TABLE `community_post`
  MODIFY COLUMN `id`             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`        BIGINT       NOT NULL COMMENT '作者用户 ID，关联 user.id',
  MODIFY COLUMN `title`          VARCHAR(120) NOT NULL COMMENT '帖子标题',
  MODIFY COLUMN `content`        TEXT         NOT NULL COMMENT '帖子正文',
  MODIFY COLUMN `cover_url`      VARCHAR(512)          DEFAULT NULL COMMENT '封面图 URL（可选，OSS 公网地址）',
  MODIFY COLUMN `tag`            VARCHAR(64)           DEFAULT NULL COMMENT '话题标签，如经验/院校/专业/科目',
  MODIFY COLUMN `like_count`     INT          NOT NULL DEFAULT 0 COMMENT '点赞数',
  MODIFY COLUMN `comment_count`  INT          NOT NULL DEFAULT 0 COMMENT '评论数（含二级回复）',
  MODIFY COLUMN `favorite_count` INT          NOT NULL DEFAULT 0 COMMENT '收藏数',
  MODIFY COLUMN `status`         TINYINT      NOT NULL DEFAULT 1 COMMENT '状态：1 正常，0 隐藏',
  MODIFY COLUMN `deleted`        TINYINT      NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
  MODIFY COLUMN `created_at`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  MODIFY COLUMN `updated_at`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间';

ALTER TABLE `community_comment` COMMENT = '社区服务·评论表（仅支持二级）';
ALTER TABLE `community_comment`
  MODIFY COLUMN `id`               BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `post_id`          BIGINT        NOT NULL COMMENT '所属帖子 ID，关联 community_post.id',
  MODIFY COLUMN `user_id`          BIGINT        NOT NULL COMMENT '评论用户 ID，关联 user.id',
  MODIFY COLUMN `parent_id`        BIGINT                 DEFAULT NULL COMMENT '一级评论 ID；NULL 表示一级评论，非空表示二级回复',
  MODIFY COLUMN `reply_to_user_id` BIGINT                 DEFAULT NULL COMMENT '被回复用户 ID（二级回复时）',
  MODIFY COLUMN `content`          VARCHAR(1000) NOT NULL COMMENT '评论/回复正文',
  MODIFY COLUMN `like_count`       INT           NOT NULL DEFAULT 0 COMMENT '点赞数',
  MODIFY COLUMN `status`           TINYINT       NOT NULL DEFAULT 1 COMMENT '状态：1 正常，0 隐藏',
  MODIFY COLUMN `deleted`          TINYINT       NOT NULL DEFAULT 0 COMMENT '软删除：0 正常，1 已删除',
  MODIFY COLUMN `created_at`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  MODIFY COLUMN `updated_at`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间';

ALTER TABLE `community_like` COMMENT = '社区服务·点赞表';
ALTER TABLE `community_like`
  MODIFY COLUMN `id`          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`     BIGINT      NOT NULL COMMENT '点赞用户 ID，关联 user.id',
  MODIFY COLUMN `target_type` VARCHAR(16) NOT NULL COMMENT '目标类型：POST 帖子 / COMMENT 评论',
  MODIFY COLUMN `target_id`   BIGINT      NOT NULL COMMENT '目标 ID（帖子或评论主键）',
  MODIFY COLUMN `created_at`  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间';

ALTER TABLE `community_favorite` COMMENT = '社区服务·收藏表';
ALTER TABLE `community_favorite`
  MODIFY COLUMN `id`         BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`    BIGINT   NOT NULL COMMENT '收藏用户 ID，关联 user.id',
  MODIFY COLUMN `post_id`    BIGINT   NOT NULL COMMENT '收藏帖子 ID，关联 community_post.id',
  MODIFY COLUMN `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间';

ALTER TABLE `community_follow` COMMENT = '社区服务·关注关系表';
ALTER TABLE `community_follow`
  MODIFY COLUMN `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `follower_id` BIGINT   NOT NULL COMMENT '关注者用户 ID',
  MODIFY COLUMN `followee_id` BIGINT   NOT NULL COMMENT '被关注者用户 ID',
  MODIFY COLUMN `created_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间';

ALTER TABLE `community_notification` COMMENT = '社区服务·站内通知表';
ALTER TABLE `community_notification`
  MODIFY COLUMN `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `user_id`    BIGINT       NOT NULL COMMENT '接收人用户 ID',
  MODIFY COLUMN `type`       VARCHAR(32)  NOT NULL COMMENT '通知类型：COMMENT / LIKE / FOLLOW 等',
  MODIFY COLUMN `ref_id`     BIGINT                DEFAULT NULL COMMENT '关联业务 ID（帖子/评论等）',
  MODIFY COLUMN `actor_id`   BIGINT                DEFAULT NULL COMMENT '触发人用户 ID',
  MODIFY COLUMN `content`    VARCHAR(255)          DEFAULT NULL COMMENT '通知文案摘要',
  MODIFY COLUMN `read_flag`  TINYINT      NOT NULL DEFAULT 0 COMMENT '已读标记：0 未读，1 已读',
  MODIFY COLUMN `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间';
