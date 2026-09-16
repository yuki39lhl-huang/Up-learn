<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import StitchIcon from './StitchIcon.vue'
import { chatStream, fetchAgentStatus, getAgentSessionId, resetAgentSession } from '../../api/agent'
import { useExamPrefsStore } from '../../stores/examPrefs'
import { renderGuideMarkdown } from '../../utils/renderGuideMarkdown'

interface ChatMessage {
  role: 'user' | 'assistant'
  content: string
  /** 等待首包（工具调用 / 模型思考） */
  waiting?: boolean
  /** 正在流式输出正文 */
  streaming?: boolean
}

const examPrefs = useExamPrefsStore()

const messages = ref<ChatMessage[]>([])
const input = ref('')
const sending = ref(false)
const sessionId = ref(getAgentSessionId())
const listRef = ref<HTMLElement | null>(null)
const ragEnabled = ref(false)
let abortController: AbortController | null = null

const statusHint = computed(() => {
  const ragPart = ragEnabled.value ? '知识库检索已启用' : '知识库未启用'
  if (examPrefs.isConfigured) {
    return `已加载备考档案 · 会话记忆已启用 · ${ragPart}`
  }
  return `未配置备考 · 请先到主页完成备考设置 · 会话记忆已启用 · ${ragPart}`
})

const welcome = computed(() => {
  if (examPrefs.isConfigured) {
    const p = examPrefs.prefs
    return `你好，我是「一点通」。已读取你的备考设置（${p.province} · ${p.cohortYear} 届 · ${p.majorCategory}），可直接问科目、目标院校或备考问题。`
  }
  return '你好，我是「一点通」。检测到你尚未完成备考设置，请先到主页填写省份、届别与考试科目，我才能按你的情况回答。'
})

function renderAssistantHtml(content: string) {
  return renderGuideMarkdown(content)
}

function escapePlain(text: string) {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/\n/g, '<br>')
}

async function loadStatus() {
  try {
    const st = await fetchAgentStatus()
    ragEnabled.value = !!st.ragEnabled
  } catch {
    ragEnabled.value = false
  }
}

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
  messages.value = [{ role: 'assistant', content: welcome.value }]
  scrollToBottom()
}

async function sendMessage() {
  const text = input.value.trim()
  if (!text || sending.value) return

  messages.value.push({ role: 'user', content: text })
  const assistantIndex = messages.value.length
  messages.value.push({ role: 'assistant', content: '', waiting: true })
  input.value = ''
  scrollToBottom()

  sending.value = true
  abortController = new AbortController()

  try {
    await chatStream(
      text,
      sessionId.value,
      (accumulated) => {
        messages.value[assistantIndex] = {
          role: 'assistant',
          content: accumulated,
          waiting: false,
          streaming: true,
        }
        scrollToBottom()
      },
      abortController.signal
    )
    const last = messages.value[assistantIndex]
    if (!last.content) {
      last.content = '抱歉，未能生成有效回答，请稍后再试。'
    }
    last.waiting = false
    last.streaming = false
  } catch (e) {
    if (e instanceof Error && e.name === 'AbortError') return
    const last = messages.value[assistantIndex]
    last.waiting = false
    last.streaming = false
    last.content = e instanceof Error ? e.message : '请求失败'
    ElMessage.error(last.content)
  } finally {
    sending.value = false
    abortController = null
    scrollToBottom()
  }
}

function stopGenerating() {
  abortController?.abort()
  sending.value = false
  const last = messages.value[messages.value.length - 1]
  if (last) {
    last.waiting = false
    last.streaming = false
  }
}

function onKeydown(e: KeyboardEvent) {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault()
    sendMessage()
  }
}

onMounted(async () => {
  await Promise.all([examPrefs.loadRemote(), loadStatus()])
  messages.value = [{ role: 'assistant', content: welcome.value }]
})
</script>

<template>
  <div class="module-shell module-shell--fill">
    <section class="module-card module-card--fill">
      <header class="module-card__head">
        <div>
          <p class="module-card__eyebrow">升学通 · AI 助手</p>
          <h2>对话答疑</h2>
        </div>
        <el-button size="small" plain @click="startNewChat">新对话</el-button>
      </header>

      <p class="agent-card__hint">
        <StitchIcon name="agent" />
        <span>{{ statusHint }}</span>
      </p>

      <div ref="listRef" class="agent-chat__list">
        <div
          v-for="(msg, i) in messages"
          :key="i"
          class="agent-chat__row"
          :class="`agent-chat__row--${msg.role}`"
        >
          <div class="agent-chat__bubble" :class="{ 'agent-chat__bubble--streaming': msg.streaming }">
            <p v-if="msg.waiting && !msg.content" class="agent-chat__typing">
              <span /><span /><span />
            </p>
            <div
              v-else-if="msg.role === 'assistant'"
              class="agent-chat__md"
              v-html="renderAssistantHtml(msg.content)"
            />
            <div v-else class="agent-chat__text" v-html="escapePlain(msg.content)" />
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
    </section>
  </div>
</template>

<style scoped>
.agent-card__hint {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  margin: 0 0 12px;
  font-size: 13px;
  color: var(--st-on-surface-variant);
  flex-shrink: 0;
}

.agent-card__hint :deep(svg) {
  width: 18px;
  height: 18px;
  color: var(--st-primary, #0058be);
}

.agent-chat__list {
  flex: 1;
  overflow-y: auto;
  padding: 4px 0 12px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  min-height: 0;
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
  padding: 12px 16px;
  border-radius: 14px;
  font-size: 14px;
  line-height: 1.65;
}

.agent-chat__row--user .agent-chat__bubble {
  background: transparent;
  border: none;
  padding: 6px 4px;
  color: var(--st-on-surface);
}

.agent-chat__row--assistant .agent-chat__bubble {
  background: var(--st-surface-container, #f1f5f9);
  color: var(--st-on-surface);
  border-bottom-left-radius: 4px;
}

.agent-chat__bubble--streaming::after {
  content: '';
  display: inline-block;
  width: 7px;
  height: 1.05em;
  margin-left: 2px;
  vertical-align: -0.15em;
  background: var(--st-primary, #0058be);
  animation: agent-caret 0.9s step-end infinite;
}

@keyframes agent-caret {
  50% {
    opacity: 0;
  }
}

.agent-chat__text {
  margin: 0;
  word-break: break-word;
}

.agent-chat__md {
  word-break: break-word;
}

.agent-chat__md :deep(h1),
.agent-chat__md :deep(h2),
.agent-chat__md :deep(h3) {
  margin: 0.85em 0 0.4em;
  font-weight: 650;
  line-height: 1.35;
  color: var(--st-on-surface);
}

.agent-chat__md :deep(h1:first-child),
.agent-chat__md :deep(h2:first-child),
.agent-chat__md :deep(h3:first-child) {
  margin-top: 0;
}

.agent-chat__md :deep(h2) {
  font-size: 15px;
}

.agent-chat__md :deep(h3) {
  font-size: 14px;
}

.agent-chat__md :deep(p) {
  margin: 0 0 0.65em;
}

.agent-chat__md :deep(p:last-child) {
  margin-bottom: 0;
}

.agent-chat__md :deep(ul),
.agent-chat__md :deep(ol) {
  margin: 0.35em 0 0.75em;
  padding-left: 1.25em;
}

.agent-chat__md :deep(li) {
  margin: 0.2em 0;
}

.agent-chat__md :deep(li + li) {
  margin-top: 0.35em;
}

.agent-chat__md :deep(strong) {
  font-weight: 650;
  color: var(--st-on-surface);
}

.agent-chat__md :deep(blockquote) {
  margin: 0.5em 0;
  padding: 0.35em 0 0.35em 0.85em;
  border-left: 3px solid var(--st-primary, #0058be);
  color: var(--st-on-surface-variant);
}

.agent-chat__md :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 0.55em 0 0.85em;
  font-size: 13px;
  overflow: hidden;
  border-radius: 8px;
  border: 1px solid rgba(15, 23, 42, 0.08);
}

.agent-chat__md :deep(th),
.agent-chat__md :deep(td) {
  padding: 8px 10px;
  text-align: left;
  border-bottom: 1px solid rgba(15, 23, 42, 0.06);
  vertical-align: top;
}

.agent-chat__md :deep(th) {
  background: var(--st-glass-inner-bg);
  font-weight: 600;
}

.agent-chat__md :deep(tr:last-child td) {
  border-bottom: none;
}

.agent-chat__md :deep(hr) {
  border: none;
  border-top: 1px solid rgba(15, 23, 42, 0.08);
  margin: 0.85em 0;
}

.agent-chat__md :deep(code) {
  font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  font-size: 0.92em;
  padding: 0.1em 0.35em;
  border-radius: 4px;
  background: rgba(15, 23, 42, 0.06);
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
  padding-top: 12px;
  border-top: 1px solid rgba(15, 23, 42, 0.08);
  flex-shrink: 0;
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
  background: var(--st-glass-inner-bg);
  color: var(--st-on-surface);
  transition: border-color 0.15s ease;
  box-sizing: border-box;
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
