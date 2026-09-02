package com.yukimomo.practice.constant;

/**
 * 用户题目调度状态（表 {@code user_question_record.status}）。
 */
public final class QuestionRecordStatus {

    private QuestionRecordStatus() {
    }

    /** 未做过或尚未纳入复习调度。 */
    public static final String NEW = "NEW";
    /** 做错：优先进入刷题池，无视 nextReviewTime。 */
    public static final String WRONG = "WRONG";
    /** 做对：按 nextReviewTime 间隔后再进入复习池。 */
    public static final String RIGHT = "RIGHT";
}
