package com.yukimomo.community.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CreatePostDTO {
    @NotBlank
    @Size(max = 120)
    private String title;
    @NotBlank
    @Size(max = 10000)
    private String content;
    @Size(max = 512)
    private String coverUrl;
    @Size(max = 64)
    private String tag;
}
