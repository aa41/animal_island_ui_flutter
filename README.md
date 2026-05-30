# Animal Island UI Flutter

纯 Flutter UI 组件库，完整复刻 Animal Island / 动森系设计语言，并提供 NES 八位机像素、Westworld / Rehoboam 科幻系统、国风手绘主题。组件 API 保持统一，可在不同游戏风格之间动态切换。

仓库现在只保留 Flutter 能力：

- 根目录是 Flutter library
- `example/` 提供 Android / iOS / Web 调试与验收
- `skill/flutter-animal-island-ui/` 提供可复制的 Codex / Claude Code 技能包
- `tool/` 提供构建与技能复制脚本

## 特性

- 纯 UI 组件库，不包含任何业务原生桥接代码
- 动森主题保持暖色、圆角、3D 压感、NookPhone 风格视觉语言
- NES 八位机主题提供马里奥式高饱和配色、圆润游戏字体、硬边轮廓、粗描边、零模糊阴影、低帧率动效
- Westworld / Rehoboam 主题提供克制黑白灰、细线折角、编号式信息层级和动态状态圆
- 国风手绘主题提供米纸底、墨线轮廓、朱砂/竹青点缀和手绘状态插画
- 支持 `AnimalIslandGameStyle.animalIsland` / `nes8Bit` / `westworld` / `guofengDoodle`
- 支持 `AnimalIslandThemeMode.day` / `AnimalIslandThemeMode.night`
- 同一批 `Animal*` 组件 API 支持跨游戏风格动态切换
- 提供完整 example，用于组件展示和跨平台测试
- 支持将技能包复制到其他项目，方便安全接入 Codex 与 Claude Code

## 游戏风格主题

当前内置四套完整游戏风格：

- `AnimalIslandGameStyle.animalIsland`
  - 动森系自然 UI
  - 奶油底、木色文字、草地/海岛氛围
  - 大圆角、柔和阴影、轻量 hover / active 动效
- `AnimalIslandGameStyle.nes8Bit`
  - NES 平台游戏 UI
  - 天空蓝、砖红、金币黄、管道绿等高对比有限色板，搭配圆润厚实的游戏字体
  - 方形/小圆角、粗描边、硬阴影、像素 loading / empty / error 状态
- `AnimalIslandGameStyle.westworld`
  - Westworld / Rehoboam 科幻系统 UI
  - 克制黑白灰、细线折角、扫描线、编号式标签
  - 动态 Rehoboam 状态圆、线性控件和系统面板
- `AnimalIslandGameStyle.guofengDoodle`
  - 国风手绘 UI
  - 米纸底、墨线边框、朱砂/竹青点缀、中文字体气质
  - 手绘 footer、国风状态图和轻量纸面层级

四套风格都支持 day / night，并共享同一套组件能力。业务层只需要切换 `gameStyle`，不需要替换组件。

## 组件能力

当前库已包含：

- 基础交互：`AnimalButton`、`AnimalInput`、`AnimalSwitch`、`AnimalSlider`
- 容器与反馈：`AnimalCard`、`AnimalCollapse`、`AnimalModal`、`showAnimalDialog`
- 选择与导航：`AnimalSelect`、`AnimalCheckboxGroup`、`AnimalTabs`
- 装饰与展示：`AnimalBadge`、`AnimalDivider`、`AnimalFooter`、`AnimalCodeBlock`
- 游戏化组件：`AnimalIcon`、`AnimalCursor`、`AnimalTypewriter`
- 状态与列表：`AnimalLoading`、`AnimalErrorState`、`AnimalEmptyState`、`AnimalStatusView`、`AnimalPullToRefresh`、`AnimalLoadMoreFooter`

NES、Westworld、国风手绘主题已覆盖上述组件，不是单独封装一批割裂 API。包括 `Switch.loading`、虚线卡片、`Loading / Empty / Error`、刷新和加载更多等反馈组件都会随 `gameStyle` 切换视觉与动效。

## 仓库结构

```text
lib/                             Flutter library 入口与组件源码
lib/animal_island_ui_flutter.dart 兼容主入口，导出全部组件能力
lib/animal_game_ui_flutter.dart   多游戏风格入口，面向后续主题扩展
lib/nes_ui_flutter.dart           NES 八位机主题入口
example/                         Android / iOS / Web 示例工程
assets/animal_island/            组件使用的包内资源
skill/flutter-animal-island-ui/  Flutter 技能包
docs/NES_8BIT_UI_RESEARCH.md     NES 八位机 UI 调研与实现映射
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
  theme: buildAnimalIslandTheme(
    mode: AnimalIslandThemeMode.day,
    gameStyle: AnimalIslandGameStyle.animalIsland,
  ),
  darkTheme: buildAnimalIslandTheme(
    mode: AnimalIslandThemeMode.night,
    gameStyle: AnimalIslandGameStyle.animalIsland,
  ),
  home: const MyHomePage(),
);
```

### 4. 动态切换游戏风格

```dart
AnimalIslandThemeMode mode = AnimalIslandThemeMode.day;
AnimalIslandGameStyle gameStyle = AnimalIslandGameStyle.animalIsland;

void cycleGameStyle() {
  setState(() {
    gameStyle = switch (gameStyle) {
      AnimalIslandGameStyle.animalIsland => AnimalIslandGameStyle.nes8Bit,
      AnimalIslandGameStyle.nes8Bit => AnimalIslandGameStyle.westworld,
      AnimalIslandGameStyle.westworld => AnimalIslandGameStyle.guofengDoodle,
      AnimalIslandGameStyle.guofengDoodle => AnimalIslandGameStyle.animalIsland,
    };
  });
}

MaterialApp(
  theme: buildAnimalIslandTheme(mode: mode, gameStyle: gameStyle),
  home: const MyHomePage(),
);
```

### 5. 使用组件

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
- [docs/NES_8BIT_UI_RESEARCH.md](./docs/NES_8BIT_UI_RESEARCH.md)：NES 八位机 UI 调研与实现映射
- [example/README.md](./example/README.md)：示例工程说明
- [skill/flutter-animal-island-ui/SKILL.md](./skill/flutter-animal-island-ui/SKILL.md)：Flutter 设计技能
- [CONTRIBUTING.md](./CONTRIBUTING.md)：贡献说明

## 设计原则

- 不退化成默认 Material 平面风格
- 动森风格保持温暖自然配色、奶油底、木色文字和柔和阴影
- NES 风格保持像素网格、有限色板、粗边框、硬阴影和低帧率反馈
- Westworld 风格保持克制黑白灰、细线折角、动态圆和明确移动端控件 affordance
- 国风手绘风格保持米纸底、墨线边框、手绘插画和轻量中文排版
- 白天与夜晚主题属于同一游戏风格下的明暗扩展，而不是两套无关主题
- 新组件优先复用现有 token、动画节奏、圆角/像素边框体系
- 新游戏风格优先扩展 `AnimalIslandGameStyle` 与主题 token，不复制一套不兼容组件 API

## License

MIT
