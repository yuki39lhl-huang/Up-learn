# -*- coding: utf-8 -*-
"""抽取广东高数各年 PDF 全文，便于人工/半自动整理题目。"""
from pathlib import Path
from pypdf import PdfReader

ROOT = Path(r"e:\GrammarPractice\IdeaProject\up-learn\shijuan\广东专升本-历年真题\高数")
OUT = Path(r"e:\GrammarPractice\IdeaProject\up-learn\sql\phase1\_gaoshu_by_year")
OUT.mkdir(exist_ok=True)

def clean(s: str) -> str:
    return "".join(c for c in s if not (0xD800 <= ord(c) <= 0xDFFF) and c not in "\x00\ufeff")

for pdf in sorted(ROOT.glob("*.pdf")):
    r = PdfReader(str(pdf))
    text = clean("\n".join((p.extract_text() or "") for p in r.pages))
    # 文件名里的年份
    import re
    m = re.search(r"(20\d{2})", pdf.name)
    year = m.group(1) if m else "unknown"
    path = OUT / f"gaoshu_{year}.txt"
    path.write_text(text, encoding="utf-8", errors="replace")
    print(year, "pages", len(r.pages), "chars", len(text), "->", path.name)
