<script setup lang="ts">
import { nextTick, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import StitchIcon from './StitchIcon.vue'
import { chatStream, getAgentSessionId, resetAgentSession } from '../../api/agent'

interface ChatMessage {
  role: 'user' | 'assistant'
  content: string
  loading?: boolean
}

const SESSION_KEY = 'ul_agent_session'

const messages = ref<ChatMessage[]>([])
const input = ref('')
const sending = ref(false)
const sessionId = ref(getAgentSessionId())
const listRef = ref<HTMLElement | null>(null)
let abortController: AbortController | null = null

const welcome =
  '你好，我是「一点通」AI 助手。我可以根据知识库检索，为你解答专升本招考、院校与专业等相关问题。'

function scrollToBottom() {
  nextTick(() => {
    listRef.value?.scrollTo({ top: listRef.value.scrollHeight, behavior: 'smooth' })
  })
}

function startNewChat() {
  if (abortController) {
    abortController.abort()
    abortController = null
  }
  sending.value = false
  sessionId.value = resetAgentSession()
  messages.value = [{ role: 'assistant', content: welcome }]
  scrollToBottom()
}

async function sendMessage() {
  const text = input.value.trim()
  if (!text || sending.value) return

  messages.value.push({ role: 'user', content: text })
  const assistantIndex = messages.value.length
  messages.value.push({ role: 'assistant', content: '', loading: true })
  input.value = ''
  scrollToBottom()

  sending.value = true
  abortController = new AbortController()

  try {
    await chatStream(
      text,
      sessionId.value,
      (accumulated) => {
        messages.value[assistantIndex] = { role: 'assistant', content: accumulated }
        scrollToBottom()
      },
      abortController.signal
    )
    const last = messages.value[assistantIndex]
    if (!last.content) {
      last.content = '抱歉，未能生成有效回答，请稍后再试。'
    }
    last.loading = false
  } catch (e) {
    if (e instanceof Error && e.name === 'AbortError') return
    const last = messages.value[assistantIndex]
    last.loading = false
    last.content = e instanceof Error ? e.message : '请求失败'
    ElMessage.error(last.content)
  } finally {
    sending.value = false
    abortController = null
    localStorage.setItem(SESSION_KEY, sessionId.value)
    scrollToBottom()
  }
}

function stopGenerating() {
  abortController?.abort()
  sending.value = false
  const last = messages.value[messages.value.length - 1]
  if (last?.loading) last.loading = false
}

function onKeydown(e: KeyboardEvent) {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault()
    sendMessage()
  }
}

onMounted(() => {
  messages.value = [{ role: 'assistant', content: welcome }]
})
</script>

<template>
  <div class="agent-chat">
    <header class="agent-chat__toolbar">
      <div class="agent-chat__brand">
        <StitchIcon name="agent" />
        <span>基于 RAG 知识库检索 · 会话记忆已启用</span>
      </div>
      <el-button size="small" plain @click="startNewChat">新对话</el-button>
    </header>

    <div ref="listRef" class="agent-chat__list">
      <div
        v-for="(msg, i) in messages"
        :key="i"
        class="agent-chat__row"
        :class="`agent-chat__row--${msg.role}`"
      >
        <div class="agent-chat__bubble">
          <p v-if="msg.loading && !msg.content" class="agent-chat__typing">
            <span /><span /><span />
          </p>
          <p v-else class="agent-chat__text" v-html="msg.content.replace(/\n/g, '<br>')" />
        </div>
      </div>
    </div>

    <footer class="agent-chat__composer">
      <textarea
        v-model="input"
        class="agent-chat__input"
        rows="2"
        placeholder="输入你的问题，Enter 发送，Shift+Enter 换行"
        :disabled="sending"
        @keydown="onKeydown"
      />
      <div class="agent-chat__actions">
        <el-button v-if="sending" size="small" plain @click="stopGenerating">停止</el-button>
        <el-button type="primary" size="small" :loading="sending" :disabled="!input.trim()" @click="sendMessage">
          发送
        </el-button>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.agent-chat {
  display: flex;
  flex-direction: column;
  height: calc(100vh - var(--gmail-topbar-h) - 56px - 32px);
  min-height: 420px;
  margin: 16px;
  border: 1px solid var(--st-outline-variant);
  border-radius: 12px;
  background: #fff;
  overflow: hidden;
}

.agent-chat__toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px 16px;
  border-bottom: 1px solid var(--st-outline-variant);
  background: var(--st-surface-container-low, #f8fafc);
}

.agent-chat__brand {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
}

.agent-chat__brand :deep(svg) {
  width: 18px;
  height: 18px;
  color: var(--st-primary, #0058be);
}

.agent-chat__list {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.agent-chat__row {
  display: flex;
}

.agent-chat__row--user {
  justify-content: flex-end;
}

.agent-chat__row--assistant {
  justify-content: flex-start;
}

.agent-chat__bubble {
  max-width: min(720px, 88%);
  padding: 10px 14px;
  border-radius: 14px;
  font-size: 14px;
  line-height: 1.6;
}

.agent-chat__row--user .agent-chat__bubble {
  background: var(--st-primary-container, #e6f0ff);
  color: var(--st-on-primary-container, #001d35);
  border-bottom-right-radius: 4px;
}

.agent-chat__row--assistant .agent-chat__bubble {
  background: var(--st-surface-container, #f1f5f9);
  color: var(--st-on-surface);
  border-bottom-left-radius: 4px;
}

.agent-chat__text {
  margin: 0;
  word-break: break-word;
}

.agent-chat__typing {
  display: inline-flex;
  gap: 4px;
  margin: 0;
  padding: 4px 0;
}

.agent-chat__typing span {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--st-on-surface-variant);
  animation: agent-dot 1.2s infinite ease-in-out;
}

.agent-chat__typing span:nth-child(2) {
  animation-delay: 0.15s;
}

.agent-chat__typing span:nth-child(3) {
  animation-delay: 0.3s;
}

@keyframes agent-dot {
  0%,
  80%,
  100% {
    opacity: 0.3;
    transform: translateY(0);
  }
  40% {
    opacity: 1;
    transform: translateY(-3px);
  }
}

.agent-chat__composer {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 12px 16px 16px;
  border-top: 1px solid var(--st-outline-variant);
  background: #fff;
}

.agent-chat__input {
  width: 100%;
  resize: none;
  border: 1px solid var(--st-outline-variant);
  border-radius: 10px;
  padding: 10px 12px;
  font: inherit;
  line-height: 1.5;
  outline: none;
  transition: border-color 0.15s ease;
}

.agent-chat__input:focus {
  border-color: var(--st-primary, #0058be);
}

.agent-chat__actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}
</style>
