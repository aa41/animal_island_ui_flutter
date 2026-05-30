import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import 'animal_component_dispatcher.dart';
import 'nes_pixel_frame.dart';

class AnimalBadge extends StatelessWidget {
  const AnimalBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandBadge(
        label: label,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
      ),
      nes: (_) => _NesAnimalBadge(
        label: label,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
      ),
      westworld: (_) => _WestworldAnimalBadge(
        label: label,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
      ),
      guofeng: (_) => _GuofengAnimalBadge(
        label: label,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
      ),
    );
  }
}

class _AnimalIslandBadge extends _ThemedAnimalBadge {
  const _AnimalIslandBadge({
    required super.label,
    required super.backgroundColor,
    required super.foregroundColor,
    required super.padding,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalBadge extends _ThemedAnimalBadge {
  const _NesAnimalBadge({
    required super.label,
    required super.backgroundColor,
    required super.foregroundColor,
    required super.padding,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalBadge extends _ThemedAnimalBadge {
  const _WestworldAnimalBadge({
    required super.label,
    required super.backgroundColor,
    required super.foregroundColor,
    required super.padding,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalBadge extends _ThemedAnimalBadge {
  const _GuofengAnimalBadge({
    required super.label,
    required super.backgroundColor,
    required super.foregroundColor,
    required super.padding,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalBadge extends StatelessWidget {
  const _ThemedAnimalBadge({
    required this.gameStyle,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.padding,
  });

  final AnimalIslandGameStyle gameStyle;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    if (theme.isGuofengDoodle) {
      final background = backgroundColor ?? theme.primary;
      final foreground =
          foregroundColor ??
          (theme.mode == AnimalIslandThemeMode.day
              ? Colors.white
              : theme.textPrimary);
      return CustomPaint(
        painter: _GuofengSealBadgePainter(
          fill: background,
          border: theme.border,
          paper: theme.surface,
        ),
        child: Padding(
          padding: padding.add(
            const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    if (theme.isNes) {
      final background = backgroundColor ?? theme.primary;
      final foreground = foregroundColor ?? Colors.white;
      return NesPixelFrame(
        palette: NesPixelFramePalette(
          background: background,
          border: theme.border,
          shadow: theme.buttonShadow,
          highlight: Colors.white,
          lowlight: theme.primaryActive,
          accent: theme.borderHover,
        ),
        texture: true,
        pixel: 3,
        shadowOffset: const Offset(3, 3),
        padding: padding.add(const EdgeInsets.symmetric(horizontal: 2)),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.08,
          ),
        ),
      );
    }

    final badge = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.surfaceSoft,
        borderRadius: BorderRadius.circular(
          theme.isWestworld ? 0 : theme.radiusPill,
        ),
        border: theme.isNes || theme.isWestworld
            ? Border.all(
                color: theme.isWestworld
                    ? theme.panelLineColor(emphasized: true)
                    : theme.border,
                width: theme.borderWidth,
              )
            : null,
      ),
      child: Padding(
        padding: padding,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foregroundColor ?? theme.textSecondary,
            letterSpacing: theme.isWestworld ? 1.55 : null,
            fontWeight: theme.isWestworld ? FontWeight.w500 : null,
          ),
        ),
      ),
    );

    if (!theme.isWestworld) {
      return badge;
    }

    final accent = foregroundColor ?? theme.textPrimary;
    return CustomPaint(
      painter: _WestworldBadgeFramePainter(
        line: theme.panelLineColor(emphasized: true),
        accent: accent,
      ),
      child: ClipPath(clipper: _WestworldBadgeClipper(), child: badge),
    );
  }
}

class _GuofengSealBadgePainter extends CustomPainter {
  const _GuofengSealBadgePainter({
    required this.fill,
    required this.border,
    required this.paper,
  });

  final Color fill;
  final Color border;
  final Color paper;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final rect = Offset.zero & size;
    final radius = Radius.circular(size.height * 0.18);
    final rrect = RRect.fromRectAndRadius(rect.deflate(1), radius);
    canvas.drawRRect(rrect, Paint()..color = fill);
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..color = border.withValues(alpha: 0.52),
    );
    final grainPaint = Paint()..color = paper.withValues(alpha: 0.24);
    for (var i = 0; i < 6; i += 1) {
      final x = 5.0 + i * (size.width - 10) / 5;
      canvas.drawLine(
        Offset(x, 4),
        Offset(x + 7, size.height - 5),
        grainPaint..strokeWidth = i.isEven ? 1.1 : 0.7,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GuofengSealBadgePainter oldDelegate) {
    return oldDelegate.fill != fill ||
        oldDelegate.border != border ||
        oldDelegate.paper != paper;
  }
}

class _WestworldBadgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cut = 7.0;
    return Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cut)
      ..lineTo(size.width - cut, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, cut)
      ..close();
  }

  @override
  bool shouldReclip(covariant _WestworldBadgeClipper oldClipper) => false;
}

class _WestworldBadgeFramePainter extends CustomPainter {
  const _WestworldBadgeFramePainter({required this.line, required this.accent});

  final Color line;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    const cut = 7.0;
    final path = Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cut)
      ..lineTo(size.width - cut, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, cut)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = line,
    );

    final nodePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = accent.withValues(alpha: 0.5);
    canvas.drawCircle(const Offset(cut, 0), 2.2, nodePaint);
    canvas.drawCircle(Offset(size.width - cut, size.height), 2.2, nodePaint);
    canvas.drawLine(
      Offset(4, size.height * 0.5),
      Offset(size.width * 0.22, size.height * 0.5),
      Paint()
        ..strokeWidth = 1
        ..color = accent.withValues(alpha: 0.18),
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldBadgeFramePainter oldDelegate) {
    return oldDelegate.line != line || oldDelegate.accent != accent;
  }
}
