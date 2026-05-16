import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/animal_island_models.dart';
import '../utils/animal_island_assets.dart';

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
}
