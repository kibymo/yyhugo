#!/usr/bin/env bash
# Regenerate content/works/*.md from data/projects.json
# Run after editing projects.json
set -euo pipefail
cd "$(dirname "$0")"

python3 << 'PYEOF'
import json
from pathlib import Path

ROOT = Path("/home/dink/projects/yyled-portfolio")
data = json.loads((ROOT / "data" / "projects.json").read_text(encoding="utf-8"))

content_dir = ROOT / "content" / "works"
content_dir.mkdir(parents=True, exist_ok=True)

# Section landing
(content_dir / "_index.md").write_text("""---
title: 作品集
description: 永昱 LED 歷年實績照 · 一般方案 12 件、租賃方案 14 件
---
""", encoding="utf-8")

# Per-project pages
for p in data["projects"]:
    fm = ["---", f"title: \"{p['title']}\"", f"slug: {p['slug']}", f"category: {p['category']}"]
    if p.get("title_en"): fm.append(f"title_en: \"{p['title_en']}\"")
    if p.get("industry"): fm.append(f"industry: {p['industry']}")
    if p.get("location"): fm.append(f"location: \"{p['location']}\"")
    if p.get("year"):     fm.append(f"year: {p['year']}")
    if p.get("scope"):    fm.append(f"scope: \"{p['scope']}\"")
    if p.get("kwh_saved_pct") is not None: fm.append(f"kwh_saved_pct: {p['kwh_saved_pct']}")
    if p.get("cover"):    fm.append(f"cover: \"{p['cover']}\"")
    if p.get("tags"):     fm.append(f"tags: [{', '.join(p['tags'])}]")
    if p.get("featured"): fm.append("featured: true")
    fm.append("---")
    fm.append("")
    fm.append(p.get("summary") or f"{p['title']} 的 LED 照明工程實績。")
    fm.append("")
    (content_dir / f"{p['slug']}.md").write_text("\n".join(fm), encoding="utf-8")

print(f"✅ Generated {len(data['projects'])} markdown files")
PYEOF
