import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../utils/animal_island_assets.dart';
import 'animal_component_dispatcher.dart';

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
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandDivider(type: type, height: height),
      nes: (_) => _NesAnimalDivider(type: type, height: height),
      westworld: (_) => _WestworldAnimalDivider(type: type, height: height),
      guofeng: (_) => _GuofengAnimalDivider(type: type, height: height),
    );
  }
}

class _AnimalIslandDivider extends _ThemedAnimalDivider {
  const _AnimalIslandDivider({required super.type, required super.height})
    : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalDivider extends _ThemedAnimalDivider {
  const _NesAnimalDivider({required super.type, required super.height})
    : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalDivider extends _ThemedAnimalDivider {
  const _WestworldAnimalDivider({required super.type, required super.height})
    : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalDivider extends _ThemedAnimalDivider {
  const _GuofengAnimalDivider({required super.type, required super.height})
    : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalDivider extends StatelessWidget {
  const _ThemedAnimalDivider({
    required this.gameStyle,
    required this.type,
    required this.height,
  });

  final AnimalIslandGameStyle gameStyle;
  final AnimalDividerType type;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    if (theme.isWestworld) {
      return CustomPaint(
        size: Size.fromHeight(height),
        painter: _WestworldDividerPainter(color: theme.panelLineColor()),
      );
    }

    if (theme.isNes) {
      return CustomPaint(
        size: Size.fromHeight(height),
        painter: _PixelDividerPainter(color: theme.border),
      );
    }

    if (theme.isGuofengDoodle) {
      final color = switch (type) {
        AnimalDividerType.lineTeal => theme.primary,
        AnimalDividerType.lineWhite => theme.surface,
        AnimalDividerType.lineYellow => theme.focusYellow,
        AnimalDividerType.waveYellow => theme.warning,
        AnimalDividerType.lineBrown => theme.border,
      };
      return CustomPaint(
        size: Size.fromHeight(height),
        painter: _GuofengDividerPainter(
          color: color,
          wave: type == AnimalDividerType.waveYellow,
        ),
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

class _GuofengDividerPainter extends CustomPainter {
  const _GuofengDividerPainter({required this.color, required this.wave});

  final Color color;
  final bool wave;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final y = size.height / 2;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (wave) {
      final path = Path()..moveTo(0, y);
      for (var x = 0.0; x <= size.width; x += 18) {
        path.quadraticBezierTo(x + 9, y - 5, x + 18, y);
        path.quadraticBezierTo(x + 27, y + 5, x + 36, y);
      }
      canvas.drawPath(path, paint);
      return;
    }

    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    canvas.drawLine(
      Offset(0, y + 3),
      Offset(size.width, y + 3),
      Paint()
        ..color = color.withValues(alpha: 0.24)
        ..strokeWidth = 1
        ..strokeCap = StrokeCap.round,
    );
    final sealPaint = Paint()..color = color.withValues(alpha: 0.86);
    final center = size.width / 2;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(center, y), width: 8, height: 8),
      sealPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GuofengDividerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.wave != wave;
  }
}

class _WestworldDividerPainter extends CustomPainter {
  const _WestworldDividerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final y = (size.height / 2).floorToDouble();
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    canvas.drawLine(Offset.zero.translate(0, y), Offset(size.width, y), paint);
    canvas.drawLine(Offset(0, y - 4), Offset(28, y - 4), paint);
    canvas.drawLine(
      Offset(size.width - 28, y + 4),
      Offset(size.width, y + 4),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldDividerPainter oldDelegate) {
    return oldDelegate.color != color;
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
