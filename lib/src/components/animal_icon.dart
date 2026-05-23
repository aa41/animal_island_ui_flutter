import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';

class AnimalIcon extends StatefulWidget {
  const AnimalIcon({
    super.key,
    required this.name,
    this.size = 24,
    this.bounce = false,
    this.color,
  });

  final AnimalIconName name;
  final double size;
  final bool bounce;
  final Color? color;

  @override
  State<AnimalIcon> createState() => _AnimalIconState();
}

class _AnimalIconState extends State<AnimalIcon> {
  bool _hovered = false;

  String get _asset {
    switch (widget.name) {
      case AnimalIconName.miles:
        return AnimalIslandAssets.iconMap['icon-miles']!;
      case AnimalIconName.camera:
        return AnimalIslandAssets.iconMap['icon-camera']!;
      case AnimalIconName.chat:
        return AnimalIslandAssets.iconMap['icon-chat']!;
      case AnimalIconName.critterpedia:
        return AnimalIslandAssets.iconMap['icon-critterpedia']!;
      case AnimalIconName.design:
        return AnimalIslandAssets.iconMap['icon-design']!;
      case AnimalIconName.diy:
        return AnimalIslandAssets.iconMap['icon-diy']!;
      case AnimalIconName.helicopter:
        return AnimalIslandAssets.iconMap['icon-helicopter']!;
      case AnimalIconName.map:
        return AnimalIslandAssets.iconMap['icon-map']!;
      case AnimalIconName.shopping:
        return AnimalIslandAssets.iconMap['icon-shopping']!;
      case AnimalIconName.variant:
        return AnimalIslandAssets.iconMap['icon-variant']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    if (theme.isNes) {
      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Transform.translate(
          offset: Offset(0, widget.bounce && _hovered ? -2 : 0),
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: _PixelIconPainter(
              name: widget.name,
              color: widget.color ?? theme.primary,
              border: theme.border,
              highlight: theme.focusYellow,
            ),
          ),
        ),
      );
    }

    if (theme.isWestworld) {
      return MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: widget.bounce && _hovered ? 1.06 : 1,
          duration: theme.interactionDuration,
          curve: theme.interactionCurve,
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: _WestworldIconPainter(
              name: widget.name,
              color: widget.color ?? theme.textPrimary,
              muted: theme.panelLineColor(hovered: _hovered),
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Transform.translate(
        offset: Offset(0, widget.bounce && _hovered ? -2 : 0),
        child: AnimatedRotation(
          turns: widget.bounce && _hovered ? (-5 / 360) : 0,
          duration: AnimalIslandTokens.base,
          curve: AnimalIslandTokens.motionCurve,
          child: AnimatedScale(
            scale: widget.bounce && _hovered ? 1.1 : 1,
            duration: AnimalIslandTokens.base,
            curve: AnimalIslandTokens.motionCurve,
            child: SvgPicture.asset(
              _asset,
              package: AnimalIslandAssets.package,
              width: widget.size,
              height: widget.size,
              colorFilter: widget.color == null
                  ? null
                  : ColorFilter.mode(widget.color!, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

class _WestworldIconPainter extends CustomPainter {
  const _WestworldIconPainter({
    required this.name,
    required this.color,
    required this.muted,
  });

  final AnimalIconName name;
  final Color color;
  final Color muted;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, size.width / 28)
      ..strokeCap = StrokeCap.square;
    final mutedStroke = Paint()
      ..color = muted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final fill = Paint()..color = color.withValues(alpha: 0.08);
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2;

    canvas.drawCircle(center, r * 0.46, mutedStroke);
    canvas.drawLine(
      Offset(r * 0.22, center.dy),
      Offset(r * 0.48, center.dy),
      mutedStroke,
    );
    canvas.drawLine(
      Offset(size.width - r * 0.48, center.dy),
      Offset(size.width - r * 0.22, center.dy),
      mutedStroke,
    );

    switch (name) {
      case AnimalIconName.camera:
        canvas.drawRect(
          Rect.fromCenter(center: center, width: r * 1.0, height: r * 0.72),
          stroke,
        );
        canvas.drawCircle(center, r * 0.22, stroke);
      case AnimalIconName.chat:
        final rect = Rect.fromCenter(
          center: center,
          width: r * 1.1,
          height: r * 0.72,
        );
        canvas.drawRect(rect, stroke);
        canvas.drawLine(
          rect.bottomLeft,
          rect.bottomLeft + Offset(r * 0.22, r * 0.2),
          stroke,
        );
      case AnimalIconName.map:
        canvas.drawLine(
          Offset(r * 0.62, r * 0.5),
          Offset(r * 0.62, r * 1.5),
          stroke,
        );
        canvas.drawLine(Offset(r, r * 0.38), Offset(r, r * 1.62), stroke);
        canvas.drawLine(
          Offset(r * 1.38, r * 0.5),
          Offset(r * 1.38, r * 1.5),
          stroke,
        );
        canvas.drawRect(
          Rect.fromLTWH(r * 0.42, r * 0.48, r * 1.16, r * 1.04),
          mutedStroke,
        );
      case AnimalIconName.shopping:
        canvas.drawRect(
          Rect.fromLTWH(r * 0.48, r * 0.74, r * 1.04, r * 0.78),
          stroke,
        );
        canvas.drawArc(
          Rect.fromLTWH(r * 0.72, r * 0.42, r * 0.56, r * 0.6),
          math.pi,
          math.pi,
          false,
          stroke,
        );
      case AnimalIconName.helicopter:
        canvas.drawLine(
          Offset(r * 0.42, r * 0.62),
          Offset(r * 1.58, r * 0.62),
          stroke,
        );
        canvas.drawOval(
          Rect.fromCenter(center: center, width: r * 0.92, height: r * 0.38),
          stroke,
        );
        canvas.drawLine(Offset(r * 1.3, r), Offset(r * 1.66, r * 1.2), stroke);
      case AnimalIconName.miles:
        canvas.drawCircle(center, r * 0.36, stroke);
        canvas.drawLine(center, Offset(center.dx, r * 0.28), stroke);
        canvas.drawLine(center, Offset(r * 1.24, r * 1.26), stroke);
      default:
        final path = Path()
          ..moveTo(center.dx, r * 0.36)
          ..lineTo(r * 1.46, r * 1.46)
          ..lineTo(r * 0.54, r * 1.46)
          ..close();
        canvas.drawPath(path, fill);
        canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _WestworldIconPainter oldDelegate) {
    return oldDelegate.name != name ||
        oldDelegate.color != color ||
        oldDelegate.muted != muted;
  }
}

class _PixelIconPainter extends CustomPainter {
  const _PixelIconPainter({
    required this.name,
    required this.color,
    required this.border,
    required this.highlight,
  });

  final AnimalIconName name;
  final Color color;
  final Color border;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 8;
    final fill = Paint()..color = color;
    final edge = Paint()..color = border;
    final hi = Paint()..color = highlight;

    void block(num x, num y, num w, num h, Paint paint) {
      canvas.drawRect(
        Rect.fromLTWH(x * unit, y * unit, w * unit, h * unit),
        paint,
      );
    }

    block(1, 1, 6, 6, edge);
    block(2, 2, 4, 4, fill);

    switch (name) {
      case AnimalIconName.camera:
        block(3, 3, 2, 2, hi);
      case AnimalIconName.chat:
        block(2, 2, 4, 3, fill);
        block(3, 5, 1, 1, fill);
        block(3, 3, 2, 1, hi);
      case AnimalIconName.map:
        block(2, 2, 1, 4, hi);
        block(5, 2, 1, 4, hi);
      case AnimalIconName.shopping:
        block(2, 3, 4, 3, fill);
        block(3, 2, 2, 1, hi);
      default:
        block(3, 2, 2, 4, hi);
        block(2, 3, 4, 2, hi);
    }
  }

  @override
  bool shouldRepaint(covariant _PixelIconPainter oldDelegate) {
    return oldDelegate.name != name ||
        oldDelegate.color != color ||
        oldDelegate.border != border ||
        oldDelegate.highlight != highlight;
  }
}
