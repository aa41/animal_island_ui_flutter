# Integration Guide

本文档面向业务项目接入 `animal_island_ui_flutter` 的场景。

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
  theme: buildAnimalIslandTheme(mode: AnimalIslandThemeMode.day),
  darkTheme: buildAnimalIslandTheme(mode: AnimalIslandThemeMode.night),
  themeMode: ThemeMode.system,
  home: const HomePage(),
);
```

如果业务需要手动切换：

```dart
final mode = isNight
    ? AnimalIslandThemeMode.night
    : AnimalIslandThemeMode.day;

MaterialApp(
  theme: buildAnimalIslandTheme(mode: mode),
  home: const HomePage(),
);
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
- 不要用冷灰和纯黑替代暖色系统
- 夜间模式不是黑底霓虹，而是“夜里的岛”
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
- 若新增组件，请同步维护 day / night 两套结果
- 若需要 AI 代理持续稳定产出，请优先让其读取 `skill/flutter-animal-island-ui/SKILL.md`
