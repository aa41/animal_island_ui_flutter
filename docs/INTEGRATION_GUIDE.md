# Integration Guide

本文档面向业务项目接入 `animal_island_ui_flutter` 的场景。当前组件库支持 Animal Island / 动森、NES 八位机像素、Westworld / Rehoboam 科幻系统、国风手绘风格，并保留统一 `Animal*` 组件 API。

## 1. 选择接入方式

### Git 依赖

适合团队共享和 CI 使用：

```yaml
dependencies:
  animal_island_ui_flutter:
    git:
      url: git@github.com:aa41/animal_island_ui_flutter.git
```

### Path 依赖

适合本地联调：

```yaml
dependencies:
  animal_island_ui_flutter:
    path: ../animal_island_ui_flutter
```

## 2. 配置主题

推荐直接采用库提供的主题入口：

```dart
MaterialApp(
  theme: buildAnimalIslandTheme(
    mode: AnimalIslandThemeMode.day,
    gameStyle: AnimalIslandGameStyle.animalIsland,
  ),
  darkTheme: buildAnimalIslandTheme(
    mode: AnimalIslandThemeMode.night,
    gameStyle: AnimalIslandGameStyle.animalIsland,
  ),
  themeMode: ThemeMode.system,
  home: const HomePage(),
);
```

如果业务需要手动切换：

```dart
final mode = isNight
    ? AnimalIslandThemeMode.night
    : AnimalIslandThemeMode.day;
final gameStyle = switch (selectedStyle) {
  'nes' => AnimalIslandGameStyle.nes8Bit,
  'westworld' => AnimalIslandGameStyle.westworld,
  'guofeng' => AnimalIslandGameStyle.guofengDoodle,
  _ => AnimalIslandGameStyle.animalIsland,
};

MaterialApp(
  theme: buildAnimalIslandTheme(mode: mode, gameStyle: gameStyle),
  home: const HomePage(),
);
```

内置游戏风格：

- `AnimalIslandGameStyle.animalIsland`：动森系自然 UI，大圆角、暖色、NookPhone 氛围
- `AnimalIslandGameStyle.nes8Bit`：NES 八位机像素 UI，像素字体、粗描边、硬阴影、低帧率动效
- `AnimalIslandGameStyle.westworld`：Westworld / Rehoboam 科幻系统 UI，细线折角、编号式信息层级、动态状态圆
- `AnimalIslandGameStyle.guofengDoodle`：国风手绘 UI，米纸底、墨线边框、朱砂/竹青点缀、手绘状态图

如果业务希望显式使用 NES 入口：

```dart
import 'package:animal_island_ui_flutter/nes_ui_flutter.dart';
```

## 3. 推荐起步组件

通常先用下面这批组件搭骨架：

- `AnimalCard`
- `AnimalButton`
- `AnimalDivider`
- `AnimalBadge`
- `AnimalTabs`
- `AnimalCollapse`

表单与状态常用：

- `AnimalInput`
- `AnimalSelect`
- `AnimalCheckboxGroup`
- `AnimalSwitch`
- `AnimalSlider`
- `AnimalLoading`
- `AnimalErrorState`
- `AnimalEmptyState`

列表流常用：

- `AnimalPullToRefresh`
- `AnimalLoadMoreFooter`

## 4. 弹窗接入

推荐优先使用 `showAnimalDialog(...)`：

```dart
showAnimalDialog<void>(
  context: context,
  title: const Text('博物馆捐赠'),
  child: const Text('是否愿意把这条鱼捐赠给博物馆？'),
);
```

若需要嵌入式控制，也可以直接使用 `AnimalModal`。

## 5. 页面设计约束

- 不要退化成默认 Material 3 平面 UI
- 动森主题不要用冷灰和纯黑替代暖色系统
- 动森夜间模式不是黑底霓虹，而是“夜里的岛”
- NES 主题不要混入动森叶子、圆形奖章、柔光阴影和大圆角 pill 作为核心视觉
- NES loading / empty / error / switch loading 等反馈应使用像素块、点阵或硬边 painter
- Westworld 主题不要做成霓虹赛博朋克、玻璃拟态或复杂 3D HUD；控件必须保持可识别的移动端交互语义
- 国风手绘主题不要做成古风营销海报或重纹理卷轴；组件应保持轻量、清晰、可操作
- 交互状态保持克制，避免抖动和夸张发光

## 6. AI 技能接入

将技能包复制到业务项目：

```bash
./tool/copy_animal_island_skill.sh \
  --project /path/to/project \
  --claude-project \
  --codex-user
```

执行后会：

- 复制 `skill/flutter-animal-island-ui/`
- 写入项目级 `AGENTS.md`
- 写入项目级 `CLAUDE.md`
- 安装到 `~/.codex/skills/animal-island-ui-flutter/`

## 7. 建议验收流程

接入后至少执行：

```bash
flutter analyze
flutter test
```

如果项目包含 Web：

```bash
flutter build web
```

如果需要对照本仓库示例：

```bash
cd example
flutter run -d chrome
```

## 8. 常见注意事项

- 组件资源已封装在 package 内，无需业务侧手动复制 asset
- 主题请从 `buildAnimalIslandTheme(...)` 开始，不建议混用大量默认 `ThemeData`
- 若新增组件，请同步维护 day / night 与 animalIsland / nes8Bit 的结果
- 若需要 AI 代理持续稳定产出，请优先让其读取 `skill/flutter-animal-island-ui/SKILL.md`
- NES 设计依据和实现映射可参考 `docs/NES_8BIT_UI_RESEARCH.md`
