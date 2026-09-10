# -*- coding: utf-8 -*-
"""
山东专升本《大学英语》回忆版 PDF 抽取文本 → 结构化题目。

结构（常见）：
  Part Ⅰ Cloze（选词填空 A-J）
  Part Ⅱ Reading Section A（三篇阅读） / Section B（七选五）
  Part Ⅲ Translation / Part Ⅳ Writing
"""
from __future__ import annotations

import re

PAGE_HDR = re.compile(r"(?m)^第\s*\d+\s*页[^\n]*\n?")
MISSING_RANGE = re.compile(
    r"(?m)^(\d{1,2})\s*[-–—~至到]\s*(\d{1,2})\s*暂无"
)
MISSING_STEM = "（本题在考生回忆版中暂缺）"


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


def _material(stem: str, section: str) -> dict:
    return {
        "paper_no": None,
        "q_type": "material",
        "section_title": section,
        "stem": stem[:6000],
        "options": None,
        "answer": "",
        "analysis": "",
        "score": 0,
        "input_mode": "reveal_only",
    }


def _choice(paper_no: int, stem: str, opts: list[str], score: float, section: str) -> dict:
    return {
        "paper_no": paper_no,
        "q_type": "choice",
        "section_title": section,
        "stem": (stem or f"第 {paper_no} 题")[:1200],
        "options": opts,
        "answer": "",
        "analysis": "",
        "score": int(score) if float(score).is_integer() else round(score),
        "input_mode": "answerable",
    }


def _essay(paper_no: int, stem: str, score: int, section: str) -> dict:
    return {
        "paper_no": paper_no,
        "q_type": "essay",
        "section_title": section,
        "stem": stem[:2000],
        "options": None,
        "answer": "",
        "analysis": "",
        "score": score,
        "input_mode": "reveal_only",
    }


def _missing(paper_no: int, score: int, section: str, q_type: str = "choice") -> dict:
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


def _word_bank(text: str) -> list[str]:
    """解析 A.word B.word … / 同行词库。"""
    # 优先抓整段词库行
    m = re.search(
        r"(?m)^((?:[A-J]\.[^\n]+(?:\s+[A-J]\.[^\n]+)*)+)$",
        text,
    )
    blob = ""
    if m:
        blob = m.group(1)
    else:
        # 多行 A-J
        lines = []
        for ln in text.splitlines():
            if re.match(r"^[A-J]\.", ln.strip()):
                lines.append(ln.strip())
            elif lines and re.search(r"[A-J]\.", ln):
                lines.append(ln.strip())
        blob = " ".join(lines)
    if not blob:
        # 宽松：全文找 A.xxx B.xxx 连续段
        m2 = re.search(r"([A-J]\.\s*\S+(?:\s+[A-J]\.\s*\S+){5,})", text)
        if m2:
            blob = m2.group(1)
    return _parse_options(blob, letters="ABCDEFGHIJ")


def _slice_after(text: str, pattern: str) -> str:
    m = re.search(pattern, text, re.I)
    return text[m.end() :] if m else text


def _between(text: str, start_pat: str, end_pat: str | None) -> str:
    m = re.search(start_pat, text, re.I | re.S)
    if not m:
        return ""
    rest = text[m.start() :]
    if not end_pat:
        return rest
    m2 = re.search(end_pat, rest[len(m.group(0)) :], re.I | re.S)
    if not m2:
        return rest
    return rest[: len(m.group(0)) + m2.start()]


def _numbered_choices(block: str, lo: int, hi: int, score: float, section: str, letters: str = "ABCD") -> list[dict]:
    qs: list[dict] = []
    parts = re.split(r"(?m)(?=^\d{1,2}\.\s*)", block)
    for part in parts:
        m = re.match(r"^(\d{1,2})\.\s*([\s\S]+)$", part.strip())
        if not m:
            continue
        seq = int(m.group(1))
        if seq < lo or seq > hi:
            continue
        body = re.split(r"(?m)^\d{1,2}\.\s*", m.group(2).strip(), maxsplit=1)[0].strip()
        if "暂无" in body and len(body) < 20:
            qs.append(_missing(seq, int(score), section))
            continue
        opts = _parse_options(body, letters=letters)
        stem = _stem_before_options(body)
        if len(opts) < 2:
            continue
        qs.append(_choice(seq, stem, opts[: len(letters)], score, section))
    return qs


def _add_missing_ranges(text: str, section: str, score: int, items: list[dict]) -> None:
    have = {q["paper_no"] for q in items if q.get("paper_no") is not None}
    for m in MISSING_RANGE.finditer(text):
        a, b = int(m.group(1)), int(m.group(2))
        for n in range(a, b + 1):
            if n not in have:
                items.append(_missing(n, score, section))
                have.add(n)


def parse_english_sd_paper(text: str) -> list[dict]:
    text = _clean(text)
    if not text or len(text) < 80:
        return []

    items: list[dict] = []

    # —— Cloze ——
    cloze_sec = "Part Ⅰ Cloze（选词填空）"
    cloze = _between(
        text,
        r"Part\s+[ⅠI]\s+Cloze",
        r"Part\s+[ⅡII]+\s+Reading|Part\s+II\s+Reading",
    )
    if cloze:
        bank = _word_bank(cloze)
        # 去掉 Directions 后作为材料
        body = re.sub(r"(?is)^Part\s+[ⅠI]\s+Cloze.*?(?=A\.|[A-Z][a-z]{2,})", "", cloze, count=1).strip()
        # 材料：词库 + 篇章（去掉词库行也可保留在材料里）
        mat = body
        if bank:
            bank_line = " ".join(bank)
            mat = f"【Word Bank】\n{bank_line}\n\n{body}"
        if len(mat) >= 40:
            items.append(_material(mat[:5000], cloze_sec))
        if bank and len(bank) >= 8:
            for n in range(1, 11):
                items.append(_choice(n, f"Cloze 第 {n} 空", bank, 2, cloze_sec))
        else:
            # 无词库时仍占位
            for n in range(1, 11):
                if f"__{n}__" in cloze or f"_{n}_" in cloze:
                    items.append(_missing(n, 2, cloze_sec) if "暂无" in cloze else _choice(n, f"Cloze 第 {n} 空", bank or [], 2, cloze_sec))

    # —— Reading Section A ——
    read_a_sec = "Part Ⅱ Reading Comprehension · Section A"
    read_a = _between(
        text,
        r"Section\s+A[（(].*?2\s*points|Section\s+A（2 points",
        r"Section\s+B[（(].*?3\s*points|Section\s+B（3 points|第二部分|Part\s+[ⅢIII]",
    )
    if not read_a:
        read_a = _between(text, r"Section\s+A（2 points each", r"Section\s+B")
    if read_a:
        _add_missing_ranges(read_a, read_a_sec, 2, items)
        # Passage One/Two/Three
        passages = list(re.finditer(r"(?m)^Passage\s+(One|Two|Three|1|2|3)\b", read_a))
        for i, pm in enumerate(passages):
            start = pm.start()
            end = passages[i + 1].start() if i + 1 < len(passages) else len(read_a)
            chunk = read_a[start:end].strip()
            # 材料到第一道题号前
            qm = re.search(r"(?m)^\d{1,2}\.\s*", chunk)
            if qm and qm.start() > 40:
                items.append(_material(chunk[: qm.start()].strip(), read_a_sec))
                items.extend(_numbered_choices(chunk[qm.start() :], 11, 25, 2, read_a_sec))
            else:
                # 整段材料（暂无题）
                if "暂无" not in chunk[:80]:
                    items.append(_material(chunk[:3000], read_a_sec))
        # 若无 Passage 标题但有题号
        if not passages:
            items.extend(_numbered_choices(read_a, 11, 25, 2, read_a_sec))

    # —— Reading Section B 七选五 ——
    read_b_sec = "Part Ⅱ Reading Comprehension · Section B"
    read_b = _between(
        text,
        r"Section\s+B[（(].*?3\s*points|Section\s+B（3 points",
        r"第二部分|Part\s+[ⅢIII]|Part\s+III",
    )
    if read_b:
        _add_missing_ranges(read_b, read_b_sec, 3, items)
        # 选项 A-G 段 + 篇章
        opts = _parse_options(read_b, letters="ABCDEFG")
        # 材料
        mat_end = re.search(r"(?m)^\d{1,2}\.\s*", read_b)
        mat_text = read_b[: mat_end.start()].strip() if mat_end else read_b
        # 去掉过长 Directions 保留篇章与选项
        mat_text = re.sub(r"(?is)^Section\s+B.*?center\.", "", mat_text, count=1).strip()
        if len(mat_text) >= 40:
            items.append(_material(mat_text[:4000], read_b_sec))
        if opts and len(opts) >= 5:
            for n in range(26, 31):
                if any(q.get("paper_no") == n for q in items):
                    continue
                if MISSING_RANGE.search(read_b) and "26" in read_b and "暂无" in read_b:
                    continue
                items.append(_choice(n, f"七选五 第 {n} 题", opts, 3, read_b_sec))
        items.extend(_numbered_choices(read_b, 26, 30, 3, read_b_sec, letters="ABCDEFG"))

    # —— Translation / Writing ——
    trans_sec = "Part Ⅲ Translation"
    for m in re.finditer(r"(?m)^((?:3[1-3]))\.\s*", text):
        seq = int(m.group(1))
        start = m.end()
        # 下一题或 PartⅣ / 文末
        nxt = re.search(r"(?m)^(?:3[1-3]|Part\s*[IVⅣ]+)\.?\s*", text[start:])
        end = start + nxt.start() if nxt else len(text)
        body = text[start:end].strip()
        body = re.sub(r"\s+", " ", body)
        if len(body) < 8:
            continue
        if seq == 33:
            items.append(_essay(seq, body, 20, "Part Ⅳ Writing"))
        else:
            items.append(_essay(seq, body, 10, trans_sec))

    # 去重：同 paper_no 保留首个非 missing，或仅 missing
    by_no: dict[int, dict] = {}
    mats = [q for q in items if q["q_type"] == "material"]
    rest = [q for q in items if q["q_type"] != "material"]
    for q in rest:
        no = q.get("paper_no")
        if no is None:
            mats.append(q)
            continue
        prev = by_no.get(no)
        if prev is None:
            by_no[no] = q
        elif prev.get("input_mode") == "missing" and q.get("input_mode") != "missing":
            by_no[no] = q
        elif prev.get("input_mode") != "missing" and q.get("input_mode") == "missing":
            pass
        elif not prev.get("options") and q.get("options"):
            by_no[no] = q

    ordered = mats + [by_no[k] for k in sorted(by_no.keys())]
    out: list[dict] = []
    for i, q in enumerate(ordered, start=1):
        row = dict(q)
        row["seq"] = i
        out.append(row)
    return out


def quality_english_sd(qs: list[dict]) -> tuple[bool, str]:
    if not qs:
        return False, "解析为空"
    real = [q for q in qs if q.get("input_mode") != "missing"]
    mats = sum(1 for q in real if q["q_type"] == "material")
    ch = sum(
        1
        for q in real
        if q["q_type"] == "choice" and q.get("options") and len(q["options"]) >= 4
    )
    essay = sum(1 for q in real if q["q_type"] == "essay")
    miss = sum(1 for q in qs if q.get("input_mode") == "missing")
    if mats >= 1 and ch >= 8:
        return True, f"材料{mats}·选择{ch}·写作{essay}·暂缺{miss}·共{len(qs)}"
    if essay >= 2 and ch >= 5:
        return True, f"残卷可用·选择{ch}·写作{essay}·暂缺{miss}·共{len(qs)}"
    if miss >= 5 and (ch >= 5 or essay >= 2):
        return True, f"残卷占位·选择{ch}·写作{essay}·暂缺{miss}·共{len(qs)}"
    return False, f"未达门槛·材料{mats}·选择{ch}·写作{essay}·暂缺{miss}"
