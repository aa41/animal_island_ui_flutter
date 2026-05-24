import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import 'animal_button.dart';
import 'animal_typewriter.dart';
import 'theme_strategies/animal_bottom_sheet_shared.dart';
import 'theme_strategies/animal_bottom_sheet_theme_strategy.dart';

Future<T?> showAnimalBottomSheet<T>({
  required BuildContext context,
  Widget? title,
  Widget? footer,
  double maxWidth = 560,
  double? maxHeightRatio,
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
    this.maxHeightRatio,
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
  final double? maxHeightRatio;
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
    final theme = context.animalIslandTheme;
    final strategy = AnimalBottomSheetThemeStrategy.of(theme);

    final sheet = _AnimalBottomSheetPanel(
      theme: theme,
      strategy: strategy,
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
    required this.theme,
    required this.strategy,
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

  final AnimalIslandThemeData theme;
  final AnimalBottomSheetThemeStrategy strategy;
  final Widget? title;
  final Widget? footer;
  final double maxWidth;
  final double? maxHeightRatio;
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
    final size = MediaQuery.sizeOf(context);
    final theme = widget.theme;
    final strategy = widget.strategy;
    final horizontalInset = size.width < 480 ? 12.0 : 18.0;
    final bottomInset = math.max(12.0, MediaQuery.paddingOf(context).bottom);
    final headerVisible = widget.title != null || widget.showCloseButton;
    final maxHeightRatio = math.min(
      widget.maxHeightRatio ?? strategy.maxHeightRatio(theme),
      0.94,
    );
    final outerClipper = strategy.clipRadius(theme) == null
        ? const AnimalBottomSheetClipper()
        : ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: strategy.clipRadius(theme)!,
            ),
          );
    final panelClipper = strategy.panelClipper(theme);
    final body = DefaultTextStyle(
      style: strategy.bodyStyle(context, theme),
      child: _AnimalBottomSheetBody(
        typeSpeed: widget.typeSpeed,
        typewriter: widget.typewriter,
        child: widget.child,
      ),
    );
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
            maxHeight: size.height * maxHeightRatio,
          ),
          child: PhysicalShape(
            clipper: outerClipper,
            color: strategy.outerColor(theme),
            shadowColor: theme.buttonShadow.withValues(alpha: 0.34),
            elevation: strategy.elevation(theme),
            child: Padding(
              padding: EdgeInsets.all(strategy.framePadding(theme)),
              child: panelClipper == null
                  ? _AnimalBottomSheetPanelSurface(
                      decoration: strategy.panelDecoration(theme),
                      contentPadding: strategy.contentPadding(theme),
                      strategy: strategy,
                      theme: theme,
                      headerVisible: headerVisible,
                      showHandle: widget.showHandle,
                      showCloseButton: widget.showCloseButton,
                      onVerticalDragUpdate: _handleVerticalDragUpdate,
                      onVerticalDragEnd: _handleVerticalDragEnd,
                      title: widget.title,
                      onClose: widget.onClose,
                      bodyScrolls: strategy.bodyScrolls(theme),
                      body: body,
                      footer: widget.footer,
                    )
                  : ClipPath(
                      clipper: panelClipper,
                      child: _AnimalBottomSheetPanelSurface(
                        decoration: strategy.panelDecoration(theme),
                        contentPadding: strategy.contentPadding(theme),
                        strategy: strategy,
                        theme: theme,
                        headerVisible: headerVisible,
                        showHandle: widget.showHandle,
                        showCloseButton: widget.showCloseButton,
                        onVerticalDragUpdate: _handleVerticalDragUpdate,
                        onVerticalDragEnd: _handleVerticalDragEnd,
                        title: widget.title,
                        onClose: widget.onClose,
                        bodyScrolls: strategy.bodyScrolls(theme),
                        body: body,
                        footer: widget.footer,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimalBottomSheetPanelSurface extends StatelessWidget {
  const _AnimalBottomSheetPanelSurface({
    required this.decoration,
    required this.contentPadding,
    required this.strategy,
    required this.theme,
    required this.headerVisible,
    required this.showHandle,
    required this.showCloseButton,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    required this.title,
    required this.onClose,
    required this.bodyScrolls,
    required this.body,
    required this.footer,
  });

  final BoxDecoration decoration;
  final EdgeInsets contentPadding;
  final AnimalBottomSheetThemeStrategy strategy;
  final AnimalIslandThemeData theme;
  final bool headerVisible;
  final bool showHandle;
  final bool showCloseButton;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget? title;
  final VoidCallback? onClose;
  final bool bodyScrolls;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: contentPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHandle || headerVisible)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: onVerticalDragUpdate,
                onVerticalDragEnd: onVerticalDragEnd,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showHandle) ...[
                        Center(child: strategy.buildHandle(theme)),
                        const SizedBox(height: 12),
                      ],
                      if (headerVisible)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: title == null
                                  ? const SizedBox.shrink()
                                  : DefaultTextStyle(
                                      style: strategy.titleStyle(
                                        context,
                                        theme,
                                      ),
                                      child: title!,
                                    ),
                            ),
                            if (showCloseButton)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: strategy.buildCloseButton(
                                  context,
                                  theme,
                                  onTap: onClose,
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            if (bodyScrolls)
              Flexible(
                fit: FlexFit.loose,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: [body],
                ),
              )
            else
              body,
            if (footer != null) ...[const SizedBox(height: 18), footer!],
          ],
        ),
      ),
    );
  }
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
