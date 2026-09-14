# -*- coding: utf-8 -*-
"""广东招生 CSV + 专业词典对照表 → school / major_dict / school_major。

用法:
  python import_guangdong_majors.py [--year 2026] [--port 3308] [--dry-run]

依赖: pymysql
默认连项目 local 配置：localhost:3308 / root / 1234 / up_learn
"""
from __future__ import annotations

import argparse
import csv
import re
import sys
from pathlib import Path

import pymysql

BASE = Path(__file__).resolve().parent
OFFER_CSV = BASE / "全部院校专业详细.csv"
MAP_CSV = BASE / "专业词典对照表.csv"
YEAR_DEFAULT = 2026
PORT_DEFAULT = 3308

ALIASES = {
    "机械设计制造及自动化": "机械设计制造及其自动化",
    "护理": "护理学",
    "劳动社会保障": "劳动与社会保障",
}


def strip_paren(name: str) -> str:
    return re.sub(r"[（(].*?[）)]", "", name).strip()


def normalize_name(raw: str) -> str:
    name = strip_paren(raw).replace(" ", "")
    return ALIASES.get(name, name)


def col(row: dict, *needles: str) -> str:
    for k, v in row.items():
        for n in needles:
            if n in k:
                return (v or "").strip()
    return ""


def load_mapping() -> dict[str, dict]:
    with MAP_CSV.open(encoding="utf-8-sig", newline="") as f:
        rows = list(csv.DictReader(f))
    return {
        r["标准专业"]: {
            "discipline": r["门类"],
            "category": r["专业类"],
            "code": r["专业代码"] or None,
            "exam_track": r["考试轨道"] or None,
        }
        for r in rows
    }


def load_offers() -> list[dict]:
    with OFFER_CSV.open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def upsert_school(cur, name: str, school_type: str) -> int:
    cur.execute(
        "SELECT id FROM school WHERE name=%s AND deleted=0 LIMIT 1",
        (name,),
    )
    row = cur.fetchone()
    if row:
        cur.execute(
            "UPDATE school SET type=%s, province='广东', updated_at=CURRENT_TIMESTAMP(3) WHERE id=%s",
            (school_type or None, row[0]),
        )
        return int(row[0])
    cur.execute(
        "INSERT INTO school (name, province, type, prefer_public, deleted) VALUES (%s,'广东',%s,%s,0)",
        (name, school_type or None, 1 if school_type == "公办" else 0),
    )
    return int(cur.lastrowid)


def upsert_dict(cur, std: str, meta: dict) -> int:
    cur.execute("SELECT id FROM major_dict WHERE name=%s AND deleted=0 LIMIT 1", (std,))
    row = cur.fetchone()
    if row:
        cur.execute(
            """UPDATE major_dict
               SET discipline=%s, major_category=%s, code=COALESCE(%s, code), exam_track=%s,
                   updated_at=CURRENT_TIMESTAMP(3)
               WHERE id=%s""",
            (meta["discipline"], meta["category"], meta["code"], meta["exam_track"], row[0]),
        )
        return int(row[0])
    cur.execute(
        """INSERT INTO major_dict (name, discipline, major_category, code, exam_track, deleted)
           VALUES (%s,%s,%s,%s,%s,0)""",
        (std, meta["discipline"], meta["category"], meta["code"], meta["exam_track"]),
    )
    return int(cur.lastrowid)


def upsert_offer(cur, school_id: int, dict_id: int, year: int, r: dict) -> None:
    display = r["招生专业"]
    group = (r.get("专业组") or "").strip() or "00"
    code = (r.get("专业号") or "").strip() or "000"
    campus = (r.get("教学地点") or "").strip() or None
    exam_type = (r.get("专综类型") or "").strip() or None
    foundation = col(r, "专业基础课") or None
    comprehensive = col(r, "专业综合课") or None
    public = col(r, "公共课") or ""
    prerequisite = (r.get("前置要求") or "").strip() or None
    batch = (r.get("批次") or "").strip() or None
    tuition_raw = (r.get("学费") or "").strip()
    tuition = int(tuition_raw) if tuition_raw.isdigit() else None
    parts = [p for p in [public, foundation, comprehensive] if p]
    exam_subjects = "，".join(parts) if parts else None

    cur.execute(
        """SELECT id FROM school_major
           WHERE school_id=%s AND year=%s AND major_group=%s AND major_code=%s AND deleted=0
           LIMIT 1""",
        (school_id, year, group, code),
    )
    row = cur.fetchone()
    if row:
        cur.execute(
            """UPDATE school_major SET
                 major_dict_id=%s, display_name=%s, campus=%s, exam_type=%s,
                 foundation_subject=%s, comprehensive_subject=%s, prerequisite=%s,
                 batch_name=%s, exam_subjects=%s, tuition=%s, updated_at=CURRENT_TIMESTAMP(3)
               WHERE id=%s""",
            (
                dict_id,
                display,
                campus,
                exam_type,
                foundation,
                comprehensive,
                prerequisite,
                batch,
                exam_subjects,
                tuition,
                row[0],
            ),
        )
    else:
        cur.execute(
            """INSERT INTO school_major (
                 school_id, major_dict_id, display_name, major_group, major_code, campus,
                 exam_type, foundation_subject, comprehensive_subject, prerequisite, batch_name,
                 exam_subjects, tuition, year, deleted
               ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,0)""",
            (
                school_id,
                dict_id,
                display,
                group,
                code,
                campus,
                exam_type,
                foundation,
                comprehensive,
                prerequisite,
                batch,
                exam_subjects,
                tuition,
                year,
            ),
        )


def refresh_major_counts(cur) -> None:
    cur.execute(
        """UPDATE school s
           SET major_count = (
             SELECT COUNT(*) FROM school_major m
             WHERE m.school_id = s.id AND m.deleted = 0
           )
           WHERE s.province = '广东' AND s.deleted = 0"""
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--year", type=int, default=YEAR_DEFAULT)
    parser.add_argument("--port", type=int, default=PORT_DEFAULT, help="MySQL 端口，local 默认 3308")
    parser.add_argument(
        "--replace-guangdong",
        action="store_true",
        help="清空 school_major、major_dict，并删除广东院校后再导入（保留山东等）",
    )
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    db = dict(
        host="localhost",
        port=args.port,
        user="root",
        password="1234",
        database="up_learn",
        charset="utf8mb4",
    )

    if not MAP_CSV.exists():
        print("missing mapping csv, run build_major_mapping.py first", file=sys.stderr)
        return 1
    mapping = load_mapping()
    offers = load_offers()

    missing = []
    for r in offers:
        std = normalize_name(r["招生专业"])
        if std not in mapping:
            missing.append(std)
    if missing:
        print("unmapped standards:", sorted(set(missing)), file=sys.stderr)
        return 1

    if args.dry_run:
        schools = {(r["院校名称"], r["性质"]) for r in offers}
        print(
            f"dry-run port={args.port} schools={len(schools)} "
            f"offers={len(offers)} dicts={len(mapping)}"
        )
        return 0

    conn = pymysql.connect(**db)
    try:
        with conn.cursor() as cur:
            if args.replace_guangdong:
                cur.execute("DELETE FROM school_major")
                cur.execute("DELETE FROM major_dict")
                cur.execute("DELETE FROM school WHERE province=%s", ("广东",))
                print("cleared school_major, major_dict, and Guangdong schools")

            school_ids: dict[str, int] = {}
            dict_ids: dict[str, int] = {}
            for std, meta in mapping.items():
                dict_ids[std] = upsert_dict(cur, std, meta)
            for r in offers:
                name = r["院校名称"].strip()
                if name not in school_ids:
                    school_ids[name] = upsert_school(cur, name, (r.get("性质") or "").strip())
                std = normalize_name(r["招生专业"])
                upsert_offer(cur, school_ids[name], dict_ids[std], args.year, r)
            refresh_major_counts(cur)
        conn.commit()
        print(
            f"ok port={args.port} schools={len(school_ids)} "
            f"dicts={len(dict_ids)} offers={len(offers)} year={args.year}"
        )
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
