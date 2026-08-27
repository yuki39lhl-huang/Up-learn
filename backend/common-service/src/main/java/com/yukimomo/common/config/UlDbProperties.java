package com.yukimomo.common.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * MySQL 连接占位符（{@code ul.db.*}），供 {@code application-{profile}.yml} 与 JDBC URL 引用。
 */
@Data
@ConfigurationProperties(prefix = "ul.db")
public class UlDbProperties {

    /** 主机：local 用 localhost，dev/Docker 用 ul-mysql */
    private String host = "localhost";

    /** 端口：local 映射口（如 3308），容器内 3306 */
    private int port = 3308;

    /** root 密码 */
    private String pw = "1234";
}
