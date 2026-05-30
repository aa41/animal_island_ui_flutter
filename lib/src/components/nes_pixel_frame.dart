import 'dart:math' as math;

import 'package:flutter/material.dart';

@immutable
class NesPixelFramePalette {
  const NesPixelFramePalette({
    required this.background,
    required this.border,
    required this.shadow,
    this.highlight,
    this.lowlight,
    this.accent,
  });

  final Color background;
  final Color border;
  final Color shadow;
  final Color? highlight;
  final Color? lowlight;
  final Color? accent;
}

class NesPixelFrame extends StatelessWidget {
  const NesPixelFrame({
    super.key,
    required this.palette,
    required this.child,
    this.pressed = false,
    this.hovered = false,
    this.focused = false,
    this.disabled = false,
    this.dashed = false,
    this.texture = false,
    this.padding = EdgeInsets.zero,
    this.pixel = 4,
    this.shadowOffset,
    this.compact = false,
    this.reserveShadowSpace = true,
  });

  final NesPixelFramePalette palette;
  final Widget child;
  final bool pressed;
  final bool hovered;
  final bool focused;
  final bool disabled;
  final bool dashed;
  final bool texture;
  final EdgeInsetsGeometry padding;
  final double pixel;
  final Offset? shadowOffset;
  final bool compact;
  final bool reserveShadowSpace;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NesPixelFramePainter(
        palette: palette,
        pressed: pressed,
        hovered: hovered,
        focused: focused,
        disabled: disabled,
        dashed: dashed,
        texture: texture,
        pixel: pixel,
        shadowOffset: shadowOffset,
        compact: compact,
        reserveShadowSpace: reserveShadowSpace,
      ),
      child: Padding(
        padding: padding.add(EdgeInsets.all(compact ? pixel : pixel * 2)),
        child: child,
      ),
    );
  }
}

class NesPixelFramePainter extends CustomPainter {
  const NesPixelFramePainter({
    required this.palette,
    this.pressed = false,
    this.hovered = false,
    this.focused = false,
    this.disabled = false,
    this.dashed = false,
    this.texture = false,
    this.pixel = 4,
    this.shadowOffset,
    this.compact = false,
    this.reserveShadowSpace = true,
  });

  final NesPixelFramePalette palette;
  final bool pressed;
  final bool hovered;
  final bool focused;
  final bool disabled;
  final bool dashed;
  final bool texture;
  final double pixel;
  final Offset? shadowOffset;
  final bool compact;
  final bool reserveShadowSpace;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    final p = math.max(2.0, pixel.roundToDouble());
    final shadow = pressed ? Offset.zero : (shadowOffset ?? Offset(p, p));
    final inset = compact ? 0.0 : p;
    final body = Rect.fromLTWH(
      inset,
      inset,
      math.max(
        0,
        size.width - inset * 2 - (reserveShadowSpace ? shadow.dx.abs() : 0),
      ),
      math.max(
        0,
        size.height - inset * 2 - (reserveShadowSpace ? shadow.dy.abs() : 0),
      ),
    );
    if (body.width <= 0 || body.height <= 0) {
      return;
    }

    final fill = disabled
        ? Color.lerp(palette.background, const Color(0xFF808080), 0.25)!
        : palette.background;
    final border = disabled
        ? palette.border.withValues(alpha: 0.52)
        : focused
        ? (palette.accent ?? palette.border)
        : palette.border;
    final shadowColor = disabled
        ? Colors.transparent
        : palette.shadow.withValues(alpha: hovered ? 1 : 0.92);
    final high = (palette.highlight ?? Colors.white).withValues(
      alpha: disabled
          ? 0.12
          : hovered
          ? 0.54
          : 0.36,
    );
    final low = (palette.lowlight ?? palette.shadow).withValues(
      alpha: disabled
          ? 0.18
          : pressed
          ? 0.68
          : hovered
          ? 0.58
          : 0.48,
    );

    if (shadow != Offset.zero) {
      _drawPixelBody(canvas, body.shift(shadow), p, shadowColor);
    }

    _drawPixelBody(canvas, body, p, fill);
    _drawPixelOutline(canvas, body, p, border, dashed: dashed);

    if (texture) {
      _drawTexture(canvas, body.deflate(p), p, border, fill);
    }

    if (!dashed) {
      final inner = body.deflate(p);
      _drawInnerEdge(canvas, inner, p, pressed ? low : high, topLeft: true);
      _drawInnerEdge(canvas, inner, p, pressed ? high : low, topLeft: false);
    }

    if (focused) {
      _drawPixelOutline(
        canvas,
        body.inflate(p),
        p,
        (palette.accent ?? palette.border).withValues(alpha: 0.42),
        dashed: true,
      );
    }
  }

  void _drawPixelBody(Canvas canvas, Rect rect, double p, Color color) {
    final paint = Paint()..color = color;
    canvas.drawRect(
      Rect.fromLTRB(rect.left + p, rect.top, rect.right - p, rect.bottom),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTRB(rect.left, rect.top + p, rect.right, rect.bottom - p),
      paint,
    );
  }

  void _drawPixelOutline(
    Canvas canvas,
    Rect rect,
    double p,
    Color color, {
    required bool dashed,
  }) {
    final paint = Paint()..color = color;
    void draw(Rect r) => canvas.drawRect(r, paint);

    if (!dashed) {
      draw(Rect.fromLTWH(rect.left + p, rect.top, rect.width - p * 2, p));
      draw(
        Rect.fromLTWH(rect.left + p, rect.bottom - p, rect.width - p * 2, p),
      );
      draw(Rect.fromLTWH(rect.left, rect.top + p, p, rect.height - p * 2));
      draw(Rect.fromLTWH(rect.right - p, rect.top + p, p, rect.height - p * 2));
      draw(Rect.fromLTWH(rect.left + p, rect.top + p, p, p));
      draw(Rect.fromLTWH(rect.right - p * 2, rect.top + p, p, p));
      draw(Rect.fromLTWH(rect.left + p, rect.bottom - p * 2, p, p));
      draw(Rect.fromLTWH(rect.right - p * 2, rect.bottom - p * 2, p, p));
      return;
    }

    final step = p * 2;
    for (var x = rect.left + p; x < rect.right - p; x += step) {
      draw(Rect.fromLTWH(x, rect.top, math.min(p, rect.right - p - x), p));
      draw(
        Rect.fromLTWH(x, rect.bottom - p, math.min(p, rect.right - p - x), p),
      );
    }
    for (var y = rect.top + p; y < rect.bottom - p; y += step) {
      draw(Rect.fromLTWH(rect.left, y, p, math.min(p, rect.bottom - p - y)));
      draw(
        Rect.fromLTWH(rect.right - p, y, p, math.min(p, rect.bottom - p - y)),
      );
    }
  }

  void _drawInnerEdge(
    Canvas canvas,
    Rect rect,
    double p,
    Color color, {
    required bool topLeft,
  }) {
    if (rect.width <= 0 || rect.height <= 0) {
      return;
    }
    final paint = Paint()..color = color;
    if (topLeft) {
      canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, rect.width, p), paint);
      canvas.drawRect(
        Rect.fromLTWH(rect.left, rect.top, p, rect.height),
        paint,
      );
      return;
    }
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.bottom - p, rect.width, p),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(rect.right - p, rect.top, p, rect.height),
      paint,
    );
  }

  void _drawTexture(
    Canvas canvas,
    Rect rect,
    double p,
    Color border,
    Color fill,
  ) {
    final paint = Paint()
      ..color = Color.lerp(border, fill, 0.68)!.withValues(alpha: 0.22);
    final dot = math.max(1.0, p / 2);
    final step = p * 3;
    for (var y = rect.top + p; y < rect.bottom - dot; y += step) {
      for (var x = rect.left + p; x < rect.right - dot; x += step) {
        if (((x / step).floor() + (y / step).floor()).isEven) {
          canvas.drawRect(Rect.fromLTWH(x, y, dot, dot), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant NesPixelFramePainter oldDelegate) {
    return oldDelegate.palette != palette ||
        oldDelegate.pressed != pressed ||
        oldDelegate.hovered != hovered ||
        oldDelegate.focused != focused ||
        oldDelegate.disabled != disabled ||
        oldDelegate.dashed != dashed ||
        oldDelegate.texture != texture ||
        oldDelegate.pixel != pixel ||
        oldDelegate.shadowOffset != shadowOffset ||
        oldDelegate.compact != compact ||
        oldDelegate.reserveShadowSpace != reserveShadowSpace;
  }
}
