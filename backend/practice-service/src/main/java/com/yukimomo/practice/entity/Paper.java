package com.yukimomo.practice.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("paper")
public class Paper {

    @TableId(type = IdType.AUTO)
    private Long id;
    private String province;
    private String subject;
    private Integer year;
    private String title;
    @TableField("pdf_url")
    private String pdfUrl;
    @TableField("answer_pdf_url")
    private String answerPdfUrl;
    @TableField("has_answer")
    private Integer hasAnswer;
    private Integer published;
    @TableLogic
    private Integer deleted;
    @TableField("created_at")
    private LocalDateTime createdAt;
    @TableField("updated_at")
    private LocalDateTime updatedAt;
}
