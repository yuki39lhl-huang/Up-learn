$ErrorActionPreference = "Continue"
$root = "E:\GrammarPractice\IdeaProject\up-learn"
$mysqlExe = (Get-Command mysql).Source

function Import-Sql([string]$file, [string]$db = "") {
  Write-Host ">> $(Split-Path $file -Leaf)"
  $args = @("-h127.0.0.1", "-P3308", "-uroot", "-p1234", "--default-character-set=utf8mb4")
  if ($db) { $args += $db }
  $p = Start-Process -FilePath $mysqlExe -ArgumentList $args -RedirectStandardInput $file -RedirectStandardError "$env:TEMP\mysql-err.txt" -RedirectStandardOutput "$env:TEMP\mysql-out.txt" -NoNewWindow -PassThru -Wait
  $err = Get-Content "$env:TEMP\mysql-err.txt" -ErrorAction SilentlyContinue | Where-Object { $_ -and ($_ -notmatch "Using a password") }
  if ($err) { $err | ForEach-Object { Write-Host $_ } }
  if ($p.ExitCode -ne 0) { Write-Host "WARN exit=$($p.ExitCode)" }
}

Write-Host "=== nacos ==="
& $mysqlExe -h127.0.0.1 -P3308 -uroot -p1234 -e "CREATE DATABASE IF NOT EXISTS nacos DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>$null
Import-Sql "$root\docker\nacos-mysql-schema.sql" "nacos"
Import-Sql "$root\docker\nacos-default-user.sql" "nacos"

Write-Host "=== up_learn base ==="
Import-Sql "$root\sql\phase1\up_learn.sql"

$order = @(
  "migrate_user_password_set.sql",
  "migrate_user_exam_preference.sql",
  "migrate_random_practice.sql",
  "migrate_wrong_book_note.sql",
  "migrate_major_dict.sql",
  "migrate_major_discipline.sql",
  "migrate_exam_subject.sql",
  "migrate_syllabus.sql",
  "migrate_daily_encouragement.sql",
  "migrate_daily_encouragement_fix.sql",
  "migrate_user_ui_preference.sql",
  "migrate_user_ui_preference_v2.sql",
  "migrate_user_ui_preference_v3_blur.sql",
  "migrate_paper.sql",
  "migrate_paper_question_section.sql",
  "migrate_paper_choice_answers.sql",
  "migrate_paper_ai_score.sql",
  "migrate_answers_from_md.sql",
  "migrate_table_comments.sql",
  "fix_paper_comments.sql",
  "fix_paper_charset.sql",
  "school_seed.sql",
  "practice_seed.sql",
  "daily_encouragement_seed.sql",
  "syllabus_seed.sql",
  "syllabus_seed_shandong.sql",
  "paper_seed.sql",
  "paper_questions_guangdong.sql",
  "paper_questions_shandong.sql"
)
foreach ($f in $order) {
  $p = Join-Path "$root\sql\phase1" $f
  if (Test-Path $p) { Import-Sql $p "up_learn" }
}

Write-Host "=== verify ==="
& $mysqlExe -h127.0.0.1 -P3308 -uroot -p1234 -e "SHOW DATABASES; SELECT COUNT(*) nacos_tables FROM information_schema.tables WHERE table_schema='nacos'; SELECT COUNT(*) up_learn_tables FROM information_schema.tables WHERE table_schema='up_learn'; SELECT COUNT(*) schools FROM up_learn.school; SELECT COUNT(*) questions FROM up_learn.question; SELECT COUNT(*) papers FROM up_learn.paper; SELECT COUNT(*) paper_qs FROM up_learn.paper_question;" 2>$null
Write-Host "DONE_RESTORE"
