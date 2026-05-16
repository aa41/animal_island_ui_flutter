import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/animal_island_models.dart';
import '../utils/animal_island_assets.dart';

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
