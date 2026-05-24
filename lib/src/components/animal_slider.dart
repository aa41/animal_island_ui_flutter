import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import 'animal_badge.dart';
import 'theme_strategies/animal_slider_theme_strategy.dart';

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
    final strategy = AnimalSliderThemeStrategy.of(theme);
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
            strategy.buildControl(
              context: context,
              theme: theme,
              currentValue: currentValue,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              enabled: widget.enabled,
              scan: _scanController,
              onChanged: _handleChanged,
              onChangeEnd: widget.onChangeEnd,
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
