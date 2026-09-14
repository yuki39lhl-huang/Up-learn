# -*- coding: utf-8 -*-
"""山东客观题答案覆盖（按 paper_no）。后续按科逐年补全。"""
from __future__ import annotations

# subject -> year -> {paper_no: answer}
SD_CHOICE_ANSWERS: dict[str, dict[int, dict[int, str]]] = {
    "英语": {},
    "计算机": {},
}


def answers_for(subject: str, year: int) -> dict[int, str] | None:
    by_year = SD_CHOICE_ANSWERS.get(subject)
    if not by_year:
        return None
    return by_year.get(year) or None
