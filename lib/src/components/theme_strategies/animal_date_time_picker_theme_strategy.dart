import 'package:flutter/material.dart';

import '../../theme/animal_island_theme.dart';
import '../../theme/animal_island_tokens.dart';

enum AnimalDateTimePickerPanelKind { calendar, time }

abstract final class AnimalDateTimePickerThemeStrategy {
  const AnimalDateTimePickerThemeStrategy();

  static AnimalDateTimePickerThemeStrategy of(AnimalIslandThemeData theme) {
    return forGameStyle(theme.gameStyle);
  }

  static AnimalDateTimePickerThemeStrategy forGameStyle(
    AnimalIslandGameStyle gameStyle,
  ) {
    return switch (gameStyle) {
      AnimalIslandGameStyle.nes8Bit =>
        const _NesAnimalDateTimePickerThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalDateTimePickerThemeStrategy(),
      AnimalIslandGameStyle.guofengDoodle =>
        const _GuofengAnimalDateTimePickerThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandDateTimePickerThemeStrategy(),
    };
  }

  EdgeInsets rootPadding({required bool compact});

  BoxDecoration rootDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  });

  double sectionGap();

  EdgeInsets panelPadding(AnimalDateTimePickerPanelKind kind);

  BoxDecoration pickerPanelDecoration(AnimalIslandThemeData theme);

  Widget? buildSystemHeader(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required String label,
    required String value,
  });

  double calendarHeaderGap();

  double weekdayGap();

  double gridMainAxisSpacing();

  double gridCrossAxisSpacing();

  double gridChildAspectRatio();

  double timePanelHeight({required bool compact});

  TextStyle monthTitleStyle(BuildContext context, AnimalIslandThemeData theme);

  TextStyle weekdayStyle(BuildContext context, AnimalIslandThemeData theme);

  BoxDecoration calendarCellDecoration(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool today,
  });

  String calendarCellText(int day);

  TextStyle calendarCellTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool disabled,
  });

  TextStyle timeSeparatorStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  });

  BoxDecoration wheelDecoration(AnimalIslandThemeData theme);

  BoxDecoration wheelSelectionDecoration(AnimalIslandThemeData theme);

  BoxDecoration wheelFadeDecoration(AnimalIslandThemeData theme);

  TextStyle wheelTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
  });
}

final class _AnimalIslandDateTimePickerThemeStrategy
    extends AnimalDateTimePickerThemeStrategy {
  const _AnimalIslandDateTimePickerThemeStrategy();

  @override
  EdgeInsets rootPadding({required bool compact}) =>
      EdgeInsets.all(compact ? 14 : 18);

  @override
  BoxDecoration rootDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      borderRadius: BorderRadius.circular(compact ? 26 : 30),
      border: Border.all(color: theme.borderLight, width: 2.5),
      boxShadow: [
        BoxShadow(
          color: theme.inputShadow.withValues(alpha: 0.42),
          blurRadius: 0,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  double sectionGap() => 14;

  @override
  EdgeInsets panelPadding(AnimalDateTimePickerPanelKind kind) {
    return switch (kind) {
      AnimalDateTimePickerPanelKind.calendar => const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        12,
      ),
      AnimalDateTimePickerPanelKind.time => const EdgeInsets.fromLTRB(
        12,
        12,
        12,
        14,
      ),
    };
  }

  @override
  BoxDecoration pickerPanelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: theme.borderLight.withValues(alpha: 0.75),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: theme.inputShadow.withValues(alpha: 0.16),
          blurRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  @override
  Widget? buildSystemHeader(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required String label,
    required String value,
  }) {
    return null;
  }

  @override
  double calendarHeaderGap() => 10;

  @override
  double weekdayGap() => 6;

  @override
  double gridMainAxisSpacing() => 4;

  @override
  double gridCrossAxisSpacing() => 4;

  @override
  double gridChildAspectRatio() => 1.06;

  @override
  double timePanelHeight({required bool compact}) => compact ? 196 : 208;

  @override
  TextStyle monthTitleStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      color: theme.textPrimary,
      fontSize: AnimalIslandTokens.fontBody,
      fontWeight: FontWeight.w800,
    );
  }

  @override
  TextStyle weekdayStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      fontSize: AnimalIslandTokens.fontCaption,
      color: theme.textMuted,
      fontWeight: FontWeight.w800,
    );
  }

  @override
  BoxDecoration calendarCellDecoration(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool today,
  }) {
    return BoxDecoration(
      color: selected
          ? theme.focusYellow
          : today
          ? theme.primarySoft
          : theme.surfaceRaised,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: selected
            ? theme.focusYellowDark
            : today
            ? theme.primary
            : theme.borderLight.withValues(alpha: 0.28),
        width: selected ? 2.4 : 1.5,
      ),
    );
  }

  @override
  String calendarCellText(int day) => '$day';

  @override
  TextStyle calendarCellTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool disabled,
  }) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
      fontSize: AnimalIslandTokens.fontCaption,
      color: disabled
          ? theme.textDisabled
          : selected
          ? theme.textPrimary
          : theme.textBody,
      fontWeight: FontWeight.w800,
    );
  }

  @override
  TextStyle timeSeparatorStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: theme.textPrimary,
      fontSize: compact ? 28 : 32,
      fontWeight: FontWeight.w900,
    );
  }

  @override
  BoxDecoration wheelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: theme.borderLight.withValues(alpha: 0.75),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: theme.inputShadow.withValues(alpha: 0.16),
          blurRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  @override
  BoxDecoration wheelSelectionDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.focusYellow.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: theme.focusYellow.withValues(alpha: 0.58),
        width: 1.8,
      ),
    );
  }

  @override
  BoxDecoration wheelFadeDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.surfaceRaised,
          theme.surfaceRaised.withValues(alpha: 0),
          theme.surfaceRaised.withValues(alpha: 0),
          theme.surfaceRaised,
        ],
        stops: const [0, 0.16, 0.84, 1],
      ),
    );
  }

  @override
  TextStyle wheelTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
  }) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: selected ? theme.textPrimary : theme.textMuted,
      fontSize: selected ? 28 : 20,
      fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
    );
  }
}

final class _NesAnimalDateTimePickerThemeStrategy
    extends _AnimalIslandDateTimePickerThemeStrategy {
  const _NesAnimalDateTimePickerThemeStrategy();

  @override
  EdgeInsets rootPadding({required bool compact}) =>
      EdgeInsets.all(compact ? 12 : 14);

  @override
  BoxDecoration rootDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      borderRadius: BorderRadius.zero,
      border: Border.all(color: theme.border, width: theme.borderWidth),
      boxShadow: [
        BoxShadow(
          color: theme.buttonShadow,
          blurRadius: 0,
          offset: const Offset(6, 6),
        ),
      ],
    );
  }

  @override
  double sectionGap() => 10;

  @override
  EdgeInsets panelPadding(AnimalDateTimePickerPanelKind kind) {
    return switch (kind) {
      AnimalDateTimePickerPanelKind.calendar => const EdgeInsets.fromLTRB(
        10,
        10,
        10,
        12,
      ),
      AnimalDateTimePickerPanelKind.time => const EdgeInsets.fromLTRB(
        10,
        12,
        10,
        12,
      ),
    };
  }

  @override
  BoxDecoration pickerPanelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.zero,
      border: Border.all(color: theme.border, width: theme.borderWidth),
      boxShadow: [
        BoxShadow(
          color: theme.buttonShadow,
          blurRadius: 0,
          offset: const Offset(3, 3),
        ),
      ],
    );
  }

  @override
  double gridMainAxisSpacing() => 5;

  @override
  double gridCrossAxisSpacing() => 5;

  @override
  TextStyle monthTitleStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      color: theme.textPrimary,
      fontSize: AnimalIslandTokens.fontBody,
      fontWeight: FontWeight.w900,
    );
  }

  @override
  TextStyle weekdayStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      fontSize: AnimalIslandTokens.fontCaption,
      color: theme.textSecondary,
      fontWeight: FontWeight.w900,
    );
  }

  @override
  BoxDecoration calendarCellDecoration(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool today,
  }) {
    return BoxDecoration(
      color: selected
          ? const Color(0xFF209CEE)
          : today
          ? theme.primarySoft
          : theme.surfaceRaised,
      borderRadius: BorderRadius.zero,
      border: Border.all(
        color: selected
            ? theme.border
            : today
            ? theme.borderHover
            : theme.borderLight,
        width: selected || today ? 3 : 2,
      ),
      boxShadow: selected
          ? const [
              BoxShadow(
                color: Color(0xFF006BB3),
                blurRadius: 0,
                offset: Offset(2, 2),
              ),
            ]
          : null,
    );
  }

  @override
  TextStyle calendarCellTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool disabled,
  }) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
      fontSize: AnimalIslandTokens.fontCaption,
      color: disabled
          ? theme.textDisabled
          : selected
          ? Colors.white
          : theme.textPrimary,
      fontWeight: FontWeight.w900,
    );
  }

  @override
  BoxDecoration wheelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.zero,
      border: Border.all(color: theme.border, width: theme.borderWidth),
    );
  }

  @override
  BoxDecoration wheelSelectionDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.primarySoft,
      borderRadius: BorderRadius.zero,
      border: Border.all(color: theme.borderHover, width: 3),
    );
  }

  @override
  BoxDecoration wheelFadeDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.surfaceRaised,
          theme.surfaceRaised.withValues(alpha: 0),
          theme.surfaceRaised.withValues(alpha: 0),
          theme.surfaceRaised,
        ],
        stops: const [0, 0.18, 0.82, 1],
      ),
    );
  }
}

final class _GuofengAnimalDateTimePickerThemeStrategy
    extends AnimalDateTimePickerThemeStrategy {
  const _GuofengAnimalDateTimePickerThemeStrategy();

  @override
  EdgeInsets rootPadding({required bool compact}) =>
      EdgeInsets.all(compact ? 10 : 12);

  @override
  BoxDecoration rootDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.circular(theme.radiusBase),
      border: Border.all(color: Colors.transparent, width: theme.borderWidth),
      boxShadow: [
        BoxShadow(
          color: theme.inputShadow.withValues(alpha: 0.26),
          blurRadius: theme.mode == AnimalIslandThemeMode.day ? 8 : 14,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  @override
  double sectionGap() => 8;

  @override
  EdgeInsets panelPadding(AnimalDateTimePickerPanelKind kind) {
    return switch (kind) {
      AnimalDateTimePickerPanelKind.calendar => const EdgeInsets.fromLTRB(
        8,
        8,
        8,
        8,
      ),
      AnimalDateTimePickerPanelKind.time => const EdgeInsets.fromLTRB(
        8,
        8,
        8,
        10,
      ),
    };
  }

  @override
  BoxDecoration pickerPanelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surface.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.transparent, width: 1.2),
    );
  }

  @override
  Widget? buildSystemHeader(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required String label,
    required String value,
  }) {
    return _GuofengPickerHeader(value: value);
  }

  @override
  double calendarHeaderGap() => 7;

  @override
  double weekdayGap() => 4;

  @override
  double gridMainAxisSpacing() => 3;

  @override
  double gridCrossAxisSpacing() => 3;

  @override
  double gridChildAspectRatio() => 1.12;

  @override
  double timePanelHeight({required bool compact}) => compact ? 164 : 174;

  @override
  TextStyle monthTitleStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      color: theme.textPrimary,
      fontSize: AnimalIslandTokens.fontBody,
      fontWeight: FontWeight.w700,
    );
  }

  @override
  TextStyle weekdayStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      fontSize: AnimalIslandTokens.fontCaption,
      color: theme.primaryActive.withValues(alpha: 0.86),
      fontWeight: FontWeight.w700,
    );
  }

  @override
  BoxDecoration calendarCellDecoration(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool today,
  }) {
    return BoxDecoration(
      color: selected
          ? theme.primary.withValues(alpha: 0.18)
          : today
          ? theme.focusYellow.withValues(alpha: 0.16)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
    );
  }

  @override
  String calendarCellText(int day) => '$day';

  @override
  TextStyle calendarCellTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool disabled,
  }) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
      fontSize: AnimalIslandTokens.fontCaption,
      color: disabled
          ? theme.textDisabled
          : selected
          ? theme.primaryActive
          : theme.textBody,
      fontWeight: FontWeight.w700,
    );
  }

  @override
  TextStyle timeSeparatorStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: theme.primaryActive,
      fontSize: compact ? 24 : 28,
      fontWeight: FontWeight.w700,
    );
  }

  @override
  BoxDecoration wheelDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.surface.withValues(alpha: 0.82),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.transparent, width: 1.2),
    );
  }

  @override
  BoxDecoration wheelSelectionDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.transparent),
    );
  }

  @override
  BoxDecoration wheelFadeDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.surfaceRaised.withValues(alpha: 0.78),
          theme.surfaceRaised.withValues(alpha: 0),
          theme.surfaceRaised.withValues(alpha: 0),
          theme.surfaceRaised.withValues(alpha: 0.78),
        ],
        stops: const [0, 0.18, 0.82, 1],
      ),
    );
  }

  @override
  TextStyle wheelTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
  }) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: selected ? theme.textPrimary : theme.textMuted,
      fontSize: selected ? 26 : 18,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
    );
  }
}

final class _WestworldAnimalDateTimePickerThemeStrategy
    extends AnimalDateTimePickerThemeStrategy {
  const _WestworldAnimalDateTimePickerThemeStrategy();

  @override
  EdgeInsets rootPadding({required bool compact}) =>
      EdgeInsets.all(compact ? 10 : 12);

  @override
  BoxDecoration rootDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return theme.westworldPanelDecoration(emphasized: true);
  }

  @override
  double sectionGap() => 8;

  @override
  EdgeInsets panelPadding(AnimalDateTimePickerPanelKind kind) {
    return switch (kind) {
      AnimalDateTimePickerPanelKind.calendar => const EdgeInsets.fromLTRB(
        12,
        8,
        12,
        10,
      ),
      AnimalDateTimePickerPanelKind.time => const EdgeInsets.fromLTRB(
        12,
        8,
        12,
        10,
      ),
    };
  }

  @override
  BoxDecoration pickerPanelDecoration(AnimalIslandThemeData theme) {
    return theme.westworldPanelDecoration(color: theme.surface);
  }

  @override
  Widget? buildSystemHeader(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required String label,
    required String value,
  }) {
    return _WestworldPickerHeader(label: label, value: value);
  }

  @override
  double calendarHeaderGap() => 6;

  @override
  double weekdayGap() => 4;

  @override
  double gridMainAxisSpacing() => 3;

  @override
  double gridCrossAxisSpacing() => 3;

  @override
  double gridChildAspectRatio() => 1.18;

  @override
  double timePanelHeight({required bool compact}) => compact ? 150 : 160;

  @override
  TextStyle monthTitleStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      color: theme.textPrimary,
      fontSize: AnimalIslandTokens.fontBody,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    );
  }

  @override
  TextStyle weekdayStyle(BuildContext context, AnimalIslandThemeData theme) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
      fontSize: AnimalIslandTokens.fontCaption,
      color: theme.textMuted,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.0,
    );
  }

  @override
  BoxDecoration calendarCellDecoration(
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool today,
  }) {
    return BoxDecoration(
      color: selected
          ? theme.primary.withValues(alpha: 0.12)
          : today
          ? theme.textMuted.withValues(alpha: 0.08)
          : theme.surfaceRaised.withValues(alpha: 0.36),
      border: Border.all(
        color: selected
            ? theme.primary
            : today
            ? theme.textMuted.withValues(alpha: 0.52)
            : theme.panelLineColor(),
        width: selected ? 1.4 : 1,
      ),
    );
  }

  @override
  String calendarCellText(int day) => day.toString().padLeft(2, '0');

  @override
  TextStyle calendarCellTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
    required bool disabled,
  }) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
      fontSize: AnimalIslandTokens.fontCaption,
      color: disabled
          ? theme.textDisabled
          : selected
          ? theme.textPrimary
          : theme.textBody,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.8,
    );
  }

  @override
  TextStyle timeSeparatorStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: theme.textPrimary,
      fontSize: compact ? 28 : 32,
      fontWeight: FontWeight.w400,
    );
  }

  @override
  BoxDecoration wheelDecoration(AnimalIslandThemeData theme) {
    return theme.westworldPanelDecoration(color: theme.surfaceRaised);
  }

  @override
  BoxDecoration wheelSelectionDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      color: theme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(0),
      border: Border.all(color: theme.primary.withValues(alpha: 0.6), width: 1),
    );
  }

  @override
  BoxDecoration wheelFadeDecoration(AnimalIslandThemeData theme) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(0),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.surfaceRaised.withValues(alpha: 0.96),
          theme.surfaceRaised.withValues(alpha: 0),
          theme.surfaceRaised.withValues(alpha: 0),
          theme.surfaceRaised.withValues(alpha: 0.96),
        ],
        stops: const [0, 0.16, 0.84, 1],
      ),
    );
  }

  @override
  TextStyle wheelTextStyle(
    BuildContext context,
    AnimalIslandThemeData theme, {
    required bool selected,
  }) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
      color: selected ? theme.textPrimary : theme.textMuted,
      fontSize: selected ? 30 : 19,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.2,
    );
  }
}

class _WestworldPickerHeader extends StatelessWidget {
  const _WestworldPickerHeader({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: theme.textMuted,
              letterSpacing: 1.8,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            border: Border.all(color: theme.panelLineColor()),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: theme.textPrimary,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _GuofengPickerHeader extends StatelessWidget {
  const _GuofengPickerHeader({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 1.2,
            color: theme.border.withValues(alpha: 0.38),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: theme.primary, width: 1.2),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: theme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.2,
            color: theme.border.withValues(alpha: 0.38),
          ),
        ),
      ],
    );
  }
}
