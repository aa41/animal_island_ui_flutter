import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../utils/animal_island_assets.dart';
import 'animal_badge.dart';
import 'animal_button.dart';
import 'animal_component_dispatcher.dart';
import 'guofeng_components.dart';

class AnimalLoadMoreFooter extends StatelessWidget {
  const AnimalLoadMoreFooter({
    super.key,
    this.state = AnimalLoadMoreState.idle,
    this.onLoadMore,
    this.idleText = 'Walk to the pier for more',
    this.loadingText = 'Kapp’n is bringing more stories...',
    this.noMoreText = 'That is all for today',
    this.errorText = 'The bottle message drifted away',
    this.retryText = 'Try again',
  });

  final AnimalLoadMoreState state;
  final Future<void> Function()? onLoadMore;
  final String idleText;
  final String loadingText;
  final String noMoreText;
  final String errorText;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandLoadMoreFooter(
        state: state,
        onLoadMore: onLoadMore,
        idleText: idleText,
        loadingText: loadingText,
        noMoreText: noMoreText,
        errorText: errorText,
        retryText: retryText,
      ),
      nes: (_) => _NesAnimalLoadMoreFooter(
        state: state,
        onLoadMore: onLoadMore,
        idleText: idleText,
        loadingText: loadingText,
        noMoreText: noMoreText,
        errorText: errorText,
        retryText: retryText,
      ),
      westworld: (_) => _WestworldThemedLoadMoreFooter(
        state: state,
        onLoadMore: onLoadMore,
        idleText: idleText,
        loadingText: loadingText,
        noMoreText: noMoreText,
        errorText: errorText,
        retryText: retryText,
      ),
      guofeng: (_) => _GuofengAnimalLoadMoreFooter(
        state: state,
        onLoadMore: onLoadMore,
        idleText: idleText,
        loadingText: loadingText,
        noMoreText: noMoreText,
        errorText: errorText,
        retryText: retryText,
      ),
    );
  }
}

class _AnimalIslandLoadMoreFooter extends _ThemedAnimalLoadMoreFooter {
  const _AnimalIslandLoadMoreFooter({
    required super.state,
    required super.onLoadMore,
    required super.idleText,
    required super.loadingText,
    required super.noMoreText,
    required super.errorText,
    required super.retryText,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalLoadMoreFooter extends _ThemedAnimalLoadMoreFooter {
  const _NesAnimalLoadMoreFooter({
    required super.state,
    required super.onLoadMore,
    required super.idleText,
    required super.loadingText,
    required super.noMoreText,
    required super.errorText,
    required super.retryText,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldThemedLoadMoreFooter extends _ThemedAnimalLoadMoreFooter {
  const _WestworldThemedLoadMoreFooter({
    required super.state,
    required super.onLoadMore,
    required super.idleText,
    required super.loadingText,
    required super.noMoreText,
    required super.errorText,
    required super.retryText,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalLoadMoreFooter extends _ThemedAnimalLoadMoreFooter {
  const _GuofengAnimalLoadMoreFooter({
    required super.state,
    required super.onLoadMore,
    required super.idleText,
    required super.loadingText,
    required super.noMoreText,
    required super.errorText,
    required super.retryText,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalLoadMoreFooter extends StatelessWidget {
  const _ThemedAnimalLoadMoreFooter({
    required this.gameStyle,
    required this.state,
    required this.onLoadMore,
    required this.idleText,
    required this.loadingText,
    required this.noMoreText,
    required this.errorText,
    required this.retryText,
  });

  final AnimalIslandGameStyle gameStyle;
  final AnimalLoadMoreState state;
  final Future<void> Function()? onLoadMore;
  final String idleText;
  final String loadingText;
  final String noMoreText;
  final String errorText;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    if (theme.isWestworld) {
      return _WestworldLoadMoreFooter(
        state: state,
        onLoadMore: onLoadMore,
        retryText: retryText,
      );
    }
    if (theme.isGuofengDoodle) {
      return _GuofengLoadMoreFooter(
        state: state,
        onLoadMore: onLoadMore,
        idleText: idleText,
        loadingText: loadingText,
        noMoreText: noMoreText,
        errorText: errorText,
        retryText: retryText,
      );
    }

    final label = switch (state) {
      AnimalLoadMoreState.loading => loadingText,
      AnimalLoadMoreState.noMore => noMoreText,
      AnimalLoadMoreState.error => errorText,
      AnimalLoadMoreState.idle => idleText,
    };

    final badgeLabel = switch (state) {
      AnimalLoadMoreState.loading => 'Sailing',
      AnimalLoadMoreState.noMore => 'Finished',
      AnimalLoadMoreState.error => 'Oops',
      AnimalLoadMoreState.idle => 'More',
    };

    final badgeColor = switch (state) {
      AnimalLoadMoreState.loading => theme.primary,
      AnimalLoadMoreState.noMore => theme.surfaceSoft,
      AnimalLoadMoreState.error => theme.error,
      AnimalLoadMoreState.idle => theme.focusYellow,
    };

    final badgeForeground = switch (state) {
      AnimalLoadMoreState.loading || AnimalLoadMoreState.error => Colors.white,
      _ => theme.textBody,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(theme.isNes ? theme.radiusSm : 24),
        border: Border.all(color: theme.borderLight, width: theme.borderWidth),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.surfaceRaised,
              shape: theme.isNes ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: theme.isNes
                  ? BorderRadius.circular(theme.radiusSm)
                  : null,
              border: Border.all(
                color: theme.borderLight,
                width: theme.isNes ? theme.borderWidth : 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: theme.isNes
                ? Text(
                    switch (state) {
                      AnimalLoadMoreState.loading => '...',
                      AnimalLoadMoreState.noMore => 'OK',
                      AnimalLoadMoreState.error => '!',
                      AnimalLoadMoreState.idle => '>',
                    },
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: theme.textPrimary),
                  )
                : Image.asset(
                    AnimalIslandAssets.iconLeaf,
                    package: AnimalIslandAssets.package,
                    width: 18,
                    height: 18,
                  ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: theme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (state == AnimalLoadMoreState.loading)
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                backgroundColor: theme.primarySoft,
              ),
            )
          else
            AnimalBadge(
              label: badgeLabel,
              backgroundColor: badgeColor,
              foregroundColor: badgeForeground,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          if (state == AnimalLoadMoreState.idle && onLoadMore != null)
            AnimalButton(
              type: AnimalButtonType.defaultType,
              size: AnimalButtonSize.small,
              onPressed: () => onLoadMore!.call(),
              child: const Text('Load More'),
            ),
          if (state == AnimalLoadMoreState.error && onLoadMore != null)
            AnimalButton(
              type: AnimalButtonType.primary,
              size: AnimalButtonSize.small,
              onPressed: () => onLoadMore!.call(),
              child: Text(retryText),
            ),
        ],
      ),
    );
  }
}

class _WestworldLoadMoreFooter extends StatefulWidget {
  const _WestworldLoadMoreFooter({
    required this.state,
    required this.onLoadMore,
    required this.retryText,
  });

  final AnimalLoadMoreState state;
  final Future<void> Function()? onLoadMore;
  final String retryText;

  @override
  State<_WestworldLoadMoreFooter> createState() =>
      _WestworldLoadMoreFooterState();
}

class _WestworldLoadMoreFooterState extends State<_WestworldLoadMoreFooter>
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
    final label = switch (widget.state) {
      AnimalLoadMoreState.loading => 'ACQUIRING NEXT VECTOR',
      AnimalLoadMoreState.noMore => 'TERMINAL BRANCH REACHED',
      AnimalLoadMoreState.error => 'DIVERGENCE INTERRUPTED',
      AnimalLoadMoreState.idle => 'EXTEND NARRATIVE RANGE',
    };
    final code = switch (widget.state) {
      AnimalLoadMoreState.loading => 'SYNC',
      AnimalLoadMoreState.noMore => 'END',
      AnimalLoadMoreState.error => 'ERR',
      AnimalLoadMoreState.idle => 'NEXT',
    };
    final accent = switch (widget.state) {
      AnimalLoadMoreState.error => theme.error,
      AnimalLoadMoreState.noMore => theme.textMuted,
      _ => theme.textPrimary,
    };

    return CustomPaint(
      painter: _WestworldLoadMoreFramePainter(
        state: widget.state,
        line: theme.panelLineColor(emphasized: true),
        accent: accent,
        surface: theme.surfaceRaised,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          runSpacing: 10,
          children: [
            SizedBox.square(
              dimension: 44,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => CustomPaint(
                  painter: _WestworldLoadMoreGlyphPainter(
                    state: widget.state,
                    progress: _controller.value,
                    color: accent,
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            Text(
              code,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
            if (widget.state == AnimalLoadMoreState.idle &&
                widget.onLoadMore != null)
              AnimalButton(
                type: AnimalButtonType.text,
                size: AnimalButtonSize.small,
                onPressed: () => widget.onLoadMore!.call(),
                child: const Text('QUERY'),
              ),
            if (widget.state == AnimalLoadMoreState.error &&
                widget.onLoadMore != null)
              AnimalButton(
                type: AnimalButtonType.text,
                size: AnimalButtonSize.small,
                danger: true,
                onPressed: () => widget.onLoadMore!.call(),
                child: Text(widget.retryText.toUpperCase()),
              ),
          ],
        ),
      ),
    );
  }
}

class _GuofengLoadMoreFooter extends StatefulWidget {
  const _GuofengLoadMoreFooter({
    required this.state,
    required this.onLoadMore,
    required this.idleText,
    required this.loadingText,
    required this.noMoreText,
    required this.errorText,
    required this.retryText,
  });

  final AnimalLoadMoreState state;
  final Future<void> Function()? onLoadMore;
  final String idleText;
  final String loadingText;
  final String noMoreText;
  final String errorText;
  final String retryText;

  @override
  State<_GuofengLoadMoreFooter> createState() => _GuofengLoadMoreFooterState();
}

class _GuofengLoadMoreFooterState extends State<_GuofengLoadMoreFooter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final label = switch (widget.state) {
      AnimalLoadMoreState.loading => '正在续写画卷...',
      AnimalLoadMoreState.noMore => '今日卷末已至',
      AnimalLoadMoreState.error => '墨迹中断，请重试',
      AnimalLoadMoreState.idle => '继续翻阅下一卷',
    };
    final accent = switch (widget.state) {
      AnimalLoadMoreState.error => theme.error,
      AnimalLoadMoreState.noMore => theme.success,
      AnimalLoadMoreState.loading => theme.primary,
      AnimalLoadMoreState.idle => theme.focusYellowDark,
    };

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.surface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(theme.radiusBase),
          ),
          child: CustomPaint(
            painter: GuofengPaperTexturePainter(theme: theme, seed: 117),
            foregroundPainter: GuofengInkOutlinePainter(
              color: accent,
              radius: theme.radiusBase,
              strokeWidth: theme.borderWidth,
              seed: 117,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 10,
                children: [
                  SizedBox.square(
                    dimension: 34,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) => CustomPaint(
                        painter: _GuofengLoadMoreGlyphPainter(
                          state: widget.state,
                          progress: _controller.value,
                          ink: theme.border,
                          accent: accent,
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (widget.state == AnimalLoadMoreState.idle &&
                      widget.onLoadMore != null)
                    AnimalButton(
                      type: AnimalButtonType.defaultType,
                      size: AnimalButtonSize.small,
                      onPressed: () => widget.onLoadMore!.call(),
                      child: const Text('Load More'),
                    ),
                  if (widget.state == AnimalLoadMoreState.error &&
                      widget.onLoadMore != null)
                    AnimalButton(
                      type: AnimalButtonType.primary,
                      size: AnimalButtonSize.small,
                      danger: true,
                      onPressed: () => widget.onLoadMore!.call(),
                      child: Text(widget.retryText),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GuofengLoadMoreGlyphPainter extends CustomPainter {
  const _GuofengLoadMoreGlyphPainter({
    required this.state,
    required this.progress,
    required this.ink,
    required this.accent,
  });

  final AnimalLoadMoreState state;
  final double progress;
  final Color ink;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = accent;
    canvas.drawCircle(
      center,
      size.shortestSide * 0.36,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = ink.withValues(alpha: 0.42),
    );
    switch (state) {
      case AnimalLoadMoreState.loading:
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: size.shortestSide * 0.36),
          progress * math.pi * 2,
          math.pi * 1.25,
          false,
          paint,
        );
      case AnimalLoadMoreState.noMore:
        canvas.drawPath(
          Path()
            ..moveTo(center.dx - 8, center.dy)
            ..lineTo(center.dx - 2, center.dy + 6)
            ..lineTo(center.dx + 9, center.dy - 7),
          paint,
        );
      case AnimalLoadMoreState.error:
        canvas.drawLine(
          center - const Offset(7, 7),
          center + const Offset(7, 7),
          paint,
        );
        canvas.drawLine(
          center + const Offset(7, -7),
          center - const Offset(7, -7),
          paint,
        );
      case AnimalLoadMoreState.idle:
        canvas.drawLine(
          center - const Offset(8, 0),
          center + const Offset(8, 0),
          paint,
        );
        canvas.drawLine(
          center + const Offset(8, 0),
          center + const Offset(2, -6),
          paint,
        );
        canvas.drawLine(
          center + const Offset(8, 0),
          center + const Offset(2, 6),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _GuofengLoadMoreGlyphPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.progress != progress ||
        oldDelegate.ink != ink ||
        oldDelegate.accent != accent;
  }
}

class _WestworldLoadMoreFramePainter extends CustomPainter {
  const _WestworldLoadMoreFramePainter({
    required this.state,
    required this.line,
    required this.accent,
    required this.surface,
  });

  final AnimalLoadMoreState state;
  final Color line;
  final Color accent;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final path = Path()
      ..moveTo(16, 0.5)
      ..lineTo(size.width - 16, 0.5)
      ..lineTo(size.width - 0.5, size.height / 2)
      ..lineTo(size.width - 16, size.height - 0.5)
      ..lineTo(16, size.height - 0.5)
      ..lineTo(0.5, size.height / 2)
      ..close();
    canvas.drawPath(path, Paint()..color = surface.withValues(alpha: 0.72));
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = line,
    );
    final y = size.height - 6;
    canvas.drawLine(
      Offset(24, y),
      Offset(size.width - 24, y),
      Paint()
        ..strokeWidth = 1
        ..color = accent.withValues(
          alpha: state == AnimalLoadMoreState.loading ? 0.42 : 0.14,
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldLoadMoreFramePainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.line != line ||
        oldDelegate.accent != accent ||
        oldDelegate.surface != surface;
  }
}

class _WestworldLoadMoreGlyphPainter extends CustomPainter {
  const _WestworldLoadMoreGlyphPainter({
    required this.state,
    required this.progress,
    required this.color,
  });

  final AnimalLoadMoreState state;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.43;
    final active = state == AnimalLoadMoreState.loading;
    final phase = progress * math.pi * 2;
    final pale = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFF111111).withValues(alpha: 0.07);
    for (var i = 1; i <= 4; i += 1) {
      canvas.drawCircle(center, radius * i / 4, pale);
    }
    final intensity = switch (state) {
      AnimalLoadMoreState.error => 0.16,
      AnimalLoadMoreState.loading => 0.08,
      _ => 0.045,
    };
    final baseRadius = radius * 0.84;
    final base = <Offset>[];
    final points = <Offset>[];
    for (var i = 0; i <= 96; i += 1) {
      final t = i / 96;
      final angle = t * math.pi * 2;
      final wave =
          math.sin(angle * 9 + phase) * intensity +
          math.sin(angle * 17 - phase * 0.7) * intensity * 0.62 +
          math.sin(angle * 31 + 0.8 + phase * 0.36) * intensity * 0.34;
      final pulse = _rehoboamPulse(
        angle,
        phase,
        state == AnimalLoadMoreState.error ? 0.54 : 0.34,
      );
      final r =
          baseRadius +
          radius *
              (wave +
                  pulse *
                      (active
                          ? 0.09
                          : state == AnimalLoadMoreState.error
                          ? 0.14
                          : 0.04));
      final direction = Offset(math.cos(angle), math.sin(angle));
      base.add(center + direction * baseRadius);
      points.add(center + direction * r);
    }
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = state == AnimalLoadMoreState.error ? 1.4 : 1.1
      ..color = color.withValues(
        alpha: state == AnimalLoadMoreState.noMore ? 0.38 : 0.78,
      );
    canvas.drawPath(
      Path()..addPolygon(base, true),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.85
        ..color = color.withValues(
          alpha: state == AnimalLoadMoreState.noMore ? 0.18 : 0.28,
        ),
    );
    canvas.drawPath(Path()..addPolygon(points, true), paint);
    if (state == AnimalLoadMoreState.error) {
      canvas.drawLine(
        center - Offset(radius * 0.38, radius * 0.38),
        center + Offset(radius * 0.38, radius * 0.38),
        paint,
      );
      return;
    }
    if (state == AnimalLoadMoreState.noMore) {
      canvas.drawCircle(
        center,
        2,
        Paint()..color = color.withValues(alpha: 0.45),
      );
      return;
    }
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.92),
      active ? phase : -math.pi / 2,
      active ? math.pi * 0.2 : math.pi * 0.42,
      false,
      paint,
    );
  }

  double _rehoboamPulse(double angle, double phase, double window) {
    final diff = (angle - phase).abs() % (math.pi * 2);
    final distance = diff > math.pi ? math.pi * 2 - diff : diff;
    if (distance >= window) {
      return 0;
    }
    return 0.5 * (1 + math.cos(math.pi * distance / window));
  }

  @override
  bool shouldRepaint(covariant _WestworldLoadMoreGlyphPainter oldDelegate) {
    return oldDelegate.state != state ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}
