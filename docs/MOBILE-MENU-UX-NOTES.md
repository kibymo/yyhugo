# yyled 手機版選單 UX 修整筆記

**日期**：2026-06-06
**範圍**：`themes/yyled/layouts/_partials/header.html` + `themes/yyled/layouts/_default/baseof.html`
**Commits**：`3d9f232` → `f026a59` → `5392069` → `6ba53e7`

---

## 三個問題的解法演進

### ① FAB 擋住手機選單

**症狀**：手機點開漢堡選單後，右下角 `LINE 詢價` 與 `02-2218-2849` 兩個浮動按鈕（z-50）壓在 Header（z-40）的下拉選單上，最後幾個項目被擋住點不到。

**嘗試過的解法**：
- 調 z-index → 失敗，會打亂 FAB 與 Lightbox、Footer CTA 的層級關係

**最終解法**：JS 控制顯示
```js
fab?.classList.toggle('hidden');              // 開選單 → 隱藏 FAB
fab?.classList.remove('hidden');              // 點連結或關閉 → 恢復
document.body.classList.toggle('overflow-hidden', !m.classList.contains('hidden'));  // 鎖滾動
```

**設計決策**：不動 z-index，直接切 `hidden` class，FAB 與選單互斥顯示最直觀。

---

### ② 漢堡按鈕 / 選單連結顏色看不到

**症狀**：手機點漢堡，內部連結看不到；以為是顏色和背景一樣。

**根因**（非表象）：
- `<button>` 與 `<a>` 都沒寫死顏色，只靠繼承 body 的 `text-ink`（`#E8E6E2`）
- 瀏覽器 user-agent 對 `<a>` 標籤有 `-webkit-link` 系統色覆寫（深色模式下行為不一致）
- Tailwind Play CDN 編譯 class 的時機與 DOMContentLoaded 不一定同步

**最終解法**：所有顏色寫死
```html
<button class="md:hidden ... text-ink hover:bg-white/10">
  <svg stroke-width="2.5">      <!-- 2 → 2.5 變粗 -->
</button>

<div style="background-color:#1A1815">   <!-- bg-base/95 → inline style -->
  <a class="text-ink hover:bg-white/10 hover:text-accent ... ">
```

**踩坑教訓**：Tailwind 動態顏色 utility（`bg-base/95`）依賴 Play CDN 編譯完成才生效，inline `style` 是 100% 可靠的後備。

---

### ③ 連結靠左、右側留白

**症狀**：選單打開後，連結文字（如 "作品集"）貼在最左邊，整列右側 80% 都是空白，視覺不平衡。

**根因**：
- 連結 `<a>` 是 `block` 滿版（tap 區要夠大）
- 文字卻 `text-left` 預設對齊
- 中文 3-4 字在 360px 寬螢幕只佔 60-80px

**最終解法**：iOS / Material 設定選單風格
```html
<a class="
  block                    /* 滿版 tap 區 */
  py-3.5                   /* 48px 高度，符合 Material Design 標準 */
  text-center              /* 置中對齊 */
  font-semibold            /* 字加粗 */
  bg-surface/60            /* 半透明卡片底 */
  hover:bg-surface         /* hover 加深 */
  hover:text-accent        /* hover 變金 */
  ring-1 ring-accent/40    /* 當前頁金色外框 */
">
```

**設計決策**：與其勉強用 icon 撐右側（增加視覺噪音），不如用「卡片式置中」把 tap 區與視覺重心一致化。`bg-surface/60` 在透明與實心之間取得平衡，不會壓過主視覺。

---

## 最終狀態

**桌面**（md 以上）：漢堡按鈕 `hidden`，顯示 9 個選項的水平 menu
**手機**（md 以下）：水平 menu `hidden`，漢堡按鈕顯示 → 點擊展開滿版卡片式選單

**JS 行為**：
- 點漢堡：menu ↔ close icon 切換、FAB 同步切換、body 鎖滾動
- 點選任一項：menu 自動收合、close icon 切回 menu icon、FAB 恢復、解開滾動鎖
- 點漢堡關閉：同上收合邏輯

**色彩規範**：
- 文字：`#E8E6E2` (ink) ↔ `#F5C842` (accent) on hover
- 背景：`#1A1815` (base) + `#25221E` (surface/60) 卡片
- 邊框：`white/10` 分隔線、`accent/40` 當前頁外框

---

## 學到的事

1. **深色模式 + Tailwind Play CDN = 顏色繼承陷阱**：顏色一定要寫死或用 inline style 兜底
2. **Tap target 要與視覺重心一致**：滿版 tap 區 + 置中文字 = 視覺平衡的最低成本解
3. **互斥顯示比調 z-index 簡單**：FAB 與 menu 不需要共存，直接切 `hidden` 永遠比改 layer 順序乾淨
4. **48px 是觸控黃金高度**：`py-3.5` (48px) 符合 Material Design / Apple HIG，tap accuracy 最高
5. **WebKit user-agent 對 `<a>` 不友善**：dark mode 下 a 標籤顏色繼承不可靠，務必 explicit `text-ink` / `text-accent`

---

## 還沒做的優化（未來 todo）

- [ ] 抽 JS 共用 toggle 函式（目前兩段重複的選單控制邏輯）
- [ ] 加 ARIA：`aria-expanded`、`aria-controls`、ESC 鍵關閉
- [ ] 選單開啟時加 `transition` 動畫（fade + slide）
- [ ] 把 `<details>` / `<dialog>` 改用原生 `<dialog>` 元素（無障礙更友善）
- [ ] 桌面 menu 也加 active 狀態 `ring`（目前只有 mobile 有）
