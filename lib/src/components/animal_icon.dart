import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/animal_island_models.dart';
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
