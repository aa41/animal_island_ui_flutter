import 'package:flutter/material.dart';

import '../../theme/animal_island_theme.dart';
import '../../theme/animal_island_tokens.dart';
import '../../utils/animal_island_assets.dart';

class AnimalBottomSheetCloseButton extends StatelessWidget {
  const AnimalBottomSheetCloseButton({
    super.key,
    required this.theme,
    required this.onTap,
    required this.borderRadius,
    required this.showLeaf,
  });

  final AnimalIslandThemeData theme;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final bool showLeaf;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 28,
        decoration: BoxDecoration(
          color: theme.surfaceSoft,
          borderRadius: borderRadius,
          border: Border.all(
            color: theme.borderLight,
            width: theme.borderWidth,
          ),
          boxShadow: theme.isWestworld
              ? null
              : [
                  BoxShadow(
                    color: theme.inputShadow.withValues(alpha: 0.6),
                    blurRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showLeaf && theme.spec.isOrganic)
              Positioned(
                left: 7,
                top: 7,
                child: Image.asset(
                  AnimalIslandAssets.iconLeaf,
                  package: AnimalIslandAssets.package,
                  width: 10,
                  height: 10,
                  opacity: const AlwaysStoppedAnimation<double>(0.62),
                ),
              ),
            Text(
              '×',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: theme.textPrimary,
                fontSize: AnimalIslandTokens.fontBodySm,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalBottomSheetHandle extends StatelessWidget {
  const AnimalBottomSheetHandle({super.key, required this.theme});

  final AnimalIslandThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 8,
          decoration: BoxDecoration(
            color: theme.surfaceSoft,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(10),
            ),
            border: Border.all(
              color: theme.border.withValues(alpha: 0.36),
              width: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Image.asset(
          AnimalIslandAssets.iconLeaf,
          package: AnimalIslandAssets.package,
          width: 16,
          height: 16,
          opacity: const AlwaysStoppedAnimation<double>(0.84),
        ),
      ],
    );
  }
}

class WestworldBottomSheetPainter extends CustomPainter {
  const WestworldBottomSheetPainter({required this.line, required this.glow});

  final Color line;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    final gridPaint = Paint()
      ..color = glow
      ..strokeWidth = 1;
    for (double x = 24; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final linePaint = Paint()
      ..color = line
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(0, 18), const Offset(72, 18), linePaint);
    canvas.drawLine(
      Offset(size.width - 72, size.height - 18),
      Offset(size.width, size.height - 18),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant WestworldBottomSheetPainter oldDelegate) {
    return oldDelegate.line != line || oldDelegate.glow != glow;
  }
}

class WestworldHandlePainter extends CustomPainter {
  const WestworldHandlePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    canvas.drawLine(Offset(18, y - 4), Offset(size.width - 18, y - 4), paint);
    canvas.drawLine(Offset(18, y + 4), Offset(size.width - 18, y + 4), paint);
  }

  @override
  bool shouldRepaint(covariant WestworldHandlePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class AnimalBottomSheetClipper extends CustomClipper<Path> {
  const AnimalBottomSheetClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.03, size.height * 0.18);
    path.cubicTo(
      size.width * 0.045,
      size.height * 0.055,
      size.width * 0.12,
      size.height * 0.02,
      size.width * 0.23,
      size.height * 0.055,
    );
    path.cubicTo(
      size.width * 0.31,
      size.height * 0.082,
      size.width * 0.39,
      size.height * 0.015,
      size.width * 0.49,
      size.height * 0.025,
    );
    path.cubicTo(
      size.width * 0.6,
      size.height * 0.035,
      size.width * 0.66,
      0,
      size.width * 0.77,
      size.height * 0.042,
    );
    path.cubicTo(
      size.width * 0.88,
      size.height * 0.083,
      size.width * 0.96,
      size.height * 0.045,
      size.width * 0.982,
      size.height * 0.16,
    );
    path.cubicTo(
      size.width * 1.006,
      size.height * 0.28,
      size.width * 0.992,
      size.height * 0.39,
      size.width * 0.985,
      size.height * 0.55,
    );
    path.cubicTo(
      size.width * 0.978,
      size.height * 0.67,
      size.width * 0.995,
      size.height * 0.78,
      size.width * 0.974,
      size.height * 0.89,
    );
    path.cubicTo(
      size.width * 0.958,
      size.height * 0.956,
      size.width * 0.915,
      size.height * 0.985,
      size.width * 0.842,
      size.height * 0.992,
    );
    path.cubicTo(
      size.width * 0.75,
      size.height * 1.0,
      size.width * 0.645,
      size.height * 0.988,
      size.width * 0.505,
      size.height * 0.988,
    );
    path.cubicTo(
      size.width * 0.36,
      size.height * 0.988,
      size.width * 0.255,
      size.height * 1.0,
      size.width * 0.162,
      size.height * 0.992,
    );
    path.cubicTo(
      size.width * 0.09,
      size.height * 0.985,
      size.width * 0.045,
      size.height * 0.956,
      size.width * 0.029,
      size.height * 0.89,
    );
    path.cubicTo(
      size.width * 0.008,
      size.height * 0.79,
      size.width * 0.028,
      size.height * 0.68,
      size.width * 0.018,
      size.height * 0.555,
    );
    path.cubicTo(
      size.width * 0.007,
      size.height * 0.405,
      size.width * -0.006,
      size.height * 0.29,
      size.width * 0.03,
      size.height * 0.18,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
