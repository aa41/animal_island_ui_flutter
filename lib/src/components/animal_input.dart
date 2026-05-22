import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';

enum AnimalInputStatus { error, warning }

class AnimalInput extends StatefulWidget {
  const AnimalInput({
    super.key,
    this.controller,
    this.focusNode,
    this.size = AnimalInputSize.middle,
    this.prefix,
    this.suffix,
    this.allowClear = false,
    this.status,
    this.shadow = false,
    this.enabled = true,
    this.hintText,
    this.onChanged,
    this.onClear,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final AnimalInputSize size;
  final Widget? prefix;
  final Widget? suffix;
  final bool allowClear;
  final AnimalInputStatus? status;
  final bool shadow;
  final bool enabled;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  State<AnimalInput> createState() => _AnimalInputState();
}

class _AnimalInputState extends State<AnimalInput> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChange);
    _focusNode.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(covariant AnimalInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller &&
        widget.controller != null) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      _controller.removeListener(_handleControllerChange);
      widget.controller!.addListener(_handleControllerChange);
    }
    if (oldWidget.focusNode != widget.focusNode && widget.focusNode != null) {
      oldWidget.focusNode?.removeListener(_handleControllerChange);
      _focusNode.removeListener(_handleControllerChange);
      widget.focusNode!.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_handleControllerChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleControllerChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final focused = _focusNode.hasFocus;
    final hasText = _controller.text.isNotEmpty;

    final metrics = switch (widget.size) {
      AnimalInputSize.small => _InputMetrics(
        height: AnimalIslandTokens.heightSm,
        horizontal: theme.isNes ? 10 : 14,
        fontSize: AnimalIslandTokens.fontCaption,
        radius: theme.isNes ? theme.radiusSm : 40,
        borderWidth: theme.inputBorderWidth,
        shadowDepth: theme.isNes ? 3 : 2,
      ),
      AnimalInputSize.middle => _InputMetrics(
        height: AnimalIslandTokens.heightBase,
        horizontal: theme.isNes ? 12 : 18,
        fontSize: AnimalIslandTokens.fontLabel,
        radius: theme.isNes ? theme.radiusBase : 50,
        borderWidth: theme.inputBorderWidth,
        shadowDepth: 3,
      ),
      AnimalInputSize.large => _InputMetrics(
        height: AnimalIslandTokens.heightLg,
        horizontal: theme.isNes ? 14 : 22,
        fontSize: AnimalIslandTokens.fontBody,
        radius: theme.isNes ? theme.radiusLg : 50,
        borderWidth: theme.inputBorderWidth,
        shadowDepth: 4,
      ),
    };

    Color borderColor = theme.borderLight;
    Color shadowColor = theme.inputShadow;
    if (_hovered) {
      borderColor = theme.borderHover;
      shadowColor = theme.borderLight;
    }
    if (focused) {
      borderColor = theme.focusYellow;
      shadowColor = theme.focusYellowDark;
    }
    if (widget.status == AnimalInputStatus.error) {
      borderColor = theme.error;
      shadowColor = theme.errorActive;
    }
    if (widget.status == AnimalInputStatus.warning) {
      borderColor = theme.warning;
      shadowColor = theme.warningActive;
    }
    if (!widget.enabled) {
      borderColor = theme.inputShadow;
      shadowColor = Colors.transparent;
    }

    return MouseRegion(
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: theme.isNes
            ? AnimalIslandTokens.pixelStep
            : AnimalIslandTokens.base,
        curve: theme.interactionCurve,
        height: metrics.height,
        padding: EdgeInsets.symmetric(horizontal: metrics.horizontal),
        decoration: BoxDecoration(
          color: widget.enabled
              ? (theme.isNes ? theme.surface : theme.surfaceRaised)
              : theme.surfaceMuted,
          borderRadius: BorderRadius.circular(metrics.radius),
          border: Border.all(color: borderColor, width: metrics.borderWidth),
          boxShadow: !widget.shadow && widget.status == null && !focused
              ? null
              : [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 0,
                    offset: Offset(0, metrics.shadowDepth),
                  ),
                ],
        ),
        child: Row(
          children: [
            if (widget.prefix != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: theme.textSecondary,
                  size: metrics.fontSize + 2,
                ),
                child: widget.prefix!,
              ),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: metrics.fontSize,
                  color: widget.enabled ? theme.textBody : theme.textDisabled,
                  letterSpacing: 0.14,
                  fontFamily: theme.isNes ? 'Press Start 2P' : null,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: theme.textDisabled,
                    fontWeight: FontWeight.w400,
                    fontSize: metrics.fontSize,
                  ),
                ),
                onChanged: widget.onChanged,
              ),
            ),
            if (widget.allowClear && hasText && widget.enabled)
              GestureDetector(
                onTap: _clear,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: _hovered
                        ? theme.textBody.withValues(alpha: 0.1)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '×',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _hovered ? theme.textBody : theme.textDisabled,
                      fontSize: AnimalIslandTokens.fontBodySm,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            if (widget.suffix != null) ...[
              const SizedBox(width: 6),
              IconTheme(
                data: IconThemeData(
                  color: theme.textSecondary,
                  size: metrics.fontSize + 2,
                ),
                child: widget.suffix!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InputMetrics {
  const _InputMetrics({
    required this.height,
    required this.horizontal,
    required this.fontSize,
    required this.radius,
    required this.borderWidth,
    required this.shadowDepth,
  });

  final double height;
  final double horizontal;
  final double fontSize;
  final double radius;
  final double borderWidth;
  final double shadowDepth;
}
