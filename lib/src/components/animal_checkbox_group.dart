import 'package:flutter/material.dart';

import '../models/animal_island_models.dart';
import '../theme/animal_island_theme.dart';
import '../theme/animal_island_tokens.dart';

class AnimalCheckboxGroup<T> extends StatefulWidget {
  const AnimalCheckboxGroup({
    super.key,
    required this.options,
    this.values,
    this.defaultValues = const [],
    this.size = AnimalCheckboxSize.middle,
    this.enabled = true,
    this.direction = AnimalCheckboxDirection.horizontal,
    this.onChanged,
    this.gap,
  });

  final List<AnimalCheckboxOption<T>> options;
  final List<T>? values;
  final List<T> defaultValues;
  final AnimalCheckboxSize size;
  final bool enabled;
  final AnimalCheckboxDirection direction;
  final ValueChanged<List<T>>? onChanged;
  final double? gap;

  @override
  State<AnimalCheckboxGroup<T>> createState() => _AnimalCheckboxGroupState<T>();
}

class _AnimalCheckboxGroupState<T> extends State<AnimalCheckboxGroup<T>> {
  late List<T> _values = List<T>.from(widget.values ?? widget.defaultValues);

  @override
  void didUpdateWidget(covariant AnimalCheckboxGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != null && widget.values != oldWidget.values) {
      _values = List<T>.from(widget.values!);
    }
  }

  void _toggle(AnimalCheckboxOption<T> option) {
    if (!widget.enabled || option.disabled) {
      return;
    }

    final next = List<T>.from(widget.values ?? _values);
    if (next.contains(option.value)) {
      next.remove(option.value);
    } else {
      next.add(option.value);
    }

    if (widget.values == null) {
      setState(() => _values = next);
    }
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final spacing =
        widget.gap ??
        (widget.direction == AnimalCheckboxDirection.vertical ? 8.0 : 12.0);

    if (widget.direction == AnimalCheckboxDirection.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < widget.options.length; i++) ...[
            _CheckboxTile<T>(
              option: widget.options[i],
              checked: (widget.values ?? _values).contains(
                widget.options[i].value,
              ),
              size: widget.size,
              enabled: widget.enabled,
              onTap: () => _toggle(widget.options[i]),
            ),
            if (i < widget.options.length - 1) SizedBox(height: spacing),
          ],
        ],
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: widget.options
          .map(
            (option) => _CheckboxTile<T>(
              option: option,
              checked: (widget.values ?? _values).contains(option.value),
              size: widget.size,
              enabled: widget.enabled,
              onTap: () => _toggle(option),
            ),
          )
          .toList(),
    );
  }
}

class _CheckboxTile<T> extends StatefulWidget {
  const _CheckboxTile({
    required this.option,
    required this.checked,
    required this.size,
    required this.enabled,
    required this.onTap,
  });

  final AnimalCheckboxOption<T> option;
  final bool checked;
  final AnimalCheckboxSize size;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_CheckboxTile<T>> createState() => _CheckboxTileState<T>();
}

class _CheckboxTileState<T> extends State<_CheckboxTile<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.animalIslandTheme;
    final disabled = !widget.enabled || widget.option.disabled;
    final metrics = switch (widget.size) {
      AnimalCheckboxSize.small => (18.0, AnimalIslandTokens.fontCaption),
      AnimalCheckboxSize.middle => (22.0, AnimalIslandTokens.fontLabel),
      AnimalCheckboxSize.large => (28.0, AnimalIslandTokens.fontBody),
    };

    final box = metrics.$1;
    final fontSize = metrics.$2;

    return MouseRegion(
      onEnter: disabled ? null : (_) => setState(() => _hovered = true),
      onExit: disabled ? null : (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        child: Opacity(
          opacity: disabled ? 0.55 : 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AnimalIslandTokens.base,
                width: box,
                height: box,
                decoration: BoxDecoration(
                  color: widget.checked
                      ? (_hovered ? theme.primaryHover : theme.primary)
                      : (disabled ? theme.surfaceMuted : theme.surfaceRaised),
                  borderRadius: BorderRadius.circular(
                    widget.size == AnimalCheckboxSize.large ? 12 : 8,
                  ),
                  border: Border.all(
                    color: widget.checked
                        ? (_hovered ? theme.primary : theme.primaryActive)
                        : (_hovered ? theme.primary : theme.borderLight),
                    width: 2.5,
                  ),
                ),
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  opacity: widget.checked ? 1 : 0,
                  duration: AnimalIslandTokens.fast,
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: box * 0.72,
                  ),
                ),
              ),
              const SizedBox(width: AnimalIslandTokens.spacingSm),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: fontSize,
                  color: disabled
                      ? theme.textDisabled
                      : (_hovered ? theme.textPrimary : theme.textBody),
                  fontWeight: FontWeight.w500,
                ),
                child: widget.option.label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
