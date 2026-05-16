import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animal_island_tokens.dart';

enum AnimalIslandThemeMode { day, night }

@immutable
class AnimalIslandThemeData extends ThemeExtension<AnimalIslandThemeData> {
  const AnimalIslandThemeData({
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

  static const AnimalIslandThemeData day = AnimalIslandThemeData(
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

  Map<String, Color> get cardColors => {
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
}) {
  final palette = mode == AnimalIslandThemeMode.day
      ? AnimalIslandThemeData.day
      : AnimalIslandThemeData.night;

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

  final rounded = GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
    displayLarge: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontDisplay,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
    ),
    displayMedium: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontDisplaySm,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
    ),
    headlineLarge: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontHeadline,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontHeadlineSm,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    ),
    titleLarge: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontTitle,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontTitleSm,
      fontWeight: FontWeight.w700,
      color: palette.textBody,
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontBodyLg,
      fontWeight: FontWeight.w500,
      height: 1.55,
      color: palette.textBody,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontBody,
      fontWeight: FontWeight.w500,
      height: 1.55,
      color: palette.textBody,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontBodySm,
      fontWeight: FontWeight.w500,
      height: 1.45,
      color: palette.textSecondary,
    ),
    labelLarge: GoogleFonts.nunito(
      fontSize: AnimalIslandTokens.fontLabel,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.18,
      color: palette.textPrimary,
    ),
    labelMedium: GoogleFonts.nunito(
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
