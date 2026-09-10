package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("paper_question")
public class PaperQuestion {

    @TableId(type = IdType.AUTO)
    private Long id;
    @TableField("paper_id")
    private Long paperId;
    private Integer seq;
    /** 卷面题号；材料为空；暂缺题仍有题号 */
    @TableField("paper_no")
    private Integer paperNo;
    @TableField("q_type")
    private String qType;
    /** 卷面大题标题 */
    @TableField("section_title")
    private String sectionTitle;
    private String stem;
    @TableField("options_json")
    private String optionsJson;
    private String answer;
    private String analysis;
    private Integer score;
    /** answerable | reveal_only */
    @TableField("input_mode")
    private String inputMode;
    @TableLogic
    private Integer deleted;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
