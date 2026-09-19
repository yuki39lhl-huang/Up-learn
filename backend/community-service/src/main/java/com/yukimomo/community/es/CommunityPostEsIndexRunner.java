package com.yukimomo.community.es;

import com.yukimomo.community.config.UlCommunityProperties;
import com.yukimomo.community.entity.CommunityPost;
import com.yukimomo.community.mapper.CommunityPostMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class CommunityPostEsIndexRunner implements ApplicationRunner {

    private final ObjectProvider<CommunityPostSearchService> searchService;
    private final CommunityPostMapper postMapper;
    private final UlCommunityProperties properties;

    @Override
    public void run(ApplicationArguments args) {
        if (!properties.isEsEnabled()) {
            return;
        }
        CommunityPostSearchService service = searchService.getIfAvailable();
        if (service == null) {
            return;
        }
        try {
            long count = service.countDocuments();
            if (count > 0) {
                log.info("社区 ES 已有 {} 条，跳过灌入", count);
                return;
            }
            List<CommunityPost> posts = postMapper.selectList(null);
            service.reindexAll(posts);
        } catch (Exception e) {
            log.warn("社区 ES 启动灌入失败: {}", e.getMessage());
        }
    }
}
