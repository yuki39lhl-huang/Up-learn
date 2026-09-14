package com.yukimomo.service;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.yukimomo.api.agent.dto.ScoreRequestDTO;
import com.yukimomo.api.agent.vo.ScoreResultVO;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import dev.langchain4j.model.openai.OpenAiChatModel;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 主观题单次 LLM 评分：不走会话记忆、RAG、Tool。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ScoreService {

    private static final Pattern FENCE = Pattern.compile("(?s)```(?:json)?\\s*(.*?)\\s*```");

    private final OpenAiChatModel openAiChatModel;

    public ScoreResultVO score(ScoreRequestDTO dto) {
        String prompt = buildPrompt(dto);
        String raw;
        try {
            raw = openAiChatModel.chat(prompt);
        } catch (Exception e) {
            log.warn("LLM score call failed: {}", e.getMessage());
            throw new BizException(ErrorCode.AGENT_SCORE_FAILED);
        }
        if (StrUtil.isBlank(raw)) {
            throw new BizException(ErrorCode.AGENT_SCORE_FAILED, "模型未返回内容");
        }
        return parse(raw, dto.getMaxScore());
    }

    private static String buildPrompt(ScoreRequestDTO dto) {
        StringBuilder sb = new StringBuilder();
        sb.append("你是专升本主观题阅卷助手。请依据采分点/参考答案给考生作答打分。\n");
        sb.append("要求：\n");
        sb.append("1. 允许表述不同，采分点命中即可给分；不要因措辞差异一律零分。\n");
        sb.append("2. 分数必须在 0 到满分之间（可保留 1 位小数）。\n");
        sb.append("3. 只输出 JSON，不要其它说明。格式：");
        sb.append("{\"score\":数字,\"feedback\":\"简要评语（说明得失分点）\"}\n\n");
        if (StrUtil.isNotBlank(dto.getSubject())) {
            sb.append("科目：").append(dto.getSubject().trim()).append('\n');
        }
        if (StrUtil.isNotBlank(dto.getQType())) {
            sb.append("题型：").append(dto.getQType().trim()).append('\n');
        }
        sb.append("满分：").append(dto.getMaxScore()).append('\n');
        sb.append("题干：\n").append(dto.getStem().trim()).append("\n\n");
        if (StrUtil.isNotBlank(dto.getRubric())) {
            sb.append("采分点/解析：\n").append(dto.getRubric().trim()).append("\n\n");
        }
        if (StrUtil.isNotBlank(dto.getStandardAnswer())) {
            sb.append("参考答案：\n").append(dto.getStandardAnswer().trim()).append("\n\n");
        }
        if (StrUtil.isBlank(dto.getRubric()) && StrUtil.isBlank(dto.getStandardAnswer())) {
            sb.append("（本题暂无标准答案/采分点，请按题干合理估算，并在 feedback 中说明依据不足。）\n\n");
        }
        sb.append("考生作答：\n").append(dto.getUserAnswer().trim()).append('\n');
        return sb.toString();
    }

    private ScoreResultVO parse(String raw, Integer maxScore) {
        String json = extractJson(raw);
        try {
            JSONObject obj = JSONUtil.parseObj(json);
            BigDecimal score = obj.getBigDecimal("score");
            if (score == null) {
                throw new BizException(ErrorCode.AGENT_SCORE_FAILED, "评分结果缺少 score");
            }
            BigDecimal max = BigDecimal.valueOf(maxScore);
            if (score.compareTo(BigDecimal.ZERO) < 0) {
                score = BigDecimal.ZERO;
            }
            if (score.compareTo(max) > 0) {
                score = max;
            }
            score = score.setScale(1, RoundingMode.HALF_UP);

            ScoreResultVO vo = new ScoreResultVO();
            vo.setScore(score);
            vo.setMaxScore(maxScore);
            String feedback = obj.getStr("feedback");
            vo.setFeedback(StrUtil.blankToDefault(feedback, "（无评语）"));
            return vo;
        } catch (BizException e) {
            throw e;
        } catch (Exception e) {
            log.warn("Parse score JSON failed, raw={}", StrUtil.maxLength(raw, 400));
            throw new BizException(ErrorCode.AGENT_SCORE_FAILED, "评分结果解析失败");
        }
    }

    private static String extractJson(String raw) {
        String text = StrUtil.trim(raw);
        Matcher m = FENCE.matcher(text);
        if (m.find()) {
            return m.group(1).trim();
        }
        int start = text.indexOf('{');
        int end = text.lastIndexOf('}');
        if (start >= 0 && end > start) {
            return text.substring(start, end + 1);
        }
        return text;
    }
}
