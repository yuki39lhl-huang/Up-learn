package com.yukimomo.practice.constant;

/**
 * 历年真题题型与作答模式常量。
 */
public final class PaperConstants {

    private PaperConstants() {
    }

    public static final String Q_CHOICE = "choice";
    public static final String Q_FILL = "fill";
    public static final String Q_CALC = "calc";
    public static final String Q_ESSAY = "essay";
    /** 阅读原文等材料，不作答 */
    public static final String Q_MATERIAL = "material";

    public static final String INPUT_ANSWERABLE = "answerable";
    public static final String INPUT_REVEAL_ONLY = "reveal_only";

    public static final String ATTEMPT_IN_PROGRESS = "in_progress";
    public static final String ATTEMPT_SUBMITTED = "submitted";
}
