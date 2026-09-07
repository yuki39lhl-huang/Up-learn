<script lang="ts">
import { defineComponent, type PropType } from 'vue'
import type { SyllabusScopeBlock } from '../../types/api'

/** 递归渲染考试范围树（标题 / 段落 / 条目 / 子块） */
export default defineComponent({
  name: 'SyllabusScopeTree',
  props: {
    blocks: {
      type: Array as PropType<SyllabusScopeBlock[]>,
      default: () => [],
    },
  },
})
</script>

<template>
  <div class="syllabus-blocks">
    <section
      v-for="(block, i) in blocks"
      :key="i"
      class="syllabus-block"
      :class="{ 'syllabus-block--highlight': block.highlight }"
    >
      <h3 v-if="block.heading" class="syllabus-block__heading">{{ block.heading }}</h3>
      <p v-for="(p, pi) in block.paragraphs ?? []" :key="`p-${pi}`" class="syllabus-block__p">
        {{ p }}
      </p>
      <ol v-if="block.items?.length" class="syllabus-block__items">
        <li v-for="(item, ii) in block.items" :key="ii">{{ item }}</li>
      </ol>
      <div v-if="block.children?.length" class="syllabus-blocks syllabus-blocks--nested">
        <SyllabusScopeTree :blocks="block.children" />
      </div>
    </section>
  </div>
</template>

<style scoped>
.syllabus-block {
  margin-bottom: 18px;
}

.syllabus-block--highlight {
  padding: 12px 14px;
  border-left: 3px solid #0f766e;
  border-radius: 0 8px 8px 0;
  background: rgba(15, 118, 110, 0.06);
}

.syllabus-block__heading {
  margin: 0 0 8px;
  font-size: 15px;
  font-weight: 650;
  color: #0f172a;
}

.syllabus-block__p {
  margin: 0 0 8px;
  font-size: 14px;
  line-height: 1.75;
  color: #334155;
}

.syllabus-block__items {
  margin: 0;
  padding-left: 2.2em;
  font-size: 14px;
  line-height: 1.7;
  color: #334155;
}

.syllabus-block__items li + li {
  margin-top: 4px;
}

.syllabus-blocks--nested {
  margin-left: 8px;
}
</style>
