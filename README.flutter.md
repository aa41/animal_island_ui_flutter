# Flutter 接入速查

适用于希望快速把 `animal_island_ui_flutter` 接入现有项目的场景。

## 依赖方式

### Git

```yaml
dependencies:
  animal_island_ui_flutter:
    git:
      url: git@github.com:aa41/animal_island_ui_flutter.git
```

### Path

```yaml
dependencies:
  animal_island_ui_flutter:
    path: ../animal_island_ui_flutter
```

## 基础初始化

```dart
import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildAnimalIslandTheme(
        mode: AnimalIslandThemeMode.day,
        gameStyle: AnimalIslandGameStyle.animalIsland,
      ),
      darkTheme: buildAnimalIslandTheme(
        mode: AnimalIslandThemeMode.night,
        gameStyle: AnimalIslandGameStyle.nes8Bit,
      ),
      home: const HomePage(),
    );
  }
}
```

## 常用入口

```dart
import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';
```

主入口：

- `lib/animal_island_ui_flutter.dart`
- `lib/animal_game_ui_flutter.dart`
- `lib/nes_ui_flutter.dart`
- `buildAnimalIslandTheme(...)`
- `AnimalIslandGameStyle.animalIsland`
- `AnimalIslandGameStyle.nes8Bit`
- `AnimalIslandGameStyle.westworld`
- `AnimalIslandGameStyle.guofengDoodle`
- `AnimalIslandThemeMode.day`
- `AnimalIslandThemeMode.night`

## 动态切换游戏风格

```dart
setState(() {
  gameStyle = switch (gameStyle) {
    AnimalIslandGameStyle.animalIsland => AnimalIslandGameStyle.nes8Bit,
    AnimalIslandGameStyle.nes8Bit => AnimalIslandGameStyle.westworld,
    AnimalIslandGameStyle.westworld => AnimalIslandGameStyle.guofengDoodle,
    AnimalIslandGameStyle.guofengDoodle => AnimalIslandGameStyle.animalIsland,
  };
});

MaterialApp(
  theme: buildAnimalIslandTheme(mode: mode, gameStyle: gameStyle),
  home: const HomePage(),
);
```

## 常用组件

- `AnimalButton`
- `AnimalInput`
- `AnimalSwitch`
- `AnimalSlider`
- `AnimalCard`
- `AnimalModal`
- `showAnimalDialog`
- `AnimalLoading`
- `AnimalErrorState`
- `AnimalEmptyState`
- `AnimalPullToRefresh`
- `AnimalLoadMoreFooter`

## 推荐文档

- 详细接入：[docs/INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md)
- 示例工程：[example/README.md](./example/README.md)
- 技能包：[skill/flutter-animal-island-ui/SKILL.md](./skill/flutter-animal-island-ui/SKILL.md)
