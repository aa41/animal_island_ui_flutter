import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import 'animal_component_dispatcher.dart';
import 'theme_strategies/animal_switch_theme_strategy.dart';

class AnimalSwitch extends StatelessWidget {
  const AnimalSwitch({
    super.key,
    this.value,
    this.initialValue = false,
    this.size = AnimalSwitchSize.normal,
    this.enabled = true,
    this.loading = false,
    this.checkedChild,
    this.uncheckedChild,
    this.onChanged,
  });

  final bool? value;
  final bool initialValue;
  final AnimalSwitchSize size;
  final bool enabled;
  final bool loading;
  final Widget? checkedChild;
  final Widget? uncheckedChild;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandSwitch(
        value: value,
        initialValue: initialValue,
        size: size,
        enabled: enabled,
        loading: loading,
        checkedChild: checkedChild,
        uncheckedChild: uncheckedChild,
        onChanged: onChanged,
      ),
      nes: (_) => _NesAnimalSwitch(
        value: value,
        initialValue: initialValue,
        size: size,
        enabled: enabled,
        loading: loading,
        checkedChild: checkedChild,
        uncheckedChild: uncheckedChild,
        onChanged: onChanged,
      ),
      westworld: (_) => _WestworldAnimalSwitch(
        value: value,
        initialValue: initialValue,
        size: size,
        enabled: enabled,
        loading: loading,
        checkedChild: checkedChild,
        uncheckedChild: uncheckedChild,
        onChanged: onChanged,
      ),
      guofeng: (_) => _GuofengAnimalSwitch(
        value: value,
        initialValue: initialValue,
        size: size,
        enabled: enabled,
        loading: loading,
        checkedChild: checkedChild,
        uncheckedChild: uncheckedChild,
        onChanged: onChanged,
      ),
    );
  }
}

class _AnimalIslandSwitch extends _ThemedAnimalSwitch {
  const _AnimalIslandSwitch({
    required super.value,
    required super.initialValue,
    required super.size,
    required super.enabled,
    required super.loading,
    required super.checkedChild,
    required super.uncheckedChild,
    required super.onChanged,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalSwitch extends _ThemedAnimalSwitch {
  const _NesAnimalSwitch({
    required super.value,
    required super.initialValue,
    required super.size,
    required super.enabled,
    required super.loading,
    required super.checkedChild,
    required super.uncheckedChild,
    required super.onChanged,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalSwitch extends _ThemedAnimalSwitch {
  const _WestworldAnimalSwitch({
    required super.value,
    required super.initialValue,
    required super.size,
    required super.enabled,
    required super.loading,
    required super.checkedChild,
    required super.uncheckedChild,
    required super.onChanged,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalSwitch extends _ThemedAnimalSwitch {
  const _GuofengAnimalSwitch({
    required super.value,
    required super.initialValue,
    required super.size,
    required super.enabled,
    required super.loading,
    required super.checkedChild,
    required super.uncheckedChild,
    required super.onChanged,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalSwitch extends StatefulWidget {
  const _ThemedAnimalSwitch({
    required this.gameStyle,
    required this.value,
    required this.initialValue,
    required this.size,
    required this.enabled,
    required this.loading,
    required this.checkedChild,
    required this.uncheckedChild,
    required this.onChanged,
  });

  final AnimalIslandGameStyle gameStyle;
  final bool? value;
  final bool initialValue;
  final AnimalSwitchSize size;
  final bool enabled;
  final bool loading;
  final Widget? checkedChild;
  final Widget? uncheckedChild;
  final ValueChanged<bool>? onChanged;

  @override
  State<_ThemedAnimalSwitch> createState() => _ThemedAnimalSwitchState();
}

class _ThemedAnimalSwitchState extends State<_ThemedAnimalSwitch>
    with SingleTickerProviderStateMixin {
  late bool _value = widget.value ?? widget.initialValue;
  AnimationController? _spinController;

  AnimationController get _controller =>
      _spinController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      )..repeat();

  @override
  void initState() {
    super.initState();
    _syncLoading();
  }

  @override
  void didUpdateWidget(covariant _ThemedAnimalSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _value = widget.value!;
    }
    if (widget.loading != oldWidget.loading) {
      _syncLoading();
    }
  }

  void _syncLoading() {
    if (widget.loading) {
      _controller.repeat();
      return;
    }
    _spinController?.stop();
    _spinController?.dispose();
    _spinController = null;
  }

  @override
  void dispose() {
    _spinController?.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!widget.enabled || widget.loading) {
      return;
    }

    final next = !_value;
    if (widget.value == null) {
      setState(() => _value = next);
    }
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final checked = widget.value ?? _value;
    final small = widget.size == AnimalSwitchSize.small;
    final strategy = AnimalSwitchThemeStrategy.forGameStyle(widget.gameStyle);
    return strategy.buildControl(
      context: context,
      theme: theme,
      checked: checked,
      enabled: widget.enabled,
      loading: widget.loading,
      small: small,
      progress: _controller,
      checkedChild: widget.checkedChild,
      uncheckedChild: widget.uncheckedChild,
      onTap: _toggle,
    );
  }
}
