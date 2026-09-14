# -*- coding: utf-8 -*-
"""直接把选择题答案 UPDATE 进库（不必整卷重导）。"""
from __future__ import annotations

import subprocess
from pathlib import Path

from gd_english_choice_answers import GD_ENGLISH_ANSWERS
from gd_politics_choice_answers import GD_POLITICS_ANSWERS

MYSQL = r"D:\development\mysql-9.3.0-winx64\bin\mysql.exe"
OUT = Path(__file__).resolve().parent / "migrate_paper_choice_answers.sql"


def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "''")


def append_subject(lines: list[str], province: str, subject: str, by_year: dict[int, dict[int, str]]) -> None:
    for year, mapping in sorted(by_year.items()):
        lines.append(f"-- {province} {subject} {year}")
        lines.append(
            "SET @pid := (SELECT id FROM paper WHERE province='"
            + esc(province)
            + "' AND subject='"
            + esc(subject)
            + f"' AND year={year} AND deleted=0 LIMIT 1);"
        )
        for paper_no, ans in sorted(mapping.items()):
            lines.append(
                "UPDATE paper_question SET answer='"
                + esc(ans)
                + f"' WHERE paper_id=@pid AND paper_no={paper_no} AND deleted=0;"
            )
        lines.append(
            "UPDATE paper SET has_answer=1 WHERE id=@pid AND EXISTS ("
            "SELECT 1 FROM paper_question q WHERE q.paper_id=@pid AND q.answer IS NOT NULL AND q.answer<>''"
            ");"
        )
        lines.append("")


def main() -> None:
    lines = [
        "-- 客观题答案覆盖（广东英语 / 政治理论等）",
        "USE up_learn;",
        "SET NAMES utf8mb4;",
        "",
    ]
    append_subject(lines, "广东", "英语", GD_ENGLISH_ANSWERS)
    append_subject(lines, "广东", "政治理论", GD_POLITICS_ANSWERS)

    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("wrote", OUT)

    sql = OUT.read_text(encoding="utf-8")
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
    print(r.stdout.decode("utf-8", "replace"))
    print(r.stderr.decode("utf-8", "replace")[:400])
    print("exit", r.returncode)


if __name__ == "__main__":
    main()
