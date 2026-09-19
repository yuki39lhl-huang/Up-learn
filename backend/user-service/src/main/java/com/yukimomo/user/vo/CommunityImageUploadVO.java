package com.yukimomo.user.vo;

import lombok.Data;

/** 社区配图上传结果。 */
@Data
public class CommunityImageUploadVO {
    /** 可写入帖子正文的公网 URL */
    private String url;
}
