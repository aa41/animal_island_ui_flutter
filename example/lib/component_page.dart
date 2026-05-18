import 'package:flutter/material.dart';

import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';

import 'demo_tools.dart';
import 'page_info.dart';

class ComponentPage extends StatelessWidget {
  const ComponentPage({
    super.key,
    required this.activeKey,
    required this.mode,
    required this.onToggleMode,
    required this.onNavigate,
  });

  final String activeKey;
  final AnimalIslandThemeMode mode;
  final VoidCallback onToggleMode;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final page = pageInfo[activeKey];
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 32,
        24,
        isMobile ? 16 : 40,
        40,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page?.title ?? activeKey,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        page?.desc ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.animalIslandTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile)
                  AnimalButton(
                    type: AnimalButtonType.primary,
                    size: AnimalButtonSize.small,
                    onPressed: onToggleMode,
                    child: Text(
                      mode == AnimalIslandThemeMode.day ? '夜晚模式' : '白天模式',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ..._buildSections(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    switch (activeKey) {
      case 'button':
        return [_buttonDemo(context)];
      case 'input':
        return [_inputDemo(context)];
      case 'switch':
        return [_switchDemo(context)];
      case 'slider':
        return [_sliderDemo(context)];
      case 'card':
        return [_cardDemo(context)];
      case 'collapse':
        return [_collapseDemo(context)];
      case 'cursor':
        return [_cursorDemo(context)];
      case 'modal':
        return [_modalDemo(context)];
      case 'bottomsheet':
        return [_bottomSheetDemo(context)];
      case 'refresh':
        return [_refreshDemo(context)];
      case 'typewriter':
        return [_typewriterDemo(context)];
      case 'divider':
        return [_dividerDemo(context)];
      case 'icon':
        return [_iconDemo(context)];
      case 'select':
        return [_selectDemo(context)];
      case 'checkbox':
        return [_checkboxDemo(context)];
      case 'tabs':
        return [_tabsDemo(context)];
      case 'footer':
        return [_footerDemo(context)];
      case 'codeblock':
        return [_codeblockDemo(context)];
      case 'time':
        return [_timeDemo(context)];
      case 'datetime':
        return [_dateTimeDemo(context)];
      case 'phone':
        return [_phoneDemo(context)];
      case 'badge':
        return [_badgeDemo(context)];
      case 'loading':
        return [_loadingDemo(context)];
      case 'error':
        return [_errorDemo(context)];
      case 'empty':
        return [_emptyDemo(context)];
      default:
        return [const SizedBox.shrink()];
    }
  }

  Widget _buttonDemo(BuildContext context) {
    return DemoSection(
      title: 'Button',
      tag: '6 types',
      description: '基础按钮、danger / ghost / loading / block 与三种尺寸。',
      children: [
        const DemoLabel('type 按钮类型'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            AnimalButton(
              type: AnimalButtonType.primary,
              onPressed: null,
              child: Text('Primary'),
            ),
          ],
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              onPressed: () {},
              child: const Text('Primary'),
            ),
            AnimalButton(
              type: AnimalButtonType.defaultType,
              onPressed: () {},
              child: const Text('Default'),
            ),
            AnimalButton(
              type: AnimalButtonType.dashed,
              onPressed: () {},
              child: const Text('Dashed'),
            ),
            AnimalButton(
              type: AnimalButtonType.text,
              onPressed: () {},
              child: const Text('Text'),
            ),
            AnimalButton(
              type: AnimalButtonType.link,
              onPressed: () {},
              child: const Text('Link'),
            ),
          ],
        ),
        const DemoLabel('danger / ghost / loading / disabled'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              danger: true,
              onPressed: () {},
              child: const Text('Danger'),
            ),
            AnimalButton(
              type: AnimalButtonType.primary,
              ghost: true,
              onPressed: () {},
              child: const Text('Ghost'),
            ),
            AnimalButton(
              type: AnimalButtonType.primary,
              loading: true,
              onPressed: () {},
              child: const Text('Loading'),
            ),
            const AnimalButton(
              type: AnimalButtonType.primary,
              enabled: false,
              child: Text('Disabled'),
            ),
          ],
        ),
        const DemoLabel('size 尺寸'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              size: AnimalButtonSize.small,
              onPressed: () {},
              child: const Text('Small'),
            ),
            AnimalButton(
              type: AnimalButtonType.primary,
              size: AnimalButtonSize.middle,
              onPressed: () {},
              child: const Text('Middle'),
            ),
            AnimalButton(
              type: AnimalButtonType.primary,
              size: AnimalButtonSize.large,
              onPressed: () {},
              child: const Text('Large'),
            ),
          ],
        ),
        const DemoLabel('icon 图标按钮'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              icon: const Text('🔍'),
              onPressed: () {},
              child: const Text('搜索'),
            ),
            AnimalButton(
              type: AnimalButtonType.defaultType,
              icon: const Text('⭐'),
              onPressed: () {},
              child: const Text('收藏'),
            ),
            AnimalButton(
              type: AnimalButtonType.dashed,
              icon: const Text('＋'),
              onPressed: () {},
              child: const Text('新增'),
            ),
          ],
        ),
        const DemoLabel('block 块级按钮'),
        DemoBox(
          child: AnimalButton(
            type: AnimalButtonType.primary,
            block: true,
            onPressed: () {},
            child: const Text('Block Button'),
          ),
        ),
        const DemoLabel('danger 组合'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              danger: true,
              onPressed: () {},
              child: const Text('Primary Danger'),
            ),
            AnimalButton(
              type: AnimalButtonType.defaultType,
              danger: true,
              onPressed: () {},
              child: const Text('Default Danger'),
            ),
            AnimalButton(
              type: AnimalButtonType.dashed,
              danger: true,
              onPressed: () {},
              child: const Text('Dashed Danger'),
            ),
            AnimalButton(
              type: AnimalButtonType.text,
              danger: true,
              onPressed: () {},
              child: const Text('Text Danger'),
            ),
            AnimalButton(
              type: AnimalButtonType.link,
              danger: true,
              onPressed: () {},
              child: const Text('Link Danger'),
            ),
          ],
        ),
        const DemoCodeBlock(
          "AnimalButton(type: AnimalButtonType.primary, onPressed: () {}, child: const Text('开始冒险'));",
        ),
        const DemoApiTable(
          rows: [
            DemoApiRow(
              prop: 'type',
              desc: '按钮类型',
              type: 'AnimalButtonType',
              defaultValue: 'defaultType',
            ),
            DemoApiRow(
              prop: 'size',
              desc: '按钮尺寸',
              type: 'AnimalButtonSize',
              defaultValue: 'middle',
            ),
            DemoApiRow(
              prop: 'danger',
              desc: '危险态',
              type: 'bool',
              defaultValue: 'false',
            ),
            DemoApiRow(
              prop: 'ghost',
              desc: '幽灵按钮',
              type: 'bool',
              defaultValue: 'false',
            ),
            DemoApiRow(
              prop: 'block',
              desc: '块级按钮',
              type: 'bool',
              defaultValue: 'false',
            ),
            DemoApiRow(
              prop: 'loading',
              desc: '加载态',
              type: 'bool',
              defaultValue: 'false',
            ),
            DemoApiRow(
              prop: 'onPressed',
              desc: '点击回调',
              type: 'VoidCallback?',
              defaultValue: '-',
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputDemo(BuildContext context) {
    return const _InputDemoSection();
  }

  Widget _switchDemo(BuildContext context) {
    return const _SwitchDemoSection();
  }

  Widget _sliderDemo(BuildContext context) {
    return const _SliderDemoSection();
  }

  Widget _cardDemo(BuildContext context) {
    final colors = <String>[
      'default',
      'app-pink',
      'purple',
      'app-blue',
      'app-yellow',
      'app-orange',
      'app-teal',
      'app-green',
      'app-red',
      'lime-green',
      'yellow-green',
      'brown',
      'warm-peach-pink',
    ];
    return DemoSection(
      title: 'Card',
      tag: '3 types / 13 colors',
      description: '默认、标题与虚线卡片，以及全部 NookPhone 色板。',
      children: [
        const DemoLabel('type 类型'),
        DemoBox(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              SizedBox(width: 180, child: AnimalCard(child: Text('基础卡片'))),
              SizedBox(
                width: 320,
                child: AnimalCard(
                  child: Text(
                    '在 Nintendo 3DS 系列作品中制作的设计二维码，也能在新的岛屿生活里继续继承与展示。',
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: AnimalCard(
                  type: AnimalCardType.title,
                  child: Text('Title 标题卡片'),
                ),
              ),
              SizedBox(
                width: 320,
                child: AnimalCard(
                  type: AnimalCardType.title,
                  child: Text('欢迎来到无人岛！标题卡片适合做功能入口、Hero 标签或重点说明。'),
                ),
              ),
              SizedBox(
                width: 180,
                child: AnimalCard(
                  type: AnimalCardType.dashed,
                  child: Text('虚线边框卡片'),
                ),
              ),
              SizedBox(
                width: 320,
                child: AnimalCard(
                  type: AnimalCardType.dashed,
                  child: Text('欢迎来到无人岛！虚线边框更适合轻量提示、次级信息和辅助操作区。'),
                ),
              ),
            ],
          ),
        ),
        const DemoLabel('color 色板'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors
              .map(
                (color) => SizedBox(
                  width: 180,
                  child: AnimalCard(color: color, child: Text(color)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _collapseDemo(BuildContext context) {
    return DemoSection(
      title: 'Collapse',
      tag: 'FAQ',
      description: '使用柔和边框、叶子装饰和无测量展开动画的 FAQ 容器。',
      children: const [
        DemoLabel('基础用法'),
        AnimalCollapse(
          question: Text('1 个岛屿可以登记多少名用户？'),
          answer: Text('1 座岛屿最多可以容纳 8 位居民（用户）。'),
        ),
        SizedBox(height: 12),
        AnimalCollapse(
          question: Text('可以多少人一起玩？'),
          answer: Text('同住 1 个岛的居民最多 4 人一起游玩。通过联机最多 8 人一起游玩。'),
        ),
        SizedBox(height: 20),
        DemoLabel('defaultExpanded 默认展开'),
        AnimalCollapse(
          defaultExpanded: true,
          question: Text('这个问题默认展开'),
          answer: Text('答案已经展示出来了，可以点击再次收起。'),
        ),
        SizedBox(height: 20),
        DemoLabel('disabled 禁用状态'),
        AnimalCollapse(
          enabled: false,
          question: Text('这个问题已被禁用（无法展开）'),
          answer: Text('这段内容不应该被看到。'),
        ),
      ],
    );
  }

  Widget _cursorDemo(BuildContext context) {
    return DemoSection(
      title: 'Cursor',
      tag: 'Web only',
      description: '在 Web 环境下用游戏手指光标包裹内容区。',
      children: const [
        DemoBox(child: Text('在 Web 上移动鼠标即可看到手指光标。移动端和原生桌面端不会强制覆盖默认指针。')),
      ],
    );
  }

  Widget _modalDemo(BuildContext context) {
    return const _ModalDemoSection();
  }

  Widget _bottomSheetDemo(BuildContext context) {
    return const _BottomSheetDemoSection();
  }

  Widget _refreshDemo(BuildContext context) {
    return const _RefreshDemoSection();
  }

  Widget _typewriterDemo(BuildContext context) {
    return DemoSection(
      title: 'Typewriter',
      tag: 'text reveal',
      description: '适合 Hero 简介、弹窗对话和说明文案的逐字揭示。',
      children: const [
        DemoBox(
          child: AnimalTypewriter(
            text: '欢迎来到无人岛。这里有海风、树影、晚霞，还有一套可以直接复用到 Flutter 项目里的可爱组件。',
            speed: 40,
          ),
        ),
      ],
    );
  }

  Widget _dividerDemo(BuildContext context) {
    return DemoSection(
      title: 'Divider',
      tag: '5 styles',
      description: '原版五种分割线资源全部可用。',
      children: const [
        DemoLabel('line-brown'),
        AnimalDivider(type: AnimalDividerType.lineBrown),
        DemoLabel('line-teal'),
        AnimalDivider(type: AnimalDividerType.lineTeal),
        DemoLabel('line-white'),
        AnimalDivider(type: AnimalDividerType.lineWhite),
        DemoLabel('line-yellow'),
        AnimalDivider(type: AnimalDividerType.lineYellow),
        DemoLabel('wave-yellow'),
        AnimalDivider(type: AnimalDividerType.waveYellow),
      ],
    );
  }

  Widget _iconDemo(BuildContext context) {
    return DemoSection(
      title: 'Icon',
      tag: '10 icons',
      description: '完整图标集、size 演示和 bounce 动效。',
      children: [
        const DemoLabel('基础用法'),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: kAnimalIslandIconList
              .map((item) => AnimalIcon(name: item.name, size: 32))
              .toList(),
        ),
        const DemoLabel('bounce 弹跳动画'),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: const [
            AnimalIcon(name: AnimalIconName.miles, size: 32, bounce: true),
            AnimalIcon(name: AnimalIconName.camera, size: 32, bounce: true),
            AnimalIcon(name: AnimalIconName.chat, size: 32, bounce: true),
          ],
        ),
      ],
    );
  }

  Widget _selectDemo(BuildContext context) {
    return const _SelectDemoSection();
  }

  Widget _checkboxDemo(BuildContext context) {
    return const _CheckboxDemoSection();
  }

  Widget _tabsDemo(BuildContext context) {
    return const _TabsDemoSection();
  }

  Widget _footerDemo(BuildContext context) {
    return DemoSection(
      title: 'Footer',
      tag: 'sea / tree',
      description: '完整保留原版海浪与树影页脚装饰。',
      children: const [
        DemoLabel('tree'),
        DemoBox(child: AnimalFooter(type: AnimalFooterType.tree)),
        DemoLabel('sea'),
        DemoBox(child: AnimalFooter(type: AnimalFooterType.sea)),
      ],
    );
  }

  Widget _codeblockDemo(BuildContext context) {
    return DemoSection(
      title: 'CodeBlock',
      tag: 'syntax',
      description: '延续原版深色暖棕代码展示风格。',
      children: const [
        AnimalCodeBlock(
          code:
              "import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';\n\nAnimalButton(\n  type: AnimalButtonType.primary,\n  onPressed: () {},\n  child: const Text('按钮'),\n);",
        ),
      ],
    );
  }

  Widget _timeDemo(BuildContext context) {
    return DemoSection(
      title: 'Time',
      tag: 'HUD',
      description: '经典 HUD 风格时间组件，实时刷新。',
      children: const [DemoBox(child: Center(child: AnimalTime()))],
    );
  }

  Widget _phoneDemo(BuildContext context) {
    return DemoSection(
      title: 'Phone',
      tag: 'NookPhone',
      description: '完整 3×3 应用布局、时间栏、徽章与底部分页图标。',
      children: const [
        DemoBox(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AnimalPhone(),
          ),
        ),
      ],
    );
  }

  Widget _badgeDemo(BuildContext context) {
    return DemoSection(
      title: 'Badge',
      tag: '增量补充',
      description: '根据日常 Flutter UI 开发需求补充的轻量标签组件，保持设计语言一致。',
      children: const [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AnimalBadge(label: '基础'),
            AnimalBadge(
              label: 'New',
              backgroundColor: Color(0xFFF5C31C),
              foregroundColor: Color(0xFF725D42),
            ),
            AnimalBadge(
              label: 'Night',
              backgroundColor: Color(0xFF31474E),
              foregroundColor: Color(0xFFF3EBD7),
            ),
          ],
        ),
      ],
    );
  }

  Widget _loadingDemo(BuildContext context) {
    return const _LoadingDemoSection();
  }

  Widget _errorDemo(BuildContext context) {
    return const _ErrorDemoSection();
  }

  Widget _emptyDemo(BuildContext context) {
    return const _EmptyDemoSection();
  }

  Widget _dateTimeDemo(BuildContext context) {
    return const _DateTimeDemoSection();
  }
}

class _DateTimeDemoSection extends StatefulWidget {
  const _DateTimeDemoSection();

  @override
  State<_DateTimeDemoSection> createState() => _DateTimeDemoSectionState();
}

class _DateTimeDemoSectionState extends State<_DateTimeDemoSection> {
  DateTime selected = DateTime(2026, 5, 18, 18, 30);

  String get summary =>
      '${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')} '
      '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}';

  Future<void> _openPicker(AnimalDateTimePickerMode mode) async {
    final result = await showAnimalDateTimePicker(
      context: context,
      mode: mode,
      initialValue: selected,
      firstDate: DateTime(2025, 1, 1, 0, 0),
      lastDate: DateTime(2027, 12, 31, 23, 59),
      minuteStep: 5,
    );

    if (result != null) {
      setState(() => selected = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'DateTime',
      tag: 'planner',
      description: '基于 NookPhone 小工具语言构建的日期时间选择器，支持月历、时间、快捷预设和弹出式调用。',
      children: [
        DemoBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  const AnimalBadge(label: 'Inline'),
                  AnimalBadge(
                    label: summary,
                    backgroundColor: const Color(0xFFE6F9F6),
                    foregroundColor: const Color(0xFF127F76),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AnimalDateTimePicker(
                value: selected,
                firstDate: DateTime(2025, 1, 1, 0, 0),
                lastDate: DateTime(2027, 12, 31, 23, 59),
                minuteStep: 5,
                onChanged: (value) => setState(() => selected = value),
              ),
            ],
          ),
        ),
        const DemoLabel('弹出式选择'),
        DemoBox(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () => _openPicker(AnimalDateTimePickerMode.dateTime),
                child: const Text('日期 + 时间'),
              ),
              AnimalButton(
                type: AnimalButtonType.defaultType,
                onPressed: () => _openPicker(AnimalDateTimePickerMode.date),
                child: const Text('仅日期'),
              ),
              AnimalButton(
                type: AnimalButtonType.defaultType,
                onPressed: () => _openPicker(AnimalDateTimePickerMode.time),
                child: const Text('仅时间'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InputDemoSection extends StatefulWidget {
  const _InputDemoSection();

  @override
  State<_InputDemoSection> createState() => _InputDemoSectionState();
}

class _InputDemoSectionState extends State<_InputDemoSection> {
  final controller = TextEditingController(text: '');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Input',
      tag: '3 sizes',
      description: '基础输入、allowClear、prefix / suffix、size、status、shadow。',
      children: [
        const DemoLabel('shadow 阴影控制'),
        DemoBox(
          child: Column(
            children: [
              AnimalInput(hintText: 'No shadow (default)', onChanged: (_) {}),
              const SizedBox(height: 12),
              AnimalInput(
                hintText: 'With shadow',
                shadow: true,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        const DemoLabel('基础用法'),
        DemoBox(
          child: Column(
            children: [
              AnimalInput(hintText: 'Basic input', onChanged: (_) {}),
              const SizedBox(height: 12),
              AnimalInput(
                controller: controller,
                hintText: 'With clear',
                allowClear: true,
                onChanged: (_) => setState(() {}),
                onClear: () => setState(() {}),
              ),
              const SizedBox(height: 12),
              AnimalInput(
                hintText: 'Prefix & Suffix',
                prefix: const Icon(Icons.search_rounded),
                suffix: const Icon(Icons.keyboard_return_rounded),
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        const DemoLabel('size 尺寸'),
        DemoBox(
          child: Column(
            children: const [
              AnimalInput(size: AnimalInputSize.small, hintText: 'Small'),
              SizedBox(height: 12),
              AnimalInput(size: AnimalInputSize.middle, hintText: 'Middle'),
              SizedBox(height: 12),
              AnimalInput(size: AnimalInputSize.large, hintText: 'Large'),
            ],
          ),
        ),
        const DemoLabel('status 校验状态'),
        DemoBox(
          child: Column(
            children: const [
              AnimalInput(status: AnimalInputStatus.error, hintText: 'Error'),
              SizedBox(height: 12),
              AnimalInput(
                status: AnimalInputStatus.warning,
                hintText: 'Warning',
              ),
            ],
          ),
        ),
        const DemoLabel('disabled 禁用'),
        const DemoBox(child: AnimalInput(enabled: false, hintText: 'Disabled')),
      ],
    );
  }
}

class _SwitchDemoSection extends StatefulWidget {
  const _SwitchDemoSection();

  @override
  State<_SwitchDemoSection> createState() => _SwitchDemoSectionState();
}

class _SwitchDemoSectionState extends State<_SwitchDemoSection> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Switch',
      tag: '2 sizes',
      description: '支持默认 / small、受控 / 非受控、自定义文案与 loading。',
      children: [
        const DemoLabel('基础用法'),
        DemoBox(
          child: Row(
            children: [
              AnimalSwitch(
                value: checked,
                onChanged: (value) => setState(() => checked = value),
              ),
              const SizedBox(width: 12),
              Text(checked ? 'ON' : 'OFF'),
            ],
          ),
        ),
        const DemoLabel('checkedChildren / unCheckedChildren'),
        const DemoBox(
          child: AnimalSwitch(
            initialValue: true,
            checkedChild: Text('开'),
            uncheckedChild: Text('关'),
          ),
        ),
        const DemoLabel('size / disabled / loading'),
        const DemoBox(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AnimalSwitch(initialValue: true),
              AnimalSwitch(size: AnimalSwitchSize.small, initialValue: true),
              AnimalSwitch(enabled: false),
              AnimalSwitch(initialValue: true, loading: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModalDemoSection extends StatefulWidget {
  const _ModalDemoSection();

  @override
  State<_ModalDemoSection> createState() => _ModalDemoSectionState();
}

class _ModalDemoSectionState extends State<_ModalDemoSection> {
  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Modal',
      tag: 'blob shape',
      description: '保留原始 SVG blob 轮廓，并补充标准 showDialog 风格调用入口。',
      children: [
        const DemoLabel('基础弹窗'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              onPressed: () {
                showAnimalDialog<void>(
                  context: context,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('钓到石头了！', textAlign: TextAlign.center),
                      SizedBox(height: 8),
                      Text('竟然连这种都能钓起来...', textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
              child: const Text('基础 Modal'),
            ),
            AnimalButton(
              type: AnimalButtonType.defaultType,
              onPressed: () {
                showAnimalDialog<void>(
                  context: context,
                  title: const Text('博物馆捐赠'),
                  child: const Text('是否愿意将这条鱼捐赠给博物馆呢？傅达会好好照顾它的！这可是博物馆的新展品哦~'),
                );
              },
              child: const Text('带标题 Modal'),
            ),
            AnimalButton(
              type: AnimalButtonType.dashed,
              onPressed: () {
                showAnimalDialog<void>(
                  context: context,
                  title: const Text('确认操作'),
                  footer: Wrap(
                    spacing: 12,
                    children: [
                      AnimalButton(
                        type: AnimalButtonType.defaultType,
                        onPressed: () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).maybePop(),
                        child: const Text('再想想'),
                      ),
                      AnimalButton(
                        type: AnimalButtonType.primary,
                        danger: true,
                        onPressed: () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).maybePop(),
                        child: const Text('确认搬家'),
                      ),
                    ],
                  ),
                  child: const Text('确定要让这位居民搬走吗？这个操作不可撤销。'),
                );
              },
              child: const Text('自定义 Footer'),
            ),
          ],
        ),
        const DemoLabel('关闭打字机 / 无 Footer'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              onPressed: () {
                showAnimalDialog<void>(
                  context: context,
                  title: const Text('天气预报'),
                  typewriter: false,
                  child: const Text('明天天气晴朗，气温 20-28°C，适合外出活动！'),
                );
              },
              child: const Text('关闭打字机效果'),
            ),
            AnimalButton(
              type: AnimalButtonType.defaultType,
              onPressed: () {
                showAnimalDialog<void>(
                  context: context,
                  footer: null,
                  typewriter: false,
                  child: const Text('这个弹窗没有底部按钮，点击遮罩即可关闭。'),
                );
              },
              child: const Text('无 Footer'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const DemoBox(
          child: Text(
            '现在无需额外包一层 Stack。业务中直接调用 showAnimalDialog(...) 即可展示带有同款 blob 轮廓和打字机效果的弹窗。',
          ),
        ),
        const DemoCodeBlock(
          "showAnimalDialog<void>(\n  context: context,\n  title: const Text('博物馆捐赠'),\n  child: const Text('欢迎来到无人岛！'),\n);",
        ),
      ],
    );
  }
}

class _BottomSheetDemoSection extends StatefulWidget {
  const _BottomSheetDemoSection();

  @override
  State<_BottomSheetDemoSection> createState() =>
      _BottomSheetDemoSectionState();
}

class _BottomSheetDemoSectionState extends State<_BottomSheetDemoSection> {
  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'BottomSheet',
      tag: 'mobile-first',
      description:
          '不是直接套用系统原生样式，而是从 NookPhone 的应用面板、任务说明与暖色菜单容器里提炼出一套更适合移动端的底部弹出层。',
      children: [
        const DemoLabel('基础调用'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              onPressed: () {
                showAnimalBottomSheet<void>(
                  context: context,
                  title: const Text('岛屿广播'),
                  child: const Text(
                    '狸克已经把今天的广播整理好了。现在海风正好，适合出门钓鱼、摘果子，或者去看看商店有没有新货。',
                  ),
                );
              },
              child: const Text('基础 BottomSheet'),
            ),
            AnimalButton(
              type: AnimalButtonType.defaultType,
              onPressed: () {
                showAnimalBottomSheet<void>(
                  context: context,
                  title: const Text('岛屿设置'),
                  footer: AnimalBottomSheetActionBar(
                    primaryLabel: '保存设置',
                    secondaryLabel: '返回',
                    onPrimaryPressed: () =>
                        Navigator.of(context, rootNavigator: true).maybePop(),
                    onSecondaryPressed: () =>
                        Navigator.of(context, rootNavigator: true).maybePop(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('• 公告板：向岛民显示活动通知'),
                      SizedBox(height: 8),
                      Text('• 岛歌：切换为傍晚版旋律'),
                      SizedBox(height: 8),
                      Text('• 访客权限：允许好友来访'),
                    ],
                  ),
                );
              },
              child: const Text('带操作区'),
            ),
            AnimalButton(
              type: AnimalButtonType.dashed,
              onPressed: () {
                showAnimalBottomSheet<void>(
                  context: context,
                  title: const Text('岛民委托'),
                  maxHeightRatio: 0.68,
                  typewriter: true,
                  child: const Text(
                    '麻烦帮我把这封信带给住在海边的邻居吧。听说他今天一早就在收拾花园，现在应该正好能找到他。',
                  ),
                );
              },
              child: const Text('带打字机效果'),
            ),
          ],
        ),
        const DemoLabel('嵌入式预览'),
        const DemoBox(
          child: SizedBox(
            height: 360,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18),
                      child: Text('用于移动端操作与信息承载的底部浮层预览'),
                    ),
                  ),
                ),
                AnimalBottomSheet(
                  open: true,
                  title: Text('出海准备清单'),
                  showCloseButton: false,
                  footer: AnimalBottomSheetActionBar(
                    primaryLabel: '开始出发',
                    secondaryLabel: '稍后再说',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('已经帮你准备好了钓竿、捕虫网和应急水果。'),
                      SizedBox(height: 12),
                      AnimalDivider(),
                      SizedBox(height: 12),
                      Text('• 钓竿耐久：良好'),
                      SizedBox(height: 6),
                      Text('• 捕虫网耐久：良好'),
                      SizedBox(height: 6),
                      Text('• 口袋剩余空位：12'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const DemoBox(
          child: Text(
            '建议把它用于移动端操作确认、轻量信息面板、任务说明、选择列表，而不是直接回退到系统原生的 Material bottom sheet 外观。',
          ),
        ),
        const DemoCodeBlock(
          "showAnimalBottomSheet<void>(\n  context: context,\n  title: const Text('岛屿广播'),\n  footer: AnimalBottomSheetActionBar(\n    primaryLabel: '知道了',\n    secondaryLabel: '稍后查看',\n  ),\n  child: const Text('今天的海风很舒服，适合出门逛逛。'),\n);",
        ),
        const DemoApiTable(
          rows: [
            DemoApiRow(prop: 'title', desc: '标题区内容', type: 'Widget?'),
            DemoApiRow(
              prop: 'footer',
              desc: '底部操作区，可传入自定义按钮组',
              type: 'Widget?',
            ),
            DemoApiRow(
              prop: 'maxWidth',
              desc: '面板最大宽度',
              type: 'double',
              defaultValue: '560',
            ),
            DemoApiRow(
              prop: 'maxHeightRatio',
              desc: '相对屏幕高度上限',
              type: 'double',
              defaultValue: '0.82',
            ),
            DemoApiRow(
              prop: 'showHandle',
              desc: '是否显示叶片把手',
              type: 'bool',
              defaultValue: 'true',
            ),
            DemoApiRow(
              prop: 'showCloseButton',
              desc: '是否显示右上角关闭按钮',
              type: 'bool',
              defaultValue: 'true',
            ),
            DemoApiRow(
              prop: 'typewriter',
              desc: '正文是否启用打字机效果',
              type: 'bool',
              defaultValue: 'false',
            ),
          ],
        ),
      ],
    );
  }
}

class _RefreshDemoSection extends StatefulWidget {
  const _RefreshDemoSection();

  @override
  State<_RefreshDemoSection> createState() => _RefreshDemoSectionState();
}

class _RefreshDemoSectionState extends State<_RefreshDemoSection> {
  final ScrollController _scrollController = ScrollController();

  late List<String> _items = _buildSeedItems(prefix: 'Day 1');
  AnimalLoadMoreState _loadMoreState = AnimalLoadMoreState.idle;
  int _refreshCount = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients ||
        _loadMoreState != AnimalLoadMoreState.idle) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 120) {
      _loadMore();
    }
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) {
      return;
    }

    setState(() {
      _refreshCount += 1;
      _items = _buildSeedItems(prefix: 'Day $_refreshCount');
      _loadMoreState = AnimalLoadMoreState.idle;
    });
  }

  Future<void> _loadMore() async {
    if (_loadMoreState == AnimalLoadMoreState.loading ||
        _loadMoreState == AnimalLoadMoreState.noMore) {
      return;
    }

    setState(() => _loadMoreState = AnimalLoadMoreState.loading);

    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) {
      return;
    }

    final nextItems = <String>[
      ..._items,
      ...List<String>.generate(
        4,
        (index) => '来自码头的新消息 ${_items.length + index + 1}',
      ),
    ];

    setState(() {
      _items = nextItems;
      _loadMoreState = nextItems.length >= 16
          ? AnimalLoadMoreState.noMore
          : AnimalLoadMoreState.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Refresh',
      tag: 'list flow',
      description: '补齐日常信息流场景里最高频的下拉刷新与加载更多，并严格沿用同一套暖色圆角与游戏化提示语气。',
      children: [
        const DemoLabel('实时示例'),
        DemoBox(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 440,
              child: AnimalPullToRefresh(
                onRefresh: _refresh,
                pullText: '再轻拉一下，海风就会带来新消息',
                releaseText: '松手刷新今日岛上公告',
                refreshingText: '狸克正在整理海滩上的漂流瓶...',
                completeText: '新的漂流瓶已经送到岸边',
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == _items.length) {
                      return AnimalLoadMoreFooter(
                        state: _loadMoreState,
                        onLoadMore: _loadMore,
                        idleText: '继续沿着码头向前逛逛',
                        loadingText: 'Kapp’n 正在把更多故事划过来...',
                        noMoreText: '今天的漂流瓶已经全部拾完啦',
                        errorText: '刚刚被浪花打断了，再试一次',
                        retryText: '重新出海',
                      );
                    }

                    final item = _items[index];
                    return AnimalCard(
                      child: Row(
                        children: [
                          const AnimalBadge(label: 'News'),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '海边风向、商店营业和岛民来信都会通过这类列表型页面呈现。',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const DemoLabel('footer 状态预览'),
        const Column(
          children: [
            AnimalLoadMoreFooter(idleText: '继续向前看看还有什么礼物'),
            SizedBox(height: 12),
            AnimalLoadMoreFooter(
              state: AnimalLoadMoreState.loading,
              loadingText: '邮轮正在靠岸，请稍等片刻',
            ),
            SizedBox(height: 12),
            AnimalLoadMoreFooter(
              state: AnimalLoadMoreState.noMore,
              noMoreText: '今天真的没有更多啦',
            ),
            SizedBox(height: 12),
            AnimalLoadMoreFooter(
              state: AnimalLoadMoreState.error,
              errorText: '网络在打盹，点按钮再试一次',
            ),
          ],
        ),
        const DemoCodeBlock(
          "AnimalPullToRefresh(\n  onRefresh: _refresh,\n  child: ListView(\n    physics: const AlwaysScrollableScrollPhysics(),\n    children: const [\n      AnimalLoadMoreFooter(),\n    ],\n  ),\n);",
        ),
      ],
    );
  }

  static List<String> _buildSeedItems({required String prefix}) {
    return List<String>.generate(8, (index) => '$prefix · 漂流瓶公告 ${index + 1}');
  }
}

class _SliderDemoSection extends StatefulWidget {
  const _SliderDemoSection();

  @override
  State<_SliderDemoSection> createState() => _SliderDemoSectionState();
}

class _SliderDemoSectionState extends State<_SliderDemoSection> {
  double volume = 42;

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Slider',
      tag: 'value control',
      description: '补齐日常表单和设置页常用的滑杆控件，保留奶油轨道、木色阴影和数值徽标。',
      children: [
        const DemoLabel('基础用法'),
        DemoBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimalSlider(
                value: volume,
                min: 0,
                max: 100,
                divisions: 10,
                leadingLabel: '静音',
                trailingLabel: '满格',
                onChanged: (value) => setState(() => volume = value),
              ),
              const SizedBox(height: 12),
              Text(
                '当前数值: ${volume.round()}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFFA08060)),
              ),
            ],
          ),
        ),
        const DemoLabel('自定义标签'),
        DemoBox(
          child: AnimalSlider(
            initialValue: 3,
            min: 1,
            max: 5,
            divisions: 4,
            leadingLabel: '小雨',
            trailingLabel: '暴雨',
            valueLabelBuilder: (value) => 'Lv.${value.round()}',
            onChanged: (_) {},
          ),
        ),
        const DemoLabel('禁用状态'),
        const DemoBox(
          child: AnimalSlider(
            initialValue: 68,
            enabled: false,
            leadingLabel: '低',
            trailingLabel: '高',
          ),
        ),
        const DemoCodeBlock(
          "AnimalSlider(\n  value: value,\n  min: 0,\n  max: 100,\n  divisions: 10,\n  leadingLabel: '静音',\n  trailingLabel: '满格',\n  onChanged: (next) => setState(() => value = next),\n);",
        ),
        const DemoApiTable(
          rows: [
            DemoApiRow(
              prop: 'value',
              desc: '受控值',
              type: 'double?',
              defaultValue: '-',
            ),
            DemoApiRow(
              prop: 'initialValue',
              desc: '非受控初始值',
              type: 'double',
              defaultValue: '50',
            ),
            DemoApiRow(
              prop: 'min / max',
              desc: '最小值与最大值',
              type: 'double',
              defaultValue: '0 / 100',
            ),
            DemoApiRow(
              prop: 'divisions',
              desc: '离散分段数',
              type: 'int?',
              defaultValue: '-',
            ),
            DemoApiRow(
              prop: 'leadingLabel / trailingLabel',
              desc: '轨道左右标签',
              type: 'String?',
              defaultValue: '-',
            ),
            DemoApiRow(
              prop: 'valueLabelBuilder',
              desc: '自定义顶部数值徽标',
              type: 'String Function(double)?',
              defaultValue: '-',
            ),
            DemoApiRow(
              prop: 'onChanged / onChangeEnd',
              desc: '数值变化回调',
              type: 'ValueChanged<double>?',
              defaultValue: '-',
            ),
          ],
        ),
      ],
    );
  }
}

class _LoadingDemoSection extends StatelessWidget {
  const _LoadingDemoSection();

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Loading',
      tag: 'status view',
      description: '统一页面级和局部区域的加载态，避免回退成默认 CircularProgressIndicator。',
      children: const [
        DemoLabel('完整加载面板'),
        DemoBox(
          child: AnimalLoading(
            title: '狸克正在整理今天的岛屿公告',
            message: '海风一吹，新的活动通知马上就会抵达。',
          ),
        ),
        DemoLabel('紧凑模式'),
        DemoBox(
          child: AnimalLoading(
            compact: true,
            title: '正在读取口袋菜单',
            message: '请稍等一下，马上就好。',
          ),
        ),
        DemoCodeBlock(
          "const AnimalLoading(\n  title: '狸克正在整理今天的岛屿公告',\n  message: '海风一吹，新的活动通知马上就会抵达。',\n);",
        ),
        DemoApiTable(
          rows: [
            DemoApiRow(
              prop: 'title',
              desc: '标题文案',
              type: 'String?',
              defaultValue: '内置默认文案',
            ),
            DemoApiRow(
              prop: 'message',
              desc: '说明文案',
              type: 'String?',
              defaultValue: '内置默认文案',
            ),
            DemoApiRow(
              prop: 'compact',
              desc: '紧凑模式',
              type: 'bool',
              defaultValue: 'false',
            ),
          ],
        ),
      ],
    );
  }
}

class _ErrorDemoSection extends StatefulWidget {
  const _ErrorDemoSection();

  @override
  State<_ErrorDemoSection> createState() => _ErrorDemoSectionState();
}

class _ErrorDemoSectionState extends State<_ErrorDemoSection> {
  int retryCount = 0;

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Error',
      tag: 'retry state',
      description: '统一错误提示、重试按钮和暖色反馈氛围，适合请求失败或加载中断场景。',
      children: [
        DemoBox(
          child: AnimalErrorState(
            title: '浪花把漂流瓶卷走了',
            message: retryCount == 0
                ? '刚刚的网络连接有些不稳定，请再试一次。'
                : '已重试 $retryCount 次，信号正在慢慢恢复。',
            onRetry: () => setState(() => retryCount += 1),
          ),
        ),
        const DemoLabel('紧凑模式'),
        const DemoBox(
          child: AnimalErrorState(
            compact: true,
            title: '地图同步失败',
            message: '请确认岛屿网络设置后再次尝试。',
          ),
        ),
        const DemoCodeBlock(
          "AnimalErrorState(\n  title: '浪花把漂流瓶卷走了',\n  message: '刚刚的网络连接有些不稳定，请再试一次。',\n  onRetry: _fetchAgain,\n);",
        ),
        const DemoApiTable(
          rows: [
            DemoApiRow(
              prop: 'title',
              desc: '错误标题',
              type: 'String?',
              defaultValue: '内置默认文案',
            ),
            DemoApiRow(
              prop: 'message',
              desc: '错误说明',
              type: 'String?',
              defaultValue: '内置默认文案',
            ),
            DemoApiRow(
              prop: 'actionLabel',
              desc: '重试按钮文案',
              type: 'String',
              defaultValue: '重新试试',
            ),
            DemoApiRow(
              prop: 'onRetry',
              desc: '点击重试回调',
              type: 'VoidCallback?',
              defaultValue: '-',
            ),
            DemoApiRow(
              prop: 'compact',
              desc: '紧凑模式',
              type: 'bool',
              defaultValue: 'false',
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyDemoSection extends StatelessWidget {
  const _EmptyDemoSection();

  @override
  Widget build(BuildContext context) {
    return DemoSection(
      title: 'Empty',
      tag: 'blank state',
      description: '为空列表、未搜索到内容或尚未创建数据时提供统一占位与引导。',
      children: [
        DemoBox(
          child: AnimalEmptyState(
            title: '今天还没有新的委托',
            message: '可以先去海边散步，等岛民发布新任务后再回来看看。',
            onAction: () {},
          ),
        ),
        const DemoLabel('紧凑模式'),
        const DemoBox(
          child: AnimalEmptyState(
            compact: true,
            title: '这里暂时空空的',
            message: '试试切换筛选条件，或者晚一点再回来。',
          ),
        ),
        const DemoCodeBlock(
          "AnimalEmptyState(\n  title: '今天还没有新的委托',\n  message: '可以先去海边散步，等岛民发布新任务后再回来看看。',\n  onAction: _browseElsewhere,\n);",
        ),
        const DemoApiTable(
          rows: [
            DemoApiRow(
              prop: 'title',
              desc: '空状态标题',
              type: 'String?',
              defaultValue: '内置默认文案',
            ),
            DemoApiRow(
              prop: 'message',
              desc: '空状态说明',
              type: 'String?',
              defaultValue: '内置默认文案',
            ),
            DemoApiRow(
              prop: 'actionLabel',
              desc: '引导按钮文案',
              type: 'String',
              defaultValue: '去逛逛别处',
            ),
            DemoApiRow(
              prop: 'onAction',
              desc: '按钮回调',
              type: 'VoidCallback?',
              defaultValue: '-',
            ),
            DemoApiRow(
              prop: 'compact',
              desc: '紧凑模式',
              type: 'bool',
              defaultValue: 'false',
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectDemoSection extends StatefulWidget {
  const _SelectDemoSection();

  @override
  State<_SelectDemoSection> createState() => _SelectDemoSectionState();
}

class _SelectDemoSectionState extends State<_SelectDemoSection> {
  String value = 'forest';
  String emptyFlowerValue = '';
  String emptyFruitValue = '';
  String disabledValue = 'garden';

  @override
  Widget build(BuildContext context) {
    const options = <AnimalSelectOption>[
      AnimalSelectOption(keyId: 'beach', label: '海滩'),
      AnimalSelectOption(keyId: 'forest', label: '森林'),
      AnimalSelectOption(keyId: 'garden', label: '花园'),
      AnimalSelectOption(keyId: 'village', label: '村庄'),
    ];

    return DemoSection(
      title: 'Select',
      tag: 'overlay',
      description: '支持同侧 / 反侧弹出、悬停光标装饰与选中 pill bar。',
      children: [
        const DemoLabel('默认状态'),
        DemoBox(
          child: Row(
            children: [
              AnimalSelect(
                options: options,
                value: value,
                onChanged: (next) => setState(() => value = next),
              ),
              const SizedBox(width: 12),
              Text('当前选择: $value'),
            ],
          ),
        ),
        const DemoLabel('自定义占位文本'),
        DemoBox(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              AnimalSelect(
                options: options,
                value: emptyFlowerValue,
                placeholder: '请选择花朵',
                onChanged: (next) => setState(() => emptyFlowerValue = next),
              ),
              AnimalSelect(
                options: options,
                value: emptyFruitValue,
                placeholder: '请选择水果',
                onChanged: (next) => setState(() => emptyFruitValue = next),
              ),
            ],
          ),
        ),
        const DemoLabel('禁用状态'),
        DemoBox(
          child: AnimalSelect(
            options: options,
            value: disabledValue,
            enabled: false,
            onChanged: (next) => setState(() => disabledValue = next),
          ),
        ),
      ],
    );
  }
}

class _CheckboxDemoSection extends StatefulWidget {
  const _CheckboxDemoSection();

  @override
  State<_CheckboxDemoSection> createState() => _CheckboxDemoSectionState();
}

class _CheckboxDemoSectionState extends State<_CheckboxDemoSection> {
  List<String> selected = <String>['beach', 'garden'];
  List<String> selected2 = <String>[];

  @override
  Widget build(BuildContext context) {
    final islandOptions = <AnimalCheckboxOption<String>>[
      const AnimalCheckboxOption(value: 'beach', label: Text('🌊 海滩')),
      const AnimalCheckboxOption(value: 'forest', label: Text('🌳 森林')),
      const AnimalCheckboxOption(value: 'garden', label: Text('🌸 花园')),
      const AnimalCheckboxOption(value: 'village', label: Text('🏡 村庄')),
    ];

    final critterOptions = <AnimalCheckboxOption<String>>[
      const AnimalCheckboxOption(value: 'butterfly', label: Text('🦋 蝴蝶')),
      const AnimalCheckboxOption(value: 'bass', label: Text('🐟 鲈鱼')),
      const AnimalCheckboxOption(
        value: 'crab',
        label: Text('🦀 螃蟹'),
        disabled: true,
      ),
      const AnimalCheckboxOption(value: 'caterpillar', label: Text('🐛 毛毛虫')),
      const AnimalCheckboxOption(value: 'jellyfish', label: Text('🌊 水母')),
    ];

    return DemoSection(
      title: 'Checkbox',
      tag: 'group',
      description: '支持受控 / 非受控、方向、尺寸和禁用。',
      children: [
        const DemoLabel('默认水平排列（受控）'),
        DemoBox(
          child: AnimalCheckboxGroup<String>(
            options: islandOptions,
            values: selected,
            onChanged: (values) => setState(() => selected = values),
            gap: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          selected.isEmpty ? '已选中: 无' : '已选中: ${selected.join('、')}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xFFA08060)),
        ),
        const DemoLabel('垂直排列 + 含禁用选项'),
        DemoBox(
          child: AnimalCheckboxGroup<String>(
            options: critterOptions,
            values: selected2,
            direction: AnimalCheckboxDirection.vertical,
            onChanged: (values) => setState(() => selected2 = values),
          ),
        ),
        const DemoLabel('小 / 中 / 大尺寸'),
        DemoBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimalCheckboxGroup<String>(
                options: islandOptions,
                defaultValues: const ['forest'],
                size: AnimalCheckboxSize.small,
              ),
              const SizedBox(height: 12),
              AnimalCheckboxGroup<String>(
                options: islandOptions,
                defaultValues: const ['beach'],
                size: AnimalCheckboxSize.middle,
              ),
              const SizedBox(height: 12),
              AnimalCheckboxGroup<String>(
                options: islandOptions.take(3).toList(),
                defaultValues: const ['beach'],
                size: AnimalCheckboxSize.large,
              ),
            ],
          ),
        ),
        const DemoLabel('全部禁用'),
        DemoBox(
          child: AnimalCheckboxGroup<String>(
            options: islandOptions,
            defaultValues: const ['garden', 'village'],
            enabled: false,
          ),
        ),
      ],
    );
  }
}

class _TabsDemoSection extends StatefulWidget {
  const _TabsDemoSection();

  @override
  State<_TabsDemoSection> createState() => _TabsDemoSectionState();
}

class _TabsDemoSectionState extends State<_TabsDemoSection> {
  String active = 'tab1';

  @override
  Widget build(BuildContext context) {
    final items = <AnimalTabItem>[
      const AnimalTabItem(
        id: 'tab1',
        label: Text('岛屿概况'),
        child: Text('这里是一座无人岛，环境优美，气候宜人。可以钓鱼、捉虫、种植各种植物。'),
      ),
      const AnimalTabItem(
        id: 'tab2',
        label: Text('商店'),
        child: Text('狸然超市营业中！各种商品应有尽有，价格实惠。'),
      ),
      const AnimalTabItem(
        id: 'tab3',
        label: Text('服务台'),
        child: Text('欢迎来到服务台！可以办理各种服务业务。'),
      ),
    ];
    final activeLabel =
        (items.firstWhere((item) => item.id == active).label as Text).data ??
        active;

    return DemoSection(
      title: 'Tabs',
      tag: 'leaf animation',
      description: '支持受控 / 非受控、shadow 与 leafAnimation 控制。',
      children: [
        const DemoLabel('非受控模式'),
        DemoBox(
          child: AnimalTabs(items: items, defaultActiveId: 'tab1'),
        ),
        const DemoLabel('shadow 阴影控制'),
        DemoBox(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 280,
                child: AnimalTabs(
                  items: items.take(2).toList(),
                  defaultActiveId: 'tab1',
                ),
              ),
              SizedBox(
                width: 280,
                child: AnimalTabs(
                  items: items.take(2).toList(),
                  defaultActiveId: 'tab1',
                  shadow: false,
                ),
              ),
            ],
          ),
        ),
        const DemoLabel('受控模式'),
        DemoBox(
          child: AnimalTabs(
            items: items,
            activeId: active,
            onChanged: (key) => setState(() => active = key),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '当前选中: $activeLabel',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xFFA08060)),
        ),
        const DemoLabel('关闭叶子动画'),
        DemoBox(
          child: AnimalTabs(
            items: items.take(2).toList(),
            defaultActiveId: 'tab1',
            leafAnimation: false,
            shadow: false,
          ),
        ),
      ],
    );
  }
}
