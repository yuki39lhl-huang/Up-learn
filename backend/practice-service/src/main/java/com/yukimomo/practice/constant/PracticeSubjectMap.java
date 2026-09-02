package com.yukimomo.practice.constant;

import cn.hutool.json.JSONUtil;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 考试科目名 → 一期题库科目映射（与前端 examSubjects.ts 对齐）。
 */
public final class PracticeSubjectMap {

    private PracticeSubjectMap() {
    }

    public static final List<String> BANK_SUBJECTS = List.of(
            "政治", "大学英语", "高等数学", "计算机基础"
    );

    /** 考试科目名 → 一期题库 subject 列取值。 */
    private static final Map<String, String> EXAM_TO_BANK = new HashMap<>();

    static {
        EXAM_TO_BANK.put("政治", "政治");
        EXAM_TO_BANK.put("政治理论", "政治");
        EXAM_TO_BANK.put("大学英语", "大学英语");
        EXAM_TO_BANK.put("英语", "大学英语");
        EXAM_TO_BANK.put("高等数学", "高等数学");
        EXAM_TO_BANK.put("管理学", "高等数学");
        EXAM_TO_BANK.put("经济学", "高等数学");
        EXAM_TO_BANK.put("民法", "政治");
        EXAM_TO_BANK.put("教育理论", "政治");
        EXAM_TO_BANK.put("大学语文", "大学英语");
        EXAM_TO_BANK.put("艺术概论", "政治");
        EXAM_TO_BANK.put("生态学基础", "高等数学");
        EXAM_TO_BANK.put("生理学", "高等数学");
        EXAM_TO_BANK.put("计算机基础与程序设计", "计算机基础");
        EXAM_TO_BANK.put("计算机基础", "计算机基础");
        EXAM_TO_BANK.put("电子技术基础", "计算机基础");
        EXAM_TO_BANK.put("机械工程基础", "高等数学");
        EXAM_TO_BANK.put("基础会计学", "高等数学");
        EXAM_TO_BANK.put("金融学", "高等数学");
        EXAM_TO_BANK.put("学前教育基础", "政治");
        EXAM_TO_BANK.put("遗传学", "高等数学");
        EXAM_TO_BANK.put("法理学", "政治");
        EXAM_TO_BANK.put("汉语言文学学科基础", "大学英语");
        EXAM_TO_BANK.put("英语基础与写作", "大学英语");
        EXAM_TO_BANK.put("设计基础", "政治");
        EXAM_TO_BANK.put("电子商务概论", "高等数学");
        EXAM_TO_BANK.put("市场营销学", "高等数学");
        EXAM_TO_BANK.put("人力资源管理", "高等数学");
        EXAM_TO_BANK.put("行政管理学", "政治");
        EXAM_TO_BANK.put("国际贸易理论与实务", "高等数学");
        EXAM_TO_BANK.put("数学专业综合", "高等数学");
    }

    /**
     * 从备考科目 JSON 解析并映射为一期题库科目列表。
     */
    public static List<String> bankSubjectsFromSelectionJson(String subjectSelectionJson) {
        if (!JSONUtil.isTypeJSON(subjectSelectionJson)) {
            return Collections.emptyList();
        }
        var obj = JSONUtil.parseObj(subjectSelectionJson);
        List<String> examSubjects = new ArrayList<>();
        appendList(examSubjects, obj.getJSONArray("public"));
        // user-service Hutool 序列化字段名为 publicSubjects，与 API 的 public 并存
        appendList(examSubjects, obj.getJSONArray("publicSubjects"));
        appendList(examSubjects, obj.getJSONArray("foundation"));
        appendList(examSubjects, obj.getJSONArray("comprehensive"));
        return mapExamSubjectsToBank(examSubjects);
    }

    /** 将考试科目列表映射为去重后的题库科目。 */
    public static List<String> mapExamSubjectsToBank(List<String> examSubjects) {
        Set<String> mapped = new HashSet<>();
        for (String exam : examSubjects) {
            if (exam == null || exam.isBlank()) {
                continue;
            }
            String bank = EXAM_TO_BANK.get(exam.trim());
            if (bank != null && BANK_SUBJECTS.contains(bank)) {
                mapped.add(bank);
            }
        }
        return new ArrayList<>(mapped);
    }

    private static void appendList(List<String> target, cn.hutool.json.JSONArray array) {
        if (array == null || array.isEmpty()) {
            return;
        }
        for (Object item : array) {
            if (item instanceof String s && !s.isBlank()) {
                target.add(s);
            }
        }
    }
}
