package com.yukimomo.tool;

import cn.hutool.core.util.StrUtil;

/**
 * 档案/口语科目名 → 库内常用名（考纲、真题、知识库共用）。
 */
public final class SubjectAlias {

    private SubjectAlias() {
    }

    public static String normalize(String subject) {
        return normalize(null, subject);
    }

    public static String normalize(String province, String subject) {
        if (StrUtil.isBlank(subject)) {
            return subject;
        }
        String s = subject.trim();
        if ("大学英语".equals(s) || "公共英语".equals(s)) {
            return "英语";
        }
        if ("高数".equals(s) || "微积分".equals(s)) {
            return "高等数学";
        }
        if ("政治".equals(s)) {
            // 广东库多为「政治理论」；知识库检索默认也归一到政治理论
            if (StrUtil.isBlank(province) || "广东".equals(province)) {
                return "政治理论";
            }
            return s;
        }
        if ("计算机基础".equals(s) || "计算机基础与编程".equals(s)) {
            return "广东".equals(province) ? "计算机基础与程序设计" : "计算机";
        }
        if ("计算机".equals(s) && StrUtil.isBlank(province)) {
            return "计算机基础与程序设计";
        }
        return s;
    }
}
