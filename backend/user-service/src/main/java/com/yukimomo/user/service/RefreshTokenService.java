package com.yukimomo.user.service;

import cn.hutool.core.util.RandomUtil;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.user.config.UlRefreshTokenProperties;
import com.yukimomo.user.constant.UserRedisConstants;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;

/**
 * Refresh Token：opaque 字符串存 Redis，用于换取新的 Access JWT。
 */
@Service
@RequiredArgsConstructor
public class RefreshTokenService {

    private static final String VALUE_SEPARATOR = ":";

    private final StringRedisTemplate stringRedisTemplate;
    private final UlRefreshTokenProperties refreshTokenProperties;

    public String create(Long userId, String email) {
        String token = RandomUtil.randomString(64);
        String key = UserRedisConstants.REFRESH_TOKEN_PREFIX + token;
        String value = userId + VALUE_SEPARATOR + email;
        stringRedisTemplate.opsForValue().set(
                key,
                value,
                Duration.ofSeconds(refreshTokenProperties.getRefreshTtlSeconds()));
        return token;
    }

    public RefreshSession validate(String refreshToken) {
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new BizException(ErrorCode.REFRESH_TOKEN_INVALID);
        }
        String key = UserRedisConstants.REFRESH_TOKEN_PREFIX + refreshToken.trim();
        String value = stringRedisTemplate.opsForValue().get(key);
        if (value == null || value.isBlank()) {
            throw new BizException(ErrorCode.REFRESH_TOKEN_INVALID);
        }
        int sep = value.indexOf(VALUE_SEPARATOR);
        if (sep <= 0 || sep >= value.length() - 1) {
            throw new BizException(ErrorCode.REFRESH_TOKEN_INVALID);
        }
        Long userId = Long.parseLong(value.substring(0, sep));
        String email = value.substring(sep + 1);
        return new RefreshSession(userId, email);
    }

    /** 轮换：删除旧 Refresh，签发新 Refresh */
    public String rotate(String oldRefreshToken, Long userId, String email) {
        revoke(oldRefreshToken);
        return create(userId, email);
    }

    public void revoke(String refreshToken) {
        if (refreshToken == null || refreshToken.isBlank()) {
            return;
        }
        stringRedisTemplate.delete(UserRedisConstants.REFRESH_TOKEN_PREFIX + refreshToken.trim());
    }

    public record RefreshSession(Long userId, String email) {
    }
}
