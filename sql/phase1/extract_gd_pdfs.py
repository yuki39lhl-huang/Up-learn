# -*- coding: utf-8 -*-
from pypdf import PdfReader
from pathlib import Path
import json

root = Path(r"e:\GrammarPractice\IdeaProject\up-learn\shijuan\广东专升本-历年真题")
out_dir = Path(r"e:\GrammarPractice\IdeaProject\up-learn\sql\phase1\_pdf_extract")
out_dir.mkdir(exist_ok=True)

def clean(s: str) -> str:
    buf = []
    for c in s:
        o = ord(c)
        if 0xD800 <= o <= 0xDFFF:
            continue
        if c in ("\x00", "\ufeff"):
            continue
        buf.append(c)
    return "".join(buf)

summaries = []
for pdf in sorted(root.rglob("*.pdf")):
    rel = pdf.relative_to(root).as_posix()
    try:
        r = PdfReader(str(pdf))
        text = clean("\n".join((page.extract_text() or "") for page in r.pages))
    except Exception as e:
        summaries.append({"file": rel, "error": str(e), "chars": 0})
        continue
    safe = rel.replace("/", "__").replace(" ", "_")
    (out_dir / f"{safe}.txt").write_text(text, encoding="utf-8", errors="replace")
    summaries.append({"file": rel, "pages": len(r.pages), "chars": len(text), "preview": text[:200]})

(out_dir / "_index.json").write_text(json.dumps(summaries, ensure_ascii=False, indent=2), encoding="utf-8")
print("done", len(summaries))
for s in summaries[:5]:
    print(s["file"], s.get("chars"), s.get("pages"))
