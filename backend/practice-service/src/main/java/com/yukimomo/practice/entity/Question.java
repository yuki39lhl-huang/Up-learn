package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 题库表 {@code question} 实体。
 * <p>
 * 出题接口只把题干/选项等映射到 {@link com.yukimomo.practice.vo.QuestionVO}，
 * 不把 {@link #answer}/{@link #analysis} 返回给前端（防作弊）；提交后再在结果 VO 中返回。
 */
@Data
@TableName("question")
public class Question {

    /** 主键，自增 */
    @TableId(type = IdType.AUTO)
    private Long id;
    /** 科目：政治 / 大学英语 / 高等数学 / 计算机基础（精确匹配筛选） */
    private String subject;
    /** 题干正文 */
    private String stem;
    /**
     * 选项 JSON 字符串，库中类型为 JSON。
     * 形如 {@code ["A.xxx","B.xxx","C.xxx","D.xxx"]}；业务层用 Hutool 解析成 List。
     */
    @TableField("options_json")
    private String optionsJson;
    /** 标准答案字母：A / B / C / D */
    private String answer;
    /** 题目解析（提交答对/答错后才返回） */
    private String analysis;
    /** 难度 1～5，可空 */
    private Integer difficulty;
    /** 逻辑删除：1 已删，0 未删；MP 查询自动带 deleted=0 */
    @TableLogic
    private Integer deleted;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
