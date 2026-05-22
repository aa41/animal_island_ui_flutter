---
name: animal-island-ui-flutter-style
description: >
  使用 animal-island-ui 的 Flutter 复刻版与 NES 八位机像素主题设计语言创建、复刻或扩展页面与组件。
  当用户需要：
  (1) 用动物森友会 / Animal Crossing 风格构建 Flutter UI；
  (2) 使用 animal_island_ui_flutter 组件库开发界面；
  (3) 用 NES / 八位机 / 像素游戏风格构建 Flutter UI；
  (4) 在白天 / 夜晚、动森 / NES 等游戏主题下保持统一组件 API；
  (5) 复用本仓库的 Flutter 设计 token、组件规范、demo 布局或技能包；
  (6) 审查 Flutter 页面是否偏离 Animal Island 或 NES 八位机设计语言时，必须使用此 skill。
---

# Animal Game UI Flutter 设计技能

> 文档拆分：
> - `references/tokens.md`：设计 token、色板、尺寸、主题切换策略
> - `references/components.md`：组件映射、用法边界、补充组件规范
> - `references/demo.md`：example 页面结构、布局比例、演示还原要求
> - 仓库文档 `docs/NES_8BIT_UI_RESEARCH.md`：NES 八位机 UI 调研与实现映射

## 概述

这是 `animal_island-ui` 的 Flutter 纯 UI 复刻与多游戏风格主题技能。当前内置两套完整风格：

### Animal Island / 动森风格

- 温暖自然的大地色系
- 超圆角 pill 轮廓
- 游戏式 3D 压感按钮与输入框阴影
- 柔和且克制的 hover / active / reveal 动效
- 有机不规则轮廓和 NookPhone 式彩色应用卡面

### NES 八位机像素风格

- 高对比有限色板：蓝、黑、白、红、黄、绿、青为主
- Press Start 2P 像素字体与紧凑字号
- 方形或极小圆角，避免动森式有机 blob 轮廓
- 3px 级粗描边、零模糊硬阴影、像素网格感
- 低帧率、阶梯式交互反馈，避免柔和 spring 和 Material 圆形 loading
- `Loading / Empty / Error` 等状态必须使用像素图标 / `CustomPainter`，不要复用动森叶子、圆形奖章和柔光装饰

Flutter 包主入口：

- `lib/animal_island_ui_flutter.dart`
- `lib/animal_game_ui_flutter.dart`
- `lib/nes_ui_flutter.dart`
- `example/`

## 触发后先做什么

1. 先读 `references/tokens.md`
2. 再按任务范围读取 `references/components.md` 或 `references/demo.md`
3. 如果任务涉及 NES / 八位机 / 像素风，再读 `docs/NES_8BIT_UI_RESEARCH.md`
4. 如果是页面开发：
   - 优先使用现成组件
   - 缺失时允许增量补组件
   - 新组件必须复用同一套 token、主题扩展、圆角/像素边框、阴影、动画节奏

## 硬性规则

- 不要退化成默认 Material 3 平面风格
- 动森风格不要用冷灰、蓝灰替代暖棕和奶油底色
- 动森风格不要引入尖锐直角、细描边、过细字体
- 默认按移动端优先控制字号，不要把组件默认尺寸做成平板或桌面观感
- 中文 / 日文 / 韩文等东亚文案优先使用精致、小号、紧凑但可读的字号层级
- 不要用“整体放大字体”来制造可爱感，游戏感优先通过留白、圆角、色板、阴影和局部强调来表达
- 不要把夜间主题做成赛博紫或纯黑 AMOLED 风
- 动森夜间主题必须仍然像动森，只是更安静、偏暮色、低照度
- NES 风格不要使用动森叶子、NookPhone SVG、柔光圆形奖章作为核心反馈图形
- NES 风格不要使用 `CircularProgressIndicator` 作为 loading 主视觉；优先像素块、闪烁点阵、帧序列 `CustomPainter`
- NES 风格不要用大圆角 pill 或柔和 blur 阴影模拟像素 UI
- 所有新组件优先复用：
  - `AnimalIslandThemeData`
  - `AnimalIslandTokens`
  - `AnimalCard` / `AnimalButton` / `AnimalBadge`

## Flutter 实现约束

- 默认使用 `buildAnimalIslandTheme(mode: ..., gameStyle: ...)`
- 先对齐 `AnimalIslandTokens` 中的 typography scale，再写组件内局部覆盖
- 通过 `context.animalIslandTheme.isNes` 区分 NES 专属视觉，不要复制一套不兼容 API
- 新主题优先扩展 `AnimalIslandGameStyle` 和 `AnimalIslandThemeData` palette/token
- 页面容器优先使用：
  - `AnimalCard`
  - `AnimalDivider`
  - `AnimalFooter`
  - `AnimalTypewriter`
- 图标优先使用 `AnimalIcon`
- 资源从包内 `assets/animal_island/...` 读取，不要复制散落资源
- NES 核心图形优先 `CustomPainter` 或文本符号，减少对动森 SVG/PNG 的依赖
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

明暗模式：

- `AnimalIslandThemeMode.day`
  - 奶油、木色、草地、日照感
- `AnimalIslandThemeMode.night`
  - 暮蓝绿、低饱和木色、高对比浅暖文字
  - 不是黑底 neon，而是“夜里的岛”

游戏风格：

- `AnimalIslandGameStyle.animalIsland`
  - 动森系自然 UI，大圆角、暖色、柔和阴影
- `AnimalIslandGameStyle.nes8Bit`
  - NES 八位机 UI，像素字体、有限色板、硬边框、低帧率动效

设计依据：

- 动森官方页面强调“时间与季节与现实同步”
- 官方页面直接展示白天、落日、夜间氛围切换
- 游戏内存在 `Night Owl` ordinance，说明夜间生活节奏是合法世界观扩展
- NES UI 设计以 PPU 有限色板、8-bit 字体、网格化构图和硬边反馈为主要风格来源

## 组件清单

完整组件，动森与 NES 主题共享同一 API：

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

NES 主题特别注意：

- `AnimalSwitch.loading` 必须显示像素帧 loading，不显示 Material 圆形进度
- `AnimalCard(type: AnimalCardType.dashed)` 内容默认居中，适合像素占位/上传/空容器
- `AnimalLoading` / `AnimalEmptyState` / `AnimalErrorState` 使用 NES 专属像素状态图标
- `AnimalDivider` / `AnimalFooter` 在 NES 下使用 painter 生成像素线条/地形，不复用动森资源
- `AnimalIcon` / `AnimalPhone` 在 NES 下优先使用块状符号和字母 glyph，避免现代 SVG 质感

## 入口与初始化

```dart
import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';

MaterialApp(
  theme: buildAnimalIslandTheme(
    mode: AnimalIslandThemeMode.day,
    gameStyle: AnimalIslandGameStyle.animalIsland,
  ),
  home: const HomePage(),
);
```

NES 专用入口也可使用：

```dart
import 'package:animal_island_ui_flutter/nes_ui_flutter.dart';

MaterialApp(
  theme: buildAnimalIslandTheme(
    mode: AnimalIslandThemeMode.day,
    gameStyle: AnimalIslandGameStyle.nes8Bit,
  ),
  home: const HomePage(),
);
```

动态切换：

```dart
setState(() {
  gameStyle = gameStyle == AnimalIslandGameStyle.animalIsland
      ? AnimalIslandGameStyle.nes8Bit
      : AnimalIslandGameStyle.animalIsland;
});
```

## 页面开发规则

- Hero 区不要只放标题和按钮，必须有温暖氛围背景
- 组件展示页不要只有纵向表单，尽量还原 demo 的“卡片陈列 + 说明 + API + 示例代码”结构
- 宽屏下保留留白和分区层次
- 窄屏下优先保证阅读顺序、触控舒适区和组件完整显示
- NES 页面不做营销式大渐变 hero；优先做可操作面板、像素 HUD、网格菜单和硬边状态反馈

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

- 优先扩 token，不改组件比例
- 调整 surface / text / border / shadow / heroGradient
- 保证白天和夜晚切换后组件仍像同一套系统
- 新增游戏风格时扩展 `AnimalIslandGameStyle`，再补 palette、半径、边框、动效 token

### 3. 组件补齐

- 允许增加通用辅助组件
- 但必须在 `references/components.md` 中登记设计边界
- Bottom sheet 若要新增或改造，优先从 `NookPhone` / 岛上应用面板的暖色容器语言迁移，不要直接照搬系统原生 Material bottom sheet
- NES 组件补齐时优先使用 painter、方形布局和有限色板，不要套一层圆角 wrapper 伪装

## 输出风格

- 给出的 Flutter UI 代码要可直接运行
- 尽量封装成可复用组件，不写一次性杂糅页面
- 页面 demo 优先美观，其次才是极限抽象
