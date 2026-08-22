package com.yukimomo.user.service;

import cn.hutool.core.util.RandomUtil;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.user.config.UlLoginProperties;
import com.yukimomo.user.constant.UserRedisConstants;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Locale;

/**
 * 登录邮箱验证码：Redis 存储 + 发送（开发环境打日志）。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LoginCodeService {

    private final StringRedisTemplate stringRedisTemplate;
    private final UlLoginProperties loginProperties;

    /**
     * 生成并缓存验证码，同一邮箱在间隔期内不可重复发送。
     */
    public void sendCode(String email) {
        String normalizedEmail = normalizeEmail(email);
        String sendKey = UserRedisConstants.LOGIN_SEND_PREFIX + normalizedEmail;
        //判断sendKey是否存在，如果存在则抛出异常,这里用hasKey是因为hasKey返回的是Boolean类型
        if (Boolean.TRUE.equals(stringRedisTemplate.hasKey(sendKey))) {
            throw new BizException(ErrorCode.LOGIN_CODE_SEND_TOO_FREQUENT);
        }

        String code = RandomUtil.randomNumbers(6);
        String codeKey = UserRedisConstants.LOGIN_CODE_PREFIX + normalizedEmail;
        stringRedisTemplate.opsForValue().set(
                codeKey,
                code,
                Duration.ofSeconds(loginProperties.getCodeTtlSeconds()));

        //设置sendKey的值为1，并设置过期时间,这个1可以是任意值，因为这里只是用来判断是否存在，不存在则设置，存在则抛出异常
        stringRedisTemplate.opsForValue().set(
                sendKey,
                "1",
                Duration.ofSeconds(loginProperties.getSendIntervalSeconds()));

        //返回邮箱和验证码
        dispatchCode(normalizedEmail, code);
    }

    /**
     * 从Redis中获取验证码并校验，成功则删除（一次性）。
     */
    public void verifyAndConsume(String email, String code) {
        String normalizedEmail = normalizeEmail(email);
        String codeKey = UserRedisConstants.LOGIN_CODE_PREFIX + normalizedEmail;
        String cached = stringRedisTemplate.opsForValue().get(codeKey);
        if (cached == null || !cached.equals(code)) {
            throw new BizException(ErrorCode.LOGIN_CODE_INVALID);
        }
        stringRedisTemplate.delete(codeKey);
    }

    private void dispatchCode(String email, String code) {
        if (loginProperties.isDevLogCode()) {
            log.info("【开发模式】邮箱 {} 登录验证码: {}（{} 秒内有效）",
                    email, code, loginProperties.getCodeTtlSeconds());
            return;
        }
        // 二期：接入 Spring Mail 真实发信
        log.warn("未开启 dev-log-code 且未配置邮件服务，验证码仅应通过 dev-log-code 调试");
        log.info("邮箱 {} 登录验证码: {}", email, code);
    }

    private String normalizeEmail(String email) {
        //去空格，转小写,Locale.ROOT 表示使用默认的本地化方式
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
