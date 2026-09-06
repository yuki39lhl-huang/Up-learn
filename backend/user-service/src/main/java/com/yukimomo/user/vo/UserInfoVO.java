package com.yukimomo.user.vo;

import lombok.Data;

/**
 * 当前登录用户资料响应。
 * <p>
 * {@link #avatarUrl} 为展示用地址：OSS 私有对象经服务端转为短期签名 URL。
 */
@Data
public class UserInfoVO {

    private Long userId;
    private String email;
    private String nickname;
    /** 头像展示 URL（可能为 OSS 签名链接，约 2h 有效） */
    private String avatarUrl;
    /** 是否已设置登录密码（{@code user.password_set = 1}） */
    private boolean hasPassword;
}
