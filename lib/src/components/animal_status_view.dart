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
    final statusBody = theme.isWestworld
        ? _WestworldStatusBody(
            tone: tone,
            title: title ?? config.title,
            message: message ?? config.message,
            action: action,
            compact: compact,
            config: config,
          )
        : theme.isNes
        ? _NesStatusBody(
            tone: tone,
            title: title ?? config.title,
            message: message ?? config.message,
            badge: config.badge,
            action: action,
            compact: compact,
            config: config,
          )
        : _AnimalStatusBody(
            tone: tone,
            title: title ?? config.title,
            message: message ?? config.message,
            action: action,
            icon: icon,
            compact: compact,
            config: config,
          );

    return DecoratedBox(
      decoration: theme.isWestworld
          ? theme.westworldPanelDecoration(
              lineColor: config.border,
              emphasized: true,
            )
          : BoxDecoration(
              color: theme.isNes ? theme.surfaceRaised : null,
              gradient: theme.isNes
                  ? null
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [theme.surfaceRaised, theme.surface],
                    ),
              borderRadius: BorderRadius.circular(
                theme.isNes ? theme.radiusBase : (compact ? 26 : 34),
              ),
              border: Border.all(
                color: config.border,
                width: theme.inputBorderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.isNes
                      ? theme.buttonShadow
                      : config.shadow.withValues(alpha: 0.26),
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
          borderRadius: BorderRadius.circular(
            theme.isWestworld
                ? 0
                : theme.isNes
                ? theme.radiusBase
                : (compact ? 24 : 32),
          ),
          image: theme.isNes || theme.isWestworld
              ? null
              : DecorationImage(
                  image: AnimalIslandAssets.raster(
                    AnimalIslandAssets.demoHomeBackground,
                  ),
                  fit: BoxFit.cover,
                  opacity: theme.mode == AnimalIslandThemeMode.day
                      ? 0.08
                      : 0.05,
                ),
        ),
        child: statusBody,
      ),
    );
  }

  _AnimalStatusConfig _configFor(AnimalIslandThemeData theme) {
    if (theme.isWestworld) {
      return switch (tone) {
        AnimalStatusTone.loading => _AnimalStatusConfig(
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
        AnimalStatusTone.error => _AnimalStatusConfig(
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
        AnimalStatusTone.empty => _AnimalStatusConfig(
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

class _AnimalStatusBody extends StatelessWidget {
  const _AnimalStatusBody({
    required this.tone,
    required this.title,
    required this.message,
    required this.action,
    required this.icon,
    required this.compact,
    required this.config,
  });

  final AnimalStatusTone tone;
  final String title;
  final String message;
  final Widget? action;
  final Widget? icon;
  final bool compact;
  final _AnimalStatusConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          child: AnimalBadge(
            label: config.badge,
            backgroundColor: config.badgeColor,
            foregroundColor: config.badgeForeground,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: theme.textPrimary,
                  fontSize: compact
                      ? AnimalIslandTokens.fontBodyLg
                      : AnimalIslandTokens.fontTitleSm,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: AnimalIslandTokens.spacingSm),
                Text(
                  message,
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
    );
  }
}

class _WestworldStatusBody extends StatefulWidget {
  const _WestworldStatusBody({
    required this.tone,
    required this.title,
    required this.message,
    required this.action,
    required this.compact,
    required this.config,
  });

  final AnimalStatusTone tone;
  final String title;
  final String message;
  final Widget? action;
  final bool compact;
  final _AnimalStatusConfig config;

  @override
  State<_WestworldStatusBody> createState() => _WestworldStatusBodyState();
}

class _WestworldStatusBodyState extends State<_WestworldStatusBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimalBadge(
              label: widget.config.badge,
              backgroundColor: widget.config.badgeColor,
              foregroundColor: widget.config.badgeForeground,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            ),
            const SizedBox(width: AnimalIslandTokens.spacingMd),
            Text(
              _toneCode(widget.tone),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: theme.textMuted,
                letterSpacing: 1.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox.square(
          dimension: widget.compact ? 94 : 124,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => CustomPaint(
              painter: _WestworldStatusPainter(
                tone: widget.tone,
                progress: _controller.value,
                line: widget.config.accent,
                muted: theme.panelLineColor(),
                glow: widget.config.fill,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520),
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 14 : 18,
            vertical: widget.compact ? 14 : 18,
          ),
          decoration: theme.westworldPanelDecoration(
            color: theme.surface,
            lineColor: widget.config.border,
          ),
          child: Column(
            children: [
              Text(
                widget.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: theme.textPrimary,
                  fontSize: widget.compact
                      ? AnimalIslandTokens.fontBodyLg
                      : AnimalIslandTokens.fontTitle,
                  letterSpacing: 1.2,
                ),
              ),
              if (widget.message.isNotEmpty) ...[
                const SizedBox(height: AnimalIslandTokens.spacingSm),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: theme.textSecondary,
                    height: 1.32,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.action != null) ...[
          const SizedBox(height: AnimalIslandTokens.spacingLg),
          widget.action!,
        ],
      ],
    );
  }

  String _toneCode(AnimalStatusTone tone) {
    return switch (tone) {
      AnimalStatusTone.loading => 'HOST-QUERY-01',
      AnimalStatusTone.error => 'DIVERGENCE-ERR',
      AnimalStatusTone.empty => 'NULL-BRANCH',
    };
  }
}

class _WestworldStatusPainter extends CustomPainter {
  const _WestworldStatusPainter({
    required this.tone,
    required this.progress,
    required this.line,
    required this.muted,
    required this.glow,
  });

  final AnimalStatusTone tone;
  final double progress;
  final Color line;
  final Color muted;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = muted;
    canvas.drawCircle(center, radius * 0.44, ring);
    canvas.drawCircle(center, radius * 0.72, ring);
    canvas.drawCircle(center, radius * 0.96, ring);
    for (var i = 0; i < 16; i += 1) {
      final angle = i * math.pi / 8;
      final a =
          center + Offset(math.cos(angle), math.sin(angle)) * radius * 0.84;
      final b =
          center + Offset(math.cos(angle), math.sin(angle)) * radius * 0.96;
      canvas.drawLine(a, b, ring);
    }

    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = line;
    final start = -math.pi / 2 + progress * math.pi * 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.72),
      start,
      math.pi * 0.66,
      false,
      active,
    );

    switch (tone) {
      case AnimalStatusTone.loading:
        final angle = progress * math.pi * 2;
        canvas.drawLine(
          center,
          center + Offset(math.cos(angle), math.sin(angle)) * radius * 0.92,
          active,
        );
      case AnimalStatusTone.error:
        canvas.drawLine(
          center - Offset(radius * 0.42, radius * 0.42),
          center + Offset(radius * 0.42, radius * 0.42),
          active,
        );
        final textPainter = TextPainter(
          text: TextSpan(
            text: '!',
            style: TextStyle(
              color: line,
              fontSize: radius * 0.78,
              fontWeight: FontWeight.w400,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          center - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      case AnimalStatusTone.empty:
        final dash = Paint()
          ..color = line
          ..strokeWidth = 1.4;
        canvas.drawLine(
          center - Offset(radius * 0.34, 0),
          center + Offset(radius * 0.34, 0),
          dash,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _WestworldStatusPainter oldDelegate) {
    return oldDelegate.tone != tone ||
        oldDelegate.progress != progress ||
        oldDelegate.line != line ||
        oldDelegate.muted != muted ||
        oldDelegate.glow != glow;
  }
}

class _NesStatusBody extends StatefulWidget {
  const _NesStatusBody({
    required this.tone,
    required this.title,
    required this.message,
    required this.badge,
    required this.action,
    required this.compact,
    required this.config,
  });

  final AnimalStatusTone tone;
  final String title;
  final String message;
  final String badge;
  final Widget? action;
  final bool compact;
  final _AnimalStatusConfig config;

  @override
  State<_NesStatusBody> createState() => _NesStatusBodyState();
}

class _NesStatusBodyState extends State<_NesStatusBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 720),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NesStatusIcon(
              tone: widget.tone,
              controller: _controller,
              color: widget.config.foreground,
              border: theme.border,
              surface: theme.surface,
              compact: widget.compact,
            ),
            const SizedBox(width: AnimalIslandTokens.spacingMd),
            AnimalBadge(
              label: widget.badge,
              backgroundColor: widget.config.badgeColor,
              foregroundColor: widget.config.badgeForeground,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ],
        ),
        const SizedBox(height: AnimalIslandTokens.spacingLg),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520),
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 14 : 18,
            vertical: widget.compact ? 14 : 18,
          ),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(theme.radiusSm),
            border: Border.all(color: theme.border, width: theme.borderWidth),
          ),
          child: Column(
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: theme.textPrimary,
                  fontSize: widget.compact
                      ? AnimalIslandTokens.fontBodySm
                      : AnimalIslandTokens.fontBody,
                  height: 1.8,
                ),
              ),
              if (widget.message.isNotEmpty) ...[
                const SizedBox(height: AnimalIslandTokens.spacingMd),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: theme.textBody,
                    height: 1.8,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.action != null) ...[
          const SizedBox(height: AnimalIslandTokens.spacingLg),
          widget.action!,
        ],
      ],
    );
  }
}

class _NesStatusIcon extends StatelessWidget {
  const _NesStatusIcon({
    required this.tone,
    required this.controller,
    required this.color,
    required this.border,
    required this.surface,
    required this.compact,
  });

  final AnimalStatusTone tone;
  final Animation<double> controller;
  final Color color;
  final Color border;
  final Color surface;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 56.0 : 72.0;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _NesStatusIconPainter(
              tone: tone,
              frame: (controller.value * 4).floor() % 4,
              color: color,
              border: border,
              surface: surface,
            ),
          ),
        );
      },
    );
  }
}

class _NesStatusIconPainter extends CustomPainter {
  const _NesStatusIconPainter({
    required this.tone,
    required this.frame,
    required this.color,
    required this.border,
    required this.surface,
  });

  final AnimalStatusTone tone;
  final int frame;
  final Color color;
  final Color border;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 8;
    final edge = Paint()..color = border;
    final fill = Paint()..color = surface;
    final accent = Paint()..color = color;

    void block(num x, num y, num w, num h, Paint paint) {
      canvas.drawRect(
        Rect.fromLTWH(x * unit, y * unit, w * unit, h * unit),
        paint,
      );
    }

    block(1, 1, 6, 6, edge);
    block(2, 2, 4, 4, fill);

    switch (tone) {
      case AnimalStatusTone.loading:
        final positions = <Offset>[
          const Offset(3, 2),
          const Offset(5, 3),
          const Offset(4, 5),
          const Offset(2, 4),
        ];
        for (var i = 0; i < positions.length; i += 1) {
          final active = i == frame;
          accent.color = color.withValues(alpha: active ? 1 : 0.32);
          block(positions[i].dx, positions[i].dy, 1, 1, accent);
        }
      case AnimalStatusTone.error:
        block(3, 2, 2, 3, accent);
        block(3, 6, 2, 1, accent);
      case AnimalStatusTone.empty:
        block(2, 3, 4, 1, accent);
        block(2, 5, 4, 1, accent);
    }
  }

  @override
  bool shouldRepaint(covariant _NesStatusIconPainter oldDelegate) {
    return oldDelegate.tone != tone ||
        oldDelegate.frame != frame ||
        oldDelegate.color != color ||
        oldDelegate.border != border ||
        oldDelegate.surface != surface;
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
          borderRadius: theme.isNes
              ? BorderRadius.circular(theme.radiusBase)
              : BorderRadius.only(
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
              child: theme.isNes
                  ? const SizedBox.shrink()
                  : Container(
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
              child: theme.isNes
                  ? const SizedBox.shrink()
                  : Container(
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
              fontSize: 32 * scale,
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
                fontSize: 16 * scale,
                fontWeight: FontWeight.w800,
                height: 0.9,
                letterSpacing: 1.0,
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
