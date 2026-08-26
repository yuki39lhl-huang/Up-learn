package com.yukimomo.practice.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MyBatis-Plus 插件配置。
 * <p>
 * 一期只挂分页插件：Controller 里用 {@code PageQuery#toMpPage()} 后，
 * {@code selectPage} 才会真正拼 LIMIT，并回填 total/pages。
 * 不配此 Bean 时，分页查询可能查出全表或 total 不准。
 */
@Configuration
public class MybatisPlusConfig {

    /**
     * 注册 MP 拦截器链；内层 {@link PaginationInnerInterceptor} 声明数据库类型为 MySQL，
     * 以便生成正确的分页 SQL 方言。
     */
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        // 外层拦截器可挂多个 InnerInterceptor（分页、乐观锁等）
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        // DbType.MYSQL：分页 SQL 用 LIMIT offset,size
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
