import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';

class AnimalSelect extends StatefulWidget {
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
  State<AnimalSelect> createState() => _AnimalSelectState();
}

class _AnimalSelectState extends State<AnimalSelect> {
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

  void _close() {
    _entry?.remove();
    _entry = null;
    if (mounted) {
      setState(() => _hoveredKey = null);
    }
  }

  void _openMenu() {
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
                      return Container(
                        width: menuWidth,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEEA0),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.options.map((option) {
                            final selected = option.keyId == widget.value;
                            final hovered = option.keyId == _hoveredKey;
                            return MouseRegion(
                              onEnter: (_) => menuSetState(
                                () => _hoveredKey = option.keyId,
                              ),
                              onExit: (_) =>
                                  menuSetState(() => _hoveredKey = null),
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
                                          child: Center(
                                            child: Container(
                                              height: 14,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFFFFCC00,
                                                ).withValues(alpha: 0.3),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (hovered)
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 16),
                                          Text(
                                            option.label,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: const Color(
                                                    0xFF725D42,
                                                  ),
                                                  fontWeight:
                                                      selected || hovered
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
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
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
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
          child: Container(
            constraints: const BoxConstraints(minWidth: 140),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8DCC8), width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label.keyId.isEmpty ? widget.placeholder : label.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: label.keyId.isEmpty
                          ? const Color(0xFFA09080)
                          : const Color(0xFF725D42),
                      fontWeight: label.keyId.isEmpty
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedRotation(
                  duration: AnimalIslandTokens.base,
                  turns: _open ? 0.5 : 0,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _open ? theme.primary : const Color(0xFFA09080),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
