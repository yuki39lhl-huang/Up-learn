# -*- coding: utf-8 -*-
"""
广东专升本「中文卷」通用结构解析（政治/管理/经济/教育/生理/语文等）。

相对 parse_mcq_blocks：
- 按大题（一、二、三…）分段识别题型，写入 section_title
- 保留 PDF 卷面题号为 paper_no（不再从 1 重排）
- 空大题（仅有标题无正文）按「共 N 小题」生成暂缺占位题
- 材料分析题保留「材料一/二/材料 1」为 material
"""
from __future__ import annotations

import re
from typing import Callable

PAGE_HDR = re.compile(r"(?m)^第\s*\d+\s*页[^\n]*\n?")
SECTION_SPLIT = re.compile(r"(?m)^([一二三四五六七八九十]+)[、．.]\s*(.+)$")
NUM_Q = re.compile(r"(?m)^(\d{1,2})[\.、．]\s*")
MATERIAL_MARK = re.compile(
    r"(?m)^材料\s*([一二三四五六七八九十]+|\d+)\s*[：:．.\s]*"
)

MISSING_STEM = "（本题在考生回忆版中暂缺）"
CN_NUM = {
    "一": 1,
    "二": 2,
    "三": 3,
    "四": 4,
    "五": 5,
    "六": 6,
    "七": 7,
    "八": 8,
    "九": 9,
    "十": 10,
}


def _clean(text: str) -> str:
    text = text.replace("\r", "\n")
    text = PAGE_HDR.sub("", text)
    lines = [ln.rstrip() for ln in text.split("\n")]
    out: list[str] = []
    blank = 0
    for ln in lines:
        if not ln.strip():
            blank += 1
            if blank <= 1:
                out.append("")
            continue
        blank = 0
        out.append(ln)
    return "\n".join(out).strip()


def _parse_options(body: str, letters: str = "ABCD") -> list[str]:
    opts: list[str] = []
    pat = (
        rf"(?:^|[\s\n])([{letters}])[.、．\)]\s*(.+?)(?=(?:\s+[{letters}][.、．\)])|"
        rf"\n[{letters}][.、．\)]|$)"
    )
    for m in re.finditer(pat, body, re.S):
        lab = m.group(1).upper()
        text = re.sub(r"\s+", " ", m.group(2)).strip(" ；;，,")
        if not text or any(o.startswith(f"{lab}.") for o in opts):
            continue
        opts.append(f"{lab}. {text}")
        if len(opts) >= len(letters):
            break
    order = {c: i for i, c in enumerate(letters)}
    opts.sort(key=lambda o: order.get(o[0], 99))
    return opts


def _stem_before_options(body: str) -> str:
    stem = re.split(r"(?:^|\n|\s)A[.、．\)]", body, maxsplit=1)[0].strip()
    return re.sub(r"\s+", " ", stem).strip()


def _section_kind(title: str) -> str:
    t = title.replace(" ", "")
    if "多项选择" in t or "多选题" in t:
        return "multi_choice"
    if "单项选择" in t or "单选题" in t or ("选择题" in t and "多选" not in t):
        return "single_choice"
    if "名词解释" in t:
        return "noun"
    if "辨析" in t:
        return "辨析"
    if "材料分析" in t or "案例分析" in t or "阅读题" in t:
        return "material_analysis"
    if "论述" in t:
        return "essay"
    if "简答" in t:
        return "short"
    if "作文" in t or "写作" in t:
        return "writing"
    if "计算" in t:
        return "calc"
    if "填空" in t:
        return "fill"
    if "判断" in t:
        return "judge"
    return "other"


def _split_sections(text: str) -> list[tuple[str, str, str, str]]:
    """[(kind, mark, title, body), ...] mark=一/二/三"""
    matches = list(SECTION_SPLIT.finditer(text))
    if not matches:
        return [("other", "", "全文", text)]
    sections: list[tuple[str, str, str, str]] = []
    for i, m in enumerate(matches):
        mark = m.group(1)
        title = m.group(2).strip()
        start = m.end()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        body = text[start:end].strip()
        sections.append((_section_kind(title), mark, title, body))
    return sections


def _section_label(mark: str, title: str) -> str:
    title = re.sub(r"\s+", " ", title).strip()
    if mark:
        return f"{mark}、{title}"
    return title


def _expected_count(title: str, kind: str) -> int:
    """从大题说明推断应有题量。"""
    m = re.search(r"共\s*([一二三四五六七八九十\d]+)\s*小题", title)
    if m:
        raw = m.group(1)
        if raw.isdigit():
            return int(raw)
        return CN_NUM.get(raw, 0)
    m = re.search(r"共\s*(\d+)\s*空", title)
    if m:
        return int(m.group(1))
    m = re.search(r"共\s*([一二三四五六七八九十\d]+)\s*题", title)
    if m:
        raw = m.group(1)
        if raw.isdigit():
            return int(raw)
        return CN_NUM.get(raw, 0)
    if kind in ("essay", "writing", "material_analysis", "辨析") and re.search(
        r"(本大题|本题)\s*\d+\s*分", title
    ):
        return 1
    return 0


def _q_type_for_kind(kind: str) -> str:
    if kind in ("single_choice", "multi_choice", "judge"):
        return "choice"
    if kind in ("fill", "noun"):
        return "fill"
    if kind == "calc":
        return "calc"
    return "essay"


def _iter_numbered(block: str) -> list[tuple[int, str]]:
    parts = re.split(r"(?m)(?=^\d{1,2}[\.、．]\s*)", block)
    out: list[tuple[int, str]] = []
    for part in parts:
        part = part.strip()
        if not part:
            continue
        m = re.match(r"^(\d{1,2})[\.、．]\s*([\s\S]+)$", part)
        if not m:
            continue
        seq = int(m.group(1))
        body = m.group(2).strip()
        body = re.split(r"(?m)^\d{1,2}[\.、．]\s*", body, maxsplit=1)[0].strip()
        out.append((seq, body))
    return out


def _body_is_empty(body: str, kind: str) -> bool:
    b = body.strip()
    if not b:
        return True
    # 大题说明残行 / 「暂无」
    compact = re.sub(r"\s+", "", b)
    if compact in ("要求）", "）", "暂无", "（暂无）", "选项暂缺", "材料暂缺", "（案例材料暂缺）"):
        return True
    if "暂无" in b and len(b) < 40 and not NUM_Q.search(b):
        return True
    if "材料暂缺" in b and len(b) < 80 and not NUM_Q.search(b):
        return True

    nums = _iter_numbered(b)
    if not nums and kind in (
        "single_choice",
        "multi_choice",
        "fill",
        "noun",
        "short",
        "essay",
        "judge",
        "other",
    ):
        # 仅有卷面切换语等
        if len(b) < 40:
            return True
    return False


def _material(title: str, body: str, section: str) -> dict:
    text = re.sub(r"\n{3,}", "\n\n", body.strip())
    return {
        "paper_no": None,
        "q_type": "material",
        "section_title": section,
        "stem": f"【{title}】\n\n{text}"[:6000],
        "options": None,
        "answer": "",
        "analysis": "",
        "score": 0,
        "input_mode": "reveal_only",
    }


def _choice(
    paper_no: int,
    stem: str,
    opts: list[str],
    score: int,
    section: str,
    multi: bool = False,
) -> dict:
    prefix = "（多选）" if multi else ""
    return {
        "paper_no": paper_no,
        "q_type": "choice",
        "section_title": section,
        "stem": (prefix + stem)[:1200],
        "options": opts,
        "answer": "",
        "analysis": "",
        "score": score,
        "input_mode": "answerable",
    }


def _subjective(paper_no: int | None, stem: str, score: int, section: str, q_type: str = "essay") -> dict:
    return {
        "paper_no": paper_no,
        "q_type": q_type,
        "section_title": section,
        "stem": stem[:2000],
        "options": None,
        "answer": "",
        "analysis": "",
        "score": score,
        "input_mode": "reveal_only",
    }


def _missing(paper_no: int, kind: str, score: int, section: str) -> dict:
    q_type = _q_type_for_kind(kind)
    return {
        "paper_no": paper_no,
        "q_type": q_type,
        "section_title": section,
        "stem": MISSING_STEM,
        "options": None,
        "answer": "",
        "analysis": "回忆版原卷该题暂缺",
        "score": score,
        "input_mode": "missing",
    }


def _score_from_title(title: str, default: int) -> int:
    m = re.search(r"每小题\s*(\d+)\s*分", title)
    if m:
        return int(m.group(1))
    m = re.search(r"每题\s*(\d+)\s*分", title)
    if m:
        return int(m.group(1))
    m = re.search(r"每空\s*(\d+)\s*分", title)
    if m:
        return int(m.group(1))
    m = re.search(r"(?:本大题|本题)\s*(\d+)\s*分", title)
    if m:
        return int(m.group(1))
    m = re.search(r"共\s*(\d+)\s*分", title)
    if m and "小题" not in title:
        return int(m.group(1))
    return default


def _push_sub_questions(
    title: str, q_text: str, section: str, push: Callable[[dict], None]
) -> None:
    per = _score_from_title(title, 8)
    numbered = _iter_numbered(q_text)
    for paper_no, qb in numbered:
        subs = list(re.finditer(r"[（(]\s*([1-9１-９])\s*[）)]\s*", qb))
        if len(subs) >= 2:
            for i, sm in enumerate(subs):
                start = sm.end()
                end = subs[i + 1].start() if i + 1 < len(subs) else len(qb)
                stem = re.sub(r"\s+", " ", qb[start:end]).strip()
                if len(stem) >= 4:
                    push(
                        _subjective(
                            paper_no if i == 0 else None,
                            f"（{sm.group(1)}）{stem}",
                            per,
                            section,
                            "essay",
                        )
                    )
            continue
        stem = re.sub(r"\s+", " ", qb).strip()
        split_m = re.search(r"[（(]\s*[1１]\s*[）)]", stem)
        if split_m and split_m.start() > 30:
            mat = stem[: split_m.start()].strip()
            if len(mat) >= 20 and "材料暂缺" not in mat:
                push(_material("案例材料", mat, section))
            rest = stem[split_m.start() :]
            for j, qm in enumerate(
                re.finditer(r"[（(]\s*([1-9１-９])\s*[）)]\s*([^（(]+)", rest)
            ):
                s = qm.group(2).strip()
                if len(s) >= 4:
                    push(
                        _subjective(
                            paper_no if j == 0 else None,
                            f"（{qm.group(1)}）{s}",
                            per,
                            section,
                            "essay",
                        )
                    )
            continue
        if len(stem) >= 4:
            push(_subjective(paper_no, stem, per, section, "essay"))
    if numbered:
        return
    for qm in re.finditer(r"[（(]\s*([1-9１-９])\s*[）)]\s*([^\n（(]+)", q_text):
        stem = qm.group(2).strip()
        if len(stem) >= 4:
            push(_subjective(None, f"（{qm.group(1)}）{stem}", per, section, "essay"))


def _parse_material_analysis(
    title: str, body: str, section: str, push: Callable[[dict], None]
) -> None:
    marks = list(MATERIAL_MARK.finditer(body))
    if not marks:
        q_part = body
        mat = ""
        m_read = re.search(
            r"(?:阅读(?:下列)?材料|根据(?:下列)?材料)[\s\S]*?(?=(?:请结合|结合材料|[（(]\s*[1１]|问))",
            body,
        )
        if m_read:
            mat = body[: m_read.end()].strip()
            q_part = body[m_read.end() :].strip()
        elif re.search(r"[（(]\s*[1１]\s*[）)]", body):
            split_m = re.search(r"[（(]\s*[1１]\s*[）)]", body)
            assert split_m
            before = body[: split_m.start()].strip()
            before = re.sub(r"^\d{1,2}[\.、．]\s*", "", before, count=1).strip()
            if len(before) >= 20 and "材料暂缺" not in before:
                mat = before
            q_part = body[split_m.start() :].strip()
        if len(mat) >= 20:
            push(_material("材料分析", mat, section))
        _push_sub_questions(title, q_part, section, push)
        return

    all_q = ""
    for i, m in enumerate(marks):
        label = m.group(1)
        start = m.end()
        end = marks[i + 1].start() if i + 1 < len(marks) else len(body)
        chunk = body[start:end].strip()
        split_m = re.search(
            r"(?m)^(?:\d{1,2}[\.、．]\s*)?(?:请结合材料|结合材料|根据材料|请结合)|"
            r"[（(]\s*[1１]\s*[）)]",
            chunk,
        )
        if split_m:
            mat_text = chunk[: split_m.start()].strip()
            all_q += "\n" + chunk[split_m.start() :].strip()
        else:
            mat_text = chunk
        mat_text = re.sub(r"(?m)^\d{1,2}[\.、．]\s*请结合.*$", "", mat_text).strip()
        if len(mat_text) >= 20:
            push(_material(f"材料{label}", mat_text, section))
    if not all_q.strip():
        after_last = body[marks[-1].start() :]
        split_m = re.search(
            r"(?m)^(?:\d{1,2}[\.、．]\s*)?(?:请结合材料|结合材料|根据材料)|[（(]\s*[1１]",
            after_last,
        )
        if split_m:
            all_q = after_last[split_m.start() :]
    _push_sub_questions(title, all_q, section, push)


def _parse_section_items(
    kind: str, title: str, body: str, section: str
) -> list[dict]:
    """解析单个大题正文（不含空大题占位）。"""
    items: list[dict] = []

    def push(q: dict) -> None:
        items.append(q)

    if kind in ("single_choice", "multi_choice"):
        multi = kind == "multi_choice"
        per = _score_from_title(title, 2 if multi else 1)
        for paper_no, chunk in _iter_numbered(body):
            opts = _parse_options(chunk)
            stem = _stem_before_options(chunk)
            if len(opts) >= 2 and stem:
                push(_choice(paper_no, stem, opts[:4] if not multi else opts[:6], per, section, multi))
            elif len(opts) >= 4:
                push(_choice(paper_no, stem or f"第 {paper_no} 题", opts[:4], per, section, multi))
    elif kind == "noun":
        per = _score_from_title(title, 3)
        for paper_no, chunk in _iter_numbered(body):
            stem = re.sub(r"\s+", " ", chunk).strip()
            if len(stem) >= 2:
                push(_subjective(paper_no, f"名词解释：{stem}", per, section, "fill"))
    elif kind == "material_analysis":
        _parse_material_analysis(title, body, section, push)
    elif kind in ("辨析", "short", "essay", "writing", "calc", "fill", "judge", "other"):
        per = _score_from_title(title, 7 if kind in ("辨析", "short", "essay") else 5)
        q_type = "fill" if kind in ("fill", "noun") else ("calc" if kind == "calc" else "essay")
        if kind == "judge":
            q_type = "choice"
        for paper_no, chunk in _iter_numbered(body):
            stem = re.sub(r"\s+", " ", chunk).strip()
            if len(stem) >= 4:
                if kind == "judge":
                    push(_choice(paper_no, stem, ["A. 正确", "B. 错误"], per, section))
                else:
                    push(_subjective(paper_no, stem, per, section, q_type))
        if not _iter_numbered(body) and len(body.strip()) >= 10 and not _body_is_empty(body, kind):
            stem = re.sub(r"\s+", " ", body).strip()
            if not stem.startswith("阅读") or len(stem) > 30:
                push(_subjective(None, stem[:2000], per, section, q_type))
    return items


def _assign_missing_ranges(
    section_metas: list[dict],
) -> None:
    """
    为空大题分配卷面题号区间。
    section_metas 项: {empty, expected, items, kind, section, per, first_real, ...}
    """
    n = len(section_metas)
    i = 0
    while i < n:
        meta = section_metas[i]
        if not meta["empty"]:
            i += 1
            continue
        # 连续空大题块
        j = i
        while j < n and section_metas[j]["empty"]:
            j += 1
        block = section_metas[i:j]
        # 下一块首个真实题号
        next_no = None
        for k in range(j, n):
            nos = [
                it["paper_no"]
                for it in section_metas[k]["items"]
                if it.get("paper_no") is not None
            ]
            if nos:
                next_no = min(nos)
                break
        # 上一块末题号
        prev_no = 0
        for k in range(i - 1, -1, -1):
            nos = [
                it["paper_no"]
                for it in section_metas[k]["items"]
                if it.get("paper_no") is not None
            ]
            if nos:
                prev_no = max(nos)
                break
        expected_sum = sum(max(1, m["expected"]) if m["expected"] else 0 for m in block)
        if next_no is not None and expected_sum > 0 and prev_no + expected_sum + 1 == next_no:
            cursor = prev_no + 1
            for m in block:
                cnt = m["expected"] or 0
                m["missing_nos"] = list(range(cursor, cursor + cnt))
                cursor += cnt
        elif next_no is not None and prev_no + 1 < next_no:
            # 用空隙按 expected 比例切分；expected 为 0 则整段空隙给第一空大题
            gap = list(range(prev_no + 1, next_no))
            if expected_sum > 0 and expected_sum <= len(gap):
                cursor = 0
                for m in block:
                    cnt = m["expected"] or 0
                    m["missing_nos"] = gap[cursor : cursor + cnt]
                    cursor += cnt
            elif len(block) == 1:
                block[0]["missing_nos"] = gap
            else:
                # 均分空隙
                chunk = max(1, len(gap) // len(block))
                cursor = 0
                for bi, m in enumerate(block):
                    if bi == len(block) - 1:
                        m["missing_nos"] = gap[cursor:]
                    else:
                        m["missing_nos"] = gap[cursor : cursor + chunk]
                        cursor += chunk
        else:
            # 无法推断空隙：按 expected 从 prev+1 起造号
            cursor = prev_no + 1
            for m in block:
                cnt = m["expected"] or (1 if m["kind"] != "other" else 0)
                m["missing_nos"] = list(range(cursor, cursor + cnt)) if cnt else []
                cursor += cnt
        i = j


def parse_gd_chinese_paper(text: str) -> list[dict]:
    text = _clean(text)
    if not text or len(text) < 80:
        return []

    raw_sections = _split_sections(text)
    metas: list[dict] = []
    for kind, mark, title, body in raw_sections:
        section = _section_label(mark, title)
        empty = _body_is_empty(body, kind)
        expected = _expected_count(title, kind)
        items = [] if empty else _parse_section_items(kind, title, body, section)
        # 大题有标题但正文解析为空 → 仍当空大题
        if not empty and not items and expected > 0 and kind != "material_analysis":
            empty = True
        per = _score_from_title(title, 1 if kind in ("single_choice", "fill", "judge") else 3)
        metas.append(
            {
                "kind": kind,
                "title": title,
                "section": section,
                "empty": empty,
                "expected": expected,
                "items": items,
                "per": per,
                "missing_nos": [],
            }
        )

    _assign_missing_ranges(metas)

    # 生成占位
    for m in metas:
        if not m["empty"]:
            continue
        for no in m["missing_nos"]:
            m["items"].append(_missing(no, m["kind"], m["per"], m["section"]))

    # 展平：按卷面顺序；同大题内材料在前，再按 paper_no
    flat: list[dict] = []
    for m in metas:
        mats = [q for q in m["items"] if q["q_type"] == "material"]
        rest = [q for q in m["items"] if q["q_type"] != "material"]
        rest.sort(key=lambda q: (q.get("paper_no") is None, q.get("paper_no") or 10**9))
        flat.extend(mats)
        flat.extend(rest)

    # seq = 入库排序号（唯一）；paper_no = 卷面题号
    out: list[dict] = []
    for i, q in enumerate(flat, start=1):
        row = dict(q)
        row["seq"] = i
        if "paper_no" not in row:
            row["paper_no"] = None
        if "section_title" not in row:
            row["section_title"] = None
        out.append(row)
    return out


def quality_chinese_paper(qs: list[dict], min_choice: int = 8) -> tuple[bool, str]:
    if not qs:
        return False, "解析为空"
    real = [q for q in qs if q.get("input_mode") != "missing"]
    choices = [
        q
        for q in real
        if q["q_type"] == "choice" and q.get("options") and len(q["options"]) >= 4
    ]
    mats = sum(1 for q in real if q["q_type"] == "material")
    subj = sum(1 for q in real if q["q_type"] in ("fill", "essay", "calc"))
    missing = sum(1 for q in qs if q.get("input_mode") == "missing")
    if len(choices) >= min_choice:
        return True, f"选择{len(choices)}·材料{mats}·主观{subj}·暂缺{missing}·共{len(qs)}"
    if mats >= 1 and subj >= 4 and len(real) >= 8:
        return True, f"无完整选择但主观可用·材料{mats}·主观{subj}·暂缺{missing}·共{len(qs)}"
    if subj >= 8 and len(real) >= 8:
        return True, f"主观题为主·主观{subj}·暂缺{missing}·共{len(qs)}"
    # 有暂缺占位 + 足够真实题，也允许上架（对标残卷）
    if missing >= 1 and len(real) >= 6:
        return True, f"残卷占位·真实{len(real)}·暂缺{missing}·共{len(qs)}"
    return False, f"未达门槛·选择{len(choices)}·材料{mats}·主观{subj}·暂缺{missing}"
