package com.yukimomo.community.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CreateCommentDTO {
    @NotBlank
    @Size(max = 1000)
    private String content;
    /** 回复目标评论 id：传一级挂其下；传二级则挂到同一一级并 @ 该用户（不做三级） */
    private Long parentId;
}
