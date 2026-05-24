import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/animal_island_models.dart';
import '../../theme/animal_island_theme.dart';

abstract final class AnimalSliderThemeStrategy {
  const AnimalSliderThemeStrategy();

  static AnimalSliderThemeStrategy of(AnimalIslandThemeData theme) {
    return switch (theme.gameStyle) {
      AnimalIslandGameStyle.nes8Bit => const _NesAnimalSliderThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalSliderThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandSliderThemeStrategy(),
    };
  }

  Widget buildControl({
    required BuildContext context,
    required AnimalIslandThemeData theme,
    required double currentValue,
    required double min,
    required double max,
    required int? divisions,
    required bool enabled,
    required Animation<double> scan,
    required ValueChanged<double> onChanged,
    required ValueChanged<double>? onChangeEnd,
  });
}

final class _AnimalIslandSliderThemeStrategy extends AnimalSliderThemeStrategy {
  const _AnimalIslandSliderThemeStrategy();

  @override
  Widget buildControl({
    required BuildContext context,
    required AnimalIslandThemeData theme,
    required double currentValue,
    required double min,
    required double max,
    required int? divisions,
    required bool enabled,
    required Animation<double> scan,
    required ValueChanged<double> onChanged,
    required ValueChanged<double>? onChangeEnd,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 12,
        activeTrackColor: theme.primary,
        inactiveTrackColor: theme.surfaceSoft,
        disabledActiveTrackColor: theme.primary.withValues(alpha: 0.35),
        disabledInactiveTrackColor: theme.surfaceMuted,
        trackShape: const RoundedRectSliderTrackShape(),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
        overlayColor: theme.primary.withValues(alpha: 0.14),
        thumbShape: AnimalSliderThumbShape(theme: theme),
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: Slider(
        value: currentValue,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: enabled ? onChanged : null,
        onChangeEnd: enabled ? onChangeEnd : null,
      ),
    );
  }
}

final class _NesAnimalSliderThemeStrategy extends AnimalSliderThemeStrategy {
  const _NesAnimalSliderThemeStrategy();

  @override
  Widget buildControl({
    required BuildContext context,
    required AnimalIslandThemeData theme,
    required double currentValue,
    required double min,
    required double max,
    required int? divisions,
    required bool enabled,
    required Animation<double> scan,
    required ValueChanged<double> onChanged,
    required ValueChanged<double>? onChangeEnd,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 14,
        activeTrackColor: theme.primary,
        inactiveTrackColor: theme.surfaceSoft,
        disabledActiveTrackColor: theme.primary.withValues(alpha: 0.35),
        disabledInactiveTrackColor: theme.surfaceMuted,
        trackShape: const RectangularSliderTrackShape(),
        overlayShape: SliderComponentShape.noOverlay,
        overlayColor: theme.primary.withValues(alpha: 0.14),
        thumbShape: AnimalSliderThumbShape(theme: theme),
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: Slider(
        value: currentValue,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: enabled ? onChanged : null,
        onChangeEnd: enabled ? onChangeEnd : null,
      ),
    );
  }
}

final class _WestworldAnimalSliderThemeStrategy
    extends AnimalSliderThemeStrategy {
  const _WestworldAnimalSliderThemeStrategy();

  @override
  Widget buildControl({
    required BuildContext context,
    required AnimalIslandThemeData theme,
    required double currentValue,
    required double min,
    required double max,
    required int? divisions,
    required bool enabled,
    required Animation<double> scan,
    required ValueChanged<double> onChanged,
    required ValueChanged<double>? onChangeEnd,
  }) {
    return _WestworldSliderTrack(
      value: currentValue,
      min: min,
      max: max,
      divisions: divisions,
      enabled: enabled,
      scan: scan,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
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

class AnimalSliderThumbShape extends SliderComponentShape {
  const AnimalSliderThumbShape({required this.theme});

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
    if (theme.gameStyle == AnimalIslandGameStyle.nes8Bit) {
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
