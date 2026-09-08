package com.yukimomo.practice.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 本地真题 PDF 目录（开发机导入源 / OSS 未启用时直读）。
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
}
