# -*- coding: utf-8 -*-
"""
从 shijuan/**/*.md 解析历年答案，按卷面题序写入 paper_question.answer / analysis。

映射规则：
  取该卷 paper_no 非空且非 material、非 missing 的题目，按 paper_no 排序，
  与答案 md 中该年的题号 1..N 按序一一对应。

用法（仓库根目录）:
  python sql/phase1/import_answers_from_md.py
  python sql/phase1/import_answers_from_md.py --dry-run
"""
from __future__ import annotations

import argparse
import re
import subprocess
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SHIJUAN = ROOT / "shijuan"
MYSQL = r"D:\development\mysql-9.3.0-winx64\bin\mysql.exe"
OUT_SQL = Path(__file__).resolve().parent / "migrate_answers_from_md.sql"
REPORT = Path(__file__).resolve().parent / "_answer_import_report.txt"

# 文件夹名 → (省, 库内 subject)
FOLDER_SUBJECT: dict[str, tuple[str, str]] = {
    # 广东
    "英语": ("广东", "英语"),
    "政治理论": ("广东", "政治理论"),
    "语文": ("广东", "大学语文"),
    "生理学": ("广东", "生理学"),
    "经济学": ("广东", "经济学"),
    "教育理论": ("广东", "教育理论"),
    "管理学": ("广东", "管理学"),
    "高数": ("广东", "高等数学"),
    # 山东
    "政治": ("山东", "政治"),
    "计算机": ("山东", "计算机"),
    "高数一": ("山东", "高等数学I"),
    "高数二": ("山东", "高等数学II"),
    "高数三": ("山东", "高等数学III"),
}

# 山东英语/语文文件夹名与广东「英语」「语文」冲突，按父目录区分
SD_FOLDER_SUBJECT: dict[str, tuple[str, str]] = {
    "英语": ("山东", "英语"),
    "语文": ("山东", "大学语文"),
    "政治": ("山东", "政治"),
    "计算机": ("山东", "计算机"),
    "高数一": ("山东", "高等数学I"),
    "高数二": ("山东", "高等数学II"),
    "高数三": ("山东", "高等数学III"),
}

# 更稳：用「# 202X年」切开
YEAR_HEADER = re.compile(r"(?m)^#\s*(20\d{2})\s*年")

# 题号行：**1. ...** / **1.** / ## 1. / ### 1.
Q_HEADER = re.compile(
    r"(?m)^(?:\*\*|#{2,4}\s*)(?P<no>\d{1,2})(?:[\.、．\)]|\*\*)\s*"
)

# 表格 | 1 | A |
TABLE_ANS = re.compile(
    r"(?m)^\|\s*(?P<no>\d{1,2})\s*\|\s*(?P<ans>[A-Ea-e]{1,5})\s*\|"
)


def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "''")


def normalize_choice_ans(raw: str) -> str:
    s = (raw or "").strip().strip("*").strip()
    if not s:
        return ""
    letter_m = re.match(r"^([A-Ja-j]{1,5})\b", s)
    if letter_m:
        letters = letter_m.group(1).upper()
        seen: list[str] = []
        for ch in letters:
            if ch not in seen:
                seen.append(ch)
        if all(c <= "E" for c in seen):
            return "".join(sorted(seen))
        return "".join(seen)
    boxed = re.search(r"\\boxed\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}", s)
    if boxed:
        s = boxed.group(1).strip()
    s = re.sub(r"\s+", " ", s).strip()
    return s[:800]


def extract_answer_from_block(block: str) -> tuple[str, str]:
    """从单题块提取 (answer, analysis)。"""
    m = re.search(r"答案[：:]\s*", block)
    if not m:
        return "", ""
    rest = block[m.end() :]
    rest = re.sub(r"^\*+\s*", "", rest)

    ana = ""
    ana_m = re.search(r"(?:\*\*)?解析[：:]\*?\*?\s*", rest)
    body = rest
    if ana_m:
        body = rest[: ana_m.start()]
        ana = re.sub(r"\s+", " ", rest[ana_m.end() :]).strip()[:800]
        ana = re.sub(r"\*+", "", ana).strip()

    body = body.strip()
    # **A（xxx）** 或 **文字答案**
    one = re.match(r"\*\*(.+?)\*\*", body, re.S)
    if one:
        body = one.group(1).strip()
    else:
        body = body.strip("*").strip()

    letter = re.match(r"^([A-Ja-j]{1,5})\b", body)
    if letter:
        return normalize_choice_ans(letter.group(1)), ana

    # 多行 latex / 文本：优先 boxed
    boxed = re.search(r"\\boxed\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}", rest)
    if boxed:
        return normalize_choice_ans(boxed.group(1)), ana

    text = re.split(r"\n\s*\n", body, maxsplit=1)[0]
    text = re.sub(r"\*+", "", text).strip()
    if not text:
        # 答案行后直接跟公式行
        latex_line = re.search(r"(\\?[(\[].+|\$\$.+\$\$|\\frac.+)", rest)
        if latex_line:
            return normalize_choice_ans(latex_line.group(1)), ana
        return "", ana
    return normalize_choice_ans(text), ana


def parse_answers_in_chunk(chunk: str) -> dict[int, tuple[str, str]]:
    """exam_no -> (answer, analysis)。"""
    found: dict[int, tuple[str, str]] = {}

    for m in TABLE_ANS.finditer(chunk):
        no = int(m.group("no"))
        found[no] = (normalize_choice_ans(m.group("ans")), "")

    headers = list(Q_HEADER.finditer(chunk))
    for i, h in enumerate(headers):
        no = int(h.group("no"))
        start = h.start()
        end = headers[i + 1].start() if i + 1 < len(headers) else len(chunk)
        block = chunk[start:end]
        ans, ana = extract_answer_from_block(block)
        if not ans:
            continue
        if ans in {"原上传资料未提供。", "因此不虚构题干、选项和答案。"}:
            continue
        if ans in {"暂缺", "略", "无"}:
            continue
        prev = found.get(no)
        if (
            prev
            and prev[0]
            and re.fullmatch(r"[A-E]{1,5}", prev[0])
            and not re.fullmatch(r"[A-J]{1,5}", ans)
        ):
            # 表格/字母答案优先于后续长文本误匹配
            found[no] = (prev[0], ana or prev[1])
        else:
            found[no] = (ans, ana or (prev[1] if prev else ""))
    return found


def resolve_subject(md_path: Path) -> tuple[str, str] | None:
    parts = md_path.relative_to(SHIJUAN).parts
    if len(parts) < 2:
        return None
    prov_dir, folder = parts[0], parts[1]
    if "山东" in prov_dir:
        return SD_FOLDER_SUBJECT.get(folder)
    if "广东" in prov_dir:
        # 广东「英语」「语文」用 FOLDER_SUBJECT
        return FOLDER_SUBJECT.get(folder)
    return None


def split_by_year(text: str) -> dict[int, str]:
    """返回 year -> 该年正文。"""
    matches = list(YEAR_HEADER.finditer(text))
    if not matches:
        # 单年文件：从文件名或首行猜
        m = re.search(r"(20\d{2})", text[:200])
        if m:
            return {int(m.group(1)): text}
        return {}
    out: dict[int, str] = {}
    for i, m in enumerate(matches):
        year = int(m.group(1))
        start = m.start()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        # 同年多次出现则合并（少见）
        chunk = text[start:end]
        if year in out:
            out[year] += "\n" + chunk
        else:
            out[year] = chunk
    return out


def mysql_query(sql: str) -> str:
    r = subprocess.run(
        [
            MYSQL,
            "--host=127.0.0.1",
            "--port=3308",
            "--user=root",
            "--password=1234",
            "--database=up_learn",
            "--default-character-set=utf8mb4",
            "-N",
            "-B",
            "-e",
            sql,
        ],
        capture_output=True,
    )
    if r.returncode != 0:
        raise RuntimeError(r.stderr.decode("utf-8", "replace"))
    return r.stdout.decode("utf-8", "replace")


def load_paper_questions(province: str, subject: str, year: int) -> tuple[list[tuple[int, int, str]], bool]:
    """返回 ([(id, paper_no, q_type), ...], has_material)。"""
    sql = (
        "SELECT q.id, IFNULL(q.paper_no,0), q.q_type FROM paper p "
        "JOIN paper_question q ON q.paper_id=p.id "
        f"WHERE p.province='{esc(province)}' AND p.subject='{esc(subject)}' "
        f"AND p.year={year} AND p.deleted=0 AND q.deleted=0 "
        "ORDER BY q.seq"
    )
    rows_all = []
    for line in mysql_query(sql).splitlines():
        if not line.strip():
            continue
        parts = line.split("\t")
        rows_all.append((int(parts[0]), int(parts[1]), parts[2]))
    has_material = any(t == "material" for _, _, t in rows_all)
    rows = [
        (qid, pn, qt)
        for qid, pn, qt in rows_all
        if pn > 0 and qt != "material" and qt != "missing"
    ]
    # 再滤 missing input：上面用了 q_type；补查 input_mode
    sql2 = (
        "SELECT q.id FROM paper p JOIN paper_question q ON q.paper_id=p.id "
        f"WHERE p.province='{esc(province)}' AND p.subject='{esc(subject)}' "
        f"AND p.year={year} AND p.deleted=0 AND q.deleted=0 AND q.input_mode='missing'"
    )
    missing_ids = set()
    for line in mysql_query(sql2).splitlines():
        if line.strip():
            missing_ids.add(int(line.strip()))
    rows = [(qid, pn, qt) for qid, pn, qt in rows if qid not in missing_ids]
    rows.sort(key=lambda x: (x[1], x[0]))
    return rows, has_material


def collect_md_files() -> list[Path]:
    return sorted(SHIJUAN.rglob("*.md"))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    updates: list[tuple[int, str, str, str, str, int, int]] = []
    # (qid, answer, analysis, province, subject, year, exam_no)
    papers_touched: set[tuple[str, str, int]] = set()
    report: list[str] = []

    for md in collect_md_files():
        subj = resolve_subject(md)
        if not subj:
            report.append(f"SKIP 未映射科目 {md.relative_to(SHIJUAN)}")
            continue
        province, subject = subj
        text = md.read_text(encoding="utf-8", errors="replace")
        by_year = split_by_year(text)
        if not by_year:
            report.append(f"SKIP 无年份切分 {md.name}")
            continue
        for year, chunk in sorted(by_year.items()):
            answers = parse_answers_in_chunk(chunk)
            if not answers:
                report.append(f"WARN {province}/{subject}/{year} 未解析到答案 ({md.name})")
                continue
            try:
                qs, has_material = load_paper_questions(province, subject, year)
            except Exception as e:
                report.append(f"ERR 查库 {province}/{subject}/{year}: {e}")
                continue
            if not qs:
                report.append(f"WARN 库无题 {province}/{subject}/{year} 答案{len(answers)}题")
                continue

            papers_touched.add((province, subject, year))
            qs_by_no = {paper_no: (qid, paper_no, q_type) for qid, paper_no, q_type in qs}
            by_no_hits = [n for n in answers if n in qs_by_no]
            # 英语等：卷面题号从 1 起，但库内 paper_no 因材料题从 2 起 → 必须按序
            force_seq = bool(
                has_material
                and answers
                and qs
                and min(answers.keys()) == 1
                and qs[0][1] > 1
            )
            use_paper_no = (not force_seq) and len(by_no_hits) >= max(
                3, int(len(answers) * 0.45)
            )

            hit = 0
            if use_paper_no:
                for exam_no in sorted(answers.keys()):
                    row = qs_by_no.get(exam_no)
                    if not row:
                        continue
                    qid, paper_no, q_type = row
                    ans, ana = answers[exam_no]
                    updates.append((qid, ans, ana, province, subject, year, exam_no))
                    hit += 1
                mode = "按paper_no"
            else:
                for exam_no in sorted(answers.keys()):
                    idx = exam_no - 1
                    if idx < 0 or idx >= len(qs):
                        continue
                    qid, paper_no, q_type = qs[idx]
                    ans, ana = answers[exam_no]
                    updates.append((qid, ans, ana, province, subject, year, exam_no))
                    hit += 1
                mode = "按序" + ("·材料错位" if force_seq else ("·有材料" if has_material else ""))
            report.append(
                f"OK {province}/{subject}/{year} md答案={len(answers)} 库题={len(qs)} "
                f"写入={hit}({mode}) ← {md.name}"
            )

    # 生成 SQL
    lines = [
        "-- 从 shijuan 答案 md 导入（先清空本卷旧答案，避免错位残留）",
        "USE up_learn;",
        "SET NAMES utf8mb4;",
        "",
    ]
    for prov, sub, year in sorted(papers_touched):
        lines.append(
            "UPDATE paper_question q "
            "JOIN paper p ON p.id=q.paper_id "
            "SET q.answer=NULL, q.analysis=NULL "
            f"WHERE p.province='{esc(prov)}' AND p.subject='{esc(sub)}' "
            f"AND p.year={year} AND p.deleted=0 AND q.deleted=0;"
        )
    lines.append("")

    # 按 qid 去重（后写覆盖）
    by_qid: dict[int, tuple[str, str]] = {}
    meta: dict[int, tuple[str, str, int, int]] = {}
    for qid, ans, ana, prov, sub, year, exam_no in updates:
        by_qid[qid] = (ans, ana)
        meta[qid] = (prov, sub, year, exam_no)

    for qid, (ans, ana) in sorted(by_qid.items()):
        if ana:
            lines.append(
                f"UPDATE paper_question SET answer='{esc(ans)}', analysis='{esc(ana)}' "
                f"WHERE id={qid} AND deleted=0;"
            )
        else:
            lines.append(
                f"UPDATE paper_question SET answer='{esc(ans)}' "
                f"WHERE id={qid} AND deleted=0;"
            )

    # 刷新 has_answer
    papers = {(meta[q][0], meta[q][1], meta[q][2]) for q in by_qid}
    for prov, sub, year in sorted(papers):
        lines.append(
            "UPDATE paper p SET has_answer=1 WHERE p.province='"
            + esc(prov)
            + "' AND p.subject='"
            + esc(sub)
            + f"' AND p.year={year} AND p.deleted=0 "
            "AND EXISTS (SELECT 1 FROM paper_question q WHERE q.paper_id=p.id "
            "AND q.answer IS NOT NULL AND q.answer<>'' AND q.deleted=0);"
        )

    OUT_SQL.write_text("\n".join(lines) + "\n", encoding="utf-8")
    REPORT.write_text("\n".join(report) + "\n", encoding="utf-8")
    print("report ->", REPORT)
    print("sql    ->", OUT_SQL, "updates", len(by_qid))
    for line in report:
        print(line)

    if args.dry_run:
        print("dry-run，未执行 SQL")
        return

    sql = OUT_SQL.read_text(encoding="utf-8")
    r = subprocess.run(
        [
            MYSQL,
            "--host=127.0.0.1",
            "--port=3308",
            "--user=root",
            "--password=1234",
            "--database=up_learn",
            "--default-character-set=utf8mb4",
        ],
        input=sql.encode("utf-8"),
        capture_output=True,
    )
    print(r.stderr.decode("utf-8", "replace")[:400])
    print("mysql exit", r.returncode)


if __name__ == "__main__":
    main()
