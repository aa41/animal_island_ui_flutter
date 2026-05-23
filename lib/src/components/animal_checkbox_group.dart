import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';

class AnimalCheckboxGroup<T> extends StatefulWidget {
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
  State<AnimalCheckboxGroup<T>> createState() => _AnimalCheckboxGroupState<T>();
}

class _AnimalCheckboxGroupState<T> extends State<AnimalCheckboxGroup<T>> {
  late List<T> _values = List<T>.from(widget.values ?? widget.defaultValues);

  @override
  void didUpdateWidget(covariant AnimalCheckboxGroup<T> oldWidget) {
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
