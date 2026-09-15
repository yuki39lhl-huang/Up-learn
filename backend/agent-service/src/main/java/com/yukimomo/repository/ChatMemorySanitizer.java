package com.yukimomo.repository;

import dev.langchain4j.agent.tool.ToolExecutionRequest;
import dev.langchain4j.data.message.AiMessage;
import dev.langchain4j.data.message.ChatMessage;
import dev.langchain4j.data.message.ToolExecutionResultMessage;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 清理非法 tool 记忆。
 * <p>
 * 注意：{@link dev.langchain4j.memory.chat.MessageWindowChatMemory} 每次 add 都会
 * {@code getMessages → add → updateMessages}。因此：
 * <ul>
 *   <li>禁止在 update 时丢掉「末尾尚未跑完的 tool_calls」</li>
 *   <li>末尾不完整的 Ai(tool_calls) 必须保留，否则工具回包会对不上</li>
 * </ul>
 */
@Slf4j
final class ChatMemorySanitizer {

    private ChatMemorySanitizer() {
    }

    static List<ChatMessage> sanitize(List<ChatMessage> raw) {
        if (raw == null || raw.isEmpty()) {
            return List.of();
        }
        List<ChatMessage> out = new ArrayList<>(raw.size());
        int i = 0;
        while (i < raw.size()) {
            ChatMessage msg = raw.get(i);

            if (msg instanceof ToolExecutionResultMessage) {
                // 悬空 tool（前面没有匹配的 assistant tool_calls）
                i++;
                continue;
            }

            if (msg instanceof AiMessage ai && ai.hasToolExecutionRequests()) {
                Set<String> need = requestIds(ai);
                List<ToolExecutionResultMessage> tools = new ArrayList<>();
                int j = i + 1;
                while (j < raw.size() && raw.get(j) instanceof ToolExecutionResultMessage toolMsg) {
                    tools.add(toolMsg);
                    j++;
                }
                Set<String> got = new HashSet<>();
                for (ToolExecutionResultMessage t : tools) {
                    if (t.id() != null) {
                        got.add(t.id());
                    }
                }
                boolean complete = !need.isEmpty() && got.containsAll(need);
                boolean inProgress = j == raw.size(); // 仍在工具执行中 / 刚写入 Ai(tool_calls)
                if (complete) {
                    out.add(ai);
                    for (ToolExecutionResultMessage t : tools) {
                        if (t.id() != null && need.contains(t.id())) {
                            out.add(t);
                        }
                    }
                } else if (inProgress) {
                    // 关键：保留末尾未完成的 tool_calls，否则下一拍 add(toolResult) 会丢助手消息
                    out.add(ai);
                    out.addAll(tools);
                }
                // 否则：中间残留的半截 tool 对（后面还有用户话）→ 丢弃
                i = j;
                continue;
            }

            out.add(msg);
            i++;
        }

        if (out.size() != raw.size()) {
            log.info("Sanitized chat memory: {} -> {} messages", raw.size(), out.size());
        }
        return List.copyOf(out);
    }

    private static Set<String> requestIds(AiMessage ai) {
        Set<String> need = new HashSet<>();
        if (ai.toolExecutionRequests() == null) {
            return need;
        }
        for (ToolExecutionRequest req : ai.toolExecutionRequests()) {
            if (req != null && req.id() != null) {
                need.add(req.id());
            }
        }
        return need;
    }
}
