import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';

class AnimalTabs extends StatefulWidget {
  const AnimalTabs({
    super.key,
    required this.items,
    this.defaultActiveId,
    this.activeId,
    this.onChanged,
    this.leafAnimation = true,
    this.shadow = true,
  });

  final List<AnimalTabItem> items;
  final String? defaultActiveId;
  final String? activeId;
  final ValueChanged<String>? onChanged;
  final bool leafAnimation;
  final bool shadow;

  @override
  State<AnimalTabs> createState() => _AnimalTabsState();
}

class _AnimalTabsState extends State<AnimalTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _activeId;
  final Map<String, double> _bodyHeights = <String, double>{};
  String? _widgetDrivenActiveId;

  @override
  void initState() {
    super.initState();
    assert(widget.items.isNotEmpty, 'AnimalTabs.items must not be empty');
    _activeId = _resolveActiveId(widget.activeId ?? widget.defaultActiveId);
    _tabController = _createController(initialId: _activeId);
  }

  @override
  void didUpdateWidget(covariant AnimalTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_itemsChanged(oldWidget.items, widget.items)) {
      final nextActiveId = _resolveActiveId(widget.activeId ?? _activeId);
      _bodyHeights.removeWhere(
        (id, _) => !widget.items.any((item) => item.id == id),
      );
      _replaceController(nextActiveId);
      _activeId = nextActiveId;
      return;
    }

    if (widget.activeId != null && widget.activeId != oldWidget.activeId) {
      final nextActiveId = _resolveActiveId(widget.activeId);
      _widgetDrivenActiveId = nextActiveId;
      _activeId = nextActiveId;
      final nextIndex = _indexForId(nextActiveId);
      if (_tabController.index != nextIndex) {
        _tabController.animateTo(nextIndex);
      } else {
        _widgetDrivenActiveId = null;
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  TabController _createController({required String initialId}) {
    final controller = TabController(
      length: widget.items.length,
      vsync: this,
      initialIndex: _indexForId(initialId),
    );
    controller.addListener(_handleTabChange);
    return controller;
  }

  void _replaceController(String activeId) {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _tabController = _createController(initialId: activeId);
  }

  bool _itemsChanged(List<AnimalTabItem> previous, List<AnimalTabItem> next) {
    if (previous.length != next.length) {
      return true;
    }
    for (var index = 0; index < previous.length; index += 1) {
      if (previous[index].id != next[index].id) {
        return true;
      }
    }
    return false;
  }

  String _resolveActiveId(String? candidate) {
    if (candidate != null) {
      for (final item in widget.items) {
        if (item.id == candidate) {
          return candidate;
        }
      }
    }
    return widget.items.first.id;
  }

  int _indexForId(String id) {
    final index = widget.items.indexWhere((item) => item.id == id);
    return index >= 0 ? index : 0;
  }

  void _handleTabChange() {
    final nextId = widget.items[_tabController.index].id;
    if (nextId == _activeId && _widgetDrivenActiveId == null) {
      return;
    }

    setState(() {
      _activeId = nextId;
    });

    if (_widgetDrivenActiveId == nextId) {
      _widgetDrivenActiveId = null;
      return;
    }

    widget.onChanged?.call(nextId);
  }

  void _recordBodyHeight(String id, double height) {
    final previousHeight = _bodyHeights[id];
    if (previousHeight != null && (previousHeight - height).abs() < 0.5) {
      return;
    }

    setState(() {
      _bodyHeights[id] = height;
    });
  }

  Widget _buildTabBody(AnimalTabItem item) {
    return Padding(
      padding: const EdgeInsets.all(AnimalIslandTokens.spacingXl),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: context.animalIslandTheme.textSecondary,
        ),
        child: item.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final activeItem = widget.items[_indexForId(_activeId)];
    final activeBodyHeight = _bodyHeights[_activeId];

    return DecoratedBox(
      decoration: theme.isWestworld
          ? theme.westworldPanelDecoration()
          : BoxDecoration(
              color: theme.surfaceRaised,
              borderRadius: BorderRadius.circular(theme.radiusLg),
              border: Border.all(
                color: theme.borderLight,
                width: theme.borderWidth,
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AnimalIslandTokens.spacingLg),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.only(
                right: AnimalIslandTokens.spacingXs,
              ),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: [
                for (var index = 0; index < widget.items.length; index += 1)
                  SizedBox(
                    height: theme.isWestworld ? 64 : null,
                    child: Tab(
                      height: theme.isWestworld ? 64 : null,
                      child: _TabChip(
                        item: widget.items[index],
                        index: index,
                        active: widget.items[index].id == _activeId,
                        shadow: widget.shadow,
                        leafAnimation: widget.leafAnimation,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: theme.borderWidth,
            color: theme.panelLineColor(),
          ),
          Offstage(
            offstage: true,
            child: _MeasuredSize(
              onChanged: (size) =>
                  _recordBodyHeight(activeItem.id, size.height),
              child: _buildTabBody(activeItem),
            ),
          ),
          if (activeBodyHeight == null)
            _buildTabBody(activeItem)
          else
            AnimatedSize(
              duration: AnimalIslandTokens.base,
              curve: AnimalIslandTokens.motionCurve,
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: activeBodyHeight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    for (final item in widget.items) _buildTabBody(item),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabChip extends StatefulWidget {
  const _TabChip({
    required this.item,
    required this.index,
    required this.active,
    required this.shadow,
    required this.leafAnimation,
  });

  final AnimalTabItem item;
  final int index;
  final bool active;
  final bool shadow;
  final bool leafAnimation;

  @override
  State<_TabChip> createState() => _TabChipState();
}

class _TabChipState extends State<_TabChip>
    with SingleTickerProviderStateMixin {
  AnimationController? _leafController;

  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _syncLeafAnimation();
  }

  @override
  void didUpdateWidget(covariant _TabChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncLeafAnimation();
  }

  @override
  void dispose() {
    _leafController?.dispose();
    super.dispose();
  }

  void _syncLeafAnimation() {
    final shouldAnimate = widget.active && widget.leafAnimation;
    if (!shouldAnimate) {
      _leafController?.stop();
      return;
    }

    _leafController ??= AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (!_leafController!.isAnimating) {
      _leafController!.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    if (theme.isWestworld) {
      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: _WestworldTabLine(
          item: widget.item,
          index: widget.index,
          active: widget.active,
          hovered: _hovered,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: theme.interactionDuration,
        curve: theme.interactionCurve,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: widget.active
              ? (theme.isWestworld
                    ? theme.primary
                    : theme.isNes
                    ? theme.primary
                    : const Color(0xFF0CC0B5))
              : (_hovered
                    ? theme.primary.withValues(alpha: 0.1)
                    : Colors.transparent),
          borderRadius: BorderRadius.circular(theme.radiusPill),
          border: theme.isNes || theme.isWestworld
              ? Border.all(
                  color: widget.active
                      ? theme.border
                      : theme.panelLineColor(hovered: _hovered),
                  width: theme.isWestworld ? 1 : 2,
                )
              : null,
          boxShadow: widget.active && widget.shadow && !theme.isWestworld
              ? [
                  BoxShadow(
                    color: theme.inputShadow,
                    blurRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.active ? '●' : '○',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: AnimalIslandTokens.fontMicro,
                    color: widget.active
                        ? (theme.isWestworld
                              ? theme.pageBackground
                              : const Color(0xFFFFF9E3))
                        : theme.textPrimary,
                  ),
                ),
                const SizedBox(width: AnimalIslandTokens.spacingSm),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: widget.active
                        ? (theme.isWestworld
                              ? theme.pageBackground
                              : const Color(0xFFFFF9E3))
                        : theme.textPrimary,
                    letterSpacing: theme.isWestworld ? 0.9 : null,
                    fontWeight: widget.active
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                  child: widget.item.label,
                ),
              ],
            ),
            if (widget.active && theme.spec.isOrganic)
              Positioned(
                right: -5,
                top: -4,
                child: widget.leafAnimation
                    ? AnimatedBuilder(
                        animation: _leafController!,
                        builder: (context, child) {
                          final radians =
                              math.sin(_leafController!.value * math.pi * 2) *
                              10;
                          return Transform.rotate(
                            angle: radians * math.pi / 180,
                            child: child,
                          );
                        },
                        child: Image.asset(
                          AnimalIslandAssets.iconLeaf,
                          package: AnimalIslandAssets.package,
                          width: 18,
                          height: 18,
                        ),
                      )
                    : Image.asset(
                        AnimalIslandAssets.iconLeaf,
                        package: AnimalIslandAssets.package,
                        width: 18,
                        height: 18,
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WestworldTabLine extends StatelessWidget {
  const _WestworldTabLine({
    required this.item,
    required this.index,
    required this.active,
    required this.hovered,
  });

  final AnimalTabItem item;
  final int index;
  final bool active;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final line = theme.textPrimary.withValues(
      alpha: active
          ? 0.92
          : hovered
          ? 0.52
          : 0.22,
    );
    final textColor = theme.textPrimary.withValues(
      alpha: active
          ? 0.96
          : hovered
          ? 0.74
          : 0.58,
    );
    return AnimatedContainer(
      duration: theme.interactionDuration,
      curve: theme.interactionCurve,
      width: 188,
      height: 58,
      padding: const EdgeInsets.only(left: 18, top: 5, right: 8, bottom: 4),
      child: CustomPaint(
        painter: _WestworldTabLinePainter(
          line: line,
          active: active,
          hovered: hovered,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 5, right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: theme.textMuted.withValues(
                        alpha: active ? 0.86 : 0.58,
                      ),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.0,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: line.withValues(alpha: active ? 0.44 : 0.24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3.0,
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: item.label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WestworldTabLinePainter extends CustomPainter {
  const _WestworldTabLinePainter({
    required this.line,
    required this.active,
    required this.hovered,
  });

  final Color line;
  final bool active;
  final bool hovered;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = active ? 1.25 : 1
      ..color = line;
    const left = 6.0;
    final top = active ? 0.0 : 6.0;
    final cornerY = size.height - 20;
    final bottomY = size.height - 5;
    final bottomEnd = active ? size.width - 2 : size.width - 18;
    canvas.drawLine(Offset(left, top), Offset(left, cornerY), paint);
    canvas.drawLine(Offset(left, cornerY), Offset(left + 18, bottomY), paint);
    canvas.drawLine(
      Offset(left + 18, bottomY),
      Offset(bottomEnd, bottomY),
      paint,
    );

    if (active || hovered) {
      canvas.drawLine(
        Offset(left + 34, bottomY - 1),
        Offset(math.min(size.width - 36, left + 106), bottomY - 1),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = line.withValues(alpha: active ? 0.42 : 0.22),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WestworldTabLinePainter oldDelegate) {
    return oldDelegate.line != line ||
        oldDelegate.active != active ||
        oldDelegate.hovered != hovered;
  }
}

class _MeasuredSize extends SingleChildRenderObjectWidget {
  const _MeasuredSize({required this.onChanged, required super.child});

  final ValueChanged<Size> onChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMeasuredSize(onChanged);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMeasuredSize renderObject,
  ) {
    renderObject.onChanged = onChanged;
  }
}

class _RenderMeasuredSize extends RenderProxyBox {
  _RenderMeasuredSize(this.onChanged);

  ValueChanged<Size> onChanged;
  Size? _lastSize;

  @override
  void performLayout() {
    super.performLayout();
    final currentSize = child?.size;
    if (currentSize == null || currentSize == _lastSize) {
      return;
    }

    _lastSize = currentSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChanged(currentSize);
    });
  }
}
