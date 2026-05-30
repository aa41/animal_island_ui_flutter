import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import 'animal_component_dispatcher.dart';
import 'guofeng_components.dart';
import 'nes_pixel_frame.dart';

class AnimalCheckboxGroup<T> extends StatelessWidget {
  const AnimalCheckboxGroup({
    super.key,
    required this.options,
    this.values,
    this.defaultValues = const [],
    this.size = AnimalCheckboxSize.middle,
    this.enabled = true,
    this.direction = AnimalCheckboxDirection.horizontal,
    this.onChanged,
    this.gap,
  });

  final List<AnimalCheckboxOption<T>> options;
  final List<T>? values;
  final List<T> defaultValues;
  final AnimalCheckboxSize size;
  final bool enabled;
  final AnimalCheckboxDirection direction;
  final ValueChanged<List<T>>? onChanged;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandCheckboxGroup<T>(
        options: options,
        values: values,
        defaultValues: defaultValues,
        size: size,
        enabled: enabled,
        direction: direction,
        onChanged: onChanged,
        gap: gap,
      ),
      nes: (_) => _NesAnimalCheckboxGroup<T>(
        options: options,
        values: values,
        defaultValues: defaultValues,
        size: size,
        enabled: enabled,
        direction: direction,
        onChanged: onChanged,
        gap: gap,
      ),
      westworld: (_) => _WestworldAnimalCheckboxGroup<T>(
        options: options,
        values: values,
        defaultValues: defaultValues,
        size: size,
        enabled: enabled,
        direction: direction,
        onChanged: onChanged,
        gap: gap,
      ),
      guofeng: (_) => _GuofengAnimalCheckboxGroup<T>(
        options: options,
        values: values,
        defaultValues: defaultValues,
        size: size,
        enabled: enabled,
        direction: direction,
        onChanged: onChanged,
        gap: gap,
      ),
    );
  }
}

class _AnimalIslandCheckboxGroup<T> extends _ThemedAnimalCheckboxGroup<T> {
  const _AnimalIslandCheckboxGroup({
    required super.options,
    required super.values,
    required super.defaultValues,
    required super.size,
    required super.enabled,
    required super.direction,
    required super.onChanged,
    required super.gap,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalCheckboxGroup<T> extends _ThemedAnimalCheckboxGroup<T> {
  const _NesAnimalCheckboxGroup({
    required super.options,
    required super.values,
    required super.defaultValues,
    required super.size,
    required super.enabled,
    required super.direction,
    required super.onChanged,
    required super.gap,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalCheckboxGroup<T> extends _ThemedAnimalCheckboxGroup<T> {
  const _WestworldAnimalCheckboxGroup({
    required super.options,
    required super.values,
    required super.defaultValues,
    required super.size,
    required super.enabled,
    required super.direction,
    required super.onChanged,
    required super.gap,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalCheckboxGroup<T> extends _ThemedAnimalCheckboxGroup<T> {
  const _GuofengAnimalCheckboxGroup({
    required super.options,
    required super.values,
    required super.defaultValues,
    required super.size,
    required super.enabled,
    required super.direction,
    required super.onChanged,
    required super.gap,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalCheckboxGroup<T> extends StatefulWidget {
  const _ThemedAnimalCheckboxGroup({
    required this.gameStyle,
    required this.options,
    required this.values,
    required this.defaultValues,
    required this.size,
    required this.enabled,
    required this.direction,
    required this.onChanged,
    required this.gap,
  });

  final AnimalIslandGameStyle gameStyle;
  final List<AnimalCheckboxOption<T>> options;
  final List<T>? values;
  final List<T> defaultValues;
  final AnimalCheckboxSize size;
  final bool enabled;
  final AnimalCheckboxDirection direction;
  final ValueChanged<List<T>>? onChanged;
  final double? gap;

  @override
  State<_ThemedAnimalCheckboxGroup<T>> createState() =>
      _ThemedAnimalCheckboxGroupState<T>();
}

class _ThemedAnimalCheckboxGroupState<T>
    extends State<_ThemedAnimalCheckboxGroup<T>> {
  late List<T> _values = List<T>.from(widget.values ?? widget.defaultValues);

  @override
  void didUpdateWidget(covariant _ThemedAnimalCheckboxGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != null && widget.values != oldWidget.values) {
      _values = List<T>.from(widget.values!);
    }
  }

  void _toggle(AnimalCheckboxOption<T> option) {
    if (!widget.enabled || option.disabled) {
      return;
    }

    final next = List<T>.from(widget.values ?? _values);
    if (next.contains(option.value)) {
      next.remove(option.value);
    } else {
      next.add(option.value);
    }

    if (widget.values == null) {
      setState(() => _values = next);
    }
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final spacing =
        widget.gap ??
        (widget.direction == AnimalCheckboxDirection.vertical ? 8.0 : 12.0);

    if (widget.direction == AnimalCheckboxDirection.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < widget.options.length; i++) ...[
            _CheckboxTile<T>(
              option: widget.options[i],
              checked: (widget.values ?? _values).contains(
                widget.options[i].value,
              ),
              size: widget.size,
              enabled: widget.enabled,
              onTap: () => _toggle(widget.options[i]),
            ),
            if (i < widget.options.length - 1) SizedBox(height: spacing),
          ],
        ],
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: widget.options
          .map(
            (option) => _CheckboxTile<T>(
              option: option,
              checked: (widget.values ?? _values).contains(option.value),
              size: widget.size,
              enabled: widget.enabled,
              onTap: () => _toggle(option),
            ),
          )
          .toList(),
    );
  }
}

class _CheckboxTile<T> extends StatefulWidget {
  const _CheckboxTile({
    required this.option,
    required this.checked,
    required this.size,
    required this.enabled,
    required this.onTap,
  });

  final AnimalCheckboxOption<T> option;
  final bool checked;
  final AnimalCheckboxSize size;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_CheckboxTile<T>> createState() => _CheckboxTileState<T>();
}

class _CheckboxTileState<T> extends State<_CheckboxTile<T>>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _westworldController;

  @override
  void initState() {
    super.initState();
    _westworldController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
  }

  @override
  void dispose() {
    _westworldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final disabled = !widget.enabled || widget.option.disabled;
    final metrics = switch (widget.size) {
      AnimalCheckboxSize.small => (18.0, AnimalIslandTokens.fontCaption),
      AnimalCheckboxSize.middle => (22.0, AnimalIslandTokens.fontLabel),
      AnimalCheckboxSize.large => (28.0, AnimalIslandTokens.fontBody),
    };

    final box = metrics.$1;
    final fontSize = metrics.$2;

    if (theme.isWestworld) {
      return MouseRegion(
        onEnter: disabled ? null : (_) => setState(() => _hovered = true),
        onExit: disabled ? null : (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: disabled ? null : widget.onTap,
          child: Opacity(
            opacity: disabled ? 0.46 : 1,
            child: _WestworldCheckboxTile(
              checked: widget.checked,
              hovered: _hovered,
              progress: _westworldController,
              box: box,
              fontSize: fontSize,
              label: widget.option.label,
            ),
          ),
        ),
      );
    }

    if (theme.isGuofengDoodle) {
      return MouseRegion(
        onEnter: disabled ? null : (_) => setState(() => _hovered = true),
        onExit: disabled ? null : (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: disabled ? null : widget.onTap,
          child: Opacity(
            opacity: disabled ? 0.46 : 1,
            child: _GuofengCheckboxTile(
              checked: widget.checked,
              hovered: _hovered,
              box: box,
              fontSize: fontSize,
              label: widget.option.label,
            ),
          ),
        ),
      );
    }

    if (theme.isNes) {
      return MouseRegion(
        onEnter: disabled ? null : (_) => setState(() => _hovered = true),
        onExit: disabled ? null : (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: disabled ? null : widget.onTap,
          child: Opacity(
            opacity: disabled ? 0.55 : 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: box + 8,
                  child: NesPixelFrame(
                    palette: NesPixelFramePalette(
                      background: widget.checked
                          ? (_hovered ? theme.primaryHover : theme.primary)
                          : theme.surfaceRaised,
                      border: widget.checked
                          ? theme.border
                          : (_hovered ? theme.borderHover : theme.border),
                      shadow: theme.buttonShadow,
                      highlight: Colors.white,
                      lowlight: widget.checked
                          ? theme.primaryActive
                          : theme.borderLight,
                      accent: theme.borderHover,
                    ),
                    hovered: _hovered,
                    focused: _hovered,
                    disabled: disabled,
                    texture: !widget.checked,
                    pixel: 3,
                    shadowOffset: const Offset(3, 3),
                    child: AnimatedOpacity(
                      opacity: widget.checked ? 1 : 0,
                      duration: AnimalIslandTokens.fast,
                      child: CustomPaint(
                        painter: _NesCheckboxCheckPainter(
                          color: Colors.white,
                          shadow: theme.primaryActive,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AnimalIslandTokens.spacingSm),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: fontSize,
                    color: disabled
                        ? theme.textDisabled
                        : (_hovered ? theme.textPrimary : theme.textBody),
                    fontWeight: widget.checked
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                  child: widget.option.label,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      onEnter: disabled ? null : (_) => setState(() => _hovered = true),
      onExit: disabled ? null : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        child: Opacity(
          opacity: disabled ? 0.55 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: theme.interactionDuration,
                width: box,
                height: box,
                decoration: BoxDecoration(
                  color: widget.checked
                      ? (_hovered ? theme.primaryHover : theme.primary)
                      : (disabled ? theme.surfaceMuted : theme.surfaceRaised),
                  borderRadius: BorderRadius.circular(
                    theme.isNes
                        ? theme.radiusSm
                        : (widget.size == AnimalCheckboxSize.large ? 12 : 8),
                  ),
                  border: Border.all(
                    color: widget.checked
                        ? (_hovered ? theme.primary : theme.primaryActive)
                        : (_hovered ? theme.primary : theme.borderLight),
                    width: theme.inputBorderWidth,
                  ),
                ),
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  opacity: widget.checked ? 1 : 0,
                  duration: AnimalIslandTokens.fast,
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: box * 0.72,
                  ),
                ),
              ),
              const SizedBox(width: AnimalIslandTokens.spacingSm),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: fontSize,
                  color: disabled
                      ? theme.textDisabled
                      : (_hovered ? theme.textPrimary : theme.textBody),
                  fontWeight: FontWeight.w500,
                ),
                child: widget.option.label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NesCheckboxCheckPainter extends CustomPainter {
  const _NesCheckboxCheckPainter({required this.color, required this.shadow});

  final Color color;
  final Color shadow;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final unit = size.shortestSide / 5;
    final blocks = [Offset(1, 2), Offset(2, 3), Offset(3, 2), Offset(4, 1)];
    final shadowPaint = Paint()..color = shadow.withValues(alpha: 0.55);
    final paint = Paint()..color = color;
    for (final block in blocks) {
      final rect = Rect.fromLTWH(block.dx * unit, block.dy * unit, unit, unit);
      canvas.drawRect(
        rect.shift(Offset(unit * 0.35, unit * 0.35)),
        shadowPaint,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NesCheckboxCheckPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.shadow != shadow;
  }
}

class _GuofengCheckboxTile extends StatelessWidget {
  const _GuofengCheckboxTile({
    required this.checked,
    required this.hovered,
    required this.box,
    required this.fontSize,
    required this.label,
  });

  final bool checked;
  final bool hovered;
  final double box;
  final double fontSize;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final markSize = box + 2;
    return Semantics(
      button: true,
      checked: checked,
      child: AnimatedContainer(
        duration: theme.interactionDuration,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: hovered
              ? theme.primarySoft.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(theme.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: markSize,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GuofengCheckboxMarkPainter(
                        checked: checked,
                        hovered: hovered,
                        ink: theme.border,
                        active: theme.primary,
                        paper: theme.surface,
                        gold: theme.focusYellow,
                      ),
                    ),
                  ),
                  if (hovered || checked)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: GuofengBrushFocusPainter(
                            color: checked ? theme.primary : theme.focusYellow,
                            radius: 6,
                            strokeWidth: 1,
                            seed: checked ? 29 : 31,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AnimalIslandTokens.spacingSm),
            AnimatedDefaultTextStyle(
              duration: theme.interactionDuration,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: fontSize,
                color: checked
                    ? theme.textPrimary
                    : hovered
                    ? theme.primaryActive
                    : theme.textBody,
                fontWeight: checked ? FontWeight.w700 : FontWeight.w500,
              ),
              child: label,
            ),
          ],
        ),
      ),
    );
  }
}

class _GuofengCheckboxMarkPainter extends CustomPainter {
  const _GuofengCheckboxMarkPainter({
    required this.checked,
    required this.hovered,
    required this.ink,
    required this.active,
    required this.paper,
    required this.gold,
  });

  final bool checked;
  final bool hovered;
  final Color ink;
  final Color active;
  final Color paper;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final rect = Rect.fromLTWH(3, 3, size.width - 6, size.height - 6);
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = checked
          ? active.withValues(alpha: 0.16)
          : paper.withValues(alpha: hovered ? 0.86 : 0.62);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      fill,
    );

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = (checked ? active : ink).withValues(
        alpha: hovered ? 0.92 : 0.78,
      );
    final path = Path()
      ..moveTo(rect.left + 1, rect.top + 3)
      ..lineTo(rect.right - 2, rect.top + 1.5)
      ..lineTo(rect.right - 1, rect.bottom - 3)
      ..lineTo(rect.left + 2, rect.bottom - 1)
      ..close();
    canvas.drawPath(path, outline);

    if (!checked) {
      return;
    }
    final check = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = ink.withValues(alpha: 0.9);
    canvas.drawPath(
      Path()
        ..moveTo(rect.left + rect.width * 0.22, rect.center.dy + 0.5)
        ..lineTo(rect.left + rect.width * 0.43, rect.bottom - 4)
        ..lineTo(rect.right - 3, rect.top + 4),
      check,
    );
    canvas.drawLine(
      Offset(rect.left + 3, rect.bottom + 2),
      Offset(rect.right - 2, rect.bottom + 1.2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.4
        ..color = gold.withValues(alpha: 0.58),
    );
  }

  @override
  bool shouldRepaint(covariant _GuofengCheckboxMarkPainter oldDelegate) {
    return oldDelegate.checked != checked ||
        oldDelegate.hovered != hovered ||
        oldDelegate.ink != ink ||
        oldDelegate.active != active ||
        oldDelegate.paper != paper ||
        oldDelegate.gold != gold;
  }
}

class _WestworldCheckboxTile extends StatelessWidget {
  const _WestworldCheckboxTile({
    required this.checked,
    required this.hovered,
    required this.progress,
    required this.box,
    required this.fontSize,
    required this.label,
  });

  final bool checked;
  final bool hovered;
  final Animation<double> progress;
  final double box;
  final double fontSize;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return Semantics(
      button: true,
      checked: checked,
      child: AnimatedContainer(
        duration: theme.interactionDuration,
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: AnimatedBuilder(
          animation: progress,
          builder: (context, child) => CustomPaint(
            painter: _WestworldCheckboxFramePainter(
              checked: checked,
              hovered: hovered,
              progress: progress.value,
              line: theme.textPrimary,
              surface: theme.surfaceRaised,
            ),
            child: child,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(box + 14, 6, 12, 6),
            child: AnimatedDefaultTextStyle(
              duration: theme.interactionDuration,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: fontSize,
                color: checked
                    ? theme.textPrimary
                    : theme.textPrimary.withValues(
                        alpha: hovered ? 0.74 : 0.56,
                      ),
                fontWeight: checked ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 1.0,
              ),
              child: label,
            ),
          ),
        ),
      ),
    );
  }
}

class _WestworldCheckboxFramePainter extends CustomPainter {
  const _WestworldCheckboxFramePainter({
    required this.checked,
    required this.hovered,
    required this.progress,
    required this.line,
    required this.surface,
  });

  final bool checked;
  final bool hovered;
  final double progress;
  final Color line;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final rect = Rect.fromLTWH(0.5, 5.5, size.width - 1, size.height - 11);
    final mark = Rect.fromLTWH(rect.left + 2, rect.top + 5, 18, 18);
    final y = mark.center.dy;
    final endX = rect.right - 6;
    canvas.drawRect(
      rect,
      Paint()..color = surface.withValues(alpha: checked ? 0.18 : 0.1),
    );
    canvas.drawLine(
      Offset(mark.right + 10, y),
      Offset(endX, y),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = line.withValues(alpha: checked ? 0.18 : 0.07),
    );

    canvas.drawRect(
      mark,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = line.withValues(
          alpha: checked
              ? 0.82
              : hovered
              ? 0.44
              : 0.26,
        ),
    );

    if (checked || hovered) {
      final scanX = mark.right + 10 + (endX - mark.right - 10) * progress;
      canvas.drawLine(
        Offset(scanX, y - 3),
        Offset(scanX, y + 3),
        Paint()
          ..strokeWidth = 1
          ..color = line.withValues(alpha: checked ? 0.18 : 0.09),
      );
    }

    if (!checked) {
      return;
    }

    canvas.drawLine(
      Offset(mark.left + 4, y),
      Offset(mark.right - 4, y),
      Paint()
        ..strokeWidth = 1.4
        ..color = line.withValues(alpha: 0.86),
    );
    canvas.drawLine(
      Offset(mark.center.dx, mark.top + 4),
      Offset(mark.center.dx, mark.bottom - 4),
      Paint()
        ..strokeWidth = 1.2
        ..color = line.withValues(alpha: 0.7),
    );
    canvas.drawLine(
      Offset(mark.right + 10, y),
      Offset(endX, y),
      Paint()
        ..strokeWidth = 1.2
        ..color = line.withValues(alpha: 0.34),
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldCheckboxFramePainter oldDelegate) {
    return oldDelegate.checked != checked ||
        oldDelegate.hovered != hovered ||
        oldDelegate.progress != progress ||
        oldDelegate.line != line ||
        oldDelegate.surface != surface;
  }
}
