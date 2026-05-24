import 'package:flutter/material.dart';

import '../../models/animal_island_models.dart';
import '../../theme/animal_island_theme.dart';

abstract final class AnimalSelectThemeStrategy {
  const AnimalSelectThemeStrategy();

  static AnimalSelectThemeStrategy of(AnimalIslandThemeData theme) {
    return switch (theme.gameStyle) {
      AnimalIslandGameStyle.nes8Bit => const _NesAnimalSelectThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalSelectThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandSelectThemeStrategy(),
    };
  }

  BoxDecoration menuDecoration(AnimalIslandThemeData theme);

  BoxDecoration triggerDecoration(AnimalIslandThemeData theme, bool open);

  Color optionTextColor(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool hovered,
  });

  String optionLabel(String label, {required bool hovered});

  Color triggerTextColor(AnimalIslandThemeData theme, {required bool empty});

  double? triggerLetterSpacing(AnimalIslandThemeData theme);

  Color selectedMarkColor(AnimalIslandThemeData theme);
}

final class _AnimalIslandSelectThemeStrategy
    extends AnimalSelectThemeStrategy {
  const _AnimalIslandSelectThemeStrategy();

  @override
  BoxDecoration menuDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: const Color(0xFFFFEEA0),
      borderRadius: BorderRadius.circular(28),
    );
  }

  @override
  BoxDecoration triggerDecoration(AnimalIslandThemeData theme, bool open) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE8DCC8), width: 2),
    );
  }

  @override
  Color optionTextColor(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool hovered,
  }) {
    return const Color(0xFF725D42);
  }

  @override
  String optionLabel(String label, {required bool hovered}) => label;

  @override
  Color triggerTextColor(AnimalIslandThemeData theme, {required bool empty}) {
    return empty ? theme.textDisabled : const Color(0xFF725D42);
  }

  @override
  double? triggerLetterSpacing(AnimalIslandThemeData theme) => null;

  @override
  Color selectedMarkColor(AnimalIslandThemeData theme) =>
      const Color(0xFFFFCC00);
}

final class _NesAnimalSelectThemeStrategy extends AnimalSelectThemeStrategy {
  const _NesAnimalSelectThemeStrategy();

  @override
  BoxDecoration menuDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      borderRadius: BorderRadius.circular(theme.radiusBase),
      border: Border.all(color: theme.border, width: theme.borderWidth),
      boxShadow: [
        BoxShadow(
          color: theme.buttonShadow,
          blurRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  BoxDecoration triggerDecoration(AnimalIslandThemeData theme, bool open) {
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.circular(theme.radiusSm),
      border: Border.all(color: theme.border, width: theme.borderWidth),
      boxShadow: open
          ? [
              BoxShadow(
                color: theme.buttonShadow,
                blurRadius: 0,
                offset: const Offset(0, 3),
              ),
            ]
          : null,
    );
  }

  @override
  Color optionTextColor(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool hovered,
  }) {
    return selected || hovered ? theme.primary : theme.textBody;
  }

  @override
  String optionLabel(String label, {required bool hovered}) {
    return hovered ? '> $label' : label;
  }

  @override
  Color triggerTextColor(AnimalIslandThemeData theme, {required bool empty}) {
    return empty ? theme.textDisabled : theme.textBody;
  }

  @override
  double? triggerLetterSpacing(AnimalIslandThemeData theme) => null;

  @override
  Color selectedMarkColor(AnimalIslandThemeData theme) => const Color(0xFFFFCC00);
}

final class _WestworldAnimalSelectThemeStrategy
    extends AnimalSelectThemeStrategy {
  const _WestworldAnimalSelectThemeStrategy();

  @override
  BoxDecoration menuDecoration(AnimalIslandThemeData theme) {
    return theme.westworldPanelDecoration(emphasized: true);
  }

  @override
  BoxDecoration triggerDecoration(AnimalIslandThemeData theme, bool open) {
    return theme.westworldPanelDecoration(
      color: theme.surfaceRaised,
      hovered: open,
      emphasized: open,
    );
  }

  @override
  Color optionTextColor(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool hovered,
  }) {
    return selected || hovered ? theme.textPrimary : theme.textSecondary;
  }

  @override
  String optionLabel(String label, {required bool hovered}) =>
      label.toUpperCase();

  @override
  Color triggerTextColor(AnimalIslandThemeData theme, {required bool empty}) {
    return empty ? theme.textDisabled : theme.textPrimary;
  }

  @override
  double? triggerLetterSpacing(AnimalIslandThemeData theme) => 0.7;

  @override
  Color selectedMarkColor(AnimalIslandThemeData theme) =>
      theme.primary.withValues(alpha: 0.86);
}
