# Contributing to animal_island_ui_flutter

欢迎提交 Issue 和 Pull Request。

## 提交 Issue

- 使用 GitHub Issues 描述 Bug、视觉偏差或组件能力缺口
- 建议附上：
  - 复现步骤
  - 预期行为
  - 实际行为
  - Flutter 版本
  - 设备 / 平台信息
  - 截图或录屏

## 提交 Pull Request

1. 基于 `main` 创建分支
2. 保持设计语言统一，不引入默认 Material 平面退化
3. 修改后执行：

```bash
flutter analyze
flutter test

cd example
flutter test
flutter build web
```

4. 提交信息建议使用 Conventional Commits

示例：

- `feat: add animal slider`
- `fix: align modal footer buttons`
- `docs: rewrite flutter integration guide`

## 本地开发

```bash
flutter pub get
flutter analyze
flutter test
./tool/build_flutter_package.sh
```

## 目录约定

```text
lib/src/components/      组件实现
lib/src/theme/           主题和 token
example/lib/             示例页面
skill/flutter-animal-island-ui/  技能包
test/                    组件测试
tool/                    脚本
```

## 组件扩展原则

- 优先复用 `AnimalIslandThemeData`
- 优先复用 `AnimalIslandTokens`
- 保持暖色、圆角、压感、游戏化动效
- 新组件需要同时考虑 day / night
- Example 中补齐演示与测试，不只改库代码

## License

MIT
