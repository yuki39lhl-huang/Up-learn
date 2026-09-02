import request, { getData } from './request'
import type {
  AnswerHistoryVO,
  DailyStatusVO,
  PageDTO,
  PracticeNoteVO,
  QuestionVO,
  RandomPendingHintVO,
  RandomResetVO,
  StudyStatsVO,
  SubmitResultVO,
  WrongQuestionVO,
} from '../types/api'

export function fetchDailyStatus() {
  return getData<DailyStatusVO>(request.get('/practice/daily/status'))
}

export function fetchDaily(subject?: string) {
  return getData<QuestionVO>(
    request.get('/practice/daily', { params: subject ? { subject } : undefined })
  )
}

/** 重置每日一练签到（累计/连续天数归零） */
export function resetDailyCheckIn() {
  return getData<void>(request.delete('/practice/daily/checkin'))
}

/** 备考重置：清空全部随机刷题进度与统计 */
export function resetRandomProgress() {
  return getData<void>(request.delete('/practice/random/progress'))
}

export function fetchRandom() {
  return getData<QuestionVO>(request.get('/practice/random'))
}

export function fetchRandomPendingHint() {
  return getData<RandomPendingHintVO>(request.get('/practice/random/pending-hint'))
}

export function submitAnswer(questionId: number, userAnswer: string, source: string) {
  return getData<SubmitResultVO>(
    request.post('/practice/submit', { questionId, userAnswer, source })
  )
}

/** source=random 时仅统计随机刷题答题，不含连续打卡 */
export function fetchStats(source?: string) {
  return getData<StudyStatsVO>(
    request.get('/practice/stats', { params: source ? { source } : undefined }),
  )
}

export function fetchWrongList(params?: {
  pageNo?: number
  pageSize?: number
  date?: string
  subject?: string
}) {
  return getData<PageDTO<WrongQuestionVO>>(request.get('/practice/wrong', { params }))
}

export function addWrongBook(questionId: number, userAnswer: string) {
  return getData<WrongQuestionVO>(
    request.post('/practice/wrong', { questionId, userAnswer }),
  )
}

export function fetchWrongDetail(id: number) {
  return getData<WrongQuestionVO>(request.get(`/practice/wrong/${id}`))
}

export function deleteWrongBook(id: number) {
  return getData<void>(request.delete(`/practice/wrong/${id}`))
}

export function clearWrongBook(date?: string, subject?: string) {
  return getData<number>(
    request.delete('/practice/wrong/batch', {
      params: { ...(date ? { date } : {}), ...(subject ? { subject } : {}) },
    }),
  )
}

export function fetchNoteList(params?: {
  pageNo?: number
  pageSize?: number
  date?: string
  subject?: string
}) {
  return getData<PageDTO<PracticeNoteVO>>(request.get('/practice/notes', { params }))
}

export function addPracticeNote(questionId: number, userNote?: string) {
  return getData<PracticeNoteVO>(
    request.post('/practice/notes', { questionId, userNote }),
  )
}

export function fetchNoteDetail(id: number) {
  return getData<PracticeNoteVO>(request.get(`/practice/notes/${id}`))
}

export function deletePracticeNote(id: number) {
  return getData<void>(request.delete(`/practice/notes/${id}`))
}

export function clearPracticeNotes(date?: string, subject?: string) {
  return getData<number>(
    request.delete('/practice/notes/batch', {
      params: { ...(date ? { date } : {}), ...(subject ? { subject } : {}) },
    }),
  )
}

/** 清空重刷：清除复习调度与当日已做，scope=all|single */
export function resetRandomPractice(scope: 'all' | 'single', subject?: string) {
  return getData<RandomResetVO>(
    request.post('/practice/random/reset', { scope, subject }),
  )
}

export function fetchAnswerHistory(params?: { pageNo?: number; pageSize?: number }) {
  return getData<PageDTO<AnswerHistoryVO>>(request.get('/practice/history', { params }))
}
