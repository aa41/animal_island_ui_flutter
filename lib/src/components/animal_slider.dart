import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import 'animal_badge.dart';
import 'animal_component_dispatcher.dart';
import 'theme_strategies/animal_slider_theme_strategy.dart';

class AnimalSlider extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandSlider(
        value: value,
        initialValue: initialValue,
        min: min,
        max: max,
        divisions: divisions,
        enabled: enabled,
        showValue: showValue,
        leadingLabel: leadingLabel,
        trailingLabel: trailingLabel,
        valueLabelBuilder: valueLabelBuilder,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
      ),
      nes: (_) => _NesAnimalSlider(
        value: value,
        initialValue: initialValue,
        min: min,
        max: max,
        divisions: divisions,
        enabled: enabled,
        showValue: showValue,
        leadingLabel: leadingLabel,
        trailingLabel: trailingLabel,
        valueLabelBuilder: valueLabelBuilder,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
      ),
      westworld: (_) => _WestworldAnimalSlider(
        value: value,
        initialValue: initialValue,
        min: min,
        max: max,
        divisions: divisions,
        enabled: enabled,
        showValue: showValue,
        leadingLabel: leadingLabel,
        trailingLabel: trailingLabel,
        valueLabelBuilder: valueLabelBuilder,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
      ),
      guofeng: (_) => _GuofengAnimalSlider(
        value: value,
        initialValue: initialValue,
        min: min,
        max: max,
        divisions: divisions,
        enabled: enabled,
        showValue: showValue,
        leadingLabel: leadingLabel,
        trailingLabel: trailingLabel,
        valueLabelBuilder: valueLabelBuilder,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
      ),
    );
  }
}

class _AnimalIslandSlider extends _ThemedAnimalSlider {
  const _AnimalIslandSlider({
    required super.value,
    required super.initialValue,
    required super.min,
    required super.max,
    required super.divisions,
    required super.enabled,
    required super.showValue,
    required super.leadingLabel,
    required super.trailingLabel,
    required super.valueLabelBuilder,
    required super.onChanged,
    required super.onChangeEnd,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalSlider extends _ThemedAnimalSlider {
  const _NesAnimalSlider({
    required super.value,
    required super.initialValue,
    required super.min,
    required super.max,
    required super.divisions,
    required super.enabled,
    required super.showValue,
    required super.leadingLabel,
    required super.trailingLabel,
    required super.valueLabelBuilder,
    required super.onChanged,
    required super.onChangeEnd,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalSlider extends _ThemedAnimalSlider {
  const _WestworldAnimalSlider({
    required super.value,
    required super.initialValue,
    required super.min,
    required super.max,
    required super.divisions,
    required super.enabled,
    required super.showValue,
    required super.leadingLabel,
    required super.trailingLabel,
    required super.valueLabelBuilder,
    required super.onChanged,
    required super.onChangeEnd,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalSlider extends _ThemedAnimalSlider {
  const _GuofengAnimalSlider({
    required super.value,
    required super.initialValue,
    required super.min,
    required super.max,
    required super.divisions,
    required super.enabled,
    required super.showValue,
    required super.leadingLabel,
    required super.trailingLabel,
    required super.valueLabelBuilder,
    required super.onChanged,
    required super.onChangeEnd,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalSlider extends StatefulWidget {
  const _ThemedAnimalSlider({
    required this.gameStyle,
    required this.value,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.enabled,
    required this.showValue,
    required this.leadingLabel,
    required this.trailingLabel,
    required this.valueLabelBuilder,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final AnimalIslandGameStyle gameStyle;
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
  State<_ThemedAnimalSlider> createState() => _ThemedAnimalSliderState();
}

class _ThemedAnimalSliderState extends State<_ThemedAnimalSlider>
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
  void didUpdateWidget(covariant _ThemedAnimalSlider oldWidget) {
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
    final strategy = AnimalSliderThemeStrategy.forGameStyle(widget.gameStyle);
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
