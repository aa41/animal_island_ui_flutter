import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';

class GuofengInkOutlinePainter extends CustomPainter {
  const GuofengInkOutlinePainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 2.4,
    this.alpha = 0.92,
    this.seed = 0,
    this.dashed = false,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double alpha;
  final int seed;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    final rect = Offset.zero & size;
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = _wobblyRRectPath(rect.deflate(strokeWidth / 2), radius);
    if (dashed) {
      _drawDashedPath(canvas, path, paint);
    } else {
      canvas.drawPath(path, paint);
    }

    final echoPaint = Paint()
      ..color = color.withValues(alpha: alpha * 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, strokeWidth * 0.46)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      _wobblyRRectPath(rect.deflate(strokeWidth + 1.6), radius),
      echoPaint,
    );
  }

  Path _wobblyRRectPath(Rect rect, double radius) {
    final safeRadius = radius.clamp(0.0, math.min(rect.width, rect.height) / 2);
    final points = <Offset>[];
    const segmentsPerSide = 10;
    final left = rect.left;
    final right = rect.right;
    final top = rect.top;
    final bottom = rect.bottom;
    final r = safeRadius;

    void addLine(Offset from, Offset to, int side) {
      for (var i = 0; i <= segmentsPerSide; i++) {
        final t = i / segmentsPerSide;
        final p = Offset.lerp(from, to, t)!;
        final jitter = math.sin((i + 1) * 1.71 + seed * 0.37 + side) * 0.72;
        final normal = side.isEven ? const Offset(0, 1) : const Offset(1, 0);
        points.add(p + normal * jitter);
      }
    }

    void addArc(Offset center, double start, double end, int side) {
      for (var i = 1; i <= 6; i++) {
        final t = i / 6;
        final angle = start + (end - start) * t;
        final jitter = math.sin((i + 3) * 1.33 + seed * 0.51 + side) * 0.54;
        points.add(
          center + Offset(math.cos(angle), math.sin(angle)) * (r + jitter),
        );
      }
    }

    points.add(Offset(left + r, top));
    addLine(Offset(left + r, top), Offset(right - r, top), 0);
    addArc(Offset(right - r, top + r), -math.pi / 2, 0, 1);
    addLine(Offset(right, top + r), Offset(right, bottom - r), 1);
    addArc(Offset(right - r, bottom - r), 0, math.pi / 2, 2);
    addLine(Offset(right - r, bottom), Offset(left + r, bottom), 2);
    addArc(Offset(left + r, bottom - r), math.pi / 2, math.pi, 3);
    addLine(Offset(left, bottom - r), Offset(left, top + r), 3);
    addArc(Offset(left + r, top + r), math.pi, math.pi * 1.5, 4);

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + 9, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 15;
      }
    }
  }

  @override
  bool shouldRepaint(covariant GuofengInkOutlinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.alpha != alpha ||
        oldDelegate.seed != seed ||
        oldDelegate.dashed != dashed;
  }
}

class GuofengBrushFocusPainter extends CustomPainter {
  const GuofengBrushFocusPainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 1.8,
    this.seed = 0,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final rect = (Offset.zero & size).deflate(strokeWidth * 0.5);
    final main = Paint()
      ..color = color.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final inner = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, strokeWidth * 0.58)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(_edgePath(rect, radius, seed, 0.42), main);
    canvas.drawPath(
      _edgePath(rect.deflate(3.2), radius - 3.2, seed + 5, 0.22),
      inner,
    );
  }

  Path _edgePath(Rect rect, double radius, int seed, double wobble) {
    final safeRadius = radius.clamp(0.0, math.min(rect.width, rect.height) / 2);
    final path = Path();
    final left = rect.left;
    final right = rect.right;
    final top = rect.top;
    final bottom = rect.bottom;
    final r = safeRadius;

    Offset jitter(Offset point, int i, Offset normal) {
      final amount = math.sin((i + 1) * 1.93 + seed * 0.41) * wobble;
      return point + normal * amount;
    }

    void lineToWobbly(Offset from, Offset to, int side) {
      for (var i = 1; i <= 8; i += 1) {
        final t = i / 8;
        final normal = side.isEven ? const Offset(0, 1) : const Offset(1, 0);
        final p = Offset.lerp(from, to, t)!;
        final next = jitter(p, i + side * 11, normal);
        path.lineTo(next.dx, next.dy);
      }
    }

    path.moveTo(left + r, top);
    lineToWobbly(Offset(left + r, top), Offset(right - r, top), 0);
    path.quadraticBezierTo(right, top, right, top + r);
    lineToWobbly(Offset(right, top + r), Offset(right, bottom - r), 1);
    path.quadraticBezierTo(right, bottom, right - r, bottom);
    lineToWobbly(Offset(right - r, bottom), Offset(left + r, bottom), 2);
    path.quadraticBezierTo(left, bottom, left, bottom - r);
    lineToWobbly(Offset(left, bottom - r), Offset(left, top + r), 3);
    path.quadraticBezierTo(left, top, left + r, top);
    return path..close();
  }

  @override
  bool shouldRepaint(covariant GuofengBrushFocusPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.seed != seed;
  }
}

class GuofengPaperTexturePainter extends CustomPainter {
  const GuofengPaperTexturePainter({required this.theme, this.seed = 0});

  final AnimalIslandThemeData theme;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final ink = theme.mode == AnimalIslandThemeMode.day
        ? theme.border
        : theme.textPrimary;
    final paint = Paint()
      ..color = ink.withValues(
        alpha: theme.mode == AnimalIslandThemeMode.day ? 0.045 : 0.055,
      )
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 24; i++) {
      final x = ((i * 37 + seed * 19) % math.max(1, size.width.toInt()))
          .toDouble();
      final y = ((i * 23 + seed * 29) % math.max(1, size.height.toInt()))
          .toDouble();
      final len = 2.0 + (i % 5);
      canvas.drawLine(
        Offset(x, y),
        Offset(x + len, y + (i.isEven ? 0.8 : -0.7)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GuofengPaperTexturePainter oldDelegate) {
    return oldDelegate.theme != theme || oldDelegate.seed != seed;
  }
}
