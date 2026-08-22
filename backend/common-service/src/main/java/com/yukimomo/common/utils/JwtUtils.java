package com.yukimomo.common.utils;

import com.yukimomo.common.config.UlJwtProperties;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.common.exception.UnauthorizedException;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * Access JWT 签发与解析（HMAC-SHA256）。
 */
@Component
@RequiredArgsConstructor
public class JwtUtils {

    private static final String CLAIM_USER_ID = "uid";
    private static final String CLAIM_EMAIL = "email";

    private final UlJwtProperties jwtProperties;

    /** 签发 Access Token（短效，网关与业务 API 使用） */
    public String createAccessToken(Long userId, String email) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + jwtProperties.getAccessTtlMs());
        return Jwts.builder()
                .subject(String.valueOf(userId))
                .claim(CLAIM_USER_ID, userId)
                .claim(CLAIM_EMAIL, email)
                .issuedAt(now)
                .expiration(expiry)
                .signWith(secretKey())
                .compact();
    }

    /** Access Token 有效期（秒），供前端倒计时 */
    public long getAccessExpiresInSeconds() {
        return jwtProperties.getAccessTtlMs() / 1000L;
    }

    public Claims parseToken(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(secretKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (ExpiredJwtException e) {
            throw new UnauthorizedException("登录已过期，请重新登录");
        } catch (Exception e) {
            throw new UnauthorizedException(ErrorCode.UNAUTHORIZED.getMessage());
        }
    }

    public Long getUserId(String token) {
        Claims claims = parseToken(token);
        Object uid = claims.get(CLAIM_USER_ID);
        if (uid instanceof Number number) {
            return number.longValue();
        }
        String subject = claims.getSubject();
        if (subject != null && !subject.isBlank()) {
            return Long.parseLong(subject);
        }
        throw new UnauthorizedException();
    }

    public String getEmail(String token) {
        Claims claims = parseToken(token);
        return claims.get(CLAIM_EMAIL, String.class);
    }

    private SecretKey secretKey() {
        byte[] keyBytes = jwtProperties.getSecret().getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
