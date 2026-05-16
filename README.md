# Animal Island UI Flutter

纯 Flutter UI 组件库，完整复刻 Animal Island / 动森系设计语言，并扩展白天、夜晚双主题。

仓库现在只保留 Flutter 能力：

- 根目录是 Flutter library
- `example/` 提供 Android / iOS / Web 调试与验收
- `skill/flutter-animal-island-ui/` 提供可复制的 Codex / Claude Code 技能包
- `tool/` 提供构建与技能复制脚本

## 特性

- 纯 UI 组件库，不包含任何业务原生桥接代码
- 保持统一的暖色、圆角、3D 压感、NookPhone 风格视觉语言
- 支持 `AnimalIslandThemeMode.day` / `AnimalIslandThemeMode.night`
- 提供完整 example，用于组件展示和跨平台测试
- 支持将技能包复制到其他项目，方便安全接入 Codex 与 Claude Code

## 组件能力

当前库已包含：

- 基础交互：`AnimalButton`、`AnimalInput`、`AnimalSwitch`、`AnimalSlider`
- 容器与反馈：`AnimalCard`、`AnimalCollapse`、`AnimalModal`、`showAnimalDialog`
- 选择与导航：`AnimalSelect`、`AnimalCheckboxGroup`、`AnimalTabs`
- 装饰与展示：`AnimalBadge`、`AnimalDivider`、`AnimalFooter`、`AnimalCodeBlock`
- 游戏化组件：`AnimalIcon`、`AnimalCursor`、`AnimalPhone`、`AnimalTime`、`AnimalTypewriter`
- 状态与列表：`AnimalLoading`、`AnimalErrorState`、`AnimalEmptyState`、`AnimalPullToRefresh`、`AnimalLoadMoreFooter`

## 仓库结构

```text
lib/                             Flutter library 入口与组件源码
example/                         Android / iOS / Web 示例工程
assets/animal_island/            组件使用的包内资源
skill/flutter-animal-island-ui/  Flutter 技能包
test/                            组件级测试
tool/                            构建与技能复制脚本
```

## 快速开始

### 1. 通过 Git 依赖接入

```yaml
dependencies:
  animal_island_ui_flutter:
    git:
      url: git@github.com:aa41/animal_island_ui_flutter.git
```

### 2. 或通过本地路径接入

```yaml
dependencies:
  animal_island_ui_flutter:
    path: ../animal_island_ui_flutter
```

### 3. 应用主题

```dart
import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';

MaterialApp(
  theme: buildAnimalIslandTheme(mode: AnimalIslandThemeMode.day),
  darkTheme: buildAnimalIslandTheme(mode: AnimalIslandThemeMode.night),
  home: const MyHomePage(),
);
```

### 4. 使用组件

```dart
import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              onPressed: () {},
              child: const Text('开始岛屿生活'),
            ),
            const SizedBox(height: 16),
            const AnimalCard(
              child: Text('欢迎来到新的动物森友会风格 Flutter 组件库。'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 本地开发

```bash
flutter pub get
flutter analyze
flutter test

cd example
flutter pub get
flutter run -d chrome
```

一键校验：

```bash
./tool/build_flutter_package.sh
```

## Example 平台支持

`example/` 当前保留以下测试能力：

- Android
- iOS
- Web

说明：

- 根库本身是纯 UI package
- 平台目录只存在于 `example/` 中，用于运行和验证组件表现

## 技能包复制

将 Flutter 技能包复制到其他项目，并同步安装到 Claude Code / Codex：

```bash
./tool/copy_animal_island_skill.sh \
  --project /path/to/your-project \
  --claude-project \
  --codex-user
```

脚本会完成：

- 复制 `skill/flutter-animal-island-ui/`
- 写入项目级 `AGENTS.md`
- 写入项目级 `CLAUDE.md`
- 安装到 `~/.codex/skills/animal-island-ui-flutter/`

## 文档

- [README.flutter.md](./README.flutter.md)：快速接入速查
- [docs/INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md)：完整接入指南
- [example/README.md](./example/README.md)：示例工程说明
- [skill/flutter-animal-island-ui/SKILL.md](./skill/flutter-animal-island-ui/SKILL.md)：Flutter 设计技能
- [CONTRIBUTING.md](./CONTRIBUTING.md)：贡献说明

## 设计原则

- 不退化成默认 Material 平面风格
- 保持温暖自然配色、奶油底、木色文字和柔和阴影
- 白天与夜晚主题属于同一世界观，而不是两套无关主题
- 新组件优先复用现有 token、动画节奏和圆角体系

## License

MIT
