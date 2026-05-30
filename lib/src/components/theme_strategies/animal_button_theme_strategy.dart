import 'package:flutter/material.dart';

import '../../models/animal_island_models.dart';
import '../../theme/animal_island_theme.dart';

enum AnimalButtonLoadingStyle { stripe, pixel, scanline }

class AnimalButtonColors {
  const AnimalButtonColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.shadow,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final Color shadow;
}

abstract final class AnimalButtonThemeStrategy {
  const AnimalButtonThemeStrategy();

  static AnimalButtonThemeStrategy of(AnimalIslandThemeData theme) {
    return forGameStyle(theme.gameStyle);
  }

  static AnimalButtonThemeStrategy forGameStyle(
    AnimalIslandGameStyle gameStyle,
  ) {
    return switch (gameStyle) {
      AnimalIslandGameStyle.nes8Bit => const _NesAnimalButtonThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalButtonThemeStrategy(),
      AnimalIslandGameStyle.guofengDoodle =>
        const _GuofengAnimalButtonThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandButtonThemeStrategy(),
    };
  }

  AnimalButtonLoadingStyle get loadingStyle;

  AnimalButtonColors resolveColors(
    AnimalIslandThemeData theme, {
    required AnimalButtonType type,
    required bool danger,
    required bool ghost,
    required bool loading,
  });
}

final class _AnimalIslandButtonThemeStrategy extends AnimalButtonThemeStrategy {
  const _AnimalIslandButtonThemeStrategy();

  @override
  AnimalButtonLoadingStyle get loadingStyle => AnimalButtonLoadingStyle.stripe;

  @override
  AnimalButtonColors resolveColors(
    AnimalIslandThemeData theme, {
    required AnimalButtonType type,
    required bool danger,
    required bool ghost,
    required bool loading,
  }) {
    if (loading) {
      return AnimalButtonColors(
        background: const Color(0xFF0EC4B6),
        border: const Color(0xFF4DE2DA),
        foreground: Colors.white,
        shadow: Colors.transparent,
      );
    }

    if (danger) {
      if (type == AnimalButtonType.primary) {
        return AnimalButtonColors(
          background: theme.error,
          border: theme.error,
          foreground: Colors.white,
          shadow: theme.errorActive,
        );
      }

      if (type == AnimalButtonType.text || type == AnimalButtonType.link) {
        return const AnimalButtonColors(
          background: Colors.transparent,
          border: Colors.transparent,
          foreground: Colors.white,
          shadow: Colors.transparent,
        );
      }

      return AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.error,
        foreground: theme.error,
        shadow: theme.buttonShadow,
      );
    }

    return switch (type) {
      AnimalButtonType.primary => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: ghost ? theme.primary : theme.surface,
        foreground: ghost ? theme.primary : const Color(0xFF794F27),
        shadow: ghost ? Colors.transparent : theme.buttonShadow,
      ),
      AnimalButtonType.defaultType => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.border,
        foreground: theme.textPrimary,
        shadow: theme.buttonShadow,
      ),
      AnimalButtonType.dashed => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.border,
        foreground: theme.textPrimary,
        shadow: Colors.transparent,
      ),
      AnimalButtonType.text => const AnimalButtonColors(
        background: Colors.transparent,
        border: Colors.transparent,
        foreground: Color(0xFF794F27),
        shadow: Colors.transparent,
      ),
      AnimalButtonType.link => AnimalButtonColors(
        background: Colors.transparent,
        border: Colors.transparent,
        foreground: theme.primary,
        shadow: Colors.transparent,
      ),
    };
  }
}

final class _NesAnimalButtonThemeStrategy extends AnimalButtonThemeStrategy {
  const _NesAnimalButtonThemeStrategy();

  @override
  AnimalButtonLoadingStyle get loadingStyle => AnimalButtonLoadingStyle.pixel;

  @override
  AnimalButtonColors resolveColors(
    AnimalIslandThemeData theme, {
    required AnimalButtonType type,
    required bool danger,
    required bool ghost,
    required bool loading,
  }) {
    if (loading) {
      return AnimalButtonColors(
        background: const Color(0xFF209CEE),
        border: theme.border,
        foreground: Colors.white,
        shadow: Colors.transparent,
      );
    }

    if (danger) {
      if (type == AnimalButtonType.primary) {
        return AnimalButtonColors(
          background: theme.error,
          border: theme.border,
          foreground: Colors.white,
          shadow: theme.buttonShadow,
        );
      }

      if (type == AnimalButtonType.text || type == AnimalButtonType.link) {
        return const AnimalButtonColors(
          background: Colors.transparent,
          border: Colors.transparent,
          foreground: Colors.white,
          shadow: Colors.transparent,
        );
      }

      return AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.border,
        foreground: theme.error,
        shadow: theme.buttonShadow,
      );
    }

    return switch (type) {
      AnimalButtonType.primary => AnimalButtonColors(
        background: ghost ? Colors.transparent : const Color(0xFF209CEE),
        border: ghost ? const Color(0xFF209CEE) : theme.border,
        foreground: ghost ? const Color(0xFF209CEE) : Colors.white,
        shadow: ghost ? Colors.transparent : const Color(0xFF006BB3),
      ),
      AnimalButtonType.defaultType => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: ghost ? theme.borderHover : theme.border,
        foreground: theme.textPrimary,
        shadow: const Color(0xFFADAFBC),
      ),
      AnimalButtonType.dashed => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.border,
        foreground: theme.textPrimary,
        shadow: const Color(0xFFADAFBC),
      ),
      AnimalButtonType.text => AnimalButtonColors(
        background: Colors.transparent,
        border: Colors.transparent,
        foreground: theme.textPrimary,
        shadow: Colors.transparent,
      ),
      AnimalButtonType.link => AnimalButtonColors(
        background: Colors.transparent,
        border: Colors.transparent,
        foreground: theme.primary,
        shadow: Colors.transparent,
      ),
    };
  }
}

final class _WestworldAnimalButtonThemeStrategy
    extends AnimalButtonThemeStrategy {
  const _WestworldAnimalButtonThemeStrategy();

  @override
  AnimalButtonLoadingStyle get loadingStyle =>
      AnimalButtonLoadingStyle.scanline;

  @override
  AnimalButtonColors resolveColors(
    AnimalIslandThemeData theme, {
    required AnimalButtonType type,
    required bool danger,
    required bool ghost,
    required bool loading,
  }) {
    if (loading) {
      return AnimalButtonColors(
        background: theme.surfaceRaised.withValues(alpha: 0.64),
        border: theme.primary.withValues(alpha: 0.72),
        foreground: theme.primary,
        shadow: Colors.transparent,
      );
    }

    if (danger) {
      if (type == AnimalButtonType.primary) {
        return AnimalButtonColors(
          background: theme.error,
          border: theme.error,
          foreground: Colors.white,
          shadow: theme.errorActive,
        );
      }

      if (type == AnimalButtonType.text || type == AnimalButtonType.link) {
        return const AnimalButtonColors(
          background: Colors.transparent,
          border: Colors.transparent,
          foreground: Colors.white,
          shadow: Colors.transparent,
        );
      }

      return AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.error,
        foreground: theme.error,
        shadow: theme.buttonShadow,
      );
    }

    return switch (type) {
      AnimalButtonType.primary => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.primary,
        border: ghost ? theme.primary : theme.primary,
        foreground: ghost ? theme.primary : theme.pageBackground,
        shadow: ghost ? Colors.transparent : theme.buttonShadow,
      ),
      AnimalButtonType.defaultType => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.border,
        foreground: theme.textPrimary,
        shadow: theme.buttonShadow,
      ),
      AnimalButtonType.dashed => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.border,
        foreground: theme.textPrimary,
        shadow: Colors.transparent,
      ),
      AnimalButtonType.text => AnimalButtonColors(
        background: Colors.transparent,
        border: Colors.transparent,
        foreground: theme.textPrimary,
        shadow: Colors.transparent,
      ),
      AnimalButtonType.link => AnimalButtonColors(
        background: Colors.transparent,
        border: Colors.transparent,
        foreground: theme.primary,
        shadow: Colors.transparent,
      ),
    };
  }
}

final class _GuofengAnimalButtonThemeStrategy
    extends AnimalButtonThemeStrategy {
  const _GuofengAnimalButtonThemeStrategy();

  @override
  AnimalButtonLoadingStyle get loadingStyle => AnimalButtonLoadingStyle.stripe;

  @override
  AnimalButtonColors resolveColors(
    AnimalIslandThemeData theme, {
    required AnimalButtonType type,
    required bool danger,
    required bool ghost,
    required bool loading,
  }) {
    if (loading) {
      return AnimalButtonColors(
        background: theme.surface,
        border: theme.border,
        foreground: theme.primary,
        shadow: theme.inputShadow,
      );
    }

    if (danger) {
      if (type == AnimalButtonType.primary) {
        return AnimalButtonColors(
          background: ghost ? Colors.transparent : theme.error,
          border: theme.errorActive,
          foreground: ghost ? theme.error : Colors.white,
          shadow: ghost ? Colors.transparent : theme.errorActive,
        );
      }
      return AnimalButtonColors(
        background: ghost
            ? Colors.transparent
            : theme.error.withValues(alpha: 0.08),
        border: theme.error,
        foreground: theme.error,
        shadow: ghost ? Colors.transparent : theme.inputShadow,
      );
    }

    return switch (type) {
      AnimalButtonType.primary => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.primary,
        border: theme.mode == AnimalIslandThemeMode.day
            ? const Color(0xFF3B2F2F)
            : theme.border,
        foreground: ghost
            ? theme.primary
            : theme.mode == AnimalIslandThemeMode.day
            ? theme.pageBackground
            : theme.textPrimary,
        shadow: ghost ? Colors.transparent : theme.buttonShadow,
      ),
      AnimalButtonType.defaultType => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surface,
        border: theme.mode == AnimalIslandThemeMode.day
            ? const Color(0xFF3B2F2F)
            : theme.border.withValues(alpha: 0.82),
        foreground: theme.textPrimary,
        shadow: ghost ? Colors.transparent : theme.buttonShadow,
      ),
      AnimalButtonType.dashed => AnimalButtonColors(
        background: ghost ? Colors.transparent : theme.surfaceRaised,
        border: theme.border.withValues(alpha: 0.92),
        foreground: theme.textPrimary,
        shadow: Colors.transparent,
      ),
      AnimalButtonType.text => AnimalButtonColors(
        background: Colors.transparent,
        border: Colors.transparent,
        foreground: theme.textPrimary,
        shadow: Colors.transparent,
      ),
      AnimalButtonType.link => AnimalButtonColors(
        background: Colors.transparent,
        border: Colors.transparent,
        foreground: theme.primary,
        shadow: Colors.transparent,
      ),
    };
  }
}
