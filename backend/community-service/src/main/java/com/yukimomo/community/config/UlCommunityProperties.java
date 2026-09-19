package com.yukimomo.community.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "ul.community")
public class UlCommunityProperties {

    private boolean esEnabled = true;
    private boolean mqEnabled = true;
}
