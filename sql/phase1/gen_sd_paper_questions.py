# -*- coding: utf-8 -*-
"""
山东专升本 paper_question 种子生成器。

用法：
  python extract_sd_pdfs.py
  python gen_sd_paper_questions.py
  docker cp paper_questions_shandong.sql ul-mysql:/tmp/
  docker exec -i ul-mysql sh -c "mysql -uroot -p1234 --default-character-set=utf8mb4 up_learn < /tmp/paper_questions_shandong.sql"
"""
from __future__ import annotations

from pathlib import Path

try:
    from english_sd_parse import parse_english_sd_paper, quality_english_sd
except ImportError:
    from sql.phase1.english_sd_parse import parse_english_sd_paper, quality_english_sd  # type: ignore

try:
    from gd_chinese_subject_parse import parse_gd_chinese_paper, quality_chinese_paper
except ImportError:
    from sql.phase1.gd_chinese_subject_parse import (  # type: ignore
        parse_gd_chinese_paper,
        quality_chinese_paper,
    )

try:
    from gen_gd_paper_questions import normalize_question, esc
except ImportError:
    from sql.phase1.gen_gd_paper_questions import normalize_question, esc  # type: ignore

EXTRACT = Path(__file__).resolve().parent / "_pdf_extract_sd"
OUT = Path(__file__).resolve().parent / "paper_questions_shandong.sql"
REPORT = Path(__file__).resolve().parent / "_reseed_report_sd.txt"

# 展示科目 → 抽取目录文件夹名
SUBJECT_FOLDER = {
    "英语": "英语",
    "政治": "政治",
    "大学语文": "语文",
    "计算机": "计算机",
    "高等数学I": "高数一",
    "高等数学II": "高数二",
    "高等数学III": "高数三",
}

SUBJECTS_YEARS = {
    "英语": [2022, 2023, 2024, 2025],
    "政治": [2025],
    "大学语文": [2022, 2023, 2024, 2025],
    "计算机": [2022, 2023, 2024, 2025],
    "高等数学I": [2022, 2023, 2024, 2025],
    "高等数学II": [2022, 2023, 2024, 2025],
    "高等数学III": [2022, 2023, 2024, 2025],
}

MIN_CHOICE = {
    "英语": 8,
    "政治": 0,
    "大学语文": 6,
    "计算机": 15,
    "高等数学I": 4,
    "高等数学II": 4,
    "高等数学III": 6,
}

CHINESE_SUBJECTS = {
    "政治",
    "大学语文",
    "计算机",
    "高等数学I",
    "高等数学II",
    "高等数学III",
}


def find_extract(folder: str, year: int) -> str | None:
    if not EXTRACT.exists():
        return None
    hits: list[Path] = []
    for f in EXTRACT.glob("*.txt"):
        if f.name.startswith("_"):
            continue
        if f"{folder}__" in f.name or f.name.startswith(folder + "__"):
            if str(year) in f.name:
                hits.append(f)
    if not hits:
        for f in EXTRACT.glob("*.txt"):
            if str(year) in f.name and folder in f.name:
                hits.append(f)
    if not hits:
        return None
    hits.sort(key=lambda p: p.stat().st_size, reverse=True)
    return hits[0].read_text(encoding="utf-8", errors="replace")


def questions_for(subject: str, year: int) -> tuple[list[dict], str, bool]:
    folder = SUBJECT_FOLDER.get(subject)
    text = find_extract(folder, year) if folder else None
    if not text:
        return [], "无抽取文本", False

    if subject == "英语":
        parsed = parse_english_sd_paper(text)
        ok, reason = quality_english_sd(parsed)
        if ok:
            return parsed, f"山东英语解析·{reason}", True
        return [], f"英语未达门槛·{reason}（已清空）", False

    if subject in CHINESE_SUBJECTS:
        parsed = parse_gd_chinese_paper(text)
        # 政治残卷：主观题很少也尽量上架
        min_c = MIN_CHOICE.get(subject, 6)
        ok, reason = quality_chinese_paper(parsed, min_choice=min_c)
        if not ok and subject == "政治" and len(parsed) >= 3:
            return parsed, f"中文卷残卷上架·{reason}", True
        if ok:
            return parsed, f"中文卷解析·{reason}", True
        return [], f"中文卷未达门槛·{reason}（已清空）", False

    return [], "未注册科目", False


def sql_question_values(paper_id_expr: str, qs: list[dict]) -> str:
    rows = []
    for q in qs:
        opts = "NULL"
        if q.get("options"):
            arr = ",".join(f"'{esc(o)}'" for o in q["options"])
            opts = f"JSON_ARRAY({arr})"
        ans = f"'{esc(q['answer'])}'" if q.get("answer") else "NULL"
        ana = f"'{esc(q['analysis'])}'" if q.get("analysis") else "NULL"
        paper_no = q.get("paper_no")
        paper_no_sql = "NULL" if paper_no is None else str(int(paper_no))
        sec = q.get("section_title")
        sec_sql = "NULL" if not sec else f"'{esc(sec)}'"
        rows.append(
            f"({paper_id_expr},{q['seq']},{paper_no_sql},'{q['q_type']}',{sec_sql},"
            f"'{esc(q['stem'])}',{opts},{ans},{ana},{q['score']},'{q['input_mode']}')"
        )
    return ",\n".join(rows)


def main() -> None:
    papers: list[tuple[str, int]] = []
    for sub, years in SUBJECTS_YEARS.items():
        for y in years:
            papers.append((sub, y))

    lines = [
        "-- 山东专升本真题结构化题目",
        "-- 由 gen_sd_paper_questions.py 生成；导入请用 UTF-8",
        "USE up_learn;",
        "SET NAMES utf8mb4;",
        "",
    ]
    report: list[str] = []

    for sub, year in papers:
        qs, note, publish = questions_for(sub, year)
        qs = [normalize_question(q) for q in qs]
        has_ans = 1 if any(q.get("answer") for q in qs) else 0
        pub = 1 if publish and qs else 0
        report.append(f"{sub}\t{year}\t题量={len(qs)}\tpublished={pub}\t{note}")

        lines.append(f"-- ===== 山东 {sub} {year} ({len(qs)} 题, published={pub}) · {note} =====")
        lines.append(
            f"SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='{esc(sub)}' AND year={year} AND deleted=0 LIMIT 1);"
        )
        lines.append("DELETE FROM paper_question WHERE paper_id=@pid;")
        if qs:
            lines.append(
                "INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES"
            )
            lines.append(sql_question_values("@pid", qs) + ";")
        lines.append(f"UPDATE paper SET has_answer={has_ans}, published={pub} WHERE id=@pid;")
        lines.append("")

    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    REPORT.write_text("\n".join(report) + "\n", encoding="utf-8")
    print("wrote", OUT)
    print("report", REPORT)
    for line in report:
        print(line)


if __name__ == "__main__":
    main()
