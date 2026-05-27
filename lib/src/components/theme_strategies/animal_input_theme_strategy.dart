import 'package:flutter/material.dart';

import '../../models/animal_island_models.dart';
import '../../theme/animal_island_theme.dart';

abstract final class AnimalInputThemeStrategy {
  const AnimalInputThemeStrategy();

  static AnimalInputThemeStrategy of(AnimalIslandThemeData theme) {
    return forGameStyle(theme.gameStyle);
  }

  static AnimalInputThemeStrategy forGameStyle(
    AnimalIslandGameStyle gameStyle,
  ) {
    return switch (gameStyle) {
      AnimalIslandGameStyle.nes8Bit => const _NesAnimalInputThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalInputThemeStrategy(),
      AnimalIslandGameStyle.guofengDoodle =>
        const _GuofengAnimalInputThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandInputThemeStrategy(),
    };
  }

  double radiusForSize(AnimalIslandThemeData theme, AnimalInputSize size);

  Color backgroundColor(AnimalIslandThemeData theme, {required bool enabled});

  TextStyle textStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool enabled,
    required double fontSize,
  });

  BoxDecoration decoration(
    AnimalIslandThemeData theme, {
    required bool hovered,
    required bool focused,
    required bool enabled,
    required bool shadow,
    required AnimalInputStatus? status,
    required double radius,
    required double borderWidth,
    required double shadowDepth,
  });
}

final class _AnimalIslandInputThemeStrategy extends AnimalInputThemeStrategy {
  const _AnimalIslandInputThemeStrategy();

  @override
  double radiusForSize(AnimalIslandThemeData theme, AnimalInputSize size) {
    return switch (size) {
      AnimalInputSize.small => theme.radiusPill,
      AnimalInputSize.middle => theme.radiusPill,
      AnimalInputSize.large => theme.radiusPill,
    };
  }

  @override
  Color backgroundColor(AnimalIslandThemeData theme, {required bool enabled}) {
    return enabled ? theme.surfaceRaised : theme.surfaceMuted;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool enabled,
    required double fontSize,
  }) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: fontSize,
      color: enabled ? theme.textBody : theme.textDisabled,
      letterSpacing: 0.14,
      fontFamily: null,
    );
  }

  @override
  BoxDecoration decoration(
    AnimalIslandThemeData theme, {
    required bool hovered,
    required bool focused,
    required bool enabled,
    required bool shadow,
    required AnimalInputStatus? status,
    required double radius,
    required double borderWidth,
    required double shadowDepth,
  }) {
    var borderColor = theme.borderLight;
    var shadowColor = theme.inputShadow;
    if (hovered) {
      borderColor = theme.borderHover;
      shadowColor = theme.borderLight;
    }
    if (focused) {
      borderColor = theme.focusYellow;
      shadowColor = theme.focusYellowDark;
    }
    if (status == AnimalInputStatus.error) {
      borderColor = theme.error;
      shadowColor = theme.errorActive;
    }
    if (status == AnimalInputStatus.warning) {
      borderColor = theme.warning;
      shadowColor = theme.warningActive;
    }
    if (!enabled) {
      borderColor = theme.inputShadow;
      shadowColor = Colors.transparent;
    }

    return BoxDecoration(
      color: backgroundColor(theme, enabled: enabled),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: (!shadow && status == null && !focused) || !enabled
          ? null
          : [
              BoxShadow(
                color: shadowColor,
                blurRadius: 0,
                offset: Offset(0, shadowDepth),
              ),
            ],
    );
  }
}

final class _NesAnimalInputThemeStrategy extends AnimalInputThemeStrategy {
  const _NesAnimalInputThemeStrategy();

  @override
  double radiusForSize(AnimalIslandThemeData theme, AnimalInputSize size) {
    return switch (size) {
      AnimalInputSize.small => theme.radiusSm,
      AnimalInputSize.middle => theme.radiusPill,
      AnimalInputSize.large => theme.radiusLg,
    };
  }

  @override
  Color backgroundColor(AnimalIslandThemeData theme, {required bool enabled}) {
    return enabled ? theme.surface : theme.surfaceMuted;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool enabled,
    required double fontSize,
  }) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: fontSize,
      color: enabled ? theme.textBody : theme.textDisabled,
      letterSpacing: 0.14,
      fontFamily: 'Press Start 2P',
    );
  }

  @override
  BoxDecoration decoration(
    AnimalIslandThemeData theme, {
    required bool hovered,
    required bool focused,
    required bool enabled,
    required bool shadow,
    required AnimalInputStatus? status,
    required double radius,
    required double borderWidth,
    required double shadowDepth,
  }) {
    return _AnimalIslandInputThemeStrategy().decoration(
      theme,
      hovered: hovered,
      focused: focused,
      enabled: enabled,
      shadow: shadow,
      status: status,
      radius: radius,
      borderWidth: borderWidth,
      shadowDepth: shadowDepth,
    );
  }
}

final class _WestworldAnimalInputThemeStrategy
    extends AnimalInputThemeStrategy {
  const _WestworldAnimalInputThemeStrategy();

  @override
  double radiusForSize(AnimalIslandThemeData theme, AnimalInputSize size) {
    return theme.radiusBase;
  }

  @override
  Color backgroundColor(AnimalIslandThemeData theme, {required bool enabled}) {
    return enabled
        ? theme.surfaceRaised.withValues(alpha: 0.58)
        : theme.surfaceMuted;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool enabled,
    required double fontSize,
  }) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: fontSize,
      color: enabled ? theme.textBody : theme.textDisabled,
      letterSpacing: 0.72,
      fontFamily: null,
    );
  }

  @override
  BoxDecoration decoration(
    AnimalIslandThemeData theme, {
    required bool hovered,
    required bool focused,
    required bool enabled,
    required bool shadow,
    required AnimalInputStatus? status,
    required double radius,
    required double borderWidth,
    required double shadowDepth,
  }) {
    var borderColor = theme.borderLight;
    if (hovered) {
      borderColor = theme.borderHover;
    }
    if (focused) {
      borderColor = theme.focusYellow;
    }
    if (status == AnimalInputStatus.error) {
      borderColor = theme.error;
    }
    if (status == AnimalInputStatus.warning) {
      borderColor = theme.warning;
    }
    if (!enabled) {
      borderColor = theme.inputShadow;
    }

    return BoxDecoration(
      color: backgroundColor(theme, enabled: enabled),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: null,
    );
  }
}

final class _GuofengAnimalInputThemeStrategy extends AnimalInputThemeStrategy {
  const _GuofengAnimalInputThemeStrategy();

  @override
  double radiusForSize(AnimalIslandThemeData theme, AnimalInputSize size) {
    return switch (size) {
      AnimalInputSize.small => theme.radiusSm,
      AnimalInputSize.middle => theme.radiusBase,
      AnimalInputSize.large => theme.radiusLg,
    };
  }

  @override
  Color backgroundColor(AnimalIslandThemeData theme, {required bool enabled}) {
    return enabled ? theme.surface : theme.surfaceMuted;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool enabled,
    required double fontSize,
  }) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: fontSize,
      color: enabled ? theme.textBody : theme.textDisabled,
      letterSpacing: 0,
      fontFamily: null,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  BoxDecoration decoration(
    AnimalIslandThemeData theme, {
    required bool hovered,
    required bool focused,
    required bool enabled,
    required bool shadow,
    required AnimalInputStatus? status,
    required double radius,
    required double borderWidth,
    required double shadowDepth,
  }) {
    var borderColor = theme.border.withValues(alpha: 0.82);
    var shadowColor = theme.inputShadow;
    if (hovered) {
      borderColor = theme.borderHover;
    }
    if (focused) {
      borderColor = theme.primary;
      shadowColor = theme.inputShadow.withValues(alpha: 0.72);
    }
    if (status == AnimalInputStatus.error) {
      borderColor = theme.error;
      shadowColor = theme.errorActive;
    }
    if (status == AnimalInputStatus.warning) {
      borderColor = theme.warning;
      shadowColor = theme.warningActive;
    }
    if (!enabled) {
      borderColor = theme.borderLight.withValues(alpha: 0.42);
      shadowColor = Colors.transparent;
    }

    return BoxDecoration(
      color: backgroundColor(theme, enabled: enabled),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor.withValues(alpha: 0),
        width: borderWidth,
      ),
      boxShadow: !enabled || (!shadow && !focused && status == null)
          ? null
          : [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.62),
                blurRadius: 0,
                offset: Offset(0, shadowDepth),
              ),
              if (focused)
                BoxShadow(
                  color: theme.primary.withValues(alpha: 0.08),
                  blurRadius: 0,
                  spreadRadius: 1.5,
                ),
            ],
    );
  }
}
