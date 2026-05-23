import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../utils/animal_island_assets.dart';

class AnimalFooter extends StatelessWidget {
  const AnimalFooter({
    super.key,
    this.type = AnimalFooterType.tree,
    this.height,
  });

  final AnimalFooterType type;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    if (theme.isWestworld) {
      return SizedBox(
        width: double.infinity,
        height: height ?? 84,
        child: CustomPaint(
          painter: _WestworldFooterPainter(
            line: theme.panelLineColor(),
            strong: theme.textPrimary.withValues(alpha: 0.42),
            muted: theme.textMuted.withValues(alpha: 0.18),
          ),
        ),
      );
    }

    if (theme.isNes) {
      return SizedBox(
        width: double.infinity,
        height: height ?? 72,
        child: CustomPaint(
          painter: _PixelFooterPainter(
            sky: theme.pageBackground,
            ground: theme.success,
            accent: theme.warning,
            border: theme.border,
            water: theme.primary,
            shadow: theme.buttonShadow,
          ),
        ),
      );
    }

    if (type == AnimalFooterType.sea) {
      return SvgPicture.asset(
        AnimalIslandAssets.footerSea,
        package: AnimalIslandAssets.package,
        fit: BoxFit.contain,
        width: double.infinity,
        height: height ?? 80,
      );
    }

    return Image.asset(
      AnimalIslandAssets.footerTree,
      package: AnimalIslandAssets.package,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height ?? 60,
      alignment: Alignment.bottomCenter,
    );
  }
}

class _PixelFooterPainter extends CustomPainter {
  const _PixelFooterPainter({
    required this.sky,
    required this.ground,
    required this.accent,
    required this.border,
    required this.water,
    required this.shadow,
  });

  final Color sky;
  final Color ground;
  final Color accent;
  final Color border;
  final Color water;
  final Color shadow;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final skyPaint = Paint()..color = sky;
    final groundPaint = Paint()..color = ground;
    final accentPaint = Paint()..color = accent;
    final borderPaint = Paint()..color = border;
    final waterPaint = Paint()..color = water.withValues(alpha: 0.72);
    final shadowPaint = Paint()..color = shadow.withValues(alpha: 0.28);
    canvas.drawRect(Offset.zero & size, skyPaint);

    final unit = math.max(4.0, (size.width / 40).floorToDouble());
    final horizon = (size.height * 0.36 / unit).floor() * unit;
    final shore = (size.height * 0.58 / unit).floor() * unit;

    canvas.drawRect(
      Rect.fromLTWH(0, horizon, size.width, shore - horizon),
      waterPaint,
    );
    for (double x = 0; x < size.width; x += unit * 4) {
      canvas.drawRect(
        Rect.fromLTWH(x + unit, horizon + unit, unit * 2, unit),
        Paint()..color = sky.withValues(alpha: 0.42),
      );
      canvas.drawRect(
        Rect.fromLTWH(x, shore - unit, unit * 3, unit),
        Paint()..color = accent.withValues(alpha: 0.74),
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(0, shore, size.width, size.height - shore),
      groundPaint,
    );
    for (double x = 0; x < size.width; x += unit * 2) {
      canvas.drawRect(Rect.fromLTWH(x, shore - unit, unit, unit), groundPaint);
      canvas.drawRect(Rect.fromLTWH(x + unit, shore, unit, unit), shadowPaint);
    }

    for (double x = unit * 2; x < size.width; x += unit * 7) {
      _drawPixelTree(
        canvas,
        Offset(x, shore - unit * 5),
        unit,
        borderPaint,
        groundPaint,
        accentPaint,
      );
    }

    canvas.drawRect(Rect.fromLTWH(0, shore - 2, size.width, 2), borderPaint);
  }

  void _drawPixelTree(
    Canvas canvas,
    Offset origin,
    double unit,
    Paint trunk,
    Paint leaf,
    Paint fruit,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + unit, origin.dy + unit * 3, unit, unit * 2),
      trunk,
    );
    canvas.drawRect(
      Rect.fromLTWH(origin.dx, origin.dy + unit, unit * 3, unit * 2),
      leaf,
    );
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + unit, origin.dy, unit, unit),
      leaf,
    );
    canvas.drawRect(
      Rect.fromLTWH(origin.dx + unit * 2, origin.dy + unit * 2, unit, unit),
      fruit,
    );
  }

  @override
  bool shouldRepaint(covariant _PixelFooterPainter oldDelegate) {
    return oldDelegate.sky != sky ||
        oldDelegate.ground != ground ||
        oldDelegate.accent != accent ||
        oldDelegate.border != border ||
        oldDelegate.water != water ||
        oldDelegate.shadow != shadow;
  }
}

class _WestworldFooterPainter extends CustomPainter {
  const _WestworldFooterPainter({
    required this.line,
    required this.strong,
    required this.muted,
  });

  final Color line;
  final Color strong;
  final Color muted;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    final linePaint = Paint()
      ..color = line
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final mutedPaint = Paint()
      ..color = muted
      ..strokeWidth = 1;
    final strongPaint = Paint()
      ..color = strong
      ..strokeWidth = 1;

    final y = size.height * 0.62;
    canvas.drawLine(
      Offset.zero.translate(0, y),
      Offset(size.width, y),
      linePaint,
    );
    for (double x = 0; x < size.width; x += 56) {
      canvas.drawLine(Offset(x, y - 10), Offset(x + 28, y - 10), mutedPaint);
      canvas.drawLine(
        Offset(x + 28, y + 10),
        Offset(x + 56, y + 10),
        mutedPaint,
      );
    }

    final center = Offset(size.width * 0.5, y);
    for (var i = 0; i < 4; i += 1) {
      canvas.drawCircle(center, 24.0 + i * 18, linePaint);
    }
    canvas.drawLine(
      Offset(center.dx - 120, y),
      Offset(center.dx - 48, y),
      strongPaint,
    );
    canvas.drawLine(
      Offset(center.dx + 48, y),
      Offset(center.dx + 120, y),
      strongPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldFooterPainter oldDelegate) {
    return oldDelegate.line != line ||
        oldDelegate.strong != strong ||
        oldDelegate.muted != muted;
  }
}
