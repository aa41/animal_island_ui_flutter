# Example App

`example/` 是 `animal_island_ui_flutter` 的完整示例工程，用于跨平台调试和视觉验收。

## 支持平台

- Android
- iOS
- Web

## 本地运行

```bash
cd example
flutter pub get
flutter run -d chrome
```

如果需要指定其他设备：

```bash
flutter devices
flutter run -d <device-id>
```

## 测试与构建

```bash
flutter test
flutter build web
```

## 说明

- 示例工程依赖根目录 package：`animal_island_ui_flutter`
- 组件页用于校验各组件在 day / night 下的一致性
- 保留 Android / iOS / Web 工程文件，仅用于示例调试，不代表库内存在原生实现
