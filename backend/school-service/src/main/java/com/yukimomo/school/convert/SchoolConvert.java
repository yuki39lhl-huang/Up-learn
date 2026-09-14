package com.yukimomo.school.convert;

import com.yukimomo.school.entity.MajorDict;
import com.yukimomo.school.entity.School;
import com.yukimomo.school.entity.SchoolMajor;
import com.yukimomo.school.vo.MajorOptionVO;
import com.yukimomo.school.vo.MajorVO;
import com.yukimomo.school.vo.SchoolVO;

/**
 * Entity → VO 转换工具（纯静态方法，不注册为 Spring Bean）。
 */
public final class SchoolConvert {

    /** 工具类禁止实例化。 */
    private SchoolConvert() {
    }

    /**
     * 院校实体转 VO；{@code preferPublic} 由库中的 0/1 转为 Boolean。
     */
    public static SchoolVO toSchoolVO(School school) {
        if (school == null) {
            return null;
        }
        SchoolVO vo = new SchoolVO();
        vo.setId(school.getId());
        vo.setName(school.getName());
        vo.setProvince(school.getProvince());
        vo.setCity(school.getCity());
        vo.setType(school.getType());
        vo.setTypeTag(school.getTypeTag());
        vo.setPreferPublic(school.getPreferPublic() != null && school.getPreferPublic() == 1);
        vo.setMajorCount(school.getMajorCount());
        vo.setEnrollment(school.getEnrollment());
        vo.setTuition(school.getTuition());
        vo.setMinScore(school.getMinScore());
        return vo;
    }

    /**
     * 词典实体转 Combobox 选项（id / name / discipline / majorCategory）。
     */
    public static MajorOptionVO toMajorOptionVO(MajorDict dict) {
        if (dict == null) {
            return null;
        }
        MajorOptionVO vo = new MajorOptionVO();
        vo.setId(dict.getId());
        vo.setName(dict.getName());
        vo.setDiscipline(dict.getDiscipline());
        vo.setMajorCategory(dict.getMajorCategory());
        vo.setExamTrack(dict.getExamTrack());
        return vo;
    }

    /**
     * 开设 + 词典合并为 MajorVO。
     * {@code id} 取 school_major.id；名称/类别取自 dict；展示名优先用开设 display_name。
     */
    public static MajorVO toMajorVO(SchoolMajor offering, MajorDict dict) {
        if (offering == null) {
            return null;
        }
        MajorVO vo = new MajorVO();
        vo.setId(offering.getId());
        vo.setSchoolId(offering.getSchoolId());
        vo.setMajorDictId(offering.getMajorDictId());
        if (dict != null) {
            vo.setName(dict.getName());
            vo.setDiscipline(dict.getDiscipline());
            vo.setMajorCategory(dict.getMajorCategory());
        }
        String display = offering.getDisplayName();
        vo.setDisplayName(display != null && !display.isBlank() ? display : vo.getName());
        vo.setMajorGroup(offering.getMajorGroup());
        vo.setMajorCode(offering.getMajorCode());
        vo.setBatchName(offering.getBatchName());
        vo.setCampus(offering.getCampus());
        vo.setExamType(offering.getExamType());
        vo.setFoundationSubject(offering.getFoundationSubject());
        vo.setComprehensiveSubject(offering.getComprehensiveSubject());
        vo.setPrerequisite(offering.getPrerequisite());
        vo.setPublicSubjects(resolvePublicSubjects(offering));
        vo.setExamSubjects(offering.getExamSubjects());
        vo.setAvgScore(offering.getAvgScore());
        vo.setEnrollment(offering.getEnrollment());
        vo.setTuition(offering.getTuition());
        vo.setMinScore(offering.getMinScore());
        vo.setYear(offering.getYear());
        return vo;
    }

    /**
     * 公共课：优先从 exam_subjects 按「公共，基础，综课」三段拆出首段；
     * 无法拆分时返回 null（前端可回退 examSubjects）。
     */
    private static String resolvePublicSubjects(SchoolMajor offering) {
        String exam = offering.getExamSubjects();
        if (exam == null || exam.isBlank()) {
            return null;
        }
        String[] parts = exam.split("，");
        if (parts.length >= 3) {
            return parts[0].trim();
        }
        if (parts.length == 1) {
            return parts[0].trim();
        }
        // 两段时：若第二段等于基础或综课，首段视为公共课
        String second = parts[1].trim();
        if (second.equals(nullToEmpty(offering.getFoundationSubject()))
                || second.equals(nullToEmpty(offering.getComprehensiveSubject()))) {
            return parts[0].trim();
        }
        return parts[0].trim();
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s;
    }
}
