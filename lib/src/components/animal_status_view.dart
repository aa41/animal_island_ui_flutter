import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';
import 'animal_badge.dart';
import 'animal_button.dart';

class AnimalStatusView extends StatelessWidget {
  const AnimalStatusView({
    super.key,
    required this.tone,
    this.title,
    this.message,
    this.action,
    this.icon,
    this.compact = false,
  });

  final AnimalStatusTone tone;
  final String? title;
  final String? message;
  final Widget? action;
  final Widget? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final config = _configFor(theme);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.surfaceRaised, theme.surface],
        ),
        borderRadius: BorderRadius.circular(compact ? 26 : 34),
        border: Border.all(color: config.border, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: config.shadow.withValues(alpha: 0.26),
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          compact ? 18 : 24,
          compact ? 18 : 22,
          compact ? 18 : 24,
          compact ? 18 : 22,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(compact ? 24 : 32),
          image: DecorationImage(
            image: AnimalIslandAssets.raster(
              AnimalIslandAssets.demoHomeBackground,
            ),
            fit: BoxFit.cover,
            opacity: theme.mode == AnimalIslandThemeMode.day ? 0.08 : 0.05,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              child: AnimalBadge(
                label: config.badge,
                backgroundColor: config.badgeColor,
                foregroundColor: config.badgeForeground,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
              ),
            ),
            const SizedBox(height: AnimalIslandTokens.spacingMd),
            _AnimalStatusMedallion(
              tone: tone,
              fillColor: config.fill,
              accentColor: config.accent,
              foregroundColor: config.foreground,
              icon: icon,
              compact: compact,
            ),
            const SizedBox(height: AnimalIslandTokens.spacingLg),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 460),
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 16 : 20,
                vertical: compact ? 16 : 18,
              ),
              decoration: BoxDecoration(
                color: theme.surface.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: theme.borderLight.withValues(alpha: 0.88),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    title ?? config.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: theme.textPrimary,
                      fontSize: compact ? 16 : 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if ((message ?? config.message).isNotEmpty) ...[
                    const SizedBox(height: AnimalIslandTokens.spacingSm),
                    Text(
                      message ?? config.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: theme.textBody,
                        height: 1.65,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AnimalIslandTokens.spacingLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }

  _AnimalStatusConfig _configFor(AnimalIslandThemeData theme) {
    return switch (tone) {
      AnimalStatusTone.loading => _AnimalStatusConfig(
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
      AnimalStatusTone.error => _AnimalStatusConfig(
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
      AnimalStatusTone.empty => _AnimalStatusConfig(
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
}

class AnimalLoading extends StatelessWidget {
  const AnimalLoading({
    super.key,
    this.title,
    this.message,
    this.compact = false,
  });

  final String? title;
  final String? message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimalStatusView(
      tone: AnimalStatusTone.loading,
      title: title,
      message: message,
      compact: compact,
    );
  }
}

class AnimalErrorState extends StatelessWidget {
  const AnimalErrorState({
    super.key,
    this.title,
    this.message,
    this.actionLabel = '重新整理公告板',
    this.onRetry,
    this.compact = false,
  });

  final String? title;
  final String? message;
  final String actionLabel;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimalStatusView(
      tone: AnimalStatusTone.error,
      title: title,
      message: message,
      compact: compact,
      action: onRetry == null
          ? null
          : AnimalButton(
              type: AnimalButtonType.primary,
              size: AnimalButtonSize.small,
              onPressed: onRetry,
              child: Text(actionLabel),
            ),
    );
  }
}

class AnimalEmptyState extends StatelessWidget {
  const AnimalEmptyState({
    super.key,
    this.title,
    this.message,
    this.actionLabel = '先去别处逛逛',
    this.onAction,
    this.compact = false,
  });

  final String? title;
  final String? message;
  final String actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimalStatusView(
      tone: AnimalStatusTone.empty,
      title: title,
      message: message,
      compact: compact,
      action: onAction == null
          ? null
          : AnimalButton(
              type: AnimalButtonType.defaultType,
              size: AnimalButtonSize.small,
              onPressed: onAction,
              child: Text(actionLabel),
            ),
    );
  }
}

class _AnimalStatusMedallion extends StatefulWidget {
  const _AnimalStatusMedallion({
    required this.tone,
    required this.fillColor,
    required this.accentColor,
    required this.foregroundColor,
    required this.icon,
    required this.compact,
  });

  final AnimalStatusTone tone;
  final Color fillColor;
  final Color accentColor;
  final Color foregroundColor;
  final Widget? icon;
  final bool compact;

  @override
  State<_AnimalStatusMedallion> createState() => _AnimalStatusMedallionState();
}

class _AnimalStatusMedallionState extends State<_AnimalStatusMedallion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final width = widget.compact ? 148.0 : 182.0;
    final height = widget.compact ? 104.0 : 126.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final bob = widget.tone == AnimalStatusTone.loading
            ? math.sin(_controller.value * math.pi * 2) * 2.4
            : 0.0;
        return Transform.translate(offset: Offset(0, bob), child: child);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: widget.fillColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.compact ? 42 : 52),
            topRight: Radius.circular(widget.compact ? 34 : 42),
            bottomLeft: Radius.circular(widget.compact ? 34 : 42),
            bottomRight: Radius.circular(widget.compact ? 46 : 58),
          ),
          border: Border.all(color: widget.accentColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 14,
              top: 12,
              child: Container(
                width: widget.compact ? 34 : 40,
                height: widget.compact ? 34 : 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.44),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 18,
              bottom: 16,
              child: Container(
                width: widget.compact ? 18 : 22,
                height: widget.compact ? 18 : 22,
                decoration: BoxDecoration(
                  color: theme.surface.withValues(alpha: 0.52),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(child: widget.icon ?? _defaultIcon(theme)),
          ],
        ),
      ),
    );
  }

  Widget _defaultIcon(AnimalIslandThemeData theme) {
    final scale = widget.compact ? 0.86 : 1.0;
    return switch (widget.tone) {
      AnimalStatusTone.loading => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 48 * scale,
            height: 48 * scale,
            decoration: BoxDecoration(
              color: theme.surface.withValues(alpha: 0.66),
              shape: BoxShape.circle,
            ),
          ),
          RotationTransition(
            turns: _controller,
            child: Image.asset(
              AnimalIslandAssets.iconLeaf,
              package: AnimalIslandAssets.package,
              width: 34 * scale,
              height: 34 * scale,
            ),
          ),
        ],
      ),
      AnimalStatusTone.error => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '!',
            style: TextStyle(
              color: widget.foregroundColor,
              fontSize: 36 * scale,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 30 * scale,
            height: 6 * scale,
            decoration: BoxDecoration(
              color: widget.foregroundColor.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
      AnimalStatusTone.empty => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52 * scale,
            height: 36 * scale,
            decoration: BoxDecoration(
              color: theme.surface.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: widget.foregroundColor.withValues(alpha: 0.28),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '...',
              style: TextStyle(
                color: widget.foregroundColor,
                fontSize: 18 * scale,
                fontWeight: FontWeight.w800,
                height: 0.9,
                letterSpacing: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            AnimalIslandAssets.iconLeaf,
            package: AnimalIslandAssets.package,
            width: 20 * scale,
            height: 20 * scale,
            opacity: const AlwaysStoppedAnimation<double>(0.72),
          ),
        ],
      ),
    };
  }
}

class _AnimalStatusConfig {
  const _AnimalStatusConfig({
    required this.title,
    required this.message,
    required this.badge,
    required this.fill,
    required this.accent,
    required this.border,
    required this.shadow,
    required this.foreground,
    required this.badgeColor,
    required this.badgeForeground,
  });

  final String title;
  final String message;
  final String badge;
  final Color fill;
  final Color accent;
  final Color border;
  final Color shadow;
  final Color foreground;
  final Color badgeColor;
  final Color badgeForeground;
}
