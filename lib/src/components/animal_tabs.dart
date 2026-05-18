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
      decoration: BoxDecoration(
        color: theme.surfaceRaised,
        borderRadius: BorderRadius.circular(AnimalIslandTokens.radiusLg),
        border: Border.all(color: theme.borderLight, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AnimalIslandTokens.spacingLg),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.only(
                right: AnimalIslandTokens.spacingXs,
              ),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: [
                for (final item in widget.items)
                  Tab(
                    child: _TabChip(
                      item: item,
                      active: item.id == _activeId,
                      shadow: widget.shadow,
                      leafAnimation: widget.leafAnimation,
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 0, thickness: 2, color: theme.borderLight),
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
    required this.active,
    required this.shadow,
    required this.leafAnimation,
  });

  final AnimalTabItem item;
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

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: AnimalIslandTokens.base,
        curve: AnimalIslandTokens.motionCurve,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: widget.active
              ? const Color(0xFF0CC0B5)
              : (_hovered
                    ? theme.primary.withValues(alpha: 0.1)
                    : Colors.transparent),
          borderRadius: BorderRadius.circular(AnimalIslandTokens.radiusPill),
          boxShadow: widget.active && widget.shadow
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
                        ? const Color(0xFFFFF9E3)
                        : theme.textPrimary,
                  ),
                ),
                const SizedBox(width: AnimalIslandTokens.spacingSm),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: widget.active
                        ? const Color(0xFFFFF9E3)
                        : theme.textPrimary,
                    fontWeight: widget.active
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                  child: widget.item.label,
                ),
              ],
            ),
            if (widget.active)
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
