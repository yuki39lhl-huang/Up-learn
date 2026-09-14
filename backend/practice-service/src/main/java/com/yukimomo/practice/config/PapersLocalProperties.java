package com.yukimomo.practice.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 本地真题 PDF 目录与 AI 评分开关。
 */
@Data
@ConfigurationProperties(prefix = "ul.papers")
public class PapersLocalProperties {

    /**
     * shijuan 根目录绝对或相对路径。
     * 例：项目根下 {@code shijuan}，则 pdf_url 存相对路径如
     * {@code 广东专升本-历年真题/高数/01.2024年广东专升本高数真题-题目.pdf}
     */
    private String localDir = "shijuan";

    /**
     * 是否允许主观题 AI 评分（练习开；模考可关）。
     */
    private boolean aiScoreEnabled = true;
}
