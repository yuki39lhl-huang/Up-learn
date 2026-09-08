-- 强制表/列为 utf8mb4，避免客户端显示 COMMENT 为 ???
USE up_learn;
SET NAMES utf8mb4;

ALTER TABLE `paper` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `paper_question` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `paper_attempt` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `paper_attempt_answer` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
