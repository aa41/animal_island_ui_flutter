import 'dart:math' as math;

import 'package:flutter/material.dart';

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

class _AnimalTabsState extends State<AnimalTabs> {
  late String _activeId =
      widget.activeId ?? widget.defaultActiveId ?? widget.items.first.id;

  @override
  void didUpdateWidget(covariant AnimalTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeId != null && widget.activeId != oldWidget.activeId) {
      _activeId = widget.activeId!;
    }
  }

  void _select(String id) {
    if (widget.activeId == null) {
      setState(() => _activeId = id);
    }
    widget.onChanged?.call(id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final activeId = widget.activeId ?? _activeId;
    final activeItem = widget.items.firstWhere((item) => item.id == activeId);

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
            child: Wrap(
              spacing: AnimalIslandTokens.spacingXs,
              runSpacing: AnimalIslandTokens.spacingXs,
              children: [
                for (final item in widget.items)
                  _TabChip(
                    item: item,
                    active: item.id == activeId,
                    shadow: widget.shadow,
                    leafAnimation: widget.leafAnimation,
                    onTap: () => _select(item.id),
                  ),
              ],
            ),
          ),
          Divider(height: 0, thickness: 2, color: theme.borderLight),
          AnimatedSwitcher(
            duration: AnimalIslandTokens.base,
            switchInCurve: AnimalIslandTokens.motionCurve,
            child: Padding(
              key: ValueKey<String>(activeItem.id),
              padding: const EdgeInsets.all(AnimalIslandTokens.spacingXl),
              child: DefaultTextStyle(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: theme.textSecondary),
                child: activeItem.child,
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
    required this.onTap,
  });

  final AnimalTabItem item;
  final bool active;
  final bool shadow;
  final bool leafAnimation;
  final VoidCallback onTap;

  @override
  State<_TabChip> createState() => _TabChipState();
}

class _TabChipState extends State<_TabChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _leafController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  bool _hovered = false;

  @override
  void dispose() {
    _leafController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
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
                      fontSize: 10,
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
                          animation: _leafController,
                          builder: (context, child) {
                            final radians =
                                math.sin(_leafController.value * math.pi * 2) *
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
      ),
    );
  }
}
