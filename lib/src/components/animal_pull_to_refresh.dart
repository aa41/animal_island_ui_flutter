import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';
import 'animal_badge.dart';

class AnimalPullToRefresh extends StatefulWidget {
  const AnimalPullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.notificationPredicate = _defaultRefreshNotificationPredicate,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.pullText = 'Pull to refresh the island',
    this.releaseText = 'Release to catch fresh updates',
    this.refreshingText = 'Tom Nook is tidying the beach...',
    this.completeText = 'Fresh island news just arrived',
  });

  final RefreshCallback onRefresh;
  final Widget child;
  final ScrollNotificationPredicate notificationPredicate;
  final RefreshIndicatorTriggerMode triggerMode;
  final String pullText;
  final String releaseText;
  final String refreshingText;
  final String completeText;

  @override
  State<AnimalPullToRefresh> createState() => _AnimalPullToRefreshState();
}

bool _defaultRefreshNotificationPredicate(ScrollNotification notification) {
  return notification.metrics.axis == Axis.vertical;
}

class _AnimalPullToRefreshState extends State<AnimalPullToRefresh> {
  static const double _triggerDistance = 92;
  static const double _maxVisibleDistance = 132;

  Timer? _hideTimer;
  late final ValueNotifier<_AnimalRefreshVisualState> _visualNotifier =
      ValueNotifier<_AnimalRefreshVisualState>(
        const _AnimalRefreshVisualState(stage: _AnimalRefreshStage.idle),
      );
  bool _refreshing = false;

  @override
  void dispose() {
    _hideTimer?.cancel();
    _visualNotifier.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification) ||
        notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (_refreshing) {
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      if (notification.dragDetails != null) {
        _handlePull(notification.metrics);
      } else if (_visualNotifier.value.stage != _AnimalRefreshStage.idle) {
        _settleOrReset();
      }
      return false;
    }

    if (notification is OverscrollNotification) {
      if (notification.dragDetails != null && notification.overscroll < 0) {
        _handlePull(notification.metrics);
      }
      return false;
    }

    if (notification is ScrollEndNotification) {
      _settleOrReset();
    }

    return false;
  }

  void _handlePull(ScrollMetrics metrics) {
    _hideTimer?.cancel();
    final pullDistance = math.min(
      (metrics.minScrollExtent - metrics.pixels).clamp(0.0, double.infinity),
      _maxVisibleDistance,
    );

    if (pullDistance <= 0) {
      if (_visualNotifier.value.stage != _AnimalRefreshStage.idle) {
        _setVisualState(
          const _AnimalRefreshVisualState(stage: _AnimalRefreshStage.idle),
        );
      }
      return;
    }

    final progress = (pullDistance / _triggerDistance).clamp(0.0, 1.0);
    final stage = progress >= 1
        ? _AnimalRefreshStage.armed
        : _AnimalRefreshStage.pulling;
    _setVisualState(
      _AnimalRefreshVisualState(stage: stage, progress: progress),
    );
  }

  void _settleOrReset() {
    if (_refreshing) {
      return;
    }

    if (_visualNotifier.value.stage == _AnimalRefreshStage.armed) {
      unawaited(_startRefresh());
      return;
    }

    _setVisualState(
      const _AnimalRefreshVisualState(stage: _AnimalRefreshStage.idle),
    );
  }

  Future<void> _startRefresh() async {
    _hideTimer?.cancel();
    _refreshing = true;
    _setVisualState(
      const _AnimalRefreshVisualState(
        stage: _AnimalRefreshStage.refreshing,
        progress: 1,
      ),
    );

    try {
      await widget.onRefresh();
    } finally {
      _refreshing = false;
      if (mounted) {
        _setVisualState(
          const _AnimalRefreshVisualState(
            stage: _AnimalRefreshStage.done,
            progress: 1,
          ),
        );
        _hideTimer = Timer(const Duration(milliseconds: 750), () {
          if (!mounted) {
            return;
          }
          _setVisualState(
            const _AnimalRefreshVisualState(stage: _AnimalRefreshStage.idle),
          );
        });
      }
    }
  }

  void _setVisualState(_AnimalRefreshVisualState next) {
    final current = _visualNotifier.value;
    if (current.stage == next.stage && current.progress == next.progress) {
      return;
    }
    _visualNotifier.value = next;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: RepaintBoundary(child: widget.child),
          ),
        ),
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: RepaintBoundary(
              child: ValueListenableBuilder<_AnimalRefreshVisualState>(
                valueListenable: _visualNotifier,
                builder: (context, visual, child) {
                  final showIndicator =
                      visual.stage != _AnimalRefreshStage.idle;
                  final visibleProgress = switch (visual.stage) {
                    _AnimalRefreshStage.idle => 0.0,
                    _AnimalRefreshStage.done ||
                    _AnimalRefreshStage.refreshing => 1.0,
                    _ => math.max(visual.progress, 0.22),
                  };
                  return Align(
                    child: AnimatedSlide(
                      duration: AnimalIslandTokens.base,
                      offset: showIndicator
                          ? Offset.zero
                          : const Offset(0, -0.4),
                      curve: AnimalIslandTokens.motionCurve,
                      child: AnimatedOpacity(
                        duration: AnimalIslandTokens.base,
                        opacity: showIndicator ? 1 : 0,
                        child: Transform.translate(
                          offset: Offset(0, -20 * (1 - visibleProgress)),
                          child: _AnimalRefreshIndicator(
                            stage: visual.stage,
                            progress: visual.progress,
                            pullText: widget.pullText,
                            releaseText: widget.releaseText,
                            refreshingText: widget.refreshingText,
                            completeText: widget.completeText,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimalRefreshIndicator extends StatelessWidget {
  const _AnimalRefreshIndicator({
    required this.stage,
    required this.progress,
    required this.pullText,
    required this.releaseText,
    required this.refreshingText,
    required this.completeText,
  });

  final _AnimalRefreshStage stage;
  final double progress;
  final String pullText;
  final String releaseText;
  final String refreshingText;
  final String completeText;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    if (theme.isWestworld) {
      return _WestworldRefreshIndicator(stage: stage, progress: progress);
    }

    final label = switch (stage) {
      _AnimalRefreshStage.armed => releaseText,
      _AnimalRefreshStage.refreshing => refreshingText,
      _AnimalRefreshStage.done => completeText,
      _ => pullText,
    };

    final badgeLabel = switch (stage) {
      _AnimalRefreshStage.armed => 'Ready',
      _AnimalRefreshStage.refreshing => 'Now',
      _AnimalRefreshStage.done => 'Done',
      _ => '${(progress * 100).round()}%',
    };

    final badgeColor = switch (stage) {
      _AnimalRefreshStage.done => theme.success,
      _AnimalRefreshStage.refreshing => theme.primary,
      _AnimalRefreshStage.armed => theme.focusYellow,
      _ => theme.surfaceSoft,
    };

    final badgeForeground = switch (stage) {
      _AnimalRefreshStage.done ||
      _AnimalRefreshStage.refreshing => Colors.white,
      _ => theme.textBody,
    };
    final iconScale = stage == _AnimalRefreshStage.refreshing
        ? 1.0
        : 0.88 + (progress * 0.22);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.surfaceRaised,
        borderRadius: BorderRadius.circular(theme.isNes ? theme.radiusSm : 32),
        border: Border.all(color: theme.border, width: theme.borderWidth),
        boxShadow: [
          BoxShadow(
            color: theme.buttonShadow.withValues(alpha: 0.28),
            blurRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: theme.surface,
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
              child: Transform.scale(
                scale: iconScale,
                child: theme.isNes
                    ? Text(
                        stage == _AnimalRefreshStage.done ? 'OK' : '>',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: theme.textPrimary),
                      )
                    : Image.asset(
                        AnimalIslandAssets.iconLeaf,
                        package: AnimalIslandAssets.package,
                        width: 18,
                        height: 18,
                      ),
              ),
            ),
            const SizedBox(width: AnimalIslandTokens.spacingMd),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AnimalIslandTokens.spacingMd),
            if (stage == _AnimalRefreshStage.refreshing)
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WestworldRefreshIndicator extends StatefulWidget {
  const _WestworldRefreshIndicator({
    required this.stage,
    required this.progress,
  });

  final _AnimalRefreshStage stage;
  final double progress;

  @override
  State<_WestworldRefreshIndicator> createState() =>
      _WestworldRefreshIndicatorState();
}

class _WestworldRefreshIndicatorState extends State<_WestworldRefreshIndicator>
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
    final label = switch (widget.stage) {
      _AnimalRefreshStage.armed => 'RELEASE TO ACQUIRE SIGNAL',
      _AnimalRefreshStage.refreshing => 'SYNCHRONIZING NARRATIVE STREAM',
      _AnimalRefreshStage.done => 'SIGNAL LOCKED',
      _ => 'PULL TO SAMPLE VECTOR',
    };
    final code = switch (widget.stage) {
      _AnimalRefreshStage.armed => 'ARMED',
      _AnimalRefreshStage.refreshing => 'SYNC',
      _AnimalRefreshStage.done => 'LOCK',
      _ => '${(widget.progress * 100).round().toString().padLeft(2, '0')}%',
    };
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFFEFEFED)),
      child: CustomPaint(
        painter: _WestworldRefreshFramePainter(
          progress: widget.progress,
          active: widget.stage == _AnimalRefreshStage.refreshing,
          line: theme.panelLineColor(emphasized: true),
          accent: theme.textPrimary,
          surface: theme.surfaceRaised,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 16, 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 44,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => CustomPaint(
                    painter: _WestworldRefreshGlyphPainter(
                      progress: widget.stage == _AnimalRefreshStage.refreshing
                          ? _controller.value
                          : widget.progress,
                      active: widget.stage == _AnimalRefreshStage.refreshing,
                      line: theme.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: theme.textPrimary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                code,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: theme.textMuted,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WestworldRefreshFramePainter extends CustomPainter {
  const _WestworldRefreshFramePainter({
    required this.progress,
    required this.active,
    required this.line,
    required this.accent,
    required this.surface,
  });

  final double progress;
  final bool active;
  final Color line;
  final Color accent;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEFEFED),
    );
    final trackStart = Offset(66, size.height - 7);
    final trackEnd = Offset(size.width - 18, size.height - 7);
    canvas.drawLine(
      trackStart,
      trackEnd,
      Paint()
        ..strokeWidth = 1
        ..color = accent.withValues(alpha: 0.12),
    );
    canvas.drawLine(
      trackStart,
      Offset.lerp(trackStart, trackEnd, progress.clamp(0, 1))!,
      Paint()
        ..strokeWidth = 1
        ..color = accent.withValues(alpha: active ? 0.56 : 0.34),
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldRefreshFramePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.active != active ||
        oldDelegate.line != line ||
        oldDelegate.accent != accent ||
        oldDelegate.surface != surface;
  }
}

class _WestworldRefreshGlyphPainter extends CustomPainter {
  const _WestworldRefreshGlyphPainter({
    required this.progress,
    required this.active,
    required this.line,
  });

  final double progress;
  final bool active;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.45;
    final pale = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFF111111).withValues(alpha: 0.07);
    for (var i = 1; i <= 4; i += 1) {
      canvas.drawCircle(center, radius * i / 4, pale);
    }
    final baseRadius = radius * 0.86;
    final phase = progress * math.pi * 2;
    final baseContour = <Offset>[];
    final outer = <Offset>[];
    for (var i = 0; i <= 96; i += 1) {
      final t = i / 96;
      final angle = t * math.pi * 2;
      final wave =
          math.sin(angle * 9 + phase) * (active ? 0.05 : 0.025) +
          math.sin(angle * 17 - phase * 0.72) * (active ? 0.034 : 0.014) +
          math.sin(angle * 31 + phase * 0.36) * (active ? 0.018 : 0.008);
      final sweep = _rehoboamPulse(angle, phase, active ? 0.38 : 0.18);
      final r = baseRadius + radius * (wave + sweep * (active ? 0.09 : 0.04));
      final direction = Offset(math.cos(angle), math.sin(angle));
      baseContour.add(center + direction * baseRadius);
      outer.add(center + direction * r);
    }
    canvas.drawPath(
      Path()..addPolygon(baseContour, true),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = const Color(0xFF111111).withValues(alpha: 0.28),
    );
    canvas.drawPath(
      Path()..addPolygon(outer, true),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = active ? 1.35 : 1.05
        ..color = const Color(
          0xFF111111,
        ).withValues(alpha: active ? 0.82 : 0.7),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.92),
      phase,
      math.pi * 0.18,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFF111111).withValues(alpha: 0.42),
    );
  }

  double _rehoboamPulse(double angle, double phase, double window) {
    final diff = ((angle - phase).abs()) % (math.pi * 2);
    final distance = diff > math.pi ? math.pi * 2 - diff : diff;
    if (distance >= window) {
      return 0;
    }
    return 0.5 * (1 + math.cos(math.pi * distance / window));
  }

  @override
  bool shouldRepaint(covariant _WestworldRefreshGlyphPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.active != active ||
        oldDelegate.line != line;
  }
}

enum _AnimalRefreshStage { idle, pulling, armed, refreshing, done }

class _AnimalRefreshVisualState {
  const _AnimalRefreshVisualState({required this.stage, this.progress = 0});

  final _AnimalRefreshStage stage;
  final double progress;
}
