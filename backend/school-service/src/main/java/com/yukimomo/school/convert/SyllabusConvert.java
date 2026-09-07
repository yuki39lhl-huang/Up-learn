package com.yukimomo.school.convert;

import cn.hutool.json.JSONUtil;
import com.yukimomo.school.entity.Syllabus;
import com.yukimomo.school.vo.SyllabusDesignatedWorkVO;
import com.yukimomo.school.vo.SyllabusOptionItemVO;
import com.yukimomo.school.vo.SyllabusReferenceVO;
import com.yukimomo.school.vo.SyllabusScopeVO;
import com.yukimomo.school.vo.SyllabusVO;
import org.springframework.util.StringUtils;

import java.util.Collections;
import java.util.List;

/**
 * 考纲 Entity → VO（JSON 列解析）。
 */
public final class SyllabusConvert {

    private SyllabusConvert() {
    }

    public static SyllabusOptionItemVO toOptionItem(Syllabus entity) {
        SyllabusOptionItemVO vo = new SyllabusOptionItemVO();
        vo.setProvince(entity.getProvince());
        vo.setYear(entity.getYear());
        vo.setSubject(entity.getSubject());
        return vo;
    }

    public static SyllabusVO toDetail(Syllabus entity) {
        SyllabusVO vo = new SyllabusVO();
        vo.setId(entity.getId());
        vo.setProvince(entity.getProvince());
        vo.setYear(entity.getYear());
        vo.setSubject(entity.getSubject());
        vo.setSourceTitle(entity.getSourceTitle());
        vo.setScope(parseScope(entity.getScopeJson()));
        vo.setReferences(parseList(entity.getReferencesJson(), SyllabusReferenceVO.class));
        vo.setDesignatedWorks(parseList(entity.getDesignatedWorksJson(), SyllabusDesignatedWorkVO.class));
        return vo;
    }

    private static SyllabusScopeVO parseScope(String json) {
        if (!StringUtils.hasText(json)) {
            return new SyllabusScopeVO();
        }
        return JSONUtil.toBean(json, SyllabusScopeVO.class);
    }

    private static <T> List<T> parseList(String json, Class<T> type) {
        if (!StringUtils.hasText(json)) {
            return Collections.emptyList();
        }
        return JSONUtil.toList(json, type);
    }
}
