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

export interface UserInfoVO {
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
  randomSubjectMode?: 'all' | 'single'
  randomSubject?: string
}

/** 用户目标院校 */
export interface UserTargetVO {
  id: number
  userId: number
  schoolId: number
  majorId?: number | null
  schoolName: string
  schoolProvince?: string
  schoolCity?: string
  schoolType?: string
  majorName?: string | null
  majorCategory?: string | null
  createdAt?: string
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
  userAnswer?: string | null
  correct?: boolean | null
  answer?: string | null
  analysis?: string | null
  /** 今日已签到时随机展示的鼓励寄语 */
  encouragement?: string | null
}

/** 手动错题本列表/详情 */
export interface WrongQuestionVO {
  id: number
  questionId: number
  subject: string
  stem: string
  options: string[]
  difficulty?: number
  userAnswer: string
  answer: string
  analysis?: string
  wrongCount: number
  lastWrongAt: string
  createdAt: string
}

/** 刷题备忘录列表/详情 */
export interface PracticeNoteVO {
  id: number
  questionId: number
  subject: string
  stem: string
  options: string[]
  analysis?: string
  userNote?: string
  answer: string
  createdAt: string
}

/** 清空重刷结果 */
export interface RandomResetVO {
  subjects: string[]
  clearedRecordCount: number
}

/** 其它科目待复习提示 */
export interface RandomPendingHintVO {
  otherSubjects: string[]
  showHint: boolean
}

/** 答题历史列表项 */
export interface AnswerHistoryVO {
  id: number
  questionId: number
  subject: string
  stem: string
  userAnswer: string
  correct: boolean
  source: string
  createdAt: string
}

export interface ChatReplyVO {
  reply: string
  sessionId: string
}
