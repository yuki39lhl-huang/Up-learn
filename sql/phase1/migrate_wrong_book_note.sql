-- =============================================================================
-- migrate_wrong_book_note.sql
-- 错题本扩展字段 + 备忘录唯一约束（可重复执行需手动跳过已存在列/索引）
-- 执行：mysql -h host -P port -u root -p up_learn < sql/phase1/migrate_wrong_book_note.sql
-- =============================================================================
USE `up_learn`;

-- wrong_question：手动错题本需保存用户错选与解析快照（与题目表解耦，防止原题改动）
ALTER TABLE `wrong_question`
  ADD COLUMN `user_answer` VARCHAR(255) NULL COMMENT '加入错题本时用户的错选选项，如 A/B/C/D' AFTER `question_id`,
  ADD COLUMN `analysis_snapshot` TEXT NULL COMMENT '加入时的解析快照，优先于 question.analysis 展示' AFTER `user_answer`;

-- practice_note：同一用户同一题只允许一条备忘录（清理重复后加唯一索引）
DELETE n1 FROM `practice_note` n1
  INNER JOIN `practice_note` n2
    ON n1.`user_id` = n2.`user_id`
   AND n1.`question_id` = n2.`question_id`
   AND n1.`id` > n2.`id`;

ALTER TABLE `practice_note`
  ADD UNIQUE KEY `uk_note_user_question` (`user_id`, `question_id`);
