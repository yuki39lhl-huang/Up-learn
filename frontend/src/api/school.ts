import request, { getData } from './request'
import type { MajorOptionVO, MajorVO, PageDTO, SchoolVO } from '../types/api'

export interface SchoolListQuery {
  pageNo?: number
  pageSize?: number
  kw?: string
  province?: string
  type?: string
  year?: number
  majorDictId?: number
  majorCategory?: string
  preferPublic?: boolean
}

export interface MajorOptionQuery {
  pageNo?: number
  pageSize?: number
  kw?: string
  majorCategory?: string
}

/** 院校分页（公开接口，经网关白名单） */
export function fetchSchoolList(query: SchoolListQuery = {}) {
  return getData<PageDTO<SchoolVO>>(request.get('/school/list', { params: query }))
}

/** 专业词典选项（Combobox 模糊搜索，可传 majorCategory 级联） */
export function fetchMajorOptions(query: MajorOptionQuery = {}) {
  return getData<PageDTO<MajorOptionVO>>(request.get('/major/options', { params: query }))
}

/** 专业类列表（级联第一级） */
export function fetchMajorCategories() {
  return getData<string[]>(request.get('/major/categories'))
}

export interface SchoolMajorsQuery {
  majorDictId?: number
  majorCategory?: string
}

/** 某校开设专业列表（可选筛选上下文，用于相关度排序） */
export function fetchSchoolMajors(schoolId: number, query: SchoolMajorsQuery = {}) {
  return getData<MajorVO[]>(request.get(`/school/${schoolId}/majors`, { params: query }))
}
