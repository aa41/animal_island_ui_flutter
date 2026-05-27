const Map<String, ({String title, String desc})>
pageInfo = <String, ({String title, String desc})>{
  'button': (
    title: 'Button 按钮',
    desc:
        '支持 primary / dashed / text / link / danger / ghost / loading / block 和三种尺寸。',
  ),
  'input': (
    title: 'Input 输入框',
    desc: '支持三种尺寸、清空按钮、prefix / suffix、warning / error 与阴影控制。',
  ),
  'switch': (title: 'Switch 开关', desc: '支持大小尺寸、受控与非受控、自定义文案与 loading。'),
  'slider': (title: 'Slider 滑杆', desc: '游戏式进度滑杆，支持数值徽标、分段与自定义标签。'),
  'card': (
    title: 'Card 卡片',
    desc: '支持默认 / title / dashed 类型与完整 NookPhone 调色板。',
  ),
  'collapse': (title: 'Collapse 折叠面板', desc: '保持温暖、圆润的 FAQ 容器和叶子装饰。'),
  'cursor': (title: 'Cursor 光标', desc: 'Web 下提供游戏手指光标覆盖体验。'),
  'modal': (title: 'Modal 弹窗', desc: '带有 blob clip-path 轮廓与可选打字机效果。'),
  'bottomsheet': (
    title: 'BottomSheet 底部面板',
    desc: '从 NookPhone 应用面板迁移出的底部弹出层，适合移动端操作与信息承载。',
  ),
  'refresh': (title: 'Refresh 刷新与加载更多', desc: '游戏化下拉刷新与加载更多页脚，适合信息流与任务清单。'),
  'typewriter': (title: 'Typewriter 打字机', desc: '对文本按字符揭示，适合对话和介绍区块。'),
  'divider': (title: 'Divider 分割线', desc: '提供五种动森式分隔线资源。'),
  'icon': (title: 'Icon 图标', desc: '完整复刻原版 10 个图标，并支持 bounce。'),
  'select': (title: 'Select 选择器', desc: '提供带光标装饰的游戏式悬浮菜单。'),
  'checkbox': (title: 'Checkbox 多选框', desc: '支持水平 / 垂直、三种尺寸、单项禁用和整组禁用。'),
  'tabs': (title: 'Tabs 标签页', desc: '支持受控 / 非受控、阴影控制与叶子摆动动画。'),
  'footer': (title: 'Footer 页脚', desc: '支持 sea / tree 两种页脚装饰。'),
  'codeblock': (title: 'CodeBlock 代码高亮', desc: '保留原版暖棕深色主题的代码展示组件。'),
  'datetime': (
    title: 'DateTime 日期时间',
    desc: 'NookPhone 风格日期时间选择器，支持日历、时间、快捷预设和弹出式选择。',
  ),
  'badge': (title: 'Badge 标签', desc: '根据统一设计语言补充的辅助标签组件。'),
  'loading': (title: 'Loading 加载态', desc: '统一的岛屿风格加载占位，可用于页面、列表或局部容器。'),
  'error': (title: 'Error 错误态', desc: '统一的错误提示与重试视图，保持游戏化语气和暖色反馈。'),
  'empty': (title: 'Empty 空状态', desc: '当内容为空时使用的游戏化占位与引导操作组件。'),
};

const List<String> basicComponentKeys = <String>[
  'button',
  'input',
  'switch',
  'slider',
  'card',
  'collapse',
  'cursor',
  'modal',
  'bottomsheet',
  'refresh',
  'typewriter',
  'divider',
  'icon',
  'select',
  'checkbox',
  'tabs',
  'footer',
  'codeblock',
  'badge',
  'loading',
  'error',
  'empty',
];

const List<String> complexComponentKeys = <String>['datetime'];
