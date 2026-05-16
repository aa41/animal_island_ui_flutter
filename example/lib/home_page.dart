import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';

import 'page_info.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.mode,
    required this.onToggleMode,
    required this.onNavigate,
  });

  final AnimalIslandThemeMode mode;
  final VoidCallback onToggleMode;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final components = <({String key, String desc})>[
      for (final key in [...basicComponentKeys, ...complexComponentKeys])
        (key: key, desc: pageInfo[key]!.desc),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: isMobile ? 24 : 40,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: AnimalButton(
                type: AnimalButtonType.primary,
                size: AnimalButtonSize.small,
                onPressed: onToggleMode,
                child: Text(
                  mode == AnimalIslandThemeMode.day ? '切换夜晚' : '切换白天',
                ),
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: isMobile
                  ? Column(
                      children: [
                        _HeroText(onNavigate: onNavigate, compact: true),
                        const SizedBox(height: 20),
                        _HeroImage(compact: true),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _HeroText(onNavigate: onNavigate)),
                        const SizedBox(width: 80),
                        const _HeroImage(),
                      ],
                    ),
            ),
            const SizedBox(height: 48),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                children: [
                  const _SectionHeader(
                    title: '特性',
                    desc: '为什么用 Flutter 复刻这一套动森设计语言',
                  ),
                  GridView.count(
                    crossAxisCount: isMobile ? 1 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isMobile ? 2.3 : 1.9,
                    children: const [
                      _FeatureCard(
                        asset: AnimalIslandAssets.nookPhoneNook1,
                        title: '1:1 视觉语言',
                        desc: '保留温暖自然底色、3D 按压按钮、有机轮廓与 NookPhone 色板。',
                      ),
                      _FeatureCard(
                        asset: AnimalIslandAssets.nookPhoneShopping,
                        title: '完整组件清单',
                        desc: '覆盖原版全部组件，并增补 Badge 等日常 Flutter UI 常用基础件。',
                      ),
                      _FeatureCard(
                        asset: AnimalIslandAssets.nookPhoneCamera,
                        title: '动态双主题',
                        desc: '在原始白天风格基础上扩展夜晚主题，保留动森傍晚与夜间氛围。',
                      ),
                      _FeatureCard(
                        asset: AnimalIslandAssets.nookPhoneRecipes,
                        title: '跨项目技能复制',
                        desc: '内置可复制 Skill 与脚本，支持 Codex 与 Claude Code 项目快速接入。',
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const AnimalDivider(),
                  const SizedBox(height: 28),
                  const _SectionHeader(title: '组件一览', desc: '点击卡片查看详细文档和在线演示'),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: isMobile ? 420 : 240,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: components.length,
                    itemBuilder: (context, index) {
                      final item = components[index];
                      return AnimalCard(
                        onTap: () => onNavigate(item.key),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pageInfo[item.key]!.title.split(' ').first,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.desc,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  const AnimalDivider(),
                  const SizedBox(height: 28),
                  const _SectionHeader(
                    title: '安装',
                    desc:
                        '根目录即 Flutter library，example 支持 Android / iOS / Web 验证。',
                  ),
                  const AnimalCodeBlock(
                    code:
                        'flutter pub add animal_island_ui_flutter\n\nimport \'package:animal_island_ui_flutter/animal_island_ui_flutter.dart\';',
                  ),
                  const SizedBox(height: 28),
                  const AnimalDivider(),
                  const SizedBox(height: 28),
                  const _SectionHeader(
                    title: '主题定制',
                    desc: '白天 / 夜晚主题都遵循同一套 token 与组件比例。',
                  ),
                  const AnimalCodeBlock(
                    code:
                        'MaterialApp(\n  theme: buildAnimalIslandTheme(mode: AnimalIslandThemeMode.day),\n  darkTheme: buildAnimalIslandTheme(mode: AnimalIslandThemeMode.night),\n)',
                  ),
                  const SizedBox(height: 40),
                  const AnimalFooter(type: AnimalFooterType.tree),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.onNavigate, this.compact = false});

  final ValueChanged<String> onNavigate;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: compact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          compact ? 'Animal Island UI' : 'Animal\nIsland UI',
          textAlign: compact ? TextAlign.center : TextAlign.left,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: const Color(0xFFFFF9E6),
            fontSize: compact ? 40 : 60,
            height: 1.05,
            shadows: const [AnimalIslandShadows.warmText],
          ),
        ),
        const SizedBox(height: 12),
        const AnimalBadge(
          label: 'Flutter v0.1.0',
          backgroundColor: Color(0xFFE6F9F6),
          foregroundColor: Color(0xFF19C8B9),
        ),
        const SizedBox(height: 16),
        AnimalTypewriter(
          text: 'Animal 风格的 Flutter UI 组件库，完整复刻 React 原版设计语言，并补充白天 / 夜晚动态主题能力。',
          speed: 32,
          textAlign: compact ? TextAlign.center : TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF7C5734),
            fontSize: compact ? 14 : 17,
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: compact ? WrapAlignment.center : WrapAlignment.start,
          spacing: 16,
          runSpacing: 12,
          children: [
            AnimalButton(
              type: AnimalButtonType.primary,
              size: AnimalButtonSize.large,
              onPressed: () => onNavigate('button'),
              child: const Text('开始使用 →'),
            ),
            AnimalButton(
              type: AnimalButtonType.defaultType,
              size: AnimalButtonSize.large,
              onPressed: () => onNavigate('phone'),
              child: const Text('查看 Demo'),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AnimalIslandAssets.demoAnimalIcon,
      package: AnimalIslandAssets.package,
      width: compact ? 220 : 320,
      height: compact ? 138 : 200,
      fit: BoxFit.contain,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.desc});

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.animalIslandTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.asset,
    required this.title,
    required this.desc,
  });

  final String asset;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return AnimalCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            asset,
            package: AnimalIslandAssets.package,
            width: 42,
            height: 42,
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
