import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '_animal_dashed_outline.dart';

class AnimalButton extends StatefulWidget {
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
  State<AnimalButton> createState() => _AnimalButtonState();
}

class _AnimalButtonState extends State<AnimalButton>
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
  void didUpdateWidget(covariant AnimalButton oldWidget) {
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

    final colors = _resolveColors(theme);
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
        mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.loading && theme.isWestworld) ...[
            _WestworldButtonLoadingGlyph(
              controller: _loadingController,
              color: colors.foreground,
            ),
            const SizedBox(width: AnimalIslandTokens.spacingSm),
          ],
          if (widget.icon != null && !widget.loading) ...[
            widget.icon!,
            const SizedBox(width: AnimalIslandTokens.spacingSm),
          ],
          Flexible(child: Center(child: widget.child)),
        ],
      ),
    );

    final showDashedBorder =
        widget.type == AnimalButtonType.dashed && !widget.loading;

    final buttonChild = Stack(
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: theme.interactionDuration,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(metrics.radius),
              color: colors.background,
              border: showDashedBorder
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
        if (showDashedBorder)
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
        if (widget.loading)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _loadingController,
              builder: (context, child) => CustomPaint(
                painter: _resolveLoadingPainter(
                  theme,
                  metrics.radius,
                  _loadingController.value,
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: metrics.horizontal,
            vertical: (metrics.height - metrics.fontSize - 8) / 2,
          ),
          child: Center(child: content),
        ),
      ],
    );

    final child = AnimatedContainer(
      duration: theme.interactionDuration,
      transform: Matrix4.translationValues(0, offsetY, 0),
      height: metrics.height,
      width: widget.block ? double.infinity : null,
      child: buttonChild,
    );

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

  _ButtonColors _resolveColors(AnimalIslandThemeData theme) {
    if (widget.loading) {
      return _ButtonColors(
        background: theme.isWestworld
            ? theme.primary.withValues(alpha: 0.08)
            : theme.isNes
            ? theme.primary
            : const Color(0xFF0EC4B6),
        border: theme.isWestworld
            ? theme.primary.withValues(alpha: 0.72)
            : theme.isNes
            ? theme.border
            : const Color(0xFF4DE2DA),
        foreground: theme.isWestworld ? theme.primary : Colors.white,
        shadow: Colors.transparent,
      );
    }

    if (widget.danger) {
      if (widget.type == AnimalButtonType.primary) {
        return _ButtonColors(
          background: theme.error,
          border: theme.error,
          foreground: Colors.white,
          shadow: theme.errorActive,
        );
      }

      if (widget.type == AnimalButtonType.text ||
          widget.type == AnimalButtonType.link) {
        return _ButtonColors(
          background: Colors.transparent,
          border: Colors.transparent,
          foreground: Colors.white,
          shadow: Colors.transparent,
        );
      }

      return _ButtonColors(
        background: widget.ghost ? Colors.transparent : theme.surface,
        border: theme.error,
        foreground: theme.error,
        shadow: theme.buttonShadow,
      );
    }

    switch (widget.type) {
      case AnimalButtonType.primary:
        return _ButtonColors(
          background: widget.ghost
              ? Colors.transparent
              : (theme.isWestworld
                    ? theme.primary
                    : theme.isNes
                    ? theme.primary
                    : theme.surface),
          border: widget.ghost
              ? theme.primary
              : (theme.isWestworld
                    ? theme.primary
                    : theme.isNes
                    ? theme.border
                    : theme.surface),
          foreground: widget.ghost
              ? theme.primary
              : (theme.isWestworld
                    ? theme.pageBackground
                    : theme.isNes
                    ? Colors.white
                    : const Color(0xFF794F27)),
          shadow: widget.ghost ? Colors.transparent : theme.buttonShadow,
        );
      case AnimalButtonType.defaultType:
        return _ButtonColors(
          background: widget.ghost ? Colors.transparent : theme.surface,
          border: theme.border,
          foreground: theme.textPrimary,
          shadow: theme.buttonShadow,
        );
      case AnimalButtonType.dashed:
        return _ButtonColors(
          background: widget.ghost ? Colors.transparent : theme.surface,
          border: theme.border,
          foreground: theme.textPrimary,
          shadow: Colors.transparent,
        );
      case AnimalButtonType.text:
        return _ButtonColors(
          background: Colors.transparent,
          border: Colors.transparent,
          foreground: theme.textPrimary,
          shadow: Colors.transparent,
        );
      case AnimalButtonType.link:
        return _ButtonColors(
          background: Colors.transparent,
          border: Colors.transparent,
          foreground: theme.primary,
          shadow: Colors.transparent,
        );
    }
  }

  CustomPainter _resolveLoadingPainter(
    AnimalIslandThemeData theme,
    double radius,
    double progress,
  ) {
    if (theme.isNes) {
      return _PixelLoadingPainter(
        progress: progress,
        base: theme.primary,
        stripe: theme.focusYellow,
      );
    }

    if (theme.isWestworld) {
      return _ScanlineLoadingPainter(
        progress: progress,
        base: theme.surfaceRaised.withValues(alpha: 0.18),
        line: theme.primary.withValues(alpha: 0.56),
        glow: theme.primary.withValues(alpha: 0.22),
      );
    }

    return _StripePainter(
      progress: progress,
      base: const Color(0xFF0EC4B6),
      stripe: const Color(0xFF01B0A7),
      radius: radius,
    );
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

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.shadow,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final Color shadow;
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
    required this.glow,
  });

  final double progress;
  final Color base;
  final Color line;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    final y = size.height - 5.5;
    final track = Paint()
      ..color = line.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(14, y), Offset(size.width - 14, y), track);

    final activeWidth = (size.width - 28) * progress;
    final active = Paint()
      ..color = line
      ..strokeWidth = 1.4;
    canvas.drawLine(Offset(14, y), Offset(14 + activeWidth, y), active);

    final pulseX = 14 + activeWidth;
    canvas.drawLine(
      Offset(pulseX, y - 4),
      Offset(pulseX, y + 4),
      Paint()
        ..color = glow
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanlineLoadingPainter other) {
    return other.progress != progress ||
        other.base != base ||
        other.line != line ||
        other.glow != glow;
  }
}

class _WestworldButtonLoadingGlyph extends StatelessWidget {
  const _WestworldButtonLoadingGlyph({
    required this.controller,
    required this.color,
  });

  final Animation<double> controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox.square(
          dimension: 19,
          child: CustomPaint(
            painter: _WestworldButtonGlyphPainter(
              progress: controller.value,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class _WestworldButtonGlyphPainter extends CustomPainter {
  const _WestworldButtonGlyphPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final muted = Paint()
      ..color = color.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final active = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, radius * 0.76, muted);
    canvas.drawCircle(center, radius * 0.42, muted);
    final tick = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i += 1) {
      final angle = i * math.pi / 2;
      final a =
          center + Offset(math.cos(angle), math.sin(angle)) * radius * 0.58;
      final b =
          center + Offset(math.cos(angle), math.sin(angle)) * radius * 0.82;
      canvas.drawLine(a, b, tick);
    }
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.76),
      -math.pi / 2 + progress * math.pi * 2,
      math.pi * 0.86,
      false,
      active,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.42),
      math.pi / 2 - progress * math.pi * 2,
      math.pi * 0.72,
      false,
      active..color = color.withValues(alpha: 0.72),
    );

    final angle = progress * math.pi * 2;
    active.color = color;
    canvas.drawLine(
      center,
      center + Offset(math.cos(angle), math.sin(angle)) * radius * 0.86,
      active,
    );
    canvas.drawCircle(center, 1.4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _WestworldButtonGlyphPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
