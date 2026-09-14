# -*- coding: utf-8 -*-
"""广东《政治理论》客观题答案（按卷面 paper_no）。公开回忆版整理。"""
from __future__ import annotations

# 多选答案存规范串如 ABD
GD_POLITICS_ANSWERS: dict[int, dict[int, str]] = {
    2024: {
        1: "B",
        2: "C",
        3: "A",
        4: "B",
        5: "C",
        6: "B",
        7: "A",
        8: "C",
        9: "D",
        10: "A",
        11: "A",
        12: "C",
        13: "B",
        14: "B",
        15: "B",
        16: "D",
        17: "A",
        18: "B",
        # 库内 19=党建基础性建设，20=对外工作出发点（与部分网页题序对调）
        19: "B",
        20: "A",
    },
}


def answers_for(year: int) -> dict[int, str] | None:
    return GD_POLITICS_ANSWERS.get(year)
