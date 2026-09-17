package com.yukimomo.school.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 院校 Elasticsearch 检索开关（{@code ul.school.*}）。
 */
@Data
@ConfigurationProperties(prefix = "ul.school")
public class UlSchoolProperties {

    /** 是否启用 ES 关键词检索；失败时自动回落 MySQL LIKE */
    private boolean esEnabled = true;
}
