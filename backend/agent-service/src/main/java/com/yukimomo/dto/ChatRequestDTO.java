package com.yukimomo.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ChatRequestDTO {

    @NotBlank(message = "消息不能为空")
    private String message;

    /** 会话 ID，不传则服务端生成新会话 */
    private String sessionId;
}
