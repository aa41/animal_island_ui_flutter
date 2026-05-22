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

class _AnimalSliderState extends State<AnimalSlider> {
  late double _value = widget.value ?? widget.initialValue;

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
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: theme.isNes ? 14 : 12,
                activeTrackColor: theme.primary,
                inactiveTrackColor: theme.surfaceSoft,
                disabledActiveTrackColor: theme.primary.withValues(alpha: 0.35),
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
