-- 界面偏好 v3：模块毛玻璃强度（若 v2 已执行且无此列则跑本脚本）
USE `up_learn`;

ALTER TABLE `user_ui_preference`
  ADD COLUMN `module_blur` INT NOT NULL DEFAULT 67 COMMENT '模块毛玻璃强度 0–100' AFTER `module_opacity`;
