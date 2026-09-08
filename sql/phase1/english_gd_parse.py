# -*- coding: utf-8 -*-
"""
广东专升本《大学英语》回忆版 PDF 抽取文本 → 结构化题目。
保留阅读 A/B/C 原文、七选五、完形、语法填空、写作；避免通用 parse 只留题干丢原文。
"""
from __future__ import annotations

import re

PAGE_HDR = re.compile(r"(?m)^第\s*\d+\s*页[^\n]*\n?")
PASSAGE_MARK = re.compile(r"(?m)^(?:\.?\s*)([A-D])\s*$")
NUM_Q = re.compile(r"(?m)^(\d{1,2})\.\s*([\s\S]+)$")


def _clean(text: str) -> str:
    text = text.replace("\r", "\n")
    text = PAGE_HDR.sub("", text)
    lines = [ln.rstrip() for ln in text.split("\n")]
    # 去掉多余空行过多
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
    # 选项正文到下一选项字母或行尾（允许多词，如 depend on）
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


def _extract_numbered_choices(block: str, lo: int, hi: int, score: float, letters: str = "ABCD") -> list[dict]:
    qs: list[dict] = []
    parts = re.split(r"(?m)(?=^\d{1,2}\.\s*)", block)
    for part in parts:
        m = NUM_Q.match(part.strip())
        if not m:
            continue
        seq = int(m.group(1))
        if seq < lo or seq > hi:
            continue
        body = m.group(2).strip()
        body = re.split(r"(?m)^\d{1,2}\.\s*", body, maxsplit=1)[0].strip()
        opts = _parse_options(body, letters=letters)
        stem = _stem_before_options(body)
        if len(opts) < 2:
            # 完形行：21.A.xxx B.xxx —— 题干可为空
            if len(opts) >= 4 or (len(opts) >= 2 and not stem):
                stem = stem or f"第 {seq} 题"
            else:
                continue
        if not stem:
            stem = f"第 {seq} 题"
        qs.append(
            {
                "seq": seq,
                "q_type": "choice",
                "stem": stem[:1200],
                "options": opts,
                "answer": "",
                "analysis": "",
                "score": score,
                "input_mode": "answerable",
            }
        )
    return qs


def _material(seq: int, title: str, body: str) -> dict:
    text = body.strip()
    text = re.sub(r"\n{3,}", "\n\n", text)
    return {
        "seq": seq,
        "q_type": "material",
        "stem": f"【{title}】\n\n{text}"[:6000],
        "options": None,
        "answer": "",
        "analysis": "",
        "score": 0,
        "input_mode": "reveal_only",
    }


def _split_reading_passages(sec: str) -> list[tuple[str, str]]:
    """返回 [(A, 原文含题), (B, ...), ...]"""
    # 去掉引导语到第一个篇目标记
    m0 = PASSAGE_MARK.search(sec)
    if not m0:
        return []
    sec = sec[m0.start() :]
    parts = PASSAGE_MARK.split(sec)
    # parts: ['', 'A', content, 'B', content, ...]
    out: list[tuple[str, str]] = []
    i = 1
    while i + 1 < len(parts):
        letter = parts[i].upper()
        content = parts[i + 1]
        # 切掉第二节及以后
        content = re.split(r"(?m)^第二节", content, maxsplit=1)[0]
        content = re.split(r"(?m)^第二部分", content, maxsplit=1)[0]
        out.append((letter, content.strip()))
        i += 2
    return out


def _passage_text_only(content: str) -> str:
    """去掉篇内已编号试题，只留阅读原文。"""
    m = re.search(r"(?m)^\d{1,2}\.\s*", content)
    if not m:
        return content.strip()
    return content[: m.start()].strip()


def parse_english_paper(text: str) -> list[dict]:
    text = _clean(text)
    if "暂无" in text and text.count("暂无") >= 3:
        return []

    items: list[dict] = []
    seq_counter = 0

    def push(q: dict) -> None:
        nonlocal seq_counter
        seq_counter += 1
        q = dict(q)
        q["seq"] = seq_counter
        items.append(q)

    # —— 阅读第一节：A/B/C + 1-15 ——
    m_sec1 = re.search(
        r"第一节[（(][^\n]*15\s*小题[\s\S]*?(?=第二节|第二部分|$)",
        text,
    )
    sec1 = m_sec1.group(0) if m_sec1 else ""
    # 若结构标记缺失，退化为全文到第二节
    if not sec1:
        m_alt = re.search(r"阅读下列短文[\s\S]*?(?=第二节|第二部分|$)", text)
        sec1 = m_alt.group(0) if m_alt else text

    for letter, content in _split_reading_passages(sec1):
        passage = _passage_text_only(content)
        if len(passage) >= 40:
            push(_material(0, f"阅读理解 {letter}", passage))
        for q in _extract_numbered_choices(content, 1, 15, score=2):
            push(q)

    # —— 七选五 16-20 ——
    m_sec2 = re.search(
        r"第二节[（(][^\n]*5\s*小题[\s\S]*?(?=第二部分|第三部分|$)",
        text,
    )
    if m_sec2:
        block = m_sec2.group(0)
        # 选项库 A-E
        bank_m = re.search(
            r"(?ms)((?:^[A-E]\..+\n?){3,})",
            block,
        )
        bank = ""
        if bank_m:
            bank = bank_m.group(1).strip()
            passage_body = block[: bank_m.start()]
        else:
            passage_body = block
        passage_body = re.sub(r"^第二节[^\n]*\n?", "", passage_body).strip()
        passage_body = re.sub(
            r"^阅读下面短文[^\n]*\n?",
            "",
            passage_body,
        ).strip()
        # 去掉已写成「16.」的独立题（若有）
        mat = passage_body
        if bank:
            mat = f"{passage_body}\n\n选项：\n{bank}"
        if len(mat) >= 40:
            push(_material(0, "阅读七选五", mat))
        # 若有独立 16-20 题干则解析；否则按空生成填空位
        qs = _extract_numbered_choices(block, 16, 20, score=2, letters="ABCDE")
        if qs:
            for q in qs:
                push(q)
        else:
            for n in range(16, 21):
                push(
                    {
                        "seq": n,
                        "q_type": "fill",
                        "stem": f"第 {n} 题：从上方选项中选出填入空白处的最佳选项。",
                        "options": None,
                        "answer": "",
                        "analysis": "",
                        "score": 2,
                        "input_mode": "reveal_only",
                    }
                )

    # —— 完形 21-35 ——
    m_cloze = re.search(
        r"第一部分.*?语言运用[\s\S]*?第一节[（(][^\n]*15\s*小题[\s\S]*?(?=第二节|第三部分|$)",
        text,
    )
    if not m_cloze:
        m_cloze = re.search(
            r"第二部分\s*语言运用[\s\S]*?第一节[（(][\s\S]*?(?=第二节|第三部分|$)",
            text,
        )
    if m_cloze:
        block = m_cloze.group(0)
        # 原文：到 21.A 之前
        opt_start = re.search(r"(?m)^21\.\s*A[.、．]", block)
        if opt_start:
            passage = block[: opt_start.start()]
            opt_block = block[opt_start.start() :]
        else:
            passage = block
            opt_block = block
        passage = re.sub(r"^[\s\S]*?阅读下面短文[^\n]*\n?", "", passage, count=1).strip()
        passage = re.sub(r"^第二部分[^\n]*\n?", "", passage).strip()
        passage = re.sub(r"^第一节[^\n]*\n?", "", passage).strip()
        if len(passage) >= 40:
            push(_material(0, "完形填空原文", passage))
        # 完形选项行：21.A.x B.y ...（选项可为多词）
        for m in re.finditer(r"(?m)^(\d{2})\.\s*(.+?)\s*$", opt_block):
            seq = int(m.group(1))
            if seq < 21 or seq > 35:
                continue
            opts = _parse_options(m.group(2), letters="ABCD")
            if len(opts) < 4:
                continue
            push(
                {
                    "seq": seq,
                    "q_type": "choice",
                    "stem": f"第 {seq} 空",
                    "options": opts[:4],
                    "answer": "",
                    "analysis": "",
                    "score": 2,
                    "input_mode": "answerable",
                }
            )

    # —— 语法填空 36-45 ——
    m_gram = re.search(
        r"第二节[（(][^\n]*10\s*小题[\s\S]*?(?=第三部分|写作|$)",
        text,
    )
    # 避免匹配到阅读第二节：取最后一个「10 小题」语法节
    grams = list(
        re.finditer(
            r"第二节[（(][^\n]*10\s*小题[\s\S]*?(?=第三部分|写作|$)",
            text,
        )
    )
    if grams:
        block = grams[-1].group(0)
        passage = re.sub(r"^第二节[^\n]*\n?", "", block).strip()
        passage = re.sub(r"^阅读下面短文[^\n]*\n?", "", passage).strip()
        if len(passage) >= 40:
            push(_material(0, "语法填空原文", passage))
        for n in range(36, 46):
            push(
                {
                    "seq": n,
                    "q_type": "fill",
                    "stem": f"第 {n} 空：在空白处填入适当单词或所给词的正确形式。",
                    "options": None,
                    "answer": "",
                    "analysis": "",
                    "score": 2,  # 卷面 1.5，库字段为 INT，暂记 2
                    "input_mode": "reveal_only",
                }
            )

    # —— 写作 ——
    m_write = re.search(r"(?m)^46\.\s*([\s\S]+)$", text)
    if m_write:
        stem = re.sub(r"\s+", " ", m_write.group(1)).strip()
        push(
            {
                "seq": 46,
                "q_type": "essay",
                "stem": stem[:2000],
                "options": None,
                "answer": "",
                "analysis": "",
                "score": 15,
                "input_mode": "reveal_only",
            }
        )

    # 分数若为 1.5，SQL/Java 用 decimal？表里 score 可能是 INT — check schema
    return items
