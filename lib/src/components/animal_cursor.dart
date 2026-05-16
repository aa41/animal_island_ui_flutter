import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/animal_island_assets.dart';

class AnimalCursor extends StatefulWidget {
  const AnimalCursor({super.key, required this.child});

  final Widget child;

  @override
  State<AnimalCursor> createState() => _AnimalCursorState();
}

class _AnimalCursorState extends State<AnimalCursor> {
  Offset? _position;
  bool _visible = false;

  bool get _supportsMouse => kIsWeb;

  @override
  Widget build(BuildContext context) {
    if (!_supportsMouse) {
      return widget.child;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _visible = true),
      onExit: (_) => setState(() {
        _visible = false;
        _position = null;
      }),
      onHover: (event) => setState(() => _position = event.localPosition),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_visible && _position != null)
            Positioned(
              left: _position!.dx - 4,
              top: _position!.dy,
              child: IgnorePointer(
                child: Image.asset(
                  AnimalIslandAssets.cursorHand,
                  package: AnimalIslandAssets.package,
                  width: 22,
                  height: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
