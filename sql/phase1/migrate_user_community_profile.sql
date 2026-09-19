-- 社区个人主页：简介 + 关注/粉丝列表是否公开
USE `up_learn`;

SET @db := DATABASE();
SET @has_bio := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'user' AND COLUMN_NAME = 'bio'
);
SET @sql_bio := IF(@has_bio = 0,
  'ALTER TABLE `user` ADD COLUMN `bio` VARCHAR(200) NULL COMMENT ''个人简介（社区展示，最多 200 字）'' AFTER `avatar_url`',
  'SELECT 1');
PREPARE stmt FROM @sql_bio; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @has_show := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'user' AND COLUMN_NAME = 'show_follow_list'
);
SET @sql_show := IF(@has_show = 0,
  'ALTER TABLE `user` ADD COLUMN `show_follow_list` TINYINT NOT NULL DEFAULT 1 COMMENT ''是否公开关注/粉丝列表：1 公开，0 仅自己可见'' AFTER `bio`',
  'SELECT 1');
PREPARE stmt FROM @sql_show; EXECUTE stmt; DEALLOCATE PREPARE stmt;
