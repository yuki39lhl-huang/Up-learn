# -*- coding: utf-8 -*-
"""从官方统考表 + 招生 CSV 生成标准专业→门类/专业类对照表。"""
from __future__ import annotations

import csv
import re
from collections import Counter, defaultdict
from pathlib import Path

BASE = Path(__file__).resolve().parent
OFFICIAL_MD = BASE / "全部在招专业(院校自定义不记录).md"
OFFER_CSV = BASE / "全部院校专业详细.csv"
OUT_CSV = BASE / "专业词典对照表.csv"

# 与 exam_subject_rule 种子对齐的专业类名
CATEGORY_ALIAS = {
    "设计学类": "艺术设计类",
    "中国语言文学类": "汉语言文学类",
    "外国语言文学类": "英语类",  # 日语等再细分时覆盖
    "生物科学类": "生物类",
    "植物生产类": "农学类",
    "电气类": "电子信息类",  # 规则表无独立电气类，并入电子信息（科目同为电子技术基础）
    "自动化类": "自动化类",
    "工业工程类": "机械类",
    "金融学类": "经济学类",
    "经济与贸易类": "国际经济与贸易类",
}

ALIASES = {
    "机械设计制造及自动化": "机械设计制造及其自动化",
    "护理": "护理学",
    "劳动社会保障": "劳动与社会保障",
    "汉语言文学(师范)": "汉语言文学",
    "英语(师范)": "英语",
    "数学与应用数学(师范)": "数学与应用数学",
    "学前教育(师范)": "学前教育",
    "音乐学(师范)": "音乐学",
    "美术学(师范)": "美术学",
}

# 科目推断：(基础课包含, 专综包含/前缀) -> (门类, 专业类, 是否待确认)
# 更具体的规则放前面
SUBJECT_RULES: list[tuple[str | None, str | None, str, str, bool]] = [
    ("高等数学", "计算机基础与程序设计", "工学", "计算机类", False),
    ("高等数学", "程序设计基础", "工学", "计算机类", False),
    ("高等数学", "电子技术基础", "工学", "电子信息类", False),
    ("高等数学", "机械工程基础", "工学", "机械类", False),
    ("高等数学", "电工电子技术基础", "工学", "自动化类", False),
    ("高等数学", "数学专业综合", "理学", "数学类", False),
    ("高等数学", "遗传学", "理学", "生物类", False),
    ("高等数学", "建筑材料", "工学", "土木类", False),
    ("高等数学", "土木工程", "工学", "土木类", False),
    ("高等数学", "工程力学", "工学", "土木类", False),
    ("高等数学", "市政工程", "工学", "土木类", True),
    ("高等数学", "城市规划", "工学", "土木类", True),
    ("高等数学", "建筑", "工学", "土木类", True),
    ("高等数学", "环境", "工学", "土木类", True),
    ("高等数学", "食品", "工学", "食品科学与工程类", False),
    ("高等数学", "服装", "工学", "机械类", True),
    ("高等数学", "高分子", "工学", "机械类", True),
    ("高等数学", "材料", "工学", "机械类", True),
    ("高等数学", "化学", "理学", "生物类", True),
    ("高等数学", "制药", "工学", "食品科学与工程类", True),
    ("高等数学", "安全", "工学", "土木类", True),
    ("高等数学", "地质", "工学", "土木类", True),
    ("高等数学", "资源", "工学", "土木类", True),
    ("高等数学", "土地", "工学", "土木类", True),
    ("高等数学", "模拟电子", "工学", "电子信息类", True),
    ("高等数学", "数字媒体技术导论", "工学", "计算机类", False),
    ("高等数学", "风景园林", "工学", "土木类", True),
    ("高等数学", "自然地理", "理学", "生物类", True),
    ("高等数学", "人文地理", "理学", "生物类", True),
    ("高等数学", "建筑工程概预算", "工学", "土木类", True),
    ("高等数学", "建设工程造价", "工学", "土木类", True),
    ("高等数学", "精细化工", "工学", "食品科学与工程类", True),
    ("高等数学", "生物化学", "理学", "生物类", True),
    ("高等数学", "物流学", "管理学", "市场营销类", True),
    ("生态学基础", "遗传学", "农学", "农学类", False),
    ("生态学基础", None, "农学", "农学类", False),
    ("管理学", "基础会计学", "管理学", "工商管理类", False),
    ("管理学", "市场营销学", "管理学", "市场营销类", False),
    ("管理学", "电子商务概论", "管理学", "电子商务类", False),
    ("管理学", "人力资源管理", "管理学", "人力资源管理类", False),
    ("管理学", "行政管理学", "管理学", "行政管理类", False),
    ("管理学", "工程项目管理", "管理学", "工商管理类", True),
    ("管理学", "建设工程项目管理", "管理学", "工商管理类", True),
    ("管理学", "物流", "管理学", "市场营销类", True),
    ("管理学", "旅游", "管理学", "市场营销类", True),
    ("管理学", "酒店", "管理学", "市场营销类", True),
    ("管理学", "健康", "管理学", "行政管理类", True),
    ("管理学", "文化", "管理学", "市场营销类", True),
    ("管理学", "传播", "管理学", "市场营销类", True),
    ("管理学", "社会保障", "管理学", "行政管理类", True),
    ("管理学", "管理信息系统", "管理学", "计算机类", True),
    ("管理学", "大数据", "管理学", "工商管理类", True),
    ("管理学", "国际企业", "管理学", "市场营销类", True),
    ("管理学", "国际商务", "管理学", "市场营销类", True),
    ("管理学", "审计", "管理学", "工商管理类", True),
    ("管理学", "信息资源", "管理学", "行政管理类", True),
    ("管理学", "标准化", "管理学", "工商管理类", True),
    ("管理学", "跨境", "管理学", "电子商务类", True),
    ("管理学", "数字化运营", "经济学", "经济学类", True),
    ("管理学", "新媒体文案", "文学", "汉语言文学类", True),
    ("经济学", "金融学", "经济学", "经济学类", False),
    ("经济学", "国际贸易理论与实务", "经济学", "国际经济与贸易类", False),
    ("经济学", "互联网金融", "经济学", "经济学类", False),
    ("大学语文", "英语基础与写作", "文学", "英语类", False),
    ("大学语文", "汉语言文学学科基础", "文学", "汉语言文学类", False),
    ("大学语文", "英汉", "文学", "英语类", False),
    ("大学语文", "翻译", "文学", "英语类", False),
    ("大学语文", "日语", "文学", "英语类", True),
    ("大学语文", "基础日语", "文学", "英语类", True),
    ("大学语文", "综合日语", "文学", "英语类", True),
    ("大学语文", "朝鲜", "文学", "英语类", True),
    ("大学语文", "韩国", "文学", "英语类", True),
    ("大学语文", "葡萄牙", "文学", "英语类", True),
    ("大学语文", "俄语", "文学", "英语类", True),
    ("大学语文", "新闻", "文学", "汉语言文学类", True),
    ("大学语文", "网络新闻", "文学", "汉语言文学类", True),
    ("大学语文", "传播", "文学", "汉语言文学类", True),
    ("民法", "法理学", "法学", "法学类", False),
    ("民法", "社会工作", "法学", "法学类", True),
    ("教育理论", "学前教育基础", "教育学", "教育学类", False),
    ("教育理论", "小学教育", "教育学", "教育学类", False),
    ("教育理论", "课程与教学论", "教育学", "教育学类", False),
    ("教育理论", "体育", "教育学", "教育学类", True),
    ("教育理论", "学校体育", "教育学", "教育学类", True),
    ("教育理论", "烹饪", "教育学", "教育学类", True),
    ("艺术概论", "设计基础", "艺术学", "艺术设计类", False),
    ("艺术概论", "音乐", "艺术学", "音乐与舞蹈类", False),
    ("艺术概论", "钢琴", "艺术学", "音乐与舞蹈类", False),
    ("艺术概论", "声乐", "艺术学", "音乐与舞蹈类", False),
    ("艺术概论", "管乐", "艺术学", "音乐与舞蹈类", False),
    ("艺术概论", "弦乐", "艺术学", "音乐与舞蹈类", False),
    ("艺术概论", "民乐", "艺术学", "音乐与舞蹈类", False),
    ("艺术概论", "舞蹈", "艺术学", "音乐与舞蹈类", False),
    ("艺术概论", "表演", "艺术学", "音乐与舞蹈类", True),
    ("艺术概论", "播音", "艺术学", "音乐与舞蹈类", True),
    ("艺术概论", "摄影", "艺术学", "艺术设计类", True),
    ("艺术概论", "分镜头", "艺术学", "艺术设计类", True),
    ("艺术概论", "专业设计", "艺术学", "艺术设计类", False),
    ("艺术概论", "书法", "艺术学", "艺术设计类", True),
    ("艺术概论", "影视", "艺术学", "艺术设计类", True),
    ("艺术概论", "电影", "艺术学", "艺术设计类", True),
    ("艺术概论", "广播", "艺术学", "艺术设计类", True),
    ("艺术概论", "美术", "艺术学", "艺术设计类", True),
    ("艺术概论", "服装设计", "艺术学", "艺术设计类", False),
    ("艺术概论", "风景园林", "艺术学", "艺术设计类", True),
    ("生理学", "护理", "医学", "医学类", False),
    ("生理学", "药学", "医学", "医学类", False),
    ("生理学", "中药", "医学", "医学类", False),
    ("生理学", "康复", "医学", "医学类", False),
    ("生理学", "预防", "医学", "医学类", False),
    ("生理学", "医学", "医学", "医学类", False),
    ("生理学", "药理", "医学", "医学类", False),
    ("生理学", "微生物", "医学", "医学类", False),
    ("生理学", "耳咽喉", "医学", "医学类", False),
    ("体育理论", None, "教育学", "教育学类", True),
]


def strip_paren(name: str) -> str:
    return re.sub(r"[（(].*?[）)]", "", name).strip()


def normalize_name(raw: str) -> str:
    name = strip_paren(raw)
    name = name.replace(" ", "")
    # 统一全角括号已去掉；再处理半角残留
    name = ALIASES.get(name, name)
    name = ALIASES.get(name, name)
    return name


def parse_official() -> dict[str, dict]:
    """标准名 -> {discipline, category, code, source}"""
    result: dict[str, dict] = {}
    for line in OFFICIAL_MD.read_text(encoding="utf-8").splitlines():
        if not line.startswith("|"):
            continue
        parts = [p.strip() for p in line.strip("|").split("|")]
        if len(parts) < 6 or not parts[0].isdigit():
            continue
        discipline, category, code, name = parts[1], parts[2], parts[3], parts[4]
        std = normalize_name(name)
        cat = category or ""
        # 英语类/汉语言：官方外国语言文学类 → 按名称细分
        if cat == "外国语言文学类":
            cat = "英语类"
        cat = CATEGORY_ALIAS.get(cat, cat) if cat else infer_category_from_name(std, discipline)
        if not cat:
            cat = "未分类"
        # 电气类：保留独立专业类更清晰（规则表可后续补）；此处用电子信息类对齐科目
        if category == "电气类":
            cat = "电子信息类"
        if category == "自动化类":
            cat = "自动化类"
        if category == "工业工程类":
            cat = "机械类"
        result[std] = {
            "discipline": discipline,
            "category": cat,
            "code": code,
            "source": "统考表",
            "pending": False,
        }
    return result


def infer_category_from_name(name: str, discipline: str) -> str:
    if discipline == "管理学":
        if "会计" in name or "财务" in name:
            return "工商管理类"
        if "电子" in name:
            return "电子商务类"
        if "市场" in name or "工商" in name:
            return "市场营销类"
        if "人力" in name:
            return "人力资源管理类"
        if "行政" in name:
            return "行政管理类"
    return ""


def infer_from_subjects(foundation: str, comprehensive: str) -> tuple[str, str, bool] | None:
    f = foundation or ""
    c = comprehensive or ""
    for f_key, c_key, disc, cat, pending in SUBJECT_RULES:
        if f_key and f_key not in f:
            continue
        if c_key and c_key not in c:
            continue
        return disc, cat, pending
    return None


def name_override(std: str) -> tuple[str, str, bool] | None:
    """按标准名强制归类（科目冲突或无法推断时）。"""
    overrides = {
        "小学教育": ("教育学", "教育学类", False),
        "体育教育": ("教育学", "教育学类", False),
        "休闲体育": ("教育学", "教育学类", True),
        "社会体育指导与管理": ("教育学", "教育学类", True),
        "运动康复": ("教育学", "教育学类", True),
        "日语": ("文学", "英语类", True),
        "朝鲜语": ("文学", "英语类", True),
        "葡萄牙语": ("文学", "英语类", True),
        "俄语": ("文学", "英语类", True),
        "翻译": ("文学", "英语类", False),
        "工程造价": ("管理学", "工商管理类", True),
        "工程管理": ("管理学", "工商管理类", True),
        "风景园林": ("工学", "土木类", True),
        "数据科学与大数据技术": ("工学", "计算机类", False),
        "人工智能": ("工学", "计算机类", False),
        "数字媒体技术": ("工学", "计算机类", False),
        "网络空间安全": ("工学", "计算机类", False),
        "智能科学与技术": ("工学", "计算机类", False),
        "信息管理与信息系统": ("管理学", "计算机类", True),
        "大数据管理与应用": ("管理学", "工商管理类", True),
        "数字经济": ("经济学", "经济学类", False),
        "互联网金融": ("经济学", "经济学类", False),
        "金融科技": ("经济学", "经济学类", False),
        "经济与金融": ("经济学", "经济学类", False),
        "税收学": ("经济学", "经济学类", False),
        "经济统计学": ("经济学", "经济学类", False),
        "资产评估": ("管理学", "工商管理类", False),
        "审计学": ("管理学", "工商管理类", False),
        "跨境电子商务": ("管理学", "电子商务类", False),
        "供应链管理": ("管理学", "市场营销类", False),
        "现代物流管理": ("管理学", "市场营销类", True),
        "物流工程": ("管理学", "市场营销类", True),
        "物流工程技术": ("管理学", "市场营销类", True),
        "护理学": ("医学", "医学类", False),
        "药学": ("医学", "医学类", False),
        "中药学": ("医学", "医学类", False),
        "中药制药": ("医学", "医学类", False),
        "康复治疗学": ("医学", "医学类", False),
        "康复治疗": ("医学", "医学类", False),
        "预防医学": ("医学", "医学类", False),
        "医学检验技术": ("医学", "医学类", False),
        "医学影像技术": ("医学", "医学类", False),
        "听力与言语康复学": ("医学", "医学类", False),
        "生物医学工程": ("工学", "电子信息类", True),
        "化妆品科学与技术": ("医学", "医学类", True),
        "网络与新媒体": ("文学", "汉语言文学类", True),
        "新闻学": ("文学", "汉语言文学类", True),
        "广告学": ("文学", "汉语言文学类", True),
        "传播学": ("文学", "汉语言文学类", True),
        "秘书学": ("文学", "汉语言文学类", True),
        "时尚传播": ("文学", "汉语言文学类", True),
        "社会工作": ("法学", "法学类", True),
        "公共事业管理": ("管理学", "行政管理类", False),
        "公共关系学": ("管理学", "行政管理类", True),
        "劳动与社会保障": ("管理学", "行政管理类", True),
        "健康服务与管理": ("管理学", "行政管理类", True),
        "医疗保险": ("管理学", "行政管理类", True),
        "会展经济与管理": ("管理学", "市场营销类", True),
        "文化产业管理": ("管理学", "市场营销类", True),
        "企业数字化管理": ("管理学", "市场营销类", True),
        "国际商务": ("管理学", "市场营销类", True),
        "应用心理学": ("理学", "数学类", True),
        "机器人工程": ("工学", "自动化类", False),
        "机器人技术": ("工学", "自动化类", False),
        "电气工程及其自动化": ("工学", "电子信息类", False),
        "电气工程及自动化": ("工学", "电子信息类", False),
        "自动化": ("工学", "电子信息类", False),
        "工业工程": ("工学", "机械类", False),
        "园林景观工程": ("农学", "农学类", True),
        "园林": ("农学", "农学类", True),
        "环境艺术设计": ("艺术学", "艺术设计类", False),
        "数字媒体艺术": ("艺术学", "艺术设计类", False),
        "新媒体艺术": ("艺术学", "艺术设计类", False),
        "动画": ("艺术学", "艺术设计类", False),
        "音乐表演": ("艺术学", "音乐与舞蹈类", False),
        "音乐学": ("艺术学", "音乐与舞蹈类", False),
        "音乐教育": ("艺术学", "音乐与舞蹈类", False),
        "舞蹈编导": ("艺术学", "音乐与舞蹈类", False),
        "舞蹈表演": ("艺术学", "音乐与舞蹈类", False),
        "表演": ("艺术学", "音乐与舞蹈类", True),
        "播音与主持艺术": ("艺术学", "音乐与舞蹈类", True),
        "书法学": ("艺术学", "艺术设计类", True),
        "绘画": ("艺术学", "艺术设计类", True),
        "摄影": ("艺术学", "艺术设计类", True),
        "应用英语": ("文学", "英语类", False),
        "商务英语": ("文学", "英语类", False),
        "软件工程技术": ("工学", "计算机类", False),
        "网络工程技术": ("工学", "计算机类", False),
        "大数据工程技术": ("工学", "计算机类", False),
        "计算机应用工程": ("工学", "计算机类", False),
        "大数据与会计": ("管理学", "工商管理类", False),
        "大数据与财务管理": ("管理学", "工商管理类", False),
        "机械电子工程技术": ("工学", "机械类", False),
        "汽车服务工程技术": ("工学", "机械类", False),
        "智能制造工程技术": ("工学", "机械类", False),
        "现代精细化工技术": ("工学", "食品科学与工程类", True),
        "合成生物技术": ("理学", "生物类", True),
        "宝石及材料工艺学": ("工学", "机械类", True),
        "药物制剂": ("医学", "医学类", False),
        "工业设计": ("工学", "机械类", True),
        "建筑设计": ("工学", "土木类", True),
        "建筑工程": ("工学", "土木类", False),
        "建筑环境与能源应用工程": ("工学", "土木类", False),
        "建筑学": ("工学", "土木类", False),
        "城乡规划": ("工学", "土木类", False),
        "给排水科学与工程": ("工学", "土木类", False),
        "交通工程": ("工学", "土木类", True),
        "交通运输": ("工学", "机械类", True),
        "飞行器设计与工程": ("工学", "电子信息类", True),
        "无人驾驶航空器系统工程": ("工学", "电子信息类", True),
        "集成电路设计与集成系统": ("工学", "电子信息类", False),
        "微电子科学与工程": ("工学", "电子信息类", False),
        "电子与计算机工程": ("工学", "计算机类", False),
        "数字印刷工程": ("工学", "计算机类", True),
        "烹饪与营养教育": ("教育学", "教育学类", True),
        "食品营养与检验教育": ("工学", "食品科学与工程类", True),
        "食品质量与安全": ("工学", "食品科学与工程类", False),
        "应用化学": ("理学", "生物类", True),
        "化学工程与工艺": ("工学", "食品科学与工程类", True),
        "制药工程": ("工学", "食品科学与工程类", True),
        "动物科学": ("农学", "农学类", False),
        "水产养殖学": ("农学", "农学类", False),
        "林学": ("农学", "农学类", False),
        "草业科学": ("农学", "农学类", False),
        "土地科学与技术": ("工学", "土木类", True),
        "资源环境科学": ("工学", "土木类", True),
        "资源勘查工程": ("工学", "土木类", True),
        "环境工程": ("工学", "土木类", False),
        "安全工程": ("工学", "土木类", True),
        "人文地理与城乡规划": ("工学", "土木类", True),
        "自然地理与资源环境": ("理学", "生物类", True),
        "戏剧影视文学": ("艺术学", "艺术设计类", True),
        "戏剧影视导演": ("艺术学", "艺术设计类", True),
        "影视摄影与制作": ("艺术学", "艺术设计类", True),
        "电影学": ("艺术学", "艺术设计类", True),
        "广播电视编导": ("艺术学", "艺术设计类", True),
        "珠宝首饰设计与工艺": ("艺术学", "艺术设计类", False),
        "服装设计与工程": ("工学", "机械类", True),
        "服装与服饰设计": ("艺术学", "艺术设计类", False),
        "工艺美术": ("艺术学", "艺术设计类", False),
        "公共艺术": ("艺术学", "艺术设计类", False),
        "艺术与科技": ("艺术学", "艺术设计类", False),
        "艺术设计学": ("艺术学", "艺术设计类", False),
        "产品设计": ("艺术学", "艺术设计类", False),
        "环境设计": ("艺术学", "艺术设计类", False),
        "视觉传达设计": ("艺术学", "艺术设计类", False),
        "美术学": ("艺术学", "艺术设计类", True),
    }
    return overrides.get(std)


def load_offers() -> list[dict]:
    with OFFER_CSV.open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def foundation_key(row: dict) -> str:
    for k in row:
        if "专业基础课" in k:
            return row[k] or ""
    return ""


def comprehensive_key(row: dict) -> str:
    for k in row:
        if "专业综合课" in k:
            return row[k] or ""
    return ""


def main() -> None:
    official = parse_official()
    rows = load_offers()

    # 每个标准名：示例招生名、考试类型统计、科目投票
    samples: dict[str, set[str]] = defaultdict(set)
    exam_tracks: dict[str, Counter] = defaultdict(Counter)
    subject_votes: dict[str, Counter] = defaultdict(Counter)

    for r in rows:
        raw = r["招生专业"]
        std = normalize_name(raw)
        samples[std].add(raw)
        exam_tracks[std][r.get("专综类型") or ""] += 1
        f, c = foundation_key(r), comprehensive_key(r)
        subject_votes[std][(f, c)] += 1

    out_rows = []
    for std in sorted(samples):
        pending = False
        source = ""
        code = ""
        discipline = ""
        category = ""

        if std in official:
            o = official[std]
            discipline, category, code = o["discipline"], o["category"], o["code"]
            source = "统考表"
            pending = False
        else:
            ov = name_override(std)
            if ov:
                discipline, category, pending = ov
                source = "名称规则"
            else:
                # 取出现次数最多的科目组合推断
                (f, c), _ = subject_votes[std].most_common(1)[0]
                inferred = infer_from_subjects(f, c)
                if inferred:
                    discipline, category, pending = inferred
                    source = "科目推断"
                else:
                    discipline, category, pending = "待定", "未分类", True
                    source = "待确认"

        tracks = exam_tracks[std]
        if len([t for t, n in tracks.items() if t and n > 0]) > 1:
            exam_track = "混合"
        else:
            exam_track = tracks.most_common(1)[0][0] or ""

        sample_names = "｜".join(sorted(samples[std])[:5])
        out_rows.append(
            {
                "标准专业": std,
                "门类": discipline,
                "专业类": category,
                "专业代码": code,
                "考试轨道": exam_track,
                "来源": source,
                "待确认": "是" if pending or source == "待确认" else "否",
                "开设次数": sum(exam_tracks[std].values()),
                "示例招生名": sample_names,
            }
        )

    with OUT_CSV.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "标准专业",
                "门类",
                "专业类",
                "专业代码",
                "考试轨道",
                "来源",
                "待确认",
                "开设次数",
                "示例招生名",
            ],
        )
        writer.writeheader()
        writer.writerows(out_rows)

    pending_n = sum(1 for r in out_rows if r["待确认"] == "是")
    print(f"wrote {OUT_CSV}")
    print(f"standards={len(out_rows)} pending={pending_n}")
    by_disc = Counter(r["门类"] for r in out_rows)
    for d, n in by_disc.most_common():
        print(f"  {d}: {n}")


if __name__ == "__main__":
    main()
