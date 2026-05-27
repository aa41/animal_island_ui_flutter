import 'package:flutter/widgets.dart';

import '../theme/animal_island_theme.dart';

typedef AnimalThemeWidgetBuilder = Widget Function(BuildContext context);

abstract final class AnimalComponentDispatcher {
  static Widget dispatch(
    BuildContext context, {
    required AnimalThemeWidgetBuilder animalIsland,
    required AnimalThemeWidgetBuilder nes,
    required AnimalThemeWidgetBuilder westworld,
    required AnimalThemeWidgetBuilder guofeng,
  }) {
    return switch (context.animalIslandTheme.gameStyle) {
      AnimalIslandGameStyle.animalIsland => animalIsland(context),
      AnimalIslandGameStyle.nes8Bit => nes(context),
      AnimalIslandGameStyle.westworld => westworld(context),
      AnimalIslandGameStyle.guofengDoodle => guofeng(context),
    };
  }
}
