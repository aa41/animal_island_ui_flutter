import 'package:flutter/material.dart';

import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';

class AnimalCollapse extends StatefulWidget {
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
  State<AnimalCollapse> createState() => _AnimalCollapseState();
}

class _AnimalCollapseState extends State<AnimalCollapse> {
  late bool _expanded = widget.defaultExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;

    return Opacity(
      opacity: widget.enabled ? 1 : 0.6,
      child: DecoratedBox(
        decoration: theme.isWestworld
            ? theme.westworldPanelDecoration(
                color: theme.surface,
                emphasized: _expanded,
              )
            : BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(theme.radiusBase),
                border: Border.all(
                  color: theme.border,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: AnimalIslandTokens.spacingXl,
                  vertical: AnimalIslandTokens.spacingLg,
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: theme.interactionDuration,
                      width: 28,
                      height: 28,
                      decoration: theme.isWestworld
                          ? BoxDecoration(
                              color: _expanded
                                  ? theme.primary.withValues(alpha: 0.12)
                                  : theme.surfaceRaised.withValues(alpha: 0.6),
                              border: Border.all(
                                color: _expanded
                                    ? theme.primary
                                    : theme.panelLineColor(),
                              ),
                            )
                          : BoxDecoration(
                              color: _expanded
                                  ? theme.primaryActive
                                  : theme.primary,
                              shape: theme.isNes
                                  ? BoxShape.rectangle
                                  : BoxShape.circle,
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
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        ),
                        child: Text(
                          _expanded ? '−' : '+',
                          key: ValueKey<bool>(_expanded),
                          style: TextStyle(
                            color: theme.isWestworld
                                ? theme.textPrimary
                                : Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AnimalIslandTokens.spacingMd),
                    Expanded(
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              fontSize: AnimalIslandTokens.fontBodyLg,
                              color: theme.textPrimary,
                              letterSpacing: theme.isWestworld ? 0.75 : null,
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
                          color: _expanded ? theme.primary : theme.textMuted,
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
                      AnimalIslandTokens.spacingXl,
                      0,
                      AnimalIslandTokens.spacingXl,
                      _expanded ? AnimalIslandTokens.spacingXl : 0,
                    ),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: theme.textSecondary,
                        height: theme.isWestworld ? 1.36 : 1.7,
                        letterSpacing: theme.isWestworld ? 0.35 : null,
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
    );
  }
}
