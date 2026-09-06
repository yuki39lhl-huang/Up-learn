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
 * 登录 / 重置密码邮箱验证码：Redis 存储 + 发送（开发环境打日志）。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LoginCodeService {

    private final StringRedisTemplate stringRedisTemplate;
    private final UlLoginProperties loginProperties;

    public void sendCode(String email) {
        sendCodeInternal(
                email,
                UserRedisConstants.LOGIN_CODE_PREFIX,
                UserRedisConstants.LOGIN_SEND_PREFIX,
                "登录");
    }

    public void verifyAndConsume(String email, String code) {
        verifyAndConsumeInternal(email, code, UserRedisConstants.LOGIN_CODE_PREFIX);
    }

    public void sendResetCode(String email) {
        sendCodeInternal(
                email,
                UserRedisConstants.RESET_CODE_PREFIX,
                UserRedisConstants.RESET_SEND_PREFIX,
                "重置密码");
    }

    public void verifyAndConsumeResetCode(String email, String code) {
        verifyAndConsumeInternal(email, code, UserRedisConstants.RESET_CODE_PREFIX);
    }

    private void sendCodeInternal(String email, String codePrefix, String sendPrefix, String scene) {
        String normalizedEmail = normalizeEmail(email);
        String sendKey = sendPrefix + normalizedEmail;
        if (Boolean.TRUE.equals(stringRedisTemplate.hasKey(sendKey))) {
            throw new BizException(ErrorCode.LOGIN_CODE_SEND_TOO_FREQUENT);
        }

        String code = RandomUtil.randomNumbers(6);
        String codeKey = codePrefix + normalizedEmail;
        stringRedisTemplate.opsForValue().set(
                codeKey,
                code,
                Duration.ofSeconds(loginProperties.getCodeTtlSeconds()));
        stringRedisTemplate.opsForValue().set(
                sendKey,
                "1",
                Duration.ofSeconds(loginProperties.getSendIntervalSeconds()));
        dispatchCode(normalizedEmail, code, scene);
    }

    private void verifyAndConsumeInternal(String email, String code, String codePrefix) {
        String normalizedEmail = normalizeEmail(email);
        String codeKey = codePrefix + normalizedEmail;
        String cached = stringRedisTemplate.opsForValue().get(codeKey);
        if (cached == null || !cached.equals(code)) {
            throw new BizException(ErrorCode.LOGIN_CODE_INVALID);
        }
        stringRedisTemplate.delete(codeKey);
    }

    private void dispatchCode(String email, String code, String scene) {
        if (loginProperties.isDevLogCode()) {
            log.info("【开发模式】邮箱 {} {}验证码: {}（{} 秒内有效）",
                    email, scene, code, loginProperties.getCodeTtlSeconds());
            return;
        }
        log.warn("未开启 dev-log-code 且未配置邮件服务，验证码仅应通过 dev-log-code 调试");
        log.info("邮箱 {} {}验证码: {}", email, scene, code);
    }

    private String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
