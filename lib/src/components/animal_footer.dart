import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../utils/animal_island_assets.dart';
import 'animal_component_dispatcher.dart';

class AnimalFooter extends StatelessWidget {
  const AnimalFooter({
    super.key,
    this.type = AnimalFooterType.tree,
    this.height,
  });

  final AnimalFooterType type;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandFooter(type: type, height: height),
      nes: (_) => _NesAnimalFooter(type: type, height: height),
      westworld: (_) => _WestworldAnimalFooter(type: type, height: height),
      guofeng: (_) => _GuofengAnimalFooter(type: type, height: height),
    );
  }
}

class _AnimalIslandFooter extends _ThemedAnimalFooter {
  const _AnimalIslandFooter({required super.type, required super.height})
    : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalFooter extends _ThemedAnimalFooter {
  const _NesAnimalFooter({required super.type, required super.height})
    : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalFooter extends _ThemedAnimalFooter {
  const _WestworldAnimalFooter({required super.type, required super.height})
    : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalFooter extends _ThemedAnimalFooter {
  const _GuofengAnimalFooter({required super.type, required super.height})
    : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalFooter extends StatelessWidget {
  const _ThemedAnimalFooter({
    required this.gameStyle,
    required this.type,
    required this.height,
  });

  final AnimalIslandGameStyle gameStyle;
  final AnimalFooterType type;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (gameStyle == AnimalIslandGameStyle.westworld) {
      return _GeneratedFooterImage(
        asset: _assetForType(
          tree: AnimalIslandAssets.westworldFooterTree,
          sea: AnimalIslandAssets.westworldFooterSea,
        ),
        height: height ?? _generatedHeight(tree: 76, sea: 70),
        filterQuality: FilterQuality.medium,
      );
    }

    if (gameStyle == AnimalIslandGameStyle.nes8Bit) {
      return _GeneratedFooterImage(
        asset: _assetForType(
          tree: AnimalIslandAssets.nesFooterTree,
          sea: AnimalIslandAssets.nesFooterSea,
        ),
        height: height ?? _generatedHeight(tree: 74, sea: 70),
        filterQuality: FilterQuality.none,
      );
    }

    if (gameStyle == AnimalIslandGameStyle.guofengDoodle) {
      return _GeneratedFooterImage(
        asset: _assetForType(
          tree: AnimalIslandAssets.guofengFooterTree,
          sea: AnimalIslandAssets.guofengFooterSea,
        ),
        height: height ?? _generatedHeight(tree: 82, sea: 76),
        filterQuality: FilterQuality.medium,
      );
    }

    if (type == AnimalFooterType.sea) {
      return SvgPicture.asset(
        AnimalIslandAssets.footerSea,
        package: AnimalIslandAssets.package,
        fit: BoxFit.contain,
        width: double.infinity,
        height: height ?? 80,
      );
    }

    return Image.asset(
      AnimalIslandAssets.footerTree,
      package: AnimalIslandAssets.package,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height ?? 60,
      alignment: Alignment.bottomCenter,
    );
  }

  String _assetForType({required String tree, required String sea}) {
    return switch (type) {
      AnimalFooterType.tree => tree,
      AnimalFooterType.sea => sea,
    };
  }

  double _generatedHeight({required double tree, required double sea}) {
    return switch (type) {
      AnimalFooterType.tree => tree,
      AnimalFooterType.sea => sea,
    };
  }
}

class _GeneratedFooterImage extends StatelessWidget {
  const _GeneratedFooterImage({
    required this.asset,
    required this.height,
    required this.filterQuality,
  });

  final String asset;
  final double height;
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      package: AnimalIslandAssets.package,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      alignment: Alignment.bottomCenter,
      filterQuality: filterQuality,
    );
  }
}
