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
     * 词典实体转 Combobox 选项（id / name / majorCategory）。
     */
    public static MajorOptionVO toMajorOptionVO(MajorDict dict) {
        if (dict == null) {
            return null;
        }
        MajorOptionVO vo = new MajorOptionVO();
        vo.setId(dict.getId());
        vo.setName(dict.getName());
        vo.setMajorCategory(dict.getMajorCategory());
        return vo;
    }

    /**
     * 开设 + 词典合并为 MajorVO。
     * {@code id} 取 school_major.id；名称/类别取自 dict。
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
            vo.setMajorCategory(dict.getMajorCategory());
        }
        vo.setExamSubjects(offering.getExamSubjects());
        vo.setAvgScore(offering.getAvgScore());
        vo.setEnrollment(offering.getEnrollment());
        vo.setTuition(offering.getTuition());
        vo.setMinScore(offering.getMinScore());
        vo.setYear(offering.getYear());
        return vo;
    }
}
