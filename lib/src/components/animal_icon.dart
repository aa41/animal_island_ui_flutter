import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
