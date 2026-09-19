<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { createCommunityPost } from '../../api/community'
import { uploadCommunityImage } from '../../api/user'
import { publishCommunitySync } from '../../utils/communitySync'
import CommunityWindowShell from './CommunityWindowShell.vue'

const router = useRouter()
const submitting = ref(false)
const uploading = ref(false)
const title = ref('')
const content = ref('')
const tag = ref('')
const coverUrl = ref('')
const fileInput = ref<HTMLInputElement | null>(null)

const TAGS = ['经验', '院校', '专业', '科目', '问答']

function pickCover() {
  fileInput.value?.click()
}

async function onCoverFile(ev: Event) {
  const input = ev.target as HTMLInputElement
  const file = input.files?.[0]
  input.value = ''
  if (!file) return
  if (!file.type.startsWith('image/')) {
    ElMessage.warning('请选择图片文件')
    return
  }
  if (file.size > 2 * 1024 * 1024) {
    ElMessage.warning('图片不能超过 2MB')
    return
  }
  uploading.value = true
  try {
    const { url } = await uploadCommunityImage(file)
    coverUrl.value = url
    ElMessage.success('配图已上传')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '上传失败，请确认 OSS 已配置')
  } finally {
    uploading.value = false
  }
}

function clearCover() {
  coverUrl.value = ''
}

async function submit() {
  const t = title.value.trim()
  const c = content.value.trim()
  if (!t || !c) {
    ElMessage.warning('请填写标题和正文')
    return
  }
  submitting.value = true
  try {
    const post = await createCommunityPost({
      title: t,
      content: c,
      tag: tag.value.trim() || undefined,
      coverUrl: coverUrl.value.trim() || undefined,
    })
    ElMessage.success('发布成功')
    publishCommunitySync({ type: 'post-created', postId: post.id, userId: post.userId })
    await router.replace(`/community/post/${post.id}`)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '发布失败')
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <CommunityWindowShell title="编写帖子">
    <section class="compose">
      <el-input v-model="title" maxlength="120" show-word-limit placeholder="标题（院校 / 专业 / 备考经验）" />
      <div class="compose__tags">
        <button
          v-for="item in TAGS"
          :key="item"
          type="button"
          class="compose__tag"
          :class="{ 'is-on': tag === item }"
          @click="tag = tag === item ? '' : item"
        >
          {{ item }}
        </button>
      </div>
      <el-input
        v-model="content"
        type="textarea"
        :rows="14"
        maxlength="10000"
        show-word-limit
        placeholder="正文：分享备考节奏、院校选择、科目经验…"
      />

      <div class="compose-cover">
        <div class="compose-cover__head">
          <span>封面图（可选）</span>
          <div class="compose-cover__actions">
            <el-button size="small" :loading="uploading" @click="pickCover">上传图片</el-button>
            <el-button v-if="coverUrl" size="small" text @click="clearCover">清除</el-button>
          </div>
        </div>
        <input
          ref="fileInput"
          type="file"
          accept="image/jpeg,image/png,image/webp"
          class="compose-cover__file"
          @change="onCoverFile"
        />
        <img v-if="coverUrl" class="compose-cover__preview" :src="coverUrl" alt="封面预览" />
        <p v-else class="compose-cover__hint">支持 JPG / PNG / WebP，不超过 2MB；需配置 OSS</p>
      </div>

      <div class="compose__foot">
        <el-button type="primary" :loading="submitting" :disabled="uploading" @click="submit">
          发布
        </el-button>
      </div>
    </section>
  </CommunityWindowShell>
</template>

<style scoped>
.compose {
  display: flex;
  flex-direction: column;
  gap: 14px;
  padding: 18px;
  border-radius: 16px;
  background: color-mix(in srgb, var(--st-surface) 92%, transparent);
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 50%, transparent);
  box-shadow: 0 8px 28px rgb(0 0 0 / 4%);
}

.compose__tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.compose__tag {
  border: 1px solid color-mix(in srgb, var(--st-outline-variant) 70%, transparent);
  background: transparent;
  color: var(--st-on-surface-variant);
  border-radius: 999px;
  padding: 4px 12px;
  font: inherit;
  font-size: 12px;
  cursor: pointer;
}

.compose__tag.is-on {
  border-color: var(--st-primary);
  color: var(--st-primary);
  background: color-mix(in srgb, var(--st-primary) 10%, transparent);
}

.compose-cover {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 12px;
  border-radius: 12px;
  border: 1px dashed color-mix(in srgb, var(--st-outline-variant) 70%, transparent);
}

.compose-cover__head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  font-size: 13px;
  font-weight: 600;
}

.compose-cover__actions {
  display: flex;
  gap: 4px;
}

.compose-cover__file {
  display: none;
}

.compose-cover__preview {
  width: 100%;
  max-height: 220px;
  object-fit: cover;
  border-radius: 10px;
}

.compose-cover__hint {
  margin: 0;
  font-size: 12px;
  color: var(--st-on-surface-variant);
}

.compose__foot {
  display: flex;
  justify-content: flex-end;
}
</style>
