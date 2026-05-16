import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';
import '../models/animal_island_models.dart';
import 'animal_button.dart';
import 'animal_typewriter.dart';

const Object _defaultModalFooterMarker = Object();

Future<T?> showAnimalDialog<T>({
  required BuildContext context,
  Widget? title,
  double width = 520,
  bool barrierDismissible = true,
  Object? footer = _defaultModalFooterMarker,
  Widget? child,
  int typeSpeed = 80,
  bool typewriter = true,
  bool useRootNavigator = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 250),
    useRootNavigator: useRootNavigator,
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return SafeArea(
        child: Center(
          child: AnimalModal(
            open: true,
            title: title,
            width: width,
            maskClosable: barrierDismissible,
            footer: footer,
            onClose: () => Navigator.of(dialogContext).maybePop(),
            onOk: () => Navigator.of(dialogContext).maybePop(),
            typeSpeed: typeSpeed,
            typewriter: typewriter,
            child: child,
          ),
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
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class AnimalModal extends StatelessWidget {
  const AnimalModal({
    super.key,
    required this.open,
    this.title,
    this.width = 520,
    this.maskClosable = true,
    this.footer = _defaultModalFooterMarker,
    this.onClose,
    this.onOk,
    this.child,
    this.typeSpeed = 80,
    this.typewriter = true,
  });

  final bool open;
  final Widget? title;
  final double width;
  final bool maskClosable;
  final Object? footer;
  final VoidCallback? onClose;
  final VoidCallback? onOk;
  final Widget? child;
  final int typeSpeed;
  final bool typewriter;

  @override
  Widget build(BuildContext context) {
    if (!open) {
      return const SizedBox.shrink();
    }

    final modal = _AnimalModalPanel(
      title: title,
      width: width,
      footer: footer,
      onClose: onClose,
      onOk: onOk,
      typeSpeed: typeSpeed,
      typewriter: typewriter,
      child: child,
    );

    final route = ModalRoute.of(context);
    final isDialogRoute = route is PopupRoute<dynamic>;

    if (isDialogRoute) {
      return Material(type: MaterialType.transparency, child: modal);
    }

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        child: GestureDetector(
          onTap: maskClosable ? onClose : null,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.translucent,
              child: modal,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimalModalPanel extends StatelessWidget {
  const _AnimalModalPanel({
    required this.title,
    required this.width,
    required this.footer,
    required this.onClose,
    required this.onOk,
    required this.child,
    required this.typeSpeed,
    required this.typewriter,
  });

  final Widget? title;
  final double width;
  final Object? footer;
  final VoidCallback? onClose;
  final VoidCallback? onOk;
  final Widget? child;
  final int typeSpeed;
  final bool typewriter;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final useDefaultFooter = identical(footer, _defaultModalFooterMarker);
    final showFooter = useDefaultFooter || footer != null;
    final customFooter = footer is Widget ? footer as Widget : null;
    final dialogButtonStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: AnimalIslandTokens.fontBody,
      fontWeight: FontWeight.w600,
      color: theme.textBody,
      height: 1,
    );
    final defaultFooter = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimalButton(
          type: AnimalButtonType.defaultType,
          size: AnimalButtonSize.middle,
          onPressed: onClose,
          child: Text('取消', style: dialogButtonStyle),
        ),
        const SizedBox(width: 12),
        AnimalButton(
          type: AnimalButtonType.primary,
          size: AnimalButtonSize.middle,
          onPressed: onOk,
          child: Text('确定', style: dialogButtonStyle),
        ),
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: math.min(MediaQuery.sizeOf(context).width - 32, width),
        maxHeight: MediaQuery.sizeOf(context).height - 64,
      ),
      child: ClipPath(
        clipper: _AnimalModalClipper(),
        child: DecoratedBox(
          decoration: BoxDecoration(color: theme.surfaceRaised),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 36, 36, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: theme.textBody,
                      fontSize: AnimalIslandTokens.fontHeadlineSm,
                    ),
                    child: title!,
                  ),
                  const SizedBox(height: 15),
                ],
                Flexible(
                  child: SingleChildScrollView(
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: theme.textMuted,
                        fontSize: AnimalIslandTokens.fontBodyLg,
                        fontWeight: FontWeight.w600,
                        height: 1.55,
                      ),
                      child: _AnimalModalBody(
                        typeSpeed: typeSpeed,
                        typewriter: typewriter,
                        child: child,
                      ),
                    ),
                  ),
                ),
                if (showFooter) ...[
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: useDefaultFooter ? defaultFooter : customFooter,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimalModalBody extends StatelessWidget {
  const _AnimalModalBody({
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
    if (child is Text) {
      final text = child as Text;
      return AnimalTypewriter(
        text: text.data ?? text.textSpan?.toPlainText() ?? '',
        style: text.style,
        speed: typeSpeed,
      );
    }
    if (child is RichText) {
      final richText = child as RichText;
      return AnimalTypewriter.rich(
        span: richText.text,
        style: richText.text.style,
        speed: typeSpeed,
      );
    }
    return child!;
  }
}

class _AnimalModalClipper extends CustomClipper<Path> {
  static final Path _path = parseSvgPathData(
    'M0.501,0.005 L0.501,0.005 L0.523,0.005 L0.549,0.006 '
    'C0.704,0.01,0.796,0.017,0.825,0.027 '
    'L0.827,0.028 '
    'C0.872,0.045,0.939,0.044,0.978,0.17 '
    'C1,0.254,1,0.365,0.99,0.505 '
    'L0.988,0.513 '
    'C0.979,0.558,0.971,0.598,0.965,0.633 '
    'C0.956,0.689,0.979,0.77,0.964,0.865 '
    'C0.953,0.928,0.921,0.966,0.869,0.979 '
    'C0.821,0.986,0.773,0.992,0.726,0.995 '
    'L0.712,0.996 L0.694,0.997 '
    'C0.648,1,0.586,1,0.507,1 '
    'L0.501,1 L0.464,1 '
    'C0.385,1,0.325,0.998,0.283,0.995 '
    'C0.234,0.992,0.184,0.987,0.133,0.979 '
    'C0.081,0.966,0.05,0.928,0.039,0.865 '
    'C0.023,0.77,0.047,0.689,0.037,0.633 '
    'C0.031,0.595,0.023,0.552,0.013,0.505 '
    'C-0.006,0.365,-0.002,0.254,0.024,0.17 '
    'C0.064,0.045,0.13,0.045,0.174,0.028 '
    'L0.175,0.028 '
    'C0.204,0.017,0.303,0.009,0.474,0.005 '
    'L0.501,0.005 Z',
  );

  @override
  Path getClip(Size size) {
    final matrix = Matrix4.diagonal3Values(size.width, size.height, 1);
    return _path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
