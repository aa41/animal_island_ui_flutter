import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/animal_island_models.dart';
import '../../theme/animal_island_theme.dart';
import '../../theme/animal_island_tokens.dart';

abstract final class AnimalSwitchThemeStrategy {
  const AnimalSwitchThemeStrategy();

  static AnimalSwitchThemeStrategy of(AnimalIslandThemeData theme) {
    return switch (theme.gameStyle) {
      AnimalIslandGameStyle.nes8Bit => const _NesAnimalSwitchThemeStrategy(),
      AnimalIslandGameStyle.westworld =>
        const _WestworldAnimalSwitchThemeStrategy(),
      AnimalIslandGameStyle.animalIsland =>
        const _AnimalIslandSwitchThemeStrategy(),
    };
  }

  Widget buildControl({
    required BuildContext context,
    required AnimalIslandThemeData theme,
    required bool checked,
    required bool enabled,
    required bool loading,
    required bool small,
    required Animation<double> progress,
    required Widget? checkedChild,
    required Widget? uncheckedChild,
    required VoidCallback onTap,
  });
}

final class _AnimalIslandSwitchThemeStrategy extends AnimalSwitchThemeStrategy {
  const _AnimalIslandSwitchThemeStrategy();

  @override
  Widget buildControl({
    required BuildContext context,
    required AnimalIslandThemeData theme,
    required bool checked,
    required bool enabled,
    required bool loading,
    required bool small,
    required Animation<double> progress,
    required Widget? checkedChild,
    required Widget? uncheckedChild,
    required VoidCallback onTap,
  }) {
    return _DefaultSwitchControl(
      theme: theme,
      checked: checked,
      enabled: enabled,
      loading: loading,
      small: small,
      progress: progress,
      checkedChild: checkedChild,
      uncheckedChild: uncheckedChild,
      onTap: onTap,
      nes: false,
    );
  }
}

final class _NesAnimalSwitchThemeStrategy extends AnimalSwitchThemeStrategy {
  const _NesAnimalSwitchThemeStrategy();

  @override
  Widget buildControl({
    required BuildContext context,
    required AnimalIslandThemeData theme,
    required bool checked,
    required bool enabled,
    required bool loading,
    required bool small,
    required Animation<double> progress,
    required Widget? checkedChild,
    required Widget? uncheckedChild,
    required VoidCallback onTap,
  }) {
    return _DefaultSwitchControl(
      theme: theme,
      checked: checked,
      enabled: enabled,
      loading: loading,
      small: small,
      progress: progress,
      checkedChild: checkedChild,
      uncheckedChild: uncheckedChild,
      onTap: onTap,
      nes: true,
    );
  }
}

final class _WestworldAnimalSwitchThemeStrategy extends AnimalSwitchThemeStrategy {
  const _WestworldAnimalSwitchThemeStrategy();

  @override
  Widget buildControl({
    required BuildContext context,
    required AnimalIslandThemeData theme,
    required bool checked,
    required bool enabled,
    required bool loading,
    required bool small,
    required Animation<double> progress,
    required Widget? checkedChild,
    required Widget? uncheckedChild,
    required VoidCallback onTap,
  }) {
    final textStyle = Theme.of(context).textTheme.labelMedium!.copyWith(
      color: theme.textPrimary.withValues(alpha: enabled ? 1 : 0.5),
      fontSize: small ? 9 : AnimalIslandTokens.fontMicro,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.9,
      height: 1,
    );
    return _WestworldSwitchControl(
      checked: checked,
      enabled: enabled,
      loading: loading,
      small: small,
      progress: progress,
      checkedChild: checkedChild,
      uncheckedChild: uncheckedChild,
      textStyle: textStyle,
      onTap: onTap,
      theme: theme,
    );
  }
}

class _DefaultSwitchControl extends StatelessWidget {
  const _DefaultSwitchControl({
    required this.theme,
    required this.checked,
    required this.enabled,
    required this.loading,
    required this.small,
    required this.progress,
    required this.checkedChild,
    required this.uncheckedChild,
    required this.onTap,
    required this.nes,
  });

  final AnimalIslandThemeData theme;
  final bool checked;
  final bool enabled;
  final bool loading;
  final bool small;
  final Animation<double> progress;
  final Widget? checkedChild;
  final Widget? uncheckedChild;
  final VoidCallback onTap;
  final bool nes;

  @override
  Widget build(BuildContext context) {
    final minWidth = small ? 38.0 : 52.0;
    final height = small ? 20.0 : 28.0;
    final knob = nes ? (small ? 14.0 : 20.0) : (small ? 14.0 : 21.0);
    final knobPadding = small ? 20.0 : 28.0;
    final horizontalTextPadding = small ? 6.0 : 8.0;
    final hasText = checkedChild != null || uncheckedChild != null;
    final disabled = !enabled;
    final textStyle = Theme.of(context).textTheme.labelMedium!.copyWith(
      color: Colors.white.withValues(alpha: disabled ? 0.5 : 1),
      fontSize: small ? 9 : AnimalIslandTokens.fontMicro,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.22,
      height: 1,
      shadows: const [
        Shadow(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(0, 1),
          blurRadius: 1,
        ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: IntrinsicWidth(
          child: AnimatedBuilder(
            animation: loading ? progress : kAlwaysDismissedAnimation,
            builder: (context, child) => AnimatedContainer(
              duration: theme.interactionDuration,
              curve: theme.interactionCurve,
              constraints: BoxConstraints(minWidth: minWidth),
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: _trackDecoration(theme, checked),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(width: minWidth - 4, height: height),
                  if (hasText)
                    Positioned.fill(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            checked ? horizontalTextPadding : knobPadding,
                            0,
                            checked ? knobPadding : horizontalTextPadding,
                            0,
                          ),
                          child: DefaultTextStyle(
                            style: textStyle,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            child: checked
                                ? checkedChild ?? const SizedBox.shrink()
                                : uncheckedChild ?? const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  AnimatedPositioned(
                    duration: theme.interactionDuration,
                    curve: theme.interactionCurve,
                    left: checked ? null : 0,
                    right: checked ? 0 : null,
                    top: small ? 1 : 2,
                    child: Transform.translate(
                      offset: const Offset(0, -1),
                      child: Container(
                        width: knob,
                        height: knob,
                        decoration: BoxDecoration(
                          color: theme.surfaceRaised,
                          shape: nes ? BoxShape.rectangle : BoxShape.circle,
                          borderRadius: nes
                              ? BorderRadius.circular(theme.radiusSm)
                              : null,
                          border: Border.all(
                            color: checked ? theme.success : theme.borderLight,
                            width: nes ? 3.0 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (checked
                                      ? theme.successActive
                                      : theme.buttonShadow)
                                  .withValues(alpha: 0.2),
                              blurRadius: 0,
                              offset: Offset(0, small ? 2 : 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: loading
                              ? (nes
                                    ? _NesSwitchLoading(
                                        controller: progress,
                                        color: checked
                                            ? theme.success
                                            : theme.textSecondary,
                                      )
                                    : RotationTransition(
                                        turns: progress,
                                        child: SizedBox(
                                          width: 11,
                                          height: 11,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: checked
                                                ? theme.success
                                                : theme.textSecondary,
                                          ),
                                        ),
                                      ))
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _trackDecoration(AnimalIslandThemeData theme, bool checked) {
    return BoxDecoration(
      color: checked
          ? (nes ? theme.success : const Color(0xFF86D67A))
          : (nes ? theme.surfaceMuted : const Color(0xFFD4C9B4)),
      borderRadius: BorderRadius.circular(theme.radiusPill),
      border: Border.all(
        color: checked ? theme.success : theme.border,
        width: theme.inputBorderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: (checked ? theme.successActive : theme.textMuted).withValues(
            alpha: 0.2,
          ),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

class _NesSwitchLoading extends StatelessWidget {
  const _NesSwitchLoading({required this.controller, required this.color});

  final Animation<double> controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final frame = (controller.value * 4).floor() % 4;
        return SizedBox(
          width: 12,
          height: 12,
          child: CustomPaint(
            painter: _NesSwitchLoadingPainter(frame: frame, color: color),
          ),
        );
      },
    );
  }
}

class _WestworldSwitchControl extends StatelessWidget {
  const _WestworldSwitchControl({
    required this.checked,
    required this.enabled,
    required this.loading,
    required this.small,
    required this.progress,
    required this.checkedChild,
    required this.uncheckedChild,
    required this.textStyle,
    required this.onTap,
    required this.theme,
  });

  final bool checked;
  final bool enabled;
  final bool loading;
  final bool small;
  final Animation<double> progress;
  final Widget? checkedChild;
  final Widget? uncheckedChild;
  final TextStyle textStyle;
  final VoidCallback onTap;
  final AnimalIslandThemeData theme;

  @override
  Widget build(BuildContext context) {
    final width = small ? 96.0 : 118.0;
    final labelLeft = small ? 55.0 : 62.0;
    const touchHeight = 44.0;
    final label = checked
        ? checkedChild ?? const Text('ON')
        : uncheckedChild ?? const Text('OFF');
    return Semantics(
      button: true,
      toggled: checked,
      enabled: enabled && !loading,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Opacity(
          opacity: enabled ? 1 : 0.46,
          child: AnimatedBuilder(
            animation: progress,
            builder: (context, child) => SizedBox(
              width: width,
              height: touchHeight,
              child: CustomPaint(
                painter: _WestworldSwitchControlPainter(
                  checked: checked,
                  loading: loading,
                  progress: progress.value,
                  line: theme.textPrimary,
                  surface: theme.surfaceRaised,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: labelLeft, right: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DefaultTextStyle(
                      style: textStyle.copyWith(
                        color: textStyle.color?.withValues(
                          alpha: checked ? 0.88 : 0.52,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: label,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WestworldSwitchControlPainter extends CustomPainter {
  const _WestworldSwitchControlPainter({
    required this.checked,
    required this.loading,
    required this.progress,
    required this.line,
    required this.surface,
  });

  final bool checked;
  final bool loading;
  final double progress;
  final Color line;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final center = size.center(Offset.zero);
    final y = center.dy;
    final start = 8.0;
    final end = math.min(size.width - 48, 42.0);
    final stateT = checked ? 1.0 : 0.0;
    final cursorX = start + (end - start) * stateT;
    final sweepT = loading ? progress : stateT;
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square
      ..color = line.withValues(alpha: checked ? 0.82 : 0.32);

    canvas.drawLine(Offset(start, y), Offset(end, y), base);
    if (!checked) {
      canvas.drawLine(
        Offset(end + 5, y),
        Offset(end + 17, y),
        Paint()
          ..strokeWidth = 1
          ..color = line.withValues(alpha: 0.12),
      );
    }

    canvas.drawCircle(
      Offset(cursorX, y),
      10.5,
      Paint()
        ..style = PaintingStyle.fill
        ..color = surface.withValues(alpha: 0.96),
    );
    canvas.drawCircle(
      Offset(cursorX, y),
      10.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = line.withValues(alpha: checked ? 0.18 : 0.12),
    );
    canvas.drawCircle(
      Offset(cursorX, y),
      7,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6
        ..color = line.withValues(alpha: checked ? 0.1 : 0.06),
    );

    if (loading) {
      final scanX = start + (end - start) * sweepT;
      canvas.drawLine(
        Offset(scanX, y - 13),
        Offset(scanX, y + 13),
        Paint()
          ..strokeWidth = 1
          ..color = line.withValues(alpha: 0.28),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WestworldSwitchControlPainter oldDelegate) {
    return oldDelegate.checked != checked ||
        oldDelegate.loading != loading ||
        oldDelegate.progress != progress ||
        oldDelegate.line != line ||
        oldDelegate.surface != surface;
  }
}

class _NesSwitchLoadingPainter extends CustomPainter {
  const _NesSwitchLoadingPainter({required this.frame, required this.color});

  final int frame;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const block = 4.0;
    final positions = <Offset>[
      const Offset(4, 0),
      const Offset(8, 4),
      const Offset(4, 8),
      const Offset(0, 4),
    ];
    for (var i = 0; i < positions.length; i += 1) {
      final active = i == frame;
      canvas.drawRect(
        Rect.fromLTWH(
          positions[i].dx,
          positions[i].dy,
          active ? block : block - 1,
          active ? block : block - 1,
        ),
        paint..color = color.withValues(alpha: active ? 1 : 0.35),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NesSwitchLoadingPainter oldDelegate) {
    return oldDelegate.frame != frame || oldDelegate.color != color;
  }
}

class _WestworldSwitchLoading extends StatelessWidget {
  const _WestworldSwitchLoading({
    required this.controller,
    required this.color,
  });

  final Animation<double> controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => SizedBox(
        width: 12,
        height: 12,
        child: CustomPaint(
          painter: _WestworldSwitchLoadingPainter(
            progress: controller.value,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _WestworldSwitchLoadingPainter extends CustomPainter {
  const _WestworldSwitchLoadingPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final center = size.center(Offset.zero);
    final x = 2 + (size.width - 4) * progress;
    canvas.drawLine(
      Offset(2, center.dy),
      Offset(size.width - 2, center.dy),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color.withValues(alpha: 0.28),
    );
    canvas.drawLine(
      Offset(x, 2),
      Offset(x, size.height - 2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color.withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldSwitchLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
