import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';

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
        duration: const Duration(milliseconds: 600),
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
    final minWidth = small ? 38.0 : 52.0;
    final height = small ? 20.0 : 28.0;
    final knob = small ? 14.0 : 21.0;
    final disabled = !widget.enabled;
    final knobPadding = small ? 20.0 : 28.0;
    final horizontalTextPadding = small ? 6.0 : 8.0;
    final hasText =
        widget.checkedChild != null || widget.uncheckedChild != null;
    final textStyle = Theme.of(context).textTheme.labelMedium!.copyWith(
      color: Colors.white.withValues(alpha: disabled ? 0.5 : 1),
      fontSize: small ? 9 : 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.22,
      height: 1,
      shadows: const [
        Shadow(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(0, 1),
          blurRadius: 1,
        ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggle,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: IntrinsicWidth(
          child: AnimatedContainer(
            duration: AnimalIslandTokens.base,
            curve: AnimalIslandTokens.motionCurve,
            constraints: BoxConstraints(minWidth: minWidth),
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: checked
                  ? const Color(0xFF86D67A)
                  : const Color(0xFFD4C9B4),
              borderRadius: BorderRadius.circular(
                AnimalIslandTokens.radiusPill,
              ),
              border: Border.all(
                color: checked ? theme.success : theme.borderLight,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (checked ? theme.successActive : theme.textMuted)
                      .withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(width: minWidth - 4, height: height),
                if (hasText)
                  Positioned.fill(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          checked ? horizontalTextPadding : knobPadding,
                          0,
                          checked ? knobPadding : horizontalTextPadding,
                          0,
                        ),
                        child: DefaultTextStyle(
                          style: textStyle,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          child: checked
                              ? widget.checkedChild ?? const SizedBox.shrink()
                              : widget.uncheckedChild ??
                                    const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                AnimatedPositioned(
                  duration: AnimalIslandTokens.base,
                  curve: AnimalIslandTokens.motionCurve,
                  left: checked ? null : 0,
                  right: checked ? 0 : null,
                  top: small ? 1 : 2,
                  child: Transform.translate(
                    offset: const Offset(0, -1),
                    child: Container(
                      width: knob,
                      height: knob,
                      decoration: BoxDecoration(
                        color: theme.surfaceRaised,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: checked ? theme.success : theme.borderLight,
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: checked
                                ? theme.successActive
                                : theme.buttonShadow,
                            blurRadius: 0,
                            offset: Offset(0, small ? 2 : 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: widget.loading
                            ? RotationTransition(
                                turns: _controller,
                                child: SizedBox(
                                  width: 11,
                                  height: 11,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: checked
                                        ? theme.success
                                        : theme.textSecondary,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
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
