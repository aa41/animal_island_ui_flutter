import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import 'animal_badge.dart';

class AnimalSlider extends StatefulWidget {
  const AnimalSlider({
    super.key,
    this.value,
    this.initialValue = 50,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.enabled = true,
    this.showValue = true,
    this.leadingLabel,
    this.trailingLabel,
    this.valueLabelBuilder,
    this.onChanged,
    this.onChangeEnd,
  });

  final double? value;
  final double initialValue;
  final double min;
  final double max;
  final int? divisions;
  final bool enabled;
  final bool showValue;
  final String? leadingLabel;
  final String? trailingLabel;
  final String Function(double value)? valueLabelBuilder;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  State<AnimalSlider> createState() => _AnimalSliderState();
}

class _AnimalSliderState extends State<AnimalSlider>
    with SingleTickerProviderStateMixin {
  late double _value = widget.value ?? widget.initialValue;
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimalSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _value = widget.value!;
    }
  }

  void _handleChanged(double value) {
    if (widget.value == null) {
      setState(() => _value = value);
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final currentValue = (widget.value ?? _value).clamp(widget.min, widget.max);
    final ratio = widget.max == widget.min
        ? 0.0
        : (currentValue - widget.min) / (widget.max - widget.min);
    final labelText =
        widget.valueLabelBuilder?.call(currentValue) ??
        currentValue.round().toString();

    return LayoutBuilder(
      builder: (context, constraints) {
        final sliderWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 320.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showValue)
              SizedBox(
                height: 34,
                width: sliderWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment(ratio * 2 - 1, 0),
                      child: AnimalBadge(
                        label: labelText,
                        backgroundColor: theme.surfaceRaised,
                        foregroundColor: theme.textPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (theme.isWestworld)
              _WestworldSliderTrack(
                value: currentValue,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                enabled: widget.enabled,
                scan: _scanController,
                onChanged: _handleChanged,
                onChangeEnd: widget.onChangeEnd,
              )
            else
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: theme.isNes ? 14 : 12,
                  activeTrackColor: theme.primary,
                  inactiveTrackColor: theme.surfaceSoft,
                  disabledActiveTrackColor: theme.primary.withValues(
                    alpha: 0.35,
                  ),
                  disabledInactiveTrackColor: theme.surfaceMuted,
                  trackShape: theme.isNes
                      ? const RectangularSliderTrackShape()
                      : const RoundedRectSliderTrackShape(),
                  overlayShape: theme.isNes
                      ? SliderComponentShape.noOverlay
                      : const RoundSliderOverlayShape(overlayRadius: 18),
                  overlayColor: theme.primary.withValues(alpha: 0.14),
                  thumbShape: _AnimalSliderThumbShape(theme: theme),
                  activeTickMarkColor: Colors.transparent,
                  inactiveTickMarkColor: Colors.transparent,
                ),
                child: Slider(
                  value: currentValue,
                  min: widget.min,
                  max: widget.max,
                  divisions: widget.divisions,
                  onChanged: widget.enabled ? _handleChanged : null,
                  onChangeEnd: widget.enabled ? widget.onChangeEnd : null,
                ),
              ),
            if (widget.leadingLabel != null || widget.trailingLabel != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Text(
                      widget.leadingLabel ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: theme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.trailingLabel ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: theme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _WestworldSliderTrack extends StatelessWidget {
  const _WestworldSliderTrack({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.enabled,
    required this.scan,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final bool enabled;
  final Animation<double> scan;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  static const double _horizontalInset = 14;

  double _valueFromLocalPosition(Offset localPosition, double width) {
    final usableWidth = math.max(1.0, width - _horizontalInset * 2);
    final rawRatio = ((localPosition.dx - _horizontalInset) / usableWidth)
        .clamp(0.0, 1.0);
    final snappedRatio = switch (divisions) {
      final int count when count > 0 => (rawRatio * count).round() / count,
      _ => rawRatio,
    };
    return min + (max - min) * snappedRatio;
  }

  void _update(Offset localPosition, double width, {required bool ended}) {
    if (!enabled) {
      return;
    }
    final next = _valueFromLocalPosition(localPosition, width);
    onChanged(next);
    if (ended) {
      onChangeEnd?.call(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 320.0;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled
              ? (details) => _update(details.localPosition, width, ended: false)
              : null,
          onTapUp: enabled
              ? (details) => _update(details.localPosition, width, ended: true)
              : null,
          onHorizontalDragUpdate: enabled
              ? (details) => _update(details.localPosition, width, ended: false)
              : null,
          onHorizontalDragEnd: enabled ? (_) => onChangeEnd?.call(value) : null,
          child: SizedBox(
            height: 38,
            width: width,
            child: AnimatedBuilder(
              animation: scan,
              builder: (context, child) => CustomPaint(
                painter: _WestworldSliderPainter(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  progress: scan.value,
                  enabled: enabled,
                  line: theme.panelLineColor(emphasized: true),
                  muted: theme.panelLineColor(),
                  active: theme.primary,
                  surface: theme.surfaceRaised,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WestworldSliderPainter extends CustomPainter {
  const _WestworldSliderPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.progress,
    required this.enabled,
    required this.line,
    required this.muted,
    required this.active,
    required this.surface,
  });

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final double progress;
  final bool enabled;
  final Color line;
  final Color muted;
  final Color active;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    const inset = _WestworldSliderTrack._horizontalInset;
    final start = inset;
    final end = math.max(start + 1, size.width - inset);
    final width = end - start;
    final y = size.height * 0.42;
    final ratio = max == min ? 0.0 : ((value - min) / (max - min)).clamp(0, 1);
    final thumbX = start + width * ratio;
    final opacity = enabled ? 1.0 : 0.42;

    const depth = 6.0;
    final railPath = Path()
      ..moveTo(start, y)
      ..lineTo(end, y)
      ..lineTo(end - depth, y + depth)
      ..moveTo(start, y)
      ..lineTo(start + depth, y + depth)
      ..lineTo(end - depth, y + depth);
    final rail = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = muted.withValues(alpha: 0.58 * opacity);
    canvas.drawPath(railPath, rail);
    final tickPaint = Paint()
      ..strokeWidth = 1
      ..color = muted.withValues(alpha: 0.26 * opacity);
    final tickCount = divisions == null ? 32 : math.min(48, divisions!);
    for (var i = 0; i <= tickCount; i += 1) {
      final x = start + width * (i / tickCount);
      final projectedX = x + depth * 0.5;
      final tall = i % 8 == 0;
      canvas.drawLine(
        Offset(projectedX, y + depth + 3),
        Offset(projectedX, y + depth + (tall ? 11 : 8)),
        tickPaint,
      );
    }

    final activePaint = Paint()
      ..strokeWidth = 1.2
      ..color = active.withValues(alpha: 0.78 * opacity);
    canvas.drawLine(Offset(start, y), Offset(thumbX, y), activePaint);
    canvas.drawLine(
      Offset(start + depth, y + depth),
      Offset(thumbX + depth * 0.5, y + depth),
      activePaint..color = active.withValues(alpha: 0.28 * opacity),
    );

    if (enabled) {
      final scanX = start + width * progress;
      canvas.drawLine(
        Offset(scanX, y - 8),
        Offset(scanX + depth * 0.5, y + depth + 10),
        Paint()
          ..strokeWidth = 1
          ..color = active.withValues(alpha: 0.14),
      );
    }

    final thumbLine = Paint()
      ..strokeWidth = 1.1
      ..color = active.withValues(alpha: 0.86 * opacity);
    final cursor = Path()
      ..moveTo(thumbX - 5, y - 9)
      ..lineTo(thumbX + 4, y - 9)
      ..lineTo(thumbX + depth, y + depth + 9)
      ..lineTo(thumbX - 4, y + depth + 9)
      ..close();
    canvas.drawPath(cursor, Paint()..color = surface.withValues(alpha: 0.84));
    canvas.drawPath(cursor, thumbLine);
    canvas.drawLine(
      Offset(thumbX - 9, y - 12),
      Offset(thumbX + 8, y - 12),
      Paint()
        ..strokeWidth = 1
        ..color = active.withValues(alpha: 0.32 * opacity),
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldSliderPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.min != min ||
        oldDelegate.max != max ||
        oldDelegate.divisions != divisions ||
        oldDelegate.progress != progress ||
        oldDelegate.enabled != enabled ||
        oldDelegate.line != line ||
        oldDelegate.muted != muted ||
        oldDelegate.active != active ||
        oldDelegate.surface != surface;
  }
}

class _AnimalSliderThumbShape extends SliderComponentShape {
  const _AnimalSliderThumbShape({required this.theme});

  final AnimalIslandThemeData theme;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(24, 24);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    if (theme.isNes) {
      final rect = Rect.fromCenter(center: center, width: 20, height: 22);
      canvas.drawRect(
        rect.translate(0, 4),
        Paint()..color = theme.buttonShadow,
      );
      canvas.drawRect(rect, Paint()..color = theme.surfaceRaised);
      canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = theme.border,
      );
      canvas.drawRect(
        Rect.fromCenter(center: center, width: 8, height: 8),
        Paint()..color = theme.primary,
      );
      return;
    }
    canvas.drawCircle(
      center + const Offset(0, 3),
      10,
      Paint()..color = theme.buttonShadow.withValues(alpha: 0.9),
    );
    canvas.drawCircle(center, 10, Paint()..color = theme.surfaceRaised);
    canvas.drawCircle(
      center,
      10,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = theme.primary,
    );
    canvas.drawCircle(center, 4.5, Paint()..color = theme.primary);
  }
}
