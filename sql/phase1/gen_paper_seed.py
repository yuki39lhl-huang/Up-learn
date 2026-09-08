#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""扫描 shijuan/ 生成 paper 元数据种子 SQL + 广东高等数学样板题目。"""
from __future__ import annotations

import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SHIJUAN = ROOT / "shijuan"
OUT = Path(__file__).resolve().parent / "paper_seed.sql"

# 文件夹名 -> (省份, 展示科目)
FOLDER_MAP = {
    "广东专升本-历年真题": {
        "高数": ("广东", "高等数学"),
        "英语": ("广东", "英语"),
        "语文": ("广东", "大学语文"),
        "政治理论": ("广东", "政治理论"),
        "管理学": ("广东", "管理学"),
        "经济学": ("广东", "经济学"),
        "教育理论": ("广东", "教育理论"),
        "生理学": ("广东", "生理学"),
    },
    "山东专升本-历年真题": {
        "英语": ("山东", "英语"),
        "政治": ("山东", "政治"),
        "语文": ("山东", "大学语文"),
        "计算机": ("山东", "计算机"),
        "高数一": ("山东", "高等数学I"),
        "高数二": ("山东", "高等数学II"),
        "高数三": ("山东", "高等数学III"),
    },
}

YEAR_RE = re.compile(r"(20\d{2})")


def escape_sql(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "''")


def parse_year(name: str) -> int | None:
    m = YEAR_RE.search(name)
    return int(m.group(1)) if m else None


def main() -> None:
    rows: list[tuple[str, str, int, str, str]] = []
    for region_dir, subjects in FOLDER_MAP.items():
        region_path = SHIJUAN / region_dir
        if not region_path.is_dir():
            print(f"skip missing: {region_path}")
            continue
        for folder, (province, subject) in subjects.items():
            sub = region_path / folder
            if not sub.is_dir():
                continue
            for pdf in sorted(sub.glob("*.pdf")):
                year = parse_year(pdf.name)
                if year is None:
                    print(f"no year: {pdf}")
                    continue
                rel = pdf.relative_to(SHIJUAN).as_posix()
                title = f"{year}年{province}专升本{subject}真题"
                rows.append((province, subject, year, title, rel))

    # 同省同科同年保留一条（后写覆盖前写，优先无序号的 2025 文件名也可）
    uniq: dict[tuple[str, str, int], tuple[str, str, int, str, str]] = {}
    for r in rows:
        uniq[(r[0], r[1], r[2])] = r
    papers = sorted(uniq.values(), key=lambda x: (x[0], x[1], -x[2]))

    lines = [
        "-- 由 gen_paper_seed.py 扫描 shijuan/ 生成；PDF 不入库，pdf_url 为相对 shijuan 路径",
        "USE up_learn;",
        "",
        "INSERT INTO `paper`",
        "  (`province`, `subject`, `year`, `title`, `pdf_url`, `has_answer`, `published`)",
        "VALUES",
    ]
    value_sql = []
    for province, subject, year, title, rel in papers:
        value_sql.append(
            f"  ('{escape_sql(province)}', '{escape_sql(subject)}', {year}, "
            f"'{escape_sql(title)}', '{escape_sql(rel)}', 0, 1)"
        )
    lines.append(",\n".join(value_sql))
    lines.append(
        "ON DUPLICATE KEY UPDATE\n"
        "  `title` = VALUES(`title`),\n"
        "  `pdf_url` = VALUES(`pdf_url`),\n"
        "  `published` = VALUES(`published`);"
    )
    lines.append("")
    lines.append("-- 样板：广东高等数学最新一年（有 PDF 的）录入若干题，便于联调作答/揭晓")
    lines.append(
        "SET @paper_id := (\n"
        "  SELECT id FROM paper\n"
        "  WHERE province = '广东' AND subject = '高等数学' AND published = 1\n"
        "  ORDER BY year DESC LIMIT 1\n"
        ");"
    )
    lines.append(
        "UPDATE paper SET has_answer = 1 WHERE id = @paper_id;"
    )
    lines.append(
        "DELETE FROM paper_question WHERE paper_id = @paper_id;"
    )
    lines.append(
        """INSERT INTO paper_question
  (paper_id, seq, q_type, stem, options_json, answer, analysis, score, input_mode)
VALUES
  (@paper_id, 1, 'choice',
   '若函数 $f(x)=x^2+1$，则二阶导数 $f^{\\\\prime\\\\prime}(x)=$',
   JSON_ARRAY('A. $2x$', 'B. $2$', 'C. $x$', 'D. $0$'),
   'B', '二阶导数：$f^{\\\\prime\\\\prime}(x)=2$。', 5, 'answerable'),
  (@paper_id, 2, 'choice',
   '极限 $\\\\lim_{x\\\\to 0}\\\\frac{\\\\sin x}{x}$ 等于',
   JSON_ARRAY('A. $0$', 'B. $1$', 'C. $\\\\infty$', 'D. 不存在'),
   'B', '重要极限：$\\\\lim_{x\\\\to 0}\\\\sin x / x = 1$。', 5, 'answerable'),
  (@paper_id, 3, 'fill',
   '设 $y=\\\\mathrm{e}^{2x}$，则 $y^{\\\\prime\\\\prime}=$ ________。',
   NULL,
   '$4\\\\mathrm{e}^{2x}$', '求导两次得 $4e^{2x}$。', 8, 'reveal_only'),
  (@paper_id, 4, 'calc',
   '计算不定积分 $\\\\displaystyle\\\\int (2x+1)\\\\,dx$。',
   NULL,
   '$x^2+x+C$', '逐项积分。提交后请对照手写过程自行批改。', 10, 'reveal_only');
"""
    )
    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"wrote {len(papers)} papers -> {OUT}")


if __name__ == "__main__":
    main()
