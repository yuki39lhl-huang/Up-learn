import request, { getData } from './request'
import type {
  PaperDetailVO,
  PaperListItemVO,
  PaperOptionsVO,
  PaperPdfVO,
  PaperStartVO,
  PaperSubmitResultVO,
  PaperSaveAnswersDTO,
} from '../types/api'

export function fetchPaperOptions() {
  return getData<PaperOptionsVO>(request.get('/practice/papers/options'))
}

export function fetchPaperList(params: { province: string; subject: string }) {
  return getData<PaperListItemVO[]>(request.get('/practice/papers', { params }))
}

export function fetchPaperDetail(id: number) {
  return getData<PaperDetailVO>(request.get(`/practice/papers/${id}`))
}

export function fetchPaperPdf(id: number) {
  return getData<PaperPdfVO>(request.get(`/practice/papers/${id}/pdf`))
}

export function startPaper(id: number) {
  return getData<PaperStartVO>(request.post(`/practice/papers/${id}/start`))
}

export function savePaperAnswers(attemptId: number, body: PaperSaveAnswersDTO) {
  return getData<void>(request.put(`/practice/papers/attempts/${attemptId}/answers`, body))
}

export function submitPaper(attemptId: number) {
  return getData<PaperSubmitResultVO>(request.post(`/practice/papers/attempts/${attemptId}/submit`))
}
