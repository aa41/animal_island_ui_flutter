import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import 'theme_strategies/animal_input_theme_strategy.dart';

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
    final strategy = AnimalInputThemeStrategy.of(theme);
    final focused = _focusNode.hasFocus;
    final hasText = _controller.text.isNotEmpty;

    final metrics = switch (widget.size) {
      AnimalInputSize.small => _InputMetrics(
        height: AnimalIslandTokens.heightSm,
        horizontal: theme.spec.inputHorizontalSmall,
        fontSize: AnimalIslandTokens.fontCaption,
        radius: strategy.radiusForSize(theme, widget.size),
        borderWidth: theme.inputBorderWidth,
        shadowDepth: theme.spec.inputShadowSmall,
      ),
      AnimalInputSize.middle => _InputMetrics(
        height: AnimalIslandTokens.heightBase,
        horizontal: theme.spec.inputHorizontalMiddle,
        fontSize: AnimalIslandTokens.fontLabel,
        radius: strategy.radiusForSize(theme, widget.size),
        borderWidth: theme.inputBorderWidth,
        shadowDepth: theme.spec.inputShadowMiddle,
      ),
      AnimalInputSize.large => _InputMetrics(
        height: AnimalIslandTokens.heightLg,
        horizontal: theme.spec.inputHorizontalLarge,
        fontSize: AnimalIslandTokens.fontBody,
        radius: strategy.radiusForSize(theme, widget.size),
        borderWidth: theme.inputBorderWidth,
        shadowDepth: theme.spec.inputShadowLarge,
      ),
    };

    return MouseRegion(
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: theme.interactionDuration,
        curve: theme.interactionCurve,
        height: metrics.height,
        padding: EdgeInsets.symmetric(horizontal: metrics.horizontal),
        decoration: strategy.decoration(
          theme,
          hovered: _hovered,
          focused: focused,
          enabled: widget.enabled,
          shadow: widget.shadow,
          status: widget.status,
          radius: metrics.radius,
          borderWidth: metrics.borderWidth,
          shadowDepth: metrics.shadowDepth,
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
                style: strategy.textStyle(
                  context,
                  theme,
                  enabled: widget.enabled,
                  fontSize: metrics.fontSize,
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
