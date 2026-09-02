-- 修复：表/字段中文注释 + 寄语数据乱码（????）
-- 执行：mysql --default-character-set=utf8mb4 -h localhost -P 3308 -u root -p up_learn < migrate_daily_encouragement_fix.sql
USE `up_learn`;

ALTER TABLE `daily_encouragement` COMMENT = '刷题服务·每日一练签到寄语表';
ALTER TABLE `daily_encouragement`
  MODIFY COLUMN `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  MODIFY COLUMN `content`    VARCHAR(512) NOT NULL COMMENT '寄语正文',
  MODIFY COLUMN `enabled`    TINYINT      NOT NULL DEFAULT 1 COMMENT '是否启用：1 启用，0 停用',
  MODIFY COLUMN `sort_order` INT          NOT NULL DEFAULT 0 COMMENT '排序权重（展示池顺序）',
  MODIFY COLUMN `created_at` DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  MODIFY COLUMN `updated_at` DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间';

DELETE FROM `daily_encouragement`;

INSERT INTO `daily_encouragement` (`content`, `enabled`, `sort_order`) VALUES
('坚持一点点，离目标就近一点点。', 1, 1),
('今天的努力，是明天从容的底气。', 1, 2),
('别和别人比进度，只和昨天的自己比。', 1, 3),
('刷一题也是进步，签到就是胜利。', 1, 4),
('备考是马拉松，稳住节奏最重要。', 1, 5),
('错题不可怕，可怕的是不再回头看。', 1, 6),
('把每天的一题做扎实，胜过突击十题。', 1, 7),
('你正在走的路，很多人都曾走过并抵达。', 1, 8),
('专注当下这一题，未来会感谢现在的你。', 1, 9),
('休息可以，放弃不行；明天继续就好。', 1, 10),
('每一次打卡，都在为梦想攒积分。', 1, 11),
('相信自己，你比想象中更能坚持。', 1, 12),
('小步快跑，专科上岸并不遥远。', 1, 13),
('今天的坚持，会在考场上变成自信。', 1, 14),
('把焦虑换成行动，把行动换成习惯。', 1, 15),
('你已经开始了，这比完美计划更可贵。', 1, 16),
('再坚持一天，就又多一分胜算。', 1, 17),
('学习像种树，每天浇灌终会成荫。', 1, 18),
('别怕慢，只怕站；签到就是向前一步。', 1, 19),
('给今天的自己点个赞，明天继续加油。', 1, 20);
