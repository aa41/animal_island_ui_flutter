import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';

class AnimalBadge extends StatefulWidget {
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
  State<AnimalBadge> createState() => _AnimalBadgeState();
}

class _AnimalBadgeState extends State<AnimalBadge>
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
