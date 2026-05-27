import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../utils/animal_island_assets.dart';
import 'animal_component_dispatcher.dart';
import 'guofeng_components.dart';
import 'theme_strategies/animal_select_theme_strategy.dart';

class AnimalSelect extends StatelessWidget {
  const AnimalSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder = '请选择',
    this.enabled = true,
  });

  final List<AnimalSelectOption> options;
  final String value;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandSelect(
        options: options,
        value: value,
        onChanged: onChanged,
        placeholder: placeholder,
        enabled: enabled,
      ),
      nes: (_) => _NesAnimalSelect(
        options: options,
        value: value,
        onChanged: onChanged,
        placeholder: placeholder,
        enabled: enabled,
      ),
      westworld: (_) => _WestworldAnimalSelect(
        options: options,
        value: value,
        onChanged: onChanged,
        placeholder: placeholder,
        enabled: enabled,
      ),
      guofeng: (_) => _GuofengAnimalSelect(
        options: options,
        value: value,
        onChanged: onChanged,
        placeholder: placeholder,
        enabled: enabled,
      ),
    );
  }
}

class _AnimalIslandSelect extends _ThemedAnimalSelect {
  const _AnimalIslandSelect({
    required super.options,
    required super.value,
    required super.onChanged,
    required super.placeholder,
    required super.enabled,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalSelect extends _ThemedAnimalSelect {
  const _NesAnimalSelect({
    required super.options,
    required super.value,
    required super.onChanged,
    required super.placeholder,
    required super.enabled,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalSelect extends _ThemedAnimalSelect {
  const _WestworldAnimalSelect({
    required super.options,
    required super.value,
    required super.onChanged,
    required super.placeholder,
    required super.enabled,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalSelect extends _ThemedAnimalSelect {
  const _GuofengAnimalSelect({
    required super.options,
    required super.value,
    required super.onChanged,
    required super.placeholder,
    required super.enabled,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalSelect extends StatefulWidget {
  const _ThemedAnimalSelect({
    required this.gameStyle,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.placeholder,
    required this.enabled,
  });

  final AnimalIslandGameStyle gameStyle;
  final List<AnimalSelectOption> options;
  final String value;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final bool enabled;

  @override
  State<_ThemedAnimalSelect> createState() => _ThemedAnimalSelectState();
}

class _ThemedAnimalSelectState extends State<_ThemedAnimalSelect> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _entry;
  String? _hoveredKey;

  bool get _open => _entry != null;

  void _toggle() {
    if (!widget.enabled) {
      return;
    }
    if (_open) {
      _close();
    } else {
      _openMenu();
    }
  }

  void _close({bool rebuild = true}) {
    _entry?.remove();
    _entry = null;
    if (mounted && rebuild) {
      setState(() => _hoveredKey = null);
    }
  }

  void _openMenu() {
    final theme = context.animalIslandTheme;
    final strategy = AnimalSelectThemeStrategy.forGameStyle(widget.gameStyle);
    final overlay = Overlay.of(context);
    final box = context.findRenderObject() as RenderBox;
    final origin = box.localToGlobal(Offset.zero);
    final screen = MediaQuery.sizeOf(context);
    final menuWidth = math.max(box.size.width + 28, 180).toDouble();
    final menuHeight = widget.options.length * 44 + 24;

    final openLeft = origin.dx + box.size.width + menuWidth + 6 > screen.width;
    final spaceBelow = screen.height - origin.dy - box.size.height;
    final spaceAbove = origin.dy;

    double verticalOffset;
    if (spaceBelow < menuHeight && spaceAbove > spaceBelow) {
      verticalOffset = -menuHeight - 6;
    } else if (spaceBelow < menuHeight) {
      verticalOffset = box.size.height + 6;
    } else if (origin.dy < menuHeight) {
      verticalOffset = box.size.height + 6;
    } else {
      verticalOffset = -menuHeight / 2 + box.size.height / 2;
    }

    _entry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _close,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(
                  openLeft ? -menuWidth - 6 : box.size.width + 6,
                  verticalOffset,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: StatefulBuilder(
                    builder: (context, menuSetState) {
                      final optionWidgets = widget.options.map((option) {
                        final selected = option.keyId == widget.value;
                        final hovered = option.keyId == _hoveredKey;
                        return MouseRegion(
                          onEnter: (_) =>
                              menuSetState(() => _hoveredKey = option.keyId),
                          onExit: (_) => menuSetState(() => _hoveredKey = null),
                          child: GestureDetector(
                            onTap: () {
                              widget.onChanged(option.keyId);
                              _close();
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  if (selected)
                                    Positioned.fill(
                                      child: _SelectedOptionMark(
                                        theme: theme,
                                        strategy: strategy,
                                      ),
                                    ),
                                  if (hovered &&
                                      theme.spec.isOrganic &&
                                      !theme.isGuofengDoodle)
                                    Positioned(
                                      left: -12,
                                      child: SvgPicture.asset(
                                        AnimalIslandAssets.selectCursor,
                                        package: AnimalIslandAssets.package,
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 16),
                                      Text(
                                        strategy.optionLabel(
                                          option.label,
                                          hovered: hovered,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: strategy.optionTextColor(
                                                theme,
                                                selected: selected,
                                                hovered: hovered,
                                              ),
                                              letterSpacing: strategy
                                                  .triggerLetterSpacing(theme),
                                              fontWeight: selected || hovered
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList();
                      final menu = Container(
                        width: menuWidth,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: strategy.menuDecoration(theme),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: optionWidgets,
                        ),
                      );
                      if (widget.gameStyle !=
                          AnimalIslandGameStyle.guofengDoodle) {
                        return menu;
                      }
                      return Stack(
                        children: [
                          menu,
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: GuofengInkOutlinePainter(
                                  color: theme.border,
                                  radius: theme.radiusBase,
                                  strokeWidth: theme.borderWidth,
                                  seed: 23,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(_entry!);
    setState(() {});
  }

  @override
  void dispose() {
    _close(rebuild: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final strategy = AnimalSelectThemeStrategy.forGameStyle(widget.gameStyle);
    final label = widget.options.firstWhere(
      (option) => option.keyId == widget.value,
      orElse: () => AnimalSelectOption(keyId: '', label: widget.placeholder),
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: GestureDetector(
          onTap: _toggle,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 140),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: strategy.triggerDecoration(theme, _open),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label.keyId.isEmpty ? widget.placeholder : label.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: strategy.triggerTextColor(
                            theme,
                            empty: label.keyId.isEmpty,
                          ),
                          letterSpacing: strategy.triggerLetterSpacing(theme),
                          fontWeight: label.keyId.isEmpty
                              ? FontWeight.w500
                              : FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedRotation(
                      duration: theme.interactionDuration,
                      turns: _open ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _open ? theme.primary : theme.textMuted,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.gameStyle == AnimalIslandGameStyle.guofengDoodle)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: GuofengInkOutlinePainter(
                        color: _open ? theme.primary : theme.border,
                        radius: theme.radiusBase,
                        strokeWidth: theme.inputBorderWidth,
                        seed: 17,
                      ),
                    ),
                  ),
                ),
              if (widget.gameStyle == AnimalIslandGameStyle.guofengDoodle &&
                  _open)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: GuofengBrushFocusPainter(
                        color: theme.focusYellow,
                        radius: theme.radiusBase,
                        seed: 23,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedOptionMark extends StatelessWidget {
  const _SelectedOptionMark({required this.theme, required this.strategy});

  final AnimalIslandThemeData theme;
  final AnimalSelectThemeStrategy strategy;

  @override
  Widget build(BuildContext context) {
    if (theme.gameStyle != AnimalIslandGameStyle.westworld) {
      return Center(
        child: Container(
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: strategy.selectedMarkColor(theme).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: strategy.selectedMarkColor(theme)),
          right: BorderSide(
            color: strategy.selectedMarkColor(theme).withValues(alpha: 0.34),
          ),
        ),
        color: strategy.selectedMarkColor(theme).withValues(alpha: 0.06),
      ),
    );
  }
}
