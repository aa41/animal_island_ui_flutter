import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';
import 'animal_component_dispatcher.dart';

class AnimalIcon extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandIcon(
        name: name,
        size: size,
        bounce: bounce,
        color: color,
      ),
      nes: (_) =>
          _NesAnimalIcon(name: name, size: size, bounce: bounce, color: color),
      westworld: (_) => _WestworldAnimalIcon(
        name: name,
        size: size,
        bounce: bounce,
        color: color,
      ),
      guofeng: (_) => _GuofengAnimalIcon(
        name: name,
        size: size,
        bounce: bounce,
        color: color,
      ),
    );
  }
}

class _AnimalIslandIcon extends _ThemedAnimalIcon {
  const _AnimalIslandIcon({
    required super.name,
    required super.size,
    required super.bounce,
    required super.color,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalIcon extends _ThemedAnimalIcon {
  const _NesAnimalIcon({
    required super.name,
    required super.size,
    required super.bounce,
    required super.color,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalIcon extends _ThemedAnimalIcon {
  const _WestworldAnimalIcon({
    required super.name,
    required super.size,
    required super.bounce,
    required super.color,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalIcon extends _ThemedAnimalIcon {
  const _GuofengAnimalIcon({
    required super.name,
    required super.size,
    required super.bounce,
    required super.color,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalIcon extends StatefulWidget {
  const _ThemedAnimalIcon({
    required this.gameStyle,
    required this.name,
    required this.size,
    required this.bounce,
    required this.color,
  });

  final AnimalIslandGameStyle gameStyle;
  final AnimalIconName name;
  final double size;
  final bool bounce;
  final Color? color;

  @override
  State<_ThemedAnimalIcon> createState() => _ThemedAnimalIconState();
}

class _ThemedAnimalIconState extends State<_ThemedAnimalIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final filterQuality = theme.isNes ? FilterQuality.none : FilterQuality.high;
    Widget icon = Image.asset(
      AnimalIslandAssets.themedIcon(widget.gameStyle, widget.name),
      package: AnimalIslandAssets.package,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      filterQuality: filterQuality,
      gaplessPlayback: true,
      isAntiAlias: !theme.isNes,
    );

    if (widget.color != null) {
      icon = ColorFiltered(
        colorFilter: ColorFilter.mode(widget.color!, BlendMode.srcIn),
        child: icon,
      );
    }

    final duration = theme.isWestworld
        ? theme.interactionDuration
        : AnimalIslandTokens.base;
    final curve = theme.isWestworld
        ? theme.interactionCurve
        : AnimalIslandTokens.motionCurve;

    Widget animated = AnimatedScale(
      scale: widget.bounce && _hovered ? (theme.isWestworld ? 1.06 : 1.1) : 1,
      duration: duration,
      curve: curve,
      child: icon,
    );

    if (!theme.isWestworld) {
      animated = Transform.translate(
        offset: Offset(0, widget.bounce && _hovered ? -2 : 0),
        child: AnimatedRotation(
          turns: widget.bounce && _hovered ? (-5 / 360) : 0,
          duration: duration,
          curve: curve,
          child: animated,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: animated,
    );
  }
}
