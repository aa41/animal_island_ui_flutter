# 国风手绘涂鸦 UI 设计与落地策略

## 风格检索结论

国风/国潮视觉通常以传统意象建立识别度：祥云、山水、水墨、竹叶、灯笼、印章红、金色点缀、玉石青绿和宣纸肌理。手绘涂鸦方向的关键不是“画得粗糙”，而是让控件边缘、图标线条、分割线、焦点态呈现轻微不规则，同时保持组件状态、间距和文字可读。

本项目适合落成“国风手绘涂鸦”主题，而不是一次性页面皮肤：现有 `AnimalIslandThemeMode.day/night`、`AnimalIslandGameStyle` 和 `theme_strategies/` 已经具备主题分发结构。

## 输出图片

- `01-guofeng-day-component-system.png`：白天完整组件系统图。
- `02-guofeng-night-component-system.png`：黑夜完整组件系统图。
- `03-guofeng-day-forms-controls-states.png`：白天表单与控件状态细节。
- `04-guofeng-night-forms-controls-states.png`：黑夜表单与控件状态细节。
- `05-guofeng-theme-implementation-map.png`：主题落地架构映射图。

## 建议 Token

白天：

- `pageBackground`: `0xFFF7F0DE`
- `surface`: `0xFFFFF8E8`
- `surfaceRaised`: `0xFFFFF3D2`
- `primary`: `0xFF1C9C8E`
- `primaryHover`: `0xFF35B8A8`
- `primaryActive`: `0xFF0F756B`
- `textPrimary`: `0xFF5C3A21`
- `textBody`: `0xFF6B5035`
- `border`: `0xFF6A4A2D`
- `borderLight`: `0xFFC9A56A`
- `warning`: `0xFFD9A441`
- `error`: `0xFFC83B2D`
- `success`: `0xFF4E8B45`
- `focusYellow`: `0xFFE8BF45`
- `buttonShadow`: `0xFFB98A4A`
- `inputShadow`: `0xFFD8B978`

黑夜：

- `pageBackground`: `0xFF101827`
- `surface`: `0xFF172235`
- `surfaceRaised`: `0xFF20304A`
- `surfaceSoft`: `0xFF263A56`
- `primary`: `0xFF55D0C3`
- `primaryHover`: `0xFF7FE4D9`
- `primaryActive`: `0xFF2BAEA1`
- `textPrimary`: `0xFFE9DCC3`
- `textBody`: `0xFFDCCAAE`
- `border`: `0xFFE0BE74`
- `borderLight`: `0xFF6E7891`
- `warning`: `0xFFF0C15A`
- `error`: `0xFFE45A44`
- `success`: `0xFF83B96D`
- `focusYellow`: `0xFFF0C15A`
- `buttonShadow`: `0xFF070B12`
- `inputShadow`: `0xFF070B12`

## Flutter 落地策略

1. 在 `AnimalIslandGameStyle` 增加 `guofengDoodle`。
2. 在 `AnimalIslandThemeSpec` 增加 `guofengDoodle`，保持 organic 形态，但让边框更像手绘：
   - `radiusSm`: 14
   - `radiusBase`: 20
   - `radiusLg`: 28
   - `radiusPill`: 50
   - `borderWidth`: 2.4
   - `inputBorderWidth`: 2.6
   - `buttonShadowRest`: 4
   - `buttonShadowHover`: 5
   - `buttonShadowPressed`: 1
3. 在 `AnimalIslandThemeFactory.resolve` 增加 `guofengDoodle/day` 与 `guofengDoodle/night` 分支。
4. 新增 `AnimalIslandThemeData.guofengDay` 和 `AnimalIslandThemeData.guofengNight`。
5. 在各 `theme_strategies` 中增加 `guofengDoodle` 分支。先覆盖高频组件：
   - `animal_button_theme_strategy.dart`
   - `animal_input_theme_strategy.dart`
   - `animal_switch_theme_strategy.dart`
   - `animal_slider_theme_strategy.dart`
   - `animal_select_theme_strategy.dart`
   - `animal_modal_theme_strategy.dart`
   - `animal_date_time_picker_theme_strategy.dart`
   - `animal_status_view_theme_strategy.dart`
6. 新增可复用绘制器：
   - `GuofengInkOutlinePainter`：用固定 seed 生成轻微抖动的圆角边框路径，避免每帧随机导致闪烁。
   - `GuofengPaperTexturePainter`：使用低透明度点纹、短线、云纹角标；不要每个组件都重绘大面积纹理，优先用于页面背景和大容器。
   - `GuofengCloudFocusPainter`：焦点态在外圈绘制淡金色云形短弧线。
7. 公共 API 不变，只通过主题策略切换视觉。

## 组件映射

- Button：玉青主按钮、宣纸默认按钮、朱砂 danger、毛笔虚线 dashed、loading 用斜向短刷纹。
- Input/Select：宣纸底、墨棕文字、焦点态金色云纹外圈、error 朱砂边、warning 金色边。
- Switch：轨道像手绘长印章，thumb 像玉扣；夜间 thumb 增加月色高光。
- Slider：轨道用粗细不均的笔线，thumb 可用圆形印泥或玉扣。
- Tabs：激活项使用朱砂小印章或玉青下划线，禁用态降低纹理对比。
- Modal/BottomSheet/Card：宣纸或夜纸底，大圆角加不规则墨线边框，阴影保持 flat offset。
- StatusView：空态用山水/祥云线稿，错误用朱砂断裂印章，loading 用旋转云纹。
- Divider/Footer/PullToRefresh：使用波浪云纹、竹叶短线和手绘分割线。

## 风险与约束

- 手绘边框不能依赖随机数实时变化，否则 hover/focus 动画会闪烁。
- 纹理要轻，避免影响表单文字可读性。
- 夜间主题不要变成纯蓝紫；朱砂、金色、玉青必须作为功能色保留。
- 图片中的中文标注可作为设计说明，不应直接作为应用内功能说明文案。
