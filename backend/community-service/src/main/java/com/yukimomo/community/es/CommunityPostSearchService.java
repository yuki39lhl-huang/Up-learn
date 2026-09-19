package com.yukimomo.community.es;

import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import com.yukimomo.community.config.UlCommunityProperties;
import com.yukimomo.community.entity.CommunityPost;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.elasticsearch.client.elc.NativeQuery;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.IndexOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "ul.community", name = "es-enabled", havingValue = "true", matchIfMissing = true)
public class CommunityPostSearchService {

    private final ElasticsearchOperations elasticsearchOperations;
    private final UlCommunityProperties properties;

    public boolean isAvailable() {
        if (!properties.isEsEnabled()) {
            return false;
        }
        try {
            elasticsearchOperations.indexOps(CommunityPostDocument.class).exists();
            return true;
        } catch (Exception e) {
            log.warn("社区 ES 不可用: {}", e.getMessage());
            return false;
        }
    }

    public List<Long> searchIds(String kw, int size) {
        if (!StringUtils.hasText(kw)) {
            return Collections.emptyList();
        }
        try {
            String term = kw.trim();
            Query query = Query.of(q -> q.multiMatch(m -> m
                    .query(term)
                    .fields("title^2", "content", "tag")));
            NativeQuery nativeQuery = NativeQuery.builder()
                    .withQuery(query)
                    .withPageable(PageRequest.of(0, Math.min(Math.max(size, 1), 200)))
                    .build();
            SearchHits<CommunityPostDocument> hits =
                    elasticsearchOperations.search(nativeQuery, CommunityPostDocument.class);
            return hits.getSearchHits().stream()
                    .map(SearchHit::getContent)
                    .map(CommunityPostDocument::getId)
                    .map(Long::valueOf)
                    .toList();
        } catch (Exception e) {
            log.warn("社区 ES 检索失败: {}", e.getMessage());
            return null;
        }
    }

    public void index(CommunityPost post) {
        try {
            ensureIndex();
            CommunityPostDocument doc = toDoc(post);
            elasticsearchOperations.save(doc);
        } catch (Exception e) {
            log.warn("社区帖子写入 ES 失败: {}", e.getMessage());
        }
    }

    public void delete(Long postId) {
        if (postId == null) {
            return;
        }
        try {
            elasticsearchOperations.delete(String.valueOf(postId), CommunityPostDocument.class);
        } catch (Exception e) {
            log.warn("社区帖子从 ES 删除失败: {}", e.getMessage());
        }
    }

    public void reindexAll(List<CommunityPost> posts) {
        ensureIndex();
        if (posts == null || posts.isEmpty()) {
            return;
        }
        elasticsearchOperations.save(posts.stream().map(this::toDoc).toList());
        log.info("社区帖子 ES 灌入 {} 条", posts.size());
    }

    public long countDocuments() {
        try {
            IndexOperations ops = elasticsearchOperations.indexOps(CommunityPostDocument.class);
            if (!ops.exists()) {
                return 0L;
            }
            return elasticsearchOperations.count(
                    NativeQuery.builder().withQuery(Query.of(q -> q.matchAll(m -> m))).build(),
                    CommunityPostDocument.class);
        } catch (Exception e) {
            return -1L;
        }
    }

    private void ensureIndex() {
        IndexOperations ops = elasticsearchOperations.indexOps(CommunityPostDocument.class);
        if (!ops.exists()) {
            ops.create();
            ops.putMapping(ops.createMapping(CommunityPostDocument.class));
        }
    }

    private CommunityPostDocument toDoc(CommunityPost post) {
        CommunityPostDocument doc = new CommunityPostDocument();
        doc.setId(String.valueOf(post.getId()));
        doc.setUserId(post.getUserId());
        doc.setTitle(post.getTitle());
        doc.setContent(post.getContent());
        doc.setTag(post.getTag());
        return doc;
    }
}
