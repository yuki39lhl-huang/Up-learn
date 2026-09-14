# -*- coding: utf-8 -*-
"""
选择题 / 可机判答案覆盖层。

按 (province, subject, year, paper_no) 写入 answer；仅覆盖已有题，不改题干。
来源：公开回忆版参考答案（人工整理），用于客观机判。
"""
from __future__ import annotations

from typing import Callable


def apply_choice_answers(
    province: str,
    subject: str,
    year: int,
    questions: list[dict],
    lookup: Callable[[str, str, int], dict[int, str] | None],
) -> tuple[list[dict], int]:
    """
    按 paper_no 覆盖 answer。
    返回 (题目列表, 覆盖条数)。
    """
    mapping = lookup(province, subject, year)
    if not mapping:
        return questions, 0
    hit = 0
    out: list[dict] = []
    for q in questions:
        row = dict(q)
        pn = row.get("paper_no")
        if pn is None:
            pn = row.get("seq")
        if pn is not None and int(pn) in mapping:
            ans = mapping[int(pn)].strip().upper()
            if ans:
                row["answer"] = ans
                hit += 1
        out.append(row)
    return out, hit
