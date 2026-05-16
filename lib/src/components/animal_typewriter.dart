import 'dart:async';

import 'package:flutter/material.dart';

class AnimalTypewriter extends StatefulWidget {
  const AnimalTypewriter({
    super.key,
    required this.text,
    this.style,
    this.speed = 90,
    this.trigger,
    this.autoPlay = true,
    this.onDone,
    this.textAlign,
  }) : span = null;

  const AnimalTypewriter.rich({
    super.key,
    required this.span,
    this.style,
    this.speed = 90,
    this.trigger,
    this.autoPlay = true,
    this.onDone,
    this.textAlign,
  }) : text = null;

  final String? text;
  final InlineSpan? span;
  final TextStyle? style;
  final int speed;
  final Object? trigger;
  final bool autoPlay;
  final VoidCallback? onDone;
  final TextAlign? textAlign;

  @override
  State<AnimalTypewriter> createState() => _AnimalTypewriterState();
}

class _AnimalTypewriterState extends State<AnimalTypewriter> {
  Timer? _timer;
  int _visible = 0;

  InlineSpan get _fullSpan => widget.span ?? TextSpan(text: widget.text ?? '');

  int get _total => _fullSpan.toPlainText().characters.length;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void didUpdateWidget(covariant AnimalTypewriter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger ||
        widget.text != oldWidget.text ||
        widget.span != oldWidget.span ||
        widget.autoPlay != oldWidget.autoPlay ||
        widget.speed != oldWidget.speed) {
      _restart();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restart() {
    _timer?.cancel();
    if (!widget.autoPlay) {
      setState(() => _visible = _total);
      return;
    }
    setState(() => _visible = 0);
    if (_total == 0) {
      return;
    }
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_visible >= _total) {
        timer.cancel();
        widget.onDone?.call();
        return;
      }
      setState(() => _visible += 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _visible;
    final visibleSpan = _truncateSpan(_fullSpan, remaining);
    return Text.rich(
      visibleSpan,
      textAlign: widget.textAlign,
      style: widget.style,
    );
  }

  InlineSpan _truncateSpan(InlineSpan span, int remaining) {
    var counter = remaining;
    return _truncateInline(span, () => counter);
  }

  InlineSpan _truncateInline(InlineSpan span, int Function() getRemaining) {
    if (span is TextSpan) {
      var remaining = getRemaining();
      final text = span.text ?? '';
      String? shown;
      if (text.isNotEmpty) {
        final characters = text.characters.toList();
        if (remaining <= 0) {
          shown = '';
        } else if (characters.length <= remaining) {
          shown = text;
          remaining -= characters.length;
        } else {
          shown = characters.take(remaining).join();
          remaining = 0;
        }
      }

      InlineSpan? childrenBuilder() {
        if (span.children == null || span.children!.isEmpty) {
          return shown == null
              ? null
              : TextSpan(text: shown, style: span.style);
        }

        final builtChildren = <InlineSpan>[];
        var localRemaining = remaining;
        for (final child in span.children!) {
          if (localRemaining <= 0) {
            break;
          }
          final truncated = _truncateInline(child, () => localRemaining);
          localRemaining -= truncated.toPlainText().characters.length;
          builtChildren.add(truncated);
        }
        return TextSpan(
          text: shown,
          style: span.style,
          children: builtChildren,
          recognizer: span.recognizer,
        );
      }

      return childrenBuilder() ?? const TextSpan(text: '');
    }

    if (span is WidgetSpan) {
      if (getRemaining() <= 0) {
        return const TextSpan(text: '');
      }
      return span;
    }

    return const TextSpan(text: '');
  }
}
