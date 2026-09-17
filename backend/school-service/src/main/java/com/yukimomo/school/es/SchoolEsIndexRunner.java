package com.yukimomo.school.es;

import com.yukimomo.school.config.UlSchoolProperties;
import com.yukimomo.school.entity.School;
import com.yukimomo.school.mapper.SchoolMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 启动时若 ES 索引为空则从 MySQL 全量灌入院校文档。
 */
@Slf4j
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "ul.school", name = "es-enabled", havingValue = "true", matchIfMissing = true)
public class SchoolEsIndexRunner implements ApplicationRunner {

    private final SchoolSearchService schoolSearchService;
    private final SchoolMapper schoolMapper;
    private final UlSchoolProperties schoolProperties;

    @Override
    public void run(ApplicationArguments args) {
        if (!schoolProperties.isEsEnabled()) {
            return;
        }
        try {
            long count = schoolSearchService.countDocuments();
            if (count > 0) {
                log.info("ES 院校索引已有 {} 条，跳过启动灌入", count);
                return;
            }
            List<School> schools = schoolMapper.selectList(null);
            schoolSearchService.reindexAll(schools);
        } catch (Exception e) {
            log.warn("启动灌入 ES 院校索引失败（将回落 MySQL）: {}", e.getMessage());
        }
    }
}
