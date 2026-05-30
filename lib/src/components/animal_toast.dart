import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import 'animal_message_surface.dart';
import 'animal_overlay_queue.dart';

class AnimalToast extends StatelessWidget {
  const AnimalToast({
    super.key,
    required this.message,
    this.type = AnimalMessageType.info,
    this.icon,
    this.onClose,
  });

  final Widget message;
  final AnimalMessageType type;
  final Widget? icon;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return AnimalMessageSurface(
      type: type,
      compact: true,
      leading: icon,
      onClose: onClose,
      child: message,
    );
  }
}

OverlayEntry showAnimalToast({
  required BuildContext context,
  required Widget message,
  AnimalMessageType type = AnimalMessageType.info,
  AnimalToastPosition position = AnimalToastPosition.top,
  Duration duration = const Duration(milliseconds: 2200),
  AnimalMessageDisplayMode displayMode = AnimalMessageDisplayMode.queue,
  Widget? icon,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  return _toastQueue.show(
    overlay: overlay,
    duration: duration,
    displayMode: displayMode,
    builder: (close) => OverlayEntry(
      builder: (context) => _AnimalToastOverlay(
        position: position,
        child: AnimalToast(
          message: message,
          type: type,
          icon: icon,
          onClose: close,
        ),
      ),
    ),
  );
}

final AnimalOverlayQueue _toastQueue = AnimalOverlayQueue();

class _AnimalToastOverlay extends StatelessWidget {
  const _AnimalToastOverlay({required this.position, required this.child});

  final AnimalToastPosition position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final alignment = switch (position) {
      AnimalToastPosition.top => Alignment.topCenter,
      AnimalToastPosition.center => Alignment.center,
      AnimalToastPosition.bottom => Alignment.bottomCenter,
    };
    final padding = switch (position) {
      AnimalToastPosition.top => const EdgeInsets.only(top: 48),
      AnimalToastPosition.center => EdgeInsets.zero,
      AnimalToastPosition.bottom => const EdgeInsets.only(bottom: 56),
    };
    return IgnorePointer(
      ignoring: false,
      child: SafeArea(
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: padding.add(const EdgeInsets.symmetric(horizontal: 18)),
            child: Material(
              type: MaterialType.transparency,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
