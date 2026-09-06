-- 用户是否已设置登录密码（验证码注册用户默认为 0）
USE `up_learn`;

ALTER TABLE `user`
  ADD COLUMN `password_set` TINYINT NOT NULL DEFAULT 0
    COMMENT '是否已设置登录密码：0 否（仅验证码），1 是'
    AFTER `password_hash`;
