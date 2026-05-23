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
          ? const BoxDecoration(color: Color(0xFFEFEFED))
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
          theme.isWestworld
              ? (compact ? 12 : 18)
              : compact
              ? 18
              : 24,
          theme.isWestworld
              ? (compact ? 12 : 18)
              : compact
              ? 18
              : 22,
          theme.isWestworld
              ? (compact ? 12 : 18)
              : compact
              ? 18
              : 24,
          theme.isWestworld
              ? (compact ? 12 : 18)
              : compact
              ? 18
              : 22,
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
        const SizedBox(height: 10),
        SizedBox.square(
          dimension: widget.compact ? 220 : 360,
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
        const SizedBox(height: 12),
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
    final outerRadius = size.shortestSide * 0.47;
    _drawRehoboamBackground(canvas, center, outerRadius, size);
    _drawRehoboamRings(canvas, center, outerRadius);
    _drawRehoboamContour(canvas, center, outerRadius);
    _drawRehoboamSweep(canvas, center, outerRadius);
    _drawToneGlyph(canvas, center, outerRadius);
  }

  void _drawRehoboamBackground(
    Canvas canvas,
    Offset center,
    double outerRadius,
    Size size,
  ) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEFEFED),
    );
    canvas.drawCircle(
      center,
      outerRadius * 0.84,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = outerRadius * 0.015
        ..color = const Color(0xFF151515).withValues(alpha: 0.04),
    );
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.45
      ..color = const Color(0xFF111111).withValues(alpha: 0.025);
    for (var i = 1; i <= 10; i += 1) {
      canvas.drawCircle(center, outerRadius * (i / 10) * 0.78, ringPaint);
    }
  }

  void _drawRehoboamRings(Canvas canvas, Offset center, double outerRadius) {
    const specs = <_RehoboamRingSpec>[
      _RehoboamRingSpec(0.22, 0.32, 0.010, <double>[2, 5], -0.11, 0.1),
      _RehoboamRingSpec(0.32, 0.42, 0.012, <double>[], 0.06, 1.6),
      _RehoboamRingSpec(0.43, 0.34, 0.012, <double>[3, 8], 0.14, 2.4),
      _RehoboamRingSpec(0.54, 0.46, 0.014, <double>[], -0.19, 0.8),
      _RehoboamRingSpec(0.64, 0.34, 0.012, <double>[5, 12], 0.22, 3.1),
      _RehoboamRingSpec(0.74, 0.5, 0.014, <double>[], -0.28, 4.2),
      _RehoboamRingSpec(0.84, 0.4, 0.014, <double>[7, 14], 0.35, 5.4),
    ];
    for (final spec in specs) {
      final pulse = 0.94 + math.sin(progress * math.pi * 2 + spec.phase) * 0.06;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = spec.width
        ..color = const Color(
          0xFF101010,
        ).withValues(alpha: spec.alpha * pulse * 1.8);
      if (spec.dash.isNotEmpty) {
        _drawDashedCircle(
          canvas,
          center,
          outerRadius * spec.radius,
          paint,
          spec.dash,
          progress * math.pi * 2 * spec.speed,
        );
      } else {
        canvas.drawCircle(center, outerRadius * spec.radius, paint);
      }
    }
  }

  void _drawRehoboamSweep(Canvas canvas, Offset center, double outerRadius) {
    final angle = progress * math.pi * 2 * 0.55;
    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0xFF101010).withValues(alpha: 0.12);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius * 0.87),
      angle - math.pi / 60,
      math.pi / 30,
      false,
      sweepPaint,
    );
    canvas.drawLine(
      center,
      center + Offset(math.cos(angle), math.sin(angle)) * outerRadius * 0.9,
      Paint()
        ..strokeWidth = 0.8
        ..color = const Color(0xFF101010).withValues(alpha: 0.035),
    );
  }

  void _drawRehoboamContour(Canvas canvas, Offset center, double outerRadius) {
    final samples = 240;
    final baseRadius = outerRadius * 0.88;
    final severity = switch (tone) {
      AnimalStatusTone.loading => 0.016,
      AnimalStatusTone.empty => 0.01,
      AnimalStatusTone.error => 0.082,
    };
    final contour = <Offset>[];
    final radii = <double>[];
    final baseContour = <Offset>[];
    for (var i = 0; i <= samples; i += 1) {
      final t = i / samples;
      final angle = t * math.pi * 2;
      final deterministicNoise =
          math.sin(angle * 23.0 + 0.7) * 0.004 +
          math.sin(angle * 37.0 - 1.3) * 0.003 +
          math.sin(angle * 61.0 + 2.1) * 0.002;
      final wave =
          math.sin(angle * 5 + progress * math.pi * 2) * 0.006 +
          math.sin(angle * 9 - progress * math.pi * 1.4) * 0.009 +
          math.sin(angle * 14 + progress * math.pi * 0.8) * severity;
      final pulse = _raisedCosine(
        _angularDistance(angle, progress * math.pi * 2),
        tone == AnimalStatusTone.error ? 0.64 : 0.24,
      );
      final errorJitter = tone == AnimalStatusTone.error
          ? deterministicNoise +
                math.pow(
                      (math.sin(angle * 31.0 + progress * math.pi * 2.2) + 1) /
                          2,
                      10,
                    ) *
                    0.022
          : 0.0;
      final r =
          baseRadius +
          outerRadius * (wave + errorJitter + pulse * severity * 1.8);
      radii.add(r);
      final direction = Offset(math.cos(angle), math.sin(angle));
      final point = center + direction * r;
      contour.add(point);
      baseContour.add(
        center +
            direction *
                (tone == AnimalStatusTone.error
                    ? r
                    : baseRadius + outerRadius * deterministicNoise * 0.35),
      );
    }
    final path = _closedSmoothPath(contour);
    canvas.drawPath(
      tone == AnimalStatusTone.error
          ? _closedLinearPath(baseContour)
          : _closedSmoothPath(baseContour),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = tone == AnimalStatusTone.error ? 1.45 : 1.05
        ..color = const Color(
          0xFF111111,
        ).withValues(alpha: tone == AnimalStatusTone.error ? 0.42 : 0.3),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = tone == AnimalStatusTone.error ? 1.6 : 1.25
        ..color = const Color(
          0xFF111111,
        ).withValues(alpha: tone == AnimalStatusTone.loading ? 0.86 : 0.72),
    );
    _drawMountainWaveLayers(canvas, center, outerRadius, contour, radii);
  }

  void _drawMountainWaveLayers(
    Canvas canvas,
    Offset center,
    double outerRadius,
    List<Offset> contour,
    List<double> radii,
  ) {
    const layers = <_RehoboamWaveLayer>[
      _RehoboamWaveLayer(0.002, 0.038, 18, 50, 0.08, 0.18, 0.62, 1.1),
      _RehoboamWaveLayer(0.008, 0.052, 24, 66, -0.06, 0.13, 0.46, 0.95),
      _RehoboamWaveLayer(0.014, 0.068, 31, 84, 0.07, 0.10, 0.36, 0.82),
      _RehoboamWaveLayer(0.020, 0.082, 38, 108, -0.05, 0.08, 0.28, 0.7),
      _RehoboamWaveLayer(0.026, 0.118, 43, 132, 0.09, 0.05, 0.24, 0.64),
    ];
    final elapsed = progress * math.pi * 2;
    for (final layer in layers) {
      final crest = <Offset>[];
      final base = <Offset>[];
      for (var i = 0; i < radii.length; i += 1) {
        final angle = (i / (radii.length - 1)) * math.pi * 2;
        final carrier =
            0.4 + 0.6 * ((math.sin(angle * 7 + elapsed * 0.4) + 1) / 2);
        final waveA =
            (math.sin(angle * layer.frequencyA + elapsed * layer.drift) + 1) /
            2;
        final waveB =
            (math.sin(angle * layer.frequencyB - elapsed * layer.drift * 1.7) +
                1) /
            2;
        final pulse = _raisedCosine(
          _angularDistance(angle, progress * math.pi * 2),
          tone == AnimalStatusTone.error ? 0.34 : 0.2,
        );
        final ridge = math.pow(waveA, 4) * 0.46 + math.pow(waveB, 8) * 0.24;
        final errorNeedle = tone == AnimalStatusTone.error
            ? math.pow(math.max(waveA, waveB), 15) * 2.6
            : 0.0;
        final height =
            outerRadius *
            layer.amplitude *
            carrier *
            (ridge +
                errorNeedle +
                pulse * (tone == AnimalStatusTone.error ? 3.2 : 0.8));
        final baseRadius = radii[i] + outerRadius * layer.baseOffset;
        final crestRadius =
            baseRadius +
            math.min(
              outerRadius * (tone == AnimalStatusTone.error ? 0.22 : 0.12),
              height,
            );
        final direction = Offset(math.cos(angle), math.sin(angle));
        crest.add(center + direction * crestRadius);
        base.insert(0, center + direction * baseRadius);
      }
      final fill = Path()
        ..addPath(_openSmoothPath(crest), Offset.zero)
        ..lineTo(base.first.dx, base.first.dy)
        ..addPath(_openSmoothPath(base), Offset.zero)
        ..close();
      canvas.drawPath(
        fill,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color(0xFF101010).withValues(alpha: layer.fillAlpha),
      );
      canvas.drawPath(
        _closedSmoothPath(crest),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = layer.strokeWidth
          ..color = const Color(
            0xFF101010,
          ).withValues(alpha: layer.strokeAlpha),
      );
    }
  }

  void _drawToneGlyph(Canvas canvas, Offset center, double outerRadius) {
    canvas.drawCircle(
      center,
      outerRadius * 0.18,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6
        ..color = const Color(0xFF111111).withValues(alpha: 0.035),
    );
    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = line;
    switch (tone) {
      case AnimalStatusTone.loading:
        final angle = progress * math.pi * 2;
        final sweep =
            center +
            Offset(math.cos(angle), math.sin(angle)) * outerRadius * 0.29;
        canvas.drawLine(
          center,
          sweep,
          active..color = line.withValues(alpha: 0.72),
        );
        canvas.drawCircle(
          sweep,
          2,
          Paint()..color = line.withValues(alpha: 0.8),
        );
      case AnimalStatusTone.error:
        canvas.drawLine(
          center - Offset(outerRadius * 0.16, outerRadius * 0.16),
          center + Offset(outerRadius * 0.16, outerRadius * 0.16),
          active,
        );
        final textPainter = TextPainter(
          text: TextSpan(
            text: '!',
            style: TextStyle(
              color: line,
              fontSize: outerRadius * 0.36,
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
          ..strokeWidth = 1.2;
        canvas.drawLine(
          center - Offset(outerRadius * 0.16, 0),
          center + Offset(outerRadius * 0.16, 0),
          dash,
        );
    }
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    List<double> dash,
    double phase,
  ) {
    final total = dash.fold<double>(0, (sum, value) => sum + value);
    final circumference = math.pi * 2 * radius;
    final cycles = math.max(1, (circumference / total).floor());
    var offset = phase;
    for (var i = 0; i < cycles; i += 1) {
      final start = offset / radius;
      final sweep = dash.first / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
      offset += total;
    }
  }

  double _angularDistance(double a, double b) {
    final diff = (a - b).abs() % (math.pi * 2);
    return diff > math.pi ? math.pi * 2 - diff : diff;
  }

  double _raisedCosine(double distance, double window) {
    if (distance >= window) {
      return 0;
    }
    return 0.5 * (1 + math.cos(math.pi * distance / window));
  }

  Path _closedSmoothPath(List<Offset> points) {
    if (points.isEmpty) {
      return Path();
    }
    if (points.length < 3) {
      return Path()..addPolygon(points, true);
    }
    final path = Path();
    final firstMid = Offset.lerp(points.first, points[1], 0.5)!;
    path.moveTo(firstMid.dx, firstMid.dy);
    for (var i = 1; i < points.length; i += 1) {
      final current = points[i];
      final next = points[(i + 1) % points.length];
      final mid = Offset.lerp(current, next, 0.5)!;
      path.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
    }
    path.close();
    return path;
  }

  Path _closedLinearPath(List<Offset> points) {
    if (points.isEmpty) {
      return Path();
    }
    return Path()..addPolygon(points, true);
  }

  Path _openSmoothPath(List<Offset> points) {
    if (points.isEmpty) {
      return Path();
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    if (points.length < 3) {
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      return path;
    }
    for (var i = 1; i < points.length - 1; i += 1) {
      final current = points[i];
      final next = points[i + 1];
      final mid = Offset.lerp(current, next, 0.5)!;
      path.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);
    return path;
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

class _RehoboamRingSpec {
  const _RehoboamRingSpec(
    this.radius,
    this.width,
    this.alpha,
    this.dash,
    this.speed,
    this.phase,
  );

  final double radius;
  final double width;
  final double alpha;
  final List<double> dash;
  final double speed;
  final double phase;
}

class _RehoboamWaveLayer {
  const _RehoboamWaveLayer(
    this.baseOffset,
    this.amplitude,
    this.frequencyA,
    this.frequencyB,
    this.drift,
    this.fillAlpha,
    this.strokeAlpha,
    this.strokeWidth,
  );

  final double baseOffset;
  final double amplitude;
  final double frequencyA;
  final double frequencyB;
  final double drift;
  final double fillAlpha;
  final double strokeAlpha;
  final double strokeWidth;
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
