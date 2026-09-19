package com.yukimomo.community.es;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@Data
@Document(indexName = CommunityPostDocument.INDEX)
public class CommunityPostDocument {
    public static final String INDEX = "ul_community_post";

    @Id
    private String id;
    @Field(type = FieldType.Long)
    private Long userId;
    @Field(type = FieldType.Text)
    private String title;
    @Field(type = FieldType.Text)
    private String content;
    @Field(type = FieldType.Keyword)
    private String tag;
}
