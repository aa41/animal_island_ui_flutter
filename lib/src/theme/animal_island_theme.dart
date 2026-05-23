import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animal_island_tokens.dart';

enum AnimalIslandThemeMode { day, night }

enum AnimalIslandGameStyle { animalIsland, nes8Bit, westworld }

enum AnimalIslandThemeShape { organic, pixel, system }

@immutable
class AnimalIslandThemeSpec {
  const AnimalIslandThemeSpec({
    required this.shape,
    required this.radiusSm,
    required this.radiusBase,
    required this.radiusLg,
    required this.radiusPill,
    required this.borderWidth,
    required this.inputBorderWidth,
    required this.interactionCurve,
    required this.interactionDuration,
    required this.bodyHeight,
    required this.bodySmallHeight,
    required this.labelSpacing,
    required this.buttonHorizontalSmall,
    required this.buttonHorizontalMiddle,
    required this.buttonHorizontalLarge,
    required this.buttonShadowRest,
    required this.buttonShadowHover,
    required this.buttonShadowPressed,
    required this.buttonHoverOffsetY,
    required this.buttonPressedOffsetY,
    required this.inputHorizontalSmall,
    required this.inputHorizontalMiddle,
    required this.inputHorizontalLarge,
    required this.inputShadowSmall,
    required this.inputShadowMiddle,
    required this.inputShadowLarge,
    required this.cardTitleRadius,
    required this.cardRadius,
    required this.panelRadius,
    this.uppercaseLabels = false,
    this.hairlineAccents = false,
  });

  final AnimalIslandThemeShape shape;
  final double radiusSm;
  final double radiusBase;
  final double radiusLg;
  final double radiusPill;
  final double borderWidth;
  final double inputBorderWidth;
  final Curve interactionCurve;
  final Duration interactionDuration;
  final double bodyHeight;
  final double bodySmallHeight;
  final double labelSpacing;
  final double buttonHorizontalSmall;
  final double buttonHorizontalMiddle;
  final double buttonHorizontalLarge;
  final double buttonShadowRest;
  final double buttonShadowHover;
  final double buttonShadowPressed;
  final double buttonHoverOffsetY;
  final double buttonPressedOffsetY;
  final double inputHorizontalSmall;
  final double inputHorizontalMiddle;
  final double inputHorizontalLarge;
  final double inputShadowSmall;
  final double inputShadowMiddle;
  final double inputShadowLarge;
  final BorderRadius cardTitleRadius;
  final BorderRadius cardRadius;
  final BorderRadius panelRadius;
  final bool uppercaseLabels;
  final bool hairlineAccents;

  bool get isPixel => shape == AnimalIslandThemeShape.pixel;
  bool get isSystem => shape == AnimalIslandThemeShape.system;
  bool get isOrganic => shape == AnimalIslandThemeShape.organic;

  static const animalIsland = AnimalIslandThemeSpec(
    shape: AnimalIslandThemeShape.organic,
    radiusSm: AnimalIslandTokens.radiusSm,
    radiusBase: AnimalIslandTokens.radiusBase,
    radiusLg: AnimalIslandTokens.radiusLg,
    radiusPill: AnimalIslandTokens.radiusPill,
    borderWidth: AnimalIslandTokens.borderWidth,
    inputBorderWidth: AnimalIslandTokens.inputBorderWidth,
    interactionCurve: AnimalIslandTokens.motionCurve,
    interactionDuration: AnimalIslandTokens.fast,
    bodyHeight: 1.55,
    bodySmallHeight: 1.45,
    labelSpacing: 0.18,
    buttonHorizontalSmall: 16,
    buttonHorizontalMiddle: 20,
    buttonHorizontalLarge: 32,
    buttonShadowRest: 5,
    buttonShadowHover: 6,
    buttonShadowPressed: 1,
    buttonHoverOffsetY: -1,
    buttonPressedOffsetY: 2,
    inputHorizontalSmall: 14,
    inputHorizontalMiddle: 18,
    inputHorizontalLarge: 22,
    inputShadowSmall: 2,
    inputShadowMiddle: 3,
    inputShadowLarge: 4,
    cardTitleRadius: BorderRadius.only(
      topLeft: Radius.circular(40),
      topRight: Radius.circular(35),
      bottomLeft: Radius.circular(38),
      bottomRight: Radius.circular(45),
    ),
    cardRadius: BorderRadius.all(Radius.circular(20)),
    panelRadius: BorderRadius.all(Radius.circular(24)),
  );

  static const nes = AnimalIslandThemeSpec(
    shape: AnimalIslandThemeShape.pixel,
    radiusSm: AnimalIslandTokens.pixelRadiusSm,
    radiusBase: AnimalIslandTokens.pixelRadiusBase,
    radiusLg: AnimalIslandTokens.pixelRadiusLg,
    radiusPill: AnimalIslandTokens.pixelRadiusBase,
    borderWidth: AnimalIslandTokens.pixelBorderWidth,
    inputBorderWidth: AnimalIslandTokens.pixelBorderWidth,
    interactionCurve: AnimalIslandTokens.pixelCurve,
    interactionDuration: AnimalIslandTokens.pixelStep,
    bodyHeight: 1.75,
    bodySmallHeight: 1.65,
    labelSpacing: 0,
    buttonHorizontalSmall: 14,
    buttonHorizontalMiddle: 18,
    buttonHorizontalLarge: 24,
    buttonShadowRest: 4,
    buttonShadowHover: 4,
    buttonShadowPressed: 1,
    buttonHoverOffsetY: 0,
    buttonPressedOffsetY: 3,
    inputHorizontalSmall: 10,
    inputHorizontalMiddle: 12,
    inputHorizontalLarge: 14,
    inputShadowSmall: 3,
    inputShadowMiddle: 3,
    inputShadowLarge: 4,
    cardTitleRadius: BorderRadius.all(Radius.circular(2)),
    cardRadius: BorderRadius.all(Radius.circular(2)),
    panelRadius: BorderRadius.all(Radius.circular(2)),
  );

  static const westworld = AnimalIslandThemeSpec(
    shape: AnimalIslandThemeShape.system,
    radiusSm: 0,
    radiusBase: 0,
    radiusLg: 0,
    radiusPill: 0,
    borderWidth: 1,
    inputBorderWidth: 1,
    interactionCurve: Cubic(0.16, 1.0, 0.3, 1.0),
    interactionDuration: Duration(milliseconds: 180),
    bodyHeight: 1.36,
    bodySmallHeight: 1.24,
    labelSpacing: 1.05,
    buttonHorizontalSmall: 14,
    buttonHorizontalMiddle: 18,
    buttonHorizontalLarge: 24,
    buttonShadowRest: 0,
    buttonShadowHover: 0,
    buttonShadowPressed: 0,
    buttonHoverOffsetY: 0,
    buttonPressedOffsetY: 0,
    inputHorizontalSmall: 12,
    inputHorizontalMiddle: 16,
    inputHorizontalLarge: 18,
    inputShadowSmall: 0,
    inputShadowMiddle: 0,
    inputShadowLarge: 0,
    cardTitleRadius: BorderRadius.all(Radius.circular(0)),
    cardRadius: BorderRadius.all(Radius.circular(0)),
    panelRadius: BorderRadius.all(Radius.circular(0)),
    uppercaseLabels: true,
    hairlineAccents: true,
  );
}

abstract final class AnimalIslandThemeFactory {
  static AnimalIslandThemeData resolve({
    required AnimalIslandThemeMode mode,
    required AnimalIslandGameStyle gameStyle,
  }) {
    return switch ((gameStyle, mode)) {
      (AnimalIslandGameStyle.nes8Bit, AnimalIslandThemeMode.day) =>
        AnimalIslandThemeData.nesDay,
      (AnimalIslandGameStyle.nes8Bit, AnimalIslandThemeMode.night) =>
        AnimalIslandThemeData.nesNight,
      (AnimalIslandGameStyle.westworld, AnimalIslandThemeMode.day) =>
        AnimalIslandThemeData.westworldDay,
      (AnimalIslandGameStyle.westworld, AnimalIslandThemeMode.night) =>
        AnimalIslandThemeData.westworldNight,
      (_, AnimalIslandThemeMode.day) => AnimalIslandThemeData.day,
      (_, AnimalIslandThemeMode.night) => AnimalIslandThemeData.night,
    };
  }

  static AnimalIslandThemeSpec specFor(AnimalIslandGameStyle gameStyle) {
    return switch (gameStyle) {
      AnimalIslandGameStyle.nes8Bit => AnimalIslandThemeSpec.nes,
      AnimalIslandGameStyle.westworld => AnimalIslandThemeSpec.westworld,
      AnimalIslandGameStyle.animalIsland => AnimalIslandThemeSpec.animalIsland,
    };
  }
}

@immutable
class AnimalIslandThemeData extends ThemeExtension<AnimalIslandThemeData> {
  const AnimalIslandThemeData({
    this.gameStyle = AnimalIslandGameStyle.animalIsland,
    required this.mode,
    required this.primary,
    required this.primaryHover,
    required this.primaryActive,
    required this.primarySoft,
    required this.textPrimary,
    required this.textBody,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.border,
    required this.borderLight,
    required this.borderHover,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSoft,
    required this.surfaceMuted,
    required this.pageBackground,
    required this.pageBackgroundAlt,
    required this.success,
    required this.successActive,
    required this.warning,
    required this.warningActive,
    required this.error,
    required this.errorActive,
    required this.focusYellow,
    required this.focusYellowDark,
    required this.sidebarActive,
    required this.sidebarHover,
    required this.buttonShadow,
    required this.inputShadow,
    required this.heroGradientStart,
    required this.heroGradientEnd,
    required this.codeBackground,
    required this.codeBorder,
    required this.codeDefault,
  });

  final AnimalIslandGameStyle gameStyle;
  final AnimalIslandThemeMode mode;
  final Color primary;
  final Color primaryHover;
  final Color primaryActive;
  final Color primarySoft;
  final Color textPrimary;
  final Color textBody;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;
  final Color border;
  final Color borderLight;
  final Color borderHover;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceSoft;
  final Color surfaceMuted;
  final Color pageBackground;
  final Color pageBackgroundAlt;
  final Color success;
  final Color successActive;
  final Color warning;
  final Color warningActive;
  final Color error;
  final Color errorActive;
  final Color focusYellow;
  final Color focusYellowDark;
  final Color sidebarActive;
  final Color sidebarHover;
  final Color buttonShadow;
  final Color inputShadow;
  final Color heroGradientStart;
  final Color heroGradientEnd;
  final Color codeBackground;
  final Color codeBorder;
  final Color codeDefault;

  AnimalIslandThemeSpec get spec => AnimalIslandThemeFactory.specFor(gameStyle);

  bool get isNes => spec.isPixel;
  bool get isWestworld => spec.isSystem;

  double get radiusSm => spec.radiusSm;
  double get radiusBase => spec.radiusBase;
  double get radiusLg => spec.radiusLg;
  double get radiusPill => spec.radiusPill;
  double get borderWidth => spec.borderWidth;
  double get inputBorderWidth => spec.inputBorderWidth;

  Curve get interactionCurve => spec.interactionCurve;
  Duration get interactionDuration => spec.interactionDuration;

  static const AnimalIslandThemeData day = AnimalIslandThemeData(
    gameStyle: AnimalIslandGameStyle.animalIsland,
    mode: AnimalIslandThemeMode.day,
    primary: Color(0xFF19C8B9),
    primaryHover: Color(0xFF3DD4C6),
    primaryActive: Color(0xFF11A89B),
    primarySoft: Color(0xFFE6F9F6),
    textPrimary: Color(0xFF794F27),
    textBody: Color(0xFF725D42),
    textSecondary: Color(0xFF9F927D),
    textMuted: Color(0xFF8A7B66),
    textDisabled: Color(0xFFC4B89E),
    border: Color(0xFF9F927D),
    borderLight: Color(0xFFC4B89E),
    borderHover: Color(0xFFA89878),
    surface: Color(0xFFF8F8F0),
    surfaceRaised: Color(0xFFF7F3DF),
    surfaceSoft: Color(0xFFF0E8D8),
    surfaceMuted: Color(0xFFF0ECE2),
    pageBackground: Color(0xFFF8F8F0),
    pageBackgroundAlt: Color(0xFFF3E8CC),
    success: Color(0xFF6FBA2C),
    successActive: Color(0xFF5A9E1E),
    warning: Color(0xFFF5C31C),
    warningActive: Color(0xFFDBA90E),
    error: Color(0xFFE05A5A),
    errorActive: Color(0xFFC94444),
    focusYellow: Color(0xFFFFCC00),
    focusYellowDark: Color(0xFFE0B800),
    sidebarActive: Color(0xFFB7C6E5),
    sidebarHover: Color(0xFFD6DFF0),
    buttonShadow: Color(0xFFBDAEA0),
    inputShadow: Color(0xFFD4C9B4),
    heroGradientStart: Color(0xFF93D17B),
    heroGradientEnd: Color(0xFF7DC395),
    codeBackground: Color(0xFF2B2118),
    codeBorder: Color(0xFF3D3028),
    codeDefault: Color(0xFFE8D5BC),
  );

  static const AnimalIslandThemeData night = AnimalIslandThemeData(
    gameStyle: AnimalIslandGameStyle.animalIsland,
    mode: AnimalIslandThemeMode.night,
    primary: Color(0xFF61D9CD),
    primaryHover: Color(0xFF7EE6DB),
    primaryActive: Color(0xFF3EB9AE),
    primarySoft: Color(0xFF213E46),
    textPrimary: Color(0xFFF3EBD7),
    textBody: Color(0xFFE7DEC9),
    textSecondary: Color(0xFFC8C0A6),
    textMuted: Color(0xFFACA48E),
    textDisabled: Color(0xFF7D837A),
    border: Color(0xFF809287),
    borderLight: Color(0xFF63786E),
    borderHover: Color(0xFF9DB0A4),
    surface: Color(0xFF26373C),
    surfaceRaised: Color(0xFF31474E),
    surfaceSoft: Color(0xFF395158),
    surfaceMuted: Color(0xFF213036),
    pageBackground: Color(0xFF162329),
    pageBackgroundAlt: Color(0xFF1E3037),
    success: Color(0xFF8BCF58),
    successActive: Color(0xFF5EA43A),
    warning: Color(0xFFF3CF62),
    warningActive: Color(0xFFC9A64A),
    error: Color(0xFFE97E75),
    errorActive: Color(0xFFC95F57),
    focusYellow: Color(0xFFF8D76B),
    focusYellowDark: Color(0xFFD2B24A),
    sidebarActive: Color(0xFF4B5F7D),
    sidebarHover: Color(0xFF39506B),
    buttonShadow: Color(0xFF12242A),
    inputShadow: Color(0xFF12242A),
    heroGradientStart: Color(0xFF193C4B),
    heroGradientEnd: Color(0xFF102934),
    codeBackground: Color(0xFF10181E),
    codeBorder: Color(0xFF24323C),
    codeDefault: Color(0xFFE8D5BC),
  );

  static const AnimalIslandThemeData nesDay = AnimalIslandThemeData(
    gameStyle: AnimalIslandGameStyle.nes8Bit,
    mode: AnimalIslandThemeMode.day,
    primary: Color(0xFF0050F8),
    primaryHover: Color(0xFF3C78FF),
    primaryActive: Color(0xFF002E8A),
    primarySoft: Color(0xFFDCE8FF),
    textPrimary: Color(0xFF101018),
    textBody: Color(0xFF1F2430),
    textSecondary: Color(0xFF4B5563),
    textMuted: Color(0xFF697386),
    textDisabled: Color(0xFF9CA3AF),
    border: Color(0xFF101018),
    borderLight: Color(0xFF2B2F3A),
    borderHover: Color(0xFF0050F8),
    surface: Color(0xFFF8F8F8),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceSoft: Color(0xFFE8ECF8),
    surfaceMuted: Color(0xFFD8DCE8),
    pageBackground: Color(0xFFD6E6FF),
    pageBackgroundAlt: Color(0xFFB8D0F8),
    success: Color(0xFF00A800),
    successActive: Color(0xFF006800),
    warning: Color(0xFFF8D800),
    warningActive: Color(0xFFC88000),
    error: Color(0xFFE00000),
    errorActive: Color(0xFF8A0000),
    focusYellow: Color(0xFFFFF000),
    focusYellowDark: Color(0xFFC88000),
    sidebarActive: Color(0xFF0050F8),
    sidebarHover: Color(0xFFB8D0F8),
    buttonShadow: Color(0xFF101018),
    inputShadow: Color(0xFF101018),
    heroGradientStart: Color(0xFF5C94FC),
    heroGradientEnd: Color(0xFFB8D0F8),
    codeBackground: Color(0xFF101018),
    codeBorder: Color(0xFFFFFFFF),
    codeDefault: Color(0xFFFFFFFF),
  );

  static const AnimalIslandThemeData nesNight = AnimalIslandThemeData(
    gameStyle: AnimalIslandGameStyle.nes8Bit,
    mode: AnimalIslandThemeMode.night,
    primary: Color(0xFF3CBCFC),
    primaryHover: Color(0xFF8CE8FF),
    primaryActive: Color(0xFF0050F8),
    primarySoft: Color(0xFF102C54),
    textPrimary: Color(0xFFFFFFFF),
    textBody: Color(0xFFF8F8F8),
    textSecondary: Color(0xFFD8DCE8),
    textMuted: Color(0xFFB8C0D0),
    textDisabled: Color(0xFF707890),
    border: Color(0xFFFFFFFF),
    borderLight: Color(0xFFD8DCE8),
    borderHover: Color(0xFF3CBCFC),
    surface: Color(0xFF181828),
    surfaceRaised: Color(0xFF24243C),
    surfaceSoft: Color(0xFF303850),
    surfaceMuted: Color(0xFF101018),
    pageBackground: Color(0xFF080814),
    pageBackgroundAlt: Color(0xFF101838),
    success: Color(0xFF58D854),
    successActive: Color(0xFF00A800),
    warning: Color(0xFFF8D800),
    warningActive: Color(0xFFC88000),
    error: Color(0xFFFF3838),
    errorActive: Color(0xFFE00000),
    focusYellow: Color(0xFFFFF000),
    focusYellowDark: Color(0xFFC88000),
    sidebarActive: Color(0xFF0050F8),
    sidebarHover: Color(0xFF303850),
    buttonShadow: Color(0xFF000000),
    inputShadow: Color(0xFF000000),
    heroGradientStart: Color(0xFF101838),
    heroGradientEnd: Color(0xFF080814),
    codeBackground: Color(0xFF000000),
    codeBorder: Color(0xFFFFFFFF),
    codeDefault: Color(0xFFFFFFFF),
  );

  static const AnimalIslandThemeData westworldDay = AnimalIslandThemeData(
    gameStyle: AnimalIslandGameStyle.westworld,
    mode: AnimalIslandThemeMode.day,
    primary: Color(0xFF151515),
    primaryHover: Color(0xFF2C2C2C),
    primaryActive: Color(0xFF000000),
    primarySoft: Color(0xFFE7E7E4),
    textPrimary: Color(0xFF0B0B0B),
    textBody: Color(0xFF202020),
    textSecondary: Color(0xFF5A5A5A),
    textMuted: Color(0xFF7A7A76),
    textDisabled: Color(0xFFB7B7B0),
    border: Color(0xFF202020),
    borderLight: Color(0xFFC7C7C0),
    borderHover: Color(0xFF5A5A5A),
    surface: Color(0xFFEDEDEA),
    surfaceRaised: Color(0xFFF7F7F4),
    surfaceSoft: Color(0xFFE2E2DE),
    surfaceMuted: Color(0xFFD4D4CD),
    pageBackground: Color(0xFFE7E7E4),
    pageBackgroundAlt: Color(0xFFF1F1EF),
    success: Color(0xFF1F7A5B),
    successActive: Color(0xFF0E4E3A),
    warning: Color(0xFFC29A43),
    warningActive: Color(0xFF8E6A1C),
    error: Color(0xFFB2423A),
    errorActive: Color(0xFF7C211D),
    focusYellow: Color(0xFFB89C58),
    focusYellowDark: Color(0xFF6B5830),
    sidebarActive: Color(0xFF111111),
    sidebarHover: Color(0xFFE0E0DB),
    buttonShadow: Color(0x00000000),
    inputShadow: Color(0x00000000),
    heroGradientStart: Color(0xFFF4F4F1),
    heroGradientEnd: Color(0xFFE2E2DD),
    codeBackground: Color(0xFF111111),
    codeBorder: Color(0xFF3F3F3F),
    codeDefault: Color(0xFFE7E7E4),
  );

  static const AnimalIslandThemeData westworldNight = AnimalIslandThemeData(
    gameStyle: AnimalIslandGameStyle.westworld,
    mode: AnimalIslandThemeMode.night,
    primary: Color(0xFFECECE8),
    primaryHover: Color(0xFFFFFFFF),
    primaryActive: Color(0xFFBFBFB8),
    primarySoft: Color(0xFF1F1F1D),
    textPrimary: Color(0xFFF4F4F0),
    textBody: Color(0xFFE2E2DC),
    textSecondary: Color(0xFFB8B8AE),
    textMuted: Color(0xFF8B8B82),
    textDisabled: Color(0xFF55554F),
    border: Color(0xFFECECE8),
    borderLight: Color(0xFF4A4A45),
    borderHover: Color(0xFFB8B8AE),
    surface: Color(0xFF10100F),
    surfaceRaised: Color(0xFF161614),
    surfaceSoft: Color(0xFF20201D),
    surfaceMuted: Color(0xFF080807),
    pageBackground: Color(0xFF060606),
    pageBackgroundAlt: Color(0xFF121210),
    success: Color(0xFF78C6A2),
    successActive: Color(0xFF3C8C67),
    warning: Color(0xFFD1B16B),
    warningActive: Color(0xFF9A7833),
    error: Color(0xFFE17168),
    errorActive: Color(0xFFAA3932),
    focusYellow: Color(0xFFD1B16B),
    focusYellowDark: Color(0xFF826323),
    sidebarActive: Color(0xFFECECE8),
    sidebarHover: Color(0xFF242420),
    buttonShadow: Color(0x00000000),
    inputShadow: Color(0x00000000),
    heroGradientStart: Color(0xFF171716),
    heroGradientEnd: Color(0xFF060606),
    codeBackground: Color(0xFF050505),
    codeBorder: Color(0xFF4A4A45),
    codeDefault: Color(0xFFECECE8),
  );

  Map<String, Color> get cardColors => {
    if (isWestworld) ...{
      'default': surfaceRaised,
      'app-pink': const Color(0xFF7B5B61),
      'purple': const Color(0xFF625A70),
      'app-blue': const Color(0xFF4F6470),
      'app-yellow': const Color(0xFFD1B16B),
      'app-orange': const Color(0xFFA66A43),
      'app-teal': const Color(0xFF4B746D),
      'app-green': const Color(0xFF4D765F),
      'app-red': const Color(0xFF9B4A44),
      'lime-green': const Color(0xFF899268),
      'yellow-green': const Color(0xFFAAA06C),
      'brown': const Color(0xFF6F6251),
      'warm-peach-pink': const Color(0xFF9A6D60),
    } else if (isNes) ...{
      'default': surfaceRaised,
      'app-pink': const Color(0xFFFF77A8),
      'purple': const Color(0xFF8854F8),
      'app-blue': const Color(0xFF0050F8),
      'app-yellow': const Color(0xFFF8D800),
      'app-orange': const Color(0xFFF87800),
      'app-teal': const Color(0xFF00A8A8),
      'app-green': const Color(0xFF00A800),
      'app-red': const Color(0xFFE00000),
      'lime-green': const Color(0xFF58D854),
      'yellow-green': const Color(0xFFA8E000),
      'brown': const Color(0xFF887000),
      'warm-peach-pink': const Color(0xFFF8A878),
    } else ...{
      'default': surfaceRaised,
      'app-pink': const Color(0xFFF8A6B2),
      'purple': const Color(0xFFB77DEE),
      'app-blue': const Color(0xFF889DF0),
      'app-yellow': const Color(0xFFF7CD67),
      'app-orange': const Color(0xFFE59266),
      'app-teal': const Color(0xFF82D5BB),
      'app-green': const Color(0xFF8AC68A),
      'app-red': const Color(0xFFFC736D),
      'lime-green': const Color(0xFFD1DA49),
      'yellow-green': const Color(0xFFECDF52),
      'brown': const Color(0xFF9A835A),
      'warm-peach-pink': const Color(0xFFE18C6F),
    },
  };

  Color cardForeground(String key) {
    switch (key) {
      case 'default':
        return textBody;
      case 'app-yellow':
      case 'yellow-green':
        return isWestworld ? const Color(0xFF10100F) : textBody;
      case 'lime-green':
        return isWestworld ? const Color(0xFF10100F) : const Color(0xFF3D5A1A);
      default:
        return isWestworld ? Colors.white : Colors.white;
    }
  }

  Color panelLineColor({bool hovered = false, bool emphasized = false}) {
    if (!isWestworld) {
      return emphasized
          ? border
          : borderLight.withValues(alpha: hovered ? 0.9 : 0.7);
    }

    final base = emphasized ? border : borderLight;
    return base.withValues(
      alpha: emphasized
          ? 0.86
          : hovered
          ? 0.62
          : 0.38,
    );
  }

  BoxDecoration westworldPanelDecoration({
    Color? color,
    Color? lineColor,
    bool hovered = false,
    bool emphasized = false,
  }) {
    final resolvedLine =
        lineColor ?? panelLineColor(hovered: hovered, emphasized: emphasized);
    return BoxDecoration(
      color: (color ?? surfaceRaised).withValues(
        alpha: mode == AnimalIslandThemeMode.day ? 0.72 : 0.82,
      ),
      border: Border.all(color: resolvedLine, width: emphasized ? 1.2 : 1),
      boxShadow: [
        BoxShadow(
          color: (mode == AnimalIslandThemeMode.day ? Colors.white : primary)
              .withValues(alpha: hovered ? 0.18 : 0.06),
          blurRadius: hovered ? 18 : 10,
          spreadRadius: -8,
        ),
      ],
    );
  }

  LinearGradient get westworldBackgroundGradient {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [heroGradientStart, pageBackground, heroGradientEnd],
    );
  }

  @Deprecated('Use cardForeground. Kept only for source compatibility.')
  Color legacyCardForeground(String key) {
    switch (key) {
      case 'default':
      case 'app-yellow':
      case 'yellow-green':
        return textBody;
      case 'lime-green':
        return const Color(0xFF3D5A1A);
      default:
        return Colors.white;
    }
  }

  @override
  AnimalIslandThemeData copyWith({
    AnimalIslandGameStyle? gameStyle,
    AnimalIslandThemeMode? mode,
    Color? primary,
    Color? primaryHover,
    Color? primaryActive,
    Color? primarySoft,
    Color? textPrimary,
    Color? textBody,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,
    Color? border,
    Color? borderLight,
    Color? borderHover,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceSoft,
    Color? surfaceMuted,
    Color? pageBackground,
    Color? pageBackgroundAlt,
    Color? success,
    Color? successActive,
    Color? warning,
    Color? warningActive,
    Color? error,
    Color? errorActive,
    Color? focusYellow,
    Color? focusYellowDark,
    Color? sidebarActive,
    Color? sidebarHover,
    Color? buttonShadow,
    Color? inputShadow,
    Color? heroGradientStart,
    Color? heroGradientEnd,
    Color? codeBackground,
    Color? codeBorder,
    Color? codeDefault,
  }) {
    return AnimalIslandThemeData(
      gameStyle: gameStyle ?? this.gameStyle,
      mode: mode ?? this.mode,
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryActive: primaryActive ?? this.primaryActive,
      primarySoft: primarySoft ?? this.primarySoft,
      textPrimary: textPrimary ?? this.textPrimary,
      textBody: textBody ?? this.textBody,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      borderHover: borderHover ?? this.borderHover,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSoft: surfaceSoft ?? this.surfaceSoft,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      pageBackground: pageBackground ?? this.pageBackground,
      pageBackgroundAlt: pageBackgroundAlt ?? this.pageBackgroundAlt,
      success: success ?? this.success,
      successActive: successActive ?? this.successActive,
      warning: warning ?? this.warning,
      warningActive: warningActive ?? this.warningActive,
      error: error ?? this.error,
      errorActive: errorActive ?? this.errorActive,
      focusYellow: focusYellow ?? this.focusYellow,
      focusYellowDark: focusYellowDark ?? this.focusYellowDark,
      sidebarActive: sidebarActive ?? this.sidebarActive,
      sidebarHover: sidebarHover ?? this.sidebarHover,
      buttonShadow: buttonShadow ?? this.buttonShadow,
      inputShadow: inputShadow ?? this.inputShadow,
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
      codeBackground: codeBackground ?? this.codeBackground,
      codeBorder: codeBorder ?? this.codeBorder,
      codeDefault: codeDefault ?? this.codeDefault,
    );
  }

  @override
  ThemeExtension<AnimalIslandThemeData> lerp(
    covariant ThemeExtension<AnimalIslandThemeData>? other,
    double t,
  ) {
    if (other is! AnimalIslandThemeData) {
      return this;
    }

    return AnimalIslandThemeData(
      gameStyle: t < 0.5 ? gameStyle : other.gameStyle,
      mode: t < 0.5 ? mode : other.mode,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primaryActive: Color.lerp(primaryActive, other.primaryActive, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textBody: Color.lerp(textBody, other.textBody, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      borderHover: Color.lerp(borderHover, other.borderHover, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceSoft: Color.lerp(surfaceSoft, other.surfaceSoft, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      pageBackgroundAlt: Color.lerp(
        pageBackgroundAlt,
        other.pageBackgroundAlt,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      successActive: Color.lerp(successActive, other.successActive, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningActive: Color.lerp(warningActive, other.warningActive, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorActive: Color.lerp(errorActive, other.errorActive, t)!,
      focusYellow: Color.lerp(focusYellow, other.focusYellow, t)!,
      focusYellowDark: Color.lerp(focusYellowDark, other.focusYellowDark, t)!,
      sidebarActive: Color.lerp(sidebarActive, other.sidebarActive, t)!,
      sidebarHover: Color.lerp(sidebarHover, other.sidebarHover, t)!,
      buttonShadow: Color.lerp(buttonShadow, other.buttonShadow, t)!,
      inputShadow: Color.lerp(inputShadow, other.inputShadow, t)!,
      heroGradientStart: Color.lerp(
        heroGradientStart,
        other.heroGradientStart,
        t,
      )!,
      heroGradientEnd: Color.lerp(heroGradientEnd, other.heroGradientEnd, t)!,
      codeBackground: Color.lerp(codeBackground, other.codeBackground, t)!,
      codeBorder: Color.lerp(codeBorder, other.codeBorder, t)!,
      codeDefault: Color.lerp(codeDefault, other.codeDefault, t)!,
    );
  }
}

ThemeData buildAnimalIslandTheme({
  AnimalIslandThemeMode mode = AnimalIslandThemeMode.day,
  AnimalIslandGameStyle gameStyle = AnimalIslandGameStyle.animalIsland,
}) {
  final palette = AnimalIslandThemeFactory.resolve(
    mode: mode,
    gameStyle: gameStyle,
  );
  final spec = palette.spec;

  final base = ThemeData(
    useMaterial3: true,
    brightness: mode == AnimalIslandThemeMode.day
        ? Brightness.light
        : Brightness.dark,
    scaffoldBackgroundColor: palette.pageBackground,
    colorScheme: ColorScheme(
      brightness: mode == AnimalIslandThemeMode.day
          ? Brightness.light
          : Brightness.dark,
      primary: palette.primary,
      onPrimary: palette.textPrimary,
      secondary: palette.warning,
      onSecondary: palette.textPrimary,
      error: palette.error,
      onError: Colors.white,
      surface: palette.surface,
      onSurface: palette.textBody,
      surfaceContainerHighest: palette.surfaceSoft,
      onSurfaceVariant: palette.textSecondary,
      outline: palette.border,
      outlineVariant: palette.borderLight,
      shadow: palette.buttonShadow,
      scrim: Colors.black54,
      inverseSurface: palette.pageBackgroundAlt,
      onInverseSurface: palette.textPrimary,
      inversePrimary: palette.primaryHover,
      tertiary: palette.success,
      onTertiary: Colors.white,
    ),
  );

  final baseTextTheme = switch (gameStyle) {
    AnimalIslandGameStyle.nes8Bit => GoogleFonts.pressStart2pTextTheme(
      base.textTheme,
    ),
    AnimalIslandGameStyle.westworld => GoogleFonts.barlowCondensedTextTheme(
      base.textTheme,
    ),
    AnimalIslandGameStyle.animalIsland => GoogleFonts.nunitoTextTheme(
      base.textTheme,
    ),
  };
  final textFont = switch (gameStyle) {
    AnimalIslandGameStyle.nes8Bit => GoogleFonts.pressStart2p,
    AnimalIslandGameStyle.westworld => GoogleFonts.barlowCondensed,
    AnimalIslandGameStyle.animalIsland => GoogleFonts.nunito,
  };
  final bodyHeight = spec.bodyHeight;
  final labelSpacing = spec.labelSpacing;
  final headingWeight = spec.isSystem ? FontWeight.w500 : FontWeight.w800;
  final titleWeight = spec.isSystem ? FontWeight.w500 : FontWeight.w700;
  final bodyWeight = spec.isSystem ? FontWeight.w400 : FontWeight.w500;

  final rounded = baseTextTheme.copyWith(
    displayLarge: textFont(
      fontSize: AnimalIslandTokens.fontDisplay,
      fontWeight: headingWeight,
      letterSpacing: spec.isSystem ? 1.4 : 0,
      color: palette.textPrimary,
    ),
    displayMedium: textFont(
      fontSize: AnimalIslandTokens.fontDisplaySm,
      fontWeight: headingWeight,
      letterSpacing: spec.isSystem ? 1.2 : 0,
      color: palette.textPrimary,
    ),
    headlineLarge: textFont(
      fontSize: AnimalIslandTokens.fontHeadline,
      fontWeight: titleWeight,
      letterSpacing: spec.isSystem ? 1.1 : 0,
      color: palette.textPrimary,
    ),
    headlineMedium: textFont(
      fontSize: AnimalIslandTokens.fontHeadlineSm,
      fontWeight: titleWeight,
      letterSpacing: spec.isSystem ? 1.0 : 0,
      color: palette.textPrimary,
    ),
    titleLarge: textFont(
      fontSize: AnimalIslandTokens.fontTitle,
      fontWeight: titleWeight,
      letterSpacing: spec.isSystem ? 0.9 : 0,
      color: palette.textPrimary,
    ),
    titleMedium: textFont(
      fontSize: AnimalIslandTokens.fontTitleSm,
      fontWeight: titleWeight,
      letterSpacing: spec.isSystem ? 0.7 : 0,
      color: palette.textBody,
    ),
    bodyLarge: textFont(
      fontSize: AnimalIslandTokens.fontBodyLg,
      fontWeight: bodyWeight,
      height: bodyHeight,
      color: palette.textBody,
    ),
    bodyMedium: textFont(
      fontSize: AnimalIslandTokens.fontBody,
      fontWeight: bodyWeight,
      height: bodyHeight,
      color: palette.textBody,
    ),
    bodySmall: textFont(
      fontSize: AnimalIslandTokens.fontBodySm,
      fontWeight: bodyWeight,
      height: spec.bodySmallHeight,
      color: palette.textSecondary,
    ),
    labelLarge: textFont(
      fontSize: AnimalIslandTokens.fontLabel,
      fontWeight: FontWeight.w700,
      letterSpacing: labelSpacing,
      color: palette.textPrimary,
    ),
    labelMedium: textFont(
      fontSize: AnimalIslandTokens.fontCaption,
      fontWeight: FontWeight.w700,
      color: palette.textSecondary,
    ),
  );

  return base.copyWith(
    textTheme: rounded,
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    extensions: <ThemeExtension<dynamic>>[palette],
  );
}

extension AnimalIslandThemeContext on BuildContext {
  AnimalIslandThemeData get animalIslandTheme =>
      Theme.of(this).extension<AnimalIslandThemeData>() ??
      AnimalIslandThemeData.day;
}
