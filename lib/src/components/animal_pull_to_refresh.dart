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

enum _AnimalRefreshStage { idle, pulling, armed, refreshing, done }

class _AnimalRefreshVisualState {
  const _AnimalRefreshVisualState({required this.stage, this.progress = 0});

  final _AnimalRefreshStage stage;
  final double progress;
}
