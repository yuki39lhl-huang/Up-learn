package com.yukimomo.school.es;

import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import com.yukimomo.school.config.UlSchoolProperties;
import com.yukimomo.school.entity.School;
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

/**
 * 院校 ES 检索与索引灌入；异常时返回 null，由业务层回落 MySQL。
 */
@Slf4j
@Service
@RequiredArgsConstructor
@ConditionalOnProperty(prefix = "ul.school", name = "es-enabled", havingValue = "true", matchIfMissing = true)
public class SchoolSearchService {

    private static final int MAX_HITS = 500;

    private final ElasticsearchOperations elasticsearchOperations;
    private final UlSchoolProperties schoolProperties;

    public boolean isAvailable() {
        if (!schoolProperties.isEsEnabled()) {
            return false;
        }
        try {
            elasticsearchOperations.indexOps(SchoolDocument.class).exists();
            return true;
        } catch (Exception e) {
            log.warn("ES 不可用，院校检索将回落 MySQL: {}", e.getMessage());
            return false;
        }
    }

    /**
     * 按校名关键词检索，按相关度返回 schoolId 列表；失败返回 {@code null}。
     */
    public List<Long> searchIdsByKeyword(String kw) {
        if (!StringUtils.hasText(kw)) {
            return Collections.emptyList();
        }
        String term = kw.trim();
        try {
            String wildcard = "*" + escapeWildcard(term) + "*";
            Query query = Query.of(q -> q.bool(b -> b
                    .should(s -> s.match(m -> m.field("name").query(term)))
                    .should(s -> s.wildcard(w -> w
                            .field("name.keyword")
                            .value(wildcard)
                            .caseInsensitive(true)))
                    .minimumShouldMatch("1")));
            NativeQuery nativeQuery = NativeQuery.builder()
                    .withQuery(query)
                    .withPageable(PageRequest.of(0, MAX_HITS))
                    .build();
            SearchHits<SchoolDocument> hits = elasticsearchOperations.search(nativeQuery, SchoolDocument.class);
            return hits.getSearchHits().stream()
                    .map(SearchHit::getContent)
                    .map(SchoolDocument::getId)
                    .filter(StringUtils::hasText)
                    .map(Long::valueOf)
                    .toList();
        } catch (Exception e) {
            log.warn("ES 院校检索失败，回落 MySQL LIKE: {}", e.getMessage());
            return null;
        }
    }

    public void reindexAll(List<School> schools) {
        IndexOperations indexOps = elasticsearchOperations.indexOps(SchoolDocument.class);
        if (!indexOps.exists()) {
            indexOps.create();
            indexOps.putMapping(indexOps.createMapping(SchoolDocument.class));
        }
        if (schools == null || schools.isEmpty()) {
            return;
        }
        List<SchoolDocument> docs = schools.stream().map(this::toDocument).toList();
        elasticsearchOperations.save(docs);
        log.info("ES 院校索引灌入完成，共 {} 条", docs.size());
    }

    public long countDocuments() {
        try {
            IndexOperations indexOps = elasticsearchOperations.indexOps(SchoolDocument.class);
            if (!indexOps.exists()) {
                return 0L;
            }
            return elasticsearchOperations.count(NativeQuery.builder().withQuery(Query.of(q -> q.matchAll(m -> m))).build(),
                    SchoolDocument.class);
        } catch (Exception e) {
            log.warn("读取 ES 院校文档数失败: {}", e.getMessage());
            return -1L;
        }
    }

    private SchoolDocument toDocument(School school) {
        SchoolDocument doc = new SchoolDocument();
        doc.setId(String.valueOf(school.getId()));
        doc.setName(school.getName());
        doc.setProvince(school.getProvince());
        doc.setType(school.getType());
        doc.setPreferPublic(school.getPreferPublic());
        doc.setMajorCount(school.getMajorCount());
        return doc;
    }

    private static String escapeWildcard(String raw) {
        return raw.replace("\\", "\\\\")
                .replace("*", "\\*")
                .replace("?", "\\?");
    }
}
