# Tokens

## 主题模式

- `AnimalIslandThemeMode.day`
- `AnimalIslandThemeMode.night`

## 游戏风格

- `AnimalIslandGameStyle.animalIsland`：有机圆角、暖色、柔和阴影、NookPhone 氛围
- `AnimalIslandGameStyle.nes8Bit`：圆润游戏字体、硬边框、马里奥式有限色板、低帧率动效
- `AnimalIslandGameStyle.westworld`：系统细线、黑白灰、编号、扫描线、Rehoboam 动态圆
- `AnimalIslandGameStyle.guofengDoodle`：米纸底、墨线、朱砂/竹青点缀、手绘状态图

## 日间主色

- primary: `#19C8B9`
- text primary: `#794F27`
- text body: `#725D42`
- border: `#9F927D`
- surface: `#F8F8F0`
- surface raised: `#F7F3DF`
- success: `#6FBA2C`
- warning: `#F5C31C`
- error: `#E05A5A`

## 夜间主色

- primary: `#61D9CD`
- text primary: `#F3EBD7`
- text body: `#E7DEC9`
- surface: `#26373C`
- surface raised: `#31474E`
- page background: `#162329`

## 间距

- xs: `4`
- sm: `8`
- md: `12`
- lg: `16`
- xl: `24`
- xxl: `32`

## 圆角

- sm: `12`
- base: `18`
- lg: `24`
- pill: `50`

NES 使用 `pixelRadiusSm/base/lg` 与 3px 级硬边框；Westworld 使用 0 圆角与 1px hairline；Guofeng 使用偏有机圆角但边缘更像手绘笔触。

## 核心尺寸

- button small: `32`
- button middle: `45`
- button large: `48`
- input middle: `40`
- switch default: `52 × 28`
- phone shell: `527 × 788`

## Typography

- micro: `10`
- caption: `11`
- body small: `12`
- label: `13`
- body: `14`
- body large: `15`
- title small: `16`
- title: `18`
- headline small: `20`
- headline: `24`
- display small: `30`
- display: `36`

移动端默认约束：

- 正文以 `14` 为基线
- 组件交互文本通常落在 `11-14`
- 标题通常落在 `16-20`
- 展示型大字默认不要超过 `36`

## 动效

- fast: `150ms`
- base: `250ms`
- slow: `350ms`
- curve: `Cubic(0.4, 0, 0.2, 1)`

风格节奏：

- Animal Island：柔和、短促、带轻微浮起感
- NES：阶梯式、低帧率、无 blur
- Westworld：线性扫描、sweep、pulse，不夸张发光
- Guofeng：轻量纸面/笔触显隐，不做弹跳或赛博扫描

## 视觉底线

- 文字永远偏暖，不偏冷灰
- 阴影优先使用暖棕或深青灰
- 高亮使用黄色或薄荷青，不用纯蓝焦点
- Westworld 例外：主色可保持黑白灰系统感，但不要变成霓虹紫蓝
- Guofeng 例外：可用墨色、朱砂、竹青点缀，但不要大面积金红或厚重纹理
