import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
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

class _AnimalCardState extends State<AnimalCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _westworldController;

  @override
  void initState() {
    super.initState();
    _westworldController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
  }

  @override
  void dispose() {
    _westworldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final background = theme.cardColors[widget.color] ?? theme.surfaceRaised;
    final foreground = theme.cardForeground(widget.color);

    final radius = switch (widget.type) {
      AnimalCardType.title => theme.spec.cardTitleRadius,
      _ => theme.spec.cardRadius,
    };

    final padding =
        widget.padding ??
        switch (widget.type) {
          AnimalCardType.title => EdgeInsets.symmetric(
            horizontal: theme.isNes
                ? 22
                : theme.isWestworld
                ? 22
                : 32,
            vertical: 12,
          ),
          _ => EdgeInsets.symmetric(
            horizontal: theme.isNes
                ? 16
                : theme.isWestworld
                ? 18
                : 24,
            vertical: 16,
          ),
        };

    final dashedBorderColor = theme.borderLight.withValues(
      alpha: _hovered ? 0.9 : 0.7,
    );

    final card = Stack(
      children: [
        AnimatedContainer(
          duration: theme.interactionDuration,
          curve: theme.interactionCurve,
          transform: Matrix4.translationValues(
            0,
            _hovered &&
                    widget.type != AnimalCardType.dashed &&
                    theme.spec.isOrganic
                ? -4
                : 0,
            0,
          ),
          padding: padding,
          decoration: _cardDecoration(
            theme: theme,
            background: background,
            radius: radius,
            hovered: _hovered,
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
            child: theme.isWestworld
                ? _WestworldCardFrame(
                    lineColor: theme.panelLineColor(
                      hovered: _hovered,
                      emphasized: widget.type == AnimalCardType.title,
                    ),
                    animation: _westworldController,
                    hovered: _hovered,
                    child: _cardChild,
                  )
                : _cardChild,
          ),
        ),
        if (widget.type == AnimalCardType.dashed)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: AnimalDashedOutlinePainter(
                  color: dashedBorderColor,
                  radius: theme.isWestworld ? 0 : 20,
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

  Widget get _cardChild {
    if (widget.type != AnimalCardType.dashed) {
      return widget.child ?? const SizedBox.shrink();
    }

    return Center(
      widthFactor: widget.child == null ? 1 : null,
      heightFactor: widget.child == null ? 1 : null,
      child: widget.child ?? const SizedBox.shrink(),
    );
  }

  BoxDecoration _cardDecoration({
    required AnimalIslandThemeData theme,
    required Color background,
    required BorderRadius radius,
    required bool hovered,
  }) {
    if (theme.isWestworld) {
      return theme.westworldPanelDecoration(
        color: widget.type == AnimalCardType.dashed
            ? theme.surface.withValues(alpha: 0.58)
            : background,
        hovered: hovered,
        emphasized: widget.type == AnimalCardType.title,
      );
    }

    return BoxDecoration(
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
                      ).withValues(alpha: hovered ? 0.34 : 0.24),
                blurRadius: theme.isNes ? 0 : (hovered ? 20 : 10),
                offset: Offset(0, theme.isNes ? 4 : (hovered ? 8 : 4)),
              ),
            ],
    );
  }
}

class _WestworldCardFrame extends StatelessWidget {
  const _WestworldCardFrame({
    required this.lineColor,
    required this.animation,
    required this.hovered,
    required this.child,
  });

  final Color lineColor;
  final Animation<double> animation;
  final bool hovered;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => CustomPaint(
        foregroundPainter: _WestworldCardPerspectivePainter(
          progress: animation.value,
          lineColor: lineColor,
          hovered: hovered,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 5),
          child: child,
        ),
      ),
    );
  }
}

class _WestworldCardPerspectivePainter extends CustomPainter {
  const _WestworldCardPerspectivePainter({
    required this.progress,
    required this.lineColor,
    required this.hovered,
  });

  final double progress;
  final Color lineColor;
  final bool hovered;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }
    final alpha = hovered ? 0.72 : 0.42;
    final basePaint = Paint()
      ..strokeWidth = 1
      ..color = lineColor.withValues(alpha: alpha);
    const topLength = 50.0;
    const sideLength = 18.0;
    canvas.drawLine(Offset.zero, const Offset(topLength, 0), basePaint);
    canvas.drawLine(Offset.zero, const Offset(0, sideLength), basePaint);
    canvas.drawLine(
      Offset(size.width - topLength, size.height),
      Offset(size.width, size.height),
      basePaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - sideLength),
      Offset(size.width, size.height),
      basePaint,
    );

    final pulse = 0.48 + 0.52 * (1 - (progress * 2 - 1).abs());
    final activePaint = Paint()
      ..strokeWidth = 1
      ..color = lineColor.withValues(alpha: (hovered ? 0.86 : 0.62) * pulse);
    final topActive = topLength * (0.34 + progress * 0.42);
    final bottomActive = topLength * (0.76 - progress * 0.42);
    canvas.drawLine(Offset.zero, Offset(topActive, 0), activePaint);
    canvas.drawLine(
      Offset(size.width - bottomActive, size.height),
      Offset(size.width, size.height),
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldCardPerspectivePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.hovered != hovered;
  }
}
