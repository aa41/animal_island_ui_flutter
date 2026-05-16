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

    final radius = switch (widget.type) {
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
          AnimalCardType.title => const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 12,
          ),
          _ => const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        };

    final dashedBorderColor = theme.borderLight.withValues(
      alpha: _hovered ? 0.9 : 0.7,
    );

    final card = Stack(
      children: [
        AnimatedContainer(
          duration: AnimalIslandTokens.base,
          curve: AnimalIslandTokens.motionCurve,
          transform: Matrix4.translationValues(
            0,
            _hovered && widget.type != AnimalCardType.dashed ? -4 : 0,
            0,
          ),
          padding: padding,
          decoration: BoxDecoration(
            color: widget.type == AnimalCardType.dashed
                ? theme.surface.withValues(alpha: 0.92)
                : background,
            borderRadius: radius,
            boxShadow: widget.type == AnimalCardType.dashed
                ? null
                : [
                    BoxShadow(
                      color: const Color.fromRGBO(
                        107,
                        92,
                        67,
                        0.42,
                      ).withValues(alpha: _hovered ? 0.34 : 0.24),
                      blurRadius: _hovered ? 20 : 10,
                      offset: Offset(0, _hovered ? 8 : 4),
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
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ),
        if (widget.type == AnimalCardType.dashed)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: AnimalDashedOutlinePainter(
                  color: dashedBorderColor,
                  radius: 20,
                  strokeWidth: 2,
                  dashLength: 7,
                  gapLength: 5,
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
