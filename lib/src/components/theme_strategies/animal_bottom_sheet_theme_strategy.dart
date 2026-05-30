import 'package:flutter/material.dart';

import '../../theme/animal_island_theme.dart';
import '../../theme/animal_island_tokens.dart';
import '../../utils/animal_island_assets.dart';
import 'animal_bottom_sheet_shared.dart';

abstract final class AnimalBottomSheetThemeStrategy {
  const AnimalBottomSheetThemeStrategy();

  static AnimalBottomSheetThemeStrategy of(AnimalIslandThemeData theme) {
    return forGameStyle(theme.gameStyle);
  }

  static AnimalBottomSheetThemeStrategy forGameStyle(
    AnimalIslandGameStyle gameStyle,
  ) {
    return switch (gameStyle) {
      AnimalIslandGameStyle.nes8Bit =>
        const _NesAnimalBottomSheetThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalBottomSheetThemeStrategy(),
      AnimalIslandGameStyle.guofengDoodle =>
        const _GuofengAnimalBottomSheetThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandBottomSheetThemeStrategy(),
    };
  }

  BorderRadius? clipRadius(AnimalIslandThemeData theme);

  Color outerColor(AnimalIslandThemeData theme);

  double elevation(AnimalIslandThemeData theme);

  double framePadding(AnimalIslandThemeData theme);

  EdgeInsets contentPadding(AnimalIslandThemeData theme);

  CustomClipper<Path>? panelClipper(AnimalIslandThemeData theme);

  BoxDecoration panelDecoration(AnimalIslandThemeData theme);

  bool bodyScrolls(AnimalIslandThemeData theme);

  double maxHeightRatio(AnimalIslandThemeData theme);

  TextStyle titleStyle(BuildContext context, AnimalIslandThemeData theme);

  TextStyle bodyStyle(BuildContext context, AnimalIslandThemeData theme);

  Widget buildHandle(AnimalIslandThemeData theme);

  Widget buildCloseButton(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required VoidCallback? onTap,
  });
}

final class _AnimalIslandBottomSheetThemeStrategy
    extends AnimalBottomSheetThemeStrategy {
  const _AnimalIslandBottomSheetThemeStrategy();

  @override
  BorderRadius? clipRadius(AnimalIslandThemeData theme) => null;

  @override
  Color outerColor(AnimalIslandThemeData theme) => theme.borderLight;

  @override
  double elevation(AnimalIslandThemeData theme) => 12;

  @override
  double framePadding(AnimalIslandThemeData theme) => 2.5;

  @override
  EdgeInsets contentPadding(AnimalIslandThemeData theme) =>
      const EdgeInsets.fromLTRB(22, 16, 22, 18);

  @override
  CustomClipper<Path>? panelClipper(AnimalIslandThemeData theme) =>
      const AnimalBottomSheetClipper();

  @override
  BoxDecoration panelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[theme.surfaceRaised, theme.surface],
      ),
      border: Border.all(
        color: theme.border.withValues(
          alpha: theme.mode == AnimalIslandThemeMode.day ? 0.5 : 0.38,
        ),
        width: 1.1,
      ),
    );
  }

  @override
  TextStyle titleStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: theme.textPrimary,
      fontSize: AnimalIslandTokens.fontTitle,
    );
  }

  @override
  TextStyle bodyStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: AnimalIslandTokens.fontBodyLg,
      color: theme.textBody,
      height: 1.55,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  bool bodyScrolls(AnimalIslandThemeData theme) => true;

  @override
  double maxHeightRatio(AnimalIslandThemeData theme) => 0.68;

  @override
  Widget buildHandle(AnimalIslandThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 8,
          decoration: BoxDecoration(
            color: theme.surfaceSoft,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(10),
            ),
            border: Border.all(
              color: theme.border.withValues(alpha: 0.36),
              width: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Image.asset(
          AnimalIslandAssets.iconLeaf,
          package: AnimalIslandAssets.package,
          width: 16,
          height: 16,
          opacity: const AlwaysStoppedAnimation<double>(0.84),
        ),
      ],
    );
  }

  @override
  Widget buildCloseButton(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required VoidCallback? onTap,
  }) {
    return AnimalBottomSheetCloseButton(
      theme: theme,
      onTap: onTap,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(14),
        bottomLeft: Radius.circular(14),
        bottomRight: Radius.circular(18),
      ),
      showLeaf: true,
    );
  }
}

final class _GuofengAnimalBottomSheetThemeStrategy
    extends AnimalBottomSheetThemeStrategy {
  const _GuofengAnimalBottomSheetThemeStrategy();

  @override
  BorderRadius? clipRadius(AnimalIslandThemeData theme) =>
      BorderRadius.circular(theme.radiusLg);

  @override
  Color outerColor(AnimalIslandThemeData theme) => Colors.transparent;

  @override
  double elevation(AnimalIslandThemeData theme) => 0;

  @override
  double framePadding(AnimalIslandThemeData theme) => 0;

  @override
  EdgeInsets contentPadding(AnimalIslandThemeData theme) =>
      const EdgeInsets.fromLTRB(24, 18, 24, 22);

  @override
  CustomClipper<Path>? panelClipper(AnimalIslandThemeData theme) => null;

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
  bool bodyScrolls(AnimalIslandThemeData theme) => true;

  @override
  double maxHeightRatio(AnimalIslandThemeData theme) => 0.76;

  @override
  TextStyle titleStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: theme.textPrimary,
      fontSize: AnimalIslandTokens.fontTitle,
      fontWeight: FontWeight.w700,
    );
  }

  @override
  TextStyle bodyStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: AnimalIslandTokens.fontBodyLg,
      color: theme.textBody,
      height: 1.5,
      fontWeight: FontWeight.w500,
    );
  }

  @override
  Widget buildHandle(AnimalIslandThemeData theme) {
    return Container(
      width: 52,
      height: 7,
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(theme.radiusPill),
        border: Border.all(color: theme.border, width: 1.4),
      ),
    );
  }

  @override
  Widget buildCloseButton(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required VoidCallback? onTap,
  }) {
    return AnimalBottomSheetCloseButton(
      theme: theme,
      onTap: onTap,
      borderRadius: BorderRadius.circular(theme.radiusSm),
      showLeaf: false,
    );
  }
}

final class _NesAnimalBottomSheetThemeStrategy
    extends AnimalBottomSheetThemeStrategy {
  const _NesAnimalBottomSheetThemeStrategy();

  @override
  BorderRadius? clipRadius(AnimalIslandThemeData theme) => BorderRadius.zero;

  @override
  Color outerColor(AnimalIslandThemeData theme) => Colors.transparent;

  @override
  double elevation(AnimalIslandThemeData theme) => 0;

  @override
  double framePadding(AnimalIslandThemeData theme) => 0;

  @override
  EdgeInsets contentPadding(AnimalIslandThemeData theme) =>
      const EdgeInsets.fromLTRB(18, 14, 18, 18);

  @override
  CustomClipper<Path>? panelClipper(AnimalIslandThemeData theme) => null;

  @override
  BoxDecoration panelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(color: theme.surfaceRaised);
  }

  @override
  TextStyle titleStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: theme.textPrimary,
      fontSize: AnimalIslandTokens.fontBody,
    );
  }

  @override
  TextStyle bodyStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: AnimalIslandTokens.fontBodySm,
      color: theme.textBody,
      height: 1.8,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  @override
  bool bodyScrolls(AnimalIslandThemeData theme) => true;

  @override
  double maxHeightRatio(AnimalIslandThemeData theme) => 0.82;

  @override
  Widget buildHandle(AnimalIslandThemeData theme) {
    return AnimalBottomSheetHandle(theme: theme);
  }

  @override
  Widget buildCloseButton(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required VoidCallback? onTap,
  }) {
    return AnimalBottomSheetCloseButton(
      theme: theme,
      onTap: onTap,
      borderRadius: BorderRadius.circular(theme.radiusSm),
      showLeaf: true,
    );
  }
}

final class _WestworldAnimalBottomSheetThemeStrategy
    extends AnimalBottomSheetThemeStrategy {
  const _WestworldAnimalBottomSheetThemeStrategy();

  @override
  BorderRadius? clipRadius(AnimalIslandThemeData theme) =>
      BorderRadius.circular(theme.radiusBase);

  @override
  Color outerColor(AnimalIslandThemeData theme) =>
      theme.panelLineColor(emphasized: true);

  @override
  double elevation(AnimalIslandThemeData theme) => 0;

  @override
  double framePadding(AnimalIslandThemeData theme) => 1;

  @override
  EdgeInsets contentPadding(AnimalIslandThemeData theme) =>
      const EdgeInsets.fromLTRB(22, 16, 22, 20);

  @override
  CustomClipper<Path>? panelClipper(AnimalIslandThemeData theme) => null;

  @override
  BoxDecoration panelDecoration(AnimalIslandThemeData theme) {
    return theme.westworldPanelDecoration(emphasized: true);
  }

  @override
  TextStyle titleStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      color: theme.textPrimary,
      fontSize: AnimalIslandTokens.fontHeadlineSm,
      letterSpacing: 1.2,
    );
  }

  @override
  TextStyle bodyStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: AnimalIslandTokens.fontBody,
      color: theme.textBody,
      height: 1.36,
      fontWeight: FontWeight.w400,
    );
  }

  @override
  bool bodyScrolls(AnimalIslandThemeData theme) => true;

  @override
  double maxHeightRatio(AnimalIslandThemeData theme) => 0.82;

  @override
  Widget buildHandle(AnimalIslandThemeData theme) {
    return Container(
      width: 84,
      height: 10,
      alignment: Alignment.center,
      child: CustomPaint(
        size: const Size(84, 10),
        painter: WestworldHandlePainter(
          color: theme.panelLineColor(emphasized: true),
        ),
      ),
    );
  }

  @override
  Widget buildCloseButton(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required VoidCallback? onTap,
  }) {
    return AnimalBottomSheetCloseButton(
      theme: theme,
      onTap: onTap,
      borderRadius: BorderRadius.circular(theme.radiusSm),
      showLeaf: false,
    );
  }
}
