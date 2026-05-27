import 'package:flutter/material.dart';

import '../../models/animal_island_models.dart';
import '../../theme/animal_island_theme.dart';

abstract final class AnimalStatusViewThemeStrategy {
  const AnimalStatusViewThemeStrategy();

  static AnimalStatusViewThemeStrategy of(AnimalIslandThemeData theme) {
    return forGameStyle(theme.gameStyle);
  }

  static AnimalStatusViewThemeStrategy forGameStyle(
    AnimalIslandGameStyle gameStyle,
  ) {
    return switch (gameStyle) {
      AnimalIslandGameStyle.nes8Bit =>
        const _NesAnimalStatusViewThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalStatusViewThemeStrategy(),
      AnimalIslandGameStyle.guofengDoodle =>
        const _GuofengAnimalStatusViewThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandStatusViewThemeStrategy(),
    };
  }

  AnimalStatusConfig config(AnimalIslandThemeData theme, AnimalStatusTone tone);

  BoxDecoration outerDecoration(
    AnimalIslandThemeData theme, {
    required AnimalStatusConfig config,
    required bool compact,
  });

  BoxDecoration innerDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  });
}

final class _AnimalIslandStatusViewThemeStrategy
    extends AnimalStatusViewThemeStrategy {
  const _AnimalIslandStatusViewThemeStrategy();

  @override
  AnimalStatusConfig config(
    AnimalIslandThemeData theme,
    AnimalStatusTone tone,
  ) {
    return switch (tone) {
      AnimalStatusTone.loading => AnimalStatusConfig(
        title: '狸克正在整理岛上的新消息',
        message: '公告板上的纸张刚刚被海风吹起，再稍等一下，新的通知就会贴好。',
        badge: '正在准备',
        fill: theme.primary.withValues(alpha: 0.14),
        accent: theme.primary,
        border: theme.primary.withValues(alpha: 0.38),
        shadow: theme.primaryActive,
        foreground: theme.primaryActive,
        badgeColor: theme.primarySoft,
        badgeForeground: theme.primaryActive,
      ),
      AnimalStatusTone.error => AnimalStatusConfig(
        title: '刚刚那张通知被风吹跑了',
        message: '海边的信号有些不稳定。重新整理一下公告板，就能继续查看岛上的消息。',
        badge: '需要重试',
        fill: theme.error.withValues(alpha: 0.12),
        accent: theme.error,
        border: theme.error.withValues(alpha: 0.32),
        shadow: theme.errorActive,
        foreground: theme.errorActive,
        badgeColor: theme.surfaceSoft,
        badgeForeground: theme.errorActive,
      ),
      AnimalStatusTone.empty => AnimalStatusConfig(
        title: '公告板今天还没有新内容',
        message: '现在先去海边散步或者逛逛商店吧。等岛民留下新消息，这里会再热闹起来。',
        badge: '暂时空白',
        fill: theme.warning.withValues(alpha: 0.18),
        accent: theme.focusYellowDark,
        border: theme.warning.withValues(alpha: 0.34),
        shadow: theme.buttonShadow,
        foreground: theme.textBody,
        badgeColor: theme.surfaceSoft,
        badgeForeground: theme.textBody,
      ),
    };
  }

  @override
  BoxDecoration outerDecoration(
    AnimalIslandThemeData theme, {
    required AnimalStatusConfig config,
    required bool compact,
  }) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [theme.surfaceRaised, theme.surface],
      ),
      borderRadius: BorderRadius.circular(compact ? 26 : 34),
      border: Border.all(color: config.border, width: theme.inputBorderWidth),
      boxShadow: [
        BoxShadow(
          color: config.shadow.withValues(alpha: 0.26),
          blurRadius: 0,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  BoxDecoration innerDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(compact ? 24 : 32),
      color: theme.surfaceSoft.withValues(
        alpha: theme.mode == AnimalIslandThemeMode.day ? 0.22 : 0.16,
      ),
    );
  }
}

final class _NesAnimalStatusViewThemeStrategy
    extends AnimalStatusViewThemeStrategy {
  const _NesAnimalStatusViewThemeStrategy();

  @override
  AnimalStatusConfig config(
    AnimalIslandThemeData theme,
    AnimalStatusTone tone,
  ) {
    return switch (tone) {
      AnimalStatusTone.loading => AnimalStatusConfig(
        title: '狸克正在整理岛上的新消息',
        message: '公告板上的纸张刚刚被海风吹起，再稍等一下，新的通知就会贴好。',
        badge: '正在准备',
        fill: theme.primary.withValues(alpha: 0.14),
        accent: theme.primary,
        border: theme.primary.withValues(alpha: 0.38),
        shadow: theme.primaryActive,
        foreground: theme.primaryActive,
        badgeColor: theme.primarySoft,
        badgeForeground: theme.primaryActive,
      ),
      AnimalStatusTone.error => AnimalStatusConfig(
        title: '刚刚那张通知被风吹跑了',
        message: '海边的信号有些不稳定。重新整理一下公告板，就能继续查看岛上的消息。',
        badge: '需要重试',
        fill: theme.error.withValues(alpha: 0.12),
        accent: theme.error,
        border: theme.error.withValues(alpha: 0.32),
        shadow: theme.errorActive,
        foreground: theme.errorActive,
        badgeColor: theme.surfaceSoft,
        badgeForeground: theme.errorActive,
      ),
      AnimalStatusTone.empty => AnimalStatusConfig(
        title: '公告板今天还没有新内容',
        message: '现在先去海边散步或者逛逛商店吧。等岛民留下新消息，这里会再热闹起来。',
        badge: '暂时空白',
        fill: theme.warning.withValues(alpha: 0.18),
        accent: theme.focusYellowDark,
        border: theme.warning.withValues(alpha: 0.34),
        shadow: theme.buttonShadow,
        foreground: theme.textBody,
        badgeColor: theme.surfaceSoft,
        badgeForeground: theme.textBody,
      ),
    };
  }

  @override
  BoxDecoration outerDecoration(
    AnimalIslandThemeData theme, {
    required AnimalStatusConfig config,
    required bool compact,
  }) {
    return BoxDecoration(
      color: theme.surfaceRaised,
      borderRadius: BorderRadius.circular(theme.radiusBase),
      border: Border.all(color: config.border, width: theme.inputBorderWidth),
      boxShadow: [
        BoxShadow(
          color: theme.buttonShadow,
          blurRadius: 0,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  @override
  BoxDecoration innerDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.circular(theme.radiusBase),
      border: Border.all(color: theme.border, width: theme.borderWidth),
    );
  }
}

final class _WestworldAnimalStatusViewThemeStrategy
    extends AnimalStatusViewThemeStrategy {
  const _WestworldAnimalStatusViewThemeStrategy();

  @override
  AnimalStatusConfig config(
    AnimalIslandThemeData theme,
    AnimalStatusTone tone,
  ) {
    return switch (tone) {
      AnimalStatusTone.loading => AnimalStatusConfig(
        title: 'SYSTEM ANALYSIS IN PROGRESS',
        message:
            'Narrative signals are being correlated. Awaiting stable divergence output.',
        badge: 'ANALYZING',
        fill: theme.primary.withValues(alpha: 0.06),
        accent: theme.primary,
        border: theme.primary.withValues(alpha: 0.54),
        shadow: theme.primary,
        foreground: theme.primary,
        badgeColor: theme.surfaceSoft,
        badgeForeground: theme.textPrimary,
      ),
      AnimalStatusTone.error => AnimalStatusConfig(
        title: 'ANOMALY DETECTED',
        message:
            'The requested thread diverged outside operational tolerance. Re-run acquisition.',
        badge: 'DIVERGENCE',
        fill: theme.error.withValues(alpha: 0.08),
        accent: theme.error,
        border: theme.error.withValues(alpha: 0.62),
        shadow: theme.errorActive,
        foreground: theme.error,
        badgeColor: theme.error.withValues(alpha: 0.12),
        badgeForeground: theme.error,
      ),
      AnimalStatusTone.empty => AnimalStatusConfig(
        title: 'NO ACTIVE NARRATIVE',
        message:
            'No compatible records were found in the current branch. Broaden the search vector.',
        badge: 'NO DATA',
        fill: theme.warning.withValues(alpha: 0.08),
        accent: theme.warning,
        border: theme.warning.withValues(alpha: 0.56),
        shadow: theme.warningActive,
        foreground: theme.warning,
        badgeColor: theme.warning.withValues(alpha: 0.1),
        badgeForeground: theme.warning,
      ),
    };
  }

  @override
  BoxDecoration outerDecoration(
    AnimalIslandThemeData theme, {
    required AnimalStatusConfig config,
    required bool compact,
  }) {
    return const BoxDecoration(color: Color(0xFFEFEFED));
  }

  @override
  BoxDecoration innerDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return const BoxDecoration();
  }
}

final class _GuofengAnimalStatusViewThemeStrategy
    extends AnimalStatusViewThemeStrategy {
  const _GuofengAnimalStatusViewThemeStrategy();

  @override
  AnimalStatusConfig config(
    AnimalIslandThemeData theme,
    AnimalStatusTone tone,
  ) {
    return switch (tone) {
      AnimalStatusTone.loading => AnimalStatusConfig(
        title: '正在铺开卷轴',
        message: '墨迹还在晕开，新的内容马上显现。',
        badge: '待墨',
        fill: theme.primary.withValues(alpha: 0.14),
        accent: theme.primary,
        border: theme.primary.withValues(alpha: 0.72),
        shadow: theme.inputShadow,
        foreground: theme.primaryActive,
        badgeColor: theme.primary,
        badgeForeground: Colors.white,
      ),
      AnimalStatusTone.error => AnimalStatusConfig(
        title: '朱印未成',
        message: '这次落印没有对齐，请重新试一次。',
        badge: '重试',
        fill: theme.error.withValues(alpha: 0.1),
        accent: theme.error,
        border: theme.error.withValues(alpha: 0.76),
        shadow: theme.errorActive,
        foreground: theme.error,
        badgeColor: theme.error,
        badgeForeground: Colors.white,
      ),
      AnimalStatusTone.empty => AnimalStatusConfig(
        title: '卷上留白',
        message: '当前还没有可展示的内容。',
        badge: '留白',
        fill: theme.warning.withValues(alpha: 0.14),
        accent: theme.focusYellow,
        border: theme.border.withValues(alpha: 0.72),
        shadow: theme.inputShadow,
        foreground: theme.textBody,
        badgeColor: theme.error.withValues(alpha: 0.88),
        badgeForeground: Colors.white,
      ),
    };
  }

  @override
  BoxDecoration outerDecoration(
    AnimalIslandThemeData theme, {
    required AnimalStatusConfig config,
    required bool compact,
  }) {
    return BoxDecoration(
      color: theme.surface,
      borderRadius: BorderRadius.circular(compact ? 10 : 12),
      border: Border.all(color: Colors.transparent, width: theme.borderWidth),
      boxShadow: [
        BoxShadow(
          color: config.shadow.withValues(alpha: 0.34),
          blurRadius: theme.mode == AnimalIslandThemeMode.day ? 8 : 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  BoxDecoration innerDecoration(
    AnimalIslandThemeData theme, {
    required bool compact,
  }) {
    return BoxDecoration(
      color: theme.surface.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(compact ? 8 : 10),
      border: Border.all(color: theme.border.withValues(alpha: 0.42), width: 1),
    );
  }
}
