-- 真题作答明细：主观 AI 评分字段 + 机打答案扩容
ALTER TABLE `paper_attempt_answer`
  MODIFY COLUMN `user_answer` TEXT COMMENT '用户答案（仅 answerable；主观可较长）',
  ADD COLUMN `ai_score` DECIMAL(6, 2) DEFAULT NULL COMMENT 'AI 评分（仅供参考）' AFTER `correct`,
  ADD COLUMN `ai_feedback` TEXT DEFAULT NULL COMMENT 'AI 评语（仅供参考）' AFTER `ai_score`;
