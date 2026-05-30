import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';
import 'animal_component_dispatcher.dart';
import 'guofeng_components.dart';
import 'nes_pixel_frame.dart';

class AnimalCollapse extends StatelessWidget {
  const AnimalCollapse({
    super.key,
    required this.question,
    required this.answer,
    this.defaultExpanded = false,
    this.enabled = true,
  });

  final Widget question;
  final Widget answer;
  final bool defaultExpanded;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimalComponentDispatcher.dispatch(
      context,
      animalIsland: (_) => _AnimalIslandCollapse(
        question: question,
        answer: answer,
        defaultExpanded: defaultExpanded,
        enabled: enabled,
      ),
      nes: (_) => _NesAnimalCollapse(
        question: question,
        answer: answer,
        defaultExpanded: defaultExpanded,
        enabled: enabled,
      ),
      westworld: (_) => _WestworldAnimalCollapse(
        question: question,
        answer: answer,
        defaultExpanded: defaultExpanded,
        enabled: enabled,
      ),
      guofeng: (_) => _GuofengAnimalCollapse(
        question: question,
        answer: answer,
        defaultExpanded: defaultExpanded,
        enabled: enabled,
      ),
    );
  }
}

class _AnimalIslandCollapse extends _ThemedAnimalCollapse {
  const _AnimalIslandCollapse({
    required super.question,
    required super.answer,
    required super.defaultExpanded,
    required super.enabled,
  }) : super(gameStyle: AnimalIslandGameStyle.animalIsland);
}

class _NesAnimalCollapse extends _ThemedAnimalCollapse {
  const _NesAnimalCollapse({
    required super.question,
    required super.answer,
    required super.defaultExpanded,
    required super.enabled,
  }) : super(gameStyle: AnimalIslandGameStyle.nes8Bit);
}

class _WestworldAnimalCollapse extends _ThemedAnimalCollapse {
  const _WestworldAnimalCollapse({
    required super.question,
    required super.answer,
    required super.defaultExpanded,
    required super.enabled,
  }) : super(gameStyle: AnimalIslandGameStyle.westworld);
}

class _GuofengAnimalCollapse extends _ThemedAnimalCollapse {
  const _GuofengAnimalCollapse({
    required super.question,
    required super.answer,
    required super.defaultExpanded,
    required super.enabled,
  }) : super(gameStyle: AnimalIslandGameStyle.guofengDoodle);
}

abstract class _ThemedAnimalCollapse extends StatefulWidget {
  const _ThemedAnimalCollapse({
    required this.gameStyle,
    required this.question,
    required this.answer,
    required this.defaultExpanded,
    required this.enabled,
  });

  final AnimalIslandGameStyle gameStyle;
  final Widget question;
  final Widget answer;
  final bool defaultExpanded;
  final bool enabled;

  @override
  State<_ThemedAnimalCollapse> createState() => _ThemedAnimalCollapseState();
}

class _ThemedAnimalCollapseState extends State<_ThemedAnimalCollapse> {
  late bool _expanded = widget.defaultExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final isGuofeng = widget.gameStyle == AnimalIslandGameStyle.guofengDoodle;
    final isNes = widget.gameStyle == AnimalIslandGameStyle.nes8Bit;

    final collapse = Opacity(
      opacity: widget.enabled ? 1 : 0.6,
      child: Stack(
        children: [
          if (isNes)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: NesPixelFramePainter(
                    palette: NesPixelFramePalette(
                      background: theme.surface,
                      border: _expanded ? theme.borderHover : theme.border,
                      shadow: theme.buttonShadow,
                      highlight: Colors.white,
                      lowlight: theme.borderLight,
                      accent: theme.borderHover,
                    ),
                    focused: _expanded,
                    texture: true,
                    pixel: 4,
                    compact: true,
                    reserveShadowSpace: false,
                    shadowOffset: const Offset(5, 5),
                  ),
                ),
              ),
            ),
          DecoratedBox(
            decoration: theme.isWestworld
                ? theme.westworldPanelDecoration(
                    color: theme.surface,
                    emphasized: _expanded,
                  )
                : isNes
                ? const BoxDecoration(color: Colors.transparent)
                : BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(theme.radiusBase),
                    border: Border.all(
                      color: isGuofeng ? Colors.transparent : theme.border,
                      width: theme.borderWidth,
                    ),
                  ),
            child: Column(
              children: [
                InkWell(
                  onTap: widget.enabled
                      ? () => setState(() => _expanded = !_expanded)
                      : null,
                  borderRadius: BorderRadius.circular(theme.radiusBase),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isGuofeng ? 18 : AnimalIslandTokens.spacingXl,
                      vertical: isGuofeng ? 14 : AnimalIslandTokens.spacingLg,
                    ),
                    child: Row(
                      children: [
                        _buildToggle(theme, isGuofeng),
                        const SizedBox(width: AnimalIslandTokens.spacingMd),
                        Expanded(
                          child: DefaultTextStyle(
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  fontSize: AnimalIslandTokens.fontBodyLg,
                                  color: theme.textPrimary,
                                  fontWeight: isGuofeng
                                      ? FontWeight.w700
                                      : null,
                                  letterSpacing: theme.isWestworld
                                      ? 0.75
                                      : null,
                                ),
                            child: widget.question,
                          ),
                        ),
                        if (theme.isWestworld)
                          AnimatedRotation(
                            turns: _expanded ? 0.5 : 0,
                            duration: theme.interactionDuration,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _expanded
                                  ? theme.primary
                                  : theme.textMuted,
                              size: 20,
                            ),
                          )
                        else if (isGuofeng)
                          AnimatedRotation(
                            turns: _expanded ? 0.5 : 0,
                            duration: theme.interactionDuration,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _expanded
                                  ? theme.primary
                                  : theme.textSecondary,
                              size: 20,
                            ),
                          )
                        else if (!theme.isNes)
                          AnimatedRotation(
                            turns: _expanded ? 0.125 : 0,
                            duration: AnimalIslandTokens.base,
                            child: Image.asset(
                              AnimalIslandAssets.iconLeaf,
                              package: AnimalIslandAssets.package,
                              width: 18,
                              height: 18,
                              opacity: AlwaysStoppedAnimation<double>(
                                _expanded ? 1 : 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: AnimalIslandTokens.motionCurve,
                  child: ClipRect(
                    child: Align(
                      heightFactor: _expanded ? 1 : 0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          isGuofeng ? 18 : AnimalIslandTokens.spacingXl,
                          0,
                          isGuofeng ? 18 : AnimalIslandTokens.spacingXl,
                          _expanded
                              ? (isGuofeng ? 18 : AnimalIslandTokens.spacingXl)
                              : 0,
                        ),
                        child: isGuofeng
                            ? DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: theme.border.withValues(
                                        alpha: 0.32,
                                      ),
                                      width: 1.2,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: DefaultTextStyle(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: theme.textBody,
                                          height: 1.7,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    child: widget.answer,
                                  ),
                                ),
                              )
                            : DefaultTextStyle(
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: theme.textSecondary,
                                      height: theme.isWestworld ? 1.36 : 1.7,
                                      letterSpacing: theme.isWestworld
                                          ? 0.35
                                          : null,
                                    ),
                                child: widget.answer,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isGuofeng)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: GuofengPaperTexturePainter(theme: theme, seed: 71),
                  foregroundPainter: GuofengInkOutlinePainter(
                    color: _expanded ? theme.primary : theme.border,
                    radius: theme.radiusBase,
                    strokeWidth: theme.borderWidth,
                    alpha: _expanded ? 0.9 : 0.72,
                    seed: 71,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    return isNes
        ? Padding(
            padding: const EdgeInsets.only(right: 5, bottom: 5),
            child: collapse,
          )
        : collapse;
  }

  Widget _buildToggle(AnimalIslandThemeData theme, bool isGuofeng) {
    if (isGuofeng) {
      return AnimatedContainer(
        duration: theme.interactionDuration,
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _expanded
              ? theme.primary.withValues(alpha: 0.18)
              : theme.surfaceRaised.withValues(alpha: 0.76),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _expanded ? theme.primary : theme.border,
            width: 1.7,
          ),
        ),
        alignment: Alignment.center,
        child: CustomPaint(
          size: const Size(16, 16),
          painter: _GuofengCollapseTogglePainter(
            expanded: _expanded,
            color: _expanded ? theme.primaryActive : theme.border,
          ),
        ),
      );
    }

    if (theme.isNes) {
      return SizedBox.square(
        dimension: 30,
        child: NesPixelFrame(
          palette: NesPixelFramePalette(
            background: _expanded ? theme.primary : theme.surfaceRaised,
            border: theme.border,
            shadow: theme.buttonShadow,
            highlight: Colors.white,
            lowlight: _expanded ? theme.primaryActive : theme.borderLight,
            accent: theme.borderHover,
          ),
          pressed: _expanded,
          texture: !_expanded,
          pixel: 3,
          compact: true,
          shadowOffset: const Offset(3, 3),
          child: Center(
            child: Text(
              _expanded ? '−' : '+',
              style: TextStyle(
                color: _expanded ? Colors.white : theme.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                height: 1,
              ),
            ),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: theme.interactionDuration,
      width: 28,
      height: 28,
      decoration: theme.isWestworld
          ? BoxDecoration(
              color: _expanded
                  ? theme.primary.withValues(alpha: 0.12)
                  : theme.surfaceRaised.withValues(alpha: 0.6),
              border: Border.all(
                color: _expanded ? theme.primary : theme.panelLineColor(),
              ),
            )
          : BoxDecoration(
              color: _expanded ? theme.primaryActive : theme.primary,
              shape: theme.isNes ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: theme.isNes
                  ? BorderRadius.circular(theme.radiusSm)
                  : null,
              border: theme.isNes
                  ? Border.all(color: theme.border, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: AnimalIslandTokens.fast,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: Text(
          _expanded ? '−' : '+',
          key: ValueKey<bool>(_expanded),
          style: TextStyle(
            color: theme.isWestworld ? theme.textPrimary : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _GuofengCollapseTogglePainter extends CustomPainter {
  const _GuofengCollapseTogglePainter({
    required this.expanded,
    required this.color,
  });

  final bool expanded;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    final y = size.height / 2;
    canvas.drawLine(Offset(2, y), Offset(size.width - 2, y - 0.6), paint);
    if (!expanded) {
      final x = size.width / 2;
      canvas.drawLine(
        Offset(x + 0.4, 2),
        Offset(x - 0.4, size.height - 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GuofengCollapseTogglePainter oldDelegate) {
    return oldDelegate.expanded != expanded || oldDelegate.color != color;
  }
}
