import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:animal_island_ui_flutter/animal_island_ui_flutter.dart';

import 'component_page.dart';
import 'example_assets.dart';
import 'home_page.dart';
import 'page_info.dart';

void main() {
  runApp(const AnimalIslandExampleApp());
}

class AnimalIslandExampleApp extends StatefulWidget {
  const AnimalIslandExampleApp({super.key});

  @override
  State<AnimalIslandExampleApp> createState() => _AnimalIslandExampleAppState();
}

class _AnimalIslandExampleAppState extends State<AnimalIslandExampleApp> {
  AnimalIslandThemeMode _mode = AnimalIslandThemeMode.day;
  AnimalIslandGameStyle _gameStyle = AnimalIslandGameStyle.animalIsland;
  String _activeKey = 'home';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Island UI Flutter',
      debugShowCheckedModeBanner: false,
      theme: buildAnimalIslandTheme(mode: _mode, gameStyle: _gameStyle),
      home: AnimalCursor(
        child: Builder(
          builder: (context) {
            final isMobile = MediaQuery.sizeOf(context).width < 900;

            if (_activeKey == 'home') {
              return Scaffold(
                body: _ThemedDemoBackground(
                  mode: _mode,
                  gameStyle: _gameStyle,
                  home: true,
                  child: HomePage(
                    mode: _mode,
                    onToggleMode: _toggleMode,
                    onNavigate: (key) => setState(() => _activeKey = key),
                  ),
                ),
              );
            }

            return Scaffold(
              body: _ThemedDemoBackground(
                mode: _mode,
                gameStyle: _gameStyle,
                home: false,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        if (!isMobile)
                          _Sidebar(
                            activeKey: _activeKey,
                            mode: _mode,
                            gameStyle: _gameStyle,
                            onToggleMode: _toggleMode,
                            onToggleGameStyle: _toggleGameStyle,
                            onNavigate: _navigate,
                          ),
                        Expanded(
                          child: SafeArea(
                            child: ComponentPage(
                              activeKey: _activeKey,
                              mode: _mode,
                              gameStyle: _gameStyle,
                              onToggleMode: _toggleMode,
                              onToggleGameStyle: _toggleGameStyle,
                              onNavigate: _navigate,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isMobile &&
                        _gameStyle != AnimalIslandGameStyle.westworld)
                      Positioned(
                        left: 220,
                        right: 0,
                        bottom: 0,
                        child: IgnorePointer(
                          child: Image.asset(
                            ExampleAssets.demoGuideLine,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              drawer: isMobile
                  ? Drawer(
                      child: _Sidebar(
                        activeKey: _activeKey,
                        mode: _mode,
                        gameStyle: _gameStyle,
                        onToggleMode: _toggleMode,
                        onToggleGameStyle: _toggleGameStyle,
                        onNavigate: (key) {
                          Navigator.of(context).pop();
                          _navigate(key);
                        },
                      ),
                    )
                  : null,
              appBar: isMobile
                  ? AppBar(
                      title: Text(pageInfo[_activeKey]?.title ?? '组件文档'),
                      leading: IconButton(
                        onPressed: () => setState(() => _activeKey = 'home'),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      actions: [
                        IconButton(
                          onPressed: _toggleGameStyle,
                          icon: Icon(_animalStyleIcon(_gameStyle)),
                        ),
                        IconButton(
                          onPressed: _toggleMode,
                          icon: Icon(
                            _mode == AnimalIslandThemeMode.day
                                ? Icons.dark_mode_outlined
                                : Icons.wb_sunny_outlined,
                          ),
                        ),
                        Builder(
                          builder: (context) => IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: const Icon(Icons.menu),
                          ),
                        ),
                      ],
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == AnimalIslandThemeMode.day
          ? AnimalIslandThemeMode.night
          : AnimalIslandThemeMode.day;
    });
  }

  void _toggleGameStyle() {
    setState(() {
      _gameStyle = switch (_gameStyle) {
        AnimalIslandGameStyle.animalIsland => AnimalIslandGameStyle.nes8Bit,
        AnimalIslandGameStyle.nes8Bit => AnimalIslandGameStyle.westworld,
        AnimalIslandGameStyle.westworld => AnimalIslandGameStyle.guofengDoodle,
        AnimalIslandGameStyle.guofengDoodle =>
          AnimalIslandGameStyle.animalIsland,
      };
    });
  }

  void _navigate(String key) {
    setState(() => _activeKey = key);
  }
}

class _ThemedDemoBackground extends StatelessWidget {
  const _ThemedDemoBackground({
    required this.mode,
    required this.gameStyle,
    required this.home,
    required this.child,
  });

  final AnimalIslandThemeMode mode;
  final AnimalIslandGameStyle gameStyle;
  final bool home;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    if (gameStyle == AnimalIslandGameStyle.westworld) {
      return DecoratedBox(
        decoration: BoxDecoration(gradient: theme.westworldBackgroundGradient),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _WestworldDemoBackgroundPainter(
                    line: theme.panelLineColor(),
                    ink: theme.textPrimary.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: home ? null : theme.pageBackground,
        gradient: home
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [theme.heroGradientStart, theme.heroGradientEnd],
              )
            : null,
        image: DecorationImage(
          image: AssetImage(
            home
                ? ExampleAssets.demoHomeBackground
                : ExampleAssets.demoContentBackground,
          ),
          fit: home ? BoxFit.cover : BoxFit.none,
          repeat: ImageRepeat.repeat,
          opacity: home
              ? (mode == AnimalIslandThemeMode.day ? 0.32 : 0.12)
              : (mode == AnimalIslandThemeMode.day ? 0.18 : 0.06),
        ),
      ),
      child: child,
    );
  }
}

class _WestworldDemoBackgroundPainter extends CustomPainter {
  const _WestworldDemoBackgroundPainter({
    required this.line,
    required this.ink,
  });

  final Color line;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.58, size.height * 0.42);
    final ringPaint = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 6; i += 1) {
      canvas.drawCircle(center, 90 + i * 62, ringPaint);
    }

    final gridPaint = Paint()
      ..color = ink
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 64) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 64) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WestworldDemoBackgroundPainter oldDelegate) {
    return oldDelegate.line != line || oldDelegate.ink != ink;
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.activeKey,
    required this.mode,
    required this.gameStyle,
    required this.onToggleMode,
    required this.onToggleGameStyle,
    required this.onNavigate,
  });

  final String activeKey;
  final AnimalIslandThemeMode mode;
  final AnimalIslandGameStyle gameStyle;
  final VoidCallback onToggleMode;
  final VoidCallback onToggleGameStyle;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    return SizedBox(
      width: 220,
      child: SafeArea(
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(
                ExampleAssets.demoMenuBackground,
                fit: BoxFit.cover,
                colorFilter: gameStyle == AnimalIslandGameStyle.westworld
                    ? ColorFilter.mode(
                        theme.pageBackground.withValues(alpha: 0.9),
                        BlendMode.srcATop,
                      )
                    : null,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.surfaceRaised.withValues(
                    alpha: mode == AnimalIslandThemeMode.day ? 0.12 : 0.28,
                  ),
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () => onNavigate('home'),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            ExampleAssets.nookPhoneNook1,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '集合啦！Animal',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: theme.textBody),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: onToggleMode,
                            iconSize: 18,
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              mode == AnimalIslandThemeMode.day
                                  ? Icons.dark_mode_outlined
                                  : Icons.wb_sunny_outlined,
                            ),
                          ),
                          IconButton(
                            onPressed: onToggleGameStyle,
                            iconSize: 18,
                            visualDensity: VisualDensity.compact,
                            icon: Icon(_animalStyleIcon(gameStyle)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        _SidebarGroup(
                          title: '── 基础组件 ──',
                          keys: basicComponentKeys,
                          activeKey: activeKey,
                          onNavigate: onNavigate,
                        ),
                        _SidebarGroup(
                          title: '── 复杂组件 ──',
                          keys: complexComponentKeys,
                          activeKey: activeKey,
                          onNavigate: onNavigate,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _animalStyleIcon(AnimalIslandGameStyle style) {
  return switch (style) {
    AnimalIslandGameStyle.animalIsland => Icons.videogame_asset_outlined,
    AnimalIslandGameStyle.nes8Bit => Icons.radar_outlined,
    AnimalIslandGameStyle.westworld => Icons.park_outlined,
    AnimalIslandGameStyle.guofengDoodle => Icons.brush_outlined,
  };
}

class _SidebarGroup extends StatelessWidget {
  const _SidebarGroup({
    required this.title,
    required this.keys,
    required this.activeKey,
    required this.onNavigate,
  });

  final String title;
  final List<String> keys;
  final String activeKey;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFFA0936E),
              letterSpacing: 0.5,
            ),
          ),
        ),
        for (final key in keys)
          _SidebarItem(
            label: pageInfo[key]?.title ?? key,
            active: activeKey == key,
            onTap: () => onNavigate(key),
          ),
      ],
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AnimalIslandTokens.fast,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: widget.active
                  ? theme.sidebarActive
                  : (_hovered ? theme.sidebarHover : Colors.transparent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.active ? Colors.white : theme.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
