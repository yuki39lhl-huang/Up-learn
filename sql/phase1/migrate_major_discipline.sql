-- 专业词典扩展：门类 / 代码 / 考试轨道；院校开设扩展广东招生字段
-- 开发环境可重复执行（已存在的列/索引会跳过）
USE `up_learn`;

-- ---------- major_dict 加列 ----------
SET @db := DATABASE();

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='major_dict' AND COLUMN_NAME='discipline') = 0,
    'ALTER TABLE `major_dict` ADD COLUMN `discipline` VARCHAR(32) DEFAULT NULL COMMENT ''门类，如工学/管理学/医学'' AFTER `name`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='major_dict' AND COLUMN_NAME='code') = 0,
    'ALTER TABLE `major_dict` ADD COLUMN `code` VARCHAR(32) DEFAULT NULL COMMENT ''官方专业代码（有则填）'' AFTER `major_category`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='major_dict' AND COLUMN_NAME='exam_track') = 0,
    'ALTER TABLE `major_dict` ADD COLUMN `exam_track` VARCHAR(16) DEFAULT NULL COMMENT ''统考/校考/混合'' AFTER `code`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.statistics
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='major_dict' AND INDEX_NAME='idx_major_dict_discipline_category') = 0,
    'ALTER TABLE `major_dict` ADD KEY `idx_major_dict_discipline_category` (`discipline`, `major_category`)',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- ---------- school_major 加列 ----------
SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='display_name') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `display_name` VARCHAR(128) DEFAULT NULL COMMENT ''招生展示名（含方向/班型）'' AFTER `major_dict_id`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='major_group') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `major_group` VARCHAR(16) DEFAULT NULL COMMENT ''专业组'' AFTER `display_name`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='major_code') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `major_code` VARCHAR(16) DEFAULT NULL COMMENT ''专业号'' AFTER `major_group`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='campus') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `campus` VARCHAR(128) DEFAULT NULL COMMENT ''教学地点'' AFTER `major_code`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='exam_type') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `exam_type` VARCHAR(16) DEFAULT NULL COMMENT ''统考/校考'' AFTER `campus`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='foundation_subject') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `foundation_subject` VARCHAR(128) DEFAULT NULL COMMENT ''专业基础课'' AFTER `exam_type`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='comprehensive_subject') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `comprehensive_subject` VARCHAR(128) DEFAULT NULL COMMENT ''专业综合课'' AFTER `foundation_subject`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='prerequisite') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `prerequisite` VARCHAR(64) DEFAULT NULL COMMENT ''前置要求：不限/限招等'' AFTER `comprehensive_subject`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND COLUMN_NAME='batch_name') = 0,
    'ALTER TABLE `school_major` ADD COLUMN `batch_name` VARCHAR(32) DEFAULT NULL COMMENT ''批次，如普通批'' AFTER `prerequisite`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- 唯一键：同校同年可有多组同词典专业
SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.statistics
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND INDEX_NAME='uk_school_major_year') > 0,
    'ALTER TABLE `school_major` DROP INDEX `uk_school_major_year`',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @sql := (
  SELECT IF(
    (SELECT COUNT(*) FROM information_schema.statistics
     WHERE TABLE_SCHEMA=@db AND TABLE_NAME='school_major' AND INDEX_NAME='uk_school_major_offer') = 0,
    'ALTER TABLE `school_major` ADD UNIQUE KEY `uk_school_major_offer` (`school_id`, `year`, `major_group`, `major_code`)',
    'SELECT 1'
  )
);
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;
