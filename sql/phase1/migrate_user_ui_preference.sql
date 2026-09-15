-- 用户界面偏好（主题 / 语言 / 双层壁纸 / 透明度 / 铺满方式 / 侧栏）
USE `up_learn`;

CREATE TABLE IF NOT EXISTS `user_ui_preference` (
  `user_id`              BIGINT       NOT NULL COMMENT '用户 ID；与 user.id 一对一',
  `theme`                VARCHAR(16)  NOT NULL DEFAULT 'light' COMMENT '主题：light / dark',
  `locale`               VARCHAR(16)  NOT NULL DEFAULT 'zh-CN' COMMENT '语言：zh-CN / en-US',
  `wallpaper_url`        VARCHAR(512)          DEFAULT NULL COMMENT '底层背景图 canonical OSS URL',
  `panel_wallpaper_url`  VARCHAR(512)          DEFAULT NULL COMMENT '主展示区壁纸 canonical OSS URL',
  `panel_wallpaper_fit`  VARCHAR(16)  NOT NULL DEFAULT 'cover' COMMENT '主展示区壁纸：cover/contain/fill',
  `shell_bg_opacity`     INT          NOT NULL DEFAULT 100 COMMENT '底层背景透明度 0–100',
  `shell_wallpaper_fit`  VARCHAR(16)  NOT NULL DEFAULT 'cover' COMMENT '底层壁纸：cover/contain/fill',
  `panel_opacity`        INT          NOT NULL DEFAULT 100 COMMENT '主展示层面板背景透明度 0–100',
  `module_opacity`       INT          NOT NULL DEFAULT 85 COMMENT '模块展示框能见度 0–100',
  `module_blur`          INT          NOT NULL DEFAULT 67 COMMENT '模块毛玻璃强度 0–100',
  `sidebar_collapsed`    TINYINT      NOT NULL DEFAULT 0 COMMENT '侧栏默认折叠：0 否，1 是',
  `created_at`           DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `updated_at`           DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='用户服务·界面偏好（主题、语言、壁纸与透明度）';

-- 若早期误建列名为 heme，执行下方语句修复：
-- ALTER TABLE `user_ui_preference` CHANGE COLUMN `heme` `theme` VARCHAR(16) NOT NULL DEFAULT 'light' COMMENT '主题：light / dark';
