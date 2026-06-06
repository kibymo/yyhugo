# 永昱 LED 照明工程 — 作品集網站

現代化暗色調的 LED 照明工程作品集網站。建於 Hugo + Tailwind CSS，靜態生成、Netlify 部署。

## 技術棧

- **Hugo 0.147.3** — 靜態網站生成器
- **Tailwind CSS 3.x** — utility-first CSS（透過 CDN 載入）
- **Data-driven** — `data/projects.json` 是單一真相源
- **Netlify** — 自動部署，push 就 rebuild

## 結構

```
yyled-portfolio/
├── data/
│   └── projects.json           # 26 個專案、178 張照片
├── content/
│   ├── _index.md               # 首頁
│   ├── works/                  # 26 個專案 markdown + _index.md
│   ├── saveproject/            # 節能規劃案例（占位）
│   ├── aboutled/               # LED 知識（占位）
│   ├── about/                  # 關於我們（占位）
│   └── contact/                # 聯絡表單
├── static/
│   ├── projects/               # 178 張實績照
│   ├── css/site.css            # 自訂 CSS
│   └── favicon.svg
├── themes/yyled/
│   └── layouts/
│       ├── _default/
│       │   ├── baseof.html     # 整體布局（head、nav、footer）
│       │   └── single.html     # 通用內容頁
│       ├── _partials/
│       │   ├── header.html     # 導航列
│       │   └── footer.html     # 頁尾
│       ├── works/
│       │   ├── list.html       # 作品集列表 + 篩選
│       │   └── single.html     # 作品細節 + lightbox
│       └── index.html          # 首頁
├── hugo.toml                   # Hugo 設定
├── regenerate.sh               # 重新生成 content/works/*.md
└── README.md
```

## 開發

```bash
# 啟動開發伺服器
hugo server -D

# 訪問 http://localhost:1313
```

## 部署

1. Push 到 GitHub
2. Netlify 連接 repo，build command: `hugo`，publish dir: `public`
3. 自動 deploy

## 維護流程：新增 / 修改專案

1. 編輯 `data/projects.json`
2. 加上照片到 `static/projects/{slug}/`
3. 跑 `./regenerate.sh` 重新生成 `content/works/{slug}.md`
4. Push → Netlify 自動 deploy

## 設計

- **主色：** `#F5C842` 暖黃 LED accent
- **底色：** `#0F1419` 深色
- **字體：** Noto Sans TC + Inter
- **響應式：** < 640px 單欄、≥ 1024px 多欄
- **互動：** 篩選、Lightbox、鍵盤導覽（←→/ESC）

## 聯絡

電話 / LINE / Email 設定在 `hugo.toml` 的 `[params]`
