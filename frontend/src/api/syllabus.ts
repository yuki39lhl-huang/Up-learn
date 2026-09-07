import request, { getData } from './request'
import type { SyllabusOptionsVO, SyllabusVO } from '../types/api'

/** 考纲筛选选项（公开接口） */
export function fetchSyllabusOptions() {
  return getData<SyllabusOptionsVO>(request.get('/syllabus/options'))
}

/** 考纲详情；无数据时 data 可能为 null */
export function fetchSyllabusDetail(params: { province: string; year: number; subject: string }) {
  return getData<SyllabusVO | null>(request.get('/syllabus', { params }))
}
