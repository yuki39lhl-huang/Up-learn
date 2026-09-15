-- 界面偏好 v2：主展示区壁纸、模块能见度、壁纸铺满方式
-- 已有库执行本脚本；新建库直接用 migrate_user_ui_preference.sql / up_learn.sql
USE `up_learn`;

ALTER TABLE `user_ui_preference`
  ADD COLUMN `panel_wallpaper_url`  VARCHAR(512)         DEFAULT NULL COMMENT '主展示区壁纸 canonical OSS URL' AFTER `wallpaper_url`,
  ADD COLUMN `panel_wallpaper_fit`  VARCHAR(16) NOT NULL DEFAULT 'cover' COMMENT '主展示区壁纸：cover/contain/fill' AFTER `panel_wallpaper_url`,
  ADD COLUMN `shell_wallpaper_fit`  VARCHAR(16) NOT NULL DEFAULT 'cover' COMMENT '底层壁纸：cover/contain/fill' AFTER `shell_bg_opacity`,
  ADD COLUMN `module_opacity`       INT         NOT NULL DEFAULT 85 COMMENT '模块展示框能见度 0–100' AFTER `panel_opacity`,
  ADD COLUMN `module_blur`          INT         NOT NULL DEFAULT 67 COMMENT '模块毛玻璃强度 0–100' AFTER `module_opacity`;
