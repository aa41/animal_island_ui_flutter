# Components

## 组件映射

| React 原版 | Flutter 版 |
|---|---|
| `Button` | `AnimalButton` |
| `Input` | `AnimalInput` |
| `Switch` | `AnimalSwitch` |
| `Slider` | `AnimalSlider` |
| `Modal` | `AnimalModal` |
| `showDialog` 风格展示 | `showAnimalDialog` |
| `Card` | `AnimalCard` |
| `Collapse` | `AnimalCollapse` |
| `Select` | `AnimalSelect` |
| `Checkbox` | `AnimalCheckboxGroup` |
| `Icon` | `AnimalIcon` |
| `Time` | `AnimalTime` |
| `Phone` | `AnimalPhone` |
| `Footer` | `AnimalFooter` |
| `Divider` | `AnimalDivider` |
| `Cursor` | `AnimalCursor` |
| `Typewriter` | `AnimalTypewriter` |
| `Tabs` | `AnimalTabs` |
| `CodeBlock` | `AnimalCodeBlock` |

## Flutter 增量组件

### `AnimalBadge`

适用场景：

- API section 标签
- 小型状态标签
- 夜间模式 / New / Beta 之类的小 pill 标签

视觉规则：

- 仍然使用大圆角 pill
- 不做尖角 chip
- 不做过深描边
- 标签字号优先 `11-13`，不要做成厚重的大胶囊标题

### `AnimalStatusView`

适用场景：

- 页面级加载 / 错误 / 空状态
- 列表占位
- 局部卡片状态提示

视觉规则：

- 仍然使用大圆角暖色面板
- 中心视觉优先使用岛屿徽章 / 叶子 / 圆形轨道语义
- 操作按钮继续沿用现有按钮风格，不切回系统弹窗态
- 标题优先 `15-16`，说明文优先 `14-15`，避免空状态文案像弹窗大标题

### `AnimalSlider`

适用场景：

- 音量设置
- 游戏参数调节
- 范围选择

视觉规则：

- 轨道保持奶油底 + 薄荷主色
- 顶部数值使用 badge，而不是系统 tooltip
- 拖拽手柄要有轻微“浮起”感，不做扁平小圆点
- 数值标签优先 `11-13`，避免变成桌面端仪表盘大数字

### `AnimalPullToRefresh`

适用场景：

- 信息流
- 任务清单
- 岛民通知列表

视觉规则：

- 使用暖色面板而不是系统默认 spinner 顶栏
- 文案语气保持游戏内提示感
- 昼夜主题下都要保持“岛上 UI”而不是系统控件感
- 提示文案优先正文级 `14-15`，不要用大号提示字抢掉主要内容层级

### `AnimalLoadMoreFooter`

适用场景：

- 列表底部加载更多
- 滚动到末尾自动补页
- 错误重试 / 没有更多状态提示

视觉规则：

- 必须和下拉刷新共用同一套圆角 / 边框 / 色板
- 支持 `idle / loading / noMore / error`
- 不要退化成纯文本 “加载中...”
- 状态标签与按钮文案保持小巧，优先 `11-14`

## Typography 补充

- `AnimalButton` / `AnimalInput` / `AnimalCheckboxGroup` / `AnimalTabs` 默认使用紧凑交互字号，通常不超过 `14`
- `AnimalModal` 标题与正文必须明显收敛于移动端尺度，避免 `28+` 或大段 `18+` 文本
- `AnimalTime` / `AnimalPhone` 虽然允许展示型数字，但仍需保留“掌机 UI”感，不做桌面大屏信息牌

## 缺省优先级

如果页面需要常见容器或展示辅助能力，优先顺序：

1. 组合已有组件
2. 通过 `AnimalCard` 扩展
3. 最后才新增独立组件

## 不建议新增的方向

- 玻璃拟态
- 纯黑科技风 HUD
- 极简细线表单
- 密集企业后台表格风
