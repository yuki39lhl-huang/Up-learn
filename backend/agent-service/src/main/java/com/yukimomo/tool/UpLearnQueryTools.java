package com.yukimomo.tool;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.yukimomo.api.client.PracticeFeignClient;
import com.yukimomo.api.client.SchoolFeignClient;
import com.yukimomo.api.practice.vo.PaperListItemVO;
import com.yukimomo.api.school.vo.SchoolMajorVO;
import com.yukimomo.api.school.vo.SchoolVO;
import com.yukimomo.api.school.vo.SyllabusDesignatedWorkVO;
import com.yukimomo.api.school.vo.SyllabusOptionItemVO;
import com.yukimomo.api.school.vo.SyllabusOptionsVO;
import com.yukimomo.api.school.vo.SyllabusReferenceVO;
import com.yukimomo.api.school.vo.SyllabusScopeBlockVO;
import com.yukimomo.api.school.vo.SyllabusVO;
import com.yukimomo.common.domain.PageDTO;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.ErrorCode;
import dev.langchain4j.agent.tool.P;
import dev.langchain4j.agent.tool.Tool;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 一点通查库 Tool：院校 / 考纲 / 真题列表（经 Feign，返回摘要 JSON）。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class UpLearnQueryTools {

    private static final int DEFAULT_PAGE_SIZE = 16;
    private static final int MAX_MAJORS_RETURNED = 40;
    private static final int MAX_SYLLABUS_CHARS = 3500;
    private static final int MAX_SCOPE_ITEMS = 40;

    private final SchoolFeignClient schoolFeignClient;
    private final PracticeFeignClient practiceFeignClient;

    @Tool("""
            按省份/办学类型/专业类查询专升本院校列表（与控制台「院校」筛选同一套接口）。
            问「招计算机类的公办院校」时：province=档案省，type=公办，preferPublic=true，majorCategory=计算机类。
            keyword 只匹配校名，不要把专业名塞进 keyword。
            禁止传档案届别当 year（届别≠招生目录年，传了常 0 条）；year 可空。
            需要某校具体专业明细时，再用 getSchoolMajors。
            """)
    public String searchSchools(
            @P("省份，如广东、山东；默认档案省") String province,
            @P(value = "校名关键词，可空；勿填专业名", required = false) String keyword,
            @P(value = "办学类型：公办/民办，可空", required = false) String type,
            @P(value = "true=公办优先；查公办请传 true", required = false) Boolean preferPublic,
            @P(value = "专业类，如计算机类、电子信息类；用户说「计算机」请归一成「计算机类」", required = false)
                    String majorCategory,
            @P(value = "专业词典 ID，精确筛某专业时用；可空", required = false) Long majorDictId) {
        try {
            String typeVal = blankToNull(type);
            Boolean prefer = preferPublic;
            if (prefer == null && typeVal != null && typeVal.contains("公办")) {
                prefer = true;
            }
            String category = normalizeMajorCategory(majorCategory);
            // 不传 year：届别年份会落到 school_major.year，常导致 0 条
            Result<PageDTO<SchoolVO>> result = schoolFeignClient.listSchools(
                    blankToNull(keyword),
                    blankToNull(province),
                    typeVal,
                    null,
                    majorDictId,
                    null,
                    category,
                    prefer,
                    1,
                    DEFAULT_PAGE_SIZE);
            if (!isOk(result) || result.getData() == null) {
                return err("院校查询失败", result);
            }
            PageDTO<SchoolVO> page = result.getData();
            List<Map<String, Object>> items = new ArrayList<>();
            if (page.getList() != null) {
                for (SchoolVO s : page.getList()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("id", s.getId());
                    row.put("name", s.getName());
                    row.put("province", s.getProvince());
                    row.put("city", s.getCity());
                    row.put("type", s.getType());
                    row.put("majorCount", s.getMajorCount());
                    items.add(row);
                }
            }
            Map<String, Object> out = new LinkedHashMap<>();
            out.put("total", page.getTotal());
            out.put("returned", items.size());
            out.put("filters", Map.of(
                    "province", blankToNull(province) == null ? "" : province.trim(),
                    "type", typeVal == null ? "" : typeVal,
                    "majorCategory", category == null ? "" : category,
                    "majorDictId", majorDictId == null ? "" : majorDictId));
            out.put("schools", items);
            out.put("hint", items.isEmpty()
                    ? "无命中；可放宽 type/majorCategory，或换档案省"
                    : "已按筛选返回院校；要某校招生专业明细请调用 getSchoolMajors(schoolId)");
            return JSONUtil.toJsonStr(out);
        } catch (Exception e) {
            log.warn("searchSchools failed: {}", e.getMessage());
            return "{\"error\":\"院校查询异常: " + escape(e.getMessage()) + "\"}";
        }
    }

    @Tool("""
            查询某校开设的招生专业明细（专业名、专业类、考试科目、前置要求、学费等）。
            用户问「某校招哪些计算机类专业 / 限招条件」时调用。
            schoolId 来自 searchSchools 返回的 id；majorCategory 可筛同类（如计算机类）。
            """)
    public String getSchoolMajors(
            @P("院校 id，来自 searchSchools") Long schoolId,
            @P(value = "专业类过滤，如计算机类；可空表示该校全部专业", required = false) String majorCategory) {
        if (schoolId == null) {
            return "{\"error\":\"schoolId 必填；请先 searchSchools 取得院校 id\"}";
        }
        try {
            String category = normalizeMajorCategory(majorCategory);
            Result<List<SchoolMajorVO>> result = schoolFeignClient.listMajors(schoolId, null, category);
            if (!isOk(result)) {
                return err("院校专业查询失败", result);
            }
            List<SchoolMajorVO> all = result.getData() == null ? List.of() : result.getData();
            // Feign 侧 majorCategory 主要用于相关度排序，不完全过滤；此处再精确过滤一次
            List<SchoolMajorVO> filtered = all;
            if (category != null) {
                filtered = all.stream()
                        .filter(m -> category.equals(StrUtil.trim(m.getMajorCategory())))
                        .toList();
                if (filtered.isEmpty()) {
                    // 宽松：名称或展示名含「计算机」等
                    String token = category.replace("类", "");
                    filtered = all.stream()
                            .filter(m -> containsIgnoreNull(m.getName(), token)
                                    || containsIgnoreNull(m.getDisplayName(), token)
                                    || containsIgnoreNull(m.getMajorCategory(), token))
                            .toList();
                }
            }
            boolean truncated = filtered.size() > MAX_MAJORS_RETURNED;
            List<SchoolMajorVO> slice = truncated
                    ? filtered.subList(0, MAX_MAJORS_RETURNED)
                    : filtered;
            List<Map<String, Object>> items = new ArrayList<>();
            for (SchoolMajorVO m : slice) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("displayName", StrUtil.blankToDefault(m.getDisplayName(), m.getName()));
                row.put("name", m.getName());
                row.put("majorCategory", m.getMajorCategory());
                row.put("majorGroup", m.getMajorGroup());
                row.put("majorCode", m.getMajorCode());
                row.put("batchName", m.getBatchName());
                row.put("examType", m.getExamType());
                row.put("publicSubjects", m.getPublicSubjects());
                row.put("foundationSubject", m.getFoundationSubject());
                row.put("comprehensiveSubject", m.getComprehensiveSubject());
                row.put("prerequisite", m.getPrerequisite());
                row.put("tuition", m.getTuition());
                row.put("campus", m.getCampus());
                row.put("year", m.getYear());
                items.add(row);
            }
            Map<String, Object> out = new LinkedHashMap<>();
            out.put("schoolId", schoolId);
            out.put("majorCategory", category == null ? "" : category);
            out.put("totalMatched", filtered.size());
            out.put("returned", items.size());
            out.put("truncated", truncated);
            out.put("majors", items);
            return JSONUtil.toJsonStr(out);
        } catch (Exception e) {
            log.warn("getSchoolMajors failed: {}", e.getMessage());
            return "{\"error\":\"院校专业查询异常: " + escape(e.getMessage()) + "\"}";
        }
    }

    @Tool("""
            查询某省某科专升本考纲要点。默认档案省份与科目。
            year 可用档案届别，但库内常按招考季年（如广东 2026）；无精确命中时工具会自动回退到该省该科最新入库年。
            科目名会做别名映射（如大学英语→英语、政治→政治理论）。不要编造未返回章节。
            """)
    public String getSyllabus(
            @P("省份，如广东") String province,
            @P(value = "期望年份；可空，空则直接取该省该科最新入库年", required = false) Integer year,
            @P("科目，可用档案名如大学英语、高等数学") String subject) {
        if (StrUtil.isBlank(province) || StrUtil.isBlank(subject)) {
            return "{\"error\":\"province 与 subject 必填；请从备考档案读取默认值\"}";
        }
        try {
            ResolvedKey key = resolveSyllabusKey(province.trim(), year, subject.trim());
            if (key == null) {
                return "{\"error\":\"无匹配考纲\",\"province\":\"" + escape(province)
                        + "\",\"subject\":\"" + escape(subject)
                        + "\",\"hint\":\"可先到控制台「考纲」看已入库省/年/科\"}";
            }
            Result<SyllabusVO> result = schoolFeignClient.getSyllabus(
                    key.province(), key.year(), key.subject());
            if (!isOk(result)) {
                return err("考纲查询失败", result);
            }
            if (result.getData() == null) {
                return "{\"error\":\"无该省/年/科考纲数据\",\"resolved\":"
                        + JSONUtil.toJsonStr(key.toMap()) + "}";
            }
            Map<String, Object> summary = summarizeSyllabus(result.getData());
            if (key.remapped()) {
                summary.put("resolvedFrom", key.toMap());
            }
            return JSONUtil.toJsonStr(summary);
        } catch (Exception e) {
            log.warn("getSyllabus failed: {}", e.getMessage());
            return "{\"error\":\"考纲查询异常: " + escape(e.getMessage()) + "\"}";
        }
    }

    @Tool("列出某省某科历年真题试卷（标题/年份/题量等），不含题目正文。默认档案省份与科目；科目会做别名映射（大学英语→英语）。禁止用本工具拉整卷。")
    public String listPapers(
            @P("省份，如广东") String province,
            @P("科目名，可用档案名") String subject) {
        if (StrUtil.isBlank(province) || StrUtil.isBlank(subject)) {
            return "{\"error\":\"province 与 subject 必填；请从备考档案读取默认值\"}";
        }
        try {
            String prov = province.trim();
            String subj = SubjectAlias.normalize(prov, subject.trim());
            Result<List<PaperListItemVO>> result = practiceFeignClient.listPapers(prov, subj);
            if (!isOk(result)) {
                // 别名未命中时再试原始名
                if (!subj.equals(subject.trim())) {
                    result = practiceFeignClient.listPapers(prov, subject.trim());
                }
            }
            if (!isOk(result)) {
                return err("真题列表查询失败", result);
            }
            List<PaperListItemVO> list = result.getData() == null ? List.of() : result.getData();
            if (list.isEmpty() && !subj.equals(subject.trim())) {
                Result<List<PaperListItemVO>> retry = practiceFeignClient.listPapers(prov, subject.trim());
                if (isOk(retry) && retry.getData() != null) {
                    list = retry.getData();
                    subj = subject.trim();
                }
            }
            List<Map<String, Object>> items = new ArrayList<>();
            for (PaperListItemVO p : list) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("id", p.getId());
                row.put("year", p.getYear());
                row.put("title", p.getTitle());
                row.put("questionCount", p.getQuestionCount());
                row.put("hasAnswer", p.getHasAnswer());
                row.put("pdfAvailable", p.getPdfAvailable());
                items.add(row);
            }
            Map<String, Object> out = new LinkedHashMap<>();
            out.put("province", prov);
            out.put("subject", subj);
            out.put("count", items.size());
            out.put("papers", items);
            out.put("hint", "仅列表；作答请到控制台「历年真题」");
            return JSONUtil.toJsonStr(out);
        } catch (Exception e) {
            log.warn("listPapers failed: {}", e.getMessage());
            return "{\"error\":\"真题列表异常: " + escape(e.getMessage()) + "\"}";
        }
    }

    private ResolvedKey resolveSyllabusKey(String province, Integer year, String subject) {
        List<String> candidates = subjectCandidates(province, subject);
        if (year != null) {
            for (String cand : candidates) {
                SyllabusVO hit = fetchSyllabusOrNull(province, year, cand);
                if (hit != null) {
                    return new ResolvedKey(province, year, cand, !cand.equals(subject));
                }
            }
        }
        SyllabusOptionItemVO best = findBestOption(province, candidates);
        if (best == null) {
            return null;
        }
        boolean remapped = year == null
                || !year.equals(best.getYear())
                || !subject.equals(best.getSubject());
        return new ResolvedKey(best.getProvince(), best.getYear(), best.getSubject(), remapped);
    }

    private SyllabusOptionItemVO findBestOption(String province, List<String> candidates) {
        Result<SyllabusOptionsVO> optResult = schoolFeignClient.listSyllabusOptions();
        if (!isOk(optResult) || optResult.getData() == null || optResult.getData().getItems() == null) {
            return null;
        }
        List<SyllabusOptionItemVO> items = optResult.getData().getItems().stream()
                .filter(i -> i != null && province.equals(i.getProvince()) && i.getYear() != null
                        && StrUtil.isNotBlank(i.getSubject()))
                .toList();
        for (String cand : candidates) {
            SyllabusOptionItemVO exact = items.stream()
                    .filter(i -> cand.equals(i.getSubject()))
                    .max(Comparator.comparing(SyllabusOptionItemVO::getYear))
                    .orElse(null);
            if (exact != null) {
                return exact;
            }
        }
        // 模糊：科目互相包含
        for (String cand : candidates) {
            SyllabusOptionItemVO fuzzy = items.stream()
                    .filter(i -> i.getSubject().contains(cand) || cand.contains(i.getSubject()))
                    .max(Comparator.comparing(SyllabusOptionItemVO::getYear))
                    .orElse(null);
            if (fuzzy != null) {
                return fuzzy;
            }
        }
        return null;
    }

    private SyllabusVO fetchSyllabusOrNull(String province, Integer year, String subject) {
        try {
            Result<SyllabusVO> result = schoolFeignClient.getSyllabus(province, year, subject);
            if (isOk(result) && result.getData() != null) {
                return result.getData();
            }
        } catch (Exception e) {
            log.debug("syllabus miss {}/{}/{}: {}", province, year, subject, e.getMessage());
        }
        return null;
    }

    private static List<String> subjectCandidates(String province, String subject) {
        Set<String> set = new LinkedHashSet<>();
        String raw = subject.trim();
        set.add(raw);
        set.add(SubjectAlias.normalize(province, raw));
        if (raw.contains("英语")) {
            set.add("英语");
            set.add("大学英语");
        }
        if (raw.contains("政治")) {
            set.add("政治理论");
            set.add("政治");
        }
        if (raw.contains("计算机")) {
            set.add("计算机基础与程序设计");
            set.add("计算机");
        }
        if (raw.contains("高数") || raw.contains("高等数学")) {
            set.add("高等数学");
        }
        return new ArrayList<>(set);
    }

    private static Map<String, Object> summarizeSyllabus(SyllabusVO vo) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("province", vo.getProvince());
        out.put("year", vo.getYear());
        out.put("subject", vo.getSubject());
        out.put("sourceTitle", vo.getSourceTitle());

        List<String> outline = new ArrayList<>();
        int[] itemBudget = {MAX_SCOPE_ITEMS};
        if (vo.getScope() != null && vo.getScope().getBlocks() != null) {
            for (SyllabusScopeBlockVO block : vo.getScope().getBlocks()) {
                flattenScope(block, outline, 0, itemBudget);
            }
        }
        out.put("scopeOutline", outline);

        List<String> refs = new ArrayList<>();
        if (vo.getReferences() != null) {
            for (SyllabusReferenceVO r : vo.getReferences()) {
                if (r == null || StrUtil.isBlank(r.getTitle())) {
                    continue;
                }
                StringBuilder sb = new StringBuilder(r.getTitle().trim());
                if (StrUtil.isNotBlank(r.getEditors())) {
                    sb.append(" / ").append(r.getEditors().trim());
                }
                if (StrUtil.isNotBlank(r.getEdition())) {
                    sb.append(" / ").append(r.getEdition().trim());
                }
                refs.add(sb.toString());
            }
        }
        out.put("references", refs);

        List<String> works = new ArrayList<>();
        if (vo.getDesignatedWorks() != null) {
            for (SyllabusDesignatedWorkVO w : vo.getDesignatedWorks()) {
                if (w == null || StrUtil.isBlank(w.getTitle())) {
                    continue;
                }
                String line = w.getTitle().trim();
                if (StrUtil.isNotBlank(w.getAuthorOrSource())) {
                    line = line + "（" + w.getAuthorOrSource().trim() + "）";
                }
                works.add(line);
            }
        }
        out.put("designatedWorks", works);

        String json = JSONUtil.toJsonStr(out);
        if (json.length() > MAX_SYLLABUS_CHARS) {
            out.put("scopeOutline", outline.subList(0, Math.min(outline.size(), 20)));
            out.put("truncated", true);
            out.put("hint", "考纲过长已截断；完整内容请到控制台「考纲」查看");
        }
        return out;
    }

    private static void flattenScope(
            SyllabusScopeBlockVO block, List<String> out, int depth, int[] itemBudget) {
        if (block == null || itemBudget[0] <= 0) {
            return;
        }
        String indent = "  ".repeat(Math.min(depth, 4));
        if (StrUtil.isNotBlank(block.getHeading())) {
            out.add(indent + block.getHeading().trim());
            itemBudget[0]--;
        }
        if (block.getParagraphs() != null) {
            for (String p : block.getParagraphs()) {
                if (itemBudget[0] <= 0) {
                    return;
                }
                if (StrUtil.isNotBlank(p)) {
                    String t = p.trim();
                    out.add(indent + (t.length() > 120 ? t.substring(0, 120) + "…" : t));
                    itemBudget[0]--;
                }
            }
        }
        if (block.getItems() != null) {
            for (String item : block.getItems()) {
                if (itemBudget[0] <= 0) {
                    return;
                }
                if (StrUtil.isNotBlank(item)) {
                    String t = item.trim();
                    out.add(indent + "- " + (t.length() > 100 ? t.substring(0, 100) + "…" : t));
                    itemBudget[0]--;
                }
            }
        }
        if (block.getChildren() != null) {
            for (SyllabusScopeBlockVO child : block.getChildren()) {
                flattenScope(child, out, depth + 1, itemBudget);
            }
        }
    }

    private static boolean isOk(Result<?> result) {
        return result != null && result.getCode() == ErrorCode.SUCCESS.getCode();
    }

    private static String err(String prefix, Result<?> result) {
        String msg = result == null ? "无响应" : result.getMsg();
        return "{\"error\":\"" + escape(prefix + ": " + msg) + "\"}";
    }

    private static String blankToNull(String s) {
        return StrUtil.isBlank(s) ? null : s.trim();
    }

    /** 口语专业类 → 库内 major_category（如 计算机 → 计算机类） */
    private static String normalizeMajorCategory(String raw) {
        if (StrUtil.isBlank(raw)) {
            return null;
        }
        String s = raw.trim();
        if ("计算机".equals(s) || "计算机专业".equals(s) || "计算机相关".equals(s)) {
            return "计算机类";
        }
        if (s.endsWith("专业") && !s.endsWith("类")) {
            String base = s.substring(0, s.length() - 2);
            if (!base.endsWith("类")) {
                return base + "类";
            }
        }
        return s;
    }

    private static boolean containsIgnoreNull(String text, String token) {
        return StrUtil.isNotBlank(text) && StrUtil.isNotBlank(token) && text.contains(token);
    }

    private static String escape(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private record ResolvedKey(String province, Integer year, String subject, boolean remapped) {
        Map<String, Object> toMap() {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("province", province);
            m.put("year", year);
            m.put("subject", subject);
            m.put("remapped", remapped);
            return m;
        }
    }
}
