---
name: animal-island-ui-flutter-style
description: >
  使用 animal-island-ui 的 Flutter 复刻版设计语言创建、复刻或扩展页面与组件。
  当用户需要：
  (1) 用动物森友会 / Animal Crossing 风格构建 Flutter UI；
  (2) 使用 animal_island_ui_flutter 组件库开发界面；
  (3) 在白天 / 夜晚双主题下保持统一的圆润自然游戏 UI；
  (4) 复用本仓库的 Flutter 设计 token、组件规范、demo 布局或技能包；
  (5) 审查 Flutter 页面是否偏离 Animal Island 设计语言时，必须使用此 skill。
---

# Animal Island UI Flutter 设计技能

> 文档拆分：
> - `references/tokens.md`：设计 token、色板、尺寸、主题切换策略
> - `references/components.md`：组件映射、用法边界、补充组件规范
> - `references/demo.md`：example 页面结构、布局比例、演示还原要求

## 概述

这是 `animal_island-ui` 的 Flutter 纯 UI 复刻技能。设计核心不变：

- 温暖自然的大地色系
- 超圆角 pill 轮廓
- 游戏式 3D 压感按钮与输入框阴影
- 柔和且克制的 hover / active / reveal 动效
- 有机不规则轮廓和 NookPhone 式彩色应用卡面

Flutter 包主入口：

- `lib/animal_island_ui_flutter.dart`
- `example/`

## 触发后先做什么

1. 先读 `references/tokens.md`
2. 再按任务范围读取 `references/components.md` 或 `references/demo.md`
3. 如果是页面开发：
   - 优先使用现成组件
   - 缺失时允许增量补组件
   - 新组件必须复用同一套 token、圆角、阴影、动画节奏

## 硬性规则

- 不要退化成默认 Material 3 平面风格
- 不要用冷灰、蓝灰替代暖棕和奶油底色
- 不要引入尖锐直角、细描边、过细字体
- 默认按移动端优先控制字号，不要把组件默认尺寸做成平板或桌面观感
- 中文 / 日文 / 韩文等东亚文案优先使用精致、小号、紧凑但可读的字号层级
- 不要用“整体放大字体”来制造可爱感，游戏感优先通过留白、圆角、色板、阴影和局部强调来表达
- 不要把夜间主题做成赛博紫或纯黑 AMOLED 风
- 夜间主题必须仍然像动森，只是更安静、偏暮色、低照度
- 所有新组件优先复用：
  - `AnimalIslandThemeData`
  - `AnimalIslandTokens`
  - `AnimalCard` / `AnimalButton` / `AnimalBadge`

## Flutter 实现约束

- 默认使用 `buildAnimalIslandTheme(...)`
- 先对齐 `AnimalIslandTokens` 中的 typography scale，再写组件内局部覆盖
- 页面容器优先使用：
  - `AnimalCard`
  - `AnimalDivider`
  - `AnimalFooter`
  - `AnimalTypewriter`
- 图标优先使用 `AnimalIcon`
- 资源从包内 `assets/animal_island/...` 读取，不要复制散落资源
- Example 页面要同时兼顾：
  - 移动端窄屏
  - Web / Desktop 宽屏

## Typography 约束

- 正文基线优先使用 `14`，长文默认不要超过 `15`
- 辅助信息 / 标签优先使用 `10-13`
- 按钮、输入框、checkbox、tabs 文本优先使用 `11-14`
- 卡片标题、表单区标题优先使用 `15-16`
- 区块标题、弹窗标题优先使用 `18-20`
- 只有 Hero、时间、核心数字展示允许突破正文层级，但默认也要控制在 `24-36`
- 避免在一个组件内同时出现过多大字号层级；移动端通常控制在 `2-3` 个文本层级内
- East Asian 风格下优先保证行高克制、字重柔和、密度精致，不做英文海报式巨型标题泛滥

## 双主题策略

- `AnimalIslandThemeMode.day`
  - 奶油、木色、草地、日照感
- `AnimalIslandThemeMode.night`
  - 暮蓝绿、低饱和木色、高对比浅暖文字
  - 不是黑底 neon，而是“夜里的岛”

设计依据：

- 动森官方页面强调“时间与季节与现实同步”
- 官方页面直接展示白天、落日、夜间氛围切换
- 游戏内存在 `Night Owl` ordinance，说明夜间生活节奏是合法世界观扩展

## 组件清单

完整组件：

- `AnimalButton`
- `AnimalInput`
- `AnimalSwitch`
- `AnimalSlider`
- `AnimalModal`
- `showAnimalDialog`
- `AnimalBottomSheet`
- `showAnimalBottomSheet`
- `AnimalCard`
- `AnimalCollapse`
- `AnimalSelect`
- `AnimalCheckboxGroup`
- `AnimalIcon`
- `AnimalTime`
- `AnimalPhone`
- `AnimalFooter`
- `AnimalDivider`
- `AnimalCursor`
- `AnimalTypewriter`
- `AnimalTabs`
- `AnimalCodeBlock`
- `AnimalBadge`
- `AnimalStatusView`
- `AnimalLoading`
- `AnimalErrorState`
- `AnimalEmptyState`
- `AnimalPullToRefresh`
- `AnimalLoadMoreFooter`

## 页面开发规则

- Hero 区不要只放标题和按钮，必须有温暖氛围背景
- 组件展示页不要只有纵向表单，尽量还原 demo 的“卡片陈列 + 说明 + API + 示例代码”结构
- 宽屏下保留留白和分区层次
- 窄屏下优先保证阅读顺序、触控舒适区和组件完整显示

## 复制到其他项目

优先使用仓库脚本：

```bash
./tool/copy_animal_island_skill.sh --project /path/to/project --claude-project --codex-user
```

脚本能力：

- 复制技能包到目标项目 `skill/flutter-animal-island-ui/`
- 复制技能包到目标项目 `.claude/skills/animal-island-ui-flutter/`
- 将技能安装到 `~/.codex/skills/animal-island-ui-flutter/`
- 追加 `AGENTS.md` / `CLAUDE.md` 指引，方便项目级自动使用

## 新组件 Checklist

- 是否复用现有 token？
- 默认字号是否先按移动端 scale 收敛，而不是先放大再回调？
- 是否保持暖色阴影和大圆角？
- 是否定义 day / night 两种视觉结果？
- hover / active 是否克制，不抖动、不花哨？
- 是否能放进现有 example 的展示框架？
- 是否会破坏原有 React 版设计语言统一性？

## 常见任务模式

### 1. 新页面

- 先用 `AnimalCard` / `AnimalButton` / `AnimalDivider` 组织骨架
- 再按需要补充 `AnimalTabs` / `AnimalCollapse` / `AnimalBadge`
- 文案强调温柔、轻松、游戏感

### 2. 主题扩展

- 仅扩 token，不改组件比例
- 调整 surface / text / border / shadow / heroGradient
- 保证白天和夜晚切换后组件仍像同一套系统

### 3. 组件补齐

- 允许增加通用辅助组件
- 但必须在 `references/components.md` 中登记设计边界
- Bottom sheet 若要新增或改造，优先从 `NookPhone` / 岛上应用面板的暖色容器语言迁移，不要直接照搬系统原生 Material bottom sheet

## 输出风格

- 给出的 Flutter UI 代码要可直接运行
- 尽量封装成可复用组件，不写一次性杂糅页面
- 页面 demo 优先美观，其次才是极限抽象
