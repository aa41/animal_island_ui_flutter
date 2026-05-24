import 'package:flutter/material.dart';

import '../../models/animal_island_models.dart';
import '../../theme/animal_island_theme.dart';
import '../../theme/animal_island_tokens.dart';

abstract final class AnimalTimeThemeStrategy {
  const AnimalTimeThemeStrategy();

  static AnimalTimeThemeStrategy of(AnimalIslandThemeData theme) {
    return switch (theme.gameStyle) {
      AnimalIslandGameStyle.nes8Bit => const _NesAnimalTimeThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalTimeThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandTimeThemeStrategy(),
    };
  }

  BoxDecoration decoration(AnimalIslandThemeData theme);

  TextStyle weekdayStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  });

  TextStyle dateStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  });

  TextStyle timeStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  });

  TextStyle colonStyle(
    BuildContext context,
    AnimalIslandThemeData theme,
  );
}

final class _AnimalIslandTimeThemeStrategy extends AnimalTimeThemeStrategy {
  const _AnimalIslandTimeThemeStrategy();

  @override
  BoxDecoration decoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      gradient: LinearGradient(
        colors: <Color>[
          Colors.white.withValues(
            alpha: theme.mode == AnimalIslandThemeMode.day ? 1 : 0.2,
          ),
          theme.surface,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFD4CFC3), width: 3),
    );
  }

  @override
  TextStyle weekdayStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      color: theme.success,
      fontWeight: FontWeight.w900,
      fontSize: compact
          ? AnimalIslandTokens.fontMicro
          : AnimalIslandTokens.fontCaption,
      letterSpacing: compact ? 1.1 : 1.3,
    );
  }

  @override
  TextStyle dateStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: const Color(0xFF8B7355),
      fontWeight: FontWeight.w800,
      fontSize: compact
          ? AnimalIslandTokens.fontBody
          : AnimalIslandTokens.fontTitleSm,
    );
  }

  @override
  TextStyle timeStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
      color: const Color(0xFF8B7355),
      fontSize: compact ? 24 : 32,
      fontWeight: FontWeight.w900,
      letterSpacing: compact ? 1.1 : 1.5,
    );
  }

  @override
  TextStyle colonStyle(
    BuildContext context,
    AnimalIslandThemeData theme,
  ) {
    return const TextStyle(color: Color(0xFF8B7355));
  }
}

final class _NesAnimalTimeThemeStrategy extends AnimalTimeThemeStrategy {
  const _NesAnimalTimeThemeStrategy();

  @override
  BoxDecoration decoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      borderRadius: BorderRadius.circular(theme.radiusSm),
      border: Border.all(color: theme.border, width: 3),
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
  TextStyle weekdayStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      color: theme.primary,
      fontWeight: FontWeight.w900,
      fontSize: compact
          ? AnimalIslandTokens.fontMicro
          : AnimalIslandTokens.fontCaption,
      letterSpacing: compact ? 1.1 : 1.3,
    );
  }

  @override
  TextStyle dateStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: theme.textPrimary,
      fontWeight: FontWeight.w800,
      fontSize: compact
          ? AnimalIslandTokens.fontBody
          : AnimalIslandTokens.fontTitleSm,
    );
  }

  @override
  TextStyle timeStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
      color: theme.textPrimary,
      fontSize: compact ? 24 : 32,
      fontWeight: FontWeight.w900,
      letterSpacing: compact ? 1.1 : 1.5,
    );
  }

  @override
  TextStyle colonStyle(
    BuildContext context,
    AnimalIslandThemeData theme,
  ) {
    return TextStyle(color: theme.focusYellow);
  }
}

final class _WestworldAnimalTimeThemeStrategy extends AnimalTimeThemeStrategy {
  const _WestworldAnimalTimeThemeStrategy();

  @override
  BoxDecoration decoration(AnimalIslandThemeData theme) {
    return theme.westworldPanelDecoration(emphasized: true);
  }

  @override
  TextStyle weekdayStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      color: theme.textMuted,
      fontWeight: FontWeight.w900,
      fontSize: compact
          ? AnimalIslandTokens.fontMicro
          : AnimalIslandTokens.fontCaption,
      letterSpacing: compact ? 1.1 : 1.3,
    );
  }

  @override
  TextStyle dateStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: theme.textPrimary,
      fontWeight: FontWeight.w800,
      fontSize: compact
          ? AnimalIslandTokens.fontBody
          : AnimalIslandTokens.fontTitleSm,
    );
  }

  @override
  TextStyle timeStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
      color: theme.textPrimary,
      fontSize: compact ? 24 : 32,
      fontWeight: FontWeight.w900,
      letterSpacing: compact ? 1.1 : 1.5,
    );
  }

  @override
  TextStyle colonStyle(
    BuildContext context,
    AnimalIslandThemeData theme,
  ) {
    return TextStyle(color: theme.focusYellow);
  }
}
