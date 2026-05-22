import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '_animal_dashed_outline.dart';

class AnimalCard extends StatefulWidget {
  const AnimalCard({
    super.key,
    this.type = AnimalCardType.defaultType,
    this.color = 'default',
    this.padding,
    this.onTap,
    this.child,
  });

  final AnimalCardType type;
  final String color;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final background = theme.cardColors[widget.color] ?? theme.surfaceRaised;
    final foreground = theme.cardForeground(widget.color);

    final radius = theme.isNes
        ? BorderRadius.circular(theme.radiusBase)
        : switch (widget.type) {
            AnimalCardType.title => const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(35),
              bottomLeft: Radius.circular(38),
              bottomRight: Radius.circular(45),
            ),
            _ => BorderRadius.circular(20),
          };

    final padding =
        widget.padding ??
        switch (widget.type) {
          AnimalCardType.title => EdgeInsets.symmetric(
            horizontal: theme.isNes ? 22 : 32,
            vertical: 12,
          ),
          _ => EdgeInsets.symmetric(
            horizontal: theme.isNes ? 16 : 24,
            vertical: 16,
          ),
        };

    final dashedBorderColor = theme.borderLight.withValues(
      alpha: _hovered ? 0.9 : 0.7,
    );

    final card = Stack(
      children: [
        AnimatedContainer(
          duration: theme.isNes
              ? AnimalIslandTokens.pixelStep
              : AnimalIslandTokens.base,
          curve: theme.interactionCurve,
          transform: Matrix4.translationValues(
            0,
            _hovered && widget.type != AnimalCardType.dashed && !theme.isNes
                ? -4
                : 0,
            0,
          ),
          padding: padding,
          decoration: BoxDecoration(
            color: widget.type == AnimalCardType.dashed
                ? theme.surface.withValues(alpha: 0.92)
                : background,
            borderRadius: radius,
            border: theme.isNes
                ? Border.all(color: theme.border, width: theme.borderWidth)
                : null,
            boxShadow: widget.type == AnimalCardType.dashed
                ? null
                : [
                    BoxShadow(
                      color: theme.isNes
                          ? theme.buttonShadow
                          : const Color.fromRGBO(
                              107,
                              92,
                              67,
                              0.42,
                            ).withValues(alpha: _hovered ? 0.34 : 0.24),
                      blurRadius: theme.isNes ? 0 : (_hovered ? 20 : 10),
                      offset: Offset(0, theme.isNes ? 4 : (_hovered ? 8 : 4)),
                    ),
                  ],
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color:
                  widget.type == AnimalCardType.defaultType &&
                      widget.color == 'default'
                  ? theme.textBody
                  : foreground,
              fontWeight: widget.type == AnimalCardType.title
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
            child: widget.type == AnimalCardType.dashed
                ? Center(
                    widthFactor: widget.child == null ? 1 : null,
                    heightFactor: widget.child == null ? 1 : null,
                    child: widget.child ?? const SizedBox.shrink(),
                  )
                : widget.child ?? const SizedBox.shrink(),
          ),
        ),
        if (widget.type == AnimalCardType.dashed)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: AnimalDashedOutlinePainter(
                  color: dashedBorderColor,
                  radius: 20,
                  strokeWidth: theme.borderWidth,
                  dashLength: theme.isNes ? 4 : 7,
                  gapLength: theme.isNes ? 4 : 5,
                ),
              ),
            ),
          ),
      ],
    );

    if (widget.onTap == null) {
      return card;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      ),
    );
  }
}
