import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import 'animal_component_dispatcher.dart';

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

abstract class _ThemedAnimalBadge extends StatefulWidget {
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
  State<_ThemedAnimalBadge> createState() => _ThemedAnimalBadgeState();
}

class _ThemedAnimalBadgeState extends State<_ThemedAnimalBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = context.animalIslandTheme;
    if (theme.isWestworld && !_controller.isAnimating) {
      _controller.repeat();
    }
    if (!theme.isWestworld && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    if (theme.isGuofengDoodle) {
      final background = widget.backgroundColor ?? theme.primary;
      final foreground =
          widget.foregroundColor ??
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
          padding: widget.padding.add(
            const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    final badge = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.surfaceSoft,
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
        padding: widget.padding,
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: widget.foregroundColor ?? theme.textSecondary,
            letterSpacing: theme.isWestworld ? 1.55 : null,
            fontWeight: theme.isWestworld ? FontWeight.w500 : null,
          ),
        ),
      ),
    );

    if (!theme.isWestworld) {
      return badge;
    }

    final accent = widget.foregroundColor ?? theme.textPrimary;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        painter: _WestworldBadgeFramePainter(
          progress: _controller.value,
          line: theme.panelLineColor(emphasized: true),
          accent: accent,
        ),
        foregroundPainter: _WestworldBadgeSweepPainter(
          progress: _controller.value,
          line: accent.withValues(alpha: 0.38),
        ),
        child: ClipPath(clipper: _WestworldBadgeClipper(), child: child),
      ),
      child: badge,
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
  const _WestworldBadgeFramePainter({
    required this.progress,
    required this.line,
    required this.accent,
  });

  final double progress;
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
    final nodeX = 7 + (size.width - 14) * progress;
    canvas.drawCircle(Offset(nodeX, size.height), 2.2, nodePaint);
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
    return oldDelegate.progress != progress ||
        oldDelegate.line != line ||
        oldDelegate.accent != accent;
  }
}

class _WestworldBadgeSweepPainter extends CustomPainter {
  const _WestworldBadgeSweepPainter({
    required this.progress,
    required this.line,
  });

  final double progress;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final x = progress * (size.width + 18) - 9;
    canvas.drawLine(
      Offset(x, 3),
      Offset(x, size.height - 3),
      Paint()
        ..color = line
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldBadgeSweepPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.line != line;
  }
}
