# -*- coding: utf-8 -*-
"""
广东专升本 paper_question 种子生成器（全省共用一套骨架）。

优先级：
1. 分年定稿（如 gaoshu_by_year_data）—— 质量最高
2. 从 _pdf_extract 文本解析 —— 仅达到质量门槛才入库
3. 达不到门槛：清空题目并 published=0（不再灌占位假题）

用法：
  python extract_gd_pdfs.py
  python gen_gd_paper_questions.py
  docker cp paper_questions_guangdong.sql ul-mysql:/tmp/
  docker exec -i ul-mysql mysql -uroot -p1234 --default-character-set=utf8mb4 < /tmp/paper_questions_guangdong.sql
"""
from __future__ import annotations

import re
from pathlib import Path

try:
    from gaoshu_by_year_data import questions_for_year as gaoshu_questions_for_year
except ImportError:
    from sql.phase1.gaoshu_by_year_data import questions_for_year as gaoshu_questions_for_year  # type: ignore

try:
    from english_gd_parse import parse_english_paper
except ImportError:
    from sql.phase1.english_gd_parse import parse_english_paper  # type: ignore

EXTRACT = Path(__file__).resolve().parent / "_pdf_extract"
OUT = Path(__file__).resolve().parent / "paper_questions_guangdong.sql"
REPORT = Path(__file__).resolve().parent / "_reseed_report.txt"

SUBJECT_FOLDER = {
    "高等数学": "高数",
    "英语": "英语",
    "大学语文": "语文",
    "政治理论": "政治理论",
    "管理学": "管理学",
    "经济学": "经济学",
    "教育理论": "教育理论",
    "生理学": "生理学",
}

# 分年定稿注册表：科目 → questions_for_year(year) -> list[dict]
CURATED_BY_SUBJECT = {
    "高等数学": gaoshu_questions_for_year,
}

# 至少要有这么多「完整四选项」选择题，才视为可上架
MIN_FULL_CHOICE = {
    "高等数学": 5,
    "英语": 10,
    "大学语文": 8,
    "政治理论": 15,
    "管理学": 15,
    "经济学": 15,
    "教育理论": 8,
    "生理学": 12,
}

SUBJECTS_YEARS = {
    "高等数学": [2022, 2023, 2024, 2025],
    "英语": [2022, 2023, 2024, 2025],
    "大学语文": [2022, 2023, 2024, 2025],
    "政治理论": [2022, 2023, 2024, 2025],
    "管理学": [2022, 2024, 2025],
    "经济学": [2022, 2023, 2024, 2025],
    "教育理论": [2023, 2024, 2025],
    "生理学": [2022, 2023, 2024, 2025],
}


def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "''")


def find_extract(folder: str, year: int) -> str | None:
    if not EXTRACT.exists():
        return None
    hits: list[Path] = []
    for f in EXTRACT.glob("*.txt"):
        name = f.name
        if f"{folder}__" in name or name.startswith(folder + "__"):
            if str(year) in name:
                hits.append(f)
    if not hits:
        for f in EXTRACT.glob("*.txt"):
            if str(year) in f.name and folder in f.name:
                hits.append(f)
    if not hits:
        return None
    # 同科同年多文件时取最长文本
    hits.sort(key=lambda p: p.stat().st_size, reverse=True)
    return hits[0].read_text(encoding="utf-8", errors="replace")


def _parse_inline_options(body: str) -> list[str]:
    """支持「A.xx B.xx」同排或分行。"""
    opts: list[str] = []
    for m in re.finditer(
        r"(?:^|[\s\n])([A-Da-d])[.、．\)]\s*([^\n]*?)(?=(?:\s+[A-Da-d][.、．\)])|\n[A-Da-d][.、．\)]|$)",
        body,
        re.S,
    ):
        lab = m.group(1).upper()
        text = re.sub(r"\s+", " ", m.group(2)).strip(" ；;，,")
        if not text or len(text) > 400:
            continue
        # 跳过已收录字母
        if any(o.startswith(f"{lab}.") for o in opts):
            continue
        opts.append(f"{lab}. {text}")
        if len(opts) >= 4:
            break
    # 按 A-D 排序
    order = {c: i for i, c in enumerate("ABCD")}
    opts.sort(key=lambda o: order.get(o[0], 9))
    return opts


def parse_mcq_blocks(text: str, max_q: int = 80) -> list[dict]:
    """从抽取文本解析题号 + 选项 / 主观题。"""
    text = text.replace("\r", "\n")
    lines = [ln.strip() for ln in text.split("\n") if ln.strip()]
    blob = "\n".join(lines)
    parts = re.split(r"(?m)(?=^\d{1,2}[\.、．]\s*)", blob)
    questions: list[dict] = []
    seen_seq: set[int] = set()

    for part in parts:
        m = re.match(r"^(\d{1,2})[\.、．]\s*(.+)$", part, re.S)
        if not m:
            continue
        seq = int(m.group(1))
        if seq in seen_seq or seq > 80:
            continue
        body = m.group(2).strip()
        # 截断下一题号残留（保险）
        body = re.split(r"(?m)^\d{1,2}[\.、．]\s*", body, maxsplit=1)[0].strip()

        opts = _parse_inline_options(body)
        stem = re.split(r"(?:^|\n|\s)A[.、．\)]", body, maxsplit=1)[0].strip()
        stem = re.sub(r"\s+", " ", stem)
        # 清洗页眉杂质
        stem = re.sub(r"第\s*\d+\s*页.*", "", stem).strip()
        if len(stem) < 4:
            continue
        junk_markers = ("暂无", "选项不详", "无完整真题", "结合回顾考查")
        if any(j in stem for j in junk_markers):
            continue

        seen_seq.add(seq)
        if len(opts) >= 4:
            questions.append(
                {
                    "seq": seq,
                    "q_type": "choice",
                    "stem": stem[:800],
                    "options": opts[:4],
                    "answer": "",
                    "analysis": "",
                    "score": 2,
                    "input_mode": "answerable",
                }
            )
        elif len(opts) >= 2:
            # 选项不全：仍保留但标为需校对，分数照常；质量门槛会卡完整四选
            questions.append(
                {
                    "seq": seq,
                    "q_type": "choice",
                    "stem": stem[:800],
                    "options": opts,
                    "answer": "",
                    "analysis": "选项可能不完整，待校对",
                    "score": 2,
                    "input_mode": "answerable",
                }
            )
        else:
            q_type = "fill" if ("____" in stem or "（　）" in stem or "( )" in stem) else "calc"
            if q_type == "calc" and len(stem) < 18:
                q_type = "fill"
            # 过短知识点短语不当题
            if len(stem) < 8:
                continue
            questions.append(
                {
                    "seq": seq,
                    "q_type": q_type,
                    "stem": stem[:800],
                    "options": None,
                    "answer": "",
                    "analysis": "",
                    "score": 5 if q_type == "calc" else 3,
                    "input_mode": "reveal_only",
                }
            )
        if len(questions) >= max_q:
            break

    questions.sort(key=lambda q: q["seq"])
    for i, q in enumerate(questions, 1):
        q["seq"] = i
    return questions


def text_looks_broken(text: str) -> bool:
    markers = (
        "1-16 暂无",
        "选择题部分无完整",
        "选项不详",
        "选择题暂无",
    )
    if any(m in text for m in markers):
        return True
    # 只有大题标题、几乎没有「1.」完整题
    numbered = len(re.findall(r"(?m)^\d{1,2}[\.、．]\s*\S{6,}", text))
    return numbered < 5


def quality_ok(subject: str, qs: list[dict], text: str | None) -> tuple[bool, str]:
    if not qs:
        return False, "解析结果为空"
    if text and text_looks_broken(text):
        return False, "源文本标记为残缺/暂无"
    full_choice = [
        q
        for q in qs
        if q["q_type"] == "choice" and q.get("options") and len(q["options"]) >= 4
    ]
    need = MIN_FULL_CHOICE.get(subject, 10)
    if len(full_choice) < need:
        return False, f"完整四选项选择题仅 {len(full_choice)} 道，门槛 {need}"
    return True, f"通过（完整选择 {len(full_choice)} / 总 {len(qs)}）"


def questions_for(subject: str, year: int) -> tuple[list[dict], str, bool]:
    """
    返回 (题目列表, 说明, 是否上架)。
    """
    curated = CURATED_BY_SUBJECT.get(subject)
    if curated is not None:
        qs = curated(year)
        return qs, "分年定稿", True

    folder = SUBJECT_FOLDER.get(subject)
    text = find_extract(folder, year) if folder else None
    if not text:
        return [], "无抽取文本", False

    # 英语：专用解析，保留阅读 A/B/C 原文与完形/语法篇章
    if subject == "英语":
        parsed = parse_english_paper(text)
        mats = sum(1 for q in parsed if q["q_type"] == "material")
        ch = sum(
            1
            for q in parsed
            if q["q_type"] == "choice" and q.get("options") and len(q["options"]) >= 4
        )
        if mats >= 3 and ch >= 15:
            return parsed, f"英语专用解析·材料{mats}·选择{ch}·共{len(parsed)}", True
        if text_looks_broken(text) or not parsed:
            return [], "英语卷残缺或解析失败（已清空）", False
        return [], f"英语未达门槛·材料{mats}·选择{ch}（已清空）", False

    parsed = parse_mcq_blocks(text, max_q=80)
    ok, reason = quality_ok(subject, parsed, text)
    if ok:
        return parsed, f"PDF解析·{reason}", True
    return [], f"未达上架门槛·{reason}（已清空，不灌占位题）", False


def sql_question_values(paper_id_expr: str, qs: list[dict]) -> str:
    rows = []
    for q in qs:
        opts = "NULL"
        if q.get("options"):
            arr = ",".join(f"'{esc(o)}'" for o in q["options"])
            opts = f"JSON_ARRAY({arr})"
        ans = f"'{esc(q['answer'])}'" if q.get("answer") else "NULL"
        ana = f"'{esc(q['analysis'])}'" if q.get("analysis") else "NULL"
        rows.append(
            f"({paper_id_expr},{q['seq']},'{q['q_type']}','{esc(q['stem'])}',{opts},{ans},{ana},{q['score']},'{q['input_mode']}')"
        )
    return ",\n".join(rows)


def main() -> None:
    papers: list[tuple[str, int]] = []
    for sub, years in SUBJECTS_YEARS.items():
        for y in years:
            papers.append((sub, y))

    lines = [
        "-- 广东专升本真题结构化题目（无水印卷面数据源）",
        "-- 由 gen_gd_paper_questions.py 生成；导入请用 UTF-8：docker cp + mysql --default-character-set=utf8mb4",
        "USE up_learn;",
        "SET NAMES utf8mb4;",
        "",
    ]
    report: list[str] = []

    for sub, year in papers:
        qs, note, publish = questions_for(sub, year)
        has_ans = 1 if any(q.get("answer") for q in qs) else 0
        pub = 1 if publish and qs else 0
        report.append(f"{sub}\t{year}\t题量={len(qs)}\tpublished={pub}\t{note}")

        lines.append(f"-- ===== 广东 {sub} {year} ({len(qs)} 题, published={pub}) · {note} =====")
        lines.append(
            f"SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='{esc(sub)}' AND year={year} AND deleted=0 LIMIT 1);"
        )
        lines.append("DELETE FROM paper_question WHERE paper_id=@pid;")
        if qs:
            lines.append(
                "INSERT INTO paper_question (paper_id, seq, q_type, stem, options_json, answer, analysis, score, input_mode) VALUES"
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
