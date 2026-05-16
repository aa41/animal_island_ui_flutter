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
        horizontal: 16,
        fontSize: AnimalIslandTokens.fontCaption,
        radius: AnimalIslandTokens.radiusSm,
      ),
      AnimalButtonSize.middle => const _ButtonMetrics(
        height: 45,
        horizontal: 20,
        fontSize: AnimalIslandTokens.fontLabel,
        radius: AnimalIslandTokens.radiusPill,
      ),
      AnimalButtonSize.large => _ButtonMetrics(
        height: AnimalIslandTokens.heightLg,
        horizontal: 32,
        fontSize: AnimalIslandTokens.fontBody,
        radius: AnimalIslandTokens.radiusLg,
      ),
    };

    final colors = _resolveColors(theme);
    final shadowDepth = widget.loading
        ? 0.0
        : _pressed
        ? 1.0
        : _hovered
        ? 6.0
        : 5.0;
    final offsetY = widget.loading
        ? 0.0
        : _pressed
        ? 2.0
        : _hovered
        ? -1.0
        : 0.0;

    final content = DefaultTextStyle(
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
        fontSize: metrics.fontSize,
        color: enabled
            ? colors.foreground
            : colors.foreground.withValues(alpha: 0.5),
        letterSpacing: 0.28,
      ),
      child: Row(
        mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            duration: AnimalIslandTokens.fast,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(metrics.radius),
              color: colors.background,
              border: showDashedBorder
                  ? null
                  : Border.all(
                      color: colors.border,
                      width: AnimalIslandTokens.borderWidth,
                    ),
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
                  strokeWidth: AnimalIslandTokens.borderWidth,
                ),
              ),
            ),
          ),
        if (widget.loading)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _loadingController,
              builder: (context, child) => CustomPaint(
                painter: _StripePainter(
                  progress: _loadingController.value,
                  base: const Color(0xFF0EC4B6),
                  stripe: const Color(0xFF01B0A7),
                  radius: metrics.radius,
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
      duration: AnimalIslandTokens.fast,
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
      return const _ButtonColors(
        background: Color(0xFF0EC4B6),
        border: Color(0xFF4DE2DA),
        foreground: Colors.white,
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
          background: widget.ghost ? Colors.transparent : theme.surface,
          border: widget.ghost ? theme.primary : theme.surface,
          foreground: widget.ghost ? theme.primary : const Color(0xFF794F27),
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
    final clip = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
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
