import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animal_island_tokens.dart';

enum AnimalIslandThemeMode { day, night }

enum AnimalIslandGameStyle { animalIsland, nes8Bit }

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

  bool get isNes => gameStyle == AnimalIslandGameStyle.nes8Bit;

  double get radiusSm =>
      isNes ? AnimalIslandTokens.pixelRadiusSm : AnimalIslandTokens.radiusSm;
  double get radiusBase => isNes
      ? AnimalIslandTokens.pixelRadiusBase
      : AnimalIslandTokens.radiusBase;
  double get radiusLg =>
      isNes ? AnimalIslandTokens.pixelRadiusLg : AnimalIslandTokens.radiusLg;
  double get radiusPill => isNes
      ? AnimalIslandTokens.pixelRadiusBase
      : AnimalIslandTokens.radiusPill;
  double get borderWidth => isNes
      ? AnimalIslandTokens.pixelBorderWidth
      : AnimalIslandTokens.borderWidth;
  double get inputBorderWidth => isNes
      ? AnimalIslandTokens.pixelBorderWidth
      : AnimalIslandTokens.inputBorderWidth;

  Curve get interactionCurve =>
      isNes ? AnimalIslandTokens.pixelCurve : AnimalIslandTokens.motionCurve;
  Duration get interactionDuration =>
      isNes ? AnimalIslandTokens.pixelStep : AnimalIslandTokens.fast;

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

  Map<String, Color> get cardColors => {
    if (isNes) ...{
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
  final palette = switch ((gameStyle, mode)) {
    (AnimalIslandGameStyle.nes8Bit, AnimalIslandThemeMode.day) =>
      AnimalIslandThemeData.nesDay,
    (AnimalIslandGameStyle.nes8Bit, AnimalIslandThemeMode.night) =>
      AnimalIslandThemeData.nesNight,
    (_, AnimalIslandThemeMode.day) => AnimalIslandThemeData.day,
    (_, AnimalIslandThemeMode.night) => AnimalIslandThemeData.night,
  };

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

  final baseTextTheme = gameStyle == AnimalIslandGameStyle.nes8Bit
      ? GoogleFonts.pressStart2pTextTheme(base.textTheme)
      : GoogleFonts.nunitoTextTheme(base.textTheme);
  final textFont = gameStyle == AnimalIslandGameStyle.nes8Bit
      ? GoogleFonts.pressStart2p
      : GoogleFonts.nunito;
  final bodyHeight = gameStyle == AnimalIslandGameStyle.nes8Bit ? 1.75 : 1.55;
  final labelSpacing = gameStyle == AnimalIslandGameStyle.nes8Bit ? 0.0 : 0.18;

  final rounded = baseTextTheme.copyWith(
    displayLarge: textFont(
      fontSize: AnimalIslandTokens.fontDisplay,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
    ),
    displayMedium: textFont(
      fontSize: AnimalIslandTokens.fontDisplaySm,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
    ),
    headlineLarge: textFont(
      fontSize: AnimalIslandTokens.fontHeadline,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    ),
    headlineMedium: textFont(
      fontSize: AnimalIslandTokens.fontHeadlineSm,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    ),
    titleLarge: textFont(
      fontSize: AnimalIslandTokens.fontTitle,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    ),
    titleMedium: textFont(
      fontSize: AnimalIslandTokens.fontTitleSm,
      fontWeight: FontWeight.w700,
      color: palette.textBody,
    ),
    bodyLarge: textFont(
      fontSize: AnimalIslandTokens.fontBodyLg,
      fontWeight: FontWeight.w500,
      height: bodyHeight,
      color: palette.textBody,
    ),
    bodyMedium: textFont(
      fontSize: AnimalIslandTokens.fontBody,
      fontWeight: FontWeight.w500,
      height: bodyHeight,
      color: palette.textBody,
    ),
    bodySmall: textFont(
      fontSize: AnimalIslandTokens.fontBodySm,
      fontWeight: FontWeight.w500,
      height: gameStyle == AnimalIslandGameStyle.nes8Bit ? 1.65 : 1.45,
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
