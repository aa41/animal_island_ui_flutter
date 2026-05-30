import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import 'animal_component_dispatcher.dart';
import 'guofeng_components.dart';
import 'nes_pixel_frame.dart';
import 'theme_strategies/animal_input_theme_strategy.dart';

class AnimalInput extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandInput(
        controller: controller,
        focusNode: focusNode,
        size: size,
        prefix: prefix,
        suffix: suffix,
        allowClear: allowClear,
        status: status,
        shadow: shadow,
        enabled: enabled,
        hintText: hintText,
        onChanged: onChanged,
        onClear: onClear,
      ),
      nes: (_) => _NesAnimalInput(
        controller: controller,
        focusNode: focusNode,
        size: size,
        prefix: prefix,
        suffix: suffix,
        allowClear: allowClear,
        status: status,
        shadow: shadow,
        enabled: enabled,
        hintText: hintText,
        onChanged: onChanged,
        onClear: onClear,
      ),
      westworld: (_) => _WestworldAnimalInput(
        controller: controller,
        focusNode: focusNode,
        size: size,
        prefix: prefix,
        suffix: suffix,
        allowClear: allowClear,
        status: status,
        shadow: shadow,
        enabled: enabled,
        hintText: hintText,
        onChanged: onChanged,
        onClear: onClear,
      ),
      guofeng: (_) => _GuofengAnimalInput(
        controller: controller,
        focusNode: focusNode,
        size: size,
        prefix: prefix,
        suffix: suffix,
        allowClear: allowClear,
        status: status,
        shadow: shadow,
        enabled: enabled,
        hintText: hintText,
        onChanged: onChanged,
        onClear: onClear,
      ),
    );
  }
}

class _AnimalIslandInput extends _ThemedAnimalInput {
  const _AnimalIslandInput({
    required super.controller,
    required super.focusNode,
    required super.size,
    required super.prefix,
    required super.suffix,
    required super.allowClear,
    required super.status,
    required super.shadow,
    required super.enabled,
    required super.hintText,
    required super.onChanged,
    required super.onClear,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalInput extends _ThemedAnimalInput {
  const _NesAnimalInput({
    required super.controller,
    required super.focusNode,
    required super.size,
    required super.prefix,
    required super.suffix,
    required super.allowClear,
    required super.status,
    required super.shadow,
    required super.enabled,
    required super.hintText,
    required super.onChanged,
    required super.onClear,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalInput extends _ThemedAnimalInput {
  const _WestworldAnimalInput({
    required super.controller,
    required super.focusNode,
    required super.size,
    required super.prefix,
    required super.suffix,
    required super.allowClear,
    required super.status,
    required super.shadow,
    required super.enabled,
    required super.hintText,
    required super.onChanged,
    required super.onClear,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalInput extends _ThemedAnimalInput {
  const _GuofengAnimalInput({
    required super.controller,
    required super.focusNode,
    required super.size,
    required super.prefix,
    required super.suffix,
    required super.allowClear,
    required super.status,
    required super.shadow,
    required super.enabled,
    required super.hintText,
    required super.onChanged,
    required super.onClear,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalInput extends StatefulWidget {
  const _ThemedAnimalInput({
    required this.gameStyle,
    required this.controller,
    required this.focusNode,
    required this.size,
    required this.prefix,
    required this.suffix,
    required this.allowClear,
    required this.status,
    required this.shadow,
    required this.enabled,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
  });

  final AnimalIslandGameStyle gameStyle;
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
  State<_ThemedAnimalInput> createState() => _ThemedAnimalInputState();
}

class _ThemedAnimalInputState extends State<_ThemedAnimalInput> {
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
  void didUpdateWidget(covariant _ThemedAnimalInput oldWidget) {
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
    final strategy = AnimalInputThemeStrategy.forGameStyle(widget.gameStyle);
    final focused = _focusNode.hasFocus;
    final hasText = _controller.text.isNotEmpty;
    final isNes = widget.gameStyle == AnimalIslandGameStyle.nes8Bit;

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

    final inputContent = Row(
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
                shape: isNes ? BoxShape.rectangle : BoxShape.circle,
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
    );

    if (isNes) {
      final outlineColor = switch (widget.status) {
        AnimalInputStatus.error => theme.error,
        AnimalInputStatus.warning => theme.warning,
        _ =>
          focused
              ? theme.borderHover
              : _hovered
              ? theme.borderHover
              : theme.border,
      };
      return MouseRegion(
        onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
        child: AnimatedContainer(
          duration: theme.interactionDuration,
          curve: theme.interactionCurve,
          height: metrics.height + 8,
          child: NesPixelFrame(
            palette: NesPixelFramePalette(
              background: strategy.backgroundColor(
                theme,
                enabled: widget.enabled,
              ),
              border: outlineColor,
              shadow: theme.inputShadow,
              highlight: Colors.white,
              lowlight: theme.borderLight,
              accent: theme.borderHover,
            ),
            hovered: _hovered,
            focused: focused,
            disabled: !widget.enabled,
            texture: true,
            pixel: 4,
            shadowOffset: widget.shadow || focused
                ? Offset(4, metrics.shadowDepth)
                : const Offset(4, 4),
            padding: EdgeInsets.symmetric(
              horizontal: math.max(0, metrics.horizontal - 8),
            ),
            child: Center(child: inputContent),
          ),
        ),
      );
    }

    final input = MouseRegion(
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: theme.interactionDuration,
        curve: theme.interactionCurve,
        height: metrics.height,
        padding: EdgeInsets.symmetric(
          horizontal: metrics.horizontal,
          vertical: theme.isGuofengDoodle ? 1 : 0,
        ),
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
        child: inputContent,
      ),
    );
    if (widget.gameStyle != AnimalIslandGameStyle.guofengDoodle) {
      return input;
    }

    final outlineColor = switch (widget.status) {
      AnimalInputStatus.error => theme.error,
      AnimalInputStatus.warning => theme.warning,
      _ =>
        focused
            ? theme.primary
            : _hovered
            ? theme.borderHover
            : theme.border,
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        input,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: GuofengInkOutlinePainter(
                color: outlineColor,
                radius: metrics.radius,
                strokeWidth: theme.inputBorderWidth,
                seed: widget.size.index + 11,
              ),
            ),
          ),
        ),
        if (focused)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GuofengBrushFocusPainter(
                  color: outlineColor,
                  radius: metrics.radius,
                  strokeWidth: 1.2,
                  seed: widget.size.index + 19,
                ),
              ),
            ),
          ),
      ],
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
