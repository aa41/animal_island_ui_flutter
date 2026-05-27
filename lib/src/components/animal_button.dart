import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '_animal_dashed_outline.dart';
import 'animal_component_dispatcher.dart';
import 'guofeng_components.dart';
import 'theme_strategies/animal_button_theme_strategy.dart';

class AnimalButton extends StatelessWidget {
  const AnimalButton({
    super.key,
    this.type = AnimalButtonType.defaultType,
    this.size = AnimalButtonSize.middle,
    this.danger = false,
    this.ghost = false,
    this.block = false,
    this.loading = false,
    this.enabled = true,
    this.icon,
    this.onPressed,
    required this.child,
  });

  final AnimalButtonType type;
  final AnimalButtonSize size;
  final bool danger;
  final bool ghost;
  final bool block;
  final bool loading;
  final bool enabled;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandButton(
        type: type,
        size: size,
        danger: danger,
        ghost: ghost,
        block: block,
        loading: loading,
        enabled: enabled,
        icon: icon,
        onPressed: onPressed,
        child: child,
      ),
      nes: (_) => _NesAnimalButton(
        type: type,
        size: size,
        danger: danger,
        ghost: ghost,
        block: block,
        loading: loading,
        enabled: enabled,
        icon: icon,
        onPressed: onPressed,
        child: child,
      ),
      westworld: (_) => _WestworldAnimalButton(
        type: type,
        size: size,
        danger: danger,
        ghost: ghost,
        block: block,
        loading: loading,
        enabled: enabled,
        icon: icon,
        onPressed: onPressed,
        child: child,
      ),
      guofeng: (_) => _GuofengAnimalButton(
        type: type,
        size: size,
        danger: danger,
        ghost: ghost,
        block: block,
        loading: loading,
        enabled: enabled,
        icon: icon,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class _AnimalIslandButton extends _ThemedAnimalButton {
  const _AnimalIslandButton({
    required super.type,
    required super.size,
    required super.danger,
    required super.ghost,
    required super.block,
    required super.loading,
    required super.enabled,
    required super.icon,
    required super.onPressed,
    required super.child,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalButton extends _ThemedAnimalButton {
  const _NesAnimalButton({
    required super.type,
    required super.size,
    required super.danger,
    required super.ghost,
    required super.block,
    required super.loading,
    required super.enabled,
    required super.icon,
    required super.onPressed,
    required super.child,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalButton extends _ThemedAnimalButton {
  const _WestworldAnimalButton({
    required super.type,
    required super.size,
    required super.danger,
    required super.ghost,
    required super.block,
    required super.loading,
    required super.enabled,
    required super.icon,
    required super.onPressed,
    required super.child,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalButton extends _ThemedAnimalButton {
  const _GuofengAnimalButton({
    required super.type,
    required super.size,
    required super.danger,
    required super.ghost,
    required super.block,
    required super.loading,
    required super.enabled,
    required super.icon,
    required super.onPressed,
    required super.child,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalButton extends StatefulWidget {
  const _ThemedAnimalButton({
    required this.gameStyle,
    required this.type,
    required this.size,
    required this.danger,
    required this.ghost,
    required this.block,
    required this.loading,
    required this.enabled,
    required this.icon,
    required this.onPressed,
    required this.child,
  });

  final AnimalIslandGameStyle gameStyle;
  final AnimalButtonType type;
  final AnimalButtonSize size;
  final bool danger;
  final bool ghost;
  final bool block;
  final bool loading;
  final bool enabled;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<_ThemedAnimalButton> createState() => _ThemedAnimalButtonState();
}

class _ThemedAnimalButtonState extends State<_ThemedAnimalButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;

  AnimationController? _controller;

  AnimationController get _loadingController =>
      _controller ??= AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      )..repeat();

  @override
  void initState() {
    super.initState();
    _syncLoadingController();
  }

  @override
  void didUpdateWidget(covariant _ThemedAnimalButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loading != widget.loading) {
      _syncLoadingController();
    }
  }

  void _syncLoadingController() {
    if (widget.loading) {
      _loadingController.repeat();
      return;
    }
    _controller?.stop();
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final enabled =
        widget.enabled && !widget.loading && widget.onPressed != null;

    final metrics = switch (widget.size) {
      AnimalButtonSize.small => _ButtonMetrics(
        height: AnimalIslandTokens.heightSm,
        horizontal: theme.spec.buttonHorizontalSmall,
        fontSize: AnimalIslandTokens.fontCaption,
        radius: theme.radiusSm,
      ),
      AnimalButtonSize.middle => _ButtonMetrics(
        height: AnimalIslandTokens.heightMdButton,
        horizontal: theme.spec.buttonHorizontalMiddle,
        fontSize: AnimalIslandTokens.fontLabel,
        radius: theme.radiusPill,
      ),
      AnimalButtonSize.large => _ButtonMetrics(
        height: AnimalIslandTokens.heightLg,
        horizontal: theme.spec.buttonHorizontalLarge,
        fontSize: AnimalIslandTokens.fontBody,
        radius: theme.radiusLg,
      ),
    };

    final strategy = AnimalButtonThemeStrategy.forGameStyle(widget.gameStyle);
    final colors = strategy.resolveColors(
      theme,
      type: widget.type,
      danger: widget.danger,
      ghost: widget.ghost,
      loading: widget.loading,
    );
    final shadowDepth = widget.loading
        ? 0.0
        : _pressed
        ? theme.spec.buttonShadowPressed
        : _hovered
        ? theme.spec.buttonShadowHover
        : theme.spec.buttonShadowRest;
    final offsetY = widget.loading
        ? 0.0
        : _pressed
        ? theme.spec.buttonPressedOffsetY
        : _hovered
        ? theme.spec.buttonHoverOffsetY
        : 0.0;

    final content = DefaultTextStyle(
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
        fontSize: metrics.fontSize,
        color: enabled
            ? colors.foreground
            : colors.foreground.withValues(alpha: 0.5),
        letterSpacing: theme.spec.isPixel ? 0 : theme.spec.labelSpacing,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null && !widget.loading) ...[
            widget.icon!,
            const SizedBox(width: AnimalIslandTokens.spacingSm),
          ],
          Flexible(child: widget.child),
        ],
      ),
    );

    final showDashedBorder =
        widget.type == AnimalButtonType.dashed && !widget.loading;
    final isGuofeng = widget.gameStyle == AnimalIslandGameStyle.guofengDoodle;

    final buttonChild = Stack(
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: theme.interactionDuration,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(metrics.radius),
              color: colors.background,
              border: showDashedBorder || isGuofeng
                  ? null
                  : Border.all(color: colors.border, width: theme.borderWidth),
              boxShadow: shadowDepth == 0
                  ? null
                  : [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 0,
                        offset: Offset(0, shadowDepth),
                      ),
                    ],
            ),
          ),
        ),
        if (isGuofeng)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GuofengInkOutlinePainter(
                  color: colors.border,
                  radius: metrics.radius,
                  strokeWidth: theme.borderWidth,
                  seed: widget.type.index + widget.size.index * 7,
                  dashed: showDashedBorder,
                ),
              ),
            ),
          )
        else if (showDashedBorder)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: AnimalDashedOutlinePainter(
                  color: colors.border,
                  radius: metrics.radius,
                  strokeWidth: theme.borderWidth,
                ),
              ),
            ),
          ),
        if (isGuofeng && (_hovered || _pressed) && enabled)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GuofengBrushFocusPainter(
                  color: _pressed ? theme.focusYellowDark : theme.focusYellow,
                  radius: metrics.radius,
                  seed: widget.type.index + 3,
                ),
              ),
            ),
          ),
        if (widget.loading)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _loadingController,
              builder: (context, child) => CustomPaint(
                painter: _resolveLoadingPainter(
                  strategy,
                  theme,
                  metrics.radius,
                  _loadingController.value,
                ),
              ),
            ),
          ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.horizontal,
              vertical: (metrics.height - metrics.fontSize - 8) / 2,
            ),
            child: content,
          ),
        ),
      ],
    );

    final translated = AnimatedContainer(
      duration: theme.interactionDuration,
      transform: Matrix4.translationValues(0, offsetY, 0),
      height: metrics.height,
      child: buttonChild,
    );
    final child = widget.block
        ? SizedBox(width: double.infinity, child: translated)
        : IntrinsicWidth(child: translated);

    return MouseRegion(
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled
            ? (_) => setState(() {
                _pressed = false;
              })
            : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: enabled ? widget.onPressed : null,
        child: child,
      ),
    );
  }

  CustomPainter _resolveLoadingPainter(
    AnimalButtonThemeStrategy strategy,
    AnimalIslandThemeData theme,
    double radius,
    double progress,
  ) {
    switch (strategy.loadingStyle) {
      case AnimalButtonLoadingStyle.pixel:
        return _PixelLoadingPainter(
          progress: progress,
          base: theme.primary,
          stripe: theme.focusYellow,
        );
      case AnimalButtonLoadingStyle.scanline:
        return _ScanlineLoadingPainter(
          progress: progress,
          base: theme.surfaceRaised.withValues(alpha: 0.14),
          line: theme.primary.withValues(alpha: 0.56),
          muted: theme.panelLineColor(),
        );
      case AnimalButtonLoadingStyle.stripe:
        return _StripePainter(
          progress: progress,
          base: theme.isGuofengDoodle ? theme.primary : const Color(0xFF0EC4B6),
          stripe: theme.isGuofengDoodle
              ? theme.focusYellow.withValues(alpha: 0.34)
              : const Color(0xFF01B0A7),
          radius: radius,
        );
    }
  }
}

class _ButtonMetrics {
  const _ButtonMetrics({
    required this.height,
    required this.horizontal,
    required this.fontSize,
    required this.radius,
  });

  final double height;
  final double horizontal;
  final double fontSize;
  final double radius;
}

class _StripePainter extends CustomPainter {
  const _StripePainter({
    required this.progress,
    required this.base,
    required this.stripe,
    required this.radius,
  });

  final double progress;
  final Color base;
  final Color stripe;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final safeRadius = radius.clamp(0.0, math.min(size.width, size.height) / 2);
    final clip = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(safeRadius),
        ),
      );

    canvas.save();
    canvas.clipPath(clip);
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = base);

    final stripePaint = Paint()..color = stripe;
    final spacing = 20.0;
    final stripeWidth = 10.0;
    final diagonal = math.sqrt(
      size.width * size.width + size.height * size.height,
    );
    final offset = -progress * spacing * 2;

    canvas.translate(offset, 0);
    canvas.rotate(-math.pi / 4);

    for (double x = -diagonal; x < diagonal * 2; x += spacing) {
      canvas.drawRect(
        Rect.fromLTWH(x, -diagonal, stripeWidth, diagonal * 3),
        stripePaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StripePainter other) {
    return other.progress != progress ||
        other.base != base ||
        other.stripe != stripe;
  }
}

class _PixelLoadingPainter extends CustomPainter {
  const _PixelLoadingPainter({
    required this.progress,
    required this.base,
    required this.stripe,
  });

  final double progress;
  final Color base;
  final Color stripe;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    canvas.drawRect(Offset.zero & size, Paint()..color = base);
    final paint = Paint()..color = stripe.withValues(alpha: 0.72);
    const block = 8.0;
    final offset = (progress * block * 4) % (block * 2);
    for (var x = -block * 2 + offset; x < size.width + block; x += block * 2) {
      canvas.drawRect(Rect.fromLTWH(x, 0, block, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelLoadingPainter other) {
    return other.progress != progress ||
        other.base != base ||
        other.stripe != stripe;
  }
}

class _ScanlineLoadingPainter extends CustomPainter {
  const _ScanlineLoadingPainter({
    required this.progress,
    required this.base,
    required this.line,
    required this.muted,
  });

  final double progress;
  final Color base;
  final Color line;
  final Color muted;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final y = size.height - 6;
    final startX = 14.0;
    final endX = size.width - 14;
    final tickPaint = Paint()
      ..color = line.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    for (var i = 0; i <= 8; i += 1) {
      final x = startX + (endX - startX) * (i / 8);
      canvas.drawLine(
        Offset(x, y - (i == 0 || i == 8 ? 8 : 4)),
        Offset(x, y + 2),
        tickPaint,
      );
    }
    canvas.drawLine(
      Offset(startX, y),
      Offset(endX, y),
      Paint()
        ..strokeWidth = 1
        ..color = muted.withValues(alpha: 0.36),
    );
    canvas.drawLine(
      Offset(startX, y),
      Offset(startX + (endX - startX) * progress, y),
      Paint()
        ..strokeWidth = 1.4
        ..color = line.withValues(alpha: 0.72),
    );
  }

  @override
  bool shouldRepaint(covariant _ScanlineLoadingPainter other) {
    return other.progress != progress ||
        other.base != base ||
        other.line != line ||
        other.muted != muted;
  }
}
