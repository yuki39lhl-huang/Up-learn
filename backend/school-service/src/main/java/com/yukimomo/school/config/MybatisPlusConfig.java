package com.yukimomo.school.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MyBatis-Plus 插件配置。
 * <p>
 * 注册分页插件，使 {@code selectPage} 能正确生成 LIMIT 并回填 total。
 */
@Configuration
public class MybatisPlusConfig {

    /**
     * 注册 MP 拦截器链（当前仅分页）。
     *
     * @return 已挂载 MySQL 分页插件的拦截器
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        // 指定 DbType.MYSQL，分页 SQL 语法与 MySQL 一致
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
