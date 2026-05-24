import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import 'theme_strategies/animal_switch_theme_strategy.dart';

class AnimalSwitch extends StatefulWidget {
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
  State<AnimalSwitch> createState() => _AnimalSwitchState();
}

class _AnimalSwitchState extends State<AnimalSwitch>
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
  void didUpdateWidget(covariant AnimalSwitch oldWidget) {
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
    final strategy = AnimalSwitchThemeStrategy.of(theme);
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
