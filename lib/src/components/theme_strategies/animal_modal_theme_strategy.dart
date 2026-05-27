import 'package:flutter/material.dart';

import '../../theme/animal_island_theme.dart';
import '../../theme/animal_island_tokens.dart';

abstract final class AnimalModalThemeStrategy {
  const AnimalModalThemeStrategy();

  static AnimalModalThemeStrategy of(AnimalIslandThemeData theme) {
    return forGameStyle(theme.gameStyle);
  }

  static AnimalModalThemeStrategy forGameStyle(
    AnimalIslandGameStyle gameStyle,
  ) {
    return switch (gameStyle) {
      AnimalIslandGameStyle.nes8Bit => const _NesAnimalModalThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalModalThemeStrategy(),
      AnimalIslandGameStyle.guofengDoodle =>
        const _GuofengAnimalModalThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandModalThemeStrategy(),
    };
  }

  BoxDecoration panelDecoration(AnimalIslandThemeData theme);

  EdgeInsets panelPadding(AnimalIslandThemeData theme);

  double titleFontSize(AnimalIslandThemeData theme);

  double bodyFontSize(AnimalIslandThemeData theme);

  double bodyHeight(AnimalIslandThemeData theme);

  FontWeight bodyFontWeight(AnimalIslandThemeData theme);

  BorderRadius? clipRadius(AnimalIslandThemeData theme);
}

final class _AnimalIslandModalThemeStrategy extends AnimalModalThemeStrategy {
  const _AnimalIslandModalThemeStrategy();

  @override
  BoxDecoration panelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[theme.surfaceRaised, theme.surface],
      ),
    );
  }

  @override
  EdgeInsets panelPadding(AnimalIslandThemeData theme) {
    return const EdgeInsets.fromLTRB(36, 36, 36, 28);
  }

  @override
  double titleFontSize(AnimalIslandThemeData theme) =>
      AnimalIslandTokens.fontHeadlineSm;

  @override
  double bodyFontSize(AnimalIslandThemeData theme) =>
      AnimalIslandTokens.fontBodyLg;

  @override
  double bodyHeight(AnimalIslandThemeData theme) => 1.55;

  @override
  FontWeight bodyFontWeight(AnimalIslandThemeData theme) => FontWeight.w600;

  @override
  BorderRadius? clipRadius(AnimalIslandThemeData theme) => null;
}

final class _NesAnimalModalThemeStrategy extends AnimalModalThemeStrategy {
  const _NesAnimalModalThemeStrategy();

  @override
  BoxDecoration panelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      borderRadius: BorderRadius.circular(theme.radiusBase),
      border: Border.all(color: theme.border, width: theme.borderWidth),
      boxShadow: [
        BoxShadow(
          color: theme.buttonShadow,
          blurRadius: 0,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  @override
  EdgeInsets panelPadding(AnimalIslandThemeData theme) {
    return const EdgeInsets.fromLTRB(24, 24, 24, 22);
  }

  @override
  double titleFontSize(AnimalIslandThemeData theme) =>
      AnimalIslandTokens.fontBody;

  @override
  double bodyFontSize(AnimalIslandThemeData theme) =>
      AnimalIslandTokens.fontBodySm;

  @override
  double bodyHeight(AnimalIslandThemeData theme) => 1.8;

  @override
  FontWeight bodyFontWeight(AnimalIslandThemeData theme) => FontWeight.w600;

  @override
  BorderRadius? clipRadius(AnimalIslandThemeData theme) =>
      BorderRadius.circular(theme.radiusBase);
}

final class _WestworldAnimalModalThemeStrategy
    extends AnimalModalThemeStrategy {
  const _WestworldAnimalModalThemeStrategy();

  @override
  BoxDecoration panelDecoration(AnimalIslandThemeData theme) {
    return theme.westworldPanelDecoration(emphasized: true);
  }

  @override
  EdgeInsets panelPadding(AnimalIslandThemeData theme) {
    return const EdgeInsets.fromLTRB(36, 36, 36, 28);
  }

  @override
  double titleFontSize(AnimalIslandThemeData theme) =>
      AnimalIslandTokens.fontHeadlineSm;

  @override
  double bodyFontSize(AnimalIslandThemeData theme) =>
      AnimalIslandTokens.fontBodyLg;

  @override
  double bodyHeight(AnimalIslandThemeData theme) => 1.36;

  @override
  FontWeight bodyFontWeight(AnimalIslandThemeData theme) => FontWeight.w400;

  @override
  BorderRadius? clipRadius(AnimalIslandThemeData theme) =>
      BorderRadius.circular(theme.radiusBase);
}

final class _GuofengAnimalModalThemeStrategy extends AnimalModalThemeStrategy {
  const _GuofengAnimalModalThemeStrategy();

  @override
  BoxDecoration panelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.circular(theme.radiusLg),
      border: Border.all(color: Colors.transparent, width: theme.borderWidth),
      boxShadow: [
        BoxShadow(
          color: theme.inputShadow.withValues(alpha: 0.38),
          blurRadius: theme.mode == AnimalIslandThemeMode.day ? 10 : 18,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  EdgeInsets panelPadding(AnimalIslandThemeData theme) {
    return const EdgeInsets.fromLTRB(28, 28, 28, 24);
  }

  @override
  double titleFontSize(AnimalIslandThemeData theme) =>
      AnimalIslandTokens.fontHeadlineSm;

  @override
  double bodyFontSize(AnimalIslandThemeData theme) =>
      AnimalIslandTokens.fontBodyLg;

  @override
  double bodyHeight(AnimalIslandThemeData theme) => 1.5;

  @override
  FontWeight bodyFontWeight(AnimalIslandThemeData theme) => FontWeight.w500;

  @override
  BorderRadius? clipRadius(AnimalIslandThemeData theme) =>
      BorderRadius.circular(theme.radiusLg);
}
