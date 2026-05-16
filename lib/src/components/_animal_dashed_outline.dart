import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class AnimalDashedOutlinePainter extends CustomPainter {
  const AnimalDashedOutlinePainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 2,
    this.dashLength = 7,
    this.gapLength = 5,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius - inset)),
      );

    final dashedPath = dashPath(
      path,
      dashArray: CircularIntervalList<double>(<double>[dashLength, gapLength]),
    );

    canvas.drawPath(
      dashedPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant AnimalDashedOutlinePainter other) {
    return other.color != color ||
        other.radius != radius ||
        other.strokeWidth != strokeWidth ||
        other.dashLength != dashLength ||
        other.gapLength != gapLength;
  }
}
