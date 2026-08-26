package com.yukimomo.practice.constant;

/**
 * practice-service 使用的 Redis Key 约定（统一前缀，避免与 user-service 等撞 Key）。
 * <p>
 * 工具类风格：私有构造，禁止实例化；只暴露常量。
 */
public final class PracticeRedisConstants {

    private PracticeRedisConstants() {
        // 禁止 new
    }

    /**
     * 每日一练缓存前缀。
     * 完整 Key：{@code ul:practice:daily:{userId}:{yyyyMMdd}}，Value 为 questionId 字符串。
     * TTL 设到当天结束（次日 0 点），保证同一用户当天拿到同一题。
     */
    public static final String DAILY_QUESTION_PREFIX = "ul:practice:daily:";
}
