import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    if (theme.isNes) {
      return SizedBox(
        width: double.infinity,
        height: height ?? 60,
        child: CustomPaint(
          painter: _PixelFooterPainter(
            sky: theme.pageBackgroundAlt,
            ground: theme.successActive,
            accent: theme.warning,
            border: theme.border,
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
  });

  final Color sky;
  final Color ground;
  final Color accent;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()..color = sky;
    final groundPaint = Paint()..color = ground;
    final accentPaint = Paint()..color = accent;
    final borderPaint = Paint()..color = border;
    canvas.drawRect(Offset.zero & size, skyPaint);
    final unit = size.width / 32;
    final groundTop = size.height * 0.52;
    canvas.drawRect(
      Rect.fromLTWH(0, groundTop, size.width, size.height),
      groundPaint,
    );
    for (var i = 0; i < 32; i += 2) {
      final x = i * unit;
      canvas.drawRect(
        Rect.fromLTWH(x, groundTop - unit, unit, unit),
        groundPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(x + unit, groundTop, unit, unit),
        accentPaint,
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(0, groundTop - 3, size.width, 3),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PixelFooterPainter oldDelegate) {
    return oldDelegate.sky != sky ||
        oldDelegate.ground != ground ||
        oldDelegate.accent != accent ||
        oldDelegate.border != border;
  }
}
