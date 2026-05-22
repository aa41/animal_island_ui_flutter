import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../utils/animal_island_assets.dart';

class AnimalDivider extends StatelessWidget {
  const AnimalDivider({
    super.key,
    this.type = AnimalDividerType.lineBrown,
    this.height = 12,
  });

  final AnimalDividerType type;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    if (theme.isNes) {
      return CustomPaint(
        size: Size.fromHeight(height),
        painter: _PixelDividerPainter(color: theme.border),
      );
    }

    final path = switch (type) {
      AnimalDividerType.lineBrown => AnimalIslandAssets.dividerBrown,
      AnimalDividerType.lineTeal => AnimalIslandAssets.dividerTeal,
      AnimalDividerType.lineWhite => AnimalIslandAssets.dividerWhite,
      AnimalDividerType.lineYellow => AnimalIslandAssets.dividerYellow,
      AnimalDividerType.waveYellow => AnimalIslandAssets.dividerWave,
    };

    if (path.endsWith('.png')) {
      return Image.asset(
        path,
        package: AnimalIslandAssets.package,
        height: height,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    }

    return SvgPicture.asset(
      path,
      package: AnimalIslandAssets.package,
      height: height,
      width: double.infinity,
      fit: BoxFit.contain,
    );
  }
}

class _PixelDividerPainter extends CustomPainter {
  const _PixelDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final y = (size.height / 2).floorToDouble();
    for (var x = 0.0; x < size.width; x += 12) {
      canvas.drawRect(Rect.fromLTWH(x, y, 8, 3), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelDividerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
