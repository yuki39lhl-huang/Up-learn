import request, { getData } from './request'
import type { DailyStatusVO, QuestionVO, StudyStatsVO, SubmitResultVO } from '../types/api'

export function fetchDailyStatus() {
  return getData<DailyStatusVO>(request.get('/practice/daily/status'))
}

export function fetchDaily(subject?: string) {
  return getData<QuestionVO>(
    request.get('/practice/daily', { params: subject ? { subject } : undefined })
  )
}

export function fetchRandom(subject?: string) {
  return getData<QuestionVO>(
    request.get('/practice/random', { params: subject ? { subject } : undefined })
  )
}

export function submitAnswer(questionId: number, userAnswer: string, source: string) {
  return getData<SubmitResultVO>(
    request.post('/practice/submit', { questionId, userAnswer, source })
  )
}

export function fetchStats() {
  return getData<StudyStatsVO>(request.get('/practice/stats'))
}
