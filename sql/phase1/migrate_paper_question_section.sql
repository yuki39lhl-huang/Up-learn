-- 卷面大题标题 + 卷面题号（回忆版空大题占位时仍保留原序号）
USE up_learn;

ALTER TABLE `paper_question`
  ADD COLUMN `section_title` VARCHAR(256) DEFAULT NULL COMMENT '卷面大题标题（如「三、名词解释题…」）' AFTER `q_type`,
  ADD COLUMN `paper_no` INT DEFAULT NULL COMMENT '卷面题号；材料为 NULL；暂缺题仍有题号' AFTER `seq`;
