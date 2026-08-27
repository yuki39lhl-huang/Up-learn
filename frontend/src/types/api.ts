/** 分页结果，与后端 PageDTO 对齐 */
export interface PageDTO<T> {
  total: number
  pages: number
  list: T[]
}

/** 与后端 common-service Result 对齐 */
export interface Result<T> {
  code: number
  msg: string
  data: T
}

export interface LoginVO {
  accessToken: string
  refreshToken: string
  accessExpiresIn: number
  newUser: boolean
  userId: number
  email: string
  nickname: string
  avatarUrl: string
}

export interface ExamSubjectSelectionVO {
  public: string[]
  foundation: string[]
  comprehensive: string[]
}

export interface UserExamPreferenceVO {
  id: number
  userId: number
  province: string
  cohortYear: number
  majorCategory: string
  subjectSelection: ExamSubjectSelectionVO
  dailySubject: string
  dailySubjectMode: 'fixed' | 'random'
}

export interface SchoolVO {
  id: number
  name: string
  province: string
  city: string
  type: string
  typeTag?: string
  preferPublic?: boolean
  majorCount?: number
  enrollment?: number
  tuition?: number
  minScore?: number
}

export interface MajorOptionVO {
  id: number
  name: string
  majorCategory?: string
}

export interface MajorVO {
  id: number
  schoolId: number
  majorDictId: number
  name: string
  majorCategory?: string
  examSubjects?: string
  avgScore?: number
  enrollment?: number
  tuition?: number
  minScore?: number
  year?: number
}

export interface QuestionVO {
  id: number
  subject: string
  stem: string
  options: string[]
  difficulty?: number
}

export interface SubmitResultVO {
  questionId: number
  correct: boolean
  answer: string
  analysis?: string
  userAnswer: string
}

export interface StudyStatsVO {
  totalAnswered: number
  correctCount: number
  accuracy: number
  /** 连续签到天数 */
  streak: number
  /** 累计签到天数 */
  totalCheckInDays: number
}

export interface DailyStatusVO {
  completedToday: boolean
  subject: string | null
  questionId: number | null
}

export interface ChatReplyVO {
  reply: string
  sessionId: string
}
