import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../utils/animal_island_assets.dart';
import 'animal_button.dart';
import 'animal_typewriter.dart';

Future<T?> showAnimalBottomSheet<T>({
  required BuildContext context,
  Widget? title,
  Widget? footer,
  double maxWidth = 560,
  double maxHeightRatio = 0.82,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  bool showHandle = false,
  bool showCloseButton = false,
  bool enableDrag = true,
  Widget? child,
  int typeSpeed = 60,
  bool typewriter = false,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.28),
    transitionDuration: const Duration(milliseconds: 280),
    useRootNavigator: useRootNavigator,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return SafeArea(
        top: false,
        child: AnimalBottomSheet(
          open: true,
          title: title,
          footer: footer,
          maxWidth: maxWidth,
          maxHeightRatio: maxHeightRatio,
          maskClosable: barrierDismissible,
          showHandle: showHandle,
          showCloseButton: showCloseButton,
          enableDrag: enableDrag,
          onClose: () => Navigator.of(dialogContext).maybePop(),
          typeSpeed: typeSpeed,
          typewriter: typewriter,
          child: child,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class AnimalBottomSheet extends StatelessWidget {
  const AnimalBottomSheet({
    super.key,
    required this.open,
    this.title,
    this.footer,
    this.maxWidth = 560,
    this.maxHeightRatio = 0.82,
    this.maskClosable = true,
    this.showHandle = true,
    this.showCloseButton = true,
    this.enableDrag = true,
    this.onClose,
    this.child,
    this.typeSpeed = 60,
    this.typewriter = false,
  });

  final bool open;
  final Widget? title;
  final Widget? footer;
  final double maxWidth;
  final double maxHeightRatio;
  final bool maskClosable;
  final bool showHandle;
  final bool showCloseButton;
  final bool enableDrag;
  final VoidCallback? onClose;
  final Widget? child;
  final int typeSpeed;
  final bool typewriter;

  @override
  Widget build(BuildContext context) {
    if (!open) {
      return const SizedBox.shrink();
    }

    final sheet = _AnimalBottomSheetPanel(
      title: title,
      footer: footer,
      maxWidth: maxWidth,
      maxHeightRatio: maxHeightRatio,
      showHandle: showHandle,
      showCloseButton: showCloseButton,
      enableDrag: enableDrag,
      onClose: onClose,
      typeSpeed: typeSpeed,
      typewriter: typewriter,
      child: child,
    );

    final route = ModalRoute.of(context);
    final isDialogRoute = route is PopupRoute<dynamic>;

    if (isDialogRoute) {
      return Material(
        type: MaterialType.transparency,
        child: Align(alignment: Alignment.bottomCenter, child: sheet),
      );
    }

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.28),
        child: GestureDetector(
          onTap: maskClosable ? onClose : null,
          behavior: HitTestBehavior.opaque,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.translucent,
              child: sheet,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimalBottomSheetPanel extends StatefulWidget {
  const _AnimalBottomSheetPanel({
    required this.title,
    required this.footer,
    required this.maxWidth,
    required this.maxHeightRatio,
    required this.showHandle,
    required this.showCloseButton,
    required this.enableDrag,
    required this.onClose,
    required this.child,
    required this.typeSpeed,
    required this.typewriter,
  });

  final Widget? title;
  final Widget? footer;
  final double maxWidth;
  final double maxHeightRatio;
  final bool showHandle;
  final bool showCloseButton;
  final bool enableDrag;
  final VoidCallback? onClose;
  final Widget? child;
  final int typeSpeed;
  final bool typewriter;

  @override
  State<_AnimalBottomSheetPanel> createState() =>
      _AnimalBottomSheetPanelState();
}

class _AnimalBottomSheetPanelState extends State<_AnimalBottomSheetPanel> {
  static const double _dismissOffset = 92;
  static const double _dismissVelocity = 920;

  double _dragOffset = 0;
  bool _isDragging = false;

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (!widget.enableDrag) {
      return;
    }

    final delta = details.primaryDelta ?? 0;
    final next = delta > 0
        ? _dragOffset + (delta * 0.78)
        : _dragOffset + (delta * 0.18);
    setState(() {
      _isDragging = true;
      _dragOffset = math.max(0, next);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (!widget.enableDrag) {
      return;
    }

    final velocity = details.primaryVelocity ?? 0;
    final shouldDismiss =
        _dragOffset >= _dismissOffset || velocity >= _dismissVelocity;

    if (shouldDismiss) {
      if (widget.onClose != null) {
        widget.onClose?.call();
      } else {
        setState(() {
          _isDragging = false;
          _dragOffset = 0;
        });
      }
      return;
    }

    setState(() {
      _isDragging = false;
      _dragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final size = MediaQuery.sizeOf(context);
    final horizontalInset = size.width < 480 ? 12.0 : 18.0;
    final bottomInset = math.max(12.0, MediaQuery.paddingOf(context).bottom);
    final headerVisible = widget.title != null || widget.showCloseButton;

    return AnimatedContainer(
      duration: _isDragging ? Duration.zero : const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, _dragOffset, 0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalInset,
          0,
          horizontalInset,
          bottomInset,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: math.min(
              size.width - horizontalInset * 2,
              widget.maxWidth,
            ),
            maxHeight: size.height * widget.maxHeightRatio,
          ),
          child: PhysicalShape(
            clipper: theme.isNes || theme.isWestworld
                ? const ShapeBorderClipper(shape: RoundedRectangleBorder())
                : const _AnimalBottomSheetClipper(),
            color: theme.isWestworld
                ? theme.panelLineColor(emphasized: true)
                : theme.borderLight,
            shadowColor: theme.buttonShadow.withValues(alpha: 0.34),
            elevation: theme.isNes || theme.isWestworld ? 0 : 12,
            child: Padding(
              padding: EdgeInsets.all(
                theme.isNes
                    ? theme.borderWidth
                    : theme.isWestworld
                    ? 1
                    : 2.5,
              ),
              child: ClipPath(
                clipper: theme.isNes || theme.isWestworld
                    ? const ShapeBorderClipper(shape: RoundedRectangleBorder())
                    : const _AnimalBottomSheetClipper(),
                child: DecoratedBox(
                  decoration: theme.isWestworld
                      ? theme.westworldPanelDecoration(emphasized: true)
                      : BoxDecoration(
                          color: theme.isNes ? theme.surfaceRaised : null,
                          gradient: theme.isNes
                              ? null
                              : LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    theme.surfaceRaised,
                                    theme.surface,
                                  ],
                                ),
                        ),
                  child: Stack(
                    children: [
                      if (theme.isWestworld)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _WestworldBottomSheetPainter(
                                line: theme.panelLineColor(),
                                glow: theme.primary.withValues(alpha: 0.08),
                              ),
                            ),
                          ),
                        ),
                      if (theme.spec.isOrganic)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AnimalIslandAssets.raster(
                                    AnimalIslandAssets.demoGuideLine,
                                  ),
                                  fit: BoxFit.cover,
                                  opacity:
                                      theme.mode == AnimalIslandThemeMode.day
                                      ? 0.06
                                      : 0.04,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (theme.spec.isOrganic)
                        Positioned(
                          left: 18,
                          top: 22,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      if (theme.spec.isOrganic)
                        Positioned(
                          right: 24,
                          top: 18,
                          child: Image.asset(
                            AnimalIslandAssets.iconLeaf,
                            package: AnimalIslandAssets.package,
                            width: 20,
                            height: 20,
                            opacity: const AlwaysStoppedAnimation<double>(0.18),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          theme.isNes
                              ? 18
                              : theme.isWestworld
                              ? 22
                              : 24,
                          theme.isNes
                              ? 14
                              : theme.isWestworld
                              ? 16
                              : 18,
                          theme.isNes
                              ? 18
                              : theme.isWestworld
                              ? 22
                              : 24,
                          theme.isNes
                              ? 18
                              : theme.isWestworld
                              ? 20
                              : 22,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.showHandle || headerVisible)
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onVerticalDragUpdate: _handleVerticalDragUpdate,
                                onVerticalDragEnd: _handleVerticalDragEnd,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.showHandle) ...[
                                        Center(
                                          child: _AnimalBottomSheetHandle(
                                            theme: theme,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                      if (headerVisible)
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: widget.title == null
                                                  ? const SizedBox.shrink()
                                                  : DefaultTextStyle(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontSize:
                                                                theme.isNes
                                                                ? AnimalIslandTokens
                                                                      .fontBody
                                                                : theme
                                                                      .isWestworld
                                                                ? AnimalIslandTokens
                                                                      .fontHeadlineSm
                                                                : AnimalIslandTokens
                                                                      .fontTitle,
                                                            color: theme
                                                                .textPrimary,
                                                            letterSpacing:
                                                                theme
                                                                    .isWestworld
                                                                ? 1.2
                                                                : null,
                                                          ),
                                                      child: widget.title!,
                                                    ),
                                            ),
                                            if (widget.showCloseButton)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 12,
                                                ),
                                                child:
                                                    _AnimalBottomSheetCloseButton(
                                                      onTap: widget.onClose,
                                                    ),
                                              ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            Flexible(
                              child: SingleChildScrollView(
                                child: DefaultTextStyle(
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(
                                        fontSize: theme.isNes
                                            ? AnimalIslandTokens.fontBodySm
                                            : theme.isWestworld
                                            ? AnimalIslandTokens.fontBody
                                            : AnimalIslandTokens.fontBodyLg,
                                        color: theme.textBody,
                                        height: theme.isNes
                                            ? 1.8
                                            : theme.isWestworld
                                            ? 1.36
                                            : 1.55,
                                        fontWeight: theme.isWestworld
                                            ? FontWeight.w400
                                            : FontWeight.w600,
                                      ),
                                  child: _AnimalBottomSheetBody(
                                    typeSpeed: widget.typeSpeed,
                                    typewriter: widget.typewriter,
                                    child: widget.child,
                                  ),
                                ),
                              ),
                            ),
                            if (widget.footer != null) ...[
                              const SizedBox(height: 18),
                              widget.footer!,
                            ],
                          ],
                        ),
                      ),
                    ],
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

class _AnimalBottomSheetHandle extends StatelessWidget {
  const _AnimalBottomSheetHandle({required this.theme});

  final AnimalIslandThemeData theme;

  @override
  Widget build(BuildContext context) {
    if (theme.isWestworld) {
      return Container(
        width: 84,
        height: 10,
        alignment: Alignment.center,
        child: CustomPaint(
          size: const Size(84, 10),
          painter: _WestworldHandlePainter(
            color: theme.panelLineColor(emphasized: true),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 8,
          decoration: BoxDecoration(
            color: theme.surfaceSoft,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(10),
            ),
            border: Border.all(
              color: theme.border.withValues(alpha: 0.36),
              width: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 6),
        if (!theme.isWestworld)
          Image.asset(
            AnimalIslandAssets.iconLeaf,
            package: AnimalIslandAssets.package,
            width: 16,
            height: 16,
            opacity: const AlwaysStoppedAnimation<double>(0.84),
          ),
      ],
    );
  }
}

class _AnimalBottomSheetCloseButton extends StatelessWidget {
  const _AnimalBottomSheetCloseButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 28,
        decoration: BoxDecoration(
          color: theme.surfaceSoft,
          borderRadius: theme.isNes || theme.isWestworld
              ? BorderRadius.circular(theme.radiusSm)
              : const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(18),
                ),
          border: Border.all(
            color: theme.borderLight,
            width: theme.borderWidth,
          ),
          boxShadow: theme.isWestworld
              ? null
              : [
                  BoxShadow(
                    color: theme.inputShadow.withValues(alpha: 0.6),
                    blurRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (theme.spec.isOrganic)
              Positioned(
                left: 7,
                top: 7,
                child: Image.asset(
                  AnimalIslandAssets.iconLeaf,
                  package: AnimalIslandAssets.package,
                  width: 10,
                  height: 10,
                  opacity: const AlwaysStoppedAnimation<double>(0.62),
                ),
              ),
            Text(
              '×',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: theme.textPrimary,
                fontSize: AnimalIslandTokens.fontBodySm,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WestworldBottomSheetPainter extends CustomPainter {
  const _WestworldBottomSheetPainter({required this.line, required this.glow});

  final Color line;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.isFinite) {
      return;
    }

    final gridPaint = Paint()
      ..color = glow
      ..strokeWidth = 1;
    for (double x = 24; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final linePaint = Paint()
      ..color = line
      ..strokeWidth = 1;
    canvas.drawLine(const Offset(0, 18), const Offset(72, 18), linePaint);
    canvas.drawLine(
      Offset(size.width - 72, size.height - 18),
      Offset(size.width, size.height - 18),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WestworldBottomSheetPainter oldDelegate) {
    return oldDelegate.line != line || oldDelegate.glow != glow;
  }
}

class _WestworldHandlePainter extends CustomPainter {
  const _WestworldHandlePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    canvas.drawLine(Offset(18, y - 4), Offset(size.width - 18, y - 4), paint);
    canvas.drawLine(Offset(18, y + 4), Offset(size.width - 18, y + 4), paint);
  }

  @override
  bool shouldRepaint(covariant _WestworldHandlePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _AnimalBottomSheetClipper extends CustomClipper<Path> {
  const _AnimalBottomSheetClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.03, size.height * 0.18);
    path.cubicTo(
      size.width * 0.045,
      size.height * 0.055,
      size.width * 0.12,
      size.height * 0.02,
      size.width * 0.23,
      size.height * 0.055,
    );
    path.cubicTo(
      size.width * 0.31,
      size.height * 0.082,
      size.width * 0.39,
      size.height * 0.015,
      size.width * 0.49,
      size.height * 0.025,
    );
    path.cubicTo(
      size.width * 0.6,
      size.height * 0.035,
      size.width * 0.66,
      0,
      size.width * 0.77,
      size.height * 0.042,
    );
    path.cubicTo(
      size.width * 0.88,
      size.height * 0.083,
      size.width * 0.96,
      size.height * 0.045,
      size.width * 0.982,
      size.height * 0.16,
    );
    path.cubicTo(
      size.width * 1.006,
      size.height * 0.28,
      size.width * 0.992,
      size.height * 0.39,
      size.width * 0.985,
      size.height * 0.55,
    );
    path.cubicTo(
      size.width * 0.978,
      size.height * 0.67,
      size.width * 0.995,
      size.height * 0.78,
      size.width * 0.974,
      size.height * 0.89,
    );
    path.cubicTo(
      size.width * 0.958,
      size.height * 0.956,
      size.width * 0.915,
      size.height * 0.985,
      size.width * 0.842,
      size.height * 0.992,
    );
    path.cubicTo(
      size.width * 0.75,
      size.height * 1.0,
      size.width * 0.645,
      size.height * 0.988,
      size.width * 0.505,
      size.height * 0.988,
    );
    path.cubicTo(
      size.width * 0.36,
      size.height * 0.988,
      size.width * 0.255,
      size.height * 1.0,
      size.width * 0.162,
      size.height * 0.992,
    );
    path.cubicTo(
      size.width * 0.09,
      size.height * 0.985,
      size.width * 0.045,
      size.height * 0.956,
      size.width * 0.029,
      size.height * 0.89,
    );
    path.cubicTo(
      size.width * 0.008,
      size.height * 0.79,
      size.width * 0.028,
      size.height * 0.68,
      size.width * 0.018,
      size.height * 0.555,
    );
    path.cubicTo(
      size.width * 0.007,
      size.height * 0.405,
      size.width * -0.006,
      size.height * 0.29,
      size.width * 0.03,
      size.height * 0.18,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _AnimalBottomSheetBody extends StatelessWidget {
  const _AnimalBottomSheetBody({
    required this.child,
    required this.typeSpeed,
    required this.typewriter,
  });

  final Widget? child;
  final int typeSpeed;
  final bool typewriter;

  @override
  Widget build(BuildContext context) {
    if (!typewriter || child == null) {
      return child ?? const SizedBox.shrink();
    }

    if (child case Text(:final data?, :final textAlign, :final style)) {
      final mergedStyle = DefaultTextStyle.of(
        context,
      ).style.merge(style ?? const TextStyle());
      return AnimalTypewriter(
        text: data,
        speed: typeSpeed,
        textAlign: textAlign ?? TextAlign.start,
        style: mergedStyle,
      );
    }

    if (child case SelectableText(
      :final data?,
      :final textAlign,
      :final style,
    )) {
      final mergedStyle = DefaultTextStyle.of(
        context,
      ).style.merge(style ?? const TextStyle());
      return AnimalTypewriter(
        text: data,
        speed: typeSpeed,
        textAlign: textAlign ?? TextAlign.start,
        style: mergedStyle,
      );
    }

    return child!;
  }
}

class AnimalBottomSheetActionBar extends StatelessWidget {
  const AnimalBottomSheetActionBar({
    super.key,
    this.primaryLabel = '确认',
    this.secondaryLabel = '取消',
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.primaryDanger = false,
  });

  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool primaryDanger;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnimalButton(
            type: AnimalButtonType.defaultType,
            block: true,
            onPressed: onSecondaryPressed,
            child: Text(secondaryLabel),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnimalButton(
            type: AnimalButtonType.primary,
            danger: primaryDanger,
            block: true,
            onPressed: onPrimaryPressed,
            child: Text(primaryLabel),
          ),
        ),
      ],
    );
  }
}
