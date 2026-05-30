import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import 'animal_message_surface.dart';
import 'animal_overlay_queue.dart';

class AnimalSnackbar extends StatelessWidget {
  const AnimalSnackbar({
    super.key,
    required this.message,
    this.title,
    this.type = AnimalMessageType.info,
    this.action,
    this.icon,
    this.onClose,
  });

  final Widget message;
  final Widget? title;
  final AnimalMessageType type;
  final Widget? action;
  final Widget? icon;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return AnimalMessageSurface(
      type: type,
      title: title,
      action: action,
      leading: icon,
      onClose: onClose,
      snackbar: true,
      child: message,
    );
  }
}

OverlayEntry showAnimalSnackbar({
  required BuildContext context,
  required Widget message,
  Widget? title,
  AnimalMessageType type = AnimalMessageType.info,
  AnimalSnackbarPosition position = AnimalSnackbarPosition.bottom,
  Duration duration = const Duration(seconds: 4),
  AnimalMessageDisplayMode displayMode = AnimalMessageDisplayMode.queue,
  Widget? action,
  Widget? icon,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  return _snackbarQueue.show(
    overlay: overlay,
    duration: duration,
    displayMode: displayMode,
    builder: (close) => OverlayEntry(
      builder: (context) => _AnimalSnackbarOverlay(
        position: position,
        child: AnimalSnackbar(
          message: message,
          title: title,
          type: type,
          action: action,
          icon: icon,
          onClose: close,
        ),
      ),
    ),
  );
}

final AnimalOverlayQueue _snackbarQueue = AnimalOverlayQueue();

class _AnimalSnackbarOverlay extends StatelessWidget {
  const _AnimalSnackbarOverlay({required this.position, required this.child});

  final AnimalSnackbarPosition position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final alignment = switch (position) {
      AnimalSnackbarPosition.top => Alignment.topCenter,
      AnimalSnackbarPosition.bottom => Alignment.bottomCenter,
    };
    final padding = switch (position) {
      AnimalSnackbarPosition.top => const EdgeInsets.only(top: 18),
      AnimalSnackbarPosition.bottom => const EdgeInsets.only(bottom: 18),
    };
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: padding.add(const EdgeInsets.symmetric(horizontal: 16)),
          child: Material(
            type: MaterialType.transparency,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560, minWidth: 260),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
