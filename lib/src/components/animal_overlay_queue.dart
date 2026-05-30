import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../models/animal_island_models.dart';

typedef AnimalOverlayEntryBuilder = OverlayEntry Function(VoidCallback close);

class AnimalOverlayQueue {
  AnimalOverlayQueue();

  final Queue<_AnimalOverlayItem> _pending = Queue<_AnimalOverlayItem>();
  _AnimalOverlayItem? _active;

  OverlayEntry show({
    required OverlayState overlay,
    required AnimalOverlayEntryBuilder builder,
    required Duration duration,
    required AnimalMessageDisplayMode displayMode,
  }) {
    _clearStaleOverlay(overlay);

    late final _AnimalOverlayItem item;
    item = _AnimalOverlayItem(
      overlay: overlay,
      duration: duration,
      entry: builder(() => _close(item)),
    );
    item.entry.addListener(() {
      if (!item.closed && !item.entry.mounted && identical(_active, item)) {
        item.timer?.cancel();
        _active = null;
        _showNext();
      }
    });

    switch (displayMode) {
      case AnimalMessageDisplayMode.queue:
        if (_active == null) {
          _show(item);
        } else {
          _pending.addLast(item);
        }
      case AnimalMessageDisplayMode.replace:
        _clearAll();
        _show(item);
    }

    return item.entry;
  }

  void _show(_AnimalOverlayItem item) {
    _active = item;
    item.overlay.insert(item.entry);
    item.inserted = true;
    if (item.duration > Duration.zero) {
      item.timer = Timer(item.duration, () => _close(item));
    }
  }

  void _close(_AnimalOverlayItem item) {
    if (item.closed) {
      return;
    }

    item.closed = true;
    item.timer?.cancel();
    _removeEntry(item);

    if (identical(_active, item)) {
      _active = null;
      _showNext();
    } else {
      _pending.remove(item);
    }
  }

  void _showNext() {
    while (_pending.isNotEmpty) {
      final item = _pending.removeFirst();
      if (!item.closed) {
        _show(item);
        return;
      }
    }
  }

  void _clearAll() {
    if (_active case final item?) {
      _removeSilently(item);
      _active = null;
    }
    while (_pending.isNotEmpty) {
      _removeSilently(_pending.removeFirst());
    }
  }

  void _removeSilently(_AnimalOverlayItem item) {
    item.closed = true;
    item.timer?.cancel();
    _removeEntry(item);
  }

  void _removeEntry(_AnimalOverlayItem item) {
    if (!item.inserted || item.removed) {
      return;
    }
    item.removed = true;
    item.entry.remove();
  }

  void _clearStaleOverlay(OverlayState overlay) {
    final item = _active;
    if (item == null || identical(item.overlay, overlay)) {
      return;
    }
    _clearAll();
  }
}

class _AnimalOverlayItem {
  _AnimalOverlayItem({
    required this.overlay,
    required this.entry,
    required this.duration,
  });

  final OverlayState overlay;
  final OverlayEntry entry;
  final Duration duration;

  Timer? timer;
  bool closed = false;
  bool inserted = false;
  bool removed = false;
}
