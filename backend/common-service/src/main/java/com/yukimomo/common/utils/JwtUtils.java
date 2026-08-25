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
        //创建有效期时间,当前时间加上accessTtlMs(30分钟)
        Date expiry = new Date(now.getTime() + jwtProperties.getAccessTtlMs());
        //创建JWT构建器,然后这里的每一个api是干嘛的?
        return Jwts.builder()
                .subject(String.valueOf(userId))//主题
                .claim(CLAIM_USER_ID, userId)//方便读取userId
                .claim(CLAIM_EMAIL, email)//方便读取email
                .issuedAt(now)//记录创建时间
                .expiration(expiry)//记录过期时间
                .signWith(secretKey())//用密钥对Header和Payload进行HMAC签名
                .compact();//输出最终字符串
    }

    /** Access Token 有效期（秒），供前端倒计时 */
    public long getAccessExpiresInSeconds() {
        return jwtProperties.getAccessTtlMs() / 1000L;
    }

    //传入需要解析的token,然后jwts调用的每一个api是干嘛的?
    public Claims parseToken(String token) {
        try {
            return Jwts.parser()//创建解析器
                    .verifyWith(secretKey())//用同一密钥对Header和Payload进行HMAC签名
                    .build()//构建解析器
                    .parseSignedClaims(token)//解析 token，验签通过后得到「带签名的 Claims 包装」
                    .getPayload();//取出payload,类型是Claims,Claims是JWT的负载,包含用户信息
        } catch (ExpiredJwtException e) {
            throw new UnauthorizedException("登录已过期，请重新登录");
        } catch (Exception e) {
            throw new UnauthorizedException(ErrorCode.UNAUTHORIZED.getMessage());
        }
    }

    //根据token获取用户id
    public Long getUserId(String token) {
        //解析token,获取Claims对象,这个claims对象是什么?
        Claims claims = parseToken(token);
        //创建的时候uid是userId的键,直接get得到用户id
        Object uid = claims.get(CLAIM_USER_ID);
        //如果uid是Number类型,则返回uid的long值
        if (uid instanceof Number number) {
            return number.longValue();
        }
        //如果uid没读到,则读取subject,subject是主题,主题是userId的String值
        String subject = claims.getSubject();
        //如果subject不为空,则返回subject的long值
        if (subject != null && !subject.isBlank()) {
            return Long.parseLong(subject);
        }
        //两条链路都读不到,则抛出异常
        throw new UnauthorizedException();
    }

    //根据token获取用户邮箱
    public String getEmail(String token) {
        Claims claims = parseToken(token);
        //创建的时候email是email的键,直接get得到用户邮箱,这里String.class是类型,指定返回类型为String
        return claims.get(CLAIM_EMAIL, String.class);
    }

    //创建密钥,使用jwtProperties.getSecret()作为密钥,getBytes(StandardCharsets.UTF_8)将字符串转换为字节数组,然后使用Keys.hmacShaKeyFor(keyBytes)创建密钥
    private SecretKey secretKey() {
        byte[] keyBytes = jwtProperties.getSecret().getBytes(StandardCharsets.UTF_8);
        //使用hmacShaKeyFor方法创建密钥,把字节数组包装成 SecretKey，给 HMAC-SHA（你项目里是 HS256）签名/验签用
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
